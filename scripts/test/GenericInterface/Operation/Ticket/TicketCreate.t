# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Socket;
use MIME::Base64;

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation::Ticket::TicketCreate;
use Kernel::GenericInterface::Operation::Session::SessionCreate;

use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
# skip SSL certificate verification
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Type',
    Value => 1,
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Frontend::AccountTime',
    Value => 1,
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Frontend::NeedAccountedTime',
    Value => 1,
);

# disable DNS lookups
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CheckMXRecord',
    Value => 0,
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# disable SessionCheckRemoteIP setting
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SessionCheckRemoteIP',
    Value => 0,
);

# enable customer groups support
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CustomerGroupSupport',
    Value => 1,
);

# check if SSL Certificate verification is disabled
$Self->Is(
    $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME},
    0,
    'Disabled SSL certificates verification in environment',
);

my $TestOwnerLogin        = $Helper->TestUserCreate();
my $TestResponsibleLogin  = $Helper->TestUserCreate();
my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();

# Make UserID 1 valid.
my $UserObject = $Kernel::OM->Get('Kernel::System::User');
my %RootUser   = $UserObject->GetUserData(
    UserID => 1,
);
my $Success = $UserObject->UserUpdate(
    %RootUser,
    UserID       => 1,
    ValidID      => 1,
    ChangeUserID => 1,
);
$Self->True(
    $Success,
    "Force root user to be valid",
);

my $OwnerID = $UserObject->UserLookup(
    UserLogin => $TestOwnerLogin,
);
my $ResponsibleID = $UserObject->UserLookup(
    UserLogin => $TestResponsibleLogin,
);

my $InvalidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( Valid => 'invalid' );

# sanity test
$Self->IsNot(
    $InvalidID,
    undef,
    "ValidLookup() for 'invalid' should not be undef"
);

# get group object
my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

# create a new group
my $GroupID = $GroupObject->GroupAdd(
    Name    => 'TestSpecial' . $RandomID,
    Comment => 'comment describing the group',    # optional
    ValidID => 1,
    UserID  => 1,
);

my %GroupData = $GroupObject->GroupGet( ID => $GroupID );

# sanity check
$Self->True(
    IsHashRefWithData( \%GroupData ),
    "GroupGet() - for testing group",
);

# create queue object
my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

my @Queues;

my @QueueProperties = (
    {
        Name    => 'queue1' . $RandomID,
        GroupID => 1,
    },
    {
        Name    => 'queue2' . $RandomID,
        GroupID => $GroupID,
    }
);

# create queues
for my $QueueProperty (@QueueProperties) {
    my $QueueID = $QueueObject->QueueAdd(
        %{$QueueProperty},
        ValidID         => 1,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        Comment         => 'Some comment',
        UserID          => 1,
    );

    # sanity check
    $Self->True(
        $QueueID,
        "QueueAdd() - create testing queue",
    );
    my %QueueData = $QueueObject->QueueGet( ID => $QueueID );

    push @Queues, \%QueueData;
}

# get type object
my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

# create new type
my $TypeID = $TypeObject->TypeAdd(
    Name    => 'TestType' . $RandomID,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $TypeID,
    "TypeAdd() - create testing type",
);

my %TypeData = $TypeObject->TypeGet(
    ID => $TypeID,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%TypeData ),
    "TypeGet() - for testing type",
);

# create service object
my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

# create new service
my $ServiceID = $ServiceObject->ServiceAdd(
    Name    => 'TestService' . $RandomID,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $ServiceID,
    "ServiceAdd() - create testing service",
);

my %ServiceData = $ServiceObject->ServiceGet(
    ServiceID => $ServiceID,
    UserID    => 1,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%ServiceData ),
    "ServiceGet() - for testing service",
);

# set service for the customer
$ServiceObject->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $TestCustomerUserLogin,
    ServiceID         => $ServiceID,
    Active            => 1,
    UserID            => 1,
);

# create SLA object
my $SLAObject = $Kernel::OM->Get('Kernel::System::SLA');

# create new SLA
my $SLAID = $SLAObject->SLAAdd(
    Name       => 'TestSLA' . $RandomID,
    ServiceIDs => [$ServiceID],
    ValidID    => 1,
    UserID     => 1,
);

# sanity check
$Self->True(
    $SLAID,
    "SLAAdd() - create testing SLA",
);

my %SLAData = $SLAObject->SLAGet(
    SLAID  => $SLAID,
    UserID => 1,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%SLAData ),
    "SLAGet() - for testing SLA",
);

# create state object
my $StateObject = $Kernel::OM->Get('Kernel::System::State');

# create new state
my $StateID = $StateObject->StateAdd(
    Name    => 'TestState' . $RandomID,
    TypeID  => 2,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $StateID,
    "StateAdd() - create testing state",
);

my %StateData = $StateObject->StateGet(
    ID => $StateID,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%StateData ),
    "StateGet() - for testing state",
);

