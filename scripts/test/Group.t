# --
# Group.t - Group tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Group.t,v 1.11 2008-05-08 09:35:57 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::Group;
use Kernel::System::User;

$Self->{GroupObject} = Kernel::System::Group->new( %{$Self} );
$Self->{UserObject}  = Kernel::System::User->new( %{$Self} );

# add three users
my $UserRand1 = 'example-user' . int( rand(1000000) );
my $UserRand2 = 'example-user' . int( rand(1000000) );
my $UserRand3 = 'example-user' . int( rand(1000000) );

$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailInvalidAddress',
    Value => 0,
);

my $UserID1 = $Self->{UserObject}->UserAdd(
    UserFirstname => 'Test1',
    UserLastname  => 'Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $UserID1,
    'UserAdd1()',
);

my $UserID2 = $Self->{UserObject}->UserAdd(
    UserFirstname => 'Test2',
    UserLastname  => 'Test2',
    UserLogin     => $UserRand2,
    UserEmail     => $UserRand2 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $UserID2,
    'UserAdd2()',
);

my $UserID3 = $Self->{UserObject}->UserAdd(
    UserFirstname => 'Test3',
    UserLastname  => 'Test3',
    UserLogin     => $UserRand3,
    UserEmail     => $UserRand3 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $UserID3,
    'UserAdd3()',
);

# add three groups
my $GroupRand1 = 'example-group1' . int( rand(1000000) );
my $GroupRand2 = 'example-group1' . int( rand(1000000) );
my $GroupRand3 = 'example-group1' . int( rand(1000000) );

my $GroupID1 = $Self->{GroupObject}->GroupAdd(
    Name    => $GroupRand1,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupID1,
    'GroupAdd1()',
);

my $GroupID2 = $Self->{GroupObject}->GroupAdd(
    Name    => $GroupRand2,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupID2,
    'GroupAdd2()',
);

my $GroupID3 = $Self->{GroupObject}->GroupAdd(
    Name    => $GroupRand3,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupID3,
    'GroupAdd3()',
);

# lookup Group1 by name
my $LookupGroupID1 = $Self->{GroupObject}->GroupLookup( Group => $GroupRand1 );
$Self->True(
    $LookupGroupID1 == $GroupID1,
    "GroupLookup(Group => '$GroupRand1')",
);

# lookup Group2 by name
my $LookupGroupID2 = $Self->{GroupObject}->GroupLookup( Group => $GroupRand2 );
$Self->True(
    $LookupGroupID2 == $GroupID2,
    "GroupLookup(Group => '$GroupRand2')",
);

# lookup Group3 by name
my $LookupGroupID3 = $Self->{GroupObject}->GroupLookup( Group => $GroupRand3 );
$Self->True(
    $LookupGroupID3 == $GroupID3,
    "GroupLookup(Group => '$GroupRand3')",
);

# lookup non-existing group by name
my $UnknownGroupID = $Self->{GroupObject}->GroupLookup( Group => 'agroupthatdoesnotexistatall' );
$Self->True(
    !defined $UnknownGroupID,
    "GroupLookup(Group => 'agroupthatdoesnotexistatall')",
);

# lookup Group1 by ID
my $LookupGroupName1 = $Self->{GroupObject}->GroupLookup( GroupID => $GroupID1 );
$Self->True(
    $LookupGroupName1 eq $GroupRand1,
    "GroupLookup(GroupID => $GroupID1)",
);

# lookup Group2 by ID
my $LookupGroupName2 = $Self->{GroupObject}->GroupLookup( GroupID => $GroupID2 );
$Self->True(
    $LookupGroupName2 eq $GroupRand2,
    "GroupLookup(GroupID => $GroupID2)",
);

# lookup Group3 by ID
my $LookupGroupName3 = $Self->{GroupObject}->GroupLookup( GroupID => $GroupID3 );
$Self->True(
    $LookupGroupName3 eq $GroupRand3,
    "GroupLookup(GroupID => $GroupID3)",
);

# lookup non-existing group by ID
my $UnknownGroupName = $Self->{GroupObject}->GroupLookup( GroupID => '9876543210' );
$Self->True(
    !defined $UnknownGroupName,
    "GroupLookup(GroupID => 9876543210)",
);

# get data of Group1
my %Group = $Self->{GroupObject}->GroupGet( ID => $GroupID1 );

