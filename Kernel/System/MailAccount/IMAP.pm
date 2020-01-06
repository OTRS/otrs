# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::MailAccount::IMAP;

use strict;
use warnings;

use Net::IMAP::Simple;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::PostMaster',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Login Password Host Timeout Debug)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return (
                Successful => 0,
                Message    => "Need $_!",
            );
        }
    }

    my $Type = 'IMAP';

    # connect to host
    my $IMAPObject = Net::IMAP::Simple->new(
        $Param{Host},
        timeout => $Param{Timeout},
        debug   => $Param{Debug} || undef,
    );
    if ( !$IMAPObject ) {
        return (
            Successful => 0,
            Message    => "$Type: Can't connect to $Param{Host}"
        );
    }

    # authentication
    my $Auth = $IMAPObject->login( $Param{Login}, $Param{Password} );
    if ( !defined $Auth ) {
        $IMAPObject->quit();
        return (
            Successful => 0,
            Message    => "$Type: Auth for user $Param{Login}/$Param{Host} failed!"
        );
    }

    return (
        Successful => 1,
        IMAPObject => $IMAPObject,
        Type       => $Type,
    );
}

sub Fetch {
    my ( $Self, %Param ) = @_;

    # start a new incoming communication
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport   => 'Email',
            Direction   => 'Incoming',
            AccountType => $Param{Type},
            AccountID   => $Param{ID},
        },
    );

    # fetch again if still messages on the account
    my $CommunicationLogStatus = 'Successful';
    COUNT:
    for ( 1 .. 200 ) {
        my $Fetch = $Self->_Fetch(
            %Param,
            CommunicationLogObject => $CommunicationLogObject,
        );
        if ( !$Fetch ) {
            $CommunicationLogStatus = 'Failed';
        }

        last COUNT if !$Self->{Reconnect};
    }

    $CommunicationLogObject->CommunicationStop(
        Status => $CommunicationLogStatus,
    );

    return 1;
}

