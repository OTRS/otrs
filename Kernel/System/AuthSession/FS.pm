# --
# Kernel/System/AuthSession/FS.pm - provides session filesystem backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::AuthSession::FS;

use strict;
use warnings;

use Storable;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject TimeObject MainObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # get more common params
    $Self->{SessionSpool}         = $Self->{ConfigObject}->Get('SessionDir');
    $Self->{SystemID}             = $Self->{ConfigObject}->Get('SystemID');
    $Self->{AgentSessionLimit}    = $Self->{ConfigObject}->Get('AgentSessionLimit');
    $Self->{CustomerSessionLimit} = $Self->{ConfigObject}->Get('CustomerSessionLimit');
    $Self->{SessionActiveTime}    = $Self->{ConfigObject}->Get('SessionActiveTime') || 60 * 10;

    return $Self;
}

sub CheckSessionID {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no SessionID!!' );
        return;
    }
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';

    # set default message
    $Self->{SessionIDErrorMessage} = 'Session invalid. Please log in again.';

    # session id check
    my %Data = $Self->GetSessionIDData( SessionID => $Param{SessionID} );

    if ( !$Data{UserID} || !$Data{UserLogin} ) {
        $Self->{SessionIDErrorMessage} = 'Session invalid. Please log in again.';
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "SessionID: '$Param{SessionID}' is invalid!!!",
        );
        return;
    }

    # remote ip check
    if (
        $Data{UserRemoteAddr} ne $RemoteAddr
        && $Self->{ConfigObject}->Get('SessionCheckRemoteIP')
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "RemoteIP of '$Param{SessionID}' ($Data{UserRemoteAddr}) is "
                . "different from registered IP ($RemoteAddr). Invalidating session!"
                . " Disable config 'SessionCheckRemoteIP' if you don't want this!",
        );

        # delete session id if it isn't the same remote ip?
        if ( $Self->{ConfigObject}->Get('SessionDeleteIfNotRemoteID') ) {
            $Self->RemoveSessionID( SessionID => $Param{SessionID} );
        }

        return;
    }

    # check session idle time
    my $TimeNow            = $Self->{TimeObject}->SystemTime();
    my $MaxSessionIdleTime = $Self->{ConfigObject}->Get('SessionMaxIdleTime');

    if ( ( $TimeNow - $MaxSessionIdleTime ) >= $Data{UserLastRequest} ) {

        $Self->{SessionIDErrorMessage} = 'Session has timed out. Please log in again.';

        my $Timeout = int( ( $TimeNow - $Data{UserLastRequest} ) / ( 60 * 60 ) );

        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "SessionID ($Param{SessionID}) idle timeout ($Timeout h)! Don't grant access!!!",
        );

        # delete session id if too old?
        if ( $Self->{ConfigObject}->Get('SessionDeleteIfTimeToOld') ) {
            $Self->RemoveSessionID( SessionID => $Param{SessionID} );
        }

        return;
    }

    # check session time
    my $MaxSessionTime = $Self->{ConfigObject}->Get('SessionMaxTime');

    if ( ( $TimeNow - $MaxSessionTime ) >= $Data{UserSessionStart} ) {

        $Self->{SessionIDErrorMessage} = 'Session has timed out. Please log in again.';

        my $Timeout = int( ( $TimeNow - $Data{UserSessionStart} ) / ( 60 * 60 ) );

        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "SessionID ($Param{SessionID}) too old ($Timeout h)! Don't grant access!!!",
        );

        # delete session id if too old?
        if ( $Self->{ConfigObject}->Get('SessionDeleteIfTimeToOld') ) {
            $Self->RemoveSessionID( SessionID => $Param{SessionID} );
        }

        return;
    }

    return 1;
}

sub SessionIDErrorMessage {
    my ( $Self, %Param ) = @_;

    return $Self->{SessionIDErrorMessage} || '';
}

sub GetSessionIDData {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no SessionID!!' );
        return;
    }

    # check cache
    return %{ $Self->{Cache}->{ $Param{SessionID} } }
        if $Self->{Cache}->{ $Param{SessionID} };

    # read data
    my $Content = $Self->{MainObject}->FileRead(
        Directory       => $Self->{SessionSpool},
        Filename        => 'Data-' . $Param{SessionID},
        Type            => 'Local',
        Mode            => 'binmode',
        DisableWarnings => 1,
    );

    return if !$Content;
    return if ref $Content ne 'SCALAR';

    # read data structure back from file dump, use block eval for safety reasons
    my $Session = eval { Storable::thaw( ${$Content} ) };

    if ( !$Session || ref $Session ne 'HASH' ) {
        delete $Self->{Cache}->{ $Param{SessionID} };
        return;
    }

    # cache result
    $Self->{Cache}->{ $Param{SessionID} } = $Session;

    return %{$Session};
}

