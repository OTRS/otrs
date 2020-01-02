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

# add web service to be used (empty config)
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create web service object",
);
my $WebserviceName = 'SOAP' . $Helper->GetRandomID();
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

my $Home  = $ConfigObject->Get('Home');
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
                        NameSpace => 'http://otrs.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
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
                        NameSpace => 'http://otrs.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
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
                        NameSpace => 'http://otrs.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
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
                        NameSpace => 'http://otrs.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
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
                        NameSpace => 'http://otrs.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
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
        Name           => 'Test 7a',
        SuccessRequest => '1',
        RequestData    => {
            'Element1' => [
                'String1',
                {},
            ],
            'Element2' => {
                'String2' => {},
                'String3' => '',
            },
            'Element3' => {},
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                'Element1' => [
                    'String1',
                    '',
                ],
                'Element2' => {
                    'String2' => '',
                    'String3' => '',
                },
                'Element3' => '',
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
                        NameSpace => 'http://otrs.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
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
                        NameSpace => 'http://otrs.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
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
                        Timeout   => 60,
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
                        Timeout   => 60,
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
                        Timeout   => 60,
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
                        Timeout   => 60,
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
                        Timeout   => 60,
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
                        Timeout   => 60,
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
                        SOAPAction          => 'No',
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
                        Timeout   => 60,
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
                        SOAPAction           => 'No',
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
                        Timeout   => 60,
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
        Name           => 'Test 17',
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
                        SOAPAction        => 'No',
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
                        Timeout   => 60,
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
        Name           => 'Test 18',
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
                        SOAPAction           => 'No',
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
                        Timeout   => 60,
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
                        Timeout   => 60,
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
                        RequestNameScheme   => 'Request',
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
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
        Name           => 'Test 21',
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
                        MaxLength  => 10000000,
                        NameSpace  => 'http://otrs.org/SoapTestInterface/',
                        Endpoint   => $RemoteSystem,
                        SOAPAction => 'No',
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
                        RequestNameScheme   => 'Request',
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
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
        Name           => 'Test 22a',
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
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
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
        Name           => 'Test 22b',
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
                        SOAPAction        => 'No',
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
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
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
        Name           => 'Test 23',
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
                        SOAPAction        => 'No',
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
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
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
                        Timeout              => 60,
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
                        Timeout              => 60,
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
                        Timeout              => 60,
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
                        Timeout              => 60,
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
                        Timeout              => 60,
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
                        Timeout              => 60,
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
                        MaxLength  => 10000000,
                        NameSpace  => 'http://otrs.org/SoapTestInterface/',
                        Endpoint   => $RemoteSystem,
                        SOAPAction => 'No',
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
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
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
                        MaxLength  => 10000000,
                        NameSpace  => 'http://otrs.org/SoapTestInterface/',
                        Endpoint   => $RemoteSystem,
                        SOAPAction => 'No',
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
                        SOAPAction           => 'Yes',
                        SOAPActionSeparator  => '#',
                        Timeout              => 60,
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
            Description => 'Test for SOAPAction validation (Fallback-Config Requester vs. Fallback-Config Provider).',
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
                        Timeout   => 60,
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
        Name           => 'Test 33',
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
            Description => 'Test for SOAPAction validation (SoapActionScheme NameSpaceSeparatorOperation Provider).',
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
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '#',
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
                        Timeout   => 60,
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
        Name           => 'Test 34',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 0,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'http://otrs.org/SoapTestInterface/#PriorityIDName' does not match "
                . "expected result 'http://otrs.org/SoapTestInterface//PriorityIDName'",
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SOAPActionSeparator / Provider).',
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
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
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
                        Timeout   => 60,
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
        Name           => 'Test 35',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 0,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'http://otrs.org/SoapTestInterface/#PriorityIDName' does not match "
                . "expected result '#PriorityIDName'",
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme SeparatorOperation Provider).',
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
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'SeparatorOperation',
                        SOAPActionSeparator => '#',
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
                        Timeout   => 60,
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
        Name           => 'Test 36',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 0,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'http://otrs.org/SoapTestInterface/#PriorityIDName' does not match "
                . "expected result 'PriorityIDName'",
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme Operation Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength        => 10000000,
                        NameSpace        => 'http://otrs.org/SoapTestInterface/',
                        SOAPAction       => 'Yes',
                        SOAPActionScheme => 'Operation',
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
                        Timeout   => 60,
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
        Name           => 'Test 37',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 0,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'http://otrs.org/SoapTestInterface/#PriorityIDName' does not match "
                . "expected result 'SoapTestInterface'",
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme FreeText Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength          => 10000000,
                        NameSpace          => 'http://otrs.org/SoapTestInterface/',
                        SOAPAction         => 'Yes',
                        SOAPActionScheme   => 'FreeText',
                        SOAPActionFreeText => 'SoapTestInterface',
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
                        Timeout   => 60,
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
        Name           => 'Test 38',
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
            Description => 'Test for SOAPAction validation (SoapActionScheme NameSpaceSeparatorOperation Requester 1).',
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
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
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
        Name           => 'Test 39',
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
            Description => 'Test for SOAPAction validation (SoapActionScheme NameSpaceSeparatorOperation Requester 2).',
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
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
                        Timeout             => 60,
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
        Name           => 'Test 40',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 0,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction '#PriorityIDName' does not match "
                . "expected result 'http://otrs.org/SoapTestInterface/#PriorityIDName'",
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme SeparatorOperation Requester).',
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
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'SeparatorOperation',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
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
        Name           => 'Test 41',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 0,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'PriorityIDName' does not match "
                . "expected result 'http://otrs.org/SoapTestInterface/#PriorityIDName'",
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme Operation Requester).',
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
                        NameSpace        => 'http://otrs.org/SoapTestInterface/',
                        Encoding         => 'UTF-8',
                        Endpoint         => $RemoteSystem,
                        SOAPAction       => 'Yes',
                        SOAPActionScheme => 'Operation',
                        Timeout          => 60,
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
        Name           => 'Test 42',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturnData => {
            Success => 0,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'SoapTestInterface' does not match "
                . "expected result 'http://otrs.org/SoapTestInterface/#PriorityIDName'",
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme FreeText Requester).',
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
                        NameSpace          => 'http://otrs.org/SoapTestInterface/',
                        Encoding           => 'UTF-8',
                        Endpoint           => $RemoteSystem,
                        SOAPAction         => 'Yes',
                        SOAPActionScheme   => 'FreeText',
                        SOAPActionFreeText => 'SoapTestInterface',
                        Timeout            => 60,
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
        Name           => 'Test 43',
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
            Name => 'SOAPTest1',
            Description =>
                'Test for SOAPAction validation (SoapActionScheme NameSpaceSeparatorOperation Requester&Provider).',
            Debugger => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength           => 10000000,
                        NameSpace           => 'http://otrs.org/SoapTestInterface/',
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
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
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
                        Timeout             => 60,
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
        Name           => 'Test 44',
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
            Description => 'Test for SOAPAction validation (SoapActionScheme SeparatorOperation Requester&Provider).',
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
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'SeparatorOperation',
                        SOAPActionSeparator => '/',
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
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'SeparatorOperation',
                        SOAPActionSeparator => '/',
                        Timeout             => 60,
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
        Name           => 'Test 45',
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
            Description => 'Test for SOAPAction validation (SoapActionScheme Operation Requester&Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength        => 10000000,
                        NameSpace        => 'http://otrs.org/SoapTestInterface/',
                        SOAPAction       => 'Yes',
                        SOAPActionScheme => 'Operation',
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
                        NameSpace        => 'http://otrs.org/SoapTestInterface/',
                        Encoding         => 'UTF-8',
                        Endpoint         => $RemoteSystem,
                        SOAPAction       => 'Yes',
                        SOAPActionScheme => 'Operation',
                        Timeout          => 60,
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
        Name           => 'Test 46',
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
            Description => 'Test for SOAPAction validation (SoapActionScheme FreeText Requester&Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength          => 10000000,
                        NameSpace          => 'http://otrs.org/SoapTestInterface/',
                        SOAPAction         => 'Yes',
                        SOAPActionScheme   => 'FreeText',
                        SOAPActionFreeText => 'SoapTestInterface',
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
                        NameSpace          => 'http://otrs.org/SoapTestInterface/',
                        Encoding           => 'UTF-8',
                        Endpoint           => $RemoteSystem,
                        SOAPAction         => 'Yes',
                        SOAPActionScheme   => 'FreeText',
                        SOAPActionFreeText => 'SoapTestInterface',
                        Timeout            => 60,
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
        Name           => 'Test 47',
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
            Description => 'Test for SOAPAction validation (NameSpace with vs. without trailing slash, see bug#12196).',
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
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
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
                        NameSpace           => 'http://otrs.org/SoapTestInterface',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
                        Timeout             => 60,
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

    # update web service with real config
    my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
        ID      => $WebserviceID,
        Name    => $WebserviceName,
        Config  => $Test->{WebserviceConfig},
        ValidID => 1,
        UserID  => 1,
    );
    $Self->True(
        $WebserviceUpdate,
        "$Test->{Name} - Updated web service $WebserviceID",
    );

    # start requester with our web service
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

}

# Check headers.
@Tests = (
    {
        Name   => 'Standard response header',
        Config => {},
        Header => {
            'Content-Type' => 'text/xml; charset=UTF-8',
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
            'Content-Type' => 'text/xml; charset=UTF-8',
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

    # Create SOAP transport object with test configuration.
    my $TransportObject = Kernel::GenericInterface::Transport->new(
        DebuggerObject  => $DebuggerObject,
        TransportConfig => {
            Type   => 'HTTP::SOAP',
            Config => $Test->{Config},
        },
    );
    $Self->Is(
        ref $TransportObject,
        'Kernel::GenericInterface::Transport',
        "$Test->{Name} - TransportObject instantiated with SOAP backend"
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

# cleanup web service
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);
$Self->True(
    $WebserviceDelete,
    "Deleted web service $WebserviceID",
);

1;
