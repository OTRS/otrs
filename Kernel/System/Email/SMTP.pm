# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Email::SMTP;

use strict;
use warnings;

use Net::SMTP;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::CommunicationLog',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug
    $Self->{Debug} = $Param{Debug} || 0;
    if ( $Self->{Debug} > 2 ) {

        # shown on STDERR
        $Self->{SMTPDebug} = 1;
    }

    ( $Self->{SMTPType} ) = ( $Type =~ m/::Email::(.*)$/i );

    return $Self;
}

sub Check {
    my ( $Self, %Param ) = @_;

    $Param{CommunicationLogObject}->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    my $Return = sub {
        my %LocalParam = @_;
        $Param{CommunicationLogObject}->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => $LocalParam{Success} ? 'Successful' : 'Failed',
        );

        return %LocalParam;
    };

    my $ReturnSuccess = sub { return $Return->( @_, Success => 1, ); };
    my $ReturnError   = sub { return $Return->( @_, Success => 0, ); };

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get config data
    $Self->{FQDN}     = $ConfigObject->Get('FQDN');
    $Self->{MailHost} = $ConfigObject->Get('SendmailModule::Host')
        || die "No SendmailModule::Host found in Kernel/Config.pm";
    $Self->{SMTPPort} = $ConfigObject->Get('SendmailModule::Port');
    $Self->{User}     = $ConfigObject->Get('SendmailModule::AuthUser');
    $Self->{Password} = $ConfigObject->Get('SendmailModule::AuthPassword');

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Debug',
        Key           => 'Kernel::System::Email::SMTP',
        Value         => 'Testing connection to SMTP service (3 attempts max.).',
    );

    # 3 possible attempts to connect to the SMTP server.
    # (MS Exchange Servers have sometimes problems on port 25)
    my $SMTP;

    my $TryConnectMessage = sprintf
        "%%s: Trying to connect to '%s%s' on %s with SMTP type '%s'.",
        $Self->{MailHost},
        ( $Self->{SMTPPort} ? ':' . $Self->{SMTPPort} : '' ),
        $Self->{FQDN},
        $Self->{SMTPType};
    TRY:
    for my $Try ( 1 .. 3 ) {

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Debug',
            Key           => 'Kernel::System::Email::SMTP',
            Value         => sprintf( $TryConnectMessage, $Try, ),
        );

        # connect to mail server
        eval {
            $SMTP = $Self->_Connect(
                MailHost  => $Self->{MailHost},
                FQDN      => $Self->{FQDN},
                SMTPPort  => $Self->{SMTPPort},
                SMTPDebug => $Self->{SMTPDebug},
            );
            return 1;
        } || do {
            my $Error = $@;
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => sprintf(
                    "SMTP, connection try %s, unexpected error captured: %s",
                    $Try,
                    $Error,
                ),
            );
        };

        last TRY if $SMTP;

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Debug',
            Key           => 'Kernel::System::Email::SMTP',
            Value         => "$Try: Connection could not be established. Waiting for 0.3 seconds.",
        );

        # sleep 0,3 seconds;
        select( undef, undef, undef, 0.3 );    ## no critic
    }

    # return if no connect was possible
    if ( !$SMTP ) {

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => 'Kernel::System::Email::SMTP',
            Value         => "Could not connect to host '$Self->{MailHost}'. ErrorMessage: $!",
        );

        return $ReturnError->(
            ErrorMessage => "Can't connect to $Self->{MailHost}: $!!",
        );
    }

    # Enclose SMTP in a wrapper to handle unexpected exceptions
    $SMTP = $Self->_GetSMTPSafeWrapper(
        SMTP => $SMTP,
    );

    # use smtp auth if configured
    if ( $Self->{User} && $Self->{Password} ) {

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Debug',
            Key           => 'Kernel::System::Email::SMTP',
            Value         => "Using SMTP authentication with user '$Self->{User}' and (hidden) password.",
        );

        if ( !$SMTP->( 'auth', $Self->{User}, $Self->{Password} ) ) {

            my $Code  = $SMTP->( 'code', );
            my $Error = $Code . ', ' . $SMTP->( 'message', );

            $SMTP->( 'quit', );

            $Param{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Error',
                Key           => 'Kernel::System::Email::SMTP',
                Value         => "SMTP authentication failed (SMTP code: $Code, ErrorMessage: $Error).",
            );

            return $ReturnError->(
                ErrorMessage => "SMTP authentication failed: $Error!",
                Code         => $Code,
            );
        }
    }

    return $ReturnSuccess->(
        SMTP => $SMTP,
    );
}

