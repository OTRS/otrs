# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation::Session::SessionCreate;
use Kernel::GenericInterface::Operation::Ticket::TicketUpdate;
use Kernel::GenericInterface::Requester;

use Kernel::System::VariableCheck qw(:all);

# get helper object
# skip SSL certificate verification
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CheckMXRecord',
    Value => 0,
);

# get a random number
my $RandomID = $Helper->GetRandomNumber();

# create a new user for current test
my $UserLogin = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $Password = $UserLogin;

# new user object
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

$Self->{UserID} = $UserObject->UserLookup(
    UserLogin => $UserLogin,
);

# create a new user without permissions for current test
my $UserLogin2 = $Helper->TestUserCreate();
my $Password2  = $UserLogin2;

# create a customer where a ticket will use and will have permissions
my $CustomerUserLogin = $Helper->TestCustomerUserCreate();
my $CustomerPassword  = $CustomerUserLogin;

# create a customer that will not have permissions
my $CustomerUserLogin2 = $Helper->TestCustomerUserCreate();
my $CustomerPassword2  = $CustomerUserLogin2;

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
        PossibleValues => {
            1 => 'One',
            2 => 'Two',
            3 => 'Three',
            0 => '0',
        },
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
        PossibleValues => {
            1 => 'Value9ßüß',
            2 => 'DifferentValue',
            3 => '1234567',
        },
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

# create ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

#ticket id container
my @TicketIDs;

# create ticket 1
my $TicketID1 = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $CustomerUserLogin,
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID1,
    "TicketCreate() successful for Ticket One ID $TicketID1",
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID1,
    UserID   => 1,
);

# remember ticket id
push @TicketIDs, $TicketID1;

# create backed object
my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
$Self->Is(
    ref $BackendObject,
    'Kernel::System::DynamicField::Backend',
    'Backend object was created successfully',
);

# set text field value
my $Result = $BackendObject->ValueSet(
    DynamicFieldConfig => \%DynamicFieldTextConfig,
    ObjectID           => $TicketID1,
    Value              => 'ticket1_field1',
    UserID             => 1,
);

# sanity check
$Self->True(
    $Result,
    "Text ValueSet() for Ticket $TicketID1",
);

# set dropdown field value
$Result = $BackendObject->ValueSet(
    DynamicFieldConfig => \%DynamicFieldDropdownConfig,
    ObjectID           => $TicketID1,
    Value              => 1,
    UserID             => 1,
);

# sanity check
$Self->True(
    $Result,
    "Multiselect ValueSet() for Ticket $TicketID1",
);

# set multiselect field value
$Result = $BackendObject->ValueSet(
    DynamicFieldConfig => \%DynamicFieldMultiselectConfig,
    ObjectID           => $TicketID1,
    Value              => [ 2, 3 ],
    UserID             => 1,
);

# sanity check
$Self->True(
    $Result,
    "Dropdown ValueSet() for Ticket $TicketID1",
);

# set web service name
my $WebserviceName = $Helper->GetRandomID();

# create web-service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create web service object",
);

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
    "Added web service",
);

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# prepare web-service config
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
            TicketUpdate => {
                Type => 'Ticket::TicketUpdate',
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
                Timeout   => 120,
            },
        },
        Invoker => {
            TicketUpdate => {
                Type => 'Test::TestSimple',
            },
            SessionCreate => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# update web-service with real config
# the update is needed because we are using
# the WebserviceID for the Endpoint in config
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => $Self->{UserID},
);
$Self->True(
    $WebserviceUpdate,
    "Updated web service $WebserviceID - $WebserviceName",
);

# disable SessionCheckRemoteIP setting
$ConfigObject->Set(
    Key   => 'SessionCheckRemoteIP',
    Value => 0,
);

# Get SessionID
# create requester object
my $RequesterSessionObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');

$Self->Is(
    'Kernel::GenericInterface::Requester',
    ref $RequesterSessionObject,
    "SessionID - Create requester object",
);

# start requester with our web-service
my $RequesterSessionResult = $RequesterSessionObject->Run(
    WebserviceID => $WebserviceID,
    Invoker      => 'SessionCreate',
    Data         => {
        UserLogin => $UserLogin,
        Password  => $Password,
    },
);