sub CreateSessionID {
    my ( $Self, %Param ) = @_;

    # get system time
    my $TimeNow = $Self->{TimeObject}->SystemTime();

    # get session limit config
    my $SessionLimit;
    if ( $Param{UserType} && $Param{UserType} eq 'User' && $Self->{AgentSessionLimit} ) {
        $SessionLimit = $Self->{AgentSessionLimit};
    }
    elsif ( $Param{UserType} && $Param{UserType} eq 'Customer' && $Self->{CustomerSessionLimit} ) {
        $SessionLimit = $Self->{CustomerSessionLimit};
    }

    if ($SessionLimit) {

        # read data
        my @List = $Self->{MainObject}->DirectoryRead(
            Directory => $Self->{SessionSpool},
            Filter    => 'State-' . $Self->{SystemID} . '*',
        );

        my $ActiveSessionCount = 0;
        SESSIONID:
        for my $SessionID (@List) {

            $SessionID =~ s!^.*/!!;
            $SessionID =~ s{ State- } {}xms;

            next SESSIONID if !$SessionID;

            # read state data
            my $StateData = $Self->{MainObject}->FileRead(
                Directory       => $Self->{SessionSpool},
                Filename        => 'State-' . $SessionID,
                Type            => 'Local',
                Mode            => 'binmode',
                DisableWarnings => 1,
            );

            next SESSIONID if !$StateData;
            next SESSIONID if ref $StateData ne 'SCALAR';

            my @SessionData = split '####', ${$StateData};

            # get needed timestamps
            my $UserType        = $SessionData[0] || '';
            my $UserLastRequest = $SessionData[2] || $TimeNow;

            next SESSIONID if $UserType ne $Param{UserType};

            next SESSIONID if ( $UserLastRequest + $Self->{SessionActiveTime} ) < $TimeNow;

            $ActiveSessionCount++;

            next SESSIONID if $ActiveSessionCount < $SessionLimit;

            $Self->{SessionIDErrorMessage} = 'Session limit reached! Please try again later.';

            return;
        }
    }

    # get remote address and the http user agent
    my $RemoteAddr      = $ENV{REMOTE_ADDR}     || 'none';
    my $RemoteUserAgent = $ENV{HTTP_USER_AGENT} || 'none';

    # create session id
    my $SessionID = $Self->{MainObject}->GenerateRandomString(
        Length => 32,
    );

    # create challenge token
    my $ChallengeToken = $Self->{MainObject}->GenerateRandomString(
         Length => 32,
    ); 

    my %Data;
    KEY:
    for my $Key ( sort keys %Param ) {

        next KEY if !$Key;

        $Data{$Key} = $Param{$Key};
    }

    $Data{UserSessionStart}    = $TimeNow;
    $Data{UserRemoteAddr}      = $RemoteAddr;
    $Data{UserRemoteUserAgent} = $RemoteUserAgent;
    $Data{UserChallengeToken}  = $ChallengeToken;

    # dump the data
    my $DataContent = Storable::nfreeze( \%Data );

    # write data file
    my $FileLocation = $Self->{MainObject}->FileWrite(
        Directory       => $Self->{SessionSpool},
        Filename        => 'Data-' . $SessionID,
        Content         => \$DataContent,
        Type            => 'Local',
        Mode            => 'binmode',
        Permission      => '660',
        DisableWarnings => 1,
    );

    return if !$FileLocation;

    # set cache
    $Self->{Cache}->{$SessionID} = \%Data;

    # create needed state content
    my $UserType         = $Self->{Cache}->{$SessionID}->{UserType}         || '';
    my $UserSessionStart = $Self->{Cache}->{$SessionID}->{UserSessionStart} || '';
    my $UserLastRequest  = $Self->{Cache}->{$SessionID}->{UserLastRequest}  || '';

    my $StateContent = $UserType . '####' . $UserSessionStart . '####' . $UserLastRequest;

    # write state file
    $Self->{MainObject}->FileWrite(
        Directory       => $Self->{SessionSpool},
        Filename        => 'State-' . $SessionID,
        Content         => \$StateContent,
        Type            => 'Local',
        Mode            => 'binmode',
        Permission      => '660',
        DisableWarnings => 1,
    );

    return $SessionID;
}

sub RemoveSessionID {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no SessionID!!' );
        return;
    }

    # delete file
    my $DeleteData = $Self->{MainObject}->FileDelete(
        Directory       => $Self->{SessionSpool},
        Filename        => 'Data-' . $Param{SessionID},
        Type            => 'Local',
        DisableWarnings => 1,
    );
    my $DeleteState = $Self->{MainObject}->FileDelete(
        Directory       => $Self->{SessionSpool},
        Filename        => 'State-' . $Param{SessionID},
        Type            => 'Local',
        DisableWarnings => 1,
    );

    return if !$DeleteData;
    return if !$DeleteState;

    # reset cache
    delete $Self->{Cache}->{ $Param{SessionID} };

    # log event
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "Removed SessionID $Param{SessionID}."
    );

    return 1;
}

