# --
# TicketACL.t - Ticket Access Control Lists tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TicketACL.t,v 1.3 2011-11-16 20:18:50 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use Kernel::Config;
use Kernel::System::DB;
use Kernel::System::Ticket;
use Kernel::System::User;
use Kernel::System::CustomerUser;
use Kernel::System::UnitTest::Helper;
use Kernel::System::Valid;
use Kernel::System::Queue;
use Kernel::System::Service;
use Kernel::System::Type;
use Kernel::System::Priority;
use Kernel::System::SLA;
use Kernel::System::State;

use vars qw($Self);

# create objects
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);
my $ConfigObject = Kernel::Config->new();
my $ValidObject  = Kernel::System::Valid->new( %{$Self} );
my $UserObject   = Kernel::System::User->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $CustomerUserObject = Kernel::System::CustomerUser->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $QueueObject    = Kernel::System::Queue->new( %{$Self} );
my $ServiceObject  = Kernel::System::Service->new( %{$Self} );
my $TypeObject     = Kernel::System::Type->new( %{$Self} );
my $PriorityObject = Kernel::System::Priority->new( %{$Self} );
my $SLAObject      = Kernel::System::SLA->new( %{$Self} );
my $StateObject    = Kernel::System::State->new( %{$Self} );

# set valid options
my %ValidList = $ValidObject->ValidList();
%ValidList = reverse %ValidList;

# set user options
my $UserLogin = $HelperObject->TestUserCreate(
    Groups => ['admin'],
) || die "Did not get test user";

my $UserID = $UserObject->UserLookup(
    UserLogin => $UserLogin,
);
my %UserData = $UserObject->GetUserData(
    UserID => $UserID,
);

# set customer user options
my $CustomerUserLogin = $HelperObject->TestCustomerUserCreate()
    || die "Did not get test customer user";

my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
    User => $CustomerUserLogin,
);

# set helper options
my $RandomID = $HelperObject->GetRandomID();
$RandomID =~ s/\-//g;

