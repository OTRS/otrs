# --
# Provider.t - Provider tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Provider.t,v 1.1 2011-02-11 10:34:07 mg Exp $
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

my $WebserviceConfig = {
    Provider => {
        Transport => {
            Module => 'Kernel::GenericInterface::Transport::HTTP::Test',
            Config => {
                Fail => 0,
            },
        },
        Operation => {
            Test => {
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
};

# add config
my $WebServiceID = $WebserviceObject->WebserviceAdd(
    Config  => $WebserviceConfig,
    Name    => "Test $RandomID",
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $WebServiceID,
    "WebserviceAdd() successful",
);

my $Request = "A=A&b=b";
my $ResultData;

{

    # prepare CGI environment variables
    local $ENV{REQUEST_URI}
        = "http://localhost/otrs/genericinterface.pl/WebserviceID/$WebServiceID";
    local $ENV{REQUEST_METHOD} = 'POST';
    local $ENV{CONTENT_LENGTH} = length($Request);
    local $ENV{CONTENT_TYPE}   = 'application/x-www-form-urlencoded; charset=utf-8;';

    # redirect STDIN from String so that the transport layer will use this data
    local *STDIN;
    open STDIN, '<:utf8', \$Request;

    # redirect STDOUT from String so that the transport layer will write there
    local *STDOUT;
    open STDOUT, '>:utf8', \$ResultData;

    # reset CGI object from previous runs
    CGI::initialize_globals();

    $ProviderObject->Run();
}

$Self->True(
    scalar $ResultData =~ m/A=A&b=B/smx,
    'Provider Run() result',
);

# delete config
my $Success = $WebserviceObject->WebserviceDelete(
    ID     => $WebServiceID,
    UserID => 1,
);

$Self->True(
    $Success,
    'WebserviceDelete()',
);

1;
