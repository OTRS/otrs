# --
# Provider.t - Provider tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Provider.t,v 1.1 2011-02-15 16:40:47 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use CGI ();
use URI::Escape();

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
                DebugThreshold => 'debug',
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
        RequestData => {
            A => 'A',
            b => 'b',
        },
        ResponseData => {
            A => 'A',
            b => 'B',
        },
        ResponseSuccess => 1,
    },
    {
        Name             => 'HTTP request umlaut',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
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
                    },
                },
            },
        },
        RequestData => {
            A => 'A',
            b => 'ö',
        },
        ResponseData => {
            A => 'A',
            b => 'ö',
        },
        ResponseSuccess => 1,
    },
    {
        Name             => 'HTTP request unicode',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
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
                    },
                },
            },
        },
        RequestData => {
            A => 'A',
            b => '使用下列语言',
            c => 'Языковые',
            d => 'd',
        },
        ResponseData => {
            A => 'A',
            b => '使用下列语言',
            c => 'Языковые',
            d => 'd',
        },
        ResponseSuccess => 1,
    },
    {
        Name             => 'HTTP request without data',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
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
        RequestData     => {},
        ResponseData    => {},
        ResponseSuccess => 0,
    },
);

sub _CreateQueryString {
    my ( $Self, %Param ) = @_;

    my $QueryString;

    for my $Key ( sort keys %{ $Param{Data} || {} } ) {
        $QueryString .= '&' if ($QueryString);
        $QueryString .= $Param{Encode} ? URI::Escape::uri_escape_utf8($Key) : $Key;
        if ( $Param{Data}->{$Key} ) {
            $QueryString
                .= "="
                . (
                $Param{Encode}
                ? URI::Escape::uri_escape_utf8( $Param{Data}->{$Key} )
                : $Param{Data}->{$Key}
                );
        }
    }

    return $QueryString;
}

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
    # Test with IO redirection, no real HTTP request
    #
    for my $RequestMethod (qw(get post)) {

        my $RequestData  = '';
        my $ResponseData = '';

        {
            local %ENV;

            if ( $RequestMethod eq 'post' ) {

                # prepare CGI environment variables
                $ENV{REQUEST_URI}
                    = "http://localhost/otrs/nph-genericinterface.pl/WebserviceID/$WebserviceID";
                $ENV{REQUEST_METHOD} = 'POST';
                $RequestData = $Self->_CreateQueryString(
                    Data   => $Test->{RequestData},
                    Encode => 0,
                );
                use bytes;
                $ENV{CONTENT_LENGTH} = length($RequestData);
            }
            else {    # GET

                # prepare CGI environment variables
                $ENV{REQUEST_URI}
                    = "http://localhost/otrs/nph-genericinterface.pl/WebserviceID/$WebserviceID?$Test->{RequestData}";
                $ENV{QUERY_STRING} = $Self->_CreateQueryString(
                    Data   => $Test->{RequestData},
                    Encode => 1,
                );
                $ENV{REQUEST_METHOD} = 'GET';
            }

            $ENV{CONTENT_TYPE} = 'application/x-www-form-urlencoded; charset=utf-8;';

            use Devel::Peek;
            Devel::Peek::Dump($RequestData);

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

        #use Devel::Peek;
        #Devel::Peek::Dump($ResponseData);
        #Devel::Peek::Dump($Test->{ResponseData});

        if ( $Test->{ResponseSuccess} ) {

            for my $Key ( sort keys %{ $Test->{ResponseData} || {} } ) {
                my $QueryStringPart = URI::Escape::uri_escape_utf8($Key);
                if ( $Test->{ResponseData}->{$Key} ) {
                    $QueryStringPart
                        .= '=' . URI::Escape::uri_escape_utf8( $Test->{ResponseData}->{$Key} );
                }

                $Self->True(
                    index( $ResponseData, $QueryStringPart ) > -1,
                    "$Test->{Name} Run() HTTP $RequestMethod result data contains $QueryStringPart",
                );
            }

            $Self->True(
                index( $ResponseData, 'HTTP/1.0 200 OK' ) > -1,
                "$Test->{Name} Run() HTTP $RequestMethod result success status",
            );
        }
        else {
            $Self->True(
                index( $ResponseData, 'HTTP/1.0 500 ' ) > -1,
                "$Test->{Name} Run() HTTP $RequestMethod result error status",
            );
        }
    }

    #
    # Test real HTTP request
    #
    for my $RequestMethod (qw(get post)) {

        my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

        my $URL
            = "http://localhost/${ScriptAlias}nph-genericinterface.pl/WebserviceID/$WebserviceID";
        my $Response;
        my $ResponseData;
        my $QueryString = $Self->_CreateQueryString(
            Data   => $Test->{RequestData},
            Encode => 1,
        );

        if ( $RequestMethod eq 'get' ) {
            $URL .= "?$QueryString";
            $Response = LWP::UserAgent->new()->$RequestMethod($URL);
        }
        else {    # POST
            $Response = LWP::UserAgent->new()->$RequestMethod( $URL, Content => $QueryString );
        }
        chomp( $ResponseData = $Response->decoded_content );

        if ( $Test->{ResponseSuccess} ) {
            for my $Key ( sort keys %{ $Test->{ResponseData} || {} } ) {
                my $QueryStringPart = URI::Escape::uri_escape_utf8($Key);
                if ( $Test->{ResponseData}->{$Key} ) {
                    $QueryStringPart
                        .= '=' . URI::Escape::uri_escape_utf8( $Test->{ResponseData}->{$Key} );
                }

                $Self->True(
                    index( $ResponseData, $QueryStringPart ) > -1,
                    "$Test->{Name} Run() HTTP $RequestMethod result data contains $QueryStringPart",
                );
            }

            $Self->Is(
                $Response->code,
                200,
                "$Test->{Name} real HTTP $RequestMethod request result success status",
            );
        }
        else {
            $Self->Is(
                $Response->code,
                500,
                "$Test->{Name} real HTTP $RequestMethod request result error status",
            );
        }
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
for my $RequestMethod (qw(get post)) {

    my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

    my $URL = "http://localhost/${ScriptAlias}nph-genericinterface.pl/WebserviceID/undefined";
    my $ResponseData;

    my $Response = LWP::UserAgent->new()->$RequestMethod($URL);
    chomp( $ResponseData = $Response->decoded_content );

    $Self->Is(
        $Response->code,
        500,
        "Nonexisting Webservice real HTTP $RequestMethod request result error status",
    );
}

1;
