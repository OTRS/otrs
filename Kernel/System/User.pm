# --
# User.pm - some user functions
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: User.pm,v 1.3 2002-04-13 11:12:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::User;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach ('DBObject', 'ConfigObject') {
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
    my $Key = $Param{Key};
    my $Value = $Param{Value};

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
    my %Preferences = $Self->GetPreferences(UserID => $Data{UserID});

    return (%Data, %Preferences);
}
# --


1;
