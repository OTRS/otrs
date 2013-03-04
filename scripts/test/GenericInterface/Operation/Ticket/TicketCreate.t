# --
# TicketCreate.t - GenericInterface TicketCreate tests for TicketConnector backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Socket;
use MIME::Base64;
use Kernel::System::Ticket;
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Requester;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::UnitTest::Helper;
use Kernel::GenericInterface::Operation::Ticket::TicketCreate;
use Kernel::GenericInterface::Operation::Session::SessionCreate;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use Kernel::System::SysConfig;
use Kernel::System::Queue;
use Kernel::System::Type;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::State;
use Kernel::System::DynamicField;
use Kernel::System::User;
use Kernel::System::Valid;

# set UserID to root because in public interface there is no user
$Self->{UserID} = 1;

# helper object
# skip SSL certiciate verification
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 1,
    SkipSSLVerify              => 1,
);

my $RandomID = $HelperObject->GetRandomID();

my $ConfigObject = Kernel::Config->new();

my $SysConfigObject = Kernel::System::SysConfig->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

$SysConfigObject->ConfigItemUpdate(
    Valid => 1,
    Key   => 'Ticket::Type',
    Value => '1',
);
$ConfigObject->Set(
    Key   => 'Ticket::Type',
    Value => 1,
);
$SysConfigObject->ConfigItemUpdate(
    Valid => 1,
    Key   => 'Ticket::Frontend::AccountTime',
    Value => '1',
);
$ConfigObject->Set(
    Key   => 'Ticket::Frontend::AccountTime',
    Value => 1,
);
$SysConfigObject->ConfigItemUpdate(
    Valid => 1,
    Key   => 'Ticket::Frontend::NeedAccountedTime',
    Value => '1',
);
$ConfigObject->Set(
    Key   => 'Ticket::Frontend::NeedAccountedTime',
    Value => 1,
);

# disable dns lookups
$SysConfigObject->ConfigItemUpdate(
    Valid => 1,
    Key   => 'CheckMXRecord',
    Value => '0',
);
$ConfigObject->Set(
    Key   => 'CheckMXRecord',
    Value => 0,
);
$SysConfigObject->ConfigItemUpdate(
    Valid => 1,
    Key   => 'CheckEmailAddresses',
    Value => '1',
);
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# check if SSL Certificate verification is disabled
$Self->Is(
    $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME},
    0,
    'Disabled SSL certiticates verification in environment',
);

# create ticket object
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# all other objects
my $QueueObject = Kernel::System::Queue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TypeObject = Kernel::System::Type->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $ServiceObject = Kernel::System::Service->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $SLAObject = Kernel::System::SLA->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $StateObject = Kernel::System::State->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $PriorityObject = Kernel::System::Priority->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $DynamicFieldObject = Kernel::System::DynamicField->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $UserObject = Kernel::System::User->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $ValidObject = Kernel::System::Valid->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $TestOwnerLogin        = $HelperObject->TestUserCreate();
my $TestResponsibleLogin  = $HelperObject->TestUserCreate();
my $TestCustomerUserLogin = $HelperObject->TestCustomerUserCreate();
my $OwnerID               = $UserObject->UserLookup(
    UserLogin => $TestOwnerLogin,
);
my $ResponsibleID = $UserObject->UserLookup(
    UserLogin => $TestResponsibleLogin,
);

my $InvalidID = $ValidObject->ValidLookup( Valid => 'invalid' );

# sanity test
$Self->IsNot(
    $InvalidID,
    undef,
    "ValidLookup() for 'invalid' should not be undef"
);

# create new queue
my $QueueID = $QueueObject->QueueAdd(
    Name            => 'TestQueue' . $RandomID,
    ValidID         => 1,
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
    "QueueAdd() - create testing queue",
);

my %QueueData = $QueueObject->QueueGet( ID => $QueueID );

# sanity check
$Self->True(
    IsHashRefWithData( \%QueueData ),
    "QueueGet() - for testing queue",
);

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

