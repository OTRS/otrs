# --
# Admin/WebService/Add.t - command tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $RandomName = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomID();

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# test cases
my @Tests = (
    {
        Name     => 'No Options',
        Options  => [],
        ExitCode => 1,
    },
    {
        Name     => 'Missing name value',
        Options  => ['--name'],
        ExitCode => 1,
    },
    {
        Name     => 'Missing source-path',
        Options  => [ '--name', $RandomName ],
        ExitCode => 1,
    },
    {
        Name     => 'Missing source-path value',
        Options  => [ '--name', $RandomName, '--source-path' ],
        ExitCode => 1,
    },

    {
        Name     => 'Non existing source-path',
        Options  => [ '--name', $RandomName, '--source-path', $RandomName ],
        ExitCode => 1,
    },
    {
        Name    => 'Non YAML source-path',
        Options => [
            '--name', $RandomName, '--source-path',
            "$Home/scripts/test/Console/Command/Admin/WebService/GenericTicketConnectorSOAP.wsdl"
        ],
        ExitCode => 1,
    },
    {
        Name    => 'Non web service YAML source-path',
        Options => [
            '--name', $RandomName, '--source-path',
            "$Home/scripts/test/Console/Command/Admin/WebService/BookOrdering.yml"
        ],
        ExitCode => 1,
    },
    {
        Name    => 'Correct YAML source-path',
        Options => [
            '--name', $RandomName, '--source-path',
            "$Home/scripts/test/Console/Command/Admin/WebService/GenericTicketConnectorSOAP.yml"
        ],
        ExitCode => 0,
    },
    {
        Name    => 'Duplicate name',
        Options => [
            '--name', $RandomName, '--source-path',
            "$Home/scripts/test/Console/Command/Admin/WebService/GenericTicketConnectorSOAP.yml"
        ],
        ExitCode => 1,
    },
);

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::WebService::Add');

for my $Test (@Tests) {

    my $ExitCode = $CommandObject->Execute( @{ $Test->{Options} } );

    $Self->Is(
        $ExitCode,
        $Test->{ExitCode},
        "$Test->{Name}",
    );
}

# get web service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

my $WebService = $WebserviceObject->WebserviceGet(
    Name => $RandomName,
);

if ($WebService) {
    my $Success = $WebserviceObject->WebserviceDelete(
        ID     => $WebService->{ID},
        UserID => 1,
    );

    $Self->True(
        $Success,
        "WebserviceDelete() for web service: $RandomName with true",
    );
}

1;