# create priority object
my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

# create new priority
my $PriorityID = $PriorityObject->PriorityAdd(
    Name    => 'TestPriority' . $RandomID,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $PriorityID,
    "PriorityAdd() - create testing priority",
);

my %PriorityData = $PriorityObject->PriorityGet(
    PriorityID => $PriorityID,
    UserID     => 1,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%PriorityData ),
    "PriorityGet() - for testing priority",
);

# create dynamic field object
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# add text dynamic field
my %DynamicFieldTextConfig = (
    Name       => "Unittest1$RandomID",
    FieldOrder => 9991,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Label      => 'Description',
    ValidID    => 1,
    Config     => {
        DefaultValue => '',
    },
);
my $FieldTextID = $DynamicFieldObject->DynamicFieldAdd(
    %DynamicFieldTextConfig,
    UserID  => 1,
    Reorder => 0,
);
$Self->True(
    $FieldTextID,
    "Dynamic Field $FieldTextID",
);

# add ID
$DynamicFieldTextConfig{ID} = $FieldTextID;

# add dropdown dynamic field
my %DynamicFieldDropdownConfig = (
    Name       => "Unittest2$RandomID",
    FieldOrder => 9992,
    FieldType  => 'Dropdown',
    ObjectType => 'Ticket',
    Label      => 'Description',
    ValidID    => 1,
    Config     => {
        PossibleValues => [
            1 => 'One',
            2 => 'Two',
            3 => 'Three',
        ],
    },
);
my $FieldDropdownID = $DynamicFieldObject->DynamicFieldAdd(
    %DynamicFieldDropdownConfig,
    UserID  => 1,
    Reorder => 0,
);
$Self->True(
    $FieldDropdownID,
    "Dynamic Field $FieldDropdownID",
);

# add ID
$DynamicFieldDropdownConfig{ID} = $FieldDropdownID;

# add multiselect dynamic field
my %DynamicFieldMultiselectConfig = (
    Name       => "Unittest3$RandomID",
    FieldOrder => 9993,
    FieldType  => 'Multiselect',
    ObjectType => 'Ticket',
    Label      => 'Multiselect label',
    ValidID    => 1,
    Config     => {
        PossibleValues => [
            1 => 'Value9ßüß',
            2 => 'DifferentValue',
            3 => '1234567',
        ],
    },
);
my $FieldMultiselectID = $DynamicFieldObject->DynamicFieldAdd(
    %DynamicFieldMultiselectConfig,
    UserID  => 1,
    Reorder => 0,
);
$Self->True(
    $FieldMultiselectID,
    "Dynamic Field $FieldMultiselectID",
);

# add ID
$DynamicFieldMultiselectConfig{ID} = $FieldMultiselectID;

# add date-time dynamic field
my %DynamicFieldDateTimeConfig = (
    Name       => "Unittest4$RandomID",
    FieldOrder => 9994,
    FieldType  => 'DateTime',
    ObjectType => 'Ticket',
    Label      => 'Description',
    Config     => {
        DefaultValue  => 0,
        YearsInFuture => 0,
        YearsInPast   => 0,
        YearsPeriod   => 0,
    },
    ValidID => 1,
);
my $FieldDateTimeID = $DynamicFieldObject->DynamicFieldAdd(
    %DynamicFieldDateTimeConfig,
    UserID  => 1,
    Reorder => 0,
);
$Self->True(
    $FieldDateTimeID,
    "Dynamic Field $FieldDateTimeID",
);

# add ID
$DynamicFieldDateTimeConfig{ID} = $FieldDateTimeID;

# add date-time dynamic field
my %DynamicFieldDateConfig = (
    Name       => "Unittest5$RandomID",
    FieldOrder => 9995,
    FieldType  => 'Date',
    ObjectType => 'Ticket',
    Label      => 'Description',
    Config     => {
        DefaultValue  => 0,
        YearsInFuture => 0,
        YearsInPast   => 0,
        YearsPeriod   => 0,
    },
    ValidID => 1,
);
my $FieldDateID = $DynamicFieldObject->DynamicFieldAdd(
    %DynamicFieldDateConfig,
    UserID  => 1,
    Reorder => 0,
);
$Self->True(
    $FieldDateID,
    "Dynamic Field $FieldDateID",
);

# add ID
$DynamicFieldDateConfig{ID} = $FieldDateID;

# create webservice object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create webservice object",
);

# set webservice name
my $WebserviceName = '-Test-' . $RandomID;

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Name   => $WebserviceName,
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
        },
        Provider => {
            Transport => {
                Type => '',
            },
        },
    },
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $WebserviceID,
    "Added Webservice",
);

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# prepare webservice config
my $RemoteSystem =
    $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
    . '/nph-genericinterface.pl/WebserviceID/'
    . $WebserviceID;

