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

# Prevent used once warning.
use Kernel::System::ObjectManager;

use vars (qw($Self));

my @CompareTests = (
    {
        Description => 'Test #1 - missing Source',
        Config      => {
            Target => 'Test 2',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Test #2 - missing Target',
        Config      => {
            Source => 'Test 1',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Test #3',
        Config      => {
            Source => 'Test 1',
            Target => 'Test 2',
        },
        ExpectedResult => {
            HTML => '<table class="DataTable diff">
<tr class=\'change\'><td><em>1</em></td><td><em>1</em></td><td>Test <del>1</del></td><td>Test <ins>2</ins></td></tr>
</table>
',
            Plain =>
                '<div class="file"><span class="fileheader"></span><div class="hunk"><span class="hunkheader">@@ -1 +1 @@
</span><del>- Test 1</del><ins>+ Test 2</ins><span class="hunkfooter"></span></div><span class="filefooter"></span></div>'
        },
    },
);

my $DiffObject = $Kernel::OM->Get('Kernel::System::Diff');

for my $Test (@CompareTests) {
    my %Result = $DiffObject->Compare(
        %{ $Test->{Config} },
    );

    if (%Result) {
        $Self->IsDeeply(
            \%Result,
            $Test->{ExpectedResult},
            $Test->{Description},
        );
    }
    else {
        $Self->False(
            $Test->{ExpectedResult},
            $Test->{Description},
        );
    }
}

1;