my $NewSessionID = $RequesterSessionResult->{Data}->{SessionID};

my @Tests = (
    {
        Name           => 'Update Agent (With Permissions)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => 'Updated',
            },
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        Operation => 'TicketUpdate',
    },
    {
        Name           => 'Update Agent (With SessionID)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => 'Updated',
            },
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        Operation => 'TicketUpdate',
    },
    {
        Name           => 'Update Agent (No Permission)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => 'Updated',
            },
        },
        Auth => {
            UserLogin => $UserLogin2,
            Password  => $Password2,
        },
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketUpdate.AccessDenied',
                    ErrorMessage =>
                        'TicketUpdate: User does not have access to the ticket!'
                },
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketUpdate.AccessDenied',
                    ErrorMessage =>
                        'TicketUpdate: User does not have access to the ticket!'
                },
            },
            Success => 1
        },
        Operation => 'TicketUpdate',
    },
    {
        Name           => 'Update Customer (With Permissions)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => 'Updated',
            },
        },
        Auth => {
            CustomerUserLogin => $CustomerUserLogin,
            Password          => $CustomerPassword,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        Operation => 'TicketUpdate',
    },
    {
        Name           => 'Update Customer (No Permission)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => 'Updated',
            },
        },
        Auth => {
            CustomerUserLogin => $CustomerUserLogin2,
            Password          => $CustomerPassword2,
        },
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketUpdate.AccessDenied',
                    ErrorMessage =>
                        'TicketUpdate: User does not have access to the ticket!'
                },
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketUpdate.AccessDenied',
                    ErrorMessage =>
                        'TicketUpdate: User does not have access to the ticket!'
                },
            },
            Success => 1
        },
        Operation => 'TicketUpdate',
    },

    {
        Name           => 'Update Text DynamicField (with empty value)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID     => $TicketID1,
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
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        Operation => 'TicketUpdate',
    },

    {
        Name           => 'Update Text DynamicField (with not empty value)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID     => $TicketID1,
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
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        Operation => 'TicketUpdate',
    },

    {
        Name           => 'Update Dropdown DynamicField (with value 0)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID     => $TicketID1,
            DynamicField => [
                {
                    Name  => "Unittest2$RandomID",
                    Value => '0',
                },
            ],
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        Operation => 'TicketUpdate',
    },

    {
        Name           => 'Update Text and Dropdown DynamicFields (with wrong value type)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID     => $TicketID1,
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
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Error => {
                    ErrorCode    => 'TicketUpdate.MissingParameter',
                    ErrorMessage => 'TicketUpdate: DynamicField->Value parameter is missing!'
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Error => {
                    ErrorCode    => 'TicketUpdate.MissingParameter',
                    ErrorMessage => 'TicketUpdate: DynamicField->Value parameter is missing!'
                },
            },
        },
        Operation => 'TicketUpdate',
    },

    {
        Name           => 'Update Dropdown DynamicField (with invalid value)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID     => $TicketID1,
            DynamicField => [
                {
                    Name  => "Unittest2$RandomID",
                    Value => '4',                    # invalid value
                },
            ],
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Error => {
                    ErrorCode    => 'TicketUpdate.InvalidParameter',
                    ErrorMessage => 'TicketUpdate: DynamicField->Value parameter is invalid!',
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Error => {
                    ErrorCode    => 'TicketUpdate.InvalidParameter',
                    ErrorMessage => 'TicketUpdate: DynamicField->Value parameter is invalid!',
                },
            },
        },
        Operation => 'TicketUpdate',
    },
    {
        Name           => 'Add article (with attachment)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => 'Updated',
            },
            Article => {
                Subject              => 'Article subject äöüßÄÖÜ€ис',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                IsVisibleForCustomer => 1,
                CommunicationChannel => 'Email',
                SenderType           => 'agent',
                From                 => 'enjoy@otrs.com',
                Charset              => 'utf8',
                MimeType             => 'text/plain',
                HistoryType          => 'AddNote',
                HistoryComment       => '%%',
            },
            Attachment => [
                {
                    Content     => 'Ymx1YiBibHViIGJsdWIg',
                    ContentType => 'text/html',
                    Filename    => 'test.txt',
                },
            ],
        },
        IncludeTicketData        => 1,
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        Operation => 'TicketUpdate',
    },
    {
        Name           => 'Add email article (with attachment named "0")',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => 'Updated',
            },
            Article => {
                Subject              => 'Article subject',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                IsVisibleForCustomer => 1,
                CommunicationChannel => 'Email',
                SenderType           => 'agent',
                Charset              => 'utf8',
                MimeType             => 'text/plain',
                HistoryType          => 'AddNote',
                HistoryComment       => '%%',
            },
            Attachment => [
                {
                    Content     => 'Ymx1YiBibHViIGJsdWIg',
                    ContentType => 'text/html',
                    Filename    => '0',
                },
            ],
        },
        IncludeTicketData        => 1,
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        Operation => 'TicketUpdate',
    },
    {
        Name           => 'Add article (with To, Cc and Bcc parameters)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => 'Updated',
            },
            Article => {
                Subject              => 'Article subject äöüßÄÖÜ€ис',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                IsVisibleForCustomer => 1,
                CommunicationChannel => 'Email',
                SenderType           => 'agent',
                From                 => 'enjoy@otrs.com',
                To                   => 'someTo@otrs.com',
                Cc                   => 'someCc@otrs.com',
                Bcc                  => 'someBcc@otrs.com',
                Charset              => 'utf8',
                MimeType             => 'text/plain',
                HistoryType          => 'AddNote',
                HistoryComment       => '%%',
            },
        },
        IncludeTicketData        => 1,
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        Operation => 'TicketUpdate',
    },
    {
        Name           => 'Add article (with CustomerUser parameter)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title        => 'Updated',
                CustomerUser => $CustomerUserLogin,
            },
            Article => {
                Subject              => 'Article subject äöüßÄÖÜ€ис',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                IsVisibleForCustomer => 1,
                CommunicationChannel => 'Email',
                SenderType           => 'agent',
                From                 => 'enjoy@otrs.com',
                Charset              => 'utf8',
                MimeType             => 'text/plain',
                HistoryType          => 'AddNote',
                HistoryComment       => '%%',
            },
        },
        IncludeTicketData        => 1,
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
            },
        },
        Operation => 'TicketUpdate',
    },
);

