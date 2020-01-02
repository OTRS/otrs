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

# get needed objects
my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
my $CustomerGroupObject   = $Kernel::OM->Get('Kernel::System::CustomerGroup');
my $GroupObject           = $Kernel::OM->Get('Kernel::System::Group');
my $QueueObject           = $Kernel::OM->Get('Kernel::System::Queue');
my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');

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

# set user details
my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate();

my @CustomerUserIDs;
my @CustomerCompanyIDs;
my @GroupIDs;
my @TicketIDs;
for ( 1 .. 3 ) {

    # create test customer user
    my $CustomerUserID = $Helper->TestCustomerUserCreate();
    $Self->True(
        $CustomerUserID,
        "Created test customer user $CustomerUserID",
    );
    push @CustomerUserIDs, $CustomerUserID;

    # create test customer company
    my $CustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID          => $CustomerUserID,
        CustomerCompanyName => $CustomerUserID,
        ValidID             => 1,
        UserID              => 1,
    );
    $Self->True(
        $CustomerCompanyID,
        "Created test customer company $CustomerCompanyID",
    );
    push @CustomerCompanyIDs, $CustomerCompanyID;

    # add customer user to customer company
    my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
        User => $CustomerUserID,
    );
    my $Success = $CustomerUserObject->CustomerUserUpdate(
        %CustomerUser,
        ID             => $CustomerUserID,
        UserCustomerID => $CustomerCompanyID,
        UserID         => 1,
    );
    $Self->True(
        $Success,
        "Added customer user to customer company $CustomerUserID",
    );

    # create test group
    my $GroupID = $GroupObject->GroupAdd(
        Name    => $CustomerUserID,
        ValidID => 1,
        UserID  => 1,
    );
    $Self->True(
        $GroupID,
        "Created test group $CustomerUserID ($GroupID)",
    );
    push @GroupIDs, $GroupID;

    # add customer relations
    $Success = $CustomerGroupObject->GroupCustomerAdd(
        GID        => $GroupID,
        CustomerID => $CustomerCompanyID,
        Permission => {
            $PermissionContextDirect => {
                ro => 1,
            },
        },
        UserID => 1,
    );
    $Self->True(
        $Success,
        "Added customer company to group $CustomerUserID",
    );

    # create test queue
    my $QueueID = $QueueObject->QueueAdd(
        Name            => $CustomerUserID,
        ValidID         => 1,
        GroupID         => $GroupID,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        UserID          => 1,
    );
    $Self->True(
        $QueueID,
        "Created test queue $CustomerUserID ($QueueID)",
    );

    # create test ticket
    my $TicketID = $TicketObject->TicketCreate(
        Title        => $CustomerUserID,
        Queue        => $CustomerUserID,
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerUser => $CustomerUserID,
        CustomerID   => $CustomerCompanyID,
        OwnerID      => $TestUserID,
        UserID       => $TestUserID,
    );
    $Self->True(
        $TicketID,
        "Created test ticket $CustomerUserID ($TicketID)",
    );
    push @TicketIDs, $TicketID;
}