my $WebserviceConfig = {

    #    Name => '',
    Description =>
        'Test for Ticket Connector using SOAP transport backend.',
    Debugger => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    Provider => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                MaxLength => 10000000,
                NameSpace => 'http://otrs.org/SoapTestInterface/',
                Endpoint  => $RemoteSystem,
            },
        },
        Operation => {
            TicketCreate => {
                Type => 'Ticket::TicketCreate',
            },
            SessionCreate => {
                Type => 'Session::SessionCreate',
            },
        },
    },
    Requester => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                NameSpace => 'http://otrs.org/SoapTestInterface/',
                Encoding  => 'UTF-8',
                Endpoint  => $RemoteSystem,
            },
        },
        Invoker => {
            TicketCreate => {
                Type => 'Test::TestSimple',
            },
            SessionCreate => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# update webservice with real config
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $WebserviceUpdate,
    "Updated Webservice $WebserviceID - $WebserviceName",
);

# Get SessionID
# create requester object
my $RequesterSessionObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
$Self->Is(
    'Kernel::GenericInterface::Requester',
    ref $RequesterSessionObject,
    "SessionID - Create requester object",
);

# create a new user for current test
my $UserLogin = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);
my $Password = $UserLogin;

# create a new user without permissions for current test
my $UserLogin2 = $Helper->TestUserCreate();
my $Password2  = $UserLogin2;

# create a customer where a ticket will use and will have permissions
my $CustomerUserLogin = $Helper->TestCustomerUserCreate();
my $CustomerPassword  = $CustomerUserLogin;

# create a customer that will not have permissions
my $CustomerUserLogin2 = $Helper->TestCustomerUserCreate();
my $CustomerPassword2  = $CustomerUserLogin2;

# start requester with our webservice
my $RequesterSessionResult = $RequesterSessionObject->Run(
    WebserviceID => $WebserviceID,
    Invoker      => 'SessionCreate',
    Data         => {
        UserLogin => $UserLogin,
        Password  => $Password,
    },
);

