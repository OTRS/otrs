# --
# User.pm - some user functions
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: User.pm,v 1.5 2002-05-12 22:05:10 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::User;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (
       'DBObject', 
       'ConfigObject',
       'LogObject',
    ) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
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
sub GetLockedCount {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID};
    my @LockIDs = (2);
    my %Data;

    $Self->{DBObject}->Prepare(
       SQL => "SELECT ar.id as ca, st.name, ti.id, ar.create_by" .
              " FROM " .
              " ticket ti, article ar, article_sender_type st" .
              " WHERE " .
              " ti.user_id = $UserID " .
              " AND " .
              " ti.ticket_lock_id in ( ${\(join ', ', @LockIDs)} )" .
              " AND " .
              " ar.ticket_id = ti.id " .
              " AND " .
              " st.id = ar.article_sender_type_id " .
              " ORDER BY ar.create_time DESC",
    );

    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        if (!$Data{"ID$RowTmp[2]"}) {
          $Data{'Count'}++;
          if ($RowTmp[1] ne 'agent' || $RowTmp[3] ne $UserID) {
            $Data{'ToDo'}++;
          }
        }
        $Data{"ID$RowTmp[2]"} = 1;
    }
    return %Data;
}
# --
sub GetGroups {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || return;
    my %Groups = ();

    my $SQL = "SELECT g.id, g.name " .
    " FROM " .
    " groups g, group_user gu".
    " WHERE " .
    " g.valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ".
    " AND ".
    " gu.user_id = $UserID".
    " AND " .
    " g.id = gu.group_id ";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
         $Groups{$RowTmp[0]} = $RowTmp[1];
    }

    return %Groups;
} 
# --
sub SetPreferences {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || return;
    my $Key = $Param{Key} || return;
    my $Value = $Param{Value} || '';

    # delete old data
    if (!$Self->{DBObject}->Do(
       SQL => "DELETE FROM $Self->{PreferencesTable} ".
              " WHERE ".
              " $Self->{PreferencesTableUserID} = $UserID ".
              " AND ".
              " $Self->{PreferencesTableKey} = '$Key'",
    )) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "Can't delete $Self->{PreferencesTable}!",
        );
        return;
    }

    # insert new data
    if (!$Self->{DBObject}->Do(
       SQL => "INSERT INTO $Self->{PreferencesTable} ($Self->{PreferencesTableUserID}, ".
              " $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue}) " .
              " VALUES ($UserID, '$Key', '$Value')",
    )) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "Can't insert new $Self->{PreferencesTable}!",
        );
        return;
    } 

    return 1;
}
# --
sub GetPreferences {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || return;
    my %Data;

    # --
    # get preferences
    # --
    my $SQL = "SELECT $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue} " .
        " FROM " .
        " $Self->{PreferencesTable} ".
        " WHERE " .
        " $Self->{PreferencesTableUserID} = $UserID";

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
sub GetUserData {
    my $Self = shift;
    my %Param = @_;
    my $User = $Param{User};
    my $UserID = $Param{UserID};
    my %Data;
    
    # --
    # get inital data
    # --
    my $SQL = "SELECT $Self->{UserTableUserID}, $Self->{UserTableUser}, ".
        " salutation, first_name, last_name, $Self->{UserTableUserPW}, valid_id ".
        " FROM " .
        " $Self->{UserTable} " .
        " WHERE ";
    if ($User) {
        $SQL .= " $Self->{UserTableUser} = '$User'";
    }
    else {
        $SQL .= " $Self->{UserTableUserID} = '$UserID'";
    }

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Data{UserID} = $RowTmp[0];
        $Data{UserLogin} = $RowTmp[1];
        $Data{UserSalutation} = $RowTmp[2];
        $Data{UserFirstname} = $RowTmp[3];
        $Data{UserLastname} = $RowTmp[4];
        $Data{UserPw} = $RowTmp[5];
        $Data{ValidID} = $RowTmp[6];
    }
    # --
    # check data
    # --
    if (! exists $Data{UserID} && ! $UserID) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "Panic! No UserData for user: '$User'!!!",
        );
        return;
    }

    # --
    # get preferences
    # --
    my %Preferences = $Self->GetPreferences(UserID => $Data{UserID});

    return (%Data, %Preferences);
}
# --
sub UserAdd {
    my $Self = shift;
    my %Param = @_;
    # --
    # qoute params
    # -- 
    my $UserParamsTmp = $Self->{ConfigObject}->{UserPreferencesMaskUse};
    foreach (my @UserParams = @$UserParamsTmp) {
       $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    $Param{Pw} = crypt($Param{Pw}, $Param{Login});
    my $SQL = "INSERT INTO $Self->{UserTable} " .
       "(salutation, " .
       " first_name, " .
       " last_name, " .
       " $Self->{UserTableUser}, " .
       " $Self->{UserTableUserPW}, " .
       " valid_id, create_time, create_by, change_time, change_by)" .
       " VALUES " .
       " ('$Param{Salutation}', " .
       " '$Param{Fristname}', " .
       " '$Param{Lastname}', " .
       " '$Param{Login}', " .
       " '$Param{Pw}', " .
       " $Param{ValidID}, current_timestamp, $Param{UserID}, ".
       " current_timestamp, $Param{UserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # --
      # get new user id
      # --
      $SQL = "SELECT $Self->{UserTableUserID} ".
        " FROM " .
        " $Self->{UserTable} " .
        " WHERE " .
        " $Self->{UserTableUser} = '$Param{Login}'";
      my $UserID = '';
      $Self->{DBObject}->Prepare(SQL => $SQL);
      while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $UserID = $RowTmp[0];
      }
      # --
      # log notice
      # --
      $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$Param{Login}' ID: '$UserID' created successfully ($Param{UserID})!",
      );

      return $UserID; 
    }
    else {
        return;
    }
}
# --
sub UserUpdate {
    my $Self = shift;
    my %Param = @_;
    # --
    # qoute params
    # -- 
    my $UserParamsTmp = $Self->{ConfigObject}->{UserPreferencesMaskUse};
    foreach (my @UserParams = @$UserParamsTmp) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
        $Param{$_} = '' if (!exists $Param{$_});
    }

    # get old pw
    my %UserData = $Self->GetUserData(UserID => $Param{ID});
        # --
        # check pw
        # --
        my $GetPw = $UserData{UserPw} || '';
        if ($GetPw ne $Param{Pw}) {
            $Self->SetPassword(UserLogin => $Param{Login}, PW => $Param{Pw});
        }

        # -- 
        # update db
        # --
        my $SQL = "UPDATE $Self->{UserTable} SET " .
        " salutation = '$Param{Salutation}', " .
        " first_name = '$Param{Fristname}'," .
        " last_name = '$Param{Lastname}', " .
        " $Self->{UserTableUser} = '$Param{Login}', " .
        " valid_id = $Param{ValidID}, " .
        " change_time = current_timestamp, " .
        " change_by = $Param{UserID} " .
        " WHERE $Self->{UserTableUserID} = $Param{ID}";
  
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # --
        # log notice
        # --
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$Param{Login}' updated successfully ($Param{UserID})!",
        );
        return 1;
    }
    else {
        return; 
    }
}   
# --
sub SetPassword {
    my $Self = shift;
    my %Param = @_;
    my $Pw = $Param{PW} || '';
    my $UserLogin = $Param{UserLogin} || return;

    # --
    # crypt pw
    # --    
    my $NewPw = crypt($Pw, $UserLogin);
    # --
    # update db
    # --
    if ($Self->{DBObject}->Do(
            SQL => "UPDATE $Self->{UserTable} ".
               " SET ".
               " $Self->{UserTableUserPW} = '$NewPw' ".
               " WHERE ".
               " $Self->{UserTableUser} = '$UserLogin'",
    )) {
        # --
        # log notice
        # --
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$UserLogin' changed password successfully!",
        );
        return 1;
    }
    else {
        return;
    }
}
# --

1;