# debugger object
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
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

$Helper->FixedTimeSet();

my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

TEST:
for my $Test (@Tests) {

    # Update web service config to include ticket data in responses.
    if ( $Test->{IncludeTicketData} ) {
        $WebserviceConfig->{Provider}->{Operation}->{TicketUpdate}->{IncludeTicketData} = 1;
        my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceName,
            Config  => $WebserviceConfig,
            ValidID => 1,
            UserID  => $Self->{UserID},
        );
        $Self->True(
            $WebserviceUpdate,
            'WebserviceUpdate - Turned on IncludeTicketData'
        );
    }

    # create local object
    my $LocalObject = "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"->new(
        %{$Self},
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
        ConfigObject   => $ConfigObject,
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

    # start requester with our web-service
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

    if ( $Test->{RequestData}->{Article} ) {

        # Get latest article data.
        my @ArticleList = $ArticleObject->ArticleList(
            TicketID => $TicketID1,
            OnlyLast => 1,
        );

        my $ArticleID;

        ARTICLE:
        for my $Article (@ArticleList) {
            $ArticleID = $Article->{ArticleID};
            last ARTICLE;
        }

        if ( $Test->{ExpectedReturnLocalData} ) {
            $Test->{ExpectedReturnLocalData}->{Data} = {
                %{ $Test->{ExpectedReturnLocalData}->{Data} },
                ArticleID => $ArticleID,
            };
        }
    }

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

    # start requester with our web-service
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    # TODO prevent failing test if enviroment on SaaS unit test system doesn't work.
    if (
        $RequesterResult->{ErrorMessage} eq
        'faultcode: Server, faultstring: Attachment could not be created, please contact the  system administrator'
        )
    {
        next TEST;
    }

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

    # remove ErrorMessage parameter from direct call
    # result to be consistent with SOAP call result
    if ( $LocalResult->{ErrorMessage} ) {
        delete $LocalResult->{ErrorMessage};
    }

    if ( $Test->{IncludeTicketData} ) {
        my %TicketGet = $TicketObject->TicketGet(
            TicketID      => $TicketID1,
            DynamicFields => 1,
            Extended      => 1,
            UserID        => 1,
        );

        my %TicketData;
        my @DynamicFields;

        # Transform some ticket properties so they match expected data structure.
        KEY:
        for my $Key ( sort keys %TicketGet ) {

            # Quote some properties as strings.
            if ( $Key eq 'UntilTime' ) {
                $TicketData{$Key} = "$TicketGet{$Key}";
                next KEY;
            }

            # Push all dynamic field data in a separate array structure.
            elsif ( $Key =~ m{^DynamicField_(?<DFName>\w+)$}xms ) {
                push @DynamicFields, {
                    Name  => $+{DFName},
                    Value => $TicketGet{$Key} // '',
                };
                next KEY;
            }

            # Skip some fields since they might differ.
            elsif (
                $Key eq 'Age'
                || $Key eq 'FirstResponse'
                || $Key eq 'Changed'
                || $Key eq 'UnlockTimeout'
                )
            {
                next KEY;
            }

            # Include any other ticket property as-is. Undefined values should be represented as empty string.
            $TicketData{$Key} = $TicketGet{$Key} // '';
        }

        if (@DynamicFields) {
            $TicketData{DynamicField} = \@DynamicFields;
        }

        $Test->{ExpectedReturnRemoteData}->{Data} = {
            %{ $Test->{ExpectedReturnRemoteData}->{Data} },
            Ticket => \%TicketData,
        };
    }

    if ( defined $Test->{RequestData}->{Ticket}->{CustomerUser} ) {
        $Self->Is(
            "\"$CustomerUserLogin $CustomerUserLogin\" <$CustomerUserLogin\@localunittest.com>",
            $RequesterResult->{Data}->{Ticket}->{Article}->{To},
            "Article parameter To is set well after TicketUpdate()",
        );
    }

    if ( $Test->{RequestData}->{Article} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

        # Check if parameters To, cc and Bcc set well
        # See bug#14393 for more information.
        if (
            defined $Test->{RequestData}->{Article}->{To}
            && defined $Test->{RequestData}->{Article}->{Cc}
            && defined $Test->{RequestData}->{Article}->{Bcc}
            )
        {

            for my $Item (qw(To Cc Bcc)) {
                $Self->Is(
                    $Test->{RequestData}->{Article}->{$Item},
                    $RequesterResult->{Data}->{Ticket}->{Article}->{$Item},
                    "Article parameter $Item is set well after TicketUpdate() - $Test->{RequestData}->{Article}->{$Item}",
                );
            }
        }

        # Get latest article data.
        my @ArticleList = $ArticleObject->ArticleList(
            TicketID => $TicketID1,
            OnlyLast => 1,
        );

        my %Article;

        ARTICLE:
        for my $Article (@ArticleList) {
            my $ArticleBackendObject = $ArticleObject->BackendForArticle( %{$Article} );

            %Article = $ArticleBackendObject->ArticleGet(
                %{$Article},
                DynamicFields => 1,
            );

            for my $Key ( sort keys %Article ) {
                $Article{$Key} //= '';
            }

            # Push all dynamic field data in a separate array structure.
            my $DynamicFields;
            KEY:
            for my $Key ( sort keys %Article ) {
                if ( $Key =~ m{^DynamicField_(?<DFName>\w+)$}xms ) {
                    push @{$DynamicFields}, {
                        Name  => $+{DFName},
                        Value => $Article{$Key} // '',
                    };
                    next KEY;
                }
            }
            for my $DynamicField ( @{$DynamicFields} ) {
                delete $Article{"DynamicField_$DynamicField->{Name}"};
            }
            if ( scalar @{$DynamicFields} == 1 ) {
                $DynamicFields = $DynamicFields->[0];
            }
            if ( IsArrayRefWithData($DynamicFields) || IsHashRefWithData($DynamicFields) ) {
                $Article{DynamicField} = $DynamicFields;
            }

            my %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID => $Article{ArticleID},
            );

            my @Attachments;
            $Kernel::OM->Get('Kernel::System::Main')->Require('MIME::Base64');
            ATTACHMENT:
            for my $FileID ( sort keys %AttachmentIndex ) {
                next ATTACHMENT if !$FileID;
                my %Attachment = $ArticleBackendObject->ArticleAttachment(
                    ArticleID => $Article{ArticleID},
                    FileID    => $FileID,
                );

                next ATTACHMENT if !IsHashRefWithData( \%Attachment );

                # Convert content to base64.
                $Attachment{Content} = MIME::Base64::encode_base64( $Attachment{Content}, '' );
                push @Attachments, {%Attachment};
            }

            # Set attachment data.
            if (@Attachments) {

                # Flatten array if only one attachment was found.
                if ( scalar @Attachments == 1 ) {
                    for my $Attachment (@Attachments) {
                        $Article{Attachment} = $Attachment;
                    }
                }
                else {
                    $Article{Attachment} = \@Attachments;
                }
            }

            last ARTICLE;
        }

        # Transform some article properties so they match expected data structure.
        for my $Key (qw(ArticleNumber)) {
            $Article{$Key} = "$Article{$Key}";
        }

        $Test->{ExpectedReturnRemoteData}->{Data}->{Ticket} = {
            %{ $Test->{ExpectedReturnRemoteData}->{Data}->{Ticket} },
            Article => \%Article,
        };
        $Test->{ExpectedReturnRemoteData}->{Data} = {
            %{ $Test->{ExpectedReturnRemoteData}->{Data} },
            ArticleID => $Article{ArticleID},
        };
    }

    # Remove some fields before comparison since they might differ.
    if ( $Test->{IncludeTicketData} ) {
        for my $Key (qw(Age Changed UnlockTimeout)) {
            delete $RequesterResult->{Data}->{Ticket}->{$Key};
        }
    }

    $Self->IsDeeply(
        $RequesterResult,
        $Test->{ExpectedReturnRemoteData},
        "$Test->{Name} - Requester success status (needs configured and running webserver)",
    );

    if ( $Test->{ExpectedReturnLocalData} ) {
        $Self->IsDeeply(
            $LocalResult,
            $Test->{ExpectedReturnLocalData},
            "$Test->{Name} - Local result matched with expected local call result.",
        );
    }
    else {
        $Self->IsDeeply(
            $LocalResult,
            $Test->{ExpectedReturnRemoteData},
            "$Test->{Name} - Local result matched with remote result.",
        );
    }

    # Update web service config to exclude ticket data in responses.
    if ( $Test->{IncludeTicketData} ) {
        $WebserviceConfig->{Provider}->{Operation}->{TicketUpdate}->{IncludeTicketData} = 0;
        my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceName,
            Config  => $WebserviceConfig,
            ValidID => 1,
            UserID  => $Self->{UserID},
        );
        $Self->True(
            $WebserviceUpdate,
            'WebserviceUpdate - Turned off IncludeTicketData'
        );
    }
}

