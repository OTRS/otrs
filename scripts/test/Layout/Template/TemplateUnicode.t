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

use File::Basename qw();

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

# call Output() once so that the TT objects are created.
$LayoutObject->Output( Template => '' );

# now add this directory as include path to be able to use the test templates
my $IncludePaths = $LayoutObject->{TemplateProviderObject}->include_path();
unshift @{$IncludePaths},
    $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/scripts/test/Layout/Template';
$LayoutObject->{TemplateProviderObject}->include_path($IncludePaths);

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

# uncached and cached
for ( 1 .. 2 ) {
    my $Result = $LayoutObject->Output(
        TemplateFile => 'TemplateUnicode',
    );

    $Self->Is(
        $Result,
        "some unicode content ä ø\n",
        'Template is considered UTF8',
    );
}

# cleanup cache is done by RestoreDatabase

1;
