# --
# Kernel/System/Permission.pm - to control the access permissions 
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Permission.pm,v 1.6 2003-01-03 00:30:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Permission;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
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
    foreach ('DBObject', 'LogObject', 'UserObject') {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{DBObject} = $Param{DBObject};

    # all sections <-> groups   
    $Self->{PermissionAdmin}   = 'admin';
    $Self->{PermissionAgent}   = 'users';
    $Self->{PermissionStats}   = 'stats';

    return $Self;
}
# --
sub Section {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || return;
    my $Section = 'Permission' . $Param{Section};

    my %Groups = $Self->{UserObject}->GetGroups(UserID => $UserID);
    foreach (keys %Groups) {
        if ($Groups{$_} eq $Self->{$Section}) {
            return 1;
        }
    }
    return;
}
# --

1;