# set queue options
my $QueueName = 'Queue_' . $RandomID;
my $QueueID   = $QueueObject->QueueAdd(
    Name            => $QueueName,
    ValidID         => $ValidList{'valid'},
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

# sanity check
$Self->True(
    $QueueID,
    "QueueAdd() ID ($QueueID) added successfully"
);

my %QueueData = $QueueObject->QueueGet(
    ID     => $QueueID,
    UserID => 1,
);

# set service options
my $ServiceName = 'Service_' . $RandomID;
my $ServiceID   = $ServiceObject->ServiceAdd(
    Name    => $ServiceName,
    ValidID => $ValidList{'valid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $ServiceID,
    "ServiceAdd() ID ($ServiceID) added successfully"
);

my %ServiceData = $ServiceObject->ServiceGet(
    ServiceID => $ServiceID,
    UserID    => 1,
);

# set type options
my $TypeName = 'Type_' . $RandomID;
my $TypeID   = $TypeObject->TypeAdd(
    Name    => $TypeName,
    ValidID => $ValidList{'valid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $TypeID,
    "TypeAdd() ID ($TypeID) added successfully"
);

my %TypeData = $TypeObject->TypeGet(
    ID     => $TypeID,
    UserID => 1,
);

# set priority options
my $PriorityName = 'Priority_' . $RandomID;
my $PriorityID   = $PriorityObject->PriorityAdd(
    Name    => $PriorityName,
    ValidID => $ValidList{'valid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $PriorityID,
    "PriorityAdd() ID ($PriorityID) added successfully"
);

my %PriorityData = $PriorityObject->PriorityGet(
    PriorityID => $PriorityID,
    UserID     => 1,
);

# set SLA options
my $SLAName = 'SLA_' . $RandomID;
my $SLAID   = $SLAObject->SLAAdd(
    Name    => $SLAName,
    ValidID => $ValidList{'valid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $SLAID,
    "SLAAdd() ID ($SLAID) added successfully"
);

my %SLAData = $SLAObject->SLAGet(
    SLAID  => $SLAID,
    UserID => 1,
);

# set state options
my $StateName = 'State_' . $RandomID;
my $StateID   = $StateObject->StateAdd(
    Name    => $StateName,
    ValidID => 1,
    TypeID  => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $StateID,
    "StateAdd() ID ($StateID) added successfully"
);

my %StateData = $StateObject->StateGet(
    ID     => $StateID,
    UserID => 1,
);

# set testig ACLs options
my %TestACLs = (
    'Queue-1' => {
        Properties => {
            Queue => {
                Name => [$QueueName],
            },
        },
        PossibleNot => {
            Ticket => {
                State => ['open'],
            },
        },
    },
    'Service-1' => {
        Properties => {
            Service => {
                Name => [$ServiceName],
            },
        },
        Possible => {
            Ticket => {
                Priority => [ '1 very low', '3 medium', ],
            },
        },
    },
    'Type-1' => {
        Properties => {
            Type => {
                Name => [$TypeName],
            },
        },
        Possible => {
            Ticket => {
                Queue => ['Raw'],
            },
        },
    },
    'CustomerUser-1' => {
        Properties => {
            CustomerUser => {
                UserLogin => [$CustomerUserLogin],
            },
        },
        Possible => {
            Ticket => {
                State => ['open'],
            },
        },
    },
    'Priority-1' => {
        Properties => {
            Priority => {
                Name => [$PriorityName],
            },
        },
        Possible => {
            Ticket => {
                Queue => ['Raw'],
            },
        },
    },
    'SLA-1' => {
        Properties => {
            SLA => {
                Name => [$SLAName],
            },
        },
        PossibleNot => {
            Ticket => {
                State => ['open'],
            },
        },
    },
    'State-1' => {
        Properties => {
            State => {
                Name => [$StateName],
            },
        },
        PossibleNot => {
            Ticket => {
                Queue => ['Raw'],
            },
        },
    },
    'Owner-1' => {
        Properties => {
            Owner => {
                UserLogin => [$UserLogin],
            },
        },
        Possible => {
            Ticket => {
                State => ['open'],
            },
        },
    },
    'Responsible-1' => {
        Properties => {
            Responsible => {
                UserLogin => [$UserLogin],
            },
        },
        PossibleNot => {
            Ticket => {
                State => ['open'],
            },
        },
    },
    'Frontend-1' => {
        Properties => {
            Frontend => {
                Action => [ 'AgentTicketPhone', 'AgentTicketEmail' ],
            },
        },
        PossibleNot => {
            Ticket => {
                Priority => [ '1 very low', '3 medium', ],
            },
        },
    },
    'Ticket-1' => {
        Properties => {
            Ticket => {
                Queue    => [$QueueName],
                Priority => ['3 normal'],
                State    => ['new'],
            },
        },
        Possible => {
            Action => {
                AgentTicketPhone   => 1,
                AgentTicketEmail   => 1,
                AgentTicketCompose => 0,
            },
        },
    },
    'DynamicField-1' => {
        Properties => {
            DynamicField => {
                DynamicField_Field1 => ['Item1'],
            },
        },
        PossibleNot => {
            Ticket => {
                State => ['open'],
            },
        },
    },
);

$ConfigObject->Set(
    Key   => 'TicketAcl',
    Value => \%TestACLs,
);

my $GotACLs = $ConfigObject->Get('TicketAcl');

# sanity check
$Self->IsDeeply(
    $GotACLs,
    \%TestACLs,
    "ACLs Set and Get from sysconfig",
);

my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},

    # use custom config object with current ACLs
    ConfigObject => $ConfigObject,
);

# set ticket options
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => $QueueName,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID,
    "TicketCreate() ID ($TicketID) created successfully"
);

# define the tests
my @Tests = (
    {
        Name   => 'ACL Queue-1 - wrong Queue',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name   => 'ACL Queue-1 - wrong return type (Action)',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Action',
            ReturnSubType => 'Wrong',
            Queue         => $QueueName,
            UserID        => $UserID,
        },
        SuccessMatch     => 0,
        ReturnActionData => {},
    },
    {
        Name   => 'ACL Queue-1 - wrong return type (Non Action)',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Wrong',
            ReturnSubType => 'State',
            Queue         => $QueueName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
        },
    },
    {
        Name   => 'ACL Queue-1 - wrong return sub type',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Wrong',
            Queue         => $QueueName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name   => 'ACL Queue-1 - correct Queue',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            Queue         => $QueueName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
        },
    },
    {
        Name   => 'ACL Queue-1 - correct QueueID',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            QueueID       => $QueueID,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
        },
    },
    {
        Name   => 'ACL Service-1 - correct Service',
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
                4 => '4 high',
                5 => '5 very high'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            Service       => $ServiceName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
    {
        Name   => 'ACL Service-1 - correct ServiceID',
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
                4 => '4 high',
                5 => '5 very high'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            ServiceID     => $ServiceID,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
    {
        Name   => 'ACL Type-1 - correct Type',
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            Type          => $TypeName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'Raw',
        },
    },
    {
        Name   => 'ACL Type-1 - correct TypeID',
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            TypeID        => $TypeID,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'Raw',
        },
    },
    {
        Name   => 'ACL CustomerUser-1 - correct CustomerUser',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType     => 'Ticket',
            ReturnSubType  => 'State',
            CustomerUserID => $CustomerUserData{UserID},
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'open',
        },
    },
    {
        Name   => 'ACL Priority-1 - correct Priority',
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            Priority      => $PriorityName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'Raw',
        },
    },
    {
        Name   => 'ACL Priority-1 - correct PriorityID',
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            PriorityID    => $PriorityID,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'Raw',
        },
    },
    {
        Name   => 'ACL SLA-1 - correct SLA',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            SLA           => $SLAName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
            3 => 'closed',
        },
    },
    {
        Name   => 'ACL SLA-1 - correct SLAID',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            SLAID         => $SLAID,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
            3 => 'closed'
        },
    },
    {
        Name   => 'ACL State-1 - correct State',
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            State         => $StateName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'PostMaster',
            3 => 'Junk',
            4 => 'Misc',
        },
    },
    {
        Name   => 'ACL State-1 - correct StateID',
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            StateID       => $StateID,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'PostMaster',
            3 => 'Junk',
            4 => 'Misc',
        },
    },
    {
        Name   => 'ACL Owner-1 - correct Owner',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            Owner         => $UserLogin,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'open',
        },
    },
    {
        Name   => 'ACL Owner-1 - correct OwnerID',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            OwnerID       => $UserID,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'open',
        },
    },
    {
        Name   => 'ACL Responsible-1 - correct Responsible',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            Responsible   => $UserLogin,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
            3 => 'closed',
        },
    },
    {
        Name   => 'ACL Responsible-1 - correct ResponsibleID',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            ResponsibleID => $UserID,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
            3 => 'closed'
        },
    },
    {
        Name   => 'ACL Frontend-1 - correct Action',
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
                4 => '4 high',
                5 => '5 very high'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            Action        => 'AgentTicketPhone',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => '2 low',
            4 => '4 high',
            5 => '5 very high'
        },
    },
    {
        Name   => 'ACL Ticket-1 - correct Action',
        Config => {
            Data          => '-',
            ReturnType    => 'Action',
            ReturnSubType => '-',
            TicketID      => $TicketID,
            UserID        => $UserID,
        },
        SuccessMatch     => 0,
        ReturnActionData => {
            AgentTicketCompose => 0,
            AgentTicketEmail   => 1,
            AgentTicketPhone   => 1
        },
    },
    {
        Name   => 'ACL DynamicField-1 - correct DynamicField',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            DynamicField  => {
                DynamicField_Field1 => ['Item1']
            },
            UserID => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
            3 => 'closed',
        },
    },
);

