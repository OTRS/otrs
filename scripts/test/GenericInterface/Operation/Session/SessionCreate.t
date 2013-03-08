# --
# SessionCreate.t - GenericInterface SessionCreate tests for SessionConnector backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Socket;

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Requester;
use Kernel::GenericInterface::Operation::Session::SessionCreate;
use Kernel::System::AuthSession;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::UnitTest::Helper;
use Kernel::System::User;

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

my $UserObject = Kernel::System::User->new(
    %{$Self},
    ConfigObject => $ConfigObject,
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

my @Tests = (
    {
        Name           => 'Empty Request',
        SuccessRequest => 1,
        SuccessGet     => 0,
        RequestData    => {},
        ExpectedData   => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'SessionCreate',
    },
    {
        Name           => 'UserLogin No Password',
        SuccessRequest => 1,
        SuccessGet     => 0,
        RequestData    => {
            UserLogin => $UserLogin,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'SessionCreate',
    },
    {
        Name           => 'CustomerUserLogin No Password',
        SuccessRequest => 1,
        SuccessGet     => 0,
        RequestData    => {
            CustomerUserLogin => $CustomerUserLogin,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'SessionCreate',
    },
    {
        Name           => 'Password No UserLogin',
        SuccessRequest => 1,
        SuccessGet     => 0,
        RequestData    => {
            Password => $UserPassword,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'SessionCreate',
    },
    {
        Name           => 'UserLogin Invalid Password',
        SuccessRequest => 1,
        SuccessGet     => 0,
        RequestData    => {
            UserLogin => $UserLogin,
            Password  => $RandomID,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'SessionCreate',
    },
    {
        Name           => 'CustomerUserLogin Invalid Password',
        SuccessRequest => 1,
        SuccessGet     => 0,
        RequestData    => {
            CustomerUserLogin => $CustomerUserLogin,
            Password          => $RandomID,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'SessionCreate',
    },
    {
        Name           => 'Invalid UserLogin Correct Password',
        SuccessRequest => 1,
        SuccessGet     => 0,
        RequestData    => {
            UserLogin => $RandomID,
            Password  => $UserPassword,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'SessionCreate',
    },
    {
        Name           => 'Invalid CustomerUserLogin Correct Password',
        SuccessRequest => 1,
        SuccessGet     => 0,
        RequestData    => {
            CustomerUserLogin => $RandomID,
            Password          => $CustomerUserPassword,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                    }
            },
            Success => 1
        },
        Operation => 'SessionCreate',
    },
    {
        Name           => 'Correct UserLogin and Password',
        SuccessRequest => 1,
        SuccessGet     => 1,
        RequestData    => {
            UserLogin => $UserLogin,
            Password  => $UserPassword,
        },
        Operation => 'SessionCreate',
    },
    {
        Name           => 'Correct CustomerUserLogin and Password',
        SuccessRequest => 1,
        SuccessGet     => 1,
        RequestData    => {
            CustomerUserLogin => $CustomerUserLogin,
            Password          => $CustomerUserPassword,
        },
        Operation => 'SessionCreate',
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
    my $LocalObject = "Kernel::GenericInterface::Operation::Session::$Test->{Operation}"->new(
        %{$Self},
        ConfigObject   => $ConfigObject,
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
    );

    $Self->Is(
        "Kernel::GenericInterface::Operation::Session::$Test->{Operation}",
        ref $LocalObject,
        "$Test->{Name} - Create local object",
    );

    # start requester with our webservice
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
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
    if ( $Test->{SuccessGet} ) {

        # local results
        $Self->IsNot(
            $LocalResult->{Data}->{SessionID},
            undef,
            "$Test->{Name} - Local result SessionID",
        );

        # requester results
        $Self->IsNot(
            $RequesterResult->{Data}->{SessionID},
            undef,
            "$Test->{Name} - Requester result SessonID",
        );

        # local and remote request shoudl be different since each time the SessionCreate is called
        # shold return different SessionID
        $Self->IsNotDeeply(
            $LocalResult,
            $RequesterResult,
            "$Test->{Name} - Local SessionID is different that Remote SessionID.",
        );
    }

    # tests supposed to fail
    else {
        $Self->Is(
            $LocalResult->{SessionID},
            undef,
            "$Test->{Name} - Local SessionID",
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

# create needed object to cleanup the sessions
my $SessionObject = Kernel::System::AuthSession->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# cleanup sessions
my $CleanUp = $SessionObject->CleanUp();

1;
