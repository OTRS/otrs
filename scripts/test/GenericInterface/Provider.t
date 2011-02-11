# --
# Provider.t - Provider tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Provider.t,v 1.3 2011-02-11 12:28:00 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use CGI;

use Kernel::System::GenericInterface::Webservice;
use Kernel::GenericInterface::Provider;
use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
my $ProviderObject   = Kernel::GenericInterface::Provider->new( %{$Self} );

my $RandomID = $HelperObject->GetRandomID();

my @Tests = (
    {
        Name             => 'HTTP request',
        WebserviceConfig => {
            Debugger => {
                DebugLevel => 'debug',
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Operation => {
                    test_operation => {
                        Type           => 'Test::PerformTest',
                        MappingInbound => {
                            Type   => 'Test',
                            Config => {
                                TestOption => 'ToUpper',
                                }
                        },
                        MappingOutbound => {
                            Type => 'Test',
                        },
                    },
                },
            },
        },
        RequestData     => 'A=A&b=b',
        ResponseData    => 'A=A&b=B',
        ResponseSuccess => 1,
    },
    {
        Name             => 'HTTP request',
        WebserviceConfig => {
            Debugger => {
                DebugLevel => 'debug',
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Operation => {
                    test_operation => {
                        Type           => 'Test::PerformTest',
                        MappingInbound => {
                            Type => 'Test',
                        },
                        MappingOutbound => {
                            Type => 'Test',
                        },
                    },
                },
            },
        },
        RequestData     => '',
        ResponseData    => '',
        ResponseSuccess => 0,
    },
);

for my $Test (@Tests) {

    # add config
    my $WebServiceID = $WebserviceObject->WebserviceAdd(
        Config  => $Test->{WebserviceConfig},
        Name    => "$Test->{Name} $RandomID",
        ValidID => 1,
        UserID  => 1,
    );

    $Self->True(
        $WebServiceID,
        "$Test->{Name} WebserviceAdd()",
    );

    for my $RequestMethod (qw(GET POST)) {

        my $RequestData;
        my $ResponseData;
        {

            local %ENV;

            if ( $RequestMethod eq 'POST' ) {

                # prepare CGI environment variables
                $ENV{REQUEST_URI}
                    = "http://localhost/otrs/nph-genericinterface.pl/WebserviceID/$WebServiceID";
                $ENV{REQUEST_METHOD} = 'POST';
                $RequestData = $Test->{RequestData};
            }
            else {    # GET

                # prepare CGI environment variables
                $ENV{REQUEST_URI}
                    = "http://localhost/otrs/nph-genericinterface.pl/WebserviceID/$WebServiceID?$Test->{RequestData}";
                $ENV{QUERY_STRING}   = $Test->{RequestData};
                $ENV{REQUEST_METHOD} = 'GET';

            }

            $ENV{CONTENT_LENGTH} = length( $Test->{RequestData} );
            $ENV{CONTENT_TYPE}   = 'application/x-www-form-urlencoded; charset=utf-8;';

            # redirect STDIN from String so that the transport layer will use this data
            local *STDIN;
            open STDIN, '<:utf8', \$RequestData;

            # redirect STDOUT from String so that the transport layer will write there
            local *STDOUT;
            open STDOUT, '>:utf8', \$ResponseData;

            # reset CGI object from previous runs
            CGI::initialize_globals();

            $ProviderObject->Run();
        }

        if ( $Test->{ResponseSuccess} ) {
            $Self->True(
                index( $ResponseData, $Test->{ResponseData} ) > -1,
                "$Test->{Name} Provider Run() HTTP $RequestMethod result data",
            );

            $Self->True(
                index( $ResponseData, 'HTTP/1.0 200 OK' ) > -1,
                "$Test->{Name} Provider Run() HTTP $RequestMethod result success status",
            );
        }
        else {
            $Self->True(
                index( $ResponseData, 'HTTP/1.0 500 ' ) > -1,
                "$Test->{Name} Provider Run() HTTP $RequestMethod result error status",
            );

        }
    }

    # delete config
    my $Success = $WebserviceObject->WebserviceDelete(
        ID     => $WebServiceID,
        UserID => 1,
    );

    $Self->True(
        $Success,
        "$Test->{Name} WebserviceDelete()",
    );

}

1;
