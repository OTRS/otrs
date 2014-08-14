# --
# REST.t -  GenericInterface transport interface tests for REST backend
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;
use vars (qw($Self));

# helper object
# skip SSL certificate verification
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# add webservice to be used (empty config)
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create webservice object",
);
my $WebserviceName = 'TestREST' . $HelperObject->GetRandomID();
my $WebserviceID   = $WebserviceObject->WebserviceAdd(
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

# try to resolve FQDN host
if ( $FQDN ne 'yourhost.example.com' && gethostbyname($FQDN) ) {
    $Host = $FQDN;
}

# try to resolve localhost instead
if ( !$Host && gethostbyname('localhost') ) {
    $Host = 'localhost';
}

# use hard coded localhost IP address
if ( !$Host ) {
    $Host = '127.0.0.1';
}

# prepare webservice config
my $BaseURL =
    $Self->{ConfigObject}->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $Self->{ConfigObject}->Get('ScriptAlias')
    . '/nph-genericinterface.pl/WebserviceID/'
    . $WebserviceID;

my @Tests = (
    {
        Name        => 'Wrong Path Name Provider - Basic Transport Mapping',
        Success     => '0',
        RequestData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => undef,
        WebserviceConfig   => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Wrong',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name        => 'Wrong Path Extra \'/\' Provider - Basic Transport Mapping',
        Success     => '0',
        RequestData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => undef,
        WebserviceConfig   => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test/',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name        => 'Wrong HTTP method Provider - Basic Transport Mapping',
        Success     => '0',
        RequestData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => undef,
        WebserviceConfig   => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['GET'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name        => 'Wrong Path Name Requester - Basic Transport Mapping',
        Success     => '0',
        RequestData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => undef,
        WebserviceConfig   => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Wrong',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name        => 'Wrong Path Extra \'/\' Requester - Basic Transport Mapping',
        Success     => '0',
        RequestData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => undef,
        WebserviceConfig   => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name        => 'Wrong HTTP command Requester - Basic Transport Mapping',
        Success     => '0',
        RequestData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => undef,
        WebserviceConfig   => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'GET',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name        => 'Correct Basic Transport Mapping POST',
        Success     => '1',
        RequestData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name        => 'Correct Basic Transport Mapping GET',
        Success     => '1',
        RequestData => {
            Other  => 'Data',
            Other1 => 'One',
            Other2 => 'Two',
            Other3 => 'Three',
            Other4 => 'Four',
        },
        ExpectedReturnData => {
            Other  => 'Data',
            Other1 => 'One',
            Other2 => 'Two',
            Other3 => 'Three',
            Other4 => 'Four',
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => [ 'GET', 'POST' ],
                                Route => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'GET',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name        => 'Correct Complex Transport Mapping URIParams 1 POST',
        Success     => '1',
        RequestData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => {
            URI     => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test/:URI',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/:Other',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name        => 'Correct Complex Transport Mapping URIParams POST 2',
        Success     => '1',
        RequestData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => {
            URI     => 'Data',
            URI2    => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test/:URI/:URI2',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/:Other/:Other1',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name        => 'Correct Complex Transport Mapping URIParams QueryParams POST',
        Success     => '1',
        RequestData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => {
            Other   => 'Data',
            URI1    => 'One',
            URI2    => 'Two',
            Query3  => 'Three',
            Query4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test/:URI1/:URI2',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/:Other1/:Other2?Query3=:Other3&Query4=:Other4',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name        => 'Correct Complex Transport Mapping URIParams QueryParams GET',
        Success     => '1',
        RequestData => {
            Other  => 'Data',
            Other1 => 'One',
            Other2 => 'Two',
            Other3 => 'Three',
            Other4 => 'Four',
        },
        ExpectedReturnData => {
            Other  => 'Data',
            URI1   => 'One',
            Other2 => 'Two',
            Other3 => 'Three',
            Query4 => 'Four',
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['GET'],
                                Route         => '/Test/:URI1/',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'GET',
                        Host                     => $BaseURL,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/:Other1/?Query4=:Other4',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
);

# create requester object
my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
$Self->Is(
    'Kernel::GenericInterface::Requester',
    ref $RequesterObject,
    "Create requester object",
);

TEST:
for my $Test (@Tests) {

    # update webservice with real config
    my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(

        ID      => $WebserviceID,
        Name    => $WebserviceName,
        Config  => $Test->{WebserviceConfig},
        ValidID => 1,
        UserID  => 1,
    );
    $Self->True(
        $WebserviceUpdate,
        "$Test->{Name} - Updated Webservice $WebserviceID",
    );

    # start requester with our webservice
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => 'TestSimple',
        Data         => $Test->{RequestData},
    );

    # check result
    $Self->Is(
        'HASH',
        ref $RequesterResult,
        "$Test->{Name} - Requester result structure is valid",
    );

    if ( !$Test->{Success} ) {

        # check result
        $Self->False(
            $RequesterResult->{Success},
            "$Test->{Name} - Requester unsuccessful result",
        );

        if ( $Test->{ExpectedReturnData} ) {
            $Self->IsNot(
                $RequesterResult->{Message},
                $Test->{ExpectedReturnData},
                "$Test->{Name} - Requester unsuccessful status (needs configured and running webserver)",
            );
        }

        next TEST;
    }

    $Self->True(
        $RequesterResult->{Success},
        "$Test->{Name} - Requester successful result",
    );

    delete $RequesterResult->{Data}->{RequestMethod};

    $Self->IsDeeply(
        $RequesterResult->{Data},
        $Test->{ExpectedReturnData},
        "$Test->{Name} - Requester success status (needs configured and running webserver)",
    );
}    #end loop

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
