# --
# Provider.t - Provider tests
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
use LWP::UserAgent;

use Kernel::System::GenericInterface::Webservice;
use Kernel::GenericInterface::Provider;
use Kernel::System::UnitTest::Helper;

# helper object
# skip SSL certiciate verification
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject => $Self,
    SkipSSLVerify  => 1,
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
                        Type           => 'Test::Test',
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
                        Type           => 'Test::Test',
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
                        Type           => 'Test::Test',
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
                        Type           => 'Test::Test',
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
    {
        Name             => 'Webservice without debugger config',
        WebserviceConfig => {
            Provider => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Operation => {
                    test_operation => {
                        Type           => 'Test::Test',
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
        ResponseSuccess => 0,
        EarlyError      => 1,
    },
);

my $CreateQueryString = sub {
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
};

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

# create url
my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');
my $BaseURL     = "http://$Host/${ScriptAlias}/nph-genericinterface.pl/";

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

    my $WebserviceNameEncoded = URI::Escape::uri_escape_utf8("$Test->{Name} $RandomID");

    #
    # Test with IO redirection, no real HTTP request
    #
    for my $RequestMethod (qw(get post)) {

        for my $WebserviceAccess (
            "WebserviceID/$WebserviceID",
            "Webservice/$WebserviceNameEncoded"
            )
        {

            my $RequestData  = '';
            my $ResponseData = '';

            {
                local %ENV;

                if ( $RequestMethod eq 'post' ) {

                    # prepare CGI environment variables
                    $ENV{REQUEST_URI}
                        = "http://localhost/otrs/nph-genericinterface.pl/$WebserviceAccess";
                    $ENV{REQUEST_METHOD} = 'POST';
                    $RequestData = $CreateQueryString->(
                        $Self,
                        Data   => $Test->{RequestData},
                        Encode => 0,
                    );
                    use bytes;
                    $ENV{CONTENT_LENGTH} = length($RequestData);
                }
                else {    # GET

                    # prepare CGI environment variables
                    $ENV{REQUEST_URI}
                        = "http://localhost/otrs/nph-genericinterface.pl/$WebserviceAccess?"
                        . $CreateQueryString->(
                        $Self,
                        Data   => $Test->{RequestData},
                        Encode => 1,
                        );
                    $ENV{QUERY_STRING} = $CreateQueryString->(
                        $Self,
                        Data   => $Test->{RequestData},
                        Encode => 1,
                    );
                    $ENV{REQUEST_METHOD} = 'GET';
                }

                $ENV{CONTENT_TYPE} = 'application/x-www-form-urlencoded; charset=utf-8;';

                # redirect STDIN from String so that the transport layer will use this data
                local *STDIN;
                open STDIN, '<:utf8', \$RequestData;    ## no critic

                # redirect STDOUT from String so that the transport layer will write there
                local *STDOUT;
                open STDOUT, '>:utf8', \$ResponseData;    ## no critic

                # reset CGI object from previous runs
                CGI::initialize_globals();

                $ProviderObject->Run();
            }

            if ( $Test->{ResponseSuccess} ) {

                for my $Key ( sort keys %{ $Test->{ResponseData} || {} } ) {
                    my $QueryStringPart = URI::Escape::uri_escape_utf8($Key);
                    if ( $Test->{ResponseData}->{$Key} ) {
                        $QueryStringPart
                            .= '=' . URI::Escape::uri_escape_utf8( $Test->{ResponseData}->{$Key} );
                    }

                    $Self->True(
                        index( $ResponseData, $QueryStringPart ) > -1,
                        "$Test->{Name} $WebserviceAccess Run() HTTP $RequestMethod result data contains $QueryStringPart",
                    );
                }

                $Self->True(
                    index( $ResponseData, 'HTTP/1.0 200 OK' ) > -1,
                    "$Test->{Name} $WebserviceAccess Run() HTTP $RequestMethod result success status",
                );
            }
            else {

               # If an early error occurred, GI cannot generate a valid HTTP error response yet,
               #   because the transport object was not yet initialized. In these cases, apache will
               #   generate this response, but here we do not use apache.
                if ( !$Test->{EarlyError} ) {
                    $Self->True(
                        index( $ResponseData, 'HTTP/1.0 500 ' ) > -1,
                        "$Test->{Name} $WebserviceAccess Run() HTTP $RequestMethod result error status",
                    );
                }
            }
        }
    }

    #
    # Test real HTTP request
    #
    for my $RequestMethod (qw(get post)) {

        for my $WebserviceAccess (
            "WebserviceID/$WebserviceID",
            "Webservice/$WebserviceNameEncoded"
            )
        {

            my $URL = $BaseURL . $WebserviceAccess;
            my $Response;
            my $ResponseData;
            my $QueryString = $CreateQueryString->(
                $Self,
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
            chomp( $ResponseData = $Response->decoded_content() );

            if ( $Test->{ResponseSuccess} ) {
                for my $Key ( sort keys %{ $Test->{ResponseData} || {} } ) {
                    my $QueryStringPart = URI::Escape::uri_escape_utf8($Key);
                    if ( $Test->{ResponseData}->{$Key} ) {
                        $QueryStringPart
                            .= '=' . URI::Escape::uri_escape_utf8( $Test->{ResponseData}->{$Key} );
                    }

                    $Self->True(
                        index( $ResponseData, $QueryStringPart ) > -1,
                        "$Test->{Name} $WebserviceAccess real HTTP $RequestMethod request (needs configured and running webserver) result data contains $QueryStringPart",
                    );
                }

                $Self->Is(
                    $Response->code(),
                    200,
                    "$Test->{Name} $WebserviceAccess real HTTP $RequestMethod request (needs configured and running webserver) result success status",
                );
            }
            else {
                $Self->Is(
                    $Response->code(),
                    500,
                    "$Test->{Name} $WebserviceAccess real HTTP $RequestMethod request (needs configured and running webserver) result error status"
                    ,
                );
            }
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

    my $URL = $BaseURL . 'undefined';
    my $ResponseData;

    my $Response = LWP::UserAgent->new()->$RequestMethod($URL);
    chomp( $ResponseData = $Response->decoded_content() );

    $Self->Is(
        $Response->code(),
        500,
        "Nonexisting Webservice real HTTP $RequestMethod request result error status",
    );
}

1;
