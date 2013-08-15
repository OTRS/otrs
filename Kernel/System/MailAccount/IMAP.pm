# --
# Kernel/System/MailAccount/IMAP.pm - lib for imap accounts
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::MailAccount::IMAP;

use strict;
use warnings;
use Net::IMAP::Simple;
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

    my $Type = 'IMAP';

    # connect to host
    my $IMAPObject = Net::IMAP::Simple->new(
        $Param{Host},
        timeout => $Param{Timeout},
        debug   => $Param{Debug}
    );
    if ( !$IMAPObject ) {
        return ( Successful => 0, Message => "$Type: Can't connect to $Param{Host}" );
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

    # fetch again if still messages on the account
    for ( 1 .. 200 ) {
        return if !$Self->_Fetch(%Param);
        last   if !$Self->{Reconnect};
    }
    return 1;
}

sub _Fetch {
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

    $Self->{Reconnect} = 0;

    my %Connect = $Self->Connect(
        Host     => $Param{Host},
        Login    => $Param{Login},
        Password => $Param{Password},
        Timeout  => $Timeout,
        Debug    => $Debug
    );

    if ( !$Connect{Successful} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$Connect{Message}",
        );
        return;
    }

    # read folder from MailAccount configuration
    my $IMAPFolder = $Param{IMAPFolder} || 'INBOX';

    my $IMAPObject = $Connect{IMAPObject};
    my $NOM        = $IMAPObject->select($IMAPFolder) || 0;
    my $AuthType   = $Connect{Type};

    # fetch messages
    if ( !$NOM ) {
        if ($CMD) {
            print "$AuthType: No messages ($Param{Login}/$Param{Host})\n";
        }
    }
    else {
        for ( my $Messageno = 1; $Messageno <= $NOM; $Messageno++ ) {

            # check if reconnect is needed
            if ( ( $FetchCounter + 1 ) > $MaxPopEmailSession ) {
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
            my $MessageSize = $IMAPObject->list($Messageno);
            if ( $MessageSize > ( $MaxEmailSize * 1024 ) ) {

                # convert sizes to MB
                my $MessageSizeMB  = int( $MessageSize /  ( 1024 * 1024 ) );
                my $MaxEmailSizeMB = int( $MaxEmailSize / ( 1024 * 1024 ) );
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "$AuthType: Can't fetch email $NOM from $Param{Login}/$Param{Host}. "
                        . "Email too big ($MessageSizeMB MB - max $MaxEmailSizeMB MB)!",
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
                my @Lines = $IMAPObject->get($Messageno);

                # compat. to Net::IMAP::Simple v1.17 get() was returning an array ref at this time
                if ( $Lines[0] && !$Lines[1] && ref $Lines[0] eq 'ARRAY' ) {
                    @Lines = @{ $Lines[0] };
                }
                if ( !@Lines ) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "$AuthType: Can't process mail, email no $Messageno is empty!",
                    );
                }
                else {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        Email   => \@Lines,
                        Trusted => $Param{Trusted} || 0,
                        Debug   => $Debug,
                    );
                    my @Return = $PostMasterObject->Run( QueueID => $Param{QueueID} || 0 );
                    if ( !$Return[0] ) {
                        my $Lines = $IMAPObject->get($Messageno);
                        my $File = $Self->_ProcessFailed( Email => $Lines );
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "$AuthType: Can't process mail, see log sub system ("
                                . "$File, report it on http://bugs.otrs.org/)!",
                        );
                    }
                    undef $PostMasterObject;
                }

                # mark email to delete if it got processed
                $IMAPObject->delete($Messageno);

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
            Priority => 'notice',
            Message => "$AuthType: Fetched $FetchCounter email(s) from $Param{Login}/$Param{Host}.",
        );
    }
    $IMAPObject->expunge_mailbox($IMAPFolder);
    $IMAPObject->quit();
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