my $NewSessionID = $RequesterSessionResult->{Data}->{SessionID};
my @Tests        = (
    {
        Name           => 'Empty Request',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {},
        ExpectedData   => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'No Article',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Ticket',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket  => 1,
            Article => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Article',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Test => 1,
            },
            Article => 1,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid DynamicField',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Test => 1,
            },
            Article => {
                Test => 1,
            },
            DynamicField => 1,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Attachment',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Test => 1,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => 1,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Title',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Test => 1,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing CustomerUser',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title => 'Ticket Title',
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid CustomerUser',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Queue or QueueID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Queue',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                Queue        => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid QueueID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Lock',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                Lock         => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid LockID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                LockID       => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Type or TypeID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Type',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                Type         => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid TypeID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Service',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                Service      => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Service',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid SLA',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLA          => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid SLAID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing State or StateID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid State',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                State        => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid StateID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Priority or PriorityID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Priority',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
                Priority     => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid PriorityID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
                PriorityID   => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Owner',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
                PriorityID   => $PriorityID,
                Owner        => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid OwnerID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
                PriorityID   => $PriorityID,
                OwnerID      => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Responsible',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
                PriorityID   => $PriorityID,
                OwnerID      => $OwnerID,
                Responsible  => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ResponsibeID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid PendingTime',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 13,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid PendingTime Diff',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Diff => -123456,
                },
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid PendingTime Diff + Full',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Diff   => 123456,
                    Year   => 2012,
                    Month  => 13,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Subject',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Body',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject => 'Article subject',
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing AutoResponseType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject => 'Article subject',
                Body    => 'Article body',
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid AutoResponseType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ArticleType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'auto reply',
                ArticleType      => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ArticleTypeID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'auto reply',
                ArticleTypeID    => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid SenderType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'auto reply',
                ArticleTypeID    => 1,
                SenderType       => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid SenderTypeID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'auto reply',
                ArticleTypeID    => 1,
                SenderTypeID     => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid From',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'auto reply',
                ArticleTypeID    => 1,
                SenderTypeID     => 1,
                From             => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing ContentType or MIMEType and Charset',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'auto reply',
                ArticleTypeID    => 1,
                SenderTypeID     => 1,
                From             => 'enjoy@otrs.com',
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ContentType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'auto reply',
                ArticleTypeID    => 1,
                SenderTypeID     => 1,
                From             => 'enjoy@otrs.com',
                ContentType      => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing ContentType or MIMEType and Charset',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'auto reply',
                ArticleTypeID    => 1,
                SenderTypeID     => 1,
                From             => 'enjoy@otrs.com',
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid HistoryType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'auto reply',
                ArticleTypeID    => 1,
                SenderTypeID     => 1,
                From             => 'enjoy@otrs.com',
                ContentType      => 'text/plain; charset=UTF8',
                HistoryType      => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing TimeUnit',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'auto reply',
                ArticleTypeID    => 1,
                SenderTypeID     => 1,
                From             => 'enjoy@otrs.com',
                ContentType      => 'text/plain; charset=UTF8',
                HistoryType      => 'NewTicket',
                HistoryComment   => '% % ',
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid TimeUnit',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'auto reply',
                ArticleTypeID    => 1,
                SenderTypeID     => 1,
                From             => 'enjoy@otrs.com',
                ContentType      => 'text/plain; charset=UTF8',
                HistoryType      => 'NewTicket',
                HistoryComment   => '% % ',
                TimeUnit         => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ForceNotificationToUserID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                   => 'Article subject',
                Body                      => 'Article body',
                AutoResponseType          => 'auto reply',
                ArticleTypeID             => 1,
                SenderTypeID              => 1,
                From                      => 'enjoy@otrs.com',
                ContentType               => 'text/plain; charset=UTF8',
                HistoryType               => 'NewTicket',
                HistoryComment            => '% % ',
                TimeUnit                  => 25,
                ForceNotificationToUserID => {
                    Item => 1,
                },
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ForceNotificationToUserID Internal',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                   => 'Article subject',
                Body                      => 'Article body',
                AutoResponseType          => 'auto reply',
                ArticleTypeID             => 1,
                SenderTypeID              => 1,
                From                      => 'enjoy@otrs.com',
                ContentType               => 'text/plain; charset=UTF8',
                HistoryType               => 'NewTicket',
                HistoryComment            => '% % ',
                TimeUnit                  => 25,
                ForceNotificationToUserID => [ 'Invalid' . $RandomID ],
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ExcludeNotificationToUserID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                     => 'Article subject',
                Body                        => 'Article body',
                AutoResponseType            => 'auto reply',
                ArticleTypeID               => 1,
                SenderTypeID                => 1,
                From                        => 'enjoy@otrs.com',
                ContentType                 => 'text/plain; charset=UTF8',
                HistoryType                 => 'NewTicket',
                HistoryComment              => '% % ',
                TimeUnit                    => 25,
                ForceNotificationToUserID   => [1],
                ExcludeNotificationToUserID => {
                    Item => 1,
                },
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ExcludeNotificationToUserID internal',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                     => 'Article subject',
                Body                        => 'Article body',
                AutoResponseType            => 'auto reply',
                ArticleTypeID               => 1,
                SenderTypeID                => 1,
                From                        => 'enjoy@otrs.com',
                ContentType                 => 'text/plain; charset=UTF8',
                HistoryType                 => 'NewTicket',
                HistoryComment              => '% % ',
                TimeUnit                    => 25,
                ForceNotificationToUserID   => [1],
                ExcludeNotificationToUserID => [ 'Invalid' . $RandomID ],
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ExcludeMuteNotificationToUserID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => {
                    Item => 1,
                },
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ExcludeMuteNotificationToUserID internal',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [ 'Invalid' . $RandomID ],
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing DynamicField name',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing DynamicField value',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name => 'Invalid' . $RandomID,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid DynamicField name',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => 'Invalid' . $RandomID,
                Value => 'Invalid' . $RandomID,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid DynamicField value',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => 'Invalid' . $RandomID,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing attachment Content',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing attachment ContentType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing attachment Filename',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'Invalid' . $RandomID,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid attachment ContentType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'Invalid' . $RandomID,
                Filename    => 'Test.txt',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    }
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs PendingTime Diff',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Diff => 10080,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs (Using Session)',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with CDATA tags',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Test content <[[https://example.com/]]>',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with Names',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                Queue        => $Queues[0]->{Name},
                Type         => $TypeData{Name},
                Service      => $ServiceData{Name},
                SLA          => $SLAData{Name},
                State        => $StateData{Name},
                Priority     => $PriorityData{Name},
                Owner        => $TestOwnerLogin,
                Responsible  => $TestResponsibleLogin,
                PendingTime  => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject => 'Article subject äöüßÄÖÜ€ис',
                Body    => 'Article body ɟ ɠ ɡ ɢ ɣ ɤ ɥ ɦ ɧ ʀ ʁ ʂ ʃ ʄ ʅ ʆ ʇ ʈ ʉ ʊ ʋ ʌ ʍ ʎ',
                AutoResponseType                => 'auto reply',
                ArticleType                     => 'email-external',
                SenderType                      => 'agent',
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name             => 'Ticket with external customer user',
        SuccessRequest   => 1,
        SuccessCreate    => 1,
        ExternalCustomer => 1,
        RequestData      => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => 'someone@somehots.com',
                Queue        => $Queues[0]->{Name},
                Type         => $TypeData{Name},
                State        => $StateData{Name},
                Priority     => $PriorityData{Name},
                Owner        => $TestOwnerLogin,
                Responsible  => $TestResponsibleLogin,
                PendingTime  => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject => 'Article subject äöüßÄÖÜ€ис',
                Body    => 'Article body ɟ ɠ ɡ ɢ ɣ ɤ ɥ ɦ ɧ ʀ ʁ ʂ ʃ ʄ ʅ ʆ ʇ ʈ ʉ ʊ ʋ ʌ ʍ ʎ',
                AutoResponseType                => 'auto reply',
                ArticleType                     => 'email-external',
                SenderType                      => 'agent',
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with TimeUnits 0',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                Queue        => $Queues[0]->{Name},
                Type         => $TypeData{Name},
                Service      => $ServiceData{Name},
                SLA          => $SLAData{Name},
                State        => $StateData{Name},
                Priority     => $PriorityData{Name},
                Owner        => $TestOwnerLogin,
                Responsible  => $TestResponsibleLogin,
                PendingTime  => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject äöüßÄÖÜ€ис',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleType                     => 'email-external',
                SenderType                      => 'agent',
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with TimeUnits fractional',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                Queue        => $Queues[0]->{Name},
                Type         => $TypeData{Name},
                Service      => $ServiceData{Name},
                SLA          => $SLAData{Name},
                State        => $StateData{Name},
                Priority     => $PriorityData{Name},
                Owner        => $TestOwnerLogin,
                Responsible  => $TestResponsibleLogin,
                PendingTime  => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject äöüßÄÖÜ€ис',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleType                     => 'email-external',
                SenderType                      => 'agent',
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25.5,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs Agent (No Permission)',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
            },
        },
        Auth => {
            UserLogin => $UserLogin2,
            Password  => $Password2,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.AccessDenied',
                    }
            },
            Success => 1
        },

        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs Customer (With Permissions)',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        Auth => {
            CustomerUserLogin => $CustomerUserLogin,
            Password          => $CustomerPassword,
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs Customer (No Permission)',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[1]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
            },
        },
        Auth => {
            CustomerUserLogin => $CustomerUserLogin2,
            Password          => $CustomerPassword2,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.AccessDenied',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Create DynamicFields (with empty value)',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => [
                {
                    Name  => "Unittest1$RandomID",
                    Value => '',
                },
                {
                    Name  => "Unittest2$RandomID",
                    Value => '',
                },
                {
                    Name  => "Unittest3$RandomID",
                    Value => '',
                },
            ],
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        Operation => 'TicketCreate',
    },

    {
        Name           => 'Create DynamicFields (with not empty value)',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => [
                {
                    Name  => "Unittest1$RandomID",
                    Value => 'Value9ßüß-カスタ1234',
                },
                {
                    Name  => "Unittest2$RandomID",
                    Value => '2',
                },
                {
                    Name  => "Unittest3$RandomID",
                    Value => [ 1, 2 ],
                },
            ],
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        Operation => 'TicketCreate',
    },

    {
        Name           => 'Create DynamicFields (with wrong value type)',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => [
                {
                    Name  => "Unittest1$RandomID",
                    Value => { Wrong => 'Value' },    # value type depends on the dynamic field
                },
                {
                    Name  => "Unittest2$RandomID",
                    Value => { Wrong => 'Value' },    # value type depends on the dynamic field
                },
            ],
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },

    {
        Name           => 'Create DynamicFields (with invalid value)',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => [
                {
                    Name  => "Unittest2$RandomID",
                    Value => '4',                    # invalid value
                },
            ],
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },

    {
        Name           => 'Ticket with Alias Charsets attachment',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=US-ASCII',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=US-ASCII',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with the date dynamic field without a time',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                Queue        => $Queues[0]->{Name},
                Type         => $TypeData{Name},
                Service      => $ServiceData{Name},
                SLA          => $SLAData{Name},
                State        => $StateData{Name},
                Priority     => $PriorityData{Name},
                Owner        => $TestOwnerLogin,
                Responsible  => $TestResponsibleLogin,
                PendingTime  => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject äöüßÄÖÜ€ис',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleType                     => 'email-external',
                SenderType                      => 'agent',
                From                            => 'enjoy@otrs.com',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [1],
                ExcludeNotificationToUserID     => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name      => $DynamicFieldDateConfig{Name},
                Value     => '2012-01-17',
                FieldType => 'Date',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
);

