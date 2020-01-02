# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'CustomerGroupAlwaysGroups',
    Value => [],
);
$ConfigObject->Set(
    Key   => 'CustomerGroupCompanyAlwaysGroups',
    Value => [],
);
$ConfigObject->Set(
    Key   => 'CustomerGroupSupport',
    Value => 1,
);
my $PermissionContextDirect          = 'UnitTestPermission-direct';
my $PermissionContextOtherCustomerID = 'UnitTestPermission-other-CustomerID';
$ConfigObject->Set(
    Key   => 'CustomerGroupPermissionContext',
    Value => {
        '001-CustomerID-same'  => { Value => $PermissionContextDirect },
        '100-CustomerID-other' => { Value => $PermissionContextOtherCustomerID },
    },
);

# set permission types
$ConfigObject->Set(
    Key   => 'System::Customer::Permission',
    Value => [ 'ro', 'move_into', 'rw' ],
);

# create local objects
my $CustomerGroupObject = $Kernel::OM->Get('Kernel::System::CustomerGroup');
my $GroupObject         = $Kernel::OM->Get('Kernel::System::Group');

my $RandomID   = $Helper->GetRandomID();
my $UserID     = 1;
my $UID        = $RandomID;
my $GID1       = 1;
my $GID2       = 2;
my $GID3       = 3;
my $CustomerID = $RandomID;

