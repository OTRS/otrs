# --
# Kernel/System/AuthSession/FS.pm - provides session filesystem backend
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: FS.pm,v 1.48 2012-10-23 08:24:19 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::AuthSession::FS;

use strict;
use warnings;
umask 002;

use Digest::MD5;
use Storable;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.48 $) [1];

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
    $Self->{SessionSpool} = $Self->{ConfigObject}->Get('SessionDir');
    $Self->{SystemID}     = $Self->{ConfigObject}->Get('SystemID');

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
    $Self->{CheckSessionIDMessage} = 'SessionID is invalid!!!';

    # session id check
    my %Data = $Self->GetSessionIDData( SessionID => $Param{SessionID} );

    if ( !$Data{UserID} || !$Data{UserLogin} ) {
        $Self->{CheckSessionIDMessage} = 'SessionID invalid! Need user data!';
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

        $Self->{CheckSessionIDMessage} = 'Session has timed out. Please log in again.';

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

        $Self->{CheckSessionIDMessage} = 'Session has timed out. Please log in again.';

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

sub CheckSessionIDMessage {
    my ( $Self, %Param ) = @_;

    return $Self->{CheckSessionIDMessage} || '';
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
        Filename        => $Param{SessionID},
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

    # get remote address and the http user agent
    my $RemoteAddr      = $ENV{REMOTE_ADDR}     || 'none';
    my $RemoteUserAgent = $ENV{HTTP_USER_AGENT} || 'none';

    # get system time
    my $TimeNow = $Self->{TimeObject}->SystemTime();

    # create session id
    my $md5 = Digest::MD5->new();
    $md5->add(
        ( $TimeNow . int( rand(999999999) ) . $Self->{SystemID} ) . $RemoteAddr . $RemoteUserAgent
    );
    my $SessionID = $Self->{SystemID} . $md5->hexdigest;

    # create challenge token
    $md5 = Digest::MD5->new();
    $md5->add( $TimeNow . $SessionID );
    my $ChallengeToken = $md5->hexdigest;

    my %Data;
    KEY:
    for my $Key ( keys %Param ) {

        next KEY if !defined $Param{$Key};

        $Data{$Key} = $Param{$Key};
    }

    $Data{UserSessionStart}    = $TimeNow;
    $Data{UserRemoteAddr}      = $RemoteAddr;
    $Data{UserRemoteUserAgent} = $RemoteUserAgent;
    $Data{UserChallengeToken}  = $ChallengeToken;

    # dump the data
    my $Dump = Storable::nfreeze( \%Data );

    # write file
    my $FileLocation = $Self->{MainObject}->FileWrite(
        Directory       => $Self->{SessionSpool},
        Filename        => $SessionID,
        Content         => \$Dump,
        Type            => 'Local',
        Mode            => 'binmode',
        Permission      => '664',
        DisableWarnings => 1,
    );

    return if !$FileLocation;

    # set cache
    $Self->{Cache}->{$SessionID} = \%Data;

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
    my $Delete = $Self->{MainObject}->FileDelete(
        Directory       => $Self->{SessionSpool},
        Filename        => $Param{SessionID},
        Type            => 'Local',
        DisableWarnings => 1,
    );

    return if !$Delete;

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
        Filter    => "$Self->{SystemID}*",
    );

    my @SessionIDs;
    for my $SessionID (@List) {
        $SessionID =~ s!^.*/!!;
        push @SessionIDs, $SessionID;
    }

    return @SessionIDs;
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

            # extract key value pair
            my $Value = $Self->{Cache}->{$SessionID}->{$Key};

            next KEY if !defined $Value;

            $SessionData{$Key} = $Value;
        }

        # dump the data
        my $Dump = Storable::nfreeze( \%SessionData );

        # write file
        my $FileLocation = $Self->{MainObject}->FileWrite(
            Directory       => $Self->{SessionSpool},
            Filename        => $SessionID,
            Content         => \$Dump,
            Type            => 'Local',
            Mode            => 'binmode',
            Permission      => '664',
            DisableWarnings => 1,
        );
    }

    # remove cached data
    delete $Self->{Cache};

    return 1;
}

1;
