# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $ConfigObject              = $Kernel::OM->Get('Kernel::Config');
my $UserObject                = $Kernel::OM->Get('Kernel::System::User');
my $CustomerUserObject        = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $ServiceObject             = $Kernel::OM->Get('Kernel::System::Service');
my $QueueObject               = $Kernel::OM->Get('Kernel::System::Queue');
my $TypeObject                = $Kernel::OM->Get('Kernel::System::Type');
my $PriorityObject            = $Kernel::OM->Get('Kernel::System::Priority');
my $SLAObject                 = $Kernel::OM->Get('Kernel::System::SLA');
my $StateObject               = $Kernel::OM->Get('Kernel::System::State');
my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $StorableObject            = $Kernel::OM->Get('Kernel::System::Storable');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# set valid options
my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
%ValidList = reverse %ValidList;

# set user options
my $UserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
) || die "Did not get test user";

my $UserID = $UserObject->UserLookup(
    UserLogin => $UserLogin,
);
my %UserData = $UserObject->GetUserData(
    UserID => $UserID,
);
my $NewUserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
) || die "Did not get test user";

my $NewUserID = $UserObject->UserLookup(
    UserLogin => $NewUserLogin,
);
my %NewUserData = $UserObject->GetUserData(
    UserID => $NewUserID,
);

# set customer user options
my $CustomerUserLogin = $Helper->TestCustomerUserCreate()
    || die "Did not get test customer user";

my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
    User => $CustomerUserLogin,
);

my $NewCustomerUserLogin = $Helper->TestCustomerUserCreate()
    || die "Did not get test customer user";

my %NewCustomerUserData = $CustomerUserObject->CustomerUserDataGet(
    User => $NewCustomerUserLogin,
);

my $RandomID = $Helper->GetRandomID();

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

