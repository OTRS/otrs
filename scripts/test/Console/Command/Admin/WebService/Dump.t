# --
# Admin/WebService/Dump.t - command tests
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

# get web service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

# create a base web service
my $WebServiceID = $WebserviceObject->WebserviceAdd(
    Name   => $RandomName,
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

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $TargetPath = "$Home/var/tmp/$RandomName.yaml";

# test cases
my @Tests = (
    {
        Name     => 'No Options',
        Options  => [],
        ExitCode => 1,
    },
    {
        Name     => 'Missing webservice-id value',
        Options  => ['--webservice-id'],
        ExitCode => 1,
    },
    {
        Name     => 'Missing target-path',
        Options  => [ '--webservice-id', $WebServiceID ],
        ExitCode => 1,
    },
    {
        Name     => 'Missing target-path value',
        Options  => [ '--webservice-id', $WebServiceID, '--target-path' ],
        ExitCode => 1,
    },
    {
        Name     => 'Wrong webservice-id',
        Options  => [ '--webservice-id', $RandomName, '--target-path', $TargetPath ],
        ExitCode => 1,
    },
    {
        Name     => 'Correct Dump',
        Options  => [ '--webservice-id', $WebServiceID, '--target-path', $TargetPath ],
        ExitCode => 0,
    },
);

# get needed objects
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::WebService::Dump');
my $MainObject    = $Kernel::OM->Get('Kernel::System::Main');
my $YAMLObject    = $Kernel::OM->Get('Kernel::System::YAML');

for my $Test (@Tests) {

    my $ExitCode = $CommandObject->Execute( @{ $Test->{Options} } );

    $Self->Is(
        $ExitCode,
        $Test->{ExitCode},
        "$Test->{Name}",
    );

    if ( !$Test->{ExitCode} ) {

        my $WebService = $WebserviceObject->WebserviceGet(
            Name => $RandomName,
        );

        my $ContentSCALARRef = $MainObject->FileRead(
            Location => $TargetPath,
            Mode     => 'utf8',
            Type     => 'Local',
            Result   => 'SCALAR',
        );

        my $Config = $YAMLObject->Load(
            Data => ${$ContentSCALARRef},
        );

        $Self->IsDeeply(
            $WebService->{Config},
            $Config,
            "$Test->{Name} - web service config"
        );
    }
}

if ($WebServiceID) {
    my $Success = $WebserviceObject->WebserviceDelete(
        ID     => $WebServiceID,
        UserID => 1,
    );

    $Self->True(
        $Success,
        "WebserviceDelete() for web service: $RandomName with true",
    );

    if ( -e $TargetPath ) {

        my $Success = unlink $TargetPath;

        $Self->True(
            $Success,
            "Deleted temporary file $TargetPath with true",
        );
    }
}
1;
