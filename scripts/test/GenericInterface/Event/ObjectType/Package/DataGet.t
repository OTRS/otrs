# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
my $FileString = $MainObject->FileRead(
    Location => "$Home/scripts/test/sample/PackageManager/TestPackage.opm",
    Mode     => 'utf8',
    Type     => 'Local',
    Result   => 'SCALAR',
);
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
my $Success       = $PackageObject->RepositoryAdd(
    String    => ${$FileString},
    FromCloud => 0,
);
$Self->True(
    $Success,
    'RepositoryAdd()',
);

my %ExpectedDataRaw = $PackageObject->PackageParse(
    String => ${$FileString},
);
$ExpectedDataRaw{MD5sum} = $MainObject->MD5sum( String => $FileString );
$ExpectedDataRaw{Status} = 'not installed';

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Success',
        Config => {
            Data => {
                Name => 'Test',
            },
        },
        Success => 1,
    },
);

my $BackedObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::ObjectType::Package');

TEST:
for my $Test (@Tests) {

    my %ObjectData = $BackedObject->DataGet( %{ $Test->{Config} } );

    my %ExpectedData;
    if ( $Test->{Success} ) {
        %ExpectedData = %ExpectedDataRaw;
    }

    $Self->IsDeeply(
        \%ObjectData,
        \%ExpectedData,
        "$Test->{Name} DataGet()"
    );
}

# Cleanup is done by RestoreDatabase.
1;
