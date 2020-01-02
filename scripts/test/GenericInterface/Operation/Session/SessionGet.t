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
use Kernel::GenericInterface::Operation::Session::SessionGet;

use Kernel::System::VariableCheck qw(:all);

# Skip SSL certificate verification (RestoreDatabase must not be used in this test).
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomNumber();

# create new users for current test
my $UserLogin1 = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $Password1 = $UserLogin1;

my $UserID1 = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $UserLogin1,
);

my $UserLogin2 = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $Password2 = $UserLogin2;

my $UserID2 = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $UserLogin2,
);

my $UserLogin3 = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $Password3 = $UserLogin3;

my $UserID3 = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $UserLogin3,
);

my $UserLogin4 = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $Password4 = $UserLogin4;

my $UserID4 = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $UserLogin4,
);

# Set web-service name.
my $WebserviceName = '-Test-' . $RandomID;

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
    "Added Web Service",
);

# Get remote host with some precautions for certain unit test systems.
my $Host = $Helper->GetTestHTTPHostname();

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Prepare web-service config.
my $RemoteSystem =
    $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
    . '/nph-genericinterface.pl/WebserviceID/'
    . $WebserviceID;

my $WebserviceConfig = {
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
            SessionGet => {
                Type => 'Session::SessionGet',
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
            SessionGet => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# Update web-service with real config, the update is needed because we are using the WebserviceID
#   for the Endpoint in config.
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => $UserID2,
);
$Self->True(
    $WebserviceUpdate,
    "Updated Web Service $WebserviceID - $WebserviceName",
);

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

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SessionCheckRemoteIP',
    Value => 0,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SessionMaxTime',
    Value => 10,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SessionMaxIdleTime',
    Value => 5,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SessionModule',
    Value => 'Kernel::System::AuthSession::DB',
);

my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

$Helper->FixedTimeSet();

my $Epoch = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

# Create a new session, this will be expired (max time) afterwards.
my $SessionID1 = $SessionObject->CreateSessionID(
    UserLogin       => $UserLogin1,
    UserEmail       => $UserLogin1,
    UserID          => $UserID1,
    UserType        => 'User',
    UserLastRequest => $Epoch + 20,
);

$Helper->FixedTimeAddSeconds(11);

$Epoch = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

# Create a new session, this will be expired (max idle time) afterwards.
my $SessionID2 = $SessionObject->CreateSessionID(
    UserLogin       => $UserLogin1,
    UserEmail       => $UserLogin1,
    UserID          => $UserID1,
    UserType        => 'User',
    UserLastRequest => $Epoch,
);

$Helper->FixedTimeAddSeconds(6);

$Epoch = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

# Create a new session, with simple data.
my $SessionID3 = $SessionObject->CreateSessionID(
    UserLogin       => $UserLogin3,
    UserEmail       => $UserLogin3,
    UserID          => $UserID3,
    UserType        => 'User',
    UserLastRequest => $Epoch,
    Simple          => 123,
);

# Create a new session, with complex data.
my %Complex = (
    Key1 => 'String',
    Key2 => ['Array'],
    Key3 => {
        Hash => 1,
    },
);
my $ComplexJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
    Data     => \%Complex,
    SortKeys => 1,
);

my $SessionID4 = $SessionObject->CreateSessionID(
    UserLogin       => $UserLogin4,
    UserEmail       => $UserLogin4,
    UserID          => $UserID4,
    UserType        => 'User',
    UserLastRequest => $Epoch,
    Complex         => \%Complex,
);