for my $Test (@Tests) {

    my $Config     = $Test->{Config};
    my $ACLSuccess = $TicketObject->TicketAcl( %{ $Test->{Config} } );

    if ( !$Test->{SuccessMatch} ) {
        $Self->False(
            $ACLSuccess,
            "$Test->{Name} executed with False",
        );

        if ( $Test->{Config}->{ReturnType} eq 'Action' ) {

            # get the action data from ACL
            my %ACLActionData = $TicketObject->TicketAclActionData();

            $Self->IsDeeply(
                \%ACLActionData,
                $Test->{ReturnActionData},
                "$Test->{Name} ACL action data",
                )

        }
    }
    else {
        $Self->True(
            $ACLSuccess,
            "$Test->{Name} executed with True",
        );

        # get the data from ACL
        my %ACLData = $TicketObject->TicketAclData();

        $Self->IsDeeply(
            \%ACLData,
            $Test->{ReturnData},
            "$Test->{Name} ACL data",
            )
    }

}

# clean the system
my $QueueUpdateSuccess = $QueueObject->QueueUpdate(
    %QueueData,
    ValidID => $ValidList{'invalid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $QueueUpdateSuccess,
    "QueueUpdate() ID ($QueueID) invalidated successfully"
);

my $ServiceUpdateSuccess = $ServiceObject->ServiceUpdate(
    %ServiceData,
    ValidID => $ValidList{'invalid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $ServiceUpdateSuccess,
    "ServiceUpdate() ID ($ServiceID) invalidated successfully"
);

my $TypeUpdateSuccess = $TypeObject->TypeUpdate(
    %TypeData,
    ValidID => $ValidList{'invalid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $TypeUpdateSuccess,
    "TypeUpdate() ID ($TypeID) invalidated successfully"
);

my $PriorityUpdateSuccess = $PriorityObject->PriorityUpdate(
    %PriorityData,
    PriorityID => $PriorityData{ID},
    ValidID    => $ValidList{'invalid'},
    UserID     => 1,
);

# sanity check
$Self->True(
    $PriorityUpdateSuccess,
    "PriorityUpdate() ID ($PriorityID) invalidated successfully"
);

my $SLAUpdateSuccess = $SLAObject->SLAUpdate(
    %SLAData,
    ValidID => $ValidList{'invalid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $SLAUpdateSuccess,
    "SLAUpdate() ID ($SLAID) invalidated successfully"
);

my $StateUpdateSuccess = $StateObject->StateUpdate(
    %StateData,
    ValidID => $ValidList{'invalid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $StateUpdateSuccess,
    "StateUpdate() ID ($StateID) invalidated successfully"
);

my $TicketDeleteSuccess = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

# sanity check
$Self->True(
    $TypeUpdateSuccess,
    "TicketDelete ID ($TicketID) deleted successfully"
);

1;
