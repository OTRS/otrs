# --
# Auth.pm - provides the authentification and user data
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Auth.pm,v 1.8 2002-05-12 19:16:01 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Auth; 

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # 0=off; 1=on;
    $Self->{Debug} = 0;

    # check needed objects
    foreach ('LogObject', 'ConfigObject', 'DBObject') {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # get wduser table
    $Self->{UserTable} = $Self->{ConfigObject}->Get('DatabaseUserTable') 
      || 'user';
    $Self->{UserTableUserID} = $Self->{ConfigObject}->Get('DatabaseUserTableUserID')
	  || 'id';
    $Self->{UserTableUserPW} = $Self->{ConfigObject}->Get('DatabaseUserTableUserPW')
      || 'pw';
    $Self->{UserTableUser} = $Self->{ConfigObject}->Get('DatabaseUserTableUser')
	  || 'login';

    return $Self;
}
# --
sub Auth {
    my $Self = shift;
    my %Param = @_;
    my $User = $Param{User} || return;
    my $Pw = $Param{Pw} || '';
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    my $UserID = '';
    my $GetPw = '';
    my $SQL = "SELECT $Self->{UserTableUserPW}, $Self->{UserTableUserID} ".
      " FROM ".
      " $Self->{UserTable} ".
      " WHERE ". 
      " valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ".
      " AND ".
      " $Self->{UserTableUser} = '$User'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) { 
        $GetPw = $RowTmp[0];
        $UserID = $RowTmp[1];
    }

    # --
    # just in case!
    # --
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: '$User' tried to login with Pw: '$Pw' ($UserID/$GetPw/$RemoteAddr)",
        );
    }

    # --
    # just a note 
    # --
    if (!$Pw) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: $User without Pw!!! (REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }
    # --
    # login note
    # --
    elsif ((($GetPw)&&($User)&&($UserID)) && crypt($Pw, $User) eq $GetPw) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: $User logged in (REMOTE_ADDR: $RemoteAddr).",
        );
        return 1;
    }
    # --
    # just a note
    # --
    elsif (($UserID) && ($GetPw)) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: $User with wrong Pw!!! (REMOTE_ADDR: $RemoteAddr)"
        ); 
        return;
    }
    # --
    # just a note
    # --
    else {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: $User doesn't exist or is invalid!!! (REMOTE_ADDR: $RemoteAddr)"
        ); 
        return;
    }
}
# --

1;

