# --
# Kernel/System/CustomerUser/Preferences/DB.pm - some customer user functions
# Copyright (C) 2001-2008 OTRS GmbH, http://otrs.org/
# --
# $Id: DB.pm,v 1.14 2008-01-15 18:39:49 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerUser::Preferences::DB;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # preferences table data
    $Self->{PreferencesTable} = $Self->{ConfigObject}->Get('CustomerPreferences')->{Params}->{Table}
        || 'customer_preferences';
    $Self->{PreferencesTableKey}
        = $Self->{ConfigObject}->Get('CustomerPreferences')->{Params}->{TableKey}
        || 'preferences_key';
    $Self->{PreferencesTableValue}
        = $Self->{ConfigObject}->Get('CustomerPreferences')->{Params}->{TableValue}
        || 'preferences_value';
    $Self->{PreferencesTableUserID}
        = $Self->{ConfigObject}->Get('CustomerPreferences')->{Params}->{TableUserID}
        || 'user_id';

    return $Self;
}

sub SetPreferences {
    my ( $Self, %Param ) = @_;

    my $UserID = $Param{UserID} || return;
    my $Key    = $Param{Key}    || return;
    my $Value = defined( $Param{Value} ) ? $Param{Value} : '';

    # delete old data
    if (!$Self->{DBObject}->Do(
                  SQL => "DELETE FROM $Self->{PreferencesTable} "
                . " WHERE "
                . " $Self->{PreferencesTableUserID} = '"
                . $Self->{DBObject}->Quote($UserID) . "'" . " AND "
                . " $Self->{PreferencesTableKey} = '"
                . $Self->{DBObject}->Quote($Key) . "'",
        )
        )
    {
        return;
    }

    # insert new data
    if (!$Self->{DBObject}->Do(
                  SQL => "INSERT INTO $Self->{PreferencesTable} ($Self->{PreferencesTableUserID}, "
                . " $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue}) "
                . " VALUES ('"
                . $Self->{DBObject}->Quote($UserID) . "', " . " '"
                . $Self->{DBObject}->Quote($Key) . "', " . " '"
                . $Self->{DBObject}->Quote($Value) . "')",
        )
        )
    {
        return;
    }
    return 1;
}

sub GetPreferences {
    my ( $Self, %Param ) = @_;

    my $UserID = $Param{UserID} || return;
    my %Data;

    # get preferences
    my $SQL
        = "SELECT $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue} "
        . " FROM "
        . " $Self->{PreferencesTable} "
        . " WHERE "
        . " $Self->{PreferencesTableUserID} = '"
        . $Self->{DBObject}->Quote($UserID) . "'";

    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # return data
    return %Data;
}

sub SearchPreferences {
    my ( $Self, %Param ) = @_;

    my %UserID = ();
    my $Key    = $Param{Key} || '';
    my $Value  = $Param{Value} || '';

    # get preferences
    my $SQL
        = "SELECT $Self->{PreferencesTableUserID}, $Self->{PreferencesTableValue} "
        . " FROM "
        . " $Self->{PreferencesTable} "
        . " WHERE "
        . " $Self->{PreferencesTableKey} = '"
        . $Self->{DBObject}->Quote($Key) . "'" . " AND "
        . " LOWER($Self->{PreferencesTableValue}) LIKE LOWER('"
        . $Self->{DBObject}->Quote( $Value, 'Like' ) . "')";

    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $UserID{ $Row[0] } = $Row[1];
    }

    # return data
    return %UserID;
}

1;
