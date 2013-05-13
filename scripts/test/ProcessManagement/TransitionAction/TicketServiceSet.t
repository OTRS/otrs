# --
# TicketServiceSet.t - TicketServiceSet testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars qw($Self);

use Kernel::Config;
use Kernel::System::UnitTest::Helper;
use Kernel::System::Ticket;
use Kernel::System::Service;
use Kernel::System::ProcessManagement::TransitionAction::TicketServiceSet;

use Kernel::System::VariableCheck qw(:all);

# create local objects
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);
my $ConfigObject = Kernel::Config->new();
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $ServiceObject = Kernel::System::Service->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $ModuleObject = Kernel::System::ProcessManagement::TransitionAction::TicketServiceSet->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    TicketObject => $TicketObject,
);

# define variables
my $UserID     = 1;
my $ModuleName = 'TicketServiceSet';
my $RandomID   = $HelperObject->GetRandomID();

# add a customer user
my $TestUserLogin = $HelperObject->TestCustomerUserCreate();

# ----------------------------------------
# Create new services
# ----------------------------------------
my @Services = (
    {
        Name    => 'Service0' . $RandomID,
        ValidID => 1,
        UserID  => 1,
    },
    {
        Name    => 'Service1' . $RandomID,
        ValidID => 1,
        UserID  => 1,
    },
    {
        Name    => 'Service2' . $RandomID,
        ValidID => 1,
        UserID  => 1,
    },
);

for my $ServiceData (@Services) {
    my $ServiceID = $ServiceObject->ServiceAdd( %{$ServiceData} );

    # sanity test
    $Self->IsNot(
        $ServiceID,
        undef,
        "ServiceADD() for $ServiceData->{Name}, ServiceID should not be undef",
    );

    # store the ServiceID
    $ServiceData->{ServiceID} = $ServiceID;
}

# ----------------------------------------

# ----------------------------------------
# Assign services to customer (0 and 1)
# ----------------------------------------
my $Success = $ServiceObject->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $TestUserLogin,
    ServiceID         => $Services[0]->{ServiceID},
    Active            => 1,
    UserID            => 1,
);

# sanity test
$Self->True(
    $Success,
    "CustomerUserServiceMemberAdd() for user $TestUserLogin, and Service $Services[0]->{Name}"
        . " with true",
);

$Success = $ServiceObject->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $TestUserLogin,
    ServiceID         => $Services[1]->{ServiceID},
    Active            => 1,
    UserID            => 1,
);

# sanity test
$Self->True(
    $Success,
    "CustomerUserServiceMemberAdd() for user $TestUserLogin, and Service $Services[1]->{Name}"
        . " with true",
);

# ----------------------------------------

# ----------------------------------------
# Create a test tickets
# ----------------------------------------
my $TicketID1 = $TicketObject->TicketCreate(
    TN            => undef,
    Title         => 'test',
    QueueID       => 1,
    Lock          => 'unlock',
    Priority      => '3 normal',
    StateID       => 1,
    TypeID        => 1,
    Service       => undef,
    SLA           => undef,
    CustomerID    => undef,
    CustomerUser  => $TestUserLogin,
    OwnerID       => 1,
    ResponsibleID => 1,
    ArchiveFlag   => undef,
    UserID        => $UserID,
);

# sanity checks
$Self->True(
    $TicketID1,
    "TicketCreate() - $TicketID1",
);

my %Ticket1 = $TicketObject->TicketGet(
    TicketID => $TicketID1,
    UserID   => $UserID,
);
$Self->True(
    IsHashRefWithData( \%Ticket1 ),
    "TicketGet() - Get Ticket with ID $TicketID1.",
);

my $TicketID2 = $TicketObject->TicketCreate(
    TN            => undef,
    Title         => 'test',
    QueueID       => 1,
    Lock          => 'unlock',
    Priority      => '3 normal',
    StateID       => 1,
    TypeID        => 1,
    Service       => undef,
    SLA           => undef,
    CustomerID    => undef,
    CustomerUser  => undef,
    OwnerID       => 1,
    ResponsibleID => 1,
    ArchiveFlag   => undef,
    UserID        => $UserID,
);

# sanity checks
$Self->True(
    $TicketID2,
    "TicketCreate() - $TicketID2",
);

my %Ticket2 = $TicketObject->TicketGet(
    TicketID => $TicketID2,
    UserID   => $UserID,
);
$Self->True(
    IsHashRefWithData( \%Ticket2 ),
    "TicketGet() - Get Ticket with ID $TicketID2.",
);