# debugger object
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Provider',
);
$Self->Is(
    ref $DebuggerObject,
    'Kernel::GenericInterface::Debugger',
    'DebuggerObject instantiate correctly',
);

for my $Test (@Tests) {

    # create local object
    my $LocalObject = "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"->new(
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
    );

    $Self->Is(
        "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}",
        ref $LocalObject,
        "$Test->{Name} - Create local object",
    );

    my %Auth = (
        UserLogin => $UserLogin,
        Password  => $Password,
    );
    if ( IsHashRefWithData( $Test->{Auth} ) ) {
        %Auth = %{ $Test->{Auth} };
    }

    # start requester with our webservice
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    # check result
    $Self->Is(
        'HASH',
        ref $LocalResult,
        "$Test->{Name} - Local result structure is valid",
    );

    # create requester object
    my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
    $Self->Is(
        'Kernel::GenericInterface::Requester',
        ref $RequesterObject,
        "$Test->{Name} - Create requester object",
    );

    # start requester with our webservice
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    # check result
    $Self->Is(
        'HASH',
        ref $RequesterResult,
        "$Test->{Name} - Requester result structure is valid",
    );

    $Self->Is(
        $RequesterResult->{Success},
        $Test->{SuccessRequest},
        "$Test->{Name} - Requester successful result",
    );

    # tests supposed to succeed
    if ( $Test->{SuccessCreate} ) {

        # local results
        $Self->True(
            $LocalResult->{Data}->{TicketID},
            "$Test->{Name} - Local result TicketID with True.",
        );
        $Self->True(
            $LocalResult->{Data}->{TicketNumber},
            "$Test->{Name} - Local result TicketNumber with True.",
        );
        $Self->True(
            $LocalResult->{Data}->{ArticleID},
            "$Test->{Name} - Local result ArticleID with True.",
        );
        $Self->Is(
            $LocalResult->{Data}->{Error},
            undef,
            "$Test->{Name} - Local result Error is undefined.",
        );

        # requester results
        $Self->True(
            $RequesterResult->{Data}->{TicketID},
            "$Test->{Name} - Requester result TicketID with True.",
        );
        $Self->True(
            $RequesterResult->{Data}->{TicketNumber},
            "$Test->{Name} - Requester result TicketNumber with True.",
        );
        $Self->True(
            $RequesterResult->{Data}->{ArticleID},
            "$Test->{Name} - Requester result ArticleID with True.",
        );
        $Self->Is(
            $RequesterResult->{Data}->{Error},
            undef,
            "$Test->{Name} - Requester result Error is undefined.",
        );

        # create ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # get the Ticket entry (from local result)
        my %LocalTicketData = $TicketObject->TicketGet(
            TicketID      => $LocalResult->{Data}->{TicketID},
            DynamicFields => 1,
            UserID        => 1,
        );

        $Self->True(
            IsHashRefWithData( \%LocalTicketData ),
            "$Test->{Name} - created local ticket structure with True.",
        );

        # get the Ticket entry (from requester result)
        my %RequesterTicketData = $TicketObject->TicketGet(
            TicketID      => $RequesterResult->{Data}->{TicketID},
            DynamicFields => 1,
            UserID        => 1,
        );

        $Self->True(
            IsHashRefWithData( \%RequesterTicketData ),
            "$Test->{Name} - created requester ticket structure with True.",
        );

        # check ticket attributes as defined in the test
        $Self->Is(
            $LocalTicketData{Title},
            $Test->{RequestData}->{Ticket}->{Title},
            "$Test->{Name} - local Ticket->Title match test definition.",

        );

        # external customers only set it's value in article (if no From is defined), ticket
        # is created with an empty customer
        if ( $Test->{ExternalCustomer} ) {
            $Self->Is(
                $LocalTicketData{CustomerUserID},
                undef,
                "$Test->{Name} - local Ticket->CustomerUser is empty.",
            );
        }
        else {
            $Self->Is(
                $LocalTicketData{CustomerUserID},
                $Test->{RequestData}->{Ticket}->{CustomerUser},
                "$Test->{Name} - local Ticket->CustomerUser match test definition.",
            );
        }

        for my $Attribute (qw(Queue Type Service SLA State Priority Owner Responsible)) {
            if ( $Test->{RequestData}->{Ticket}->{ $Attribute . 'ID' } ) {
                $Self->Is(
                    $LocalTicketData{ $Attribute . 'ID' },
                    $Test->{RequestData}->{Ticket}->{ $Attribute . 'ID' },
                    "$Test->{Name} - local Ticket->$Attribute" . 'ID' . " match test definition.",
                );
            }
            else {
                $Self->Is(
                    $LocalTicketData{$Attribute},
                    $Test->{RequestData}->{Ticket}->{$Attribute},
                    "$Test->{Name} - local Ticket->$Attribute match test definition.",
                );
            }
        }

        # get local article information
        my %LocalArticleData = $TicketObject->ArticleGet(
            ArticleID     => $LocalResult->{Data}->{ArticleID},
            DynamicFields => 1,
            UserID        => 1,
        );

        # get requester article information
        my %RequesterArticleData = $TicketObject->ArticleGet(
            ArticleID     => $RequesterResult->{Data}->{ArticleID},
            DynamicFields => 1,
            UserID        => 1,
        );

        for my $Attribute (qw(Subject Body ContentType MimeType Charset From)) {
            if ( $Test->{RequestData}->{Article}->{$Attribute} ) {
                $Self->Is(
                    $LocalArticleData{$Attribute},
                    $Test->{RequestData}->{Article}->{$Attribute},
                    "$Test->{Name} - local Article->$Attribute match test definition.",
                );
            }
        }

        for my $Attribute (qw(ArticleType SenderType)) {
            if ( $Test->{RequestData}->{Article}->{ $Attribute . 'ID' } ) {
                $Self->Is(
                    $LocalArticleData{ $Attribute . 'ID' },
                    $Test->{RequestData}->{Article}->{ $Attribute . 'ID' },
                    "$Test->{Name} - local Article->$Attribute" . 'ID' . " match test definition.",
                );
            }
            else {
                $Self->Is(
                    $LocalArticleData{$Attribute},
                    $Test->{RequestData}->{Article}->{$Attribute},
                    "$Test->{Name} - local Article->$Attribute match test definition.",
                );
            }
        }

        # check dynamic fields
        my @RequestedDynamicFields;
        if ( ref $Test->{RequestData}->{DynamicField} eq 'HASH' ) {
            push @RequestedDynamicFields, $Test->{RequestData}->{DynamicField};
        }
        else {
            @RequestedDynamicFields = @{ $Test->{RequestData}->{DynamicField} };
        }
        for my $DynamicField (@RequestedDynamicFields) {

            if ( $DynamicField->{FieldType} eq 'Date' && $DynamicField->{Value} =~ m{ \A \d{4}-\d{2}-\d{2} \z }xms ) {
                $DynamicField->{Value} .= ' 00:00:00';
            }

            $Self->IsDeeply(
                $LocalTicketData{ 'DynamicField_' . $DynamicField->{Name} } // '',
                $DynamicField->{Value},
                "$Test->{Name} - local Ticket->DynamicField_"
                    . $DynamicField->{Name}
                    . " match test definition.",
            );
        }

        # check attachments
        my %AttachmentIndex = $TicketObject->ArticleAttachmentIndex(
            ArticleID                  => $LocalResult->{Data}->{ArticleID},
            StripPlainBodyAsAttachment => 3,
            Article                    => \%LocalArticleData,
            UserID                     => 1,
        );

        my @Attachments;
        ATTACHMENT:
        for my $FileID ( sort keys %AttachmentIndex ) {
            next ATTACHMENT if !$FileID;
            my %Attachment = $TicketObject->ArticleAttachment(
                ArticleID => $LocalResult->{Data}->{ArticleID},
                FileID    => $FileID,
                UserID    => 1,
            );

            next ATTACHMENT if !IsHashRefWithData( \%Attachment );

            # convert content to base64
            $Attachment{Content} = encode_base64( $Attachment{Content}, '' );

            # delete not needed attributes
            for my $Attribute (qw(ContentAlternative ContentID Filesize FilesizeRaw)) {
                delete $Attachment{$Attribute};
            }
            push @Attachments, {%Attachment};
        }

        my @RequestedAttachments;
        if ( ref $Test->{RequestData}->{Attachment} eq 'HASH' ) {
            push @RequestedAttachments, $Test->{RequestData}->{Attachment};
        }
        else {
            @RequestedAttachments = @{ $Test->{RequestData}->{Attachment} };
        }

        $Self->IsDeeply(
            \@Attachments,
            \@RequestedAttachments,
            "$Test->{Name} - local Ticket->Attachment match test definition.",
        );

        # remove attributes that might be different from local and requester responses
        for my $Attribute (
            qw(TicketID TicketNumber Created Changed Age CreateTimeUnix UnlockTimeout)
            )
        {
            delete $LocalTicketData{$Attribute};
            delete $RequesterTicketData{$Attribute};
        }

        $Self->IsDeeply(
            \%LocalTicketData,
            \%RequesterTicketData,
            "$Test->{Name} - Local ticket result matched with remote result.",
        );

        # remove attributes that might be different from local and requester responses
        for my $Attribute (
            qw( Age AgeTimeUnix ArticleID TicketID Created Changed IncomingTime TicketNumber
            CreateTimeUnix
            )
            )
        {
            delete $LocalArticleData{$Attribute};
            delete $RequesterArticleData{$Attribute};
        }

        $Self->IsDeeply(
            \%LocalArticleData,
            \%RequesterArticleData,
            "$Test->{Name} - Local article result matched with remote result.",
        );

        # delete the tickets
        for my $TicketID (
            $LocalResult->{Data}->{TicketID},
            $RequesterResult->{Data}->{TicketID}
            )
        {

            # Allow some time for all history entries to be written to the ticket before deleting it,
            #   otherwise TicketDelete could fail.
            sleep 1;

            my $TicketDelete = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );

            # sanity check
            $Self->True(
                $TicketDelete,
                "TicketDelete() successful for Ticket ID $TicketID",
            );
        }
    }

    # tests supposed to fail
    else {
        $Self->False(
            $LocalResult->{TicketID},
            "$Test->{Name} - Local result TicketID with false.",
        );
        $Self->False(
            $LocalResult->{TicketNumber},
            "$Test->{Name} - Local result TicketNumber with false.",
        );
        $Self->False(
            $LocalResult->{ArticleID},
            "$Test->{Name} - Local result ArticleID with false.",
        );
        $Self->Is(
            $LocalResult->{Data}->{Error}->{ErrorCode},
            $Test->{ExpectedData}->{Data}->{Error}->{ErrorCode},
            "$Test->{Name} - Local result ErrorCode matched with expected local call result.",
        );
        $Self->True(
            $LocalResult->{Data}->{Error}->{ErrorMessage},
            "$Test->{Name} - Local result ErrorMessage with true.",
        );
        $Self->IsNot(
            $LocalResult->{Data}->{Error}->{ErrorMessage},
            '',
            "$Test->{Name} - Local result ErrorMessage is not empty.",
        );
        $Self->Is(
            $LocalResult->{ErrorMessage},
            $LocalResult->{Data}->{Error}->{ErrorCode}
                . ': '
                . $LocalResult->{Data}->{Error}->{ErrorMessage},
            "$Test->{Name} - Local result ErrorMessage (outside Data hash) matched with concatenation"
                . " of ErrorCode and ErrorMessage within Data hash.",
        );

        # remove ErrorMessage parameter from direct call
        # result to be consistent with SOAP call result
        if ( $LocalResult->{ErrorMessage} ) {
            delete $LocalResult->{ErrorMessage};
        }

        # sanity check
        $Self->False(
            $LocalResult->{ErrorMessage},
            "$Test->{Name} - Local result ErrorMessage (outside Data hash) got removed to compare"
                . " local and remote tests.",
        );

        $Self->IsDeeply(
            $LocalResult,
            $RequesterResult,
            "$Test->{Name} - Local result matched with remote result.",
        );
    }
}

