# --
# Kernel/System/CustomerUser/Preferences/DB.pm - some customer user functions
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DB.pm,v 1.6 2003-05-01 21:45:59 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerUser::Preferences::DB;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.6 $';
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
    $Self->{PreferencesTable} = $Self->{ConfigObject}->Get('CustomerPreferences')->{Params}->{Table}
      || 'customer_preferences';
    $Self->{PreferencesTableKey} = $Self->{ConfigObject}->Get('CustomerPreferences')->{Params}->{TableKey}
      || 'preferences_key';
    $Self->{PreferencesTableValue} = $Self->{ConfigObject}->Get('CustomerPreferences')->{Params}->{TableValue}
      || 'preferences_value';
    $Self->{PreferencesTableUserID} = $Self->{ConfigObject}->Get('CustomerPreferences')->{Params}->{TableUserID}
      || 'user_id';

    return $Self;
}
# --
sub SetPreferences {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || return;
    my $Key = $Param{Key} || return;
    my $Value = defined($Param{Value}) ? $Param{Value} : '';
    # delete old data
    if (!$Self->{DBObject}->Do(
       SQL => "DELETE FROM $Self->{PreferencesTable} ".
              " WHERE ".
              " $Self->{PreferencesTableUserID} = '".$Self->{DBObject}->Quote($UserID)."'".
              " AND ".
              " $Self->{PreferencesTableKey} = '".$Self->{DBObject}->Quote($Key)."'",
    )) {
        return;
    }
    # insert new data
    if (!$Self->{DBObject}->Do(
       SQL => "INSERT INTO $Self->{PreferencesTable} ($Self->{PreferencesTableUserID}, ".
              " $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue}) " .
              " VALUES ('".$Self->{DBObject}->Quote($UserID)."', ".
              " '".$Self->{DBObject}->Quote($Key)."', ".
              " '".$Self->{DBObject}->Quote($Value)."')",
    )) {
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
        " $Self->{PreferencesTableUserID} = '".$Self->{DBObject}->Quote($UserID)."'";

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
    # return data
    # --
    return %Data;
}
# --

1;