my @Tests = (
    {
        Name   => 'Only CustomerUserID',
        Search => {
            CustomerUserLoginRaw => $CustomerUserIDs[0],
            CustomerUserID       => $CustomerUserIDs[0],
            Permission           => 'ro',
        },
        Result => [ $TicketIDs[0] ],
    },
    {
        Name   => 'Same CustomerUserID',
        Search => {
            CustomerUserLoginRaw => $CustomerUserIDs[0],
            CustomerUserID       => $CustomerUserIDs[0],
            Permission           => 'ro',
        },
        Result => [ $TicketIDs[0] ],
    },
    {
        Name   => 'Same CustomerID',
        Search => {
            CustomerIDRaw  => $CustomerCompanyIDs[0],
            CustomerUserID => $CustomerUserIDs[0],
            Permission     => 'ro',
        },
        Result => [ $TicketIDs[0] ],
    },
    {
        Name   => 'Other CustomerUserID (no access)',
        Search => {
            CustomerUserLoginRaw => $CustomerUserIDs[1],
            CustomerUserID       => $CustomerUserIDs[2],
            Permission           => 'ro',
        },
        Result => [],
    },
    {
        Name   => 'Other CustomerID (no access)',
        Search => {
            CustomerIDRaw  => $CustomerCompanyIDs[1],
            CustomerUserID => $CustomerUserIDs[2],
            Permission     => 'ro',
        },
        Result => [],
    },
    {
        Name             => 'Other CustomerUserID, other CustomerID',
        GrantPermissions => {
            CustomerID => {
                GID        => $GroupIDs[1],
                CustomerID => $CustomerCompanyIDs[2],
                Permission => {
                    $PermissionContextDirect => {
                        ro => 1,
                    },
                    $PermissionContextOtherCustomerID => {
                        ro => 1,
                    },
                },
            }
        },
        Search => {
            CustomerUserLoginRaw => $CustomerUserIDs[1],
            CustomerIDRaw        => $CustomerCompanyIDs[1],
            CustomerUserID       => $CustomerUserIDs[2],
            Permission           => 'ro',
        },
        Result => [ $TicketIDs[1] ],
    },
    {
        Name   => 'Only CustomerUserID (with a CustomerID which has permission on two groups)',
        Search => {
            CustomerUserID => $CustomerUserIDs[2],
            Permission     => 'ro',
        },
        Result => [ $TicketIDs[1], $TicketIDs[2] ],
    },
    {
        Name          => 'Other CustomerUserID, same CustomerID',
        ChangeCompany => {
            CustomerUserID => $CustomerUserIDs[2],
            CustomerID     => $CustomerCompanyIDs[1],
        },
        Search => {
            CustomerUserLoginRaw => $CustomerUserIDs[1],
            CustomerIDRaw        => $CustomerCompanyIDs[1],
            CustomerUserID       => $CustomerUserIDs[2],
            Permission           => 'ro',
        },
        Result => [ $TicketIDs[1] ],
    },

    # Test in the next tests the combination from UserID and CustomerUserID in one  ticket search.
    {
        Name   => 'Same CustomerUserID (with UserID, which has no access)',
        Search => {
            CustomerUserLoginRaw => $CustomerUserIDs[0],
            CustomerUserID       => $CustomerUserIDs[0],
            UserID               => $TestUserID,
            Permission           => 'ro',
        },
        Result => [],
    },

    {
        Name             => 'Same CustomerUserID (with UserID)',
        GrantPermissions => {
            User => {
                GID        => $GroupIDs[0],
                UID        => $TestUserID,
                Permission => {
                    ro => 1,
                },
            }
        },
        Search => {
            CustomerUserLoginRaw => $CustomerUserIDs[0],
            CustomerUserID       => $CustomerUserIDs[0],
            UserID               => $TestUserID,
            Permission           => 'ro',
        },
        Result => [ $TicketIDs[0] ],
    },

    {
        Name   => 'Only CustomerUserID and UserID',
        Search => {
            CustomerUserID => $CustomerUserIDs[0],
            UserID         => $TestUserID,
            Permission     => 'ro',
        },
        Result => [ $TicketIDs[0] ],
    },
    {
        Name =>
            'Only CustomerUserID and UserID (with a CustomerID which has permission on two groups, but UserID only permission for the first group)',
        GrantPermissions => {
            User => {
                GID        => $GroupIDs[1],
                UID        => $TestUserID,
                Permission => {
                    ro => 1,
                },
            }
        },
        ChangeCompany => {
            CustomerUserID => $CustomerUserIDs[2],
            CustomerID     => $CustomerCompanyIDs[2],
        },
        Search => {
            CustomerUserID => $CustomerUserIDs[2],
            UserID         => $TestUserID,
            Permission     => 'ro',
        },
        Result => [ $TicketIDs[1] ],
    },
    {
        Name             => 'Only CustomerUserID and UserID (with a CustomerID which has permission on two groups)',
        GrantPermissions => {
            User => {
                GID        => $GroupIDs[2],
                UID        => $TestUserID,
                Permission => {
                    ro => 1,
                },
            }
        },
        Search => {
            CustomerUserID => $CustomerUserIDs[2],
            UserID         => $TestUserID,
            Permission     => 'ro',
        },
        Result => [ $TicketIDs[1], $TicketIDs[2] ],
    },
    {
        Name => 'Only CustomerUserID and UserID (with a UserID which has more permission than the CustomerUserID)',
        ChangeCompany => {
            CustomerUserID => $CustomerUserIDs[2],
            CustomerID     => $CustomerCompanyIDs[1],
        },
        Search => {
            CustomerUserID => $CustomerUserIDs[2],
            UserID         => $TestUserID,
            Permission     => 'ro',
        },
        Result => [ $TicketIDs[1] ],
    },
);

for my $Test (@Tests) {

    # grant permissions
    if ( $Test->{GrantPermissions} ) {

        if ( $Test->{GrantPermissions}->{CustomerID} ) {
            my $Success = $CustomerGroupObject->GroupCustomerAdd(
                %{ $Test->{GrantPermissions}->{CustomerID} },
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Add customer $Test->{GrantPermissions}->{CustomerID}->{CustomerID} to group $Test->{GrantPermissions}->{CustomerID}->{GID}",
            );
        }

        if ( $Test->{GrantPermissions}->{User} ) {
            my $Success = $GroupObject->PermissionGroupUserAdd(
                %{ $Test->{GrantPermissions}->{User} },
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Add user $Test->{GrantPermissions}->{User}->{UID} to group $Test->{GrantPermissions}->{User}->{GID}",
            );
        }
    }

    # customer company change
    if ( $Test->{ChangeCompany} ) {
        my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
            User => $Test->{ChangeCompany}->{CustomerUserID},
        );
        my $Success = $CustomerUserObject->CustomerUserUpdate(
            %CustomerUser,
            ID             => $Test->{ChangeCompany}->{CustomerUserID},
            UserCustomerID => $Test->{ChangeCompany}->{CustomerID},
            UserID         => 1,
        );
        $Self->True(
            $Success,
            "Added customer user $Test->{ChangeCompany}->{CustomerUserID} to customer company $Test->{ChangeCompany}->{CustomerID}",
        );
    }

    # ticket search
    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        %{ $Test->{Search} },
        OrderBy => ['Up'],
        SortBy  => ['TicketNumber'],
        Result  => 'ARRAY',
    );

    @ReturnedTicketIDs = sort { int $a <=> int $b } @ReturnedTicketIDs;
    @{ $Test->{Result} } = sort { int $a <=> int $b } @{ $Test->{Result} };

    $Self->IsDeeply(
        \@ReturnedTicketIDs,
        $Test->{Result},
        "$Test->{Name} ticket search",
    );
}

# cleanup is done by RestoreDatabase.

1;
