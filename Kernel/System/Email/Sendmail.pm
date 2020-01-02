# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Email::Sendmail;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog',
    'Kernel::System::Encode',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{Type} = 'Sendmail';

    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::Sendmail',
        Value         => 'Received message for sending, validating message contents.',
    );

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {
            my $ErrorMsg = "Need $_!";

            $Param{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::Email::Sendmail',
                Value         => $ErrorMsg,
            );

            return $Self->_SendError(
                %Param,
                ErrorMessage => $ErrorMsg,
            );
        }
    }

    # from for arg
    my $Arg = quotemeta( $Param{From} );
    if ( !$Param{From} ) {
        $Arg = "''";
    }

    # get recipients
    my $ToString = '';
    for my $To ( @{ $Param{ToArray} } ) {
        if ($ToString) {
            $ToString .= ', ';
        }
        $ToString .= $To;
        $Arg      .= ' ' . quotemeta($To);
    }

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::Email::Sendmail',
        Value         => 'Checking availability of sendmail command.',
    );

    # check availability
    my %Result = $Self->Check();

    if ( !$Result{Success} ) {

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::Email::Sendmail',
            Value         => "Sendmail check error: $Result{ErrorMessage}",
        );

        return $Self->_SendError(
            %Param,
            %Result,
        );
    }

    $Param{CommunicationLogObject}->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::Sendmail',
        Value         => "Sending email from '$Param{From}' to '$ToString'.",
    );

    # set sendmail binary
    my $Sendmail = $Result{Sendmail};

    # restore the child signal to the original value, in a daemon environment, child signal is set
    # to ignore causing problems with file handler pipe close
    local $SIG{'CHLD'} = 'DEFAULT';

    # invoke sendmail in order to send off mail, catching errors in a temporary file
    my $FH;
    my $GenErrorMessage = sub { return sprintf( q{Can't send message: %s!}, shift, ); };
    ## no critic
    if ( !open( $FH, '|-', "$Sendmail $Arg " ) ) {
        ## use critic
        my $ErrorMessage = $GenErrorMessage->($!);

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => 'Kernel::System::Email::Sendmail',
            Value         => "Error during message sending: $ErrorMessage",
        );

        return $Self->_SendError(
            %Param,
            ErrorMessage => $ErrorMessage,
        );
    }

    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # encode utf8 header strings (of course, there should only be 7 bit in there!)
    $EncodeObject->EncodeOutput( $Param{Header} );

    # encode utf8 body strings
    $EncodeObject->EncodeOutput( $Param{Body} );

    print $FH ${ $Param{Header} };
    print $FH "\n";
    print $FH ${ $Param{Body} };

    # Check if the filehandle was already closed because of an error
    #   (e. g. mail too large). See bug#9251.
    if ( !close($FH) ) {

        my $ErrorMessage = $GenErrorMessage->($!);

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => 'Kernel::System::Email::Sendmail',
            Value         => "Error during message sending: $ErrorMessage",
        );

        return $Self->_SendError(
            %Param,
            ErrorMessage => $ErrorMessage,
        );
    }

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::Sendmail',
        Value         => "Email successfully sent from '$Param{From}' to '$ToString'!",
    );

    $Param{CommunicationLogObject}->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    return $Self->_SendSuccess();
}

sub _SendSuccess {
    my ( $Self, %Param ) = @_;

    return {
        %Param,
        Success => 1,
    };
}

sub _SendError {
    my ( $Self, %Param ) = @_;

    $Param{CommunicationLogObject}->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Failed',
    );

    return {
        Success => 0,
        %Param,
    };
}

sub Check {
    my ( $Self, %Param ) = @_;

    # get config data
    my $Sendmail = $Kernel::OM->Get('Kernel::Config')->Get('SendmailModule::CMD');

    # check if sendmail binary is there (strip all args and check if file exists)
    my $SendmailBinary = $Sendmail;
    $SendmailBinary =~ s/^(.+?)\s.+?$/$1/;
    if ( !-f $SendmailBinary ) {
        return (
            Success      => 0,
            ErrorMessage => "No such binary: $SendmailBinary!"
        );
    }

    return (
        Success  => 1,
        Sendmail => $Sendmail,
    );
}

1;