# create new dynamic field
my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => 'TestDynamicFieldGI' . int rand(1000),
    Label      => 'GI Test Field',
    FieldOrder => 9991,
    FieldType  => 'DateTime',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue  => 0,
        YearsInFuture => 0,
        YearsInPast   => 0,
        YearsPeriod   => 0,
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $DynamicFieldID,
    "DynamicFieldAdd() - create testing dynamic field",
);

my $DynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
    ID => $DynamicFieldID,
);

# sanity check
$Self->True(
    IsHashRefWithData($DynamicFieldData),
    "DynamicFieldGet() - for testing dynamic field",
);

# create webservice object
my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create webservice object",
);

# set webservice name
my $WebserviceName = '-Test-' . $RandomID;

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Name    => $WebserviceName,
    Config  => {
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
my $Host;
my $FQDN = $Self->{ConfigObject}->Get('FQDN');

# try to resolve fqdn host
if ( $FQDN ne 'yourhost.example.com' && gethostbyname($FQDN) ) {
    $Host = $FQDN;
}

# try to resolve localhost instead
if ( !$Host && gethostbyname('localhost') ) {
    $Host = 'localhost';
}

# use hardcoded localhost ip address
if ( !$Host ) {
    $Host = '127.0.0.1';
}

# prepare webservice config
my $RemoteSystem =
    $Self->{ConfigObject}->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $Self->{ConfigObject}->Get('ScriptAlias')
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
my $RequesterSessionObject = Kernel::GenericInterface::Requester->new( %{$Self} );
$Self->Is(
    'Kernel::GenericInterface::Requester',
    ref $RequesterSessionObject,
    "SessionID - Create requester object",
);

# create a new user for current test
my $UserLogin = $HelperObject->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);
my $Password = $UserLogin;

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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
                QueueID      => $QueueID,
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
        Name           => 'Invalid Responsibe',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
        Name           => 'Missing Subject',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                QueueID       => $QueueID,
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
                Name  => $DynamicFieldData->{Name},
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
                QueueID       => $QueueID,
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
                Name  => $DynamicFieldData->{Name},
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
                QueueID       => $QueueID,
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
                Name  => $DynamicFieldData->{Name},
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
                QueueID       => $QueueID,
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
                Name  => $DynamicFieldData->{Name},
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
                QueueID       => $QueueID,
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
                Name  => $DynamicFieldData->{Name},
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
                QueueID       => $QueueID,
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
                Name  => $DynamicFieldData->{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
            },
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
                Queue        => $QueueData{Name},
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
                Subject                     => 'Article subject äöüßÄÖÜ€ис',
                Body                        => 'Article body !"Â§$%&/()=?Ã*ÃÃL:L@,.-',
                AutoResponseType            => 'auto reply',
                ArticleType                 => 'email-external',
                SenderType                  => 'agent',
                From                        => 'enjoy@otrs.com',
                ContentType                 => 'text/plain; charset=UTF8',
                HistoryType                 => 'NewTicket',
                HistoryComment              => '% % ',
                TimeUnit                    => 25,
                ForceNotificationToUserID   => [1],
                ExcludeNotificationToUserID => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldData->{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
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
                Queue        => $QueueData{Name},
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
                Subject                     => 'Article subject äöüßÄÖÜ€ис',
                Body                        => 'Article body !"Â§$%&/()=?Ã*ÃÃL:L@,.-',
                AutoResponseType            => 'auto reply',
                ArticleType                 => 'email-external',
                SenderType                  => 'agent',
                From                        => 'enjoy@otrs.com',
                ContentType                 => 'text/plain; charset=UTF8',
                HistoryType                 => 'NewTicket',
                HistoryComment              => '% % ',
                TimeUnit                    => 25,
                ForceNotificationToUserID   => [1],
                ExcludeNotificationToUserID => [1],
                ExcludeMuteNotificationToUserID => [1],
            },
            DynamicField => {
                Name  => $DynamicFieldData->{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
            },
        },
        Operation => 'TicketCreate',
    },

);

