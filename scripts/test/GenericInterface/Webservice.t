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

# get needed objects
my $WebserviceObject        = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
my $WebserviceHistoryObject = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory');

my $RandomID = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomID();

my @Tests = (
    {
        Name          => 'test 1',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Name        => 'Nagios',
                Description => 'Connector to send and receive date from Nagios.',
                Debugger    => {
                    DebugThreshold => 'debug',
                    TestMode       => 1,
                },
                Provider => {
                    Transport => {
                        Type   => 'HTTP::SOAP',
                        Config => {
                            NameSpace  => '',
                            SOAPAction => '',
                            Encoding   => '',
                            Endpoint   => '',
                        },
                    },
                    Operation => {
                        Operation1 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                            Type => 'Test::Test',
                        },
                        Operation2 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                        },
                    },
                },
                Requester => {
                    Transport => {
                        Type   => 'HTTP::SOAP',
                        Config => {
                            NameSpace  => '',
                            SOAPAction => '',
                            Encoding   => '',
                            Endpoint   => '',
                        },
                    },
                    Invokers => {
                        Invoker1 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                        },
                        Invoker2 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                            Type => 'Test::Test',
                        },
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 2',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Name        => 'Nagios',
                Description => 'Connector to send and receive date from Nagios 2.',
                Debugger    => {
                    DebugThreshold => 'debug',
                    TestMode       => 1,
                },
                Provider => {
                    Transport => {
                        Type   => 'HTTP::SOAP',
                        Config => {
                            NameSpace  => '!"§$%&/()=?Ü*ÄÖL:L@,.-',
                            SOAPAction => '',
                            Encoding   => '',
                            Endpoint =>
                                'iojfoiwjeofjweoj ojerojgv oiaejroitjvaioejhtioja viorjhiojgijairogj aiovtq348tu 08qrujtio juortu oquejrtwoiajdoifhaois hnaeruoigbo eghjiob jaer89ztuio45u603u4i9tj340856u903 jvipojziopeji',
                        },
                    },
                    Operation => {
                        Operation1 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                            Type => 'Test::Test',
                        },
                        Operation2 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                        },
                    },
                },
                Requester => {
                    Transport => {
                        Type   => 'HTTP::REST',
                        Config => {
                            NameSpace => '',
                            Encoding  => '',
                            Endpoint  => '',
                        },
                    },
                    Invokers => {
                        Invoker1 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                            Type => 'Test::Test',
                        },
                    },
                },
            },
            ValidID => 2,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 3',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 2,
        Add           => {
            Config  => {},
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config  => { 1 => 1 },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 4',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 2,
        Add           => {
            Config => {
                Name        => 'Nagios',
                Description => 'Connector to send and receive date from Nagios 2.'
                    . "\nasdkaosdkoa\tsada\n",
                Debugger => {
                    DebugThreshold => 'debug',
                    TestMode       => 1,
                },
                Provider => {
                    Transport => {
                        Type => '',
                    },
                },
                Requester => {
                    Transport => {
                        Type   => 'HTTP::REST',
                        Config => {
                            NameSpace => '',
                            Encoding  => '',
                            Endpoint  => '',
                        },
                    },
                },
            },
            ValidID => 2,
            UserID  => 1,
        },
        Update => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the name must be 'test 4', because the purpose if that it fails on
    {
        Name          => 'test 4',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 0,
        Add           => {
            Config => {
                Name        => 'Nagios',
                Description => 'Connector to send and receive date from Nagios 2.',
                Debugger    => {
                    DebugThreshold => 'debug',
                    TestMode       => 1,
                },
                Provider => {
                    Transport => {
                        Type => '',
                    },
                },
                Requester => {
                    Transport => {
                        Type   => 'HTTP::REST',
                        Config => {
                            NameSpace => '',
                            Encoding  => '',
                            Endpoint  => '',
                        },
                    },
                },
            },
            ValidID => 2,
            UserID  => 1,
        },
        Update => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 5 - Invalid Config Add (Undef)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 0,
        Add           => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 6 - Invalid Config Add (String)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 0,
        Add           => {
            Config  => 'Something',
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 7 - Invalid Config Add (Missing DebugThreshold)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 2,
        Add           => {
            Config => {
                Debugger => {},
                Provider => undef,
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 8 - Invalid Config Add (Empty DebugThreshold)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 2,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => '',
                },
                Provider => undef,
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 9 - Invalid Config Add (Undefined Provider)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 2,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => undef,
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 10 - Invalid Config Add (String Provider)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 2,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => 'string',
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 11 - Invalid Config Add (Empty Provider)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 2,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {},
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 12 - Invalid Config Add (Wrong Provider)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 2,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Other => 1,
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 13 - Invalid Config Add (String Provider Transport)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 2,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => 'string',
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 14 - Invalid Config Add (Empty Provider Transport)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 2,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {},
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 15 - Invalid Config Add (Wrong Provider Transport) must success',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Other => 1
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 16 - Invalid Config Update (string Config)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config  => 'string',
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 17 - Invalid Config Update (empty Config)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config  => {},
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 18 - Invalid Config Update (missing Debugger)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => {
                Debugger => undef,
                Provider => {}
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 19 - Invalid Config Update (empty Debugger)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => {
                Debugger => {},
                Provider => {}
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 20 - Invalid Config Update (missing Debugger DebugThreshold)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => {
                Debugger => {
                    TestMode => 1,
                },
                Provider => {}
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 21 - Invalid Config Update (empty Debugger DebugThreshold)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => {
                Debugger => {
                    DebugThreshold => '',
                },
                Provider => {}
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 22 - Invalid Config Update (missing Requester)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Requester => undef,
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 22 - Invalid Config Update (string Requester)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    }
                },
                Requester => 'String',
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 23 - Invalid Config Update (empty Requester)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    }
                },
                Requester => {},
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 24 - Invalid Config Update (missing Requester Transport)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    }
                },
                Requester => {
                    Transport => undef,
                    Other     => 1,
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 25 - Invalid Config Update (string Requester Transport)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    }
                },
                Requester => {
                    Transport => 'string',
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 26 - Invalid Config Update (empty Requester Transport)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    }
                },
                Requester => {
                    Transport => {},
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
    },

    {
        Name          => 'test 27 - Upgrade configuration scheme for Migration from OTRS 5 to OTRS 6',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        HistoryCount  => 2,
        Add           => {
            Config => {
                Description => 'Test for auto-update OTRS 5 -> 6.',
                Debugger    => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    }
                },
                Requester => {
                    Transport => {
                        Type   => 'HTTP::SOAP',
                        Config => {
                            Authentication => {
                                Password => 'basic auth password',
                                Type     => 'BasicAuth',
                                User     => 'basic auth user',
                            },
                            Encoding             => 'UTF-8',
                            Endpoint             => 'http://somehost/someuri',
                            NameSpace            => '',
                            RequestNameFreeText  => '',
                            RequestNameScheme    => 'Request',
                            ResponseNameFreeText => '',
                            ResponseNameScheme   => 'Response',
                            SOAPAction           => 'Yes',
                            SOAPActionSeparator  => '/',
                            SSL                  => {
                                SSLCADir          => '/opt/otrs/scripts/test/sample/SSL/',
                                SSLCAFile         => '/opt/otrs/scripts/test/sample/SSL/ca-certificate.pem',
                                SSLP12Certificate => '/opt/otrs/scripts/test/sample/SSL/certificate.pem',
                                SSLP12Password    => 'certificate password',
                                SSLProxy          => 'https://proxy-host:1234/',
                                SSLProxyPassword  => 'proxy password',
                                SSLProxyUser      => 'proxy user',
                                UseSSL            => 'Yes',
                            },
                        },
                    },
                },
            },
            ValidID        => 1,
            UserID         => 1,
            ExpectedConfig => {
                Description => 'Test for auto-update OTRS 5 -> 6.',
                Debugger    => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    }
                },
                Requester => {
                    Transport => {
                        Type   => 'HTTP::SOAP',
                        Config => {
                            Authentication => {
                                AuthType          => 'BasicAuth',
                                BasicAuthPassword => 'basic auth password',
                                BasicAuthUser     => 'basic auth user',
                            },
                            Encoding  => 'UTF-8',
                            Endpoint  => 'http://somehost/someuri',
                            NameSpace => '',
                            Proxy     => {
                                ProxyExclude  => 'No',
                                ProxyHost     => 'https://proxy-host:1234/',
                                ProxyPassword => 'proxy password',
                                ProxyUser     => 'proxy user',
                                UseProxy      => 'Yes',
                            },
                            RequestNameFreeText  => '',
                            RequestNameScheme    => 'Request',
                            ResponseNameFreeText => '',
                            ResponseNameScheme   => 'Response',
                            SOAPAction           => 'Yes',
                            SOAPActionScheme     => 'NameSpaceSeparatorOperation',
                            SOAPActionSeparator  => '/',
                            SSL                  => {
                                SSLCADir       => '/opt/otrs/scripts/test/sample/SSL/',
                                SSLCAFile      => '/opt/otrs/scripts/test/sample/SSL/ca-certificate.pem',
                                SSLCertificate => '/opt/otrs/scripts/test/sample/SSL/certificate.pem',
                                SSLPassword    => 'certificate password',
                                UseSSL         => 'Yes',
                            },
                            Timeout => 60,
                        },
                    },
                },
            },
        },
        Update => {
            Config => {
                Description => 'Test for auto-update OTRS 5 -> 6.',
                Debugger    => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    }
                },
                Requester => {
                    Transport => {
                        Type   => 'HTTP::REST',
                        Config => {
                            Authentication => {
                                Password => 'basic auth password',
                                Type     => 'BasicAuth',
                                User     => 'basic auth user',
                            },
                            DefaultCommand => 'POST',
                            Host           => 'http://somehost/someuri',
                            X509           => {
                                X509CAFile   => '/opt/otrs/scripts/test/sample/SSL/ca-certificate.pem',
                                X509CertFile => '/opt/otrs/scripts/test/sample/SSL/certificate.pem',
                                X509KeyFile  => '/opt/otrs/scripts/test/sample/SSL/certificate.key.pem',
                                UseX509      => 'Yes',
                            },
                        },
                    },
                },
            },
            ValidID        => 1,
            UserID         => 1,
            ExpectedConfig => {
                Description => 'Test for auto-update OTRS 5 -> 6.',
                Debugger    => {
                    DebugThreshold => 'debug',
                },
                Provider => {
                    Transport => {
                        Type => 'HTTP::Test'
                    }
                },
                Requester => {
                    Transport => {
                        Type   => 'HTTP::REST',
                        Config => {
                            Authentication => {
                                AuthType          => 'BasicAuth',
                                BasicAuthPassword => 'basic auth password',
                                BasicAuthUser     => 'basic auth user',
                            },
                            DefaultCommand => 'POST',
                            Host           => 'http://somehost/someuri',
                            Proxy          => {
                                UseProxy => 'No',
                            },
                            SSL => {
                                SSLCAFile      => '/opt/otrs/scripts/test/sample/SSL/ca-certificate.pem',
                                SSLCertificate => '/opt/otrs/scripts/test/sample/SSL/certificate.pem',
                                SSLKey         => '/opt/otrs/scripts/test/sample/SSL/certificate.key.pem',
                                UseSSL         => 'Yes',
                            },
                            Timeout => 300,
                        },
                    },
                },
            },
        },
    },
);

