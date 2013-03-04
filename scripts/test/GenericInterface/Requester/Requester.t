# --
# Requester.t - Requester tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use CGI ();
use URI::Escape();

use Kernel::System::GenericInterface::Webservice;
use Kernel::GenericInterface::Requester;
use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
my $RequesterObject  = Kernel::GenericInterface::Requester->new( %{$Self} );

my $RandomID = $HelperObject->GetRandomID();

my @Tests = (
    {
        Name             => 'Simple HTTP request',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Invoker => {
                    test_operation => {
                        Type           => 'Test::TestSimple',
                        MappingInbound => {
                            Type   => 'Test',
                            Config => {
                                TestOption => 'ToUpper',
                            },
                        },
                        MappingOutbound => {
                            Type => 'Test',
                        },
                    },
                },
            },
        },
        InputData => {
            TicketID => 123,
        },
        ReturnData => {
            TICKETID => 123,
        },
        ResponseSuccess => 1,
    },
    {
        Name             => 'Simple HTTP request with umlaut',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Invoker => {
                    test_operation => {
                        Type           => 'Test::TestSimple',
                        MappingInbound => {
                            Type   => 'Test',
                            Config => {
                                TestOption => 'ToUpper',
                            },
                        },
                        MappingOutbound => {
                            Type => 'Test',
                        },
                    },
                },
            },
        },
        InputData => {
            TicketID => 123,
            b        => 'ö',
        },
        ReturnData => {
            TICKETID => 123,
            B        => 'Ö',
        },
        ResponseSuccess => 1,
    },
    {
        Name             => 'Simple HTTP request with unicode',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Invoker => {
                    test_operation => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
        InputData => {
            TicketID => 123,
            b        => '使用下列语言',
            c        => 'Языковые',
        },
        ReturnData => {
            TicketID => 123,
            b        => '使用下列语言',
            c        => 'Языковые',
        },
        ResponseSuccess => 1,
    },
    {
        Name             => 'Failing HTTP request',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 1,
                    },
                },
                Invoker => {
                    test_operation => {
                        Type           => 'Test::TestSimple',
                        MappingInbound => {
                            Type   => 'Test',
                            Config => {
                                TestOption => 'ToUpper',
                            },
                        },
                        MappingOutbound => {
                            Type => 'Test',
                        },
                    },
                },
            },
        },
        InputData => {
            TicketID => 123,
        },
        ReturnData      => {},
        ResponseSuccess => 0,
    },
);

for my $Test (@Tests) {

    # add config
    my $WebserviceID = $WebserviceObject->WebserviceAdd(
        Config  => $Test->{WebserviceConfig},
        Name    => "$Test->{Name} $RandomID",
        ValidID => 1,
        UserID  => 1,
    );

    $Self->True(
        $WebserviceID,
        "$Test->{Name} WebserviceAdd()",
    );

    #
    # Run actual test
    #
    my $FunctionResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => 'test_operation',
        Data         => $Test->{InputData},
    );

    if ( $Test->{ResponseSuccess} ) {

        $Self->True(
            $FunctionResult->{Success},
            "$Test->{Name} success status",
        );

        my $ResponseData;
        if ( ref $FunctionResult->{Data} eq 'HASH' ) {
            $ResponseData = $FunctionResult->{Data}->{ResponseData};
        }

        for my $Key ( sort keys %{ $Test->{ResponseData} || {} } ) {
            my $QueryStringPart = URI::Escape::uri_escape_utf8($Key);
            if ( $Test->{ResponseData}->{$Key} ) {
                $QueryStringPart
                    .= '=' . URI::Escape::uri_escape_utf8( $Test->{ResponseData}->{$Key} );
            }

            $Self->True(
                index( $ResponseData, $QueryStringPart ) > -1,
                "$Test->{Name} result data contains $QueryStringPart",
            );
        }
    }
    else {
        $Self->False(
            $FunctionResult->{Success},
            "$Test->{Name} error status",
        );
    }

    # delete config
    my $Success = $WebserviceObject->WebserviceDelete(
        ID     => $WebserviceID,
        UserID => 1,
    );

    $Self->True(
        $Success,
        "$Test->{Name} WebserviceDelete()",
    );
}

#
# Test nonexisting webservice
#
my $FunctionResult = $RequesterObject->Run(
    WebserviceID => -1,
    Invoker      => 'test_operation',
    Data         => {
        1 => 1
    },
);

$Self->False(
    $FunctionResult->{Success},
    "Nonexisting web service error status",
);

1;