sub UpdateSessionID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(SessionID Key)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check cache
    if ( !$Self->{Cache}->{ $Param{SessionID} } ) {
        my %SessionData = $Self->GetSessionIDData( SessionID => $Param{SessionID} );

        $Self->{Cache}->{ $Param{SessionID} } = \%SessionData;
    }

    # update the value, set cache
    $Self->{Cache}->{ $Param{SessionID} }->{ $Param{Key} } = $Param{Value};

    return 1;
}

sub GetAllSessionIDs {
    my ( $Self, %Param ) = @_;

    # read data
    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{SessionSpool},
        Filter    => 'Data-' . $Self->{SystemID} . '*',
    );

    my @SessionIDs;
    for my $SessionID (@List) {
        $SessionID =~ s!^.*/!!;
        $SessionID =~ s{ Data- } {}xms;
        push @SessionIDs, $SessionID;
    }

    return @SessionIDs;
}

sub GetExpiredSessionIDs {
    my ( $Self, %Param ) = @_;

    # get config
    my $MaxSessionTime     = $Self->{ConfigObject}->Get('SessionMaxTime');
    my $MaxSessionIdleTime = $Self->{ConfigObject}->Get('SessionMaxIdleTime');

    # get current time
    my $TimeNow = $Self->{TimeObject}->SystemTime();

    # read data
    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{SessionSpool},
        Filter    => 'State-' . $Self->{SystemID} . '*',
    );

    my @ExpiredSession;
    my @ExpiredIdle;
    SESSIONID:
    for my $SessionID (@List) {

        $SessionID =~ s!^.*/!!;
        $SessionID =~ s{ State- } {}xms;

        next SESSIONID if !$SessionID;

        # read state data
        my $StateData = $Self->{MainObject}->FileRead(
            Directory       => $Self->{SessionSpool},
            Filename        => 'State-' . $SessionID,
            Type            => 'Local',
            Mode            => 'binmode',
            DisableWarnings => 1,
        );

        next SESSIONID if !$StateData;
        next SESSIONID if ref $StateData ne 'SCALAR';

        my @SessionData = split '####', ${$StateData};

        # get needed timestamps
        my $UserSessionStart = $SessionData[1] || $TimeNow;
        my $UserLastRequest  = $SessionData[2] || $TimeNow;

        # time calculation
        my $ValidTime     = $UserSessionStart + $MaxSessionTime - $TimeNow;
        my $ValidIdleTime = $UserLastRequest + $MaxSessionIdleTime - $TimeNow;

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

sub CleanUp {
    my ( $Self, %Param ) = @_;

    # delete fs files
    my @SessionIDs = $Self->GetAllSessionIDs();

    return 1 if !@SessionIDs;

    SESSIONID:
    for my $SessionID (@SessionIDs) {

        next SESSIONID if !$SessionID;

        $Self->RemoveSessionID( SessionID => $SessionID );
    }

    return 1;
}

sub DESTROY {
    my ( $Self, %Param ) = @_;

    return 1 if !$Self->{Cache};

    SESSIONID:
    for my $SessionID ( sort keys %{ $Self->{Cache} } ) {

        next SESSIONID if !$SessionID;

        my %SessionData;
        KEY:
        for my $Key ( sort keys %{ $Self->{Cache}->{$SessionID} } ) {

            next KEY if !$Key;

            $SessionData{$Key} = $Self->{Cache}->{$SessionID}->{$Key};
        }

        # dump the data
        my $DataContent = Storable::nfreeze( \%SessionData );

        # write data file
        $Self->{MainObject}->FileWrite(
            Directory       => $Self->{SessionSpool},
            Filename        => 'Data-' . $SessionID,
            Content         => \$DataContent,
            Type            => 'Local',
            Mode            => 'binmode',
            Permission      => '660',
            DisableWarnings => 1,
        );

        # create needed state content
        my $UserType         = $Self->{Cache}->{$SessionID}->{UserType}         || '';
        my $UserSessionStart = $Self->{Cache}->{$SessionID}->{UserSessionStart} || '';
        my $UserLastRequest  = $Self->{Cache}->{$SessionID}->{UserLastRequest}  || '';

        my $StateContent = $UserType . '####' . $UserSessionStart . '####' . $UserLastRequest;

        # write state file
        $Self->{MainObject}->FileWrite(
            Directory       => $Self->{SessionSpool},
            Filename        => 'State-' . $SessionID,
            Content         => \$StateContent,
            Type            => 'Local',
            Mode            => 'binmode',
            Permission      => '660',
            DisableWarnings => 1,
        );
    }

    # remove cached data
    delete $Self->{Cache};

    return 1;
}

1;
