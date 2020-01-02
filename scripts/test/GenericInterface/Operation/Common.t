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

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation::Ticket::TicketCreate;
use Kernel::GenericInterface::Operation::Session::SessionCreate;

# get helper object
# skip SSL certificate verification
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify   => 1,
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# create web service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create web service object",
);

# set web service name
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
    "Added web service",
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

# Operation::Common is not an Object but a base class, instantiate any operation that uses it.
my $TicketOperationObject = Kernel::GenericInterface::Operation::Ticket::TicketCreate->new(
    DebuggerObject => $DebuggerObject,
    WebserviceID   => $WebserviceID,
);
$Self->Is(
    ref $TicketOperationObject,
    'Kernel::GenericInterface::Operation::Ticket::TicketCreate',
    'OperationObject instantiate correctly',
);

# Session::Common is not an Object but a base class, instantiate any operation that uses it.
my $SessionOperationObject = Kernel::GenericInterface::Operation::Session::SessionCreate->new(
    DebuggerObject => $DebuggerObject,
    WebserviceID   => $WebserviceID,
);
$Self->Is(
    ref $SessionOperationObject,
    'Kernel::GenericInterface::Operation::Session::SessionCreate',
    'SessionCommonObject instantiate correctly',
);

# set user details
my $UserLogin    = $Helper->TestUserCreate();
my $UserPassword = $UserLogin;
my $UserID       = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $UserLogin,
);
my $UserSessionID = $SessionOperationObject->CreateSessionID(
    Data => {
        UserLogin => $UserLogin,
        Password  => $UserPassword,
    },
);

# set customer user details
my $CustomerUserLogin     = $Helper->TestCustomerUserCreate();
my $CustomerUserPassword  = $CustomerUserLogin;
my $CustomerUserID        = $CustomerUserLogin;
my $CustomerUserSessionID = $SessionOperationObject->CreateSessionID(
    Data => {
        CustomerUserLogin => $CustomerUserLogin,
        Password          => $CustomerUserPassword,
    },
);

# sanity checks
$Self->IsNot(
    $UserSessionID,
    undef,
    "CreateSessionID() for User"
);
$Self->IsNot(
    $CustomerUserSessionID,
    undef,
    "CreateSessionID() for CustomerUser"
);

# Tests for Auth()
my @Tests = (
    {
        Name    => 'Empty',
        Data    => {},
        Success => 0,
    },
    {
        Name    => 'No SessionID',
        Data    => {},
        Success => 0,
    },
    {
        Name => 'Invalid SessionID',
        Data => {
            SessionID => $RandomID,
        },
        Success => 0,
    },
    {
        Name => 'UserLogin No Password',
        Data => {
            UserLogin => $UserLogin,
        },
        Success => 0,
    },
    {
        Name => 'CustomerUserLogin No Password',
        Data => {
            CustomerUserLogin => $CustomerUserLogin,
        },
        Success => 0,
    },
    {
        Name => 'Password No UserLogin',
        Data => {
            Password => $UserPassword,
        },
        Success => 0,
    },
    {
        Name => 'UserLogin Invalid Password',
        Data => {
            UserLogin => $UserLogin,
            Password  => $RandomID,
        },
        Success => 0,
    },
    {
        Name => 'CustomerUserLogin Invalid Password',
        Data => {
            CustomerUserLogin => $CustomerUserLogin,
            Password          => $RandomID,
        },
        Success => 0,
    },
    {
        Name => 'Invalid UserLogin Correct Password',
        Data => {
            UserLogin => $RandomID,
            Password  => $UserPassword,
        },
        Success => 0,
    },
    {
        Name => 'Invalid CustomerUserLogin Correct Password',
        Data => {
            CustomerUserLogin => $RandomID,
            Password          => $CustomerUserPassword,
        },
        Success => 0,
    },
    {
        Name => 'Correct User SessionID',
        Data => {
            SessionID => $UserSessionID,
        },
        ExpectedResult => {
            User     => $UserID,
            UserType => 'User',
        },
        Success => 1,
    },
    {
        Name => 'Correct CustomerSessionID',
        Data => {
            SessionID => $CustomerUserSessionID,
        },
        ExpectedResult => {
            User     => $CustomerUserID,
            UserType => 'Customer',
        },
        Success => 1,
    },
    {
        Name => 'Correct UserLogin and Password',
        Data => {
            UserLogin => $UserLogin,
            Password  => $UserPassword,
        },
        ExpectedResult => {
            User     => $UserID,
            UserType => 'User',
        },
        Success => 1,
    },
    {
        Name => 'Correct CustomerUserLogin and Password',
        Data => {
            CustomerUserLogin => $CustomerUserLogin,
            Password          => $CustomerUserPassword,
        },
        ExpectedResult => {
            User     => $CustomerUserID,
            UserType => 'Customer',
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my ( $User, $UserType ) = $TicketOperationObject->Auth(
        Data => $Test->{Data},
    );

    if ( $Test->{Success} ) {
        $Self->Is(
            $User,
            $Test->{ExpectedResult}->{User},
            "Auth() - $Test->{Name}: User",
        );
        $Self->Is(
            $UserType,
            $Test->{ExpectedResult}->{UserType},
            "Auth() - $Test->{Name}: UserType",
        );
    }

    else {
        $Self->Is(
            $User,
            0,
            "Auth() - $Test->{Name}: User",
        );
        $Self->Is(
            $UserType,
            undef,
            "Auth() - $Test->{Name}: UserType",
        );
    }
}

# cleanup is done by RestoreDatabase.

1;