my @WebserviceIDs;
TEST:
for my $Test (@Tests) {

    # add config
    my $WebserviceID = $WebserviceObject->WebserviceAdd(
        Name => $Test->{Name} . ' ' . $RandomID,
        %{ $Test->{Add} }
    );
    if ( !$Test->{SuccessAdd} ) {
        $Self->False(
            $WebserviceID,
            "$Test->{Name} - WebserviceAdd()",
        );
        next TEST;
    }
    else {
        $Self->True(
            $WebserviceID,
            "$Test->{Name} - WebserviceAdd()",
        );
    }

    # remember id to delete it later
    push @WebserviceIDs, $WebserviceID;

    # get config
    my $Webservice = $WebserviceObject->WebserviceGet(
        ID => $WebserviceID,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $Webservice->{Name},
        "$Test->{Name} - WebserviceGet()",
    );
    $Self->IsDeeply(
        $Webservice->{Config},
        $Test->{Add}->{ExpectedConfig} // $Test->{Add}->{Config},
        "$Test->{Name} - WebserviceGet() - Config",
    );

    my $WebserviceByName = $WebserviceObject->WebserviceGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$WebserviceByName,
        \$Webservice,
        "$Test->{Name} - WebserviceGet() with Name parameter result",
    );

    # get config from cache
    my $WebserviceFromCache = $WebserviceObject->WebserviceGet(
        ID => $WebserviceID,
    );

    # verify config from cache
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $WebserviceFromCache->{Name},
        "$Test->{Name} - WebserviceGet() from cache",
    );
    $Self->IsDeeply(
        $WebserviceFromCache->{Config},
        $Test->{Add}->{ExpectedConfig} // $Test->{Add}->{Config},
        "$Test->{Name} - WebserviceGet() from cache- Config",
    );

    $Self->IsDeeply(
        $Webservice,
        $WebserviceFromCache,
        "$Test->{Name} - WebserviceGet() - Cache and DB",
    );

    my $WebserviceByNameFromCache = $WebserviceObject->WebserviceGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$WebserviceByNameFromCache,
        \$WebserviceFromCache,
        "$Test->{Name} - WebserviceGet() with Name parameter result from cache",
    );

    # update config with a modification
    if ( !$Test->{Update} ) {
        $Test->{Update} = $Test->{Add};
    }
    my $Success = $WebserviceObject->WebserviceUpdate(
        ID   => $WebserviceID,
        Name => $Test->{Name} . ' ' . $RandomID,
        %{ $Test->{Update} }
    );
    if ( !$Test->{SuccessUpdate} ) {
        $Self->False(
            $Success,
            "$Test->{Name} - WebserviceUpdate() False",
        );
        next TEST;
    }
    else {
        $Self->True(
            $Success,
            "$Test->{Name} - WebserviceUpdate() True",
        );
    }

    # get config
    $Webservice = $WebserviceObject->WebserviceGet(
        ID     => $WebserviceID,
        UserID => 1,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $Webservice->{Name},
        "$Test->{Name} - WebserviceGet()",
    );
    $Self->IsDeeply(
        $Webservice->{Config},
        $Test->{Update}->{ExpectedConfig} // $Test->{Update}->{Config},
        "$Test->{Name} - WebserviceGet() - Config",
    );

    $WebserviceByName = $WebserviceObject->WebserviceGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$WebserviceByName,
        \$Webservice,
        "$Test->{Name} - WebserviceGet() with Name parameter result",
    );

    # history check
    my @History = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $WebserviceID,
        UserID       => 1,
    );
    $Self->Is(
        scalar @History,
        $Test->{HistoryCount},
        "$Test->{Name} - WebserviceHistoryList()",
    );

    COUNT:
    for my $Count ( 0 .. 1 ) {
        next COUNT if !$History[$Count];
        my $WebserviceHistoryGet = $WebserviceHistoryObject->WebserviceHistoryGet(
            ID => $History[$Count],
        );
        if ( $Count == 1 ) {
            $Self->IsDeeply(
                $WebserviceHistoryGet->{Config},
                $Test->{Add}->{ExpectedConfig} // $Test->{Add}->{Config},
                "$Test->{Name} - WebserviceHistoryGet() - Config",
            );
        }
        else {
            $Self->IsDeeply(
                $WebserviceHistoryGet->{Config},
                $Test->{Update}->{ExpectedConfig} // $Test->{Update}->{Config},
                "$Test->{Name} - WebserviceHistoryGet() - Config",
            );
        }
    }

    # verify if cache was also updated
    if ( $Test->{SuccessUpdate} ) {
        my $WebserviceUpdateFromCache = $WebserviceObject->WebserviceGet(
            ID     => $WebserviceID,
            UserID => 1,
        );

        # verify config from cache
        $Self->Is(
            $Test->{Name} . ' ' . $RandomID,
            $WebserviceUpdateFromCache->{Name},
            "$Test->{Name} - WebserviceGet() from cache",
        );
        $Self->IsDeeply(
            $WebserviceUpdateFromCache->{Config},
            $Test->{Update}->{ExpectedConfig} // $Test->{Update}->{Config},
            "$Test->{Name} - WebserviceGet() from cache- Config",
        );
    }
}

