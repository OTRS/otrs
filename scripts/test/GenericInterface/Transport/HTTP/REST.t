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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Skip SSL certificate verification.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Add web service to be used (empty config).
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    'Create web service object'
);
my $WebserviceName = 'REST' . $Helper->GetRandomID();
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
    'Added Web service'
);

# Get remote host with some precautions for certain unit test systems.
my $Host = $Helper->GetTestHTTPHostname();

# Prepare web service config.
my $BaseURL =
    $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
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
                        Timeout                  => 120,
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
                        Timeout                  => 120,
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
                        Timeout                  => 120,
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
                        Timeout                  => 120,
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
                        Timeout                  => 120,
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
                        Timeout                  => 120,
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
                        Timeout                  => 120,
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
                        Timeout                  => 120,
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
                        Timeout                  => 120,
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
                        Timeout                  => 120,
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
                        Timeout                  => 120,
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
                        Timeout                  => 120,
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

    # tests for bug #12049
    {
        Name        => 'UTF8 test GET',
        Success     => '1',
        RequestData => {
            Other => 'äöüß€ÄÖÜ',
        },
        ExpectedReturnData => {
            Other => 'äöüß€ÄÖÜ',
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
                        Timeout                  => 120,
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
        Name        => 'UTF8 test POST',
        Success     => '1',
        RequestData => {
            Other => 'äöüß€ÄÖÜ',
        },
        ExpectedReturnData => {
            Other => 'äöüß€ÄÖÜ',
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
                        Timeout                  => 120,
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
        Name        => 'UTF8 test POST mixed with GET params',
        Success     => '1',
        RequestData => {
            Other  => 'äöüß€ÄÖÜ',
            Other1 => 'ÄÖÜß€äöü',
        },
        ExpectedReturnData => {
            Other  => 'äöüß€ÄÖÜ',
            Other1 => 'ÄÖÜß€äöü',
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
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test?Other1=:Other1',
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
        Name        => 'UTF8 test GET with URI params',
        Success     => '1',
        RequestData => {
            Other => 'äöüß€ÄÖÜ',
        },
        ExpectedReturnData => {
            Other  => 'äöüß€ÄÖÜ',
            Other1 => 'ÄÖÜß€äöü',
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
                                Route         => '/Test/:Other1',
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
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/ÄÖÜß€äöü',
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
        Name        => 'UTF8 test POST with URI params',
        Success     => '1',
        RequestData => {
            Other => 'äöüß€ÄÖÜ',
        },
        ExpectedReturnData => {
            Other  => 'äöüß€ÄÖÜ',
            Other1 => 'ÄÖÜß€äöü',
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
                                Route         => '/Test/:Other1',
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
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/ÄÖÜß€äöü',
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

# Create requester object.
my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
$Self->Is(
    'Kernel::GenericInterface::Requester',
    ref $RequesterObject,
    'Create requester object'
);

TEST:
for my $Test (@Tests) {

    # Update web service with real config.
    my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
        ID      => $WebserviceID,
        Name    => $WebserviceName,
        Config  => $Test->{WebserviceConfig},
        ValidID => 1,
        UserID  => 1,
    );
    $Self->True(
        $WebserviceUpdate,
        "$Test->{Name} - Updated Web service $WebserviceID"
    );

    # start requester with our web service
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => 'TestSimple',
        Data         => $Test->{RequestData},
    );

    # check result
    $Self->Is(
        'HASH',
        ref $RequesterResult,
        "$Test->{Name} - Requester result structure is valid"
    );

    if ( !$Test->{Success} ) {

        # check result
        $Self->False(
            $RequesterResult->{Success},
            "$Test->{Name} - Requester unsuccessful result"
        );

        if ( $Test->{ExpectedReturnData} ) {
            $Self->IsNot(
                $RequesterResult->{Message},
                $Test->{ExpectedReturnData},
                "$Test->{Name} - Requester unsuccessful status (needs configured and running web server)"
            );
        }

        next TEST;
    }

    $Self->True(
        $RequesterResult->{Success},
        "$Test->{Name} - Requester successful result"
    );

    delete $RequesterResult->{Data}->{RequestMethod};

    $Self->IsDeeply(
        $RequesterResult->{Data},
        $Test->{ExpectedReturnData},
        "$Test->{Name} - Requester success status (needs configured and running web server)"
    );
}

# Check direct requests.
@Tests = (
    {
        Name        => 'Correct Direct Request GET Special Chars',
        Success     => '1',
        RequestData => {
            Other1 => 'DataOne',
            Other2 => 'Data Two',
            Other3 => 'Data%20Tree',
            Other4 => 'Data+Four',
            Other5 => 'Data%2BFive'
        },
        ExpectedReturnData => {
            Other1 => 'DataOne',
            Other2 => 'Data Two',
            Other3 => 'Data Tree',
            Other4 => 'Data Four',
            Other5 => 'Data+Five'
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
        },
    },
);

# Get JSON object.
my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

TEST:
for my $Test (@Tests) {

    # Update web service with real config.
    my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
        ID      => $WebserviceID,
        Name    => $WebserviceName,
        Config  => $Test->{WebserviceConfig},
        ValidID => 1,
        UserID  => 1,
    );
    $Self->True(
        $WebserviceUpdate,
        "$Test->{Name} - Updated Web service $WebserviceID"
    );

    my $RequestParams;
    for my $DataKey ( sort keys %{ $Test->{RequestData} } ) {
        $RequestParams .= "$DataKey=$Test->{RequestData}->{$DataKey}&";
    }

    # Perform request.
    my %Response = $Kernel::OM->Get('Kernel::System::WebUserAgent')->Request(
        Type => 'GET',
        URL  => $BaseURL
            . $Test->{WebserviceConfig}->{Provider}->{Transport}->{Config}->{RouteOperationMapping}->{TestSimple}
            ->{Route}
            . '?'
            . $RequestParams,
    );

    if ( !$Test->{Success} ) {

        # Check result.
        $Self->IsNot(
            $Response{Status},
            '200 OK',
            "$Test->{Name} - Response unsuccessful result"
        );

        next TEST;
    }

    $Self->Is(
        $Response{Status},
        '200 OK',
        "$Test->{Name} - Response successful result"
    );

    my $ReturnData = $JSONObject->Decode(
        Data => ${ $Response{Content} },
    );

    delete $ReturnData->{RequestMethod};

    $Self->IsDeeply(
        $ReturnData,
        $Test->{ExpectedReturnData},
        "$Test->{Name} - Response data (needs configured and running web server)"
    );
}

# Check headers.
@Tests = (
    {
        Name   => 'Standard response header',
        Config => {},
        Header => {
            'Content-Type' => 'application/json; charset=UTF-8',
        },
    },
    {
        Name   => 'Additional response headers',
        Config => {
            AdditionalHeaders => {
                Key1 => 'Value1',
                Key2 => 'Value2',
            },
        },
        Header => {
            'Content-Type' => 'application/json; charset=UTF-8',
            Key1           => 'Value1',
            Key2           => 'Value2',
        },
    },
);

# Create debugger object.
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    CommunicationType => 'Provider',
    WebserviceID      => $WebserviceID,
);

for my $Test (@Tests) {

    # Create REST transport object with test configuration.
    my $TransportObject = Kernel::GenericInterface::Transport->new(
        DebuggerObject  => $DebuggerObject,
        TransportConfig => {
            Type   => 'HTTP::REST',
            Config => $Test->{Config},
        },
    );
    $Self->Is(
        ref $TransportObject,
        'Kernel::GenericInterface::Transport',
        "$Test->{Name} - TransportObject instantiated with REST backend"
    );

    my $Response = '';
    my $Result;
    {

        # Redirect STDOUT from string so that the transport layer will write there.
        local *STDOUT;
        open STDOUT, '>:utf8', \$Response;    ## no critic

        # Discard request object to prevent errors.
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );

        # Create response.
        $Result = $TransportObject->ProviderGenerateResponse(
            Success => 1,
            Data    => {},
        );
    }
    $Self->True(
        $Result,
        "$Test->{Name} - Response created"
    );

    # Analyze headers.
    for my $Key ( sort keys %{ $Test->{Header} } ) {
        $Self->True(
            index( $Response, "$Key: $Test->{Header}->{$Key}\r\n" ) != -1,
            "$Test->{Name} - Found header '$Key' with value '$Test->{Header}->{$Key}'"
        );
    }
}

# Cleanup test web service.
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);
$Self->True(
    $WebserviceDelete,
    "Deleted Web service $WebserviceID"
);

1;
