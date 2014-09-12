# --
# scripts/test/Layout/Template/TemplateUnicode.t - layout testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use File::Basename qw();

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

1;
