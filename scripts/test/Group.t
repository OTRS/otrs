# --
# Group.t - Group tests
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Group.t,v 1.1 2005-12-20 22:53:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::Group;

$Self->{GroupObject} = Kernel::System::Group->new(%{$Self});

my $GroupRand = 'example-group'.int(rand(1000000));

my $GroupID = $Self->{GroupObject}->GroupAdd(
    Name => $GroupRand,
    ValidID => 1,
    UserID => 1,
);

$Self->True(
    $GroupID,
    'GroupAdd()',
);

my %Group = $Self->{GroupObject}->GroupGet(ID => $GroupID);

$Self->True(
    $Group{Name} eq $GroupRand,
    'GroupGet()',
);

my $GroupUpdate = $Self->{GroupObject}->GroupUpdate(
    ID => $GroupID,
    Name => $GroupRand."1",
    ValidID => 1,
    UserID => 1,
);

$Self->True(
    $GroupUpdate,
    'GroupUpdate()',
);

%Group = $Self->{GroupObject}->GroupGet(ID => $GroupID);

$Self->True(
    $Group{Name} eq $GroupRand."1",
    'GroupGet()',
);

my %Groups = $Self->{GroupObject}->GroupList(Valid => 1);

$Self->True(
    $Groups{$GroupID},
    'GroupList()',
);


my $RoleRand = 'example-group'.int(rand(1000000));

my $RoleID = $Self->{GroupObject}->RoleAdd(
    Name => $RoleRand,
    ValidID => 1,
    UserID => 1,
);

$Self->True(
    $RoleID,
    'RoleAdd()',
);

my %Role = $Self->{GroupObject}->RoleGet(ID => $RoleID);

$Self->True(
    $Role{Name} eq $RoleRand,
    'RoleGet()',
);

my $RoleUpdate = $Self->{GroupObject}->RoleUpdate(
    ID => $RoleID,
    Name => $RoleRand."1",
    ValidID => 1,
    UserID => 1,
);

$Self->True(
    $RoleUpdate,
    'RoleUpdate()',
);

%Role = $Self->{GroupObject}->RoleGet(ID => $RoleID);

$Self->True(
    $Role{Name} eq $RoleRand."1",
    'RoleGet()',
);

my %Roles = $Self->{GroupObject}->RoleList(Valid => 1);

$Self->True(
    $Roles{$RoleID},
    'RoleList()',
);



1;
