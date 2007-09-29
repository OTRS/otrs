# --
# scripts/test/Stats.t - stats module testscript
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Stats.t,v 1.6 2007-09-29 11:09:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::Stats;
use Kernel::System::Group;
use Kernel::System::User;
use Kernel::System::Main;
use Kernel::System::CSV;

$Self->{UserID} = 1;
$Self->{GroupObject} = Kernel::System::Group->new(%{$Self});
$Self->{UserObject} = Kernel::System::User->new(%{$Self});
$Self->{MainObject} = Kernel::System::Main->new(%{$Self});
$Self->{CSVObject} = Kernel::System::CSV->new(%{$Self});
$Self->{StatsObject} = Kernel::System::Stats->new(%{$Self});

# check the StatsAddfunction
my $StatID1 = $Self->{StatsObject}->StatsAdd();
my $StatID2 = $Self->{StatsObject}->StatsAdd();

# test 1
$Self->True(
    $StatID1 > 0,
    'StatsAdd() first StatID > 0',
);

# test 2
$Self->True(
    $StatID2 > 0,
    'StatsAdd() second StatID > 0',
);

# test 3
$Self->True(
    $StatID2 > $StatID1,
    'StatsAdd() first StatID < second StatID',
);

# test 4 - check the stats update function
$Self->True(
    $Self->{StatsObject}->StatsUpdate(
        StatID => $StatID1,
        Hash   => {
            Title => 'TestTitle from UnitTest.pl',
            Description=> 'some Description'
        }
    ),
    "StatsUpdate() Update StatID1",
);

$Self->False(
    $Self->{StatsObject}->StatsUpdate(
        StatID => ($StatID2+1),
        Hash   => {
            Title => 'TestTitle from UnitTest.pl',
            Description=> 'some Description'
        }
    ),
    "StatsUpdate() try to update a invalid stat id (Ignore the Tracebacks on the top)",
);

# check get function
my $Stat = $Self->{StatsObject}->StatsGet(
    StatID => $StatID1,
);

$Self->Is(
    $Stat->{Title},
    'TestTitle from UnitTest.pl',
    'StatsGet() check the Title'
);

# check completenesscheck
my @Notify = $Self->{StatsObject}->CompletenessCheck(
    StatData => $Stat,
    Section  => 'All',
);
$Self->Is(
    $Notify[0]{Priority},
    'Error',
    'CompletenessCheck() check the checkfunctions'
);

# check StatsList
my $ArrayRef = $Self->{StatsObject}->GetStatsList(
    OrderBy   => 'StatID',
    Direction => 'ASC',
);

my $Counter = 0;
for (@{$ArrayRef}) {
    if ($_ eq $StatID1 || $_ eq $StatID2) {
        $Counter++;
    }
}

$Self->Is(
    $Counter,
    '2',
    'GetStatsList() check if StatID1 and StatID2 available in the statslist'
);

# check the available DynamicFiles
my $DynamicArrayRef = $Self->{StatsObject}->GetDynamicFiles();
$Self->True(
    $DynamicArrayRef,
    'GetDynamicFiles() check if dynamic files available',
);

# check the sumbuild function
my @StatArray = @{$Self->{StatsObject}->SumBuild(
    Array => [
        ['Title'],
        ['SomeText', 'Column1','Column2','Column3','Column4','Column5'],
        ['Row1', 1,1,1,1,1],
        ['Row1', 2,2,2,2,2],
        ['Row1', 3,3,3,3,3],
    ],
    SumRow => 1,
    SumCol => 1,
)};

my @SubStatArray = @{$StatArray[$#StatArray]};
$Counter = $SubStatArray[$#SubStatArray];
$Self->Is(
    $Counter,
    '30',
    'GetStatsList() check if StatID1 and StatID2 available in the statslist'
);

# export StatID 1
my $ExportFile =  $Self->{StatsObject}->Export(StatID => $StatID1);
$Self->True(
    $ExportFile->{Content},
    'Export() check if Exportfile has a content',
);
# import the exportet stat
my $StatID3 = $Self->{StatsObject}->Import(
    Content  => $ExportFile->{Content},
);
$Self->True(
    $StatID3,
    'Import() is StatID3 true',
);

# check the imported stat
my $Stat3 = $Self->{StatsObject}->StatsGet(
    StatID => $StatID3,
);
$Self->Is(
    $Stat3->{Title},
    'TestTitle from UnitTest.pl',
    'StatsGet() check importet stat'
);

# check delete stat function
$Self->True(
    $Self->{StatsObject}->StatsDelete(StatID => $StatID1),
    'StatsDelete() delete StatID1',
);
$Self->True(
    $Self->{StatsObject}->StatsDelete(StatID => $StatID2),
    'StatsDelete() delete StatID2',
);
$Self->True(
    $Self->{StatsObject}->StatsDelete(StatID => $StatID3),
    'StatsDelete() delete StatID3',
);

# ---
# import a Stat and export it - then check if it is the same string
# ---

# load example file
my $Path  = $Self->{ConfigObject}->Get('Home') . '/scripts/test/sample/Stats.TicketOverview.de.xml';
my $ImportContent = '';
my $StatID = 0;
my $ExportContent = {};

if (!open(FH, "<".$Path)) {
    $Self->True(
        0,
        'Get the file which should be imported',
    );

}
else {
    while (<FH>) {
        $ImportContent .= $_;
    }
    close(FH);

    $StatID = $Self->{StatsObject}->Import(
        Content  => $ImportContent,
    );

    $ExportContent =  $Self->{StatsObject}->Export(StatID => $StatID);

    # the following line are because of different spelling 'ISO-8859' or 'iso-8859'
    # but this is no solution for the problem if one string is iso and the other utf!
    $ImportContent =~ s/^<\?xml.*?>.*?<otrs_stats/<otrs_stats/ms;
    $ExportContent->{Content} =~ s/^<\?xml.*?>.*?<otrs_stats/<otrs_stats/ms;
    $Self->Is(
        $ImportContent,
        $ExportContent->{Content},
        "Export-Importcheck - check if import file content equal export file content.\n Be careful, if it gives errors if you run OTRS with default charset uft-8,\n because the examplefile is iso-8859-1, but at my test there a no problems to compare a utf-8 string with an iso string?!\n"
    );
}
$Self->True(
    $Self->{StatsObject}->StatsDelete(StatID => $StatID),
    'StatsDelete() delete import stat',
);

1;