$Self->True(
    $Group{Name} eq $GroupRand1,
    'GroupGet()',
);

# update Group1
my $GroupUpdate = $Self->{GroupObject}->GroupUpdate(
    ID      => $GroupID1,
    Name    => $GroupRand1 . "1",
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupUpdate,
    'GroupUpdate()',
);

# get data of updated Group1
%Group = $Self->{GroupObject}->GroupGet( ID => $GroupID1 );

$Self->True(
    $Group{Name} eq $GroupRand1 . "1",
    'GroupGet()',
);

# get list of valid groups
my %Groups = $Self->{GroupObject}->GroupList( Valid => 1 );

$Self->True(
    $Groups{$GroupID1},
    'GroupList()',
);

# add three roles
my $RoleRand1 = 'example-role1' . int( rand(1000000) );
my $RoleRand2 = 'example-role2' . int( rand(1000000) );
my $RoleRand3 = 'example-role3' . int( rand(1000000) );

my $RoleID1 = $Self->{GroupObject}->RoleAdd(
    Name    => $RoleRand1,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $RoleID1,
    'RoleAdd1()',
);

my $RoleID2 = $Self->{GroupObject}->RoleAdd(
    Name    => $RoleRand2,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $RoleID2,
    'RoleAdd2()',
);

my $RoleID3 = $Self->{GroupObject}->RoleAdd(
    Name    => $RoleRand3,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $RoleID3,
    'RoleAdd3()',
);

# lookup Role1 by name
my $LookupRoleID1 = $Self->{GroupObject}->RoleLookup( Role => $RoleRand1 );
$Self->True(
    $LookupRoleID1 == $RoleID1,
    "RoleLookup(Role => '$RoleRand1')",
);

# lookup Role2 by name
my $LookupRoleID2 = $Self->{GroupObject}->RoleLookup( Role => $RoleRand2 );
$Self->True(
    $LookupRoleID2 == $RoleID2,
    "RoleLookup(Role => '$RoleRand2')",
);

# lookup Role3 by name
my $LookupRoleID3 = $Self->{GroupObject}->RoleLookup( Role => $RoleRand3 );
$Self->True(
    $LookupRoleID3 == $RoleID3,
    "RoleLookup(Role => '$RoleRand3')",
);

# lookup non-existing role by name
my $UnknownRoleID = $Self->{GroupObject}->RoleLookup( Role => 'arolethatdoesnotexistatall' );
$Self->True(
    !defined $UnknownRoleID,
    "RoleLookup(Role => 'arolethatdoesnotexistatall')",
);

# lookup Role1 by ID
my $LookupRoleName1 = $Self->{GroupObject}->RoleLookup( RoleID => $RoleID1 );
$Self->True(
    $LookupRoleName1 eq $RoleRand1,
    "RoleLookup(RoleID => $RoleID1)",
);

# lookup Role2 by ID
my $LookupRoleName2 = $Self->{GroupObject}->RoleLookup( RoleID => $RoleID2 );
$Self->True(
    $LookupRoleName2 eq $RoleRand2,
    "RoleLookup(RoleID => $RoleID2)",
);

# lookup Role3 by ID
my $LookupRoleName3 = $Self->{GroupObject}->RoleLookup( RoleID => $RoleID3 );
$Self->True(
    $LookupRoleName3 eq $RoleRand3,
    "RoleLookup(RoleID => $RoleID3)",
);

# lookup non-existing role by ID
my $UnknownRoleName = $Self->{GroupObject}->RoleLookup( RoleID => '9876543210' );
$Self->True(
    !defined $UnknownRoleName,
    "RoleLookup(RoleID => 9876543210)",
);

# get data of Role1
my %Role = $Self->{GroupObject}->RoleGet( ID => $RoleID1 );

$Self->True(
    $Role{Name} eq $RoleRand1,
    'RoleGet()',
);

# update Role1
my $RoleUpdate = $Self->{GroupObject}->RoleUpdate(
    ID      => $RoleID1,
    Name    => $RoleRand1 . "1",
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $RoleUpdate,
    'RoleUpdate()',
);

# get data of updated Role1
%Role = $Self->{GroupObject}->RoleGet( ID => $RoleID1 );

$Self->True(
    $Role{Name} eq $RoleRand1 . "1",
    'RoleGet()',
);