# ----------------------------------------

# Run() tests
my @Tests = (
    {
        Name    => 'No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name   => 'No UserID',
        Config => {
            UserID => undef,
            Ticket => \%Ticket1,
            Config => {
                CustomerID => 'test',
            },
        },
        Success => 0,
    },
    {
        Name   => 'No Ticket',
        Config => {
            UserID => $UserID,
            Ticket => undef,
            Config => {
                CustomerID => 'test',
            },
        },
        Success => 0,
    },
    {
        Name   => 'No Config',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket1,
            Config => {},
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Config',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket1,
            Config => {
                NoAgentNotify => 0,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Ticket Format',
        Config => {
            UserID => $UserID,
            Ticket => 1,
            Config => {
                Service => 'open',
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Config Format',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket1,
            Config => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Service',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket1,
            Config => {
                Service => 'NotExisting' . $RandomID,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong ServiceID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket1,
            Config => {
                ServiceID => 'NotExisting' . $RandomID,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Not assigned Service',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket1,
            Config => {
                Service => $Services[2]->{Name},
            },
        },
        Success => 0,
    },
    {
        Name   => 'Not Assigned ServiceID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket1,
            Config => {
                ServiceID => $Services[2]->{ServiceID},
            },
        },
        Success => 0,
    },
    {
        Name   => "Ticket without customer with Service $Services[0]->{Name}",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket2,
            Config => {
                ServiceID => $Services[0]->{Name},
            },
        },
        Success => 0,
    },
    {
        Name   => "Ticket without customer with ServiceID $Services[1]->{Name}",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket2,
            Config => {
                ServiceID => $Services[0]->{ServiceID},
            },
        },
        Success => 0,
    },
    {
        Name   => "Correct Service $Services[0]->{Name}",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket1,
            Config => {
                Service => $Services[0]->{Name},
            },
        },
        Success => 1,
    },
    {
        Name   => "Correct Service $Services[1]->{Name}",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket1,
            Config => {
                Service => $Services[1]->{Name},
            },
        },
        Success => 1,
    },
    {
        Name   => "Correct ServiceID $Services[0]->{Name}",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket1,
            Config => {
                ServiceID => $Services[0]->{ServiceID},
            },
        },
        Success => 1,
    },
    {
        Name   => "Correct ServiceID $Services[1]->{Name}",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket1,
            Config => {
                ServiceID => $Services[0]->{ServiceID},
            },
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $ModuleObject->Run(
        %{ $Test->{Config} },
        ProcessEntityID          => 'P1',
        ActivityEntityID         => 'A1',
        TransitionEntityID       => 'T1',
        TransitionActionEntityID => 'TA1',
    );

    if ( $Test->{Success} ) {

        $Self->True(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | excecuted with True"
        );

        # get ticket
        my $TicketID = $TicketID1;
        if ( $Test->{Config}->{Ticket}->{TicketID} eq $TicketID2 ) {
            $TicketID = $TicketID2;
        }
        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        ATTRIBUTE:
        for my $Attribute ( sort keys %{ $Test->{Config}->{Config} } ) {

            $Self->True(
                $Ticket{$Attribute},
                "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for TicketID:"
                    . " $TicketID exists with True",
            );

            $Self->Is(
                $Ticket{$Attribute},
                $Test->{Config}->{Config}->{$Attribute},
                "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for TicketID:"
                    . " $TicketID match expected value",
            );
        }
    }
    else {
        $Self->False(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | excecuted with False"
        );
    }
}

#-----------------------------------------
# Destructors to remove our Testitems
# ----------------------------------------

# Tickets
my $Delete = $TicketObject->TicketDelete(
    TicketID => $TicketID1,
    UserID   => 1,
);
$Self->True(
    $Delete,
    "TicketDelete() - $TicketID2",
);

$Delete = $TicketObject->TicketDelete(
    TicketID => $TicketID1,
    UserID   => 1,
);
$Self->True(
    $Delete,
    "TicketDelete() - $TicketID2",
);

# Services
for my $ServiceData (@Services) {
    my $Success = $ServiceObject->ServiceUpdate(
        %{$ServiceData},
        ValidID => 2,
    );

    # sanity test
    $Self->True(
        $Success,
        "ServiceUpdate() for $ServiceData->{Name}, Set service to invalid with true",
    );
}

# ----------------------------------------

1;
