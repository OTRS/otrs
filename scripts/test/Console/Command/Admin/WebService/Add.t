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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $WebService = 'webservice' . $Helper->GetRandomID();

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
        Options  => [ '--name', $WebService ],
        ExitCode => 1,
    },
    {
        Name     => 'Missing source-path value',
        Options  => [ '--name', $WebService, '--source-path' ],
        ExitCode => 1,
    },

    {
        Name     => 'Non existing source-path',
        Options  => [ '--name', $WebService, '--source-path', $WebService ],
        ExitCode => 1,
    },
    {
        Name    => 'Non YAML source-path',
        Options => [
            '--name', $WebService, '--source-path',
            "$Home/scripts/test/Console/Command/Admin/WebService/GenericTicketConnectorSOAP.wsdl"
        ],
        ExitCode => 1,
    },
    {
        Name    => 'Non web service YAML source-path',
        Options => [
            '--name', $WebService, '--source-path',
            "$Home/scripts/test/Console/Command/Admin/WebService/BookOrdering.yml"
        ],
        ExitCode => 1,
    },
    {
        Name    => 'Correct YAML source-path',
        Options => [
            '--name', $WebService, '--source-path',
            "$Home/scripts/test/Console/Command/Admin/WebService/GenericTicketConnectorSOAP.yml"
        ],
        ExitCode => 0,
    },
    {
        Name    => 'Duplicate name',
        Options => [
            '--name', $WebService, '--source-path',
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

# cleanup is done by RestoreDatabase

1;