# get list of Roles
my %Roles = $Self->{GroupObject}->RoleList( Valid => 1 );

$Self->True(
    $Roles{$RoleID1},
    'RoleList()',
);

# add User1 to Group1
$Self->{GroupObject}->GroupMemberAdd(
    GID        => $GroupID1,
    UID        => $UserID1,
    Permission => {
        ro        => 1,
        move_into => 1,
        create    => 1,
        owner     => 1,
        priority  => 0,
        rw        => 0,
    },
    UserID => 1,
);

# add User2 to Group1
$Self->{GroupObject}->GroupMemberAdd(
    GID        => $GroupID1,
    UID        => $UserID2,
    Permission => {
        ro        => 1,
        move_into => 1,
        create    => 1,
        owner     => 1,
        priority  => 0,
        rw        => 1,
    },
    UserID => 1,
);

# add User3 to Group2
$Self->{GroupObject}->GroupMemberAdd(
    GID        => $GroupID2,
    UID        => $UserID3,
    Permission => {
        ro        => 1,
        move_into => 1,
        create    => 1,
        owner     => 1,
        priority  => 0,
        rw        => 0,
    },
    UserID => 1,
);

# add User1 to Role1
$Self->{GroupObject}->GroupUserRoleMemberAdd(
    UID    => $UserID1,
    RID    => $RoleID1,
    Active => 1,
    UserID => 1,
);

# add User2 to Role2
$Self->{GroupObject}->GroupUserRoleMemberAdd(
    UID    => $UserID2,
    RID    => $RoleID2,
    Active => 1,
    UserID => 1,
);

# add User3 to Role2
$Self->{GroupObject}->GroupUserRoleMemberAdd(
    UID    => $UserID3,
    RID    => $RoleID2,
    Active => 1,
    UserID => 1,
);

# add Group1 to Role1
$Self->{GroupObject}->GroupRoleMemberAdd(
    GID        => $GroupID1,
    RID        => $RoleID1,
    Permission => {
        ro        => 1,
        move_into => 1,
        create    => 1,
        owner     => 1,
        priority  => 0,
        rw        => 0,
    },
    UserID => 1,
);

# add Group3 to Role2
$Self->{GroupObject}->GroupRoleMemberAdd(
    GID        => $GroupID3,
    RID        => $RoleID2,
    Permission => {
        ro        => 1,
        move_into => 1,
        create    => 1,
        owner     => 1,
        priority  => 0,
        rw        => 0,
    },
    UserID => 1,
);

# check groupmembers of User1
my %MemberList1 = $Self->{GroupObject}->GroupMemberList(
    UserID => $UserID1,
    Type   => 'ro',
    Result => 'HASH',
);
my $GroupMemberList1 = 1;
for ( keys %MemberList1 ) {
    if ( $_ ne $GroupID1 ) {
        $GroupMemberList1 = 0;
    }
}
$Self->True(
    $GroupMemberList1,
    'GroupMemberList1()',
);

# check groupmembers of User2
my %MemberList2 = $Self->{GroupObject}->GroupMemberList(
    UserID => $UserID2,
    Type   => 'ro',
    Result => 'HASH',
);
my $GroupMemberList2 = 1;
for ( keys %MemberList2 ) {
    if ( $_ ne $GroupID1 && $_ ne $GroupID3 ) {
        $GroupMemberList2 = 0;
    }
}
if ( !$MemberList2{$GroupID1} || !$MemberList2{$GroupID3} ) {
    $GroupMemberList2 = 0;
}
$Self->True(
    $GroupMemberList2,
    'GroupMemberList2()',
);

# check groupmembers of User3
my %MemberList3 = $Self->{GroupObject}->GroupMemberList(
    UserID => $UserID3,
    Type   => 'ro',
    Result => 'HASH',
);
my $GroupMemberList3 = 1;
for ( keys %MemberList3 ) {
    if ( $_ ne $GroupID2 && $_ ne $GroupID3 ) {
        $GroupMemberList3 = 0;
    }
}
if ( !$MemberList3{$GroupID2} || !$MemberList3{$GroupID3} ) {
    $GroupMemberList3 = 0;
}
$Self->True(
    $GroupMemberList3,
    'GroupMemberList3()',
);

