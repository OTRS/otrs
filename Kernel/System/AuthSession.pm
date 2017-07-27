# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::AuthSession;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::SystemData',
    'Kernel::System::SysConfig',
);

=head1 NAME

Kernel::System::AuthSession - global session interface

=head1 SYNOPSIS

All session functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get configured session backend
    my $GenericModule = $Kernel::OM->Get('Kernel::Config')->Get('SessionModule');
    $GenericModule ||= 'Kernel::System::AuthSession::DB';

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # load session backend module
    if ( !$MainObject->Require($GenericModule) ) {
        $MainObject->Die("Can't load backend module $GenericModule! $@");
    }

    $Self->{Backend} = $GenericModule->new();

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    for my $SessionLimitConfigKey (
        qw(AgentSessionLimitPriorWarning AgentSessionLimit AgentSessionPerUserLimit CustomerSessionLimit CustomerSessionPerUserLimit)
        )
    {
        $Self->{$SessionLimitConfigKey} = $ConfigObject->Get($SessionLimitConfigKey);
    }

    return $Self;
}

=item CheckSessionID()

checks a session, returns true (session ok) or false (session invalid)

    my $Ok = $SessionObject->CheckSessionID(
        SessionID => '1234567890123456',
    );

=cut

sub CheckSessionID {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->CheckSessionID(%Param);
}

=item CheckAgentSessionLimitPriorWarning()

Get the agent session limit prior warning message, if the limit is reached.

    my $PriorMessage = $SessionObject->CheckAgentSessionLimitPriorWarning();

 returns the prior warning message (AgentSessionLimitPriorWarning reached) or false (AgentSessionLimitPriorWarning not reached)

=cut

sub CheckAgentSessionLimitPriorWarning {
    my ( $Self, %Param ) = @_;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $Cache       = $CacheObject->Get(
        Type => 'AuthSession',
        Key  => 'AgentSessionLimitPriorWarningMessage',
    );
    return $Cache if defined $Cache;

    my %OTRSBusinessSystemData = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGroupGet(
        Group => 'OTRSBusiness',
    );

    my $SessionLimitPriorWarning = $OTRSBusinessSystemData{AgentSessionLimitPriorWarning};
    if (
        !$SessionLimitPriorWarning
        || (
            $Self->{AgentSessionLimitPriorWarning}
            && $Self->{AgentSessionLimitPriorWarning} < $SessionLimitPriorWarning
        )
        )
    {
        $SessionLimitPriorWarning = $Self->{AgentSessionLimitPriorWarning};
    }

    my $PriorWarningMessage = '';
    if ($SessionLimitPriorWarning) {

        my %ActiveSessions = $Self->GetActiveSessions(
            UserType => 'User',
        );

        if ( defined $ActiveSessions{Total} && $ActiveSessions{Total} > $SessionLimitPriorWarning ) {

            if (
                $OTRSBusinessSystemData{AgentSessionLimitPriorWarning}
                && $OTRSBusinessSystemData{AgentSessionLimitPriorWarning} == $SessionLimitPriorWarning
                )
            {
                $PriorWarningMessage = 'You have exceeded the number of concurrent agents - contact sales@otrs.com.';
            }
            else {
                $PriorWarningMessage = 'Please note that the session limit is almost reached.';
            }
        }
    }

    $CacheObject->Set(
        Type  => 'AuthSession',
        TTL   => 60 * 15,
        Key   => 'AgentSessionLimitPriorWarningMessage',
        Value => $PriorWarningMessage,
    );

    return $PriorWarningMessage;
}

=item SessionIDErrorMessage()

returns an error in the session handling

    my $Message = $SessionObject->SessionIDErrorMessage();

=cut

sub SessionIDErrorMessage {
    my ( $Self, %Param ) = @_;

    return $Self->{SessionIDErrorMessage} || $Self->{Backend}->SessionIDErrorMessage(%Param);
}

=item GetSessionIDData()

get session data in a hash

    my %Data = $SessionObject->GetSessionIDData(
        SessionID => '1234567890123456',
    );

