# --
# Common.t - Operation tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::User;
use Kernel::GenericInterface::Operation::Session::Common;

use Kernel::System::UnitTest::Helper;

use Kernel::GenericInterface::Debugger;
use Kernel::System::GenericInterface::Webservice;

# helper object
# skip SSL certiciate verification
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject => $Self,
    SkipSSLVerify  => 1,
);

my $RandomID = $HelperObject->GetRandomID();

# create local config object
my $ConfigObject = Kernel::Config->new();

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

# create needed objects
my $UserObject = Kernel::System::User->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $GroupObject = Kernel::System::Group->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $SessionCommonObject = Kernel::GenericInterface::Operation::Session::Common->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    ConfigObject   => $ConfigObject,
);
$Self->Is(
    ref $SessionCommonObject,
    'Kernel::GenericInterface::Operation::Session::Common',
    'CommonObject instanciate correctly',
);

# set user details
my $UserLogin    = $HelperObject->TestUserCreate();
my $UserPassword = $UserLogin;
my $UserID       = $UserObject->UserLookup(
    UserLogin => $UserLogin,
);

# set customer user details
my $CustomerUserLogin    = $HelperObject->TestCustomerUserCreate();
my $CustomerUserPassword = $CustomerUserLogin;
my $CustomerUserID       = $CustomerUserLogin;

# Tests for CreateSessionID
my @Tests = (
    {
        Name    => 'Empty',
        Data    => {},
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
        Name => 'Correct UserLogin and Password',
        Data => {
            UserLogin => $UserLogin,
            Password  => $UserPassword,
        },
        Success => 1,
    },
    {
        Name => 'Correct CustomerUserLogin and Password',
        Data => {
            CustomerUserLogin => $CustomerUserLogin,
            Password          => $CustomerUserPassword,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $SessionID = $SessionCommonObject->CreateSessionID(
        Data => $Test->{Data},
    );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $SessionID,
            undef,
            "GerSessionID() - $Test->{Name}",
        );
    }

    else {
        $Self->Is(
            $SessionID,
            undef,
            "GerSessionID() - $Test->{Name}",
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

1;