sub _Fetch {
    my ( $Self, %Param ) = @_;

    my $CommunicationLogObject = $Param{CommunicationLogObject};

    $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    # check needed stuff
    for (qw(Login Password Host Trusted QueueID)) {
        if ( !defined $Param{$_} ) {
            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailAccount::IMAP',
                Value         => "$_ not defined!",
            );

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Connection',
                Status        => 'Failed',
            );

            return;
        }
    }
    for (qw(Login Password Host)) {
        if ( !$Param{$_} ) {
            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailAccount::IMAP',
                Value         => "Need $_!",
            );

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Connection',
                Status        => 'Failed',
            );

            return;
        }
    }

    my $Debug = $Param{Debug} || 0;
    my $Limit = $Param{Limit} || 5000;
    my $CMD   = $Param{CMD}   || 0;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # MaxEmailSize
    my $MaxEmailSize = $ConfigObject->Get('PostMasterMaxEmailSize') || 1024 * 6;

    # MaxPopEmailSession
    my $MaxPopEmailSession = $ConfigObject->Get('PostMasterReconnectMessage') || 20;

    my $Timeout      = 60;
    my $FetchCounter = 0;

    $Self->{Reconnect} = 0;

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Debug',
        Key           => 'Kernel::System::MailAccount::IMAP',
        Value         => "Open connection to '$Param{Host}' ($Param{Login}).",
    );

    my %Connect = ();
    eval {
        %Connect = $Self->Connect(
            Host     => $Param{Host},
            Login    => $Param{Login},
            Password => $Param{Password},
            Timeout  => $Timeout,
            Debug    => $Debug
        );
        return 1;
    } || do {
        my $Error = $@;
        %Connect = (
            Successful => 0,
            Message =>
                "Something went wrong while trying to connect to 'IMAP => $Param{Login}/$Param{Host}': ${ Error }",
        );
    };

    if ( !$Connect{Successful} ) {
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => 'Kernel::System::MailAccount::IMAP',
            Value         => $Connect{Message},
        );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => 'Failed',
        );

        return;
    }

    my $IMAPOperation = sub {
        my $Operation = shift;
        my @Params    = @_;

        my $IMAPObject = $Connect{IMAPObject};
        my $ScalarResult;
        my @ArrayResult = ();
        my $Wantarray   = wantarray;

        eval {
            if ($Wantarray) {
                @ArrayResult = $IMAPObject->$Operation( @Params, );
            }
            else {
                $ScalarResult = $IMAPObject->$Operation( @Params, );
            }

            return 1;
        } || do {
            my $Error = $@;
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => sprintf(
                    "Error while executing 'IMAP->%s(%s)': %s",
                    $Operation,
                    join( ',', @Params ),
                    $Error,
                ),
            );
        };

        return @ArrayResult if $Wantarray;
        return $ScalarResult;
    };

    # read folder from MailAccount configuration
    my $IMAPFolder = $Param{IMAPFolder}                         || 'INBOX';
    my $NOM        = $IMAPOperation->( 'select', $IMAPFolder, ) || 0;
    my $AuthType   = $Connect{Type};

    my $ConnectionWithErrors = 0;
    my $MessagesWithError    = 0;

    # fetch messages
    if ( !$NOM ) {
        if ($CMD) {
            print "$AuthType: No messages ($Param{Login}/$Param{Host})\n";
        }

        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Notice',
            Key           => 'Kernel::System::MailAccount::IMAP',
            Value         => "No messages available ($Param{Login}/$Param{Host}).",
        );
    }
    else {

        my $MessageCount = $NOM eq '0E0' ? 0 : $NOM;

        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Notice',
            Key           => 'Kernel::System::MailAccount::IMAP',
            Value         => "$MessageCount messages available for fetching ($Param{Login}/$Param{Host}).",
        );

        MESSAGE_NO:
        for ( my $Messageno = 1; $Messageno <= $NOM; $Messageno++ ) {

            # check if reconnect is needed
            if ( ( $FetchCounter + 1 ) > $MaxPopEmailSession ) {

                $Self->{Reconnect} = 1;

                if ($CMD) {
                    print "$AuthType: Reconnect Session after $MaxPopEmailSession messages...\n";
                }

                $CommunicationLogObject->ObjectLog(
                    ObjectLogType => 'Connection',
                    Priority      => 'Info',
                    Key           => 'Kernel::System::MailAccount::IMAP',
                    Value         => "Reconnect session after $MaxPopEmailSession messages.",
                );

                last MESSAGE_NO;
            }

            if ($CMD) {
                print "$AuthType: Message $Messageno/$NOM ($Param{Login}/$Param{Host})\n";
            }

            # check maximum message size
            my $MessageSize = $IMAPOperation->( 'list', $Messageno, );
            if ( !( defined $MessageSize ) ) {
                my $ErrorMessage
                    = "$AuthType: Can't determine the size of email '$Messageno/$NOM' from $Param{Login}/$Param{Host}!";

                $CommunicationLogObject->ObjectLog(
                    ObjectLogType => 'Connection',
                    Priority      => 'Error',
                    Key           => 'Kernel::System::MailAccount::IMAP',
                    Value         => $ErrorMessage,
                );

                $ConnectionWithErrors = 1;

                if ($CMD) {
                    print "\n";
                }

                next MESSAGE_NO;
            }

            # determine (human readable) message size
            my $MessageSizeReadable;

            if ( $MessageSize > ( 1024 * 1024 ) ) {
                $MessageSizeReadable = sprintf "%.1f MB", ( $MessageSize / ( 1024 * 1024 ) );
            }
            elsif ( $MessageSize > 1024 ) {
                $MessageSizeReadable = sprintf "%.1f KB", ( $MessageSize / 1024 );
            }
            else {
                $MessageSizeReadable = $MessageSize . ' Bytes';
            }

            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Debug',
                Key           => 'Kernel::System::MailAccount::IMAP',
                Value => "Prepare fetching of message '$Messageno/$NOM' (Size: $MessageSizeReadable) from server.",
            );

            if ( $MessageSize > ( $MaxEmailSize * 1024 ) ) {

                # convert size to KB, log error
                my $MessageSizeKB = int( $MessageSize / (1024) );

                $CommunicationLogObject->ObjectLog(
                    ObjectLogType => 'Connection',
                    Priority      => 'Error',
                    Key           => 'Kernel::System::MailAccount::IMAP',
                    Value =>
                        "Cannot fetch message '$Messageno/$NOM' with size '$MessageSizeReadable' ($MessageSizeKB KB)."
                        . "Maximum allowed message size is '$MaxEmailSize KB'!",
                );

                $ConnectionWithErrors = 1;
            }
            else {

                # safety protection
                $FetchCounter++;
                my $FetchDelay = ( $FetchCounter % 20 == 0 ? 1 : 0 );
                if ( $FetchDelay && $CMD ) {

                    print "$AuthType: Safety protection: waiting 1 second before processing next mail...\n";

                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Debug',
                        Key           => 'Kernel::System::MailAccount::IMAP',
                        Value => 'Safety protection: waiting 1 second before fetching next message from server.',
                    );

                    sleep 1;
                }

                # get message (header and body)
                my @Lines = $IMAPOperation->( 'get', $Messageno, );

                # compat. to Net::IMAP::Simple v1.17 get() was returning an array ref at this time
                if ( $Lines[0] && !$Lines[1] && ref $Lines[0] eq 'ARRAY' ) {
                    @Lines = @{ $Lines[0] };
                }
                if ( !@Lines ) {

                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Error',
                        Key           => 'Kernel::System::MailAccount::IMAP',
                        Value         => "Could not fetch message '$Messageno', answer from server was empty.",
                    );

                    $ConnectionWithErrors = 1;
                }
                else {

                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Debug',
                        Key           => 'Kernel::System::MailAccount::IMAP',
                        Value         => "Message '$Messageno' successfully received from server.",
                    );

                    $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );
                    my $MessageStatus = 'Successful';

                    my $PostMasterObject = $Kernel::OM->Create(
                        'Kernel::System::PostMaster',
                        ObjectParams => {
                            %{$Self},
                            Email                  => \@Lines,
                            Trusted                => $Param{Trusted} || 0,
                            Debug                  => $Debug,
                            CommunicationLogObject => $CommunicationLogObject,
                        },
                    );

                    # In case of error, mark message as failed.
                    my @Return = eval {
                        return $PostMasterObject->Run( QueueID => $Param{QueueID} || 0 );
                    };
                    my $Exception = $@ || undef;

                    if ( !$Return[0] ) {
                        $MessagesWithError += 1;

                        if ($Exception) {
                            $Kernel::OM->Get('Kernel::System::Log')->Log(
                                Priority => 'error',
                                Message  => 'Exception while processing mail: ' . $Exception,
                            );
                        }

                        my $Lines = $IMAPOperation->( 'get', $Messageno, );
                        my $File  = $Self->_ProcessFailed( Email => $Lines );

                        $CommunicationLogObject->ObjectLog(
                            ObjectLogType => 'Message',
                            Priority      => 'Error',
                            Key           => 'Kernel::System::MailAccount::IMAP',
                            Value =>
                                "Could not process message. Raw mail saved ($File, report it on http://bugs.otrs.org/)!",
                        );

                        $MessageStatus = 'Failed';
                    }

                    # mark email to delete once it was processed
                    $IMAPOperation->( 'delete', $Messageno, );

                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Debug',
                        Key           => 'Kernel::System::MailAccount::IMAP',
                        Value         => "Message '$Messageno' marked for deletion.",
                    );

                    undef $PostMasterObject;

                    $CommunicationLogObject->ObjectLogStop(
                        ObjectLogType => 'Message',
                        Status        => $MessageStatus,
                    );
                }

                # check limit
                $Self->{Limit}++;
                if ( $Self->{Limit} >= $Limit ) {
                    $Self->{Reconnect} = 0;
                    last MESSAGE_NO;
                }
            }

            if ($CMD) {
                print "\n";
            }
        }
    }

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => 'Kernel::System::MailAccount::IMAP',
        Value         => "Fetched $FetchCounter message(s) from server ($Param{Login}/$Param{Host}).",
    );

    $IMAPOperation->( 'expunge_mailbox', $IMAPFolder, );
    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Debug',
        Key           => 'Kernel::System::MailAccount::IMAP',
        Value         => "Executed deletion of marked messages from server ($Param{Login}/$Param{Host}).",
    );

    $IMAPOperation->( 'quit', );
    if ($CMD) {
        print "$AuthType: Connection to $Param{Host} closed.\n\n";
    }

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Debug',
        Key           => 'Kernel::System::MailAccount::IMAP',
        Value         => "Connection to '$Param{Host}' closed.",
    );

    if ($ConnectionWithErrors) {
        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => 'Failed',
        );

        return;
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    return if $MessagesWithError;
    return 1;
}

sub _ProcessFailed {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Email} ) {

        my $ErrorMessage = "'Email' not defined!";

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $ErrorMessage,
        );
        return;
    }

    # get content of email
    my $Content;
    for my $Line ( @{ $Param{Email} } ) {
        $Content .= $Line;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/spool/';
    my $MD5  = $MainObject->MD5sum(
        String => \$Content,
    );
    my $Location = $Home . 'problem-email-' . $MD5;

    return $MainObject->FileWrite(
        Location   => $Location,
        Content    => \$Content,
        Mode       => 'binmode',
        Type       => 'Local',
        Permission => '640',
    );
}

1;