sub Send {
    my ( $Self, %Param ) = @_;

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::SMTP',
        Value         => 'Received message for sending, validating message contents.',
    );

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {

            $Param{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::Email::SMTP',
                Value         => "Need $_!",
            );

            return $Self->_SendError(
                %Param,
                ErrorMessage => "Need $_!",
            );
        }
    }
    if ( !$Param{From} ) {
        $Param{From} = '';
    }

    # connect to smtp server
    my %Result = $Self->Check(%Param);

    if ( !$Result{Success} ) {
        return $Self->_SendError( %Param, %Result, );
    }

    # set/get SMTP handle
    my $SMTP = $Result{SMTP};

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::Email::SMTP',
        Value         => "Sending envelope from (mail from: $Param{From}) to server.",
    );

    # set envelope from, return if from was not accepted by the server
    if ( !$SMTP->( 'mail', $Param{From}, ) ) {

        my $FullErrorMessage = sprintf(
            "Envelope from '%s' not accepted by the server: %s, %s!",
            $Param{From},
            $SMTP->( 'code', ),
            $SMTP->( 'message', ),
        );

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::Email::SMTP',
            Value         => $FullErrorMessage,
        );

        return $Self->_SendError(
            %Param,
            ErrorMessage => $FullErrorMessage,
            SMTP         => $SMTP,
        );
    }

    TO:
    for my $To ( @{ $Param{ToArray} } ) {

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::Email::SMTP',
            Value         => "Sending envelope to (rcpt to: $To) to server.",
        );

        # Check if the recipient is valid
        next TO if $SMTP->( 'to', $To, );

        my $FullErrorMessage = sprintf(
            "Envelope to '%s' not accepted by the server: %s, %s!",
            $To,
            $SMTP->( 'code', ),
            $SMTP->( 'message', ),
        );

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::Email::SMTP',
            Value         => $FullErrorMessage,
        );

        return $Self->_SendError(
            %Param,
            ErrorMessage => $FullErrorMessage,
            SMTP         => $SMTP,
        );
    }

    my $ToString = join ',', @{ $Param{ToArray} };

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # encode utf8 header strings (of course, there should only be 7 bit in there!)
    $EncodeObject->EncodeOutput( $Param{Header} );

    # encode utf8 body strings
    $EncodeObject->EncodeOutput( $Param{Body} );

    # send data
    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::Email::SMTP',
        Value         => "Sending message data to server.",
    );

    # Send email data by chunks because when in SSL mode, each SSL
    # frame has a maximum of 16kB (Bug #12957).
    # We send always the first 4000 characters until '$Data' is empty.
    # If any error occur while sending data to the smtp server an exception
    # is thrown and '$DataSent' will be undefined.
    my $DataSent = eval {
        my $Data      = ${ $Param{Header} } . "\n" . ${ $Param{Body} };
        my $ChunkSize = 4000;

        $SMTP->( 'data', ) || die "error starting data sending";

        while ( my $DataLength = length $Data ) {
            my $TmpChunkSize = ( $ChunkSize > $DataLength ) ? $DataLength : $ChunkSize;
            my $Chunk        = substr $Data, 0, $TmpChunkSize;

            $SMTP->( 'datasend', $Chunk, ) || die "error sending data chunk";

            $Data = substr $Data, $TmpChunkSize;
        }

        $SMTP->( 'dataend', ) || die "error ending data sending";

        return 1;
    };

    if ( !$DataSent ) {
        my $FullErrorMessage = sprintf(
            "Could not send message to server: %s, %s!",
            $SMTP->( 'code', ),
            $SMTP->( 'message', ),
        );

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::Email::SMTP',
            Value         => $FullErrorMessage,
        );

        return $Self->_SendError(
            %Param,
            ErrorMessage => $FullErrorMessage,
            SMTP         => $SMTP,
        );
    }

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Sent email to '$ToString' from '$Param{From}'.",
        );
    }

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::SMTP',
        Value         => "Email successfully sent from '$Param{From}' to '$ToString'.",
    );

    return $Self->_SendSuccess(
        SMTP => $SMTP,
        %Param
    );
}

sub _Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(MailHost FQDN)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # Remove a possible port from the FQDN value
    my $FQDN = $Param{FQDN};
    $FQDN =~ s{:\d+}{}smx;

    # set up connection connection
    my $SMTP = Net::SMTP->new(
        $Param{MailHost},
        Hello   => $FQDN,
        Port    => $Param{SMTPPort} || 25,
        Timeout => 30,
        Debug   => $Param{SMTPDebug},
    );

    return $SMTP;
}

sub _SendResult {
    my ( $Self, %Param ) = @_;

    my $SMTP = delete $Param{SMTP};
    $SMTP->( 'quit', ) if $SMTP;

    return {%Param};
}

sub _SendSuccess {
    my ( $Self, %Param ) = @_;
    return $Self->_SendResult(
        Success => 1,
        %Param
    );
}

sub _SendError {
    my ( $Self, %Param ) = @_;

    my $SMTP = $Param{SMTP};
    if ( $SMTP && !defined $Param{Code} ) {
        $Param{Code} = $SMTP->( 'code', );
    }

    return $Self->_SendResult(
        Success => 0,
        %Param,
        SMTPError => 1,
    );
}

sub _GetSMTPSafeWrapper {
    my ( $Self, %Param, ) = @_;

    my $SMTP = $Param{SMTP};

    return sub {
        my $Operation   = shift;
        my @LocalParams = @_;

        my $ScalarResult;
        my @ArrayResult = ();
        my $Wantarray   = wantarray;

        eval {
            if ($Wantarray) {
                @ArrayResult = $SMTP->$Operation( @LocalParams, );
            }
            else {
                $ScalarResult = $SMTP->$Operation( @LocalParams, );
            }

            return 1;
        } || do {
            my $Error = $@;
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => sprintf(
                    "Error while executing 'SMTP->%s(%s)': %s",
                    $Operation,
                    join( ',', @LocalParams ),
                    $Error,
                ),
            );
        };

        return @ArrayResult if $Wantarray;
        return $ScalarResult;
    };
}

1;
