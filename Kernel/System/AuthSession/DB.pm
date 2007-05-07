# --
# Kernel/System/AuthSession/DB.pm - provides session db backend
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: DB.pm,v 1.27 2007-05-07 08:23:41 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession::DB;

use strict;
use Digest::MD5;
use MIME::Base64;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = '$Revision: 1.27 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(LogObject ConfigObject DBObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }
    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);
    # get more common params
    $Self->{SystemID} = $Self->{ConfigObject}->Get('SystemID');
    # Debug 0=off 1=on
    $Self->{Debug} = 0;
    # session table data
    $Self->{SQLSessionTable} = $Self->{ConfigObject}->Get('SessionTable') || 'sessions';
    # id row
    $Self->{SQLSessionTableID} = $Self->{ConfigObject}->Get('SessionTableID') || 'session_id';
    # value row
    $Self->{SQLSessionTableValue} = $Self->{ConfigObject}->Get('SessionTableValue') || 'session_value';

    return $Self;
}

sub CheckSessionID {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID};
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';
    # set default message
    $Self->{CheckSessionIDMessage} = "SessionID is invalid!!!";
    # session id check
    my %Data = $Self->GetSessionIDData(SessionID => $SessionID);

    if (!$Data{UserID} || !$Data{UserLogin}) {
        $Self->{CheckSessionIDMessage} = "SessionID invalid! Need user data!";
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "SessionID: '$SessionID' is invalid!!!",
        );
        return;
    }
    # remote ip check
    if ($Data{UserRemoteAddr} ne $RemoteAddr &&
        $Self->{ConfigObject}->Get('SessionCheckRemoteIP') ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "RemoteIP of '$SessionID' ($Data{UserRemoteAddr}) is different with the ".
                "request IP ($RemoteAddr). Don't grant access!!!",
        );
        # delete session id if it isn't the same remote ip?
        if ($Self->{ConfigObject}->Get('SessionDeleteIfNotRemoteID')) {
            $Self->RemoveSessionID(SessionID => $SessionID);
        }
        return;
    }
    # check session idle time
    my $MaxSessionIdleTime = $Self->{ConfigObject}->Get('SessionMaxIdleTime');
    if ( ($Self->{TimeObject}->SystemTime() - $MaxSessionIdleTime) >= $Data{UserLastRequest} ) {
        $Self->{CheckSessionIDMessage} = 'Session has timed out. Please log in again.';
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "SessionID ($SessionID) idle timeout (". int(($Self->{TimeObject}->SystemTime() - $Data{UserLastRequest})/(60*60))
                ."h)! Don't grant access!!!",
        );
        # delete session id if too old?
        if ($Self->{ConfigObject}->Get('SessionDeleteIfTimeToOld')) {
            $Self->RemoveSessionID(SessionID => $SessionID);
        }
        return;
    }
    # check session time
    my $MaxSessionTime = $Self->{ConfigObject}->Get('SessionMaxTime');
    if ( ($Self->{TimeObject}->SystemTime() - $MaxSessionTime) >= $Data{UserSessionStart} ) {
        $Self->{CheckSessionIDMessage} = 'Session has timed out. Please log in again.';
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "SessionID ($SessionID) too old (". int(($Self->{TimeObject}->SystemTime() - $Data{UserSessionStart})/(60*60))
                ."h)! Don't grant access!!!",
        );
        # delete session id if too old?
        if ($Self->{ConfigObject}->Get('SessionDeleteIfTimeToOld')) {
            $Self->RemoveSessionID(SessionID => $SessionID);
        }
        return;
    }
    return 1;
}

sub CheckSessionIDMessage {
    my $Self = shift;
    my %Param = @_;
    return $Self->{CheckSessionIDMessage} || '';
}

sub GetSessionIDData {
    my $Self = shift;
    my %Param = @_;
    my $Strg = '';
    my %Data;
    # check session id
    if (!$Param{SessionID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Got no SessionID!!");
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # read data
    my $SQL = "SELECT $Self->{SQLSessionTableValue} ".
        " FROM ".
        " $Self->{SQLSessionTable} ".
        " WHERE ".
        " $Self->{SQLSessionTableID} = '$Param{SessionID}'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Strg = $Row[0];
    }
    # split data
    my @StrgData = split(/;/, $Strg);
    foreach (@StrgData) {
        my @PaarData = split(/:/, $_);
        if ($PaarData[1]) {
            $Data{$PaarData[0]} = decode_base64($PaarData[1]);
        }
        else {
            $Data{$PaarData[0]} = '';
        }
        # Debug
        if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "GetSessionIDData: '$PaarData[0]:".decode_base64($PaarData[1])."'",
            );
        }
    }
    # return data
    return %Data;
}