# UnlockOnAway tests
$ConfigObject->Set(
    Key   => 'Ticket::UnlockOnAway',
    Value => 1,
);

my ( $UserLoginOutOfOffice, $UserIDOutOfOffice ) = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $UserIDNoOutOfOffice = $UserObject->UserLookup(
    UserLogin => $UserLogin,
);

# set a user out of office
my $StartDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

$StartDateTimeObject->Subtract(
    Days => 1,
);
my $StartDateTimeSettings = $StartDateTimeObject->Get();
my $EndDateTimeObject     = $Kernel::OM->Create('Kernel::System::DateTime');
$EndDateTimeObject->Add(
    Days => 1,
);
my $EndDateTimeSettings = $EndDateTimeObject->Get();
my %OutOfOfficeParams   = (
    OutOfOffice           => 1,
    OutOfOfficeStartYear  => $StartDateTimeSettings->{Year},
    OutOfOfficeStartMonth => $StartDateTimeSettings->{Month},
    OutOfOfficeStartDay   => $StartDateTimeSettings->{Day},
    OutOfOfficeEndYear    => $EndDateTimeSettings->{Year},
    OutOfOfficeEndMonth   => $EndDateTimeSettings->{Month},
    OutOfOfficeEndDay     => $EndDateTimeSettings->{Day},
);
for my $Key ( sort keys %OutOfOfficeParams ) {
    $UserObject->SetPreferences(
        UserID => $UserIDOutOfOffice,
        Key    => $Key,
        Value  => $OutOfOfficeParams{$Key},
    );
}

