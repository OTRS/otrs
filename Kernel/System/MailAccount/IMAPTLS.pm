# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::MailAccount::IMAPTLS;

use strict;
use warnings;

use Mail::IMAPClient;

use Kernel::System::PostMaster;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog',
    'Kernel::System::Log',
    'Kernel::System::Main',
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
            return (
                Successful => 0,
                Message    => "Need $_!",
            );
        }
    }

    # connect to host
    my $IMAPObject = Mail::IMAPClient->new(
        Server   => $Param{Host},
        User     => $Param{Login},
        Password => $Param{Password},
        Starttls => [ SSL_verify_mode => 0 ],
        Debug    => $Param{Debug},
        Uid      => 1,

        # see bug#8791: needed for some Microsoft Exchange backends
        Ignoresizeerrors => 1,
    );

    if ( !$IMAPObject ) {
        return (
            Successful => 0,
            Message    => "IMAPTLS: Can't connect to $Param{Host}: $@\n"
        );
    }

    return (
        Successful => 1,
        IMAPObject => $IMAPObject,
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
                Key           => 'Kernel::System::MailAccount::IMAPTLS',
                Value         => "$_ not defined!",
            );

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Connection',
                Status        => 'Failed',
            );
            $CommunicationLogObject->CommunicationStop( Status => 'Failed' );

            return;
        }
    }
    for (qw(Login Password Host)) {
        if ( !$Param{$_} ) {
            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailAccount::IMAPTLS',
                Value         => "Need $_!",
            );

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Connection',
                Status        => 'Failed',
            );

            $CommunicationLogObject->CommunicationStop( Status => 'Failed' );

            return;
        }
    }

    my $Debug = $Param{Debug} || 0;
    my $Limit = $Param{Limit} || 5000;
    my $CMD   = $Param{CMD}   || 0;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # MaxEmailSize is in kB in SysConfig
    my $MaxEmailSize = $ConfigObject->Get('PostMasterMaxEmailSize') || 1024 * 6;

    # MaxPopEmailSession
    my $MaxPopEmailSession = $ConfigObject->Get('PostMasterReconnectMessage') || 20;

    my $Timeout      = 60;
    my $FetchCounter = 0;
    my $AuthType     = 'IMAPTLS';

    $Self->{Reconnect} = 0;

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Debug',
        Key           => 'Kernel::System::MailAccount::IMAPTLS',
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
    } || do {
        my $Error = $@;
        %Connect = (
            Successful => 0,
            Message =>
                "Something went wrong while trying to connect to 'IMAPTLS => $Param{Login}/$Param{Host}': ${ Error }",
        );
    };

    if ( !$Connect{Successful} ) {
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => 'Kernel::System::MailAccount::IMAPTLS',
            Value         => $Connect{Message},
        );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => 'Failed',
        );

        $CommunicationLogObject->CommunicationStop( Status => 'Failed' );

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
                    "Error while executing 'IMAPTLS->%s(%s)': %s",
                    $Operation,
                    join( ',', @Params ),
                    $Error,
                ),
            );
        };

        return @ArrayResult if $Wantarray;
        return $ScalarResult;
    };

    my $ConnectionWithErrors = 0;
    my $MessagesWithError    = 0;

    # read folder from MailAccount configuration
    my $IMAPFolder       = $Param{IMAPFolder} || 'INBOX';
    my $NumberOfMessages = 0;
    my $Messages;

    eval {
        $IMAPOperation->( 'select', $IMAPFolder, ) || die "Could not select: $@\n";
        $Messages         = $IMAPOperation->( 'messages', ) || die "Could not retrieve messages : $@\n";
        $NumberOfMessages = scalar @{$Messages};

        if ($CMD) {
            print "$AuthType: I found $NumberOfMessages messages on $Param{Login}/$Param{Host}. ";
        }

        return 1;
    } || do {
        my $Error = $@;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => sprintf(
                "Error while retrieving the messages 'IMAPTLS': %s",
                $Error,
            ),
        );

        $ConnectionWithErrors = 1;
    };

    # fetch messages
    if ( $Messages && !$NumberOfMessages ) {
        if ($CMD) {
            print "$AuthType: No messages on $Param{Login}/$Param{Host}\n";
        }
    }
    elsif ($NumberOfMessages) {
        MESSAGE_NO:
        for my $Messageno ( @{$Messages} ) {

            # check if reconnect is needed
            $FetchCounter++;
            if ( ($FetchCounter) > $MaxPopEmailSession ) {
                $Self->{Reconnect} = 1;
                if ($CMD) {
                    print "$AuthType: Reconnect Session after $MaxPopEmailSession messages...\n";
                }
                last MESSAGE_NO;
            }
            if ($CMD) {
                print
                    "$AuthType: Message $FetchCounter/$NumberOfMessages ($Param{Login}/$Param{Host})\n";
            }

            # check message size
            my $MessageSize = $IMAPOperation->( 'size', $Messageno, );
            if ( !( defined $MessageSize ) ) {
                my $ErrorMessage
                    = "$AuthType: Can't determine the size of email '$Messageno/$NumberOfMessages' from $Param{Login}/$Param{Host}!";

                $CommunicationLogObject->ObjectLog(
                    ObjectLogType => 'Connection',
                    Priority      => 'Error',
                    Key           => 'Kernel::System::MailAccount::IMAPTLS',
                    Value         => $ErrorMessage,
                );

                $ConnectionWithErrors = 1;

                if ($CMD) {
                    print "\n";
                }

                next MESSAGE_NO;
            }

            $MessageSize = int( $MessageSize / 1024 );
            if ( $MessageSize > $MaxEmailSize ) {

                my $ErrorMessage = "$AuthType: Can't fetch email $Messageno from $Param{Login}/$Param{Host}. "
                    . "Email too big ($MessageSize KB - max $MaxEmailSize KB)!";

                $CommunicationLogObject->ObjectLog(
                    ObjectLogType => 'Connection',
                    Priority      => 'Error',
                    Key           => 'Kernel::System::MailAccount::IMAPTLS',
                    Value         => $ErrorMessage,
                );

                $ConnectionWithErrors = 1;
            }
            else {

                # safety protection
                my $FetchDelay = ( $FetchCounter % 20 == 0 ? 1 : 0 );
                if ( $FetchDelay && $CMD ) {
                    print "$AuthType: Safety protection: waiting 1 second before processing next mail...\n";
                    sleep 1;
                }

                # get message (header and body)
                my $Message = $IMAPOperation->( 'message_string', $Messageno, );
                if ( !$Message ) {

                    my $ErrorMessage = "$AuthType: Can't process mail, email no $Messageno is empty!";

                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Error',
                        Key           => 'Kernel::System::MailAccount::IMAPTLS',
                        Value         => $ErrorMessage,
                    );

                    $ConnectionWithErrors = 1;
                }
                else {
                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Debug',
                        Key           => 'Kernel::System::MailAccount::IMAPTLS',
                        Value         => "Message '$Messageno' successfully received from server.",
                    );

                    $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );
                    my $MessageStatus = 'Successful';

                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        Email                  => \$Message,
                        Trusted                => $Param{Trusted} || 0,
                        Debug                  => $Debug,
                        CommunicationLogObject => $CommunicationLogObject,
                    );

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
                        my $File  = $Self->_ProcessFailed( Email => $Message );

                        my $ErrorMessage = "$AuthType: Can't process mail, see log sub system ("
                            . "$File, report it on http://bugs.otrs.org/)!";

                        $CommunicationLogObject->ObjectLog(
                            ObjectLogType => 'Connection',
                            Priority      => 'Error',
                            Key           => 'Kernel::System::MailAccount::IMAPTLS',
                            Value         => $ErrorMessage,
                        );

                        $MessageStatus = 'Failed';
                    }

                    # mark email to delete once it was processed
                    $IMAPOperation->( 'delete_message', $Messageno, );
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

    # log status
    if ( $Debug > 0 || $FetchCounter ) {
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Info',
            Key           => 'Kernel::System::MailAccount::IMAPTLS',
            Value         => "$AuthType: Fetched $FetchCounter email(s) from $Param{Login}/$Param{Host}.",
        );
    }
    $IMAPOperation->( 'close', );
    if ($CMD) {
        print "$AuthType: Connection to $Param{Host} closed.\n\n";
    }

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
    $CommunicationLogObject->CommunicationStop( Status => 'Successful' );

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

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/spool/';
    my $MD5  = $MainObject->MD5sum(
        String => \$Param{Email},
    );
    my $Location = $Home . 'problem-email-' . $MD5;

    return $MainObject->FileWrite(
        Location   => $Location,
        Content    => \$Param{Email},
        Mode       => 'binmode',
        Type       => 'Local',
        Permission => '640',
    );
}

1;
