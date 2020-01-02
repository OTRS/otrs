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

use Socket;

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation::Session::SessionCreate;

# get config object
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

# set user details
my ( $UserLogin, $UserID ) = $Helper->TestUserCreate();
my $UserPassword = $UserLogin;

# set customer user details
my $CustomerUserLogin    = $Helper->TestCustomerUserCreate();
my $CustomerUserPassword = $CustomerUserLogin;
my $CustomerUserID       = $CustomerUserLogin;

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
    UserID  => $UserID,
);
$Self->True(
    $WebserviceID,
    "Added web service",
);

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# prepare web service config
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
            SessionCreate => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# update web service with real config
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => $UserID,
);
$Self->True(
    $WebserviceUpdate,
    "Updated web service $WebserviceID - $WebserviceName",
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
    my $LocalObject = "Kernel::GenericInterface::Operation::Session::$Test->{Operation}"->new(
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
    );

    $Self->Is(
        "Kernel::GenericInterface::Operation::Session::$Test->{Operation}",
        ref $LocalObject,
        "$Test->{Name} - Create local object",
    );

    # start requester with our web service
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %{ $Test->{RequestData} },
        },
    );

    # sleep between requests to have different timestamps
    # because of failing tests on windows
    sleep 1;

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

    # start requester with our web service
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

        # local and remote request should be different since each time the SessionCreate is called
        # should return different SessionID
        $Self->IsNotDeeply(
            $LocalResult,
            $RequesterResult,
            "$Test->{Name} - Local SessionID is different than Remote SessionID.",
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

# clean up web service
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => $UserID,
);
$Self->True(
    $WebserviceDelete,
    "Deleted web service $WebserviceID",
);

# cleanup sessions
my $CleanUp = $Kernel::OM->Get('Kernel::System::AuthSession')->CleanUp();

1;