my $TicketIDNoOutOfOffice = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    Queue        => 'Raw',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $CustomerUserLogin,
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => $UserIDNoOutOfOffice,
    UserID       => 1,
);
push @TicketIDs, $TicketIDNoOutOfOffice;

my $TicketIDOutOfOffice = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    Queue        => 'Raw',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $CustomerUserLogin,
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => $UserIDOutOfOffice,
    UserID       => 1,
);
push @TicketIDs, $TicketIDOutOfOffice;

@Tests = (
    {
        Name        => 'Add Article, Ticket NoOutOfOffice',
        RequestData => {
            TicketID => $TicketIDNoOutOfOffice,
            Article  => {
                Subject     => 'some subject',
                Body        => 'some body',
                ContentType => 'text/plain; charset=UTF8',
            },

        },
        Lock => 'lock',
    },
    {
        Name        => 'Add Article, Ticket OutOfOffice',
        RequestData => {
            TicketID => $TicketIDOutOfOffice,
            Article  => {
                Subject     => 'some subject',
                Body        => 'some body',
                ContentType => 'text/plain; charset=UTF8',
            },
        },
        Lock => 'unlock',
    },

    {
        Name        => 'Add Article / Change Owner, Ticket NoOutOfOffice',
        RequestData => {
            TicketID => $TicketIDNoOutOfOffice,
            Ticket   => {
                OwnerID => $UserIDOutOfOffice,
            },
            Article => {
                Subject     => 'some subject',
                Body        => 'some body',
                ContentType => 'text/plain; charset=UTF8',
            },
        },
        Lock => 'lock',
    },
    {
        Name        => 'Add Article / Change Owner, Ticket OutOfOffice',
        RequestData => {
            TicketID => $TicketIDOutOfOffice,
            Ticket   => {
                OwnerID => $UserIDNoOutOfOffice,
            },
            Article => {
                Subject     => 'some subject',
                Body        => 'some body',
                ContentType => 'text/plain; charset=UTF8',
            },
        },
        Lock => 'lock',
    },
);

