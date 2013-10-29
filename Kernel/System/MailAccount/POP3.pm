# --
# Kernel/System/MailAccount/POP3.pm - lib for pop3 accounts
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::MailAccount::POP3;

use strict;
use warnings;
use Net::POP3;
use Kernel::System::PostMaster;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(DBObject LogObject ConfigObject TimeObject MainObject)) {
        die "Got no $_" if !$Self->{$_};
    }

    # reset limit
    $Self->{Limit} = 0;

    return $Self;
}

sub Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Login Password Host Timeout Debug)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # connect to host
    my $PopObject
        = Net::POP3->new( $Param{Host}, Timeout => 5, Debug => 1 );
    if ( !$PopObject ) {
        return ( Successful => 0, Message => "POP3: Can't connect to $Param{Host}" );
    }

    # authentication
    my $NOM = $PopObject->login( $Param{Login}, $Param{Password} );
    if ( !defined $NOM ) {
        $PopObject->quit();
        return (
            Successful => 0,
            Message    => "POP3: Auth for user $Param{Login}/$Param{Host} failed!"
        );
    }

    return (
        Successful => 1,
        PopObject  => $PopObject,
        NOM        => $NOM,
        Type       => 'POP3',
    );
}

sub _Fetch {
    my ( $Self, %Param ) = @_;

    # fetch again if still messages on the account
    MESSAGE:
    while (1) {
        return if !$Self->_Fetch(%Param);
        last MESSAGE if $Self->{Reconnect};
    }
    return 1;
}

sub Fetch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Login Password Host Trusted QueueID)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    for (qw(Login Password Host)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Debug = $Param{Debug} || 0;
    my $Limit = $Param{Limit} || 5000;
    my $CMD   = $Param{CMD}   || 0;

    # MaxEmailSize
    my $MaxEmailSize = $Self->{ConfigObject}->Get('PostMasterMaxEmailSize') || 1024 * 6;

    # MaxPopEmailSession
    my $MaxPopEmailSession = $Self->{ConfigObject}->Get('PostMasterReconnectMessage') || 20;

    my $FetchCounter = 0;

    $Self->{Reconnect} = 0;

    my %Connect = $Self->Connect(
        Host     => $Param{Host},
        Login    => $Param{Login},
        Password => $Param{Password},
        Timeout  => 15,
        Debug    => $Debug
    );

    if ( !$Connect{Successful} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$Connect{Message}",
        );
        return;
    }
    my $PopObject = $Connect{PopObject};
    my $NOM       = $Connect{NOM};
    my $AuthType  = $Connect{Type};

    # fetch messages
    if ( !$NOM ) {
        if ($CMD) {
            print "$AuthType: No messages ($Param{Login}/$Param{Host})\n";
        }
    }
    else {
        my $MessageList = $PopObject->list();
        for my $Messageno ( sort keys %{$MessageList} ) {

            # check if reconnect is needed
            if ( $FetchCounter >= $MaxPopEmailSession ) {
                $Self->{Reconnect} = 1;
                if ($CMD) {
                    print "$AuthType: Reconnect Session after $MaxPopEmailSession messages...\n";
                }
                last;
            }
            if ($CMD) {
                print "$AuthType: Message $Messageno/$NOM ($Param{Login}/$Param{Host})\n";
            }

            # check message size
            if ( $MessageList->{$Messageno} > ( $MaxEmailSize * 1024 ) ) {

                # convert size to KB, log error
                my $MessageSizeKB = int( $MessageList->{$Messageno} / (1024) );
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "$AuthType: Can't fetch email $NOM from $Param{Login}/$Param{Host}. "
                        . "Email too big ($MessageSizeKB KB - max $MaxEmailSize KB)!",
                );
            }
            else {

                # safety protection
                $FetchCounter++;
                if ( $FetchCounter > 10 ) {
                    if ($CMD) {
                        print
                            "$AuthType: Safety protection: waiting 2 second before processing next mail...\n";
                    }
                    sleep 2;
                }

                # get message (header and body)
                my $Lines = $PopObject->get($Messageno);
                if ( !$Lines ) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "$AuthType: Can't process mail, email no $Messageno is empty!",
                    );
                }
                else {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        Email   => $Lines,
                        Trusted => $Param{Trusted} || 0,
                        Debug   => $Debug,
                    );
                    my @Return = $PostMasterObject->Run( QueueID => $Param{QueueID} || 0 );
                    if ( !$Return[0] ) {
                        my $File = $Self->_ProcessFailed( Email => $Lines );
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "$AuthType: Can't process mail, mail saved ("
                                . "$File, report it on http://bugs.otrs.org/)!",
                        );
                    }
                    undef $PostMasterObject;
                }

                # mark email to delete if it got processed
                $PopObject->delete($Messageno);

                # check limit
                $Self->{Limit}++;
                if ( $Self->{Limit} >= $Limit ) {
                    $Self->{Reconnect} = 0;
                    last;
                }

            }
            if ($CMD) {
                print "\n";
            }
        }
    }

    # log status
    if ( $Debug > 0 || $FetchCounter ) {
        $Self->{LogObject}->Log(
            Priority => 'info',
            Message => "$AuthType: Fetched $FetchCounter email(s) from $Param{Login}/$Param{Host}.",
        );
    }
    $PopObject->quit();
    if ($CMD) {
        print "$AuthType: Connection to $Param{Host} closed.\n\n";
    }

    # return if everything is done
    return 1;
}

sub _ProcessFailed {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Email} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "'Email' not defined!" );
        return;
    }

    # get content of email
    my $Content;
    for my $Line ( @{ $Param{Email} } ) {
        $Content .= $Line;
    }

    my $Home = $Self->{ConfigObject}->Get('Home') . '/var/spool/';
    my $MD5  = $Self->{MainObject}->MD5sum(
        String => \$Content,
    );
    my $Location = $Home . 'problem-email-' . $MD5;

    return $Self->{MainObject}->FileWrite(
        Location   => $Location,
        Content    => \$Content,
        Mode       => 'binmode',
        Type       => 'Local',
        Permission => '640',
    );
}

1;
