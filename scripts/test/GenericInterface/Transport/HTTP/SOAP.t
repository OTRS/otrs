# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

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
my $WebserviceName = 'SOAPTest' . $HelperObject->GetRandomID();
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
my $FQDN = $ConfigObject->Get('FQDN');

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
    $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
    . '/nph-genericinterface.pl/WebserviceID/'
    . $WebserviceID;

my @Tests = (
    {
        Name           => 'Test 1',
        SuccessRequest => '0',
        RequestData    => {
            PriorityName => '5 very high',
            DataIn       => {
                Blah => 'Fasel',
            },
        },
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type => 'HTTP::SOAP',
                },
            },
        },
    },

    {
        Name             => 'Test 2',
        SuccessRequest   => '0',
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type => 'HTTP::SOAP',
                },
            },
        },
    },

    {
        Name           => 'Test 3',
        SuccessRequest => '0',
        RequestData    => {
            PriorityName => '5 very high',
            DataIn       => {
                Blah => 'Fasel',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otrs.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        MappingInbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapExact => {
                                    PriorityID => 'PriorityName',
                                    Data       => 'DataOut',
                                },
                                KeyMapDefault => {
                                    MapType => 'Ignore',
                                },
                                ValueMap => {
                                    PriorityName => {
                                        ValueMapExact => {
                                            1 => '1 sehr niedrig',
                                            2 => '2 niedrig',
                                            3 => '3 normal',
                                            4 => '4 hoch',
                                            5 => '5 sehr hoch',
                                        },
                                    },
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        MappingOutbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapDefault => {
                                    MapType => 'Keep',
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                                }
                        },
                        Type => 'Test::Test',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 4',
        SuccessRequest => '1',
        RequestData    => {
            PriorityName => '5 very high',
            DataIn       => {
                Blah        => 'Fasel',
                Umlaut      => 'äöüßÄÖÜ€ис',
                InvalidXML1 => '<test>',
                InvalidXML2 => 'test&test',
            },
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                PriorityName => '5 sehr hoch',
                DataOut      => {
                    Blah        => 'Fasel',
                    Umlaut      => 'äöüßÄÖÜ€ис',
                    InvalidXML1 => '<test>',
                    InvalidXML2 => 'test&test',
                },
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
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
                    PriorityIDName => {
                        MappingInbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapExact => {
                                    PriorityID => 'PriorityName',
                                    Data       => 'DataOut',
                                },
                                KeyMapDefault => {
                                    MapType => 'Ignore',
                                },
                                ValueMap => {
                                    PriorityName => {
                                        ValueMapExact => {
                                            1 => '1 sehr niedrig',
                                            2 => '2 niedrig',
                                            3 => '3 normal',
                                            4 => '4 hoch',
                                            5 => '5 sehr hoch',
                                        },
                                    },
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        MappingOutbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapDefault => {
                                    MapType => 'Keep',
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                                }
                        },
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace      => 'http://otrs.org/SoapTestInterface/',
                        Encoding       => 'UTF-8',
                        Endpoint       => $RemoteSystem,
                        Authentication => {
                            Type     => 'BasicAuth',
                            User     => 'MyUser',
                            Password => 'MyPass',
                        },
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        MappingInbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapDefault => {
                                    MapType => 'Keep',
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        MappingOutbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapExact => {
                                    PriorityName => 'PriorityID',
                                    DataIn       => 'Data',
                                },
                                KeyMapDefault => {
                                    MapType => 'Ignore',
                                },
                                ValueMap => {
                                    PriorityID => {
                                        ValueMapExact => {
                                            '1 very low'  => 1,
                                            '2 low'       => 2,
                                            '3 normal'    => 3,
                                            '4 high'      => 4,
                                            '5 very high' => 5,
                                        },
                                    },
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name               => 'Test 5',
        SuccessRequest     => '1',
        RequestData        => {},
        ExpectedReturnData => {
            Success => 1,
            Data    => {},
        },
        WebserviceConfig => {
            Name => 'SOAPTest1',
            Description =>
                'Test with empty data for provider and requester using SOAP transport backend.',
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
                    PriorityIDName => {
                        MappingInbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapExact => {
                                    PriorityID => 'PriorityName',
                                    Data       => 'DataOut',
                                },
                                KeyMapDefault => {
                                    MapType => 'Ignore',
                                },
                                ValueMap => {
                                    PriorityName => {
                                        ValueMapExact => {
                                            1 => '1 sehr niedrig',
                                            2 => '2 niedrig',
                                            3 => '3 normal',
                                            4 => '4 hoch',
                                            5 => '5 sehr hoch',
                                        },
                                    },
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        MappingOutbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapDefault => {
                                    MapType => 'Keep',
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                                }
                        },
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace      => 'http://otrs.org/SoapTestInterface/',
                        Encoding       => 'UTF-8',
                        Endpoint       => $RemoteSystem,
                        Authentication => {
                            Type     => 'BasicAuth',
                            User     => 'MyUser',
                            Password => 'MyPass',
                        },
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        MappingInbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapDefault => {
                                    MapType => 'Keep',
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        MappingOutbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapExact => {
                                    PriorityName => 'PriorityID',
                                    DataIn       => 'Data',
                                },
                                KeyMapDefault => {
                                    MapType => 'Ignore',
                                },
                                ValueMap => {
                                    PriorityID => {
                                        ValueMapExact => {
                                            '1 very low'  => 1,
                                            '2 low'       => 2,
                                            '3 normal'    => 3,
                                            '4 high'      => 4,
                                            '5 very high' => 5,
                                        },
                                    },
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 6',
        SuccessRequest => '1',
        RequestData    => {
            PriorityName => '5 very high',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                PriorityName => '5 very high',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace      => 'http://otrs.org/SoapTestInterface/',
                        Encoding       => 'UTF-8',
                        Endpoint       => $RemoteSystem,
                        Authentication => {
                            Type     => 'BasicAuth',
                            User     => 'MyUser',
                            Password => 'MyPass',
                        },
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 7',
        SuccessRequest => '1',
        RequestData    => {
            PriorityName => [ '5 very high', '4 high' ],
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                PriorityName => [ '5 very high', '4 high' ],
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace      => 'http://otrs.org/SoapTestInterface/',
                        Encoding       => 'UTF-8',
                        Endpoint       => $RemoteSystem,
                        Authentication => {
                            Type     => 'BasicAuth',
                            User     => 'MyUser',
                            Password => 'MyPass',
                        },
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 7',
        SuccessRequest => '1',
        RequestData    => {
            PriorityName => [
                '5 very high',
                Hash => {
                    Val => 1,
                },
            ],
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                PriorityName => [
                    '5 very high',
                    Hash => {
                        Val => 1,
                    },
                ],
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace      => 'http://otrs.org/SoapTestInterface/',
                        Encoding       => 'UTF-8',
                        Endpoint       => $RemoteSystem,
                        Authentication => {
                            Type     => 'BasicAuth',
                            User     => 'MyUser',
                            Password => 'MyPass',
                        },
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 8',
        SuccessRequest => '0',
        RequestData    => {
            TestError => 123,
            ErrorData => {
                PriorityName => [ '5 very high', '4 high' ],
            },
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => 'faultcode: Server, faultstring: Error message for error code: 123',
        },
        WebserviceConfig => {
            Name => 'SOAPTest1',
            Description =>
                'Operation handling errors test for provider and requester using SOAP transport backend.',
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace      => 'http://otrs.org/SoapTestInterface/',
                        Encoding       => 'UTF-8',
                        Endpoint       => $RemoteSystem,
                        Authentication => {
                            Type     => 'BasicAuth',
                            User     => 'MyUser',
                            Password => 'MyPass',
                        },
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 9',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 0,
            ErrorMessage =>
                "faultcode: Server, faultstring: Namespace from SOAPAction"
                . " 'http://otrs.org/InvalidSoapTestInterface/' does not match namespace"
                . " from configuration 'http://otrs.org/SoapTestInterface/'",

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for NameSpace validation.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otrs.org/InvalidSoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 10',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'WillBeOverwritten',
                        ResponseNameScheme   => 'Plain',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
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
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 11',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'WillBeOverwritten',
                        ResponseNameScheme   => 'Response',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
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
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 12',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'Test',
                        ResponseNameScheme   => 'Replace',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
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
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 13',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'PriorityIDNameResponse',
                        ResponseNameScheme   => 'Replace',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
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
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 14',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => '',
                        ResponseNameScheme   => 'Append',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
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
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 15',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'Response',
                        ResponseNameScheme   => 'Append',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
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
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 16',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => 'faultcode: Server, faultstring: Got no OperationType!',

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength           => 10000000,
                        NameSpace           => 'http://otrs.org/SoapTestInterface/',
                        Endpoint            => $RemoteSystem,
                        RequestNameFreeText => 'Name',
                        RequestNameScheme   => 'Append',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
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
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 17',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        RequestNameFreeText  => 'Test',
                        RequestNameScheme    => 'Append',
                        ResponseNameFreeText => 'PriorityIDNameTestResponse',
                        ResponseNameScheme   => 'Replace',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
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
                    PriorityIDNameTest => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 18',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => "No response data found for specified operation 'PriorityIDNameRequest' in soap response",

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otrs.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Request',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
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
                    PriorityIDNameRequest => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 19',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        RequestNameScheme    => 'Request',
                        ResponseNameFreeText => 'PriorityIDNameRequestResponse',
                        ResponseNameScheme   => 'Replace',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
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
                    PriorityIDNameRequest => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 20',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otrs.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Plain',
                    },
                },
                Operation => {
                    PriorityIDNamePlain => {
                        Type => 'Test::Test',
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
                    PriorityIDNamePlain => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 21',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otrs.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Request',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace         => 'http://otrs.org/SoapTestInterface/',
                        Encoding          => 'UTF-8',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Request',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 22',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => 'faultcode: Server, faultstring: Got no OperationType!',

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester request element name generation/validation.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace         => 'http://otrs.org/SoapTestInterface/',
                        Encoding          => 'UTF-8',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Request',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 23a',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otrs.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Request',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otrs.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        RequestNameFreeText => 'Request',
                        RequestNameScheme   => 'Append',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 23b',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => 'faultcode: Server, faultstring: Got no OperationType!',

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otrs.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'equest',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otrs.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        RequestNameFreeText => 'Request',
                        RequestNameScheme   => 'Append',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 24',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => 'faultcode: Server, faultstring: Got no OperationType!',

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otrs.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Request',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otrs.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        RequestNameFreeText => 'Test',
                        RequestNameScheme   => 'Apppend',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 25',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'WillBeOverwritten',
                        ResponseNameScheme   => 'Plain',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 26',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'WillBeOverwritten',
                        ResponseNameScheme   => 'Response',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 27',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'Test',
                        ResponseNameScheme   => 'Replace',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 28',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'PriorityIDNameResponse',
                        ResponseNameScheme   => 'Replace',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 29',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => '',
                        ResponseNameScheme   => 'Append',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 30',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'Response',
                        ResponseNameScheme   => 'Append',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 31',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success      => 0,
            ErrorMessage => 'faultcode: Server, faultstring: Got no OperationType!',

        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
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
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otrs.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        RequestNameFreeText => 'Name',
                        RequestNameScheme   => 'Append',
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    {
        Name           => 'Test 32',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
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
                    PriorityIDNameTest => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otrs.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        RequestNameFreeText  => 'Test',
                        RequestNameScheme    => 'Append',
                        ResponseNameFreeText => 'PriorityIDNameTestResponse',
                        ResponseNameScheme   => 'Replace',
                    },
                },
                Invoker => {
                    PriorityIDName => {
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
    my ($InvokerName) = keys %{ $Test->{WebserviceConfig}->{Requester}->{Invoker} };
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $InvokerName,
        Data         => $Test->{RequestData},
    );

    # check result
    $Self->Is(
        'HASH',
        ref $RequesterResult,
        "$Test->{Name} - Requester result structure is valid",
    );

    if ( !$Test->{SuccessRequest} ) {

        # check result
        $Self->False(
            $RequesterResult->{Success},
            "$Test->{Name} - Requester unsuccessful result",
        );

        if ( $Test->{ExpectedReturnData} ) {
            $Self->IsDeeply(
                $RequesterResult,
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

    $Self->IsDeeply(
        $RequesterResult,
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
