# --
# Permission.pm - to control the access permissions 
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Permission.pm,v 1.1 2001-12-23 13:27:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Permission;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
    foreach ('DBObject', 'LogObject') {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{DBObject} = $Param{DBObject};

    # all sections <-> groups   
    $Self->{PermissionAdmin}   = 'admin';
    $Self->{PermissionAgent}   = 'users';

    return $Self;
}
# --
sub Section {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID};
    my $Section = 'Permission' . $Param{Section};

    my $SQL = "SELECT sug.id FROM " .
     " group_user as sug, groups as sg" .
     " WHERE " .
     " user_id = $UserID " .
     " and " .
     " sg.name = '$Self->{$Section}' " .
     " and " .
     " sg.id = sug.group_id ";	
    $Self->{DBObject}->Prepare(SQL => $SQL);
    my $GroupID = '';
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $GroupID = $RowTmp[0];
    }
    return $GroupID;
}
# --

1;