sub CreateSessionID {
    my $Self = shift;
    my %Param = @_;
    # get REMOTE_ADDR
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';
    # get HTTP_USER_AGENT
    my $RemoteUserAgent = $ENV{HTTP_USER_AGENT} || 'none';
    # create SessionID
    my $md5 = Digest::MD5->new();
    $md5->add(
        ($Self->{TimeObject}->SystemTime() . int(rand(999999999)) . $Self->{SystemID}) . $RemoteAddr . $RemoteUserAgent
    );
    my $SessionID = $Self->{SystemID} . $md5->hexdigest;
    # data 2 strg
    my $DataToStore = '';
    foreach (keys %Param) {
        if (defined($Param{$_})) {
            $Self->{EncodeObject}->EncodeOutput(\$Param{$_});
            $DataToStore .= "$_:".encode_base64($Param{$_}, '').":;";
        }
    }
    $DataToStore .= "UserSessionStart:" . encode_base64($Self->{TimeObject}->SystemTime(), '') .":;";
    $DataToStore .= "UserRemoteAddr:" . encode_base64($RemoteAddr, '') .":;";
    $DataToStore .= "UserRemoteUserAgent:". encode_base64($RemoteUserAgent, '') .":;";
    # store SessionID + data
    # quote params
    $DataToStore = $Self->{DBObject}->Quote($DataToStore) || '';
    my $SQL = "INSERT INTO $Self->{SQLSessionTable} ".
        " ($Self->{SQLSessionTableID}, $Self->{SQLSessionTableValue}) ".
        " VALUES ".
        " ('$SessionID', ?)";
    $Self->{DBObject}->Do(SQL => $SQL, Bind => [\$DataToStore]);

    return $SessionID;
}

sub RemoveSessionID {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID};
    # delete db recode
    if (!$Self->{DBObject}->Do(
        SQL => "DELETE FROM $Self->{SQLSessionTable} ".
            " WHERE $Self->{SQLSessionTableID} = '$SessionID'"
    )) {
        return;
    }
    else {
        # log event
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Removed SessionID $Param{SessionID}."
        );
        return 1;
    }
}

sub UpdateSessionID {
    my $Self = shift;
    my %Param = @_;
    my $Key = defined($Param{Key}) ? $Param{Key} : '';
    my $Value = defined($Param{Value}) ? $Param{Value} : '';
    my $SessionID = $Param{SessionID};
    # check needed stuff
    if (!$SessionID) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need SessionID!",
        );
        return;
    }
    my %SessionData = $Self->GetSessionIDData(SessionID => $SessionID);
    # check needed update! (no changes)
    if (((exists $SessionData{$Key}) && $SessionData{$Key} eq $Value) || (!exists $SessionData{$Key} && $Value eq '')) {
        return 1;
    }
    # update the value
    $SessionData{$Key} = $Value;
    # set new data sting
    my $NewDataToStore = '';
    foreach (keys %SessionData) {
        $Self->{EncodeObject}->EncodeOutput(\$SessionData{$_});
        $NewDataToStore .= "$_:".encode_base64($SessionData{$_}, '').":;";
        # Debug
        if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "UpdateSessionID: $_=$SessionData{$_}",
            );
        }
    }
    # update db enrty
    my $SQL = "UPDATE $Self->{SQLSessionTable} ".
        " SET ".
        " $Self->{SQLSessionTableValue} = ? ".
        " WHERE ".
        " $Self->{SQLSessionTableID} = '".$Self->{DBObject}->Quote($SessionID)."'";
    return $Self->{DBObject}->Do(SQL => $SQL, Bind => [\$NewDataToStore]);
}

sub GetAllSessionIDs {
    my $Self = shift;
    my %Param = @_;
    my @SessionIDs = ();
    # read data
    my $SQL = "SELECT $Self->{SQLSessionTableID} ".
        " FROM ".
        " $Self->{SQLSessionTable}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        push (@SessionIDs,  $RowTmp[0]);
    }
    return @SessionIDs;
}

sub CleanUp {
    my $Self = shift;
    my %Param = @_;
    # delete db recodes
    if ($Self->{DBObject}->Do(SQL => "DELETE FROM $Self->{SQLSessionTable}")) {
        return 1;
    }
    else {
        return;
    }
}

1;
