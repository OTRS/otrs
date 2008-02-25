# --
# Kernel/System/Queue/PreferencesDB.pm - some user functions
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: PreferencesDB.pm,v 1.2 2008-02-25 10:50:09 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Queue::PreferencesDB;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # preferences table data
    $Self->{PreferencesTable} = 'queue_preferences';
    $Self->{PreferencesTableKey} = 'preferences_key';
    $Self->{PreferencesTableValue} = 'preferences_value';
    $Self->{PreferencesTableQueueID} = 'queue_id';

    return $Self;
}

sub QueuePreferencesSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(QueueID Key Value)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }

    # db quote
    for (qw(Key Value)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    for (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    # delete old data
    if (!$Self->{DBObject}->Do(
        SQL => "DELETE FROM $Self->{PreferencesTable} ".
            " WHERE ".
            " $Self->{PreferencesTableQueueID} = $Param{QueueID} ".
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
        SQL => "INSERT INTO $Self->{PreferencesTable} ($Self->{PreferencesTableQueueID}, ".
            " $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue}) " .
            " VALUES ($Param{QueueID}, '$Param{Key}', '$Param{Value}')",
    )) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't insert new $Self->{PreferencesTable}!",
        );
        return;
    }

    return 1;
}

sub QueuePreferencesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(QueueID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }

    # check if queue preferences are available
    if ( !$Self->{ConfigObject}->Get('QueuePreferences') ) {
        return;
    }

    # db quote
    for (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    # get preferences
    my %Data;
    my $SQL = "SELECT $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue} " .
        " FROM " .
        " $Self->{PreferencesTable} ".
        " WHERE " .
        " $Self->{PreferencesTableQueueID} = $Param{QueueID}";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{$Row[0]} = $Row[1];
    }

    # return data
    return %Data;
}

1;
