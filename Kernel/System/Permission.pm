# --
# Kernel/System/Permission.pm - to control the access permissions
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: Permission.pm,v 1.13 2006-11-02 12:20:53 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Permission;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.13 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(DBObject LogObject UserObject GroupObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    # all sections <-> groups
    $Self->{PermissionAdmin}   = 'admin';
    $Self->{PermissionAgent}   = 'users';
    $Self->{PermissionStats}   = 'stats';

    return $Self;
}

sub Section {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || return;
    my $Section = 'Permission' . $Param{Section};

    my %Groups = $Self->{GroupObject}->GroupMemberList(
        Result => 'HASH',
        Type => 'rw',
        UserID => $UserID,
        Cached => 1,
    );
    foreach (keys %Groups) {
        if ($Groups{$_} eq $Self->{$Section}) {
            return 1;
        }
    }
    return;
}

1;