my $NewQueueName = 'NewQueue_' . $RandomID;
my $NewQueueID   = $QueueObject->QueueAdd(
    Name            => $NewQueueName,
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
    $NewQueueID,
    "QueueAdd() ID ($NewQueueID) added successfully"
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

my $NewServiceName = 'NewService_' . $RandomID;
my $NewServiceID   = $ServiceObject->ServiceAdd(
    Name    => $NewServiceName,
    ValidID => $ValidList{'valid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $NewServiceID,
    "ServiceAdd() ID ($NewServiceID) added successfully"
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

my $NewTypeName = 'NewType_' . $RandomID;
my $NewTypeID   = $TypeObject->TypeAdd(
    Name    => $NewTypeName,
    ValidID => $ValidList{'valid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $NewTypeID,
    "TypeAdd() ID ($NewTypeID) added successfully"
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

my $NewPriorityName = 'NewPriority_' . $RandomID;
my $NewPriorityID   = $PriorityObject->PriorityAdd(
    Name    => $NewPriorityName,
    ValidID => $ValidList{'valid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $NewPriorityID,
    "PriorityAdd() ID ($NewPriorityID) added successfully"
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

my $NewSLAName = 'NewSLA_' . $RandomID;
my $NewSLAID   = $SLAObject->SLAAdd(
    Name    => $NewSLAName,
    ValidID => $ValidList{'valid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $NewSLAID,
    "SLAAdd() ID ($NewSLAID) added successfully"
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

my $NewStateName = 'NewState_' . $RandomID;
my $NewStateID   = $StateObject->StateAdd(
    Name    => $NewStateName,
    ValidID => 1,
    TypeID  => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $NewStateID,
    "StateAdd() ID ($NewStateID) added successfully"
);

# Create test ticket dynamic fields.
my @DynamicFieldNames;
for my $Count ( 1 .. 2 ) {
    my $DynamicFieldName = 'DynamicField' . $Count . $RandomID;
    my $DynamicFieldID   = $DynamicFieldObject->DynamicFieldAdd(
        Name       => $DynamicFieldName,
        Label      => 'a description',
        FieldOrder => 99999,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue => 'Default',
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => 1,
    );
    $Self->True(
        $DynamicFieldID,
        "DynamicFieldAdd() ID ($DynamicFieldID) added successfully"
    );

    push @DynamicFieldNames, $DynamicFieldName;
}

# TODO integrate this tests with database tests
# set testing ACLs options
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
                Priority => [$PriorityName],
                State    => [$StateName],
            },
        },
        Possible => {
            Action => [ 'AgentTicketPhone', 'AgentTicketBounce', ],
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
    'DynamicField-2' => {
        Properties => {
            DynamicField => {
                DynamicField_Field2 => ['0'],    # zero-value, see bug#12273
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

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# set ticket options
my $TicketID = $TicketObject->TicketCreate(
    Title         => 'Some Ticket Title',
    Queue         => $QueueName,
    Service       => $ServiceName,
    Type          => $TypeName,
    Lock          => 'unlock',
    Priority      => $PriorityName,
    SLA           => $SLAName,
    State         => $StateName,
    CustomerID    => '123465',
    CustomerUser  => $CustomerUserLogin,
    OwnerID       => $UserID,
    ResponsibleID => $UserID,
    UserID        => 1,
);

# sanity check
$Self->True(
    $TicketID,
    "TicketCreate() ID ($TicketID) created successfully",
);

# Set the test ticket dynamic field values.
for my $Count ( 0 .. 1 ) {
    my $Value;
    if ( $Count == 0 ) {
        $Value = 'Item1';
    }
    elsif ( $Count == 1 ) {
        $Value = '0';
    }

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name => $DynamicFieldNames[$Count],
    );
    my $DynamicFieldValueSetSuccess = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $TicketID,
        Value              => $Value,
        UserID             => $UserID,
    );

    $Self->True(
        $DynamicFieldValueSetSuccess,
        "DynamicField ValueSet() for DynamicField ID ($DynamicFieldNames[$Count]), Ticket ID ($TicketID) set successfully",
    );
}

# define form update based tests
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
        SuccessMatch => 0,
        ReturnData   => {},
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
        Name   => 'ACL Ticket-1 - correct Ticket using Action',
        Config => {
            Data          => '-',
            ReturnType    => 'Action',
            Action        => 'AgentTicketPhone',
            ReturnSubType => '-',
            TicketID      => $TicketID,
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketPhone',
        },
    },
    {
        Name   => 'ACL Ticket-1 - correct Ticket using Data',
        Config => {
            Data => {
                1 => 'AgentTicketPhone',
                2 => 'AgentTicketBounce',
                3 => 'AgentTicketCompose',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            TicketID      => $TicketID,
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketPhone',
            2 => 'AgentTicketBounce',
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

    {
        Name   => 'ACL DynamicField-2 - DynamicField with zero value',
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            DynamicField  => {
                DynamicField_Field2 => ['0'],    # zero-value, see bug#12273
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

    }
    else {
        $Self->True(
            $ACLSuccess,
            "$Test->{Name} executed with True",
        );

        if ( $Test->{Config}->{ReturnType} eq 'Action' ) {

            # get the action data from ACL
            my %ACLActionData = $TicketObject->TicketAclActionData();

            $Self->IsDeeply(
                \%ACLActionData,
                $Test->{ReturnActionData},
                "$Test->{Name} ACL action data",
            );

        }
        else {

            # get the data from ACL
            my %ACLData = $TicketObject->TicketAclData();

            $Self->IsDeeply(
                \%ACLData,
                $Test->{ReturnData},
                "$Test->{Name} ACL data",
            );
        }
    }
}

$Self->True(
    1,
    "--- Start Database ACL Tests ---",
);

# define the database tests
@Tests = (

    # queue based tests
    {
        Name => 'ACL DB-Queue-1 - Sent new queue, Wrong PropertiesDatabase: ',
        ACLs => {
            'DB-Queue-1-A' => {
                PropertiesDatabase => {
                    Queue => {
                        Name => [$NewQueueName],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        State => ['new'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Queue         => $NewQueueName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Queue-1 - Sent new queue, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Queue-1-B' => {
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Queue         => $NewQueueName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
        },
    },
    {
        Name => 'ACL DB-Queue-1 - Sent new queue, Wrong Properties, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Queue-1-C' => {
                Properties => {
                    Queue => {
                        Name => [$QueueName],
                    },
                },
                PropertiesDatabase => {
                    Queue => {
                        Name => [$QueueName],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        State => ['new'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Queue         => $NewQueueName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Queue-1 - Sent new queue, Correct Properties,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Queue-1-D' => {
                Properties => {
                    Queue => {
                        Name => [$NewQueueName],
                    },
                },
                PropertiesDatabase => {
                    Queue => {
                        Name => [$QueueName],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        State => ['new'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Queue         => $NewQueueName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'open',
        },
    },

    # service based tests
    {
        Name => 'ACL DB-Service-1 - Sent new service, Wrong PropertiesDatabase: ',
        ACLs => {
            'DB-Service-1-A' => {
                PropertiesDatabase => {
                    Service => {
                        Name => [$NewServiceName],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            TicketID      => $TicketID,
            Service       => $NewServiceName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Service-1 - Sent new service, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Service-1-B' => {
                PropertiesDatabase => {
                    Service => {
                        Name => [$ServiceName],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', ],
                    },
                },
            },
        },
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
            TicketID      => $TicketID,
            Service       => $NewServiceName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
        },
    },
    {
        Name => 'ACL DB-Service-1 - Sent new service, Wrong Properties,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Service-1-C' => {
                Properties => {
                    Service => {
                        Name => [$ServiceName],
                    },
                },
                PropertiesDatabase => {
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
        },
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
            TicketID      => $TicketID,
            Service       => $NewServiceName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Service-1 - Sent new service, Correct Properties,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Service-1-D' => {
                Properties => {
                    Service => {
                        Name => [$NewServiceName],
                    },
                },
                PropertiesDatabase => {
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
        },
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
            TicketID      => $TicketID,
            Service       => $NewServiceName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },

    # type based tests
    {
        Name => 'ACL DB-Type-1 - Sent new type, Wrong PropertiesDatabase: ',
        ACLs => {
            'DB-Type-1-A' => {
                PropertiesDatabase => {
                    Type => {
                        Name => [$NewTypeName],
                    },
                },
                Possible => {
                    Ticket => {
                        Queue => ['Raw'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            TicketID      => $TicketID,
            Type          => $NewTypeName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Type-1 - Sent new type, Correct PropertiesDatabase:',
        ACLs => {
            'DB-Type-1-B' => {
                PropertiesDatabase => {
                    Type => {
                        Name => [$TypeName],
                    },
                },
                Possible => {
                    Ticket => {
                        Queue => ['Misc'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            TicketID      => $TicketID,
            Type          => $NewTypeName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            4 => 'Misc',
        },
    },
    {
        Name => 'ACL DB-Type-1 - Sent new type, Wrong Properties, Correct PropertiesDatabase:',
        ACLs => {
            'DB-Type-1-C' => {
                Properties => {
                    Type => {
                        Name => [$TypeName],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            TicketID      => $TicketID,
            Type          => $NewTypeName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Type-1 - Sent new type, Correct Properties, Correct PropertiesDatabase:',
        ACLs => {
            'DB-Type-1-D' => {
                Properties => {
                    Type => {
                        Name => [$NewTypeName],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            TicketID      => $TicketID,
            Type          => $NewTypeName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'Raw',
        },
    },

    # customer based tests
    {
        Name => 'ACL DB-CustomerUser-1 - Set new CustomerUser, Wrong PropertiesDatabase: ',
        ACLs => {
            'DB-CustomerUser-1-A' => {
                PropertiesDatabase => {
                    CustomerUser => {
                        UserLogin => [$NewCustomerUserLogin],
                    },
                },
                Possible => {
                    Ticket => {
                        State => ['open'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType     => 'Ticket',
            ReturnSubType  => 'State',
            TicketID       => $TicketID,
            CustomerUserID => $NewCustomerUserData{UserID},
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-CustomerUser-1 - Set new CustomerUser, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-CustomerUser-1-B' => {
                PropertiesDatabase => {
                    CustomerUser => {
                        UserLogin => [$CustomerUserLogin],
                    },
                },
                Possible => {
                    Ticket => {
                        State => ['new'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType     => 'Ticket',
            ReturnSubType  => 'State',
            TicketID       => $TicketID,
            CustomerUserID => $NewCustomerUserData{UserID},
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
        },
    },
    {
        Name => 'ACL DB-CustomerUser-1 - Set new CustomerUser, Wrong Properties,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-CustomerUser-1-C' => {
                Properties => {
                    CustomerUser => {
                        UserLogin => [$CustomerUserLogin],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType     => 'Ticket',
            ReturnSubType  => 'State',
            TicketID       => $TicketID,
            CustomerUserID => $NewCustomerUserData{UserID},
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-CustomerUser-1 - Set new CustomerUser, Correct Properties,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-CustomerUser-1-S' => {
                Properties => {
                    CustomerUser => {
                        UserLogin => [$NewCustomerUserLogin],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType     => 'Ticket',
            ReturnSubType  => 'State',
            TicketID       => $TicketID,
            CustomerUserID => $NewCustomerUserData{UserID},
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'open',
        },
    },

    # priority based tests
    {
        Name => 'ACL DB-Priority-1 - Sent new priority, Wrong Properties: ',
        ACLs => {
            'DB-Priority-1-A' => {
                PropertiesDatabase => {
                    Priority => {
                        Name => [$NewPriorityName],
                    },
                },
                Possible => {
                    Ticket => {
                        State => ['open'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Priority      => $NewPriorityName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Priority-1 - Sent new priority, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Priority-1-B' => {
                PropertiesDatabase => {
                    Priority => {
                        Name => [$PriorityName],
                    },
                },
                Possible => {
                    Ticket => {
                        State => ['new'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Priority      => $NewPriorityName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
        },
    },
    {
        Name => 'ACL DB-Priority-1 - Sent new priority, Wrong Properties,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Priority-1-C' => {
                Properties => {
                    Priority => {
                        Name => [$PriorityName],
                    },
                },
                PropertiesDatabase => {
                    Priority => {
                        Name => [$PriorityName],
                    },
                },
                Possible => {
                    Ticket => {
                        State => ['open'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Priority      => $NewPriorityName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Priority-1 - Sent new priority, Correct Properties,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Priority-1-D' => {
                Properties => {
                    Priority => {
                        Name => [$NewPriorityName],
                    },
                },
                PropertiesDatabase => {
                    Priority => {
                        Name => [$PriorityName],
                    },
                },
                Possible => {
                    Ticket => {
                        State => ['open'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Priority      => $NewPriorityName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'open',
        },
    },

    # sla based tests
    {
        Name => 'ACL DB-SLA-1 - Sent new SLA, Wrong PropertiesDatabase: ',
        ACLs => {
            'DB-SLA-1-A' => {
                PropertiesDatabase => {
                    SLA => {
                        Name => [$NewSLAName],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        State => ['open'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            SLA           => $NewSLAName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-SLA-1 - Sent new SLA, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-SLA-1-B' => {
                PropertiesDatabase => {
                    SLA => {
                        Name => [$SLAName],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        State => ['new'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            SLA           => $NewSLAName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'open',
            3 => 'closed',
        },
    },
    {
        Name => 'ACL DB-SLA-1 - Sent new SLA, Wrong Properties, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-SLA-1-C' => {
                Properties => {
                    SLA => {
                        Name => [$SLAName],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            SLA           => $NewSLAName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-SLA-1 - Sent new SLA, Correct Properties, Correct PropertiesDatabase:',
        ACLs => {
            'DB-SLA-1-D' => {
                Properties => {
                    SLA => {
                        Name => [$NewSLAName],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            SLA           => $NewSLAName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
            3 => 'closed',
        },
    },

    # state based tests
    {
        Name => 'ACL DB-State-1 - Sent new state, Wrong PropertiesDatabase: ',
        ACLs => {
            'DB-State-1-A' => {
                PropertiesDatabase => {
                    State => {
                        Name => [$NewStateName],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Queue => ['Raw'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            TicketID      => $TicketID,
            State         => $NewStateName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-State-1 - Sent new state, Correct PropertiesDatabase:',
        ACLs => {
            'DB-State-1-B' => {
                PropertiesDatabase => {
                    State => {
                        Name => [$StateName],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Queue => ['Junk'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            TicketID      => $TicketID,
            State         => $NewStateName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'Raw',
            2 => 'PostMaster',
            4 => 'Misc',
        },
    },
    {
        Name => 'ACL DB-State-1 - Sent new state, Wrong Properties, Correct PropertiesDatabase:',
        ACLs => {
            'DB-State-1-C' => {
                Properties => {
                    State => {
                        Name => [$StateName],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            TicketID      => $TicketID,
            State         => $NewStateName,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-State-1 - Sent new state, Correct Properties,'
            . ' Correct PropertiesDatabase:',
        ACLs => {
            'DB-State-1-D' => {
                Properties => {
                    State => {
                        Name => [$NewStateName],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'Raw',
                2 => 'PostMaster',
                3 => 'Junk',
                4 => 'Misc',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Queue',
            TicketID      => $TicketID,
            State         => $NewStateName,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'PostMaster',
            3 => 'Junk',
            4 => 'Misc',
        },
    },

    # owner based tests
    {
        Name => 'ACL DB-Owner-1 - Sent new owner, Wrong PropertiesDatabase: ',
        ACLs => {
            'DB-Owner-1-A' => {
                PropertiesDatabase => {
                    Owner => {
                        UserLogin => [$NewUserLogin],
                    },
                },
                Possible => {
                    Ticket => {
                        State => ['open'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Owner         => $NewUserLogin,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Owner-1 - Sent new owner, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Owner-1-B' => {
                PropertiesDatabase => {
                    Owner => {
                        UserLogin => [$UserLogin],
                    },
                },
                Possible => {
                    Ticket => {
                        State => ['closed'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Owner         => $NewUserLogin,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            3 => 'closed',
        },
    },
    {
        Name => 'ACL DB-Owner-1 - Sent new owner, Wrong Properties, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Owner-1-C' => {
                Properties => {
                    Owner => {
                        UserLogin => [$UserLogin],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Owner         => $NewUserLogin,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Owner-1 - Sent new owner, Correct Properties,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Owner-1-D' => {
                Properties => {
                    Owner => {
                        UserLogin => [$NewUserLogin],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Owner         => $NewUserLogin,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'open',
        },
    },

    # responsible based tests
    {
        Name => 'ACL DB-Responsible-1 - Sent new responsible, Wrong PropertiesDatabase: ',
        ACLs => {
            'DB-Responsible-1-A' => {
                PropertiesDatabase => {
                    Responsible => {
                        UserLogin => [$NewUserLogin],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        State => ['open'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Responsible   => $NewUserLogin,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Responsible-1 - Sent new responsible, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Responsible-1-B' => {
                PropertiesDatabase => {
                    Responsible => {
                        UserLogin => [$UserLogin],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        State => ['closed'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Responsible   => $NewUserLogin,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
            2 => 'open',
        },
    },
    {
        Name => 'ACL DB-Responsible-1 - Sent new responsible, Wrong Properties,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Responsible-1-C' => {
                Properties => {
                    Responsible => {
                        UserLogin => [$UserLogin],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Responsible   => $NewUserLogin,
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-Responsible-1 - Sent new responsible, Correct Properties,'
            . ' Correct PropertiesDatabase:',
        ACLs => {
            'DB-Responsible-1-D' => {
                Properties => {
                    Responsible => {
                        UserLogin => [$NewUserLogin],
                    },
                },
                PropertiesDatabase => {
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
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed'
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            Responsible   => $NewUserLogin,
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
            3 => 'closed',
        },
    },

    # frontend based tests
    {
        Name => 'ACL DB-Frontend-1 - correct Action: ',
        ACLs => {
            'DB-Frontend-1' => {
                PropertiesDatabase => {
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
        },
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

    # ticket based tests
    {
        Name => 'ACL DB-Ticket-1 - Sent new params, Wrong PropertiesDatabase :',
        ACLs => {
            'DB-Ticket-1-A' => {
                PropertiesDatabase => {
                    Ticket => {
                        Queue    => [$NewQueueName],
                        Priority => [$NewPriorityName],
                        State    => [$NewStateName],
                    },
                },
                Possible => {
                    Action => ['AgentTicketCompose'],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            TicketID      => $TicketID,
            Queue         => $NewQueueName,
            Priority      => $NewPriorityName,
            State         => $NewStateName,
            UserID        => $UserID,
        },

        # Action ACL always return false
        SuccessMatch     => 0,
        ReturnActionData => {},
    },
    {
        Name => 'ACL DB-Ticket-1 - Sent new params, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-Ticket-1-B' => {
                PropertiesDatabase => {
                    Ticket => {
                        Queue    => [$QueueName],
                        Priority => [$PriorityName],
                        State    => [$StateName],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketClose', 'AgentTicketBounce', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            TicketID      => $TicketID,
            Queue         => $NewQueueName,
            Priority      => $NewPriorityName,
            State         => $NewStateName,
            UserID        => $UserID,
        },

        # Action ACL always return false
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
        },
    },
    {
        Name => 'ACL DB-Ticket-1 - Sent new params, Wrong Properties,'
            . ' Correct PropertiesDatabase:',
        ACLs => {
            'DB-Ticket-1-C' => {
                Properties => {
                    Ticket => {
                        Queue    => [$QueueName],
                        Priority => [$PriorityName],
                        State    => [$StateName],
                    },
                },
                PropertiesDatabase => {
                    Ticket => {
                        Queue    => [$QueueName],
                        Priority => [$PriorityName],
                        State    => [$StateName],
                    },
                },
                Possible => {
                    Action => ['AgentTicketCompose'],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            TicketID      => $TicketID,
            Queue         => $NewQueueName,
            Priority      => $NewPriorityName,
            State         => $NewStateName,
            UserID        => $UserID,
        },
        SuccessMatch     => 0,
        ReturnActionData => {},
    },
    {
        Name => 'ACL DB-Ticket-2 - Sent new params, Wrong Properties,'
            . ' Correct PropertiesDatabase:',
        ACLs => {
            'DB-Ticket-1-D' => {
                Properties => {
                    Ticket => {
                        Queue    => [$NewQueueName],
                        Priority => [$NewPriorityName],
                        State    => [$NewStateName],
                    },
                },
                PropertiesDatabase => {
                    Ticket => {
                        Queue    => [$QueueName],
                        Priority => [$PriorityName],
                        State    => [$StateName],
                    },
                },
                Possible => {
                    Action => ['AgentTicketCompose'],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            TicketID      => $TicketID,
            Queue         => $NewQueueName,
            Priority      => $NewPriorityName,
            State         => $NewStateName,
            UserID        => $UserID,
        },

        # Action ACL always return false
        SuccessMatch     => 1,
        ReturnActionData => {}
    },

    # dynamic fields based tests
    {
        Name => 'ACL DB-DynamicField-1 - Sent new dynamic field value,'
            . ' Wrong PropertiesDatabase: ',
        ACLs => {
            'DB-DynamicField-1-A' => {
                PropertiesDatabase => {
                    DynamicField => {
                        'DynamicField_' . $DynamicFieldNames[0] => ['Item2'],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        State => ['open'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            DynamicField  => {
                'DynamicField_' . $DynamicFieldNames[0] => ['Item2']
            },
            UserID => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-DynamicField-1 - Sent new dynamic field value,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-DynamicField-1-B' => {
                PropertiesDatabase => {
                    DynamicField => {
                        'DynamicField_' . $DynamicFieldNames[0] => ['Item1'],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        State => ['new'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            DynamicField  => {
                'DynamicField_' . $DynamicFieldNames[0] => ['Item2']
            },
            UserID => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => 'open',
            3 => 'closed',
        },
    },
    {
        Name => 'ACL DB-DynamicField-1 - Sent new dynamic field value, Wrong Properties,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-DynamicField-1-C' => {
                Properties => {
                    DynamicField => {
                        'DynamicField_' . $DynamicFieldNames[0] => ['Item1'],
                    },
                },
                PropertiesDatabase => {
                    DynamicField => {
                        'DynamicField_' . $DynamicFieldNames[0] => ['Item1'],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        State => ['open'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            DynamicField  => {
                'DynamicField_' . $DynamicFieldNames[0] => ['Item2']
            },
            UserID => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-DynamicField-1 - Sent new dynamic field value, Correct Properties,'
            . ' Correct PropertiesDatabase: ',
        ACLs => {
            'DB-DynamicField-1-C' => {
                Properties => {
                    DynamicField => {
                        'DynamicField_' . $DynamicFieldNames[0] => ['Item2'],
                    },
                },
                PropertiesDatabase => {
                    DynamicField => {
                        'DynamicField_' . $DynamicFieldNames[0] => ['Item1'],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        State => ['open'],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => 'new',
                2 => 'open',
                3 => 'closed',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            TicketID      => $TicketID,
            DynamicField  => {
                'DynamicField_' . $DynamicFieldNames[0] => ['Item2']
            },
            UserID => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => 'new',
            3 => 'closed',
        },
    },
    {
        Name => 'ACL DB-DynamicField - restrict action',
        ACLs => {
            'DB-DynamicField' => {
                Properties => {
                    DynamicField => {
                        'DynamicField_' . $DynamicFieldNames[0] => ['Item1'],
                    },
                },
                PossibleNot => {
                    Action => ['AgentTicketClose'],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketPrint',
                2 => 'AgentTicketClose',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            TicketID      => $TicketID,
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketPrint',
        }
    },

    # user based tests
    {
        Name => 'ACL DB-User-1 - Wrong PropertiesDatabase: ',
        ACLs => {
            'DB-User-1-A' => {
                PropertiesDatabase => {
                    User => {
                        UserLogin => [$NewUserLogin],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-User-1 - Correct PropertiesDatabase: ',
        ACLs => {
            'DB-User-1-B' => {
                PropertiesDatabase => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Priority => ['2 low'],
                    },
                },
            },
        },
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
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
            4 => '4 high',
            5 => '5 very high'
        },
    },
    {
        Name => 'ACL DB-User-1 - Wrong Properties, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-User-1-C' => {
                Properties => {
                    User => {
                        UserLogin => [$NewUserLogin],
                    },
                },
                PropertiesDatabase => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Priority => ['2 low'],
                    },
                },
            },
        },
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
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL DB-User-1 - Correct Properties, Correct PropertiesDatabase: ',
        ACLs => {
            'DB-User-1-D' => {
                Properties => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                PropertiesDatabase => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => '2 low',
            4 => '4 high',
            5 => '5 very high'
        },
    },
);

# Get role object.
my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

# Add some roles
my $RoleID1 = $GroupObject->RoleAdd(
    Name    => "unittest1-$RandomID",
    Comment => 'comment describing the role',
    ValidID => 1,
    UserID  => 1,
);
$Self->IsNot(
    $RoleID1,
    undef,
    "RoleAdd() - RoleID1",
);
my $RoleID2 = $GroupObject->RoleAdd(
    Name    => "unittest2-$RandomID",
    Comment => 'comment describing the role',
    ValidID => 1,
    UserID  => 1,
);
$Self->IsNot(
    $RoleID2,
    undef,
    "RoleAdd() - RoleID2",
);

my $RemoveRoles = sub {

    for my $RoleID ( $RoleID1, $RoleID2 ) {
        my $Success = $GroupObject->PermissionRoleUserAdd(
            UID    => $UserID,
            RID    => $RoleID,
            Active => 0,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Test user removed from Role $RoleID",
        );
    }
};

my $ExecuteTests = sub {
    my %Param = @_;
    my @Tests = @{ $Param{Tests} };

    for my $Test (@Tests) {

        # clean previous data
        $TicketObject->{TicketAclData} = {};

        if ( $Test->{AddRoles} ) {
            $RemoveRoles->();
            for my $RoleID ( @{ $Test->{AddRoles} } ) {
                my $Success = $GroupObject->PermissionRoleUserAdd(
                    UID    => $UserID,
                    RID    => $RoleID,
                    Active => 1,
                    UserID => 1,
                );
                $Self->True(
                    $Success,
                    "Test user added to Role $RoleID",
                );
            }
        }

        $ConfigObject->Set(
            Key   => 'TicketAcl',
            Value => $Test->{ACLs},
        );

        $GotACLs = $ConfigObject->Get('TicketAcl');

        # sanity check
        $Self->IsDeeply(
            $GotACLs,
            $Test->{ACLs},
            "$Test->{Name} ACLs Set and Get from sysconfig",
        );

        my $Config     = $Test->{Config};
        my $ACLSuccess = $TicketObject->TicketAcl( %{ $Test->{Config} } );

        # get the data from ACL
        my %ACLData = $TicketObject->TicketAclData();

        if ( !$Test->{SuccessMatch} ) {
            $Self->False(
                $ACLSuccess,
                "$Test->{Name} Executed with False",
            );

            $Self->IsDeeply(
                \%ACLData,
                {},
                "$Test->{Name} ACL data must be empty",
            );
        }
        else {

            if ( $Test->{Config}->{ReturnType} eq 'Action' ) {

                # get the action data from ACL
                # Action ACL always return false
                my %ACLActionData = $TicketObject->TicketAclActionData();

                $Self->IsDeeply(
                    \%ACLActionData,
                    $Test->{ReturnActionData},
                    "$Test->{Name} ACL action data",
                );
            }
            else {
                $Self->True(
                    $ACLSuccess,
                    "$Test->{Name} Executed with True",
                );

                $Self->IsDeeply(
                    \%ACLData,
                    $Test->{ReturnData},
                    "$Test->{Name} ACL data",
                );
            }
        }

        # clean ACLs
        $ConfigObject->Set(
            Key   => 'TicketAcl',
            Value => {},
        );

        $GotACLs = $ConfigObject->Get('TicketAcl');

        # sanity check
        $Self->IsDeeply(
            $GotACLs,
            {},
            "$Test->{Name} ACLs are clean",
        );

        if ( $Test->{AddRoles} ) {
            $RemoveRoles->();
        }
    }
};
$ExecuteTests->( Tests => \@Tests );

# special tests
@Tests = (

    # Properties Not
    {
        Name => 'ACL Queue - Using [Not]:',
        ACLs => {
            'Not-Queue-Raw' => {
                Properties => {
                    Queue => {
                        Name => ['[Not]Raw'],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            Queue         => 'Misc',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL Queue - Using [Not] Negated Queue:',
        ACLs => {
            'Not-Queue-Raw' => {
                Properties => {
                    Queue => {
                        Name => ['[Not]Raw'],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL Queue - Using [Not] in an Array:',
        ACLs => {
            'Not-Queue-Raw' => {
                Properties => {
                    Queue => {
                        Name => [ '[Not]Raw', '[Not]Postmaster' ],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            Queue         => 'Misc',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },

    # Properties NotRegExp
    {
        Name => 'ACL Queue - Using [NotRegExp]:',
        ACLs => {
            'Not-Queue-Raw' => {
                Properties => {
                    Queue => {
                        Name => ['[NotRegExp]HW'],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            Queue         => 'Misc',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL Queue - Using [NotRegExp] Negated Queue:',
        ACLs => {
            'Not-Queue-Raw' => {
                Properties => {
                    Queue => {
                        Name => ['[NotRegExp]aw'],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL Queue - Using [NotRegExp] in an Array:',
        ACLs => {
            'Not-Queue-Raw' => {
                Properties => {
                    Queue => {
                        Name => [ '[NotRegExp]aw', '[NotRegExp]master' ],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            Queue         => 'Misc',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },

    # Properties Notregexp
    {
        Name => 'ACL Queue - Using [Notregexp]:',
        ACLs => {
            'Not-Queue-Raw' => {
                Properties => {
                    Queue => {
                        Name => ['[Notregexp]HW'],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            Queue         => 'Misc',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL Queue - Using [Notregexp] Negated Queue:',
        ACLs => {
            'Not-Queue-Raw' => {
                Properties => {
                    Queue => {
                        Name => ['[Notregexp]ra'],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {},
    },
    {
        Name => 'ACL Queue - Using [Notregexp] in an Array:',
        ACLs => {
            'Not-Queue-Raw' => {
                Properties => {
                    Queue => {
                        Name => [ '[Notregexp]ra', '[Notregexp]master' ],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
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
            Queue         => 'Misc',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },

    # combination possible, possible not
    {
        Name => 'ACL Queue - Possible/PossibleNot:',
        ACLs => {
            'Queue-Possible-Priority' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '2 low', '3 medium', ],
                    },
                },
            },
            'Queue-Possible-Priority2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Priority => [ '2 low', ],
                    },
                },
            },
        },
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
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL Queue - Possible/PossibleNot Join:',
        ACLs => {
            'Queue-Possible-Priority' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '2 low', '3 medium', ],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Priority => [ '2 low', ],
                    },
                },
            },
        },
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
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL Queue - PossibleNot only:',
        ACLs => {
            'Queue-Possible-Priority2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Priority => [ '2 low', ],
                    },
                },
            },
        },
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
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
            4 => '4 high',
            5 => '5 very high',
        },
    },
    {
        Name => 'ACL DB-User-1 - Possible/PossibleAdd: ',
        ACLs => {
            'DB-User-1-D' => {
                Properties => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                Properties => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
            'DB-User-1-E' => {
                Properties => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                Properties => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                PossibleAdd => {
                    Ticket => {
                        Priority => [ '4 high', ],
                    },
                },
            },
        },
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
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
            4 => '4 high'
        },
    },
    {
        Name => 'ACL DB-User-1 - Possible/PossibleAdd/Possible: ',
        ACLs => {
            'DB-User-1-D' => {
                Properties => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                Properties => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
            'DB-User-1-E' => {
                Properties => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                Properties => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                PossibleAdd => {
                    Ticket => {
                        Priority => [ '4 high', ],
                    },
                },
            },
            'DB-User-1-F' => {
                Properties => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                Properties => {
                    User => {
                        UserLogin => [$UserLogin],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '4 high', ],
                    },
                },
            },

        },
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
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            4 => '4 high'
        },
    },
    {
        Name => 'ACL Queue - PossibleNot/PossibleAdd:',
        ACLs => {
            'Queue-Possible-Priority1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Priority => [ '1 very low', '2 low', ],
                    },
                },
            },
            'Queue-Possible-Priority2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Ticket => {
                        Priority => [ '2 low', ],
                    },
                },
            },
        },
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
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            2 => '2 low',
            3 => '3 medium',
            4 => '4 high',
            5 => '5 very high'
        },
    },
    {
        Name => 'ACL Queue - PossibleNot/Possible:',
        ACLs => {
            'Queue-Possible-Priority1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Priority => [ '2 low', ],
                    },
                },
            },
            'Queue-Possible-Priority2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '2 low', '3 medium', ],
                    },
                },
            },
        },
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
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            2 => '2 low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL Queue - Possible/PossibleAdd/PossibleNot:',
        ACLs => {
            'Queue-Possible-Priority1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '2 low', ],
                    },
                },
            },
            'Queue-Possible-Priority2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Ticket => {
                        Priority => [ '2 low', '3 medium', '4 high' ],
                    },
                },
            },
            'Queue-Possible-Priority3' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Ticket => {
                        Priority => [ '3 medium', ],
                    },
                },
            },
        },
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
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            2 => '2 low',
            4 => '4 high',
        },
    },
);
$Self->True(
    1,
    "--- Start Special ACL Tests ---",
);
$ExecuteTests->( Tests => \@Tests );

# Array match tests
my @TestsNormal = (
    {
        Name => 'ACL User Role - No roles check unittest1',
        ACLs => {
            'Role-Test' => {
                Properties => {
                    User => {
                        Role => ["unittest1-$RandomID"],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            UserID        => $UserID,
        },
        SuccessMatch => 0,
        ReturnData   => {
            1 => '1 very low',
            2 => '2 low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL User Role - 1 role (wrong) check unittest1',
        ACLs => {
            'Role-Test' => {
                Properties => {
                    User => {
                        Role => ["unittest1-$RandomID"],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            UserID        => $UserID,
        },
        AddRoles     => [$RoleID2],
        SuccessMatch => 0,
        ReturnData   => {
            1 => '1 very low',
            2 => '2 low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL User Role -  1 role check unittest1',
        ACLs => {
            'Role-Test' => {
                Properties => {
                    User => {
                        Role => ["unittest1-$RandomID"],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            UserID        => $UserID,
        },
        AddRoles     => [$RoleID1],
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL User Role -  2 role check unittest1',
        ACLs => {
            'Role-Test' => {
                Properties => {
                    User => {
                        Role => ["unittest1-$RandomID"],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            UserID        => $UserID,
        },
        AddRoles     => [ $RoleID1, $RoleID2 ],
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL User Role -  2 role check unittest2',
        ACLs => {
            'Role-Test' => {
                Properties => {
                    User => {
                        Role => ["unittest2-$RandomID"],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            UserID        => $UserID,
        },
        AddRoles     => [ $RoleID1, $RoleID2 ],
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
);

my %TestModifiers = (
    RegExp => [
        {
            Name => 'ACL User Role - No roles check [RegExp]unittest1',
            Role => ["[RegExp]unittest1"]
        },
        {
            Name => 'ACL User Role - 1 role (wrong) check [RegExp]unittest1',
            Role => ["[RegExp]unittest1"]
        },
        {
            Name => 'ACL User Role -  1 role check [RegExp]unittest1',
            Role => ["[RegExp]unittest1"]
        },
        {
            Name => 'ACL User Role -  2 role check [RegExp]unittest1',
            Role => ["[RegExp]unittest1"]
        },
        {
            Name => 'ACL User Role -  2 role check [RegExp]unittest2',
            Role => ["[RegExp]unittest2"]
        }
    ],
    regexp => [
        {
            Name => 'ACL User Role - No roles check [regexp]unittest1',
            Role => ["[regexp]unittest1"]
        },
        {
            Name => 'ACL User Role - 1 role (wrong) check [regexp]unittest1',
            Role => ["[regexp]unittest1"]
        },
        {
            Name => 'ACL User Role -  1 role check [regexp]unittest1',
            Role => ["[regexp]unittest1"]
        },
        {
            Name => 'ACL User Role -  2 role check [regexp]unittest1',
            Role => ["[regexp]unittest1"]
        },
        {
            Name => 'ACL User Role -  2 role check [regexp]unittest2',
            Role => ["[regexp]unittest2"]
        },
    ]
);

my $NumberOfTests = $#TestsNormal;

for my $TestCase ( sort keys %TestModifiers ) {
    for my $Index ( 0 .. $NumberOfTests ) {

        my $Test = $StorableObject->Clone( Data => $TestsNormal[$Index] );

        $Test->{Name} = $TestModifiers{$TestCase}->[$Index]->{Name};
        $Test->{ACLs}->{'Role-Test'}->{Properties}->{User}->{Role} = $TestModifiers{$TestCase}->[$Index]->{Role};

        push @TestsNormal, $Test;
    }
}

my @TestsNot = (
    {
        Name => 'ACL User Role - No roles check [Not]unittest1:',
        ACLs => {
            'Role-Test' => {
                Properties => {
                    User => {
                        Role => ["[Not]unittest1-$RandomID"],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            UserID        => $UserID,
        },
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL User Role - 1 role (wrong) check [Not]unittest1:',
        ACLs => {
            'Role-Test' => {
                Properties => {
                    User => {
                        Role => ["[Not]unittest1-$RandomID"],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            UserID        => $UserID,
        },
        AddRoles     => [$RoleID2],
        SuccessMatch => 1,
        ReturnData   => {
            1 => '1 very low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL User Role - 1 role check [Not]unittest1:',
        ACLs => {
            'Role-Test' => {
                Properties => {
                    User => {
                        Role => ["[Not]unittest1-$RandomID"],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            UserID        => $UserID,
        },
        AddRoles     => [$RoleID1],
        SuccessMatch => 0,
        ReturnData   => {
            1 => '1 very low',
            2 => '2 low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL User Role -  2 role check [Not]unittest1:',
        ACLs => {
            'Role-Test' => {
                Properties => {
                    User => {
                        Role => ["[Not]unittest1-$RandomID"],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            UserID        => $UserID,
        },
        AddRoles     => [ $RoleID1, $RoleID2 ],
        SuccessMatch => 0,
        ReturnData   => {
            1 => '1 very low',
            2 => '2 low',
            3 => '3 medium',
        },
    },
    {
        Name => 'ACL User Role -  2 role check [Not]unittest2:',
        ACLs => {
            'Role-Test' => {
                Properties => {
                    User => {
                        Role => ["[Not]unittest2-$RandomID"],
                    },
                },
                Possible => {
                    Ticket => {
                        Priority => [ '1 very low', '3 medium', ],
                    },
                },
            },
        },
        Config => {
            Data => {
                1 => '1 very low',
                2 => '2 low',
                3 => '3 medium',
            },
            ReturnType    => 'Ticket',
            ReturnSubType => 'Priority',
            UserID        => $UserID,
        },
        AddRoles     => [ $RoleID1, $RoleID2 ],
        SuccessMatch => 0,
        ReturnData   => {
            1 => '1 very low',
            2 => '2 low',
            3 => '3 medium',
        },
    },
);

%TestModifiers = (
    RegExp => [
        {
            Name => 'ACL User Role - No roles check [NotRegExp]unittest1',
            Role => ["[NotRegExp]unittest1"]
        },
        {
            Name => 'ACL User Role - 1 role (wrong) check [NotRegExp]unittest1',
            Role => ["[NotRegExp]unittest1"]
        },
        {
            Name => 'ACL User Role -  1 role check [NotRegExp]unittest1',
            Role => ["[NotRegExp]unittest1"]
        },
        {
            Name => 'ACL User Role -  2 role check [NotRegExp]unittest1',
            Role => ["[NotRegExp]unittest1"]
        },
        {
            Name => 'ACL User Role -  2 role check [NotRegExp]unittest2',
            Role => ["[NotRegExp]unittest2"]
        }
    ],
    regexp => [
        {
            Name => 'ACL User Role - No roles check [Notregexp]unittest1',
            Role => ["[Notregexp]unittest1"]
        },
        {
            Name => 'ACL User Role - 1 role (wrong) check [Notregexp]unittest1',
            Role => ["[Notregexp]unittest1"]
        },
        {
            Name => 'ACL User Role -  1 role check [Notregexp]unittest1',
            Role => ["[Notregexp]unittest1"]
        },
        {
            Name => 'ACL User Role -  2 role check [Notregexp]unittest1',
            Role => ["[Notregexp]unittest1"]
        },
        {
            Name => 'ACL User Role -  2 role check [Notregexp]unittest2',
            Role => ["[Notregexp]unittest2"]
        },
    ]
);

$NumberOfTests = $#TestsNot;

for my $TestCase ( sort keys %TestModifiers ) {
    for my $Index ( 0 .. $NumberOfTests ) {

        my $Test = Storable::dclone( $TestsNot[$Index] );

        $Test->{Name} = $TestModifiers{$TestCase}->[$Index]->{Name};
        $Test->{ACLs}->{'Role-Test'}->{Properties}->{User}->{Role} = $TestModifiers{$TestCase}->[$Index]->{Role};

        push @TestsNot, $Test;
    }
}

@Tests = ( @TestsNormal, @TestsNot );

$Self->True(
    1,
    "--- Start Array match ACL Tests ---",
);
$ExecuteTests->( Tests => \@Tests );

# cleanup is done by RestoreDatabase.

1;