#
# Tests for GroupMemberAdd()
#
my @Tests = (
    {
        Name    => 'Empty params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'No GID',
        Config => {
            GID        => undef,
            UID        => $UID,
            Permission => {
                ro => 1,
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'No UID',
        Config => {
            GID        => $GID1,
            UID        => undef,
            Permission => {
                ro => 1,
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'No permission',
        Config => {
            GID        => $GID1,
            UID        => $UID,
            Permission => undef,
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Empty permission',
        Config => {
            GID        => $GID1,
            UID        => $UID,
            Permission => {},
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ro permission',
        Config => {
            GID        => $GID1,
            UID        => $UID,
            Permission => {
                ro => 1,
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ro move_into permission',
        Config => {
            GID        => $GID1,
            UID        => $UID,
            Permission => {
                ro        => 1,
                move_into => 1,
                rw        => 0,
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ro move_into rw permission',
        Config => {
            GID        => $GID1,
            UID        => $UID,
            Permission => {
                rw => 1,
            },
            UserID => $UserID,
        },
        Success => 1,
    },
);

#
# Run tests for GroupMemberAdd()
#
for my $Test (@Tests) {

    my $MemberAddSuccess = $CustomerGroupObject->GroupMemberAdd( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {

        # create permission string
        my @Permissions;

        PERMISSION:
        for my $Permission ( sort keys %{ $Test->{Config}->{Permission} } ) {
            next PERMISSION if !$Test->{Config}->{Permission}->{$Permission};

            push @Permissions, $Permission;
        }
        my $PermissionsStrg = join ',', @Permissions;

        $Self->True(
            $MemberAddSuccess,
            "GroupMemberAdd() Test: $Test->{Name} - User: $Test->{Config}->{UID}, Group: $Test->{Config}->{GID}, Permissions:[$PermissionsStrg] with true",
        );

        PERMISSION:
        for my $Permission ( sort keys %{ $Test->{Config}->{Permission} } ) {

            my @ExpectedResult = ( $Test->{Config}->{GID} );

            @ExpectedResult = () if !$Test->{Config}->{Permission}->{$Permission};

            # check results
            my @MemberList = $CustomerGroupObject->GroupMemberList(
                UserID => $Test->{Config}->{UID},
                Type   => $Permission,
                Result => 'ID',
            );

            $Self->IsDeeply(
                \@MemberList,
                \@ExpectedResult,
                "GroupMemberList() for GroupMemberAdd() $Test->{Name} - User: $Test->{Config}->{UID} - Permission: $Permission",
            );

            my $PermissionResult = $CustomerGroupObject->PermissionCheck(
                GroupName => $GroupObject->GroupLookup( GroupID => $Test->{Config}->{GID} ),
                UserID    => $Test->{Config}->{UID},
                Type      => $Permission,
            );

            $Self->Is(
                $PermissionResult,
                $Test->{Config}->{Permission}->{$Permission},
                "PermissionCheck() $Test->{Name} - User: $Test->{Config}->{UID} - Permission: $Permission"
            );
        }
    }
    else {
        $Self->False(
            $MemberAddSuccess,
            "GroupMemberAdd() Test: $Test->{Name} - with false",
        );
    }
}

#
# Tests for GroupCustomerAdd()
#
@Tests = (
    {
        Name    => 'Empty params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'No GID',
        Config => {
            GID        => undef,
            CustomerID => $CustomerID,
            Permission => {
                $PermissionContextDirect => {
                    ro => 1,
                },
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'No CustomerID',
        Config => {
            GID        => $GID1,
            CustomerID => undef,
            Permission => {
                $PermissionContextDirect => {
                    ro => 1,
                },
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'No permission',
        Config => {
            GID        => $GID1,
            CustomerID => $CustomerID,
            Permission => undef,
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Empty permission',
        Config => {
            GID        => $GID1,
            CustomerID => $CustomerID,
            Permission => {},
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ro permission',
        Config => {
            GID        => $GID1,
            CustomerID => $CustomerID,
            Permission => {
                $PermissionContextDirect => {
                    ro => 1,
                },
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ro move_into permission',
        Config => {
            GID        => $GID1,
            CustomerID => $CustomerID,
            Permission => {
                $PermissionContextDirect => {
                    ro        => 1,
                    move_into => 1,
                },
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ro move_into rw permission',
        Config => {
            GID        => $GID1,
            CustomerID => $CustomerID,
            Permission => {
                $PermissionContextDirect => {
                    rw => 1,
                },
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'other customer id ro permission',
        Config => {
            GID        => $GID1,
            CustomerID => $CustomerID,
            Permission => {
                $PermissionContextDirect => {
                    rw => 1,
                },
                $PermissionContextOtherCustomerID => {
                    ro => 1,
                },
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'other customer id ro rw permission',
        Config => {
            GID        => $GID1,
            CustomerID => $CustomerID,
            Permission => {
                $PermissionContextDirect => {
                    rw => 1,
                },
                $PermissionContextOtherCustomerID => {
                    rw => 1,
                },
            },
            UserID => $UserID,
        },
        Success => 1,
    },
);

#
# Run tests for GroupCustomerAdd()
#
for my $Test (@Tests) {

    my $CustomerAddSuccess = $CustomerGroupObject->GroupCustomerAdd( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {

        # create permission string
        my @Permissions;

        CONTEXT:
        for my $Context ( sort keys %{ $Test->{Config}->{Permission} } ) {
            next CONTEXT if ref $Test->{Config}->{Permission}->{$Context} ne 'HASH';

            PERMISSION:
            for my $Permission ( sort keys %{ $Test->{Config}->{Permission}->{$Context} } ) {
                next PERMISSION if !$Test->{Config}->{Permission}->{$Context}->{$Permission};

                push @Permissions, $Permission;
            }
            my $PermissionsStrg = join ',', @Permissions;

            $Self->True(
                $CustomerAddSuccess,
                "GroupCustomerAdd() Test: $Test->{Name} - Customer: $Test->{Config}->{CustomerID}, Group: $Test->{Config}->{GID}, Permissions:[$PermissionsStrg], Context: $Context with true",
            );

            PERMISSION:
            for my $Permission ( sort keys %{ $Test->{Config}->{$Context}->{Permission} } ) {

                next PERMISSION if !$Test->{Config}->{Permission}->{$Context}->{$Permission};

                # check results
                my @CustomerList = $CustomerGroupObject->GroupCustomerList(
                    CustomerID => $Test->{Config}->{CustomerID},
                    Type       => $Permission,
                    Context    => $Context,
                    Result     => 'ID',
                );

                $Self->IsDeeply(
                    \@CustomerList,
                    [$GID1],
                    "GroupCustomerList() for GroupMemberAdd() $Test->{Name} - Customer: $Test->{Config}->{CustomerID}",
                );
            }
        }
    }
    else {
        $Self->False(
            $CustomerAddSuccess,
            "GroupCustomerAdd() Test: $Test->{Name} - with false",
        );
    }
}

# reset membership
my $ResetMembership = sub {
    my %Param = @_;

    $Param{UID} = $Param{UID} || $UID;

    my $Success = $CustomerGroupObject->GroupMemberAdd(
        GID        => $GID1,
        UID        => $Param{UID},
        Permission => {
            ro        => 0,
            move_into => 0,
            rw        => 0,
        },
        UserID => $UserID,
    );
    $Self->True(
        $Success,
        "GroupMemberAdd() reset for User: $Param{UID} Group: $GID1 - with true",
    );

    $Success = $CustomerGroupObject->GroupMemberAdd(
        GID        => $GID2,
        UID        => $Param{UID},
        Permission => {
            ro        => 0,
            move_into => 0,
            rw        => 0,
        },
        UserID => $UserID,
    );
    $Self->True(
        $Success,
        "GroupMemberAdd() reset for User: $Param{UID} Group: $GID2 - with true",
    );

    $Success = $CustomerGroupObject->GroupMemberAdd(
        GID        => $GID3,
        UID        => $Param{UID},
        Permission => {
            ro        => 0,
            move_into => 0,
            rw        => 0,
        },
        UserID => $UserID,
    );
    $Self->True(
        $Success,
        "GroupMemberAdd() reset for User: $Param{UID}, Group: $GID3 - with true",
    );

    for my $Permission (qw(ro move_into create owner priority rw)) {

        # check results
        my @MemberList = $CustomerGroupObject->GroupMemberList(
            UserID => $Param{UID},
            Type   => $Permission,
            Result => 'ID',
        );

        my @ExpectedResult;
        if ( IsArrayRefWithData( $Param{AlwaysGroups} ) ) {
            @ExpectedResult = ( $Param{GID} );
        }

        $Self->IsDeeply(
            \@MemberList,
            \@ExpectedResult,
            "GroupMemberList() for GroupMemberAdd() reset for User: $Param{UID}",
        );
    }
};

# reset customer
my $ResetCustomer = sub {
    my %Param = @_;

    $Param{CustomerID} = $Param{CustomerID} || $CustomerID;

    my $Success = $CustomerGroupObject->GroupCustomerAdd(
        GID        => $GID1,
        CustomerID => $Param{CustomerID},
        Permission => {
            $PermissionContextDirect => {
                ro        => 0,
                move_into => 0,
                rw        => 0,
            },
            $PermissionContextOtherCustomerID => {
                ro        => 0,
                move_into => 0,
                rw        => 0,
            },
        },
        UserID => $UserID,
    );
    $Self->True(
        $Success,
        "GroupCustomerAdd() reset for Customer: $Param{CustomerID} Group: $GID1 - with true",
    );

    $Success = $CustomerGroupObject->GroupCustomerAdd(
        GID        => $GID2,
        CustomerID => $Param{CustomerID},
        Permission => {
            $PermissionContextDirect => {
                ro        => 0,
                move_into => 0,
                rw        => 0,
            },
            $PermissionContextOtherCustomerID => {
                ro        => 0,
                move_into => 0,
                rw        => 0,
            },
        },
        UserID => $UserID,
    );
    $Self->True(
        $Success,
        "GroupCustomerAdd() reset for Customer: $Param{CustomerID} Group: $GID2 - with true",
    );

    $Success = $CustomerGroupObject->GroupCustomerAdd(
        GID        => $GID3,
        CustomerID => $Param{CustomerID},
        Permission => {
            $PermissionContextDirect => {
                ro        => 0,
                move_into => 0,
                rw        => 0,
            },
            $PermissionContextOtherCustomerID => {
                ro        => 0,
                move_into => 0,
                rw        => 0,
            },
        },
        UserID => $UserID,
    );
    $Self->True(
        $Success,
        "GroupCustomerAdd() reset for Customer: $Param{CustomerID}, Group: $GID3 - with true",
    );

    # check results
    for my $Context ( $PermissionContextDirect, $PermissionContextOtherCustomerID ) {
        for my $Permission (qw(ro move_into create owner priority rw)) {
            my @CustomerList = $CustomerGroupObject->GroupCustomerList(
                CustomerID => $Param{CustomerID},
                Type       => $Permission,
                Context    => $Context,
                Result     => 'ID',
            );

            my @ExpectedResult;
            if ( IsArrayRefWithData( $Param{AlwaysGroups} ) && $Context eq $PermissionContextDirect ) {
                @ExpectedResult = ( $Param{GID} );
            }

            $Self->IsDeeply(
                \@CustomerList,
                \@ExpectedResult,
                "GroupCustomerList() for GroupCustomerAdd() reset for Customer: $Param{CustomerID}, Context: $Context",
            );
        }
    }
};

# reset membership
$ResetMembership->(
    AlwaysGroups => $ConfigObject->Get('CustomerGroupAlwaysGroups'),
    GID          => $GID1,
);

# reset customer
$ResetCustomer->(
    AlwaysGroups => $ConfigObject->Get('CustomerGroupCompanyAlwaysGroups'),
    GID          => $GID1,
);

# set AlwaysGroups
$ConfigObject->Set(
    Key   => 'CustomerGroupAlwaysGroups',
    Value => [ $GroupObject->GroupLookup( GroupID => $GID1 ) ],
);
$ConfigObject->Set(
    Key   => 'CustomerGroupCompanyAlwaysGroups',
    Value => [ $GroupObject->GroupLookup( GroupID => $GID1 ) ],
);

# reset membership with AlwaysGroups
$ResetMembership->(
    AlwaysGroups => $ConfigObject->Get('CustomerGroupAlwaysGroups'),
    GID          => $GID1,
);

# reset customer with AlwaysGroups
$ResetCustomer->(
    AlwaysGroups => $ConfigObject->Get('CustomerGroupCompanyAlwaysGroups'),
    GID          => $GID1,
);

# remove AlwaysGroups
$ConfigObject->Set(
    Key   => 'CustomerGroupAlwaysGroups',
    Value => [],
);
$ConfigObject->Set(
    Key   => 'CustomerGroupCompanyAlwaysGroups',
    Value => [],
);

# reset membership
$ResetMembership->(
    AlwaysGroups => $ConfigObject->Get('CustomerGroupAlwaysGroups'),
    GID          => $GID1,
);

# reset customer
$ResetCustomer->(
    AlwaysGroups => $ConfigObject->Get('CustomerGroupCompanyAlwaysGroups'),
    GID          => $GID1,
);

#
# Tests for GroupMemberList()
#
@Tests = (
    {
        Name    => 'Empty params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'No Type',
        Config => {
            Type    => undef,
            Result  => 'HASH',
            UserID  => $UID,
            GroupID => $GID1,
        },
        Success => 0,
    },
    {
        Name   => 'No Result',
        Config => {
            Type    => 'ro',
            Result  => undef,
            UserID  => $UID,
            GroupID => $GID1,
        },
        Success => 0,
    },
    {
        Name   => 'No UserID and GroupID',
        Config => {
            Type    => 'ro',
            Result  => 'Name',
            UserID  => undef,
            GroupID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong UserID Array',
        Config => {
            Type    => 'ro',
            Result  => 'Name',
            UserID  => 'Nonexistent' . $RandomID,
            GroupID => undef,
        },
        ExpectedResult => [],
        Success        => 1,
    },
    {
        Name   => 'Wrong UserID Hash',
        Config => {
            Type    => 'ro',
            Result  => 'HASH',
            UserID  => 'Nonexistent' . $RandomID,
            GroupID => undef,
        },
        ExpectedResult => {},
        Success        => 1,
    },
    {
        Name   => 'Wrong GroupID Array',
        Config => {
            Type    => 'ro',
            Result  => 'ID',
            UserID  => undef,
            GroupID => 99999999,
        },
        ExpectedResult => [],
        Success        => 1,
    },
    {
        Name   => 'Wrong GroupID Hash',
        Config => {
            Type    => 'ro',
            Result  => 'HASH',
            UserID  => undef,
            GroupID => 99999999,
        },
        ExpectedResult => {},
        Success        => 1,
    },
    {
        Name   => 'Wrong Type Array',
        Config => {
            Type    => 'ro',
            Result  => 'Name',
            UserID  => $UID,
            GroupID => undef,
        },
        AddConfig => [
            {
                GID        => $GID1,
                UID        => $UID,
                Permission => {
                    ro        => 0,
                    move_into => 1,
                    rw        => 0,
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult  => [],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => 'Wrong Type Hash',
        Config => {
            Type    => 'ro',
            Result  => 'HASH',
            UserID  => $UID,
            GroupID => undef,
        },
        ExpectedResult  => {},
        Success         => 1,
        ResetMembership => 1,
    },
    {
        Name   => '1 With UserID - Result Name',
        Config => {
            Type    => 'ro',
            Result  => 'Name',
            UserID  => $UID,
            GroupID => undef,
        },
        AddConfig => [
            {
                GID        => $GID1,
                UID        => $UID,
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult  => [ $GroupObject->GroupLookup( GroupID => $GID1 ) ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => '1 With UserID - Result ID',
        Config => {
            Type    => 'ro',
            Result  => 'ID',
            UserID  => $UID,
            GroupID => undef,
        },
        ExpectedResult  => [$GID1],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => '1 With UserID - Result HASH',
        Config => {
            Type    => 'ro',
            Result  => 'HASH',
            UserID  => $UID,
            GroupID => undef,
        },
        ExpectedResult => {
            $GID1 => $GroupObject->GroupLookup( GroupID => $GID1 ),
        },
        Success         => 1,
        ResetMembership => 1,
    },
    {
        Name   => '1 With GroupID - Result Name',
        Config => {
            Type    => 'ro',
            Result  => 'Name',
            UserID  => undef,
            GroupID => $GID1,
        },
        AddConfig => [
            {
                GID        => $GID1,
                UID        => $UID,
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult  => [ $GroupObject->GroupLookup( GroupID => $GID1 ) ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => '1 With GroupID - Result ID',
        Config => {
            Type    => 'ro',
            Result  => 'ID',
            UserID  => undef,
            GroupID => $GID1,
        },
        ExpectedResult  => [$UID],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => '1 With GroupID - Result HASH',
        Config => {
            Type    => 'ro',
            Result  => 'HASH',
            UserID  => undef,
            GroupID => $GID1,
        },
        ExpectedResult => {
            $UID => $GroupObject->GroupLookup( GroupID => $GID1 ),
        },
        Success         => 1,
        ResetMembership => 1,
    },
    {
        Name   => 'Multiple With UserID - Result Name',
        Config => {
            Type    => 'ro',
            Result  => 'Name',
            UserID  => $UID,
            GroupID => undef,
        },
        AddConfig => [
            {
                GID        => $GID1,
                UID        => $UID,
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
            {
                GID        => $GID2,
                UID        => $UID,
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
            {
                GID        => $GID3,
                UID        => $UID,
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [
            $GroupObject->GroupLookup( GroupID => $GID1 ),
            $GroupObject->GroupLookup( GroupID => $GID2 ),
            $GroupObject->GroupLookup( GroupID => $GID3 ),
        ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => 'Multiple With UserID - Result ID',
        Config => {
            Type    => 'ro',
            Result  => 'ID',
            UserID  => $UID,
            GroupID => undef,
        },
        ExpectedResult => [
            $GID1,
            $GID2,
            $GID3,
        ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => 'Multiple With UserID - Result HASH',
        Config => {
            Type    => 'ro',
            Result  => 'HASH',
            UserID  => $UID,
            GroupID => undef,
        },
        ExpectedResult => {
            $GID1 => $GroupObject->GroupLookup( GroupID => $GID1 ),
            $GID2 => $GroupObject->GroupLookup( GroupID => $GID2 ),
            $GID3 => $GroupObject->GroupLookup( GroupID => $GID3 ),
        },
        Success         => 1,
        ResetMembership => 1,
    },
    {
        Name   => 'Multiple With GroupID - Result Name',
        Config => {
            Type    => 'ro',
            Result  => 'Name',
            UserID  => undef,
            GroupID => $GID1,
        },
        AddConfig => [
            {
                GID        => $GID1,
                UID        => $UID . '-1',
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
            {
                GID        => $GID1,
                UID        => $UID . '-2',
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
            {
                GID        => $GID1,
                UID        => $UID . '-3',
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [
            $GroupObject->GroupLookup( GroupID => $GID1 ),
            $GroupObject->GroupLookup( GroupID => $GID1 ),
            $GroupObject->GroupLookup( GroupID => $GID1 ),
        ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => 'Multiple With GroupID - Result ID',
        Config => {
            Type    => 'ro',
            Result  => 'ID',
            UserID  => undef,
            GroupID => $GID1,
        },
        ExpectedResult => [
            $UID . '-1',
            $UID . '-2',
            $UID . '-3',
        ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => 'Multiple With GroupID - Result HASH',
        Config => {
            Type    => 'ro',
            Result  => 'HASH',
            UserID  => undef,
            GroupID => $GID1,
        },
        ExpectedResult => {
            $UID . '-1' => $GroupObject->GroupLookup( GroupID => $GID1 ),
            $UID . '-2' => $GroupObject->GroupLookup( GroupID => $GID1 ),
            $UID . '-3' => $GroupObject->GroupLookup( GroupID => $GID1 ),
        },
        Success         => 1,
        ResetMembership => 1,
        ResetAllUsers   => 1,
    },
);

#
# Run tests for GroupMemberList()
#
for my $Test (@Tests) {

    for my $AddConfig ( @{ $Test->{AddConfig} } ) {
        my $Success = $CustomerGroupObject->GroupMemberAdd( %{$AddConfig} );

        $Self->True(
            $Success,
            "GroupMemberAdd() for GroupMemberList() Test:$Test->{Name}",
        );
    }

    my $MemberList;
    if ( $Test->{Config}->{Result} && $Test->{Config}->{Result} eq 'HASH' ) {
        %{$MemberList} = $CustomerGroupObject->GroupMemberList( %{ $Test->{Config} } );
    }
    elsif (
        $Test->{Config}->{Result}
        && ( $Test->{Config}->{Result} eq 'Name' || $Test->{Config}->{Result} eq 'ID' )
        )
    {
        @{$MemberList} = $CustomerGroupObject->GroupMemberList( %{ $Test->{Config} } );
    }
    else {
        $MemberList = $CustomerGroupObject->GroupMemberList( %{ $Test->{Config} } );
    }

    if ( $Test->{Success} ) {

        if ( ref $MemberList eq 'ARRAY' ) {
            my @SortedExpected   = sort @{ $Test->{ExpectedResult} };
            my @SortedMemberList = sort @{$MemberList};
            $Self->IsDeeply(
                \@SortedMemberList,
                \@SortedExpected,
                "GroupMemberList() $Test->{Name} for User: $UID",
            );
        }
        else {
            $Self->IsDeeply(
                $MemberList,
                $Test->{ExpectedResult},
                "GroupMemberList() $Test->{Name} for User: $UID",
            );

        }

        # reset membership if needed
        if ( $Test->{ResetMembership} && $Test->{ResetAllUsers} ) {
            $ResetMembership->();
            $ResetMembership->( UID => $UID . '-1' );
            $ResetMembership->( UID => $UID . '-2' );
            $ResetMembership->( UID => $UID . '-3' );
        }
        elsif ( $Test->{ResetMembership} ) {
            $ResetMembership->();
        }
    }
    else {
        if ( ref $MemberList eq 'HASH' ) {
            $Self->IsDeeply(
                $MemberList,
                {},
                "GroupMemberList() Test: $Test->{Name}",
            );
        }
        elsif ( ref $MemberList eq 'ARRAY' ) {
            $Self->IsDeeply(
                $MemberList,
                [],
                "GroupMemberList() Test: $Test->{Name}",
            );
        }
        else {
            $Self->Is(
                $MemberList,
                undef,
                "GroupMemberList() Test: $Test->{Name}",
            );
        }
    }
}

#
# Tests for GroupCustomerList()
#
@Tests = (
    {
        Name    => 'Empty params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'No Type',
        Config => {
            Type       => undef,
            Context    => $PermissionContextDirect,
            Result     => 'HASH',
            GroupID    => $GID1,
            CustomerID => $CustomerID,
        },
        Success => 0,
    },
    {
        Name   => 'No Result',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => undef,
            GroupID    => $GID1,
            CustomerID => $CustomerID,
        },
        Success => 0,
    },
    {
        Name   => 'No CustomerID and GroupID',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'Name',
            GroupID    => undef,
            CustomerID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong CustomerID Array',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'Name',
            GroupID    => undef,
            CustomerID => 'Nonexistent' . $RandomID,
        },
        ExpectedResult => [],
        Success        => 1,
    },
    {
        Name   => 'Wrong CustomerID Hash',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'HASH',
            GroupID    => undef,
            CustomerID => 'Nonexistent' . $RandomID,
        },
        ExpectedResult => {},
        Success        => 1,
    },
    {
        Name   => 'Wrong GroupID Array',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'ID',
            GroupID    => 99999999,
            CustomerID => undef,
        },
        ExpectedResult => [],
        Success        => 1,
    },
    {
        Name   => 'Wrong GroupID Hash',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'HASH',
            GroupID    => 99999999,
            CustomerID => undef,
        },
        ExpectedResult => {},
        Success        => 1,
    },
    {
        Name   => 'Wrong Type Array',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'Name',
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        AddConfig => [
            {
                GID        => $GID1,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 0,
                        move_into => 1,
                        rw        => 0,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult  => [],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => 'Wrong Type Hash',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'HASH',
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        ExpectedResult  => {},
        Success         => 1,
        ResetMembership => 1,
    },
    {
        Name   => '1 With CustomerID - Result Name',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'Name',
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        AddConfig => [
            {
                GID        => $GID1,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 1,
                        move_into => 0,
                        rw        => 0,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult  => [ $GroupObject->GroupLookup( GroupID => $GID1 ) ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => '1 With CustomerID - Result ID',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'ID',
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        ExpectedResult  => [$GID1],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => '1 With CustomerID - Result HASH',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'HASH',
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        ExpectedResult => {
            $GID1 => $GroupObject->GroupLookup( GroupID => $GID1 ),
        },
        Success         => 1,
        ResetMembership => 1,
    },
    {
        Name   => '1 With GroupID - Result Name',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'Name',
            GroupID    => $GID1,
            CustomerID => undef,
        },
        AddConfig => [
            {
                GID        => $GID1,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 1,
                        move_into => 0,
                        rw        => 0,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult  => [ $GroupObject->GroupLookup( GroupID => $GID1 ) ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => '1 With GroupID - Result ID',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'ID',
            GroupID    => $GID1,
            CustomerID => undef,
        },
        ExpectedResult  => [$UID],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => '1 With GroupID - Result HASH',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'HASH',
            GroupID    => $GID1,
            CustomerID => undef,
        },
        ExpectedResult => {
            $UID => $GroupObject->GroupLookup( GroupID => $GID1 ),
        },
        Success         => 1,
        ResetMembership => 1,
    },
    {
        Name   => 'Multiple With CustomerID - Result Name',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'Name',
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        AddConfig => [
            {
                GID        => $GID1,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 1,
                        move_into => 0,
                        rw        => 0,
                    },
                },
                UserID => $UserID,
            },
            {
                GID        => $GID2,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 1,
                        move_into => 0,
                        rw        => 0,
                    },
                },
                UserID => $UserID,
            },
            {
                GID        => $GID3,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 1,
                        move_into => 0,
                        rw        => 0,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [
            $GroupObject->GroupLookup( GroupID => $GID1 ),
            $GroupObject->GroupLookup( GroupID => $GID2 ),
            $GroupObject->GroupLookup( GroupID => $GID3 ),
        ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => 'Multiple With CustomerID - Result ID',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'ID',
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        ExpectedResult => [
            $GID1,
            $GID2,
            $GID3,
        ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => 'Multiple With CustomerID - Result HASH',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'HASH',
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        ExpectedResult => {
            $GID1 => $GroupObject->GroupLookup( GroupID => $GID1 ),
            $GID2 => $GroupObject->GroupLookup( GroupID => $GID2 ),
            $GID3 => $GroupObject->GroupLookup( GroupID => $GID3 ),
        },
        Success         => 1,
        ResetMembership => 1,
    },
    {
        Name   => 'Multiple With GroupID - Result Name',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'Name',
            GroupID    => $GID1,
            CustomerID => undef,
        },
        AddConfig => [
            {
                GID        => $GID1,
                CustomerID => $CustomerID . '-1',
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 1,
                        move_into => 0,
                        rw        => 0,
                    },
                },
                UserID => $UserID,
            },
            {
                GID        => $GID1,
                CustomerID => $CustomerID . '-2',
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 1,
                        move_into => 0,
                        rw        => 0,
                    },
                },
                UserID => $UserID,
            },
            {
                GID        => $GID1,
                CustomerID => $CustomerID . '-3',
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 1,
                        move_into => 0,
                        rw        => 0,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [
            $GroupObject->GroupLookup( GroupID => $GID1 ),
            $GroupObject->GroupLookup( GroupID => $GID1 ),
            $GroupObject->GroupLookup( GroupID => $GID1 ),
        ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => 'Multiple With GroupID - Result ID',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'ID',
            GroupID    => $GID1,
            CustomerID => undef,
        },
        ExpectedResult => [
            $CustomerID . '-1',
            $CustomerID . '-2',
            $CustomerID . '-3',
        ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => 'Multiple With GroupID - Result HASH',
        Config => {
            Type       => 'ro',
            Context    => $PermissionContextDirect,
            Result     => 'HASH',
            GroupID    => $GID1,
            CustomerID => undef,
        },
        ExpectedResult => {
            $CustomerID . '-1' => $GroupObject->GroupLookup( GroupID => $GID1 ),
            $CustomerID . '-2' => $GroupObject->GroupLookup( GroupID => $GID1 ),
            $CustomerID . '-3' => $GroupObject->GroupLookup( GroupID => $GID1 ),
        },
        Success         => 1,
        ResetMembership => 1,
        ResetAllUsers   => 1,
    },
);

#
# Run tests for GroupCustomerList()
#
for my $Test (@Tests) {

    for my $AddConfig ( @{ $Test->{AddConfig} } ) {
        my $Success = $CustomerGroupObject->GroupCustomerAdd( %{$AddConfig} );

        $Self->True(
            $Success,
            "GroupCustomerAdd() for GroupCustomerList() Test:$Test->{Name}",
        );
    }

    my $CustomerList;
    if ( $Test->{Config}->{Result} && $Test->{Config}->{Result} eq 'HASH' ) {
        %{$CustomerList} = $CustomerGroupObject->GroupCustomerList( %{ $Test->{Config} } );
    }
    elsif (
        $Test->{Config}->{Result}
        && ( $Test->{Config}->{Result} eq 'Name' || $Test->{Config}->{Result} eq 'ID' )
        )
    {
        @{$CustomerList} = $CustomerGroupObject->GroupCustomerList( %{ $Test->{Config} } );
    }
    else {
        $CustomerList = $CustomerGroupObject->GroupCustomerList( %{ $Test->{Config} } );
    }

    if ( $Test->{Success} ) {

        if ( ref $CustomerList eq 'ARRAY' ) {
            my @SortedExpected     = sort @{ $Test->{ExpectedResult} };
            my @SortedCustomerList = sort @{$CustomerList};
            $Self->IsDeeply(
                \@SortedCustomerList,
                \@SortedExpected,
                "GroupCustomerList() $Test->{Name} for Customer: $CustomerID",
            );
        }
        else {
            $Self->IsDeeply(
                $CustomerList,
                $Test->{ExpectedResult},
                "GroupCustomerList() $Test->{Name} for Customer: $CustomerID",
            );

        }

        # reset membership if needed
        if ( $Test->{ResetMembership} && $Test->{ResetAllUsers} ) {
            $ResetCustomer->();
            $ResetCustomer->( CustomerID => $CustomerID . '-1' );
            $ResetCustomer->( CustomerID => $CustomerID . '-2' );
            $ResetCustomer->( CustomerID => $CustomerID . '-3' );
        }
        elsif ( $Test->{ResetMembership} ) {
            $ResetCustomer->();
        }
    }
    else {
        if ( ref $CustomerList eq 'HASH' ) {
            $Self->IsDeeply(
                $CustomerList,
                {},
                "GroupCustomerList() Test: $Test->{Name}",
            );
        }
        elsif ( ref $CustomerList eq 'ARRAY' ) {
            $Self->IsDeeply(
                $CustomerList,
                [],
                "GroupCustomerList() Test: $Test->{Name}",
            );
        }
        else {
            $Self->Is(
                $CustomerList,
                undef,
                "GroupCustomerList() Test: $Test->{Name}",
            );
        }
    }
}

#
# Tests for GroupLookup()
#
@Tests = (
    {
        Name    => 'Empty params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'No Group and GroupID',
        Config => {
            Group   => undef,
            GroupID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Group',
        Config => {
            Group   => 'Nonexistent' . $RandomID,
            GroupID => undef,
        },
        ExpectedResults => '',
        Success         => 1,
    },
    {
        Name   => 'Wrong GroupID',
        Config => {
            Group   => undef,
            GroupID => 99999999,
        },
        ExpectedResults => '',
        Success         => 1,
    },
    {
        Name   => 'Correct Group',
        Config => {
            Group   => $GroupObject->GroupLookup( GroupID => $GID1 ),
            GroupID => undef,
        },
        ExpectedResult => $GID1,
        Success        => 1,
    },
    {
        Name   => 'Correct GroupID',
        Config => {
            Group   => undef,
            GroupID => $GID1,
        },
        ExpectedResult => $GroupObject->GroupLookup( GroupID => $GID1 ),
        Success        => 1,
    },
);

for my $Test (@Tests) {

    my $Result = $CustomerGroupObject->GroupLookup( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {

        $Self->Is(
            $Result,
            $Test->{ExpectedResult},
            "GroupLookup() Test:$Test->{Name}",
        );
    }
    else {
        $Self->Is(
            $Result,
            undef,
            "GroupLookup() Test:$Test->{Name}",
        );
    }
}

# get customer user object
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# add customer user to database
my $UserLogin = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'John',
    UserLastname   => 'Doe',
    UserCustomerID => $CustomerID,
    UserLogin      => $UID,
    UserPassword   => 'some-pass',
    UserEmail      => 'email@example.com',
    ValidID        => 1,
    UserID         => $UserID,
);
$Self->Is(
    $UserLogin,
    $UID,
    'CustomerUserAdd() - UserLogin',
);

my %User = $CustomerUserObject->CustomerUserDataGet(
    User => $UID,
);
$Self->Is(
    $User{UserCustomerID},
    $CustomerID,
    'CustomerUserDataGet() - UserCustomerID',
);

#
# Tests for GroupMemberList() inheritance
#
@Tests = (
    {
        Name   => 'Inheritance With UserID - Result Name',
        Config => {
            Type       => 'rw',
            Result     => 'Name',
            UserID     => $UID,
            GroupID    => undef,
            CustomerID => undef,
        },
        AddConfig => [
            {
                GID        => $GID1,
                UID        => $UID,
                CustomerID => undef,
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [ $GroupObject->GroupLookup( GroupID => $GID1 ) ],
        Success        => 0,
    },
    {
        Name   => 'Inheritance With UserID - Result Name',
        Config => {
            Type       => 'rw',
            Result     => 'Name',
            UserID     => $UID,
            GroupID    => undef,
            CustomerID => undef,
        },
        AddConfig => [
            {
                GID        => $GID1,
                UID        => undef,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        rw => 1,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [ $GroupObject->GroupLookup( GroupID => $GID1 ) ],
        Success        => 1,
    },
    {
        Name   => 'Inheritance With UserID - Result ID',
        Config => {
            Type       => 'rw',
            Result     => 'ID',
            UserID     => $UID,
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        ExpectedResult => [$GID1],
        Success        => 1,
    },
    {
        Name   => 'Inheritance With UserID - Result HASH',
        Config => {
            Type       => 'rw',
            Result     => 'HASH',
            UserID     => $UID,
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        ExpectedResult => {
            $GID1 => $GroupObject->GroupLookup( GroupID => $GID1 ),
        },
        Success => 1,
    },
    {
        Name   => 'Inheritance With GroupID - Result Name',
        Config => {
            Type       => 'rw',
            Result     => 'Name',
            UserID     => undef,
            GroupID    => $GID1,
            CustomerID => undef,
        },
        ExpectedResult => [ $GroupObject->GroupLookup( GroupID => $GID1 ) ],
        Success        => 1,
    },
    {
        Name   => 'Inheritance With GroupID - Result ID',
        Config => {
            Type       => 'rw',
            Result     => 'ID',
            UserID     => undef,
            GroupID    => $GID1,
            CustomerID => undef,
        },
        AddConfig => [
            {
                GID        => $GID1,
                UID        => undef,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 0,
                        move_into => 0,
                        rw        => 0,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [$UID],
        Success        => 0,
    },
    {
        Name   => 'Inheritance With GroupID - Result HASH',
        Config => {
            Type       => 'rw',
            Result     => 'HASH',
            UserID     => undef,
            GroupID    => $GID1,
            CustomerID => undef,
        },
        ExpectedResult => {
            $UID => $GroupObject->GroupLookup( GroupID => $GID1 ),
        },
        Success => 0,
    },
    {
        Name   => 'Inheritance Multiple With UserID - Result Name',
        Config => {
            Type       => 'rw',
            Result     => 'Name',
            UserID     => $UID,
            GroupID    => undef,
            CustomerID => undef,
        },
        AddConfig => [
            {
                GID        => $GID1,
                UID        => $UID,
                CustomerID => undef,
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
            {
                GID        => $GID2,
                UID        => $UID,
                CustomerID => undef,
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
            {
                GID        => $GID3,
                UID        => $UID,
                CustomerID => undef,
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
            {
                GID        => $GID3,
                UID        => undef,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 0,
                        move_into => 0,
                        rw        => 1,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [
            $GroupObject->GroupLookup( GroupID => $GID3 ),
        ],
        Success => 1,
    },
    {
        Name   => 'Inheritance Multiple With UserID - Result ID',
        Config => {
            Type       => 'rw',
            Result     => 'ID',
            UserID     => $UID,
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        ExpectedResult => [
            $GID3,
        ],
        Success => 1,
    },
    {
        Name   => 'Inheritance Multiple With UserID - Result HASH',
        Config => {
            Type       => 'rw',
            Result     => 'HASH',
            UserID     => $UID,
            GroupID    => undef,
            CustomerID => $CustomerID,
        },
        ExpectedResult => {
            $GID3 => $GroupObject->GroupLookup( GroupID => $GID3 ),
        },
        Success => 1,
    },
    {
        Name   => 'Inheritance Multiple With GroupID - Result Name',
        Config => {
            Type       => 'rw',
            Result     => 'Name',
            UserID     => undef,
            GroupID    => $GID1,
            CustomerID => undef,
        },
        AddConfig => [
            {
                GID        => $GID1,
                UID        => $UID,
                CustomerID => undef,
                Permission => {
                    ro        => 1,
                    move_into => 0,
                    rw        => 0,
                },
                UserID => $UserID,
            },
            {
                GID        => $GID1,
                UID        => undef,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        rw => 1,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [
            $GroupObject->GroupLookup( GroupID => $GID1 ),
        ],
        Success => 1,
    },
    {
        Name   => 'Inheritance Multiple With GroupID - Result ID',
        Config => {
            Type       => 'rw',
            Result     => 'ID',
            UserID     => undef,
            GroupID    => $GID1,
            CustomerID => undef,
        },
        ExpectedResult => [
            $UID,
        ],
        Success         => 1,
        ResetMembership => 0,
    },
    {
        Name   => 'Inheritance Multiple With GroupID - Result HASH',
        Config => {
            Type       => 'rw',
            Result     => 'HASH',
            UserID     => undef,
            GroupID    => $GID1,
            CustomerID => undef,
        },
        ExpectedResult => {
            $UID => $GroupObject->GroupLookup( GroupID => $GID1 ),
        },
        Success => 1,
    },
    {
        Name   => 'Inheritance Multiple With GroupID - Result Name',
        Config => {
            Type           => 'ro',
            Result         => 'Name',
            UserID         => undef,
            GroupID        => $GID1,
            CustomerID     => undef,
            RawPermissions => 1,
        },
        ExpectedResult => [
            $GroupObject->GroupLookup( GroupID => $GID1 ),
        ],
        Success => 1,
    },
    {
        Name   => 'Inheritance Multiple With GroupID - Result ID',
        Config => {
            Type           => 'ro',
            Result         => 'ID',
            UserID         => undef,
            GroupID        => $GID1,
            CustomerID     => undef,
            RawPermissions => 1,
        },
        ExpectedResult => [
            $UID,
        ],
        Success => 1,
    },
    {
        Name   => 'Inheritance Multiple With GroupID - Result HASH',
        Config => {
            Type           => 'ro',
            Result         => 'HASH',
            UserID         => undef,
            GroupID        => $GID1,
            CustomerID     => undef,
            RawPermissions => 1,
        },
        ExpectedResult => {
            $UID => $GroupObject->GroupLookup( GroupID => $GID1 ),
        },
        Success => 1,
    },
    {
        Name   => 'Inheritance Multiple With GroupID - Result Name',
        Config => {
            Type           => 'rw',
            Result         => 'Name',
            UserID         => undef,
            GroupID        => $GID1,
            CustomerID     => undef,
            RawPermissions => 1,
        },
        ExpectedResult => [],
        Success        => 1,
    },
    {
        Name   => 'Inheritance Multiple With GroupID - Result ID',
        Config => {
            Type           => 'rw',
            Result         => 'ID',
            UserID         => undef,
            GroupID        => $GID1,
            CustomerID     => undef,
            RawPermissions => 1,
        },
        ExpectedResult => [],
        Success        => 1,
    },
    {
        Name   => 'Inheritance Multiple With GroupID - Result HASH',
        Config => {
            Type           => 'rw',
            Result         => 'HASH',
            UserID         => undef,
            GroupID        => $GID1,
            CustomerID     => undef,
            RawPermissions => 1,
        },
        ExpectedResult => {},
        Success        => 1,
    },
);

#
# Run tests for GroupMemberList() inheritance
#
for my $Test (@Tests) {

    for my $AddConfig ( @{ $Test->{AddConfig} } ) {
        my $Success;
        my $MethodName;
        if ( $AddConfig->{UID} ) {
            $Success    = $CustomerGroupObject->GroupMemberAdd( %{$AddConfig} );
            $MethodName = 'GroupMemberAdd';
        }
        elsif ( $AddConfig->{CustomerID} ) {
            $Success    = $CustomerGroupObject->GroupCustomerAdd( %{$AddConfig} );
            $MethodName = 'GroupCustomerAdd';
        }

        $Self->True(
            $Success,
            "$MethodName() for GroupMemberList() Test:$Test->{Name}",
        );
    }

    my $MemberList;
    if ( $Test->{Config}->{Result} && $Test->{Config}->{Result} eq 'HASH' ) {
        %{$MemberList} = $CustomerGroupObject->GroupMemberList( %{ $Test->{Config} } );
    }
    elsif (
        $Test->{Config}->{Result}
        && ( $Test->{Config}->{Result} eq 'Name' || $Test->{Config}->{Result} eq 'ID' )
        )
    {
        @{$MemberList} = $CustomerGroupObject->GroupMemberList( %{ $Test->{Config} } );
    }
    else {
        $MemberList = $CustomerGroupObject->GroupMemberList( %{ $Test->{Config} } );
    }

    if ( $Test->{Success} ) {

        if ( ref $MemberList eq 'ARRAY' ) {
            my @SortedExpected   = sort @{ $Test->{ExpectedResult} };
            my @SortedMemberList = sort @{$MemberList};
            $Self->IsDeeply(
                \@SortedMemberList,
                \@SortedExpected,
                "GroupMemberList() $Test->{Name} for User: $UID",
            );
        }
        else {
            $Self->IsDeeply(
                $MemberList,
                $Test->{ExpectedResult},
                "GroupMemberList() $Test->{Name} for User: $UID",
            );

        }
    }
    else {
        if ( ref $MemberList eq 'HASH' ) {
            $Self->IsDeeply(
                $MemberList,
                {},
                "GroupMemberList() Test: $Test->{Name}",
            );
        }
        elsif ( ref $MemberList eq 'ARRAY' ) {
            $Self->IsDeeply(
                $MemberList,
                [],
                "GroupMemberList() Test: $Test->{Name}",
            );
        }
        else {
            $Self->Is(
                $MemberList,
                undef,
                "GroupMemberList() Test: $Test->{Name}",
            );
        }
    }
}

# get customer company object
my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

# get another customer id
my $CustomerID2 = $Helper->GetRandomID();
my $CustomerID3 = $Helper->GetRandomID();

# add customer companies to the database
my @CustomerIDs = (
    $CustomerID,
    $CustomerID2,
    $CustomerID3,
);
for my $CustomerID (@CustomerIDs) {
    my $CustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID          => $CustomerID,
        CustomerCompanyName => $CustomerID,
        ValidID             => 1,
        UserID              => 1,
    );
    $Self->True(
        $CustomerCompanyID,
        "Created test customer company $CustomerCompanyID",
    );
}

#
# Tests for GroupContextCustomers()
#
@Tests = (
    {
        Name   => 'Single customer company',
        Config => {
            CustomerUserID => $UID,
        },
        ExpectedResult => [
            $CustomerID,
        ],
    },
    {
        Name   => 'Multiple customer companies ro',
        Config => {
            CustomerUserID => $UID,
        },
        AddConfig => [
            {
                GID        => $GID1,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        ro => 1,
                    },
                    $PermissionContextOtherCustomerID => {
                        ro => 1,
                    },
                },
                UserID => $UserID,
            },
            {
                GID        => $GID1,
                CustomerID => $CustomerID2,
                Permission => {
                    $PermissionContextDirect => {
                        ro => 1,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [
            $CustomerID,
            $CustomerID2,
        ],
    },
    {
        Name   => 'Multiple customer companies rw',
        Config => {
            CustomerUserID => $UID,
        },
        AddConfig => [
            {
                GID        => $GID1,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        rw => 1,
                    },
                    $PermissionContextOtherCustomerID => {
                        rw => 1,
                    },
                },
                UserID => $UserID,
            },
            {
                GID        => $GID1,
                CustomerID => $CustomerID2,
                Permission => {
                    $PermissionContextDirect => {
                        rw => 1,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [
            $CustomerID,
            $CustomerID2,
        ],
    },
    {
        Name   => 'Multiple customer companies - combination 1',
        Config => {
            CustomerUserID => $UID,
        },
        AddConfig => [
            {
                GID        => $GID1,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        ro => 1,
                    },
                    $PermissionContextOtherCustomerID => {
                        ro => 1,
                    },
                },
                UserID => $UserID,
            },
            {
                GID        => $GID1,
                CustomerID => $CustomerID2,
                Permission => {
                    $PermissionContextDirect => {
                        ro        => 0,
                        move_into => 1,
                    },
                },
                UserID => $UserID,
            },
            {
                GID        => $GID1,
                CustomerID => $CustomerID3,
                Permission => {
                    $PermissionContextDirect => {
                        ro => 1,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [
            $CustomerID,
            $CustomerID3,
        ],
    },
    {
        Name   => 'Multiple customer companies - combination 2',
        Config => {
            CustomerUserID => $UID,
        },
        AddConfig => [
            {
                GID        => $GID1,
                CustomerID => $CustomerID,
                Permission => {
                    $PermissionContextDirect => {
                        ro => 1,
                    },
                    $PermissionContextOtherCustomerID => {
                        ro => 1,
                    },
                },
                UserID => $UserID,
            },
            {
                GID        => $GID1,
                CustomerID => $CustomerID2,
                Permission => {
                    $PermissionContextDirect => {
                        ro => 1,
                    },
                },
                UserID => $UserID,
            },
            {
                GID        => $GID1,
                CustomerID => $CustomerID3,
                Permission => {
                    $PermissionContextDirect => {
                        rw => 1,
                    },
                },
                UserID => $UserID,
            },
        ],
        ExpectedResult => [
            $CustomerID,
            $CustomerID2,
            $CustomerID3,
        ],
    },
);

#
# Run tests for GroupContextCustomers()
#
for my $Test (@Tests) {

    for my $AddConfig ( @{ $Test->{AddConfig} } ) {
        my $Success = $CustomerGroupObject->GroupCustomerAdd( %{$AddConfig} );

        $Self->True(
            $Success,
            "GroupCustomerAdd() for GroupContextCustomers() Test:$Test->{Name}",
        );
    }

    my %Customers = $CustomerGroupObject->GroupContextCustomers( %{ $Test->{Config} } );

    my @SortedExpected  = sort @{ $Test->{ExpectedResult} };
    my @SortedCustomers = sort keys %Customers;

    $Self->IsDeeply(
        \@SortedCustomers,
        \@SortedExpected,
        "GroupContextCustomers() $Test->{Name} for User: $UID",
    );
}

# Disable email checks
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'CheckMXRecord',
    Value => 0,
);

# create 2 customer users
my $CustomerUser1 = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'John 1',
    UserLastname   => 'Doe',
    UserCustomerID => 'jdoe1',
    UserLogin      => 'jdoe1',
    UserEmail      => 'jdoe1@example.com',
    ValidID        => 1,
    UserID         => 1,
);
$Self->True(
    $CustomerUser1,
    "Customer user #1 created."
);
my $CustomerUser2 = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'John 2',
    UserLastname   => 'Doe',
    UserCustomerID => 'jdoe2',
    UserLogin      => 'jdoe2',
    UserEmail      => 'jdoe2@example.com',
    ValidID        => 1,
    UserID         => 1,
);
$Self->True(
    $CustomerUser2,
    "Customer user #2 created."
);
my $GroupID2 = $GroupObject->GroupAdd(
    Name    => 'Test_customer_group_#1',
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $GroupID2,
    "Customer Group created."
);
my $SuccessGroupMemberAdd1 = $CustomerGroupObject->GroupMemberAdd(
    GID        => $GroupID2,
    UID        => $CustomerUser1,
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
$Self->True(
    $SuccessGroupMemberAdd1,
    "Customer #1 added to the group."
);
my $SuccessGroupMemberAdd2 = $CustomerGroupObject->GroupMemberAdd(
    GID        => $GroupID2,
    UID        => $CustomerUser2,
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
$Self->True(
    $SuccessGroupMemberAdd2,
    "Customer #2 added to the group."
);

# First get members while both users are Valid
my @Members1 = $CustomerGroupObject->GroupMemberList(
    GroupID => $GroupID2,
    Result  => 'ID',
    Type    => 'ro',
);

@Members1 = sort { $a cmp $b } @Members1;

$Self->IsDeeply(
    \@Members1,
    [
        'jdoe1',
        'jdoe2'
    ],
    "GroupMemberList() - 2 Customer users."
);

# set 2nd user to invalid state
my $CustomerUserInvalid = $CustomerUserObject->CustomerUserUpdate(
    Source         => 'CustomerUser',
    ID             => $CustomerUser2,
    UserCustomerID => $CustomerUser2,
    UserLogin      => 'jdoe2',               # new user login
    UserFirstname  => 'John 2',
    UserLastname   => 'Doe',
    UserEmail      => 'jdoe2@example.com',
    ValidID        => 2,
    UserID         => 1,
);
$Self->True(
    $CustomerUserInvalid,
    "Set 2nd Customer user to invalid",
);

# Get group members again
my @Members2 = $CustomerGroupObject->GroupMemberList(
    GroupID => $GroupID2,
    Result  => 'ID',
    Type    => 'ro',
);

$Self->IsDeeply(
    \@Members2,
    [
        'jdoe1',
    ],
    "GroupMemberList() - 2 Customer users."
);

# cleanup is done by RestoreDatabase

1;