# delete webservice
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);
$Self->True(
    $WebserviceDelete,
    "Deleted Webservice $WebserviceID",
);

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# delete queues
for my $QueueData (@Queues) {
    $Success = $DBObject->Do(
        SQL => "DELETE FROM queue WHERE id = $QueueData->{QueueID}",
    );
    $Self->True(
        $Success,
        "Queue with ID $QueueData->{QueueID} is deleted!",
    );
}

# delete group
$Success = $DBObject->Do(
    SQL => "DELETE FROM groups WHERE id = $GroupID",
);
$Self->True(
    $Success,
    "Group with ID $GroupID is deleted!",
);

# delete type
$Success = $DBObject->Do(
    SQL => "DELETE FROM ticket_type WHERE id = $TypeID",
);
$Self->True(
    $Success,
    "Type with ID $TypeID is deleted!",
);

# delete service_customer_user and service
$Success = $DBObject->Do(
    SQL => "DELETE FROM service_customer_user WHERE service_id = $ServiceID",
);
$Self->True(
    $Success,
    "Service user referenced to service ID $ServiceID is deleted!",
);

$Success = $DBObject->Do(
    SQL => "DELETE FROM service_sla WHERE service_id = $ServiceID OR sla_id = $SLAID",
);
$Self->True(
    $Success,
    "Service SLA referenced to service ID $ServiceID is deleted!",
);

