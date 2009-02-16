# --
# Kernel/System/AuthSession.pm - provides session check and session data
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AuthSession.pm,v 1.37 2009-02-16 11:58:56 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::AuthSession;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.37 $) [1];

=head1 NAME

Kernel::System::AuthSeesion - global session interface

=head1 SYNOPSIS

All session functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::AuthSession;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        LogObject    => $LogObject,
        ConfigObject => $ConfigObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $SesionObject = Kernel::System::AuthSession->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
    );

(The session backend (DB, FS or IPC) is configures in Kernel/Config.pm)

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject TimeObject DBObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # load generator backend module
    my $GenericModule = $Self->{ConfigObject}->Get('SessionModule')
        || 'Kernel::System::AuthSession::DB';
    if ( !$Self->{MainObject}->Require($GenericModule) ) {
        $Self->{MainObject}->Die("Can't load backend module $GenericModule! $@");
    }
    $Self->{Backend} = $GenericModule->new(%Param);

    return $Self;
}

=item CheckSessionID()

checks a session, returns true (session ok) or false (session invalid)

    $SessionObject->CheckSessionID(SessionID => '1234567890123456');

=cut

sub CheckSessionID {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->CheckSessionID(%Param);
}

=item CheckSessionIDMessage()

returns why CheckSessionID() returns false (e. g. invalid session id,
different remote ip, ...)

    my $Message = $SessionObject->CheckSessionIDMessage();

=cut

sub CheckSessionIDMessage {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->CheckSessionIDMessage(%Param);
}

=item GetSessionIDData()

get session data in a hash

    my %Data = $SessionObject->GetSessionIDData(SessionID => '1234567890123456');

=cut

sub GetSessionIDData {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->GetSessionIDData(%Param);
}

=item CreateSessionID()

create a new session with given data

    my $SessionID = $SessionObject->CreateSessionID(
        UserLogin => 'root',
        UserEmail => 'root@example.com',
    );

=cut

sub CreateSessionID {
    my ( $Self, %Param ) = @_;

    # delete old session ids
    my @Expired = $Self->GetExpiredSessionIDs();
    for ( 0 .. 1 ) {
        for my $SessionID ( @{ $Expired[$_] } ) {
            $Self->RemoveSessionID( SessionID => $SessionID );
        }
    }

    # return created session id
    return $Self->{Backend}->CreateSessionID(%Param);
}

=item RemoveSessionID()

removes a session and returns true (session deleted), false (if
session can't get deleted)

    $SessionObject->RemoveSessionID(SessionID => '1234567890123456');

=cut

sub RemoveSessionID {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->RemoveSessionID(%Param);
}

=item UpdateSessionID()

update session info by key and value, returns true (if ok) and
false (if can't update)

    $SessionObject->UpdateSessionID(
        SessionID => '1234567890123456',
        Key       => 'LastScreenView',
        Value     => 'SomeInfo',
    );

=cut

sub UpdateSessionID {
    my ( $Self, %Param ) = @_;

    if ( $Param{Key} && $Param{Key} =~ /:/ ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't Update Key: '$Param{Key}' because of ':' is not alown!",
        );
        return;
    }
    return $Self->{Backend}->UpdateSessionID(%Param);
}

=item GetExpiredSessionIDs()

returns a array with expired session ids

    my @Sessions = $SessionObject->GetExpiredSessionIDs();

    my @ExpiredSession = @{$Session[0]};
    my @ExpiredIdle    = @{$Session[1]};

=cut

sub GetExpiredSessionIDs {
    my ( $Self, %Param ) = @_;

    my @ExpiredSession = ();
    my @ExpiredIdle    = ();
    my @List           = $Self->{Backend}->GetAllSessionIDs();
    for my $SessionID (@List) {
        my %SessionData    = $Self->GetSessionIDData( SessionID => $SessionID );
        my $MaxSessionTime = $Self->{ConfigObject}->Get('SessionMaxTime');
        my $ValidTime      = ( ( $SessionData{UserSessionStart} || 0 ) + $MaxSessionTime )
            - $Self->{TimeObject}->SystemTime();
        my $MaxSessionIdleTime = $Self->{ConfigObject}->Get('SessionMaxIdleTime');
        my $ValidIdleTime = ( ( $SessionData{UserLastRequest} || 0 ) + $MaxSessionIdleTime )
            - $Self->{TimeObject}->SystemTime();

        # delete invalid session time
        if ( $ValidTime <= 0 ) {
            push @ExpiredSession, $SessionID;
        }

        # delete invalid idle session time
        elsif ( $ValidIdleTime <= 0 ) {
            push @ExpiredIdle, $SessionID;
        }
    }
    return ( \@ExpiredSession, \@ExpiredIdle );
}

=item GetAllSessionIDs()

returns a array with all session ids

    my @Sessions = $SessionObject->GetAllSessionIDs();

=cut

sub GetAllSessionIDs {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->GetAllSessionIDs(%Param);
}

=item CleanUp()

clean up of sessions in your system

    $SessionObject->CleanUp();

=cut

sub CleanUp {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->CleanUp(%Param);
}
1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=head1 VERSION

$Revision: 1.37 $ $Date: 2009-02-16 11:58:56 $

=cut
