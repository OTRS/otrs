# --
# Auth.pm - provides the authentification and user data
# Copyright (C) 2001,2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Auth.pm,v 1.5 2002-04-12 16:33:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Auth; 

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
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

    # preferences table data
    $Self->{PreferencesTable} = $Self->{ConfigObject}->Get('DatabasePreferencesTable') 
      || 'user_preferences';
    $Self->{PreferencesTableKey} = $Self->{ConfigObject}->Get('DatabasePreferencesTableKey')
	  || 'preferences_key';
    $Self->{PreferencesTableValue} = $Self->{ConfigObject}->Get('DatabasePreferencesTableValue')
	  || 'preferences_value';
    $Self->{PreferencesTableUserID} = $Self->{ConfigObject}->Get('DatabasePreferencesTableUserID') 
	  || 'user_id';

    return $Self;
}
# --
sub Auth {
    my $Self = shift;
    my %Param = @_;
    my $User = $Param{User} || return;
    my $Pw = $Param{Pw} || return;
    my $UserID = '';
    my $GetPw = '';
    my $SQL = "SELECT $Self->{UserTableUserPW}, $Self->{UserTableUserID} ".
      " FROM ".
      " $Self->{UserTable} ".
      " WHERE ". 
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
          MSG => "User: '$User' tried to login with Pw: '$Pw' ($UserID/$GetPw)",
        );
    }

    # --
    # just a note 
    # --
    if (!$Pw) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: $User without Pw!!!",
        );
        return;
    }
    # --
    # login note
    # --
    elsif ((($GetPw)&&($User)&&($UserID)) && crypt($Pw, $User) eq $GetPw) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: $User logged in.",
        );
        return 1;
    }
    # --
    # just a note
    # --
    else {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: $User with wrong Pw!!!"
        ); 
        return;
    }
}
# --
sub GetUserData {
    my $Self = shift;
    my %Param = @_;
    my $User = $Param{User};
    my %Data;

    # --
    # get inital data
    # --
    my $SQL = "SELECT su.$Self->{UserTableUserID}, su.salutation, su.first_name, su.last_name ".
        " FROM " .
        " $Self->{UserTable} as su " .
        " WHERE " .
        " su.$Self->{UserTableUser} = '$User'";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Data{UserID} = $RowTmp[0];
        $Data{UserLogin} = $User;
        $Data{UserFirstname} = $RowTmp[2];
        $Data{UserLastname} = $RowTmp[3];
    }

    # --
    # check data
    # --
    if (! exists $Data{UserID}) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "Panic! No UserData for user: '$User'!!!",
        );
        return;
    }

    # --
    # get preferences
    # --
    $SQL = "SELECT $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue} " .
        " FROM " .
        " $Self->{PreferencesTable} ".
        " WHERE " .
        " $Self->{PreferencesTableUserID} = $Data{UserID}";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Data{$RowTmp[0]} = $RowTmp[1];
    }

    # --
    # return data
    # --
    return %Data;
}
# --

1;

