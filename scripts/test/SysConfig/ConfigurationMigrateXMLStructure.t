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

use Kernel::Config;

# get needed objects
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# load xml from samples
my $XML = $MainObject->FileRead(
    Directory => $Kernel::OM->Get('Kernel::Config')->{Home} . '/scripts/test/sample/SysConfig/',
    Filename  => 'ConfigurationMigrateXMLStructure.xml',
    Mode      => 'utf8',
);

my $XMLExpected = $MainObject->FileRead(
    Directory => $Kernel::OM->Get('Kernel::Config')->{Home} . '/scripts/test/sample/SysConfig/',
    Filename  => 'ConfigurationMigrateXMLStructureResult.xml',
    Mode      => 'utf8',
);
my @XMLExpectedSettings = split( '</Setting>', ${$XMLExpected} );

# Migrate
my $Result = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateXMLStructure(
    Content => ${$XML},
    Name    => 'MigrateXMLStructure',
);

my @ResultSettings = split( '</Setting>', $Result );

$Self->Is(
    scalar @ResultSettings,
    scalar @XMLExpectedSettings,
    "Compare Setting number."
);

INDEX:
for my $Index ( 0 .. scalar @ResultSettings - 1 ) {
    $Self->True(
        $XMLExpectedSettings[$Index],
        "Check if expected item exists [$Index]",
    );
    next INDEX if !$XMLExpectedSettings[$Index];

    # Get Description
    $XMLExpectedSettings[$Index] =~ m{<Description.*?>(.*?)</Description>};
    my $Title = $1 || 'Test without description';

    $Self->Is(
        $ResultSettings[$Index],
        $XMLExpectedSettings[$Index],
        $Title,
    );
}

1;
