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
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper           = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create web service object",
);

# delete existing web services to prevent side effects
my $WebserviceList = $WebserviceObject->WebserviceList(
    Valid => 0,
);
for my $WebserviceID ( sort keys %{$WebserviceList} ) {
    my $Success = $WebserviceObject->WebserviceDelete(
        ID     => $WebserviceID,
        UserID => 1,
    );
    $Self->True(
        $Success,
        "Remove web service '$WebserviceList->{$WebserviceID}'",
    );
}

my $Home  = $ConfigObject->Get('Home');
my @Tests = (

    {
        Name   => 'MigrateWebServiceConfiguration-' . $Helper->GetRandomID(),
        Config => {
            Description => 'Test for auto-update OTRS 5 -> 6.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
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
                        Endpoint             => 'http://localhost/otrs/nph-genericinterface.pl/Webservice/Test',
                        NameSpace            => '',
                        RequestNameFreeText  => '',
                        RequestNameScheme    => 'Request',
                        ResponseNameFreeText => '',
                        ResponseNameScheme   => 'Response',
                        SOAPAction           => 'Yes',
                        SOAPActionSeparator  => '/',
                        SSL                  => {
                            SSLCADir          => $Home . '/scripts/test/sample/SSL/',
                            SSLCAFile         => $Home . '/scripts/test/sample/SSL/ca-certificate.pem',
                            SSLP12Certificate => $Home . '/scripts/test/sample/SSL/certificate.pem',
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
        ExpectedTransportConfig => {
            Authentication => {
                AuthType          => 'BasicAuth',
                BasicAuthPassword => 'basic auth password',
                BasicAuthUser     => 'basic auth user',
            },
            Encoding  => 'UTF-8',
            Endpoint  => 'http://localhost/otrs/nph-genericinterface.pl/Webservice/Test',
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
                SSLCADir       => $Home . '/scripts/test/sample/SSL/',
                SSLCAFile      => $Home . '/scripts/test/sample/SSL/ca-certificate.pem',
                SSLCertificate => $Home . '/scripts/test/sample/SSL/certificate.pem',
                SSLPassword    => 'certificate password',
                UseSSL         => 'Yes',
            },
            Timeout => 60,
        },
    },

    {
        Name   => 'MigrateWebServiceConfiguration-' . $Helper->GetRandomID(),
        Config => {
            Description => 'Test for auto-update OTRS 5 -> 6.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
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
                        DefaultCommand           => 'POST',
                        Host                     => 'http://localhost/otrs/nph-genericinterface.pl/Webservice/Test',
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                        X509 => {
                            X509CAFile   => $Home . '/scripts/test/sample/SSL/ca-certificate.pem',
                            X509CertFile => $Home . '/scripts/test/sample/SSL/certificate.pem',
                            X509KeyFile  => $Home . '/scripts/test/sample/SSL/certificate.key.pem',
                            UseX509      => 'Yes',
                        },
                    },
                },
            },
        },
        ExpectedTransportConfig => {
            Authentication => {
                AuthType          => 'BasicAuth',
                BasicAuthPassword => 'basic auth password',
                BasicAuthUser     => 'basic auth user',
            },
            DefaultCommand           => 'POST',
            Host                     => 'http://localhost/otrs/nph-genericinterface.pl/Webservice/Test',
            InvokerControllerMapping => {
                TestSimple => {
                    Controller => '/Test',
                },
            },
            Proxy => {
                UseProxy => 'No',
            },
            SSL => {
                SSLCAFile      => $Home . '/scripts/test/sample/SSL/ca-certificate.pem',
                SSLCertificate => $Home . '/scripts/test/sample/SSL/certificate.pem',
                SSLKey         => $Home . '/scripts/test/sample/SSL/certificate.key.pem',
                UseSSL         => 'Yes',
            },
            Timeout => 300,
        },
    },

);

for my $Test (@Tests) {

    my $WebserviceID = $WebserviceObject->WebserviceAdd(
        Name    => $Test->{Name},
        Config  => $Test->{Config},
        ValidID => 1,
        UserID  => 1,
    );
    $Self->True(
        $WebserviceID,
        "$Test->{Name} - Added web service",
    );
}

my $UpgradeSuccess = $Kernel::OM->Create('scripts::DBUpdateTo6::MigrateWebServiceConfiguration')->Run();
$Self->Is(
    1,
    $UpgradeSuccess,
    'Upgrade web services to latest version.',
);

for my $Test (@Tests) {

    my $Webservice = $WebserviceObject->WebserviceGet(
        Name => $Test->{Name},
    );
    $Self->True(
        $Webservice,
        "$Test->{Name} - Get updated web service",
    );
    print STDERR $Kernel::OM->Get('Kernel::System::Main')
        ->Dump( $Webservice->{Config}->{Requester}->{Transport}->{Config} );
    print STDERR $Kernel::OM->Get('Kernel::System::Main')->Dump( $Test->{ExpectedTransportConfig} );

    $Self->IsDeeply(
        $Webservice->{Config}->{Requester}->{Transport}->{Config},
        $Test->{ExpectedTransportConfig},
        "$Test->{Name} - Parameter migration successful",
    );

}

# cleanup is done by RestoreDatabase

1;
