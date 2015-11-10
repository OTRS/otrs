# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

=cut

This test verifies that old group_role entries with permission_value=0
are ignored in OTRS correctly (see bug#11616).

=cut

use vars (qw($Self));

our @ObjectDependencies = (
    'Kernel::System::Group',
    'Kernel::System::Time',
    'Kernel::System::UnitTest::Helper',
    'Kernel::System::User',
);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

# get needed objects
my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
my $TimeObject   = $Kernel::OM->Get('Kernel::System::Time');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

# create test user
my $UserLogin = $HelperObject->TestUserCreate();
my $UserID = $UserObject->UserLookup( UserLogin => $UserLogin );
my $RandomID = $HelperObject->GetRandomID();

# create test group
my $GroupName = 'test-permission-group-' . $RandomID;
my $GroupID   = $GroupObject->GroupAdd(
    Name    => $GroupName,
    ValidID => 1,
    UserID  => 1,
);

# create test role
my $RoleName = 'test-permission-role-' . $RandomID;
my $RoleID   = $GroupObject->RoleAdd(
    Name    => $RoleName,
    ValidID => 1,
    UserID  => 1,
);

my $Success = $GroupObject->PermissionGroupRoleAdd(
    GID        => $GroupID,
    RID        => $RoleID,
    Permission => { 'ro' => 1 },
    UserID     => 1,
);

$Self->True(
    $Success,
    "PermissionGroupRoleAdd() - add permissions for group ID $GroupID and role ID $RoleID"
);

my %Data = $GroupObject->_DBGroupRoleGet(
     Type => 'RoleGroupPerm',
);

$Self->IsDeeply(
    $Data{$RoleID},
    {
        $GroupID => [ 'ro' ],
    },
    "Role-Group connection found",
);

$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => "
        UPDATE group_role
        SET permission_value=0
        WHERE role_id = $RoleID
            AND group_id = $GroupID",
);

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

%Data = $GroupObject->_DBGroupRoleGet(
     Type => 'RoleGroupPerm',
);

$Self->Is(
    $Data{$RoleID},
    undef,
    "Role-Group connection found",
);

1;