# debugger object
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    ConfigObject   => $ConfigObject,
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
    'DebuggerObject instanciate correctly',
);

for my $Test (@Tests) {

    # create local object
    my $LocalObject = "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"->new(
        %{$Self},
        ConfigObject   => $ConfigObject,
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
    );

    $Self->Is(
        "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}",
        ref $LocalObject,
        "$Test->{Name} - Create local object",
    );

    # start requester with our webservice
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            UserLogin => $UserLogin,
            Password  => $Password,
            %{ $Test->{RequestData} },
            }
    );

    # check result
    $Self->Is(
        'HASH',
        ref $LocalResult,
        "$Test->{Name} - Local result structure is valid",
    );

    # create requester object
    my $RequesterObject = Kernel::GenericInterface::Requester->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );
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
            SessionID => $NewSessionID,
            %{ $Test->{RequestData} },
            }
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

        # get the Ticket entry (from local result)
        my %LocalTicketData = $TicketObject->TicketGet(
            TicketID      => $LocalResult->{Data}->{TicketID},
            DynamicFields => 1,
            UserID        => 1,
        );

        $Self->True(
            IsHashRefWithData( \%LocalTicketData ),
            "$Test->{Name} - created local ticket strcture with True.",
        );

        # get the Ticket entry (from requester result)
        my %RequesterTicketData = $TicketObject->TicketGet(
            TicketID      => $RequesterResult->{Data}->{TicketID},
            DynamicFields => 1,
            UserID        => 1,
        );

        $Self->True(
            IsHashRefWithData( \%RequesterTicketData ),
            "$Test->{Name} - created requester ticket strcture with True.",
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
            $Self->Is(
                $LocalTicketData{ 'DynamicField_' . $DynamicField->{Name} },
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

            # next if not attachment
            next ATTACHMENT if !IsHashRefWithData( \%Attachment );

            # convert content to base64
            $Attachment{Content} = encode_base64( $Attachment{Content}, '' );

            # delete not needed attibutes
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
            "$Test->{Name} - Local result ErroMessage (outsise Data hash) got removed to compare"
                . " local and remote tests.",
        );

        $Self->IsDeeply(
            $LocalResult,
            $RequesterResult,
            "$Test->{Name} - Local result matched with remote result.",
        );
    }
}

# clean up webservice
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);
$Self->True(
    $WebserviceDelete,
    "Deleted Webservice $WebserviceID",
);

# invalidate queue
{
    my $Success = $QueueObject->QueueUpdate(
        %QueueData,
        ValidID => $InvalidID,
        UserID  => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "QueueUpdate() set queue $QueueData{Name} to invalid",
    );
}

# invalidate type
{
    my $Success = $TypeObject->TypeUpdate(
        %TypeData,
        ValidID => $InvalidID,
        UserID  => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "TypeUpdate() set type $TypeData{Name} to invalid",
    );
}

# invalidate service
{
    my $Success = $ServiceObject->ServiceUpdate(
        %ServiceData,
        ValidID => $InvalidID,
        UserID  => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "ServiceUpdate() set service $ServiceData{Name} to invalid",
    );
}

# invalidate SLA
{
    my $Success = $SLAObject->SLAUpdate(
        %SLAData,
        ValidID => $InvalidID,
        UserID  => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "SLAUpdate() set SLA $SLAData{Name} to invalid",
    );
}

# invalidate state
{
    my $Success = $StateObject->StateUpdate(
        %StateData,
        ValidID => $InvalidID,
        UserID  => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "StateUpdate() set state $StateData{Name} to invalid",
    );
}

# invalidate type
{
    my $Success = $PriorityObject->PriorityUpdate(
        %PriorityData,
        PriorityID => $PriorityID,
        ValidID    => $InvalidID,
        UserID     => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "PriorityUpdate() set priority $PriorityData{Name} to invalid",
    );
}

# remove DynamicFields
{
    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "DynamicFieldDelete() for DynamicField $DynamicFieldData->{Name}"
    );
}

1;