# list check from DB
my $WebserviceList = $WebserviceObject->WebserviceList( Valid => 0 );
for my $WebserviceID (@WebserviceIDs) {
    $Self->True(
        scalar $WebserviceList->{$WebserviceID},
        "WebserviceList() from DB found web service $WebserviceID",
    );

    my @WebserviceHistoryList = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $WebserviceID,
    );

    $Self->True(
        scalar @WebserviceHistoryList > 0,
        "WebserviceHistoryList() found entries for web service $WebserviceID",
    );
}

# list check from cache
$WebserviceList = $WebserviceObject->WebserviceList( Valid => 0 );
for my $WebserviceID (@WebserviceIDs) {
    $Self->True(
        scalar $WebserviceList->{$WebserviceID},
        "WebserviceList() from Cache found web service $WebserviceID",
    );
}

# delete config
for my $WebserviceID (@WebserviceIDs) {
    my $Success = $WebserviceObject->WebserviceDelete(
        ID     => $WebserviceID,
        UserID => 1,
    );
    $Self->True(
        $Success,
        "WebserviceDelete() deleted web service $WebserviceID",
    );
    $Success = $WebserviceObject->WebserviceDelete(
        ID     => $WebserviceID,
        UserID => 1,
    );
    $Self->False(
        $Success,
        "WebserviceDelete() deleted web service $WebserviceID",
    );
}

# list check from DB
$WebserviceList = $WebserviceObject->WebserviceList( Valid => 0 );
for my $WebserviceID (@WebserviceIDs) {
    $Self->False(
        scalar $WebserviceList->{$WebserviceID},
        "WebserviceList() did not find web service $WebserviceID",
    );

    my @WebserviceHistoryList = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $WebserviceID,
    );

    $Self->False(
        scalar @WebserviceHistoryList,
        "WebserviceHistoryList() from DB found entries for web service $WebserviceID",
    );
    my @History = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $WebserviceID,
        UserID       => 1,
    );
    $Self->False(
        scalar @History,
        'WebserviceHistoryList()',
    );
}

# list check from cache
$WebserviceList = $WebserviceObject->WebserviceList( Valid => 0 );
for my $WebserviceID (@WebserviceIDs) {
    $Self->False(
        scalar $WebserviceList->{$WebserviceID},
        "WebserviceList() from cache did not find web service $WebserviceID",
    );
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

1;
