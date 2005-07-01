# --
# Kernel/System/User/Preferences/DB.pm - some user functions
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DB.pm,v 1.6.6.1 2005-07-01 06:12:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::User::Preferences::DB;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.6.6.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # preferences table data
    $Self->{PreferencesTable} = $Self->{ConfigObject}->Get('PreferencesTable')
      || 'user_preferences';
    $Self->{PreferencesTableKey} = $Self->{ConfigObject}->Get('PreferencesTableKey')
      || 'preferences_key';
    $Self->{PreferencesTableValue} = $Self->{ConfigObject}->Get('PreferencesTableValue')
      || 'preferences_value';
    $Self->{PreferencesTableUserID} = $Self->{ConfigObject}->Get('PreferencesTableUserID')
      || 'user_id';

    return $Self;
}
# --
sub SetPreferences {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID Key)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # delete old data
    if (!$Self->{DBObject}->Do(
       SQL => "DELETE FROM $Self->{PreferencesTable} ".
              " WHERE ".
              " $Self->{PreferencesTableUserID} = $Param{UserID} ".
              " AND ".
              " $Self->{PreferencesTableKey} = '$Param{Key}'",
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
              " VALUES ($Param{UserID}, '$Param{Key}', '$Param{Value}')",
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
    my %Data;
    # check needed stuff
    foreach (qw(UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # get preferences
    my $SQL = "SELECT $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue} " .
        " FROM " .
        " $Self->{PreferencesTable} ".
        " WHERE " .
        " $Self->{PreferencesTableUserID} = $Param{UserID}";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Data{$RowTmp[0]} = $RowTmp[1];
    }
    # return data
    return %Data;
}
# --

1;
