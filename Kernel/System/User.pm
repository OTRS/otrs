# --
# User.pm - some db functions fot user funktions
# Copyright (C) 2001,2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: User.pm,v 1.2 2002-04-12 16:33:35 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::User;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub GetLockedCount {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID};
    my @LockIDs = (2);
    my %Data;

    $Self->Prepare(
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

    while (my @RowTmp = $Self->FetchrowArray()) {
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

    $Self->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->FetchrowArray()) {
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
    if (!$Self->Do(
       SQL => "DELETE FROM user_preferences ".
              " WHERE ".
              " user_id = $UserID ".
              " AND ".
              " preferences_key = '$Key'",
    )) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "Can't delete user_preferences!",
        );
        return;
    }

    # insert new data
    if (!$Self->Do(
       SQL => "INSERT INTO user_preferences (user_id, preferences_key, preferences_value) " .
                " VALUES ($UserID, '$Key', '$Value')",
    )) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "Can't insert new user_preferences!",
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

    # preferences table data
    $Self->{PreferencesTable} = $Self->{ConfigObject}->Get('DatabasePreferencesTable')
      || 'user_preferences';
    $Self->{PreferencesTableKey} = $Self->{ConfigObject}->Get('DatabasePreferencesTableKey')
      || 'preferences_key';
    $Self->{PreferencesTableValue} = $Self->{ConfigObject}->Get('DatabasePreferencesTableValue')
      || 'preferences_value';
    $Self->{PreferencesTableUserID} = $Self->{ConfigObject}->Get('DatabasePreferencesTableUserID')
      || 'user_id';

    # --
    # get preferences
    # --
    my $SQL = "SELECT $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue} " .
        " FROM " .
        " $Self->{PreferencesTable} ".
        " WHERE " .
        " $Self->{PreferencesTableUserID} = $UserID";

    $Self->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->FetchrowArray()) {
        $Data{$RowTmp[0]} = $RowTmp[1];
    }

    # --
    # return data
    # --
    return %Data;
}
# --


1;