# Define test cases.
my @Tests = (
    {
        Name                    => 'Empty request',
        SuccessRequest          => 1,
        RequestData             => {},
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode    => 'SessionGet.MissingParameter',
                    ErrorMessage => 'SessionGet: The request is empty!'
                },
            },
            Success => 1,
        },
        Operation => 'SessionGet',
    },
    {
        Name           => 'Missing SessionID',
        SuccessRequest => 1,
        RequestData    => {
            SessionID => '',
        },
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode    => 'SessionGet.MissingParameter',
                    ErrorMessage => 'SessionGet: SessionID is missing!'
                },
            },
            Success => 1,
        },
        Operation => 'SessionGet',
    },
    {
        Name           => 'Wrong SessionID',
        SuccessRequest => 1,
        RequestData    => {
            SessionID => 12345,
        },
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode    => 'SessionGet.SessionInvalid',
                    ErrorMessage => 'SessionGet: SessionID is Invalid!'
                },
            },
            Success => 1,
        },
        Operation => 'SessionGet',
    },

    {
        Name           => 'Session Expired Max Time',
        SuccessRequest => 1,
        RequestData    => {
            SessionID => $SessionID1,
        },
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode    => 'SessionGet.SessionInvalid',
                    ErrorMessage => 'SessionGet: SessionID is Invalid!'
                },
            },
            Success => 1,
        },
        Operation => 'SessionGet',
    },
    {
        Name           => 'Session Expired Max Time Idle',
        SuccessRequest => 1,
        RequestData    => {
            SessionID => $SessionID2,
        },
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode    => 'SessionGet.SessionInvalid',
                    ErrorMessage => 'SessionGet: SessionID is Invalid!'
                },
            },
            Success => 1,
        },
        Operation => 'SessionGet',
    },
    {
        Name           => 'Session Simple Data',
        SuccessRequest => 1,
        RequestData    => {
            SessionID => $SessionID3,
        },
        ExpectedReturnLocalData => {
            Data => {
                SessionData => [
                    {
                        Key   => 'Simple',
                        Value => 123,
                    },
                    {
                        Key   => 'UserEmail',
                        Value => $UserLogin3,
                    },
                    {
                        Key   => 'UserID',
                        Value => $UserID3,
                    },
                    {
                        Key   => 'UserLastRequest',
                        Value => $Epoch,
                    },
                    {
                        Key   => 'UserLogin',
                        Value => $UserLogin3,
                    },
                    {
                        Key   => 'UserRemoteAddr',
                        Value => 'none',
                    },
                    {
                        Key   => 'UserRemoteUserAgent',
                        Value => 'none',
                    },
                    {
                        Key   => 'UserSessionStart',
                        Value => $Epoch,
                    },
                    {
                        Key   => 'UserType',
                        Value => 'User',
                    },
                ],
            },
            Success => 1,
        },
        Operation => 'SessionGet',
    },
    {
        Name           => 'Session Complex Data',
        SuccessRequest => 1,
        RequestData    => {
            SessionID => $SessionID4,
        },
        ExpectedReturnLocalData => {
            Data => {
                SessionData => [
                    {
                        Key        => 'Complex',
                        Serialized => 1,
                        Value      => $ComplexJSON,
                    },
                    {
                        Key   => 'UserEmail',
                        Value => $UserLogin4,
                    },
                    {
                        Key   => 'UserID',
                        Value => $UserID4,
                    },
                    {
                        Key   => 'UserLastRequest',
                        Value => $Epoch,
                    },
                    {
                        Key   => 'UserLogin',
                        Value => $UserLogin4,
                    },
                    {
                        Key   => 'UserRemoteAddr',
                        Value => 'none',
                    },
                    {
                        Key   => 'UserRemoteUserAgent',
                        Value => 'none',
                    },
                    {
                        Key   => 'UserSessionStart',
                        Value => $Epoch,
                    },
                    {
                        Key   => 'UserType',
                        Value => 'User',
                    },
                ],
            },
            Success => 1,
        },
        Operation => 'SessionGet',
    },
);

TEST:
for my $Test (@Tests) {

    my $LocalObject = "Kernel::GenericInterface::Operation::Session::$Test->{Operation}"->new(
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
    );

    $Self->Is(
        "Kernel::GenericInterface::Operation::Session::$Test->{Operation}",
        ref $LocalObject,
        "$Test->{Name} - Create local object",
    );

    # Start requester with our web-service.
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %{ $Test->{RequestData} },
        },
    );

    # Remove ErrorMessage parameter from direct call result to be consistent with SOAP call result.
    if ( $LocalResult->{ErrorMessage} ) {
        delete $LocalResult->{ErrorMessage};
    }

    # Check result.
    $Self->Is(
        'HASH',
        ref $LocalResult,
        "$Test->{Name} - Local result structure is valid",
    );

    $Self->IsDeeply(
        $LocalResult,
        $Test->{ExpectedReturnLocalData},
        "$Test->{Name} - Expected Local result",
    );

    my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
    $Self->Is(
        'Kernel::GenericInterface::Requester',
        ref $RequesterObject,
        "$Test->{Name} - Create requester object",
    );

    # Start requester with our web service.
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %{ $Test->{RequestData} },
        },
    );

    # Check result.
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

    if ( defined $LocalResult->{Data}->{SessionData} ) {
        @{ $LocalResult->{Data}->{SessionData} }
            = grep { $_->{Key} ne 'UserSessionStart' && $_->{Key} ne 'UserLastRequest' }
            @{ $LocalResult->{Data}->{SessionData} };
    }
    if ( defined $RequesterResult->{Data}->{SessionData} ) {
        @{ $RequesterResult->{Data}->{SessionData} }
            = grep { $_->{Key} ne 'UserSessionStart' && $_->{Key} ne 'UserLastRequest' }
            @{ $RequesterResult->{Data}->{SessionData} };
    }

    $Self->IsDeeply(
        $LocalResult,
        $RequesterResult,
        "$Test->{Name} - Local Vs Requester results",
    );
}

# Delete web service.
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => $UserID1,
);
$Self->True(
    $WebserviceDelete,
    "Deleted Web Service $WebserviceID",
);

for my $SessionID ( $SessionID1, $SessionID2, $SessionID3, $SessionID4 ) {
    my $Success = $SessionObject->RemoveSessionID( SessionID => $SessionID );
    $Self->True(
        $Success,
        "RemoveSessionID() for $SessionID",
    );
}

# Also delete any other added data during the this test, since RestoreDatabase must not be used.

1;