for my $Test (@Tests) {

    # create local object
    my $LocalObject = "Kernel::GenericInterface::Operation::Ticket::TicketUpdate"->new(
        %{$Self},
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
        ConfigObject   => $ConfigObject,
    );

    my %Auth = (
        UserLogin => $UserLogin,
        Password  => $Password,
    );

    # start requester with our web-service
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => 'TicketUpdate',
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    my %Ticket = $TicketObject->TicketGet(
        TicketID => $Test->{RequestData}->{TicketID},
        UserID   => 1,
    );

    $Self->Is(
        $Ticket{Lock},
        $Test->{Lock},
        "$Test->{Name} Lock attribute",
    );

    my $Success = $TicketObject->TicketLockSet(
        Lock     => 'lock',
        TicketID => $Test->{RequestData}->{TicketID},
        UserID   => 1,
    );
}

# cleanup

# delete web-service
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => $Self->{UserID},
);
$Self->True(
    $WebserviceDelete,
    "Deleted web service $WebserviceID",
);

# delete tickets
for my $TicketID (@TicketIDs) {
    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => $Self->{UserID},
    );

    # sanity check
    $Self->True(
        $TicketDelete,
        "TicketDelete() successful for Ticket ID $TicketID",
    );
}

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

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );
    my $ValuesDeleteSuccess = $BackendObject->AllValuesDelete(
        DynamicFieldConfig => $DynamicFieldConfig,
        UserID             => $Self->{UserID},
    );

    $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

1;