# check groupmembers of Group1
my %MemberList4 = $Self->{GroupObject}->GroupMemberList(
    GroupID => $GroupID1,
    Type    => 'ro',
    Result  => 'HASH',
);
my $GroupMemberList4 = 1;
for ( keys %MemberList4 ) {
    if ( $_ ne $UserID1 && $_ ne $UserID2 ) {
        $GroupMemberList4 = 0;
    }
}
if ( !$MemberList4{$UserID1} || !$MemberList4{$UserID2} ) {
    $GroupMemberList4 = 0;
}
$Self->True(
    $GroupMemberList4,
    'GroupMemberList4()',
);

# check groupmembers of Group2
my %MemberList5 = $Self->{GroupObject}->GroupMemberList(
    GroupID => $GroupID2,
    Type    => 'ro',
    Result  => 'HASH',
);
my $GroupMemberList5 = 1;
for ( keys %MemberList5 ) {
    if ( $_ ne $UserID3 ) {
        $GroupMemberList5 = 0;
    }
}
$Self->True(
    $GroupMemberList5,
    'GroupMemberList5()',
);

# check groupmembers of Group3
my %MemberList6 = $Self->{GroupObject}->GroupMemberList(
    GroupID => $GroupID3,
    Type    => 'ro',
    Result  => 'HASH',
);
my $GroupMemberList6 = 1;
for ( keys %MemberList6 ) {
    if ( $_ ne $UserID2 && $_ ne $UserID3 ) {
        $GroupMemberList6 = 0;
    }
}
if ( !$MemberList6{$UserID2} || !$MemberList6{$UserID3} ) {
    $GroupMemberList6 = 0;
}
$Self->True(
    $GroupMemberList6,
    'GroupMemberList6()',
);

# check involved users of User1
my %InvolvedList1 = $Self->{GroupObject}->GroupMemberInvolvedList(
    UserID => $UserID1,
    Type   => 'ro',
);
my $GroupMemberInvolvedList1 = 1;
for ( keys %InvolvedList1 ) {
    if ( $_ ne $UserID1 && $_ ne $UserID2 ) {
        $GroupMemberInvolvedList1 = 0;
    }
}
$Self->True(
    $GroupMemberInvolvedList1,
    'GroupMemberInvolvedList1()',
);

# check involved users of User2
my %InvolvedList2 = $Self->{GroupObject}->GroupMemberInvolvedList(
    UserID => $UserID2,
    Type   => 'ro',
);
my $GroupMemberInvolvedList2 = 1;
for ( keys %InvolvedList2 ) {
    if ( $_ ne $UserID1 && $_ ne $UserID2 && $_ ne $UserID3 ) {
        $GroupMemberInvolvedList2 = 0;
    }
}
$Self->True(
    $GroupMemberInvolvedList2,
    'GroupMemberInvolvedList2()',
);

# check involved users of User3
my %InvolvedList3 = $Self->{GroupObject}->GroupMemberInvolvedList(
    UserID => $UserID3,
    Type   => 'ro',
);
my $GroupMemberInvolvedList3 = 1;
for ( keys %InvolvedList3 ) {
    if ( $_ ne $UserID2 && $_ ne $UserID3 ) {
        $GroupMemberInvolvedList3 = 0;
    }
}
$Self->True(
    $GroupMemberInvolvedList3,
    'GroupMemberInvolvedList3()',
);

# set test groups invalid
my @GroupIDs   = ( $GroupID1,   $GroupID2,   $GroupID3 );
my @GroupRands = ( $GroupRand1, $GroupRand2, $GroupRand3 );
my @RoleIDs    = ( $RoleID1,    $RoleID2,    $RoleID3 );
my @RoleRands  = ( $RoleRand1,  $RoleRand2,  $RoleRand3 );
for ( 0 .. 2 ) {
    my $GroupUpdate = $Self->{GroupObject}->GroupUpdate(
        ID      => $GroupIDs[$_],
        Name    => $GroupRands[$_],
        ValidID => 2,
        UserID  => 1,
    );
    $Self->True(
        $GroupUpdate,
        'GroupUpdate() set group invalid',
    );
    my $RoleUpdate = $Self->{GroupObject}->RoleUpdate(
        ID      => $RoleIDs[$_],
        Name    => $RoleRands[$_],
        ValidID => 2,
        UserID  => 1,
    );
    $Self->True(
        $RoleUpdate,
        'RoleUpdate() set role invalid',
    );
}

1;
