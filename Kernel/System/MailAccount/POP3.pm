# --
# Kernel/System/MailAccount/POP3.pm - lib for pop3 accounts
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: POP3.pm,v 1.5 2009-02-16 11:47:35 tr Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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

    my $Timeout      = 60;
    my $FetchCounter = 0;
    my $Reconnect    = 0;
    my $AuthType     = 'POP3';

    # connect to host
    my $PopObject = Net::POP3->new( $Param{Host}, Timeout => $Timeout, Debug => $Debug );
    if ( !$PopObject ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$AuthType: Can't connect to $Param{Host}",
        );
        return;
    }

    # authentcation
    my $NOM = $PopObject->login( $Param{Login}, $Param{Password} );
    if ( !defined $NOM ) {
        $PopObject->quit();
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$AuthType: Auth for user $Param{Login}/$Param{Host} failed!",
        );
        return;
    }

    # fetch messages
    if ( $NOM > 0 ) {
        for my $Messageno ( sort { $a <=> $b } keys %{ $PopObject->list() } ) {

            # check if reconnect is needed
            if ( ( $FetchCounter + 1 ) > $MaxPopEmailSession ) {
                $Reconnect = 1;
                if ($CMD) {
                    print "$AuthType: Reconnect Session after $MaxPopEmailSession messages...\n";
                }
                last;
            }
            if ($CMD) {
                print "$AuthType: Message $Messageno/$NOM ($Param{Login}/$Param{Host})\n";
            }

            # check message size
            my $MessageSize = int( $PopObject->list($Messageno) / 1024 );
            if ( $MessageSize > $MaxEmailSize ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "$AuthType: Can't fetch email $NOM from $Param{Login}/$Param{Host}. Email to "
                        . "big ($MessageSize KB - max $MaxEmailSize KB)!",
                );
            }
            else {

                # safety protection
                $FetchCounter++;
                if ( $FetchCounter > 10 && $FetchCounter < 25 ) {
                    if ($CMD) {
                        print
                            "$AuthType: Safety protection waiting 2 second till processing next mail...\n";
                    }
                    sleep 2;
                }
                elsif ( $FetchCounter > 25 ) {
                    if ($CMD) {
                        print
                            "$AuthType: Safety protection waiting 3 seconds till processing next mail...\n";
                    }
                    sleep 3;
                }

                # get message (header and body)
                my $Lines            = $PopObject->get($Messageno);
                my $PostMasterObject = Kernel::System::PostMaster->new(
                    %{$Self},
                    Email   => $Lines,
                    Trusted => $Param{Trusted} || 0,
                    Debug   => $Debug,
                );
                my @Return = $PostMasterObject->Run( QueueID => $Param{QueueID} || 0 );
                if ( !$Return[0] ) {
                    my $Lines = $PopObject->get($Messageno);
                    my $File = $Self->_ProcessFailed( Email => $Lines );
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "$AuthType: Can't process mail, see log sub system ("
                            . "$File, report it on http://bugs.otrs.org/)!",
                    );
                }
                undef $PostMasterObject;

                # mark email to delete if it got processed
                $PopObject->delete($Messageno);

                # check limit
                $Self->{Limit}++;
                if ( $Self->{Limit} >= $Limit ) {
                    $Reconnect = 0;
                    last;
                }

            }
            if ($CMD) {
                print "\n";
            }
        }
    }
    else {
        if ($CMD) {
            print "$AuthType: No messages ($Param{Login}/$Param{Host})\n";
        }
    }

    # log status
    if ( $Debug > 0 || $FetchCounter ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "$AuthType: Fetched $FetchCounter email(s) from $Param{Login}/$Param{Host}.",
        );
    }
    $PopObject->quit();
    if ($CMD) {
        print "$AuthType: Connection to $Param{Host} closed.\n\n";
    }

    # fetch again if still messages on the account
    if ($Reconnect) {
        $Self->Fetch(%Param);
    }
    return 1;
}

sub _ProcessFailed {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Email)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
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
        Permission => '644',
    );
}

1;
