# --
# Kernel/System/User/Preferences/DB.pm - some user functions
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: DB.pm,v 1.10 2006-08-29 17:24:11 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::User::Preferences::DB;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.10 $';
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
    foreach (qw(Key Value)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get preferences
    my $SQL = "SELECT $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue} " .
        " FROM " .
        " $Self->{PreferencesTable} ".
        " WHERE " .
        " $Self->{PreferencesTableUserID} = $Param{UserID}";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{$Row[0]} = $Row[1];
    }
    # return data
    return %Data;
}
# --
sub SearchPreferences {
    my $Self = shift;
    my %Param = @_;
    my %UserID = ();
    my $Key = $Param{Key} || '';
    my $Value = $Param{Value} || '';

    # get preferences
    my $SQL = "SELECT $Self->{PreferencesTableUserID}, $Self->{PreferencesTableValue} " .
        " FROM " .
        " $Self->{PreferencesTable} ".
        " WHERE " .
        " $Self->{PreferencesTableKey} = '".$Self->{DBObject}->Quote($Key)."'".
        " AND ".
        " LOWER($Self->{PreferencesTableValue}) LIKE LOWER('".$Self->{DBObject}->Quote($Value)."')";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $UserID{$Row[0]} = $Row[1];
    }
    # return data
    return %UserID;
}
# --

1;