Returns:

    %Data = (
        UserSessionStart    => '1293801801',
        UserRemoteAddr      => '127.0.0.1',
        UserRemoteUserAgent => 'Some User Agent x.x',
        UserLastname        => 'SomeLastName',
        UserFirstname       => 'SomeFirstname',
        # and all other preferences values
    );

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

    if ( !$Param{UserType} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no UserType!'
        );
        return;
    }

    if ( $Param{UserType} ne 'User' && $Param{UserType} ne 'Customer' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got wrong UserType!'
        );
        return;
    }

    my %OTRSBusinessSystemData = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGroupGet(
        Group => 'OTRSBusiness',
    );

    my $SessionLimit;
    if ( $Param{UserType} eq 'User' ) {

        # Use the AgentSessionLimit from the business solution, if a session limit exists and use the AgentSessionLimit
        #   from the config, if the value is lower the business solution value.
        $SessionLimit = $OTRSBusinessSystemData{AgentSessionLimit};
        if ( !$SessionLimit || ( $Self->{AgentSessionLimit} && $Self->{AgentSessionLimit} < $SessionLimit ) ) {
            $SessionLimit = $Self->{AgentSessionLimit};
        }
    }
    elsif ( $Param{UserType} eq 'Customer' && $Self->{CustomerSessionLimit} ) {
        $SessionLimit = $Self->{CustomerSessionLimit};
    }


    # get session per user limit config
    my $SessionPerUserLimit;
    if ( $Param{UserType} eq 'User' && $Self->{AgentSessionPerUserLimit} ) {
        $SessionPerUserLimit = $Self->{AgentSessionPerUserLimit};
    }
    elsif ( $Param{UserType} eq 'Customer' && $Self->{CustomerSessionPerUserLimit} ) {
        $SessionPerUserLimit = $Self->{CustomerSessionPerUserLimit};
    }

    my $SessionSource = $Param{SessionSource} || '';

    # Don't check the session limit for sessions from the source 'GenericInterface'.
    if ( $SessionSource ne 'GenericInterface' && ( $SessionLimit || $SessionPerUserLimit ) ) {

        my %ActiveSessions = $Self->GetActiveSessions(%Param);

        if ( $SessionLimit && defined $ActiveSessions{Total} && $ActiveSessions{Total} >= $SessionLimit ) {

            if (
                $Param{UserType} eq 'User'
                && $OTRSBusinessSystemData{AgentSessionLimit}
                && $OTRSBusinessSystemData{AgentSessionLimit} == $SessionLimit
                )
            {
                $Self->{SessionIDErrorMessage}
                    = 'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!';
            }
            else {
                $Self->{SessionIDErrorMessage} = 'Session limit reached! Please try again later.';
            }
            return;
        }

        if (
            $SessionPerUserLimit
            && $Param{UserLogin}
            && defined $ActiveSessions{PerUser}->{ $Param{UserLogin} }
            && $ActiveSessions{PerUser}->{ $Param{UserLogin} } >= $SessionPerUserLimit
            )
        {

            $Self->{SessionIDErrorMessage} = 'Session per user limit reached!';

            return;
        }
    }

    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'AuthSession',
        Key  => 'AgentSessionLimitPriorWarningMessage',
    );

    return $Self->{Backend}->CreateSessionID(%Param);
}

=item RemoveSessionID()

removes a session and returns true (session deleted), false (if
session can't get deleted)

    $SessionObject->RemoveSessionID(SessionID => '1234567890123456');

=cut

sub RemoveSessionID {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'AuthSession',
        Key  => 'AgentSessionLimitPriorWarningMessage',
    );

    return $Self->{Backend}->RemoveSessionID(%Param);
}

=item UpdateSessionID()

update session info by key and value, returns true (if ok) and
false (if can't update)

    $SessionObject->UpdateSessionID(
        SessionID => '1234567890123456',
        Key       => 'LastScreenOverview',
        Value     => 'SomeInfo',
    );

=cut

sub UpdateSessionID {
    my ( $Self, %Param ) = @_;

    if ( $Param{Key} ) {

        my @Parts = split /:/, $Param{Key};

        if ( defined $Parts[1] ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't update key: '$Param{Key}' because ':' is not allowed!",
            );
            return;
        }
    }

    return $Self->{Backend}->UpdateSessionID(%Param);
}

=item GetExpiredSessionIDs()

returns a array of an array of session ids that have expired,
and one array of session ids that have been idle for too long.

    my @Sessions = $SessionObject->GetExpiredSessionIDs();

    my @ExpiredSession = @{$Session[0]};
    my @ExpiredIdle    = @{$Session[1]};

=cut

sub GetExpiredSessionIDs {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->GetExpiredSessionIDs(%Param);
}

=item GetAllSessionIDs()

returns an array with all session ids

    my @Sessions = $SessionObject->GetAllSessionIDs();

=cut

sub GetAllSessionIDs {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->GetAllSessionIDs(%Param);
}

=item GetActiveSessions()

Get the current active sessions for the given UserType.

    my %Result = $SessionObject->GetActiveSessions(
        UserType => '(User|Customer)',
    );

returns

    %Result = (
        Total => 8,
        PerUser => {
            UserID1 => 2,
            UserID2 => 1,
        },
    );

=cut

sub GetActiveSessions {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserType} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no UserType!'
        );
        return;
    }

    if ( $Param{UserType} ne 'User' && $Param{UserType} ne 'Customer' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got wrong UserType!'
        );
        return;
    }

    return $Self->{Backend}->GetActiveSessions(%Param);
}

=item CleanUp()

cleanup of sessions in your system

    $SessionObject->CleanUp();

=cut

sub CleanUp {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'AuthSession',
        Key  => 'AgentSessionLimitPriorWarningMessage',
    );

    return $Self->{Backend}->CleanUp(%Param);
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