$Success = $DBObject->Do(
    SQL => "DELETE FROM service WHERE id = $ServiceID",
);
$Self->True(
    $Success,
    "Service with ID $ServiceID is deleted!",
);

# delete SLA
$Success = $DBObject->Do(
    SQL => "DELETE FROM sla WHERE id = $SLAID",
);
$Self->True(
    $Success,
    "SLA with ID $SLAID is deleted!",
);

# delete state
$Success = $DBObject->Do(
    SQL => "DELETE FROM ticket_state WHERE id = $StateID",
);
$Self->True(
    $Success,
    "State with ID $StateID is deleted!",
);

# delete priority
$Success = $DBObject->Do(
    SQL => "DELETE FROM ticket_priority WHERE id = $PriorityID",
);
$Self->True(
    $Success,
    "Priority with ID $PriorityID is deleted!",
);

# delete dynamic fields
my $DeleteFieldList = $DynamicFieldObject->DynamicFieldList(
    ResultType => 'HASH',
    ObjectType => 'Ticket',
);

DYNAMICFIELD:
for my $DynamicFieldID ( sort keys %{$DeleteFieldList} ) {

    next DYNAMICFIELD if !$DynamicFieldID;
    next DYNAMICFIELD if !$DeleteFieldList->{$DynamicFieldID};

    next DYNAMICFIELD if $DeleteFieldList->{$DynamicFieldID} !~ m{ ^Unittest }xms;

    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );

    $Self->True(
        $Success,
        "DynamicFieldDelete() for $DeleteFieldList->{$DynamicFieldID} with true",
    );
}

# Restore UserID 1 previous validity.
$Success = $UserObject->UserUpdate(
    %RootUser,
    UserID       => 1,
    ChangeUserID => 1,
);
$Self->True(
    $Success,
    "Restored root user validity",
);

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

1;
