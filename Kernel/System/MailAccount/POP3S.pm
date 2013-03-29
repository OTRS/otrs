# --
# Kernel/System/MailAccount/POP3S.pm - lib for pop3 accounts
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::MailAccount::POP3S;

use strict;
use warnings;

#use Net::POP3::SSLWrapper;
use Mail::POP3Client;

# Mail::POP3Client depends on IO::Socket::SSL for secure connections but doesn't fail if it's
# not present - therefore we 'use' this module explicitly. (see bug 3790)
use IO::Socket::SSL;
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

    # Net::POP3::SSLWrapper is not working with gmail, so we switched to Mail::POP3Client temporally
    #    my $PopObject
    #        = Net::POP3->new( $Param{Host}, Port => 995, Timeout => $Timeout, Debug => $Debug );

    # connect to host
    my $PopObject = Mail::POP3Client->new(
        USER     => $Param{Login},
        PASSWORD => $Param{Password},
        HOST     => $Param{Host},
        USESSL   => 'true',
    );

    if ( !$PopObject ) {
        return ( Successful => 0, Message => "POP3S: Can't connect to $Param{Host}" );
    }

    # authentcation
    # Net::POP3::SSLWrapper is not working with gmail, so we switched to Mail::POP3Client temporally
    #    my $NOM = $PopObject->login( $Param{Login}, $Param{Password} );
    #    if ( !defined $NOM ) {
    #        $PopObject->quit();
    #        $Self->{LogObject}->Log(
    #            Priority => 'error',
    #            Message  => "$AuthType: Auth for user $Param{Login}/$Param{Host} failed!",
    #        );
    #        return;
    #    }
    my $NOM = $PopObject->Count();

    # if there is no connection, Mail::POP3Client will return a -1 (see bug 3790)
    if ( $NOM == -1 ) {
        return (
            Successful => 0,
            Message    => "POP3S: Auth for user $Param{Login}/$Param{Host} failed!"
        );
    }

    return (
        Successful => 1,
        PopObject  => $PopObject,
        NOM        => $NOM
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
    my $AuthType     = 'POP3S';

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
            Message  => $Connect{Message},
        );
        return;
    }
    my $PopObject = $Connect{PopObject};
    my $NOM       = $Connect{NOM};

    # fetch messages
    if ( !$NOM ) {
        if ($CMD) {
            print "$AuthType: No messages ($Param{Login}/$Param{Host})\n";
        }
    }
    else {

        # Net::POP3::SSLWrapper is not working with gmail, so we switched to Mail::POP3Client
        # temporally for my $Messageno ( sort { $a <=> $b } keys %{ $PopObject->list() } ) {
        for my $MessagenoString ( $PopObject->List() ) {
            my ( $Messageno, $MessageSize ) = split( '\s+', $MessagenoString );

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
            # Net::POP3::SSLWrapper is not working with gmail, so we switched to Mail::POP3Client
            # temporally
            # my $MessageSize = int( $PopObject->list($Messageno) / 1024 );
            $MessageSize = int( $MessageSize / 1024 );
            if ( $MessageSize > $MaxEmailSize ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "$AuthType: Can't fetch email $NOM from $Param{Login}/$Param{Host}. "
                        . "Email too big ($MessageSize KB - max $MaxEmailSize KB)!",
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
                # Net::POP3::SSLWrapper is not working with gmail, so we switched to
                # Mail::POP3Client temporally
                # my $Lines = $PopObject->get($Messageno);
                my $Line = $PopObject->HeadAndBody($Messageno);
                if ( !$Line ) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "$AuthType: Can't process mail, email no $Messageno is empty!",
                    );
                }
                else {
                    my @Lines = split( /\n/, $Line );
                    for my $LineItem (@Lines) {
                        $LineItem .= "\n";
                    }
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        Email   => \@Lines,
                        Trusted => $Param{Trusted} || 0,
                        Debug   => $Debug,
                    );
                    my @Return = $PostMasterObject->Run( QueueID => $Param{QueueID} || 0 );
                    if ( !$Return[0] ) {

                        # Net::POP3::SSLWrapper is not working with gmail, so we switched to
                        # Mail::POP3Client temporally
                        # my $Lines = $PopObject->get($Messageno);
                        my $Line = $PopObject->HeadAndBody($Messageno);
                        my @Lines = split( /\n/, $Line );
                        for my $LineItem (@Lines) {
                            $LineItem .= "\n";
                        }
                        my $File = $Self->_ProcessFailed( Email => \@Lines );
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "$AuthType: Can't process mail, see log sub system ("
                                . "$File, report it on http://bugs.otrs.org/)!",
                        );
                    }
                    undef $PostMasterObject;
                }

                # mark email to delete if it got processed
                # Net::POP3::SSLWrapper is not working with gmail, so we switched to
                # Mail::POP3Client temporally
                # $PopObject->delete($Messageno);
                $PopObject->Delete($Messageno);

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

    # Net::POP3::SSLWrapper is not working with gmail, so we switched to Mail::POP3Client temporally
    # $PopObject->quit();
    $PopObject->Close();
    if ($CMD) {
        print "$AuthType: Connection to $Param{Host} closed.\n\n";
    }

    # return it everything is done
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
        Permission => '640',
    );
}

1;
