# --
# Kernel/System/User/Preferences/DB.pm - some user functions
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DB.pm,v 1.1 2002-12-07 18:59:04 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::User::Preferences::DB;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
    my $UserID = $Param{UserID} || return;
    my $Key = $Param{Key} || return;
    my $Value = $Param{Value} || '';
    $Key = $Self->{DBObject}->Quote($Key);
    $Value = $Self->{DBObject}->Quote($Value) || '';
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
    # check needed preferences
    # --
    if (!$Data{UserCharset}) {
        $Data{UserCharset} = $Self->{ConfigObject}->Get('DefaultCharset');
    }
    # --
    # check language if long name s given --> compat (REMOVE ME LATER!)
    # --
    if ($Data{UserLanguage} && $Data{UserLanguage} !~ /^..$/) {
      my %OldNames = (
          bb => 'Bavarian',
          en => 'English',
          de => 'German',
          nl => 'Dutch',
          fr => 'French',
          bg => 'Bulgarian',
          es => 'Spanish',
          cs => 'Czech',
          it => 'Italian',
      );
      foreach (keys %OldNames) {
          if ($OldNames{$_} =~ /^$Data{UserLanguage}$/i) {
              $Data{UserLanguage} = $_;
          }
      }
    }
    # --
    # return data
    # --
    return %Data;
}
# --

1;
