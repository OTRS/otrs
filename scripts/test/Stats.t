# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::ObjectManager;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

# try to get an invalid stat
my $StatInvalid = $StatsObject->StatsGet( StatID => 1111 );

$Self->False(
    $StatInvalid,
    'StatsGet() try to get a not exitsting stat',
);

my $Update = $StatsObject->StatsUpdate(
    StatID => '1111',
    Hash   => {
        Title       => 'TestTitle from UnitTest.pl',
        Description => 'some Description',
    },
    UserID => 1,
);
$Self->False(
    $Update,
    'StatsUpdate() try to update a invalid stat id (Ignore the Tracebacks on the top)',
);

# check the StatsAddfunction
my $StatID1 = $StatsObject->StatsAdd(
    UserID => 1,
);
my $StatID2 = $StatsObject->StatsAdd(
    UserID => 1,
);

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
$Update = $StatsObject->StatsUpdate(
    StatID => $StatID1,
    Hash   => {
        Title        => 'TestTitle from UnitTest.pl',
        Description  => 'some Description',
        Object       => 'Ticket',
        Format       => 'CSV',
        ObjectModule => 'Kernel::System::Stats::Dynamic::Ticket',
        Permission   => '1',
        StatType     => 'dynamic',
        SumCol       => '1',
        SumRow       => '1',
        Valid        => '1',
    },
    UserID => 1,
);
$Self->True(
    $Update,
    'StatsUpdate() Update StatID1',
);

$Update = $StatsObject->StatsUpdate(
    StatID => ( $StatID2 + 2 ),
    Hash   => {
        Title       => 'TestTitle from UnitTest.pl',
        Description => 'some Description',
    },
    UserID => 1,
);
$Self->False(
    $Update,
    'StatsUpdate() try to update a invalid stat id (Ignore the Tracebacks on the top)',
);

# check get function
my $Stat = $StatsObject->StatsGet( StatID => $StatID1 );

$Self->Is(
    $Stat->{Title},
    'TestTitle from UnitTest.pl',
    'StatsGet() check the Title',
);

$Self->Is(
    $Stat->{Cache},
    undef,
    'StatsGet() Cache was not yet set',
);

$Self->Is(
    $Stat->{ShowAsDashboardWidget},
    undef,
    'StatsGet() ShowAsDashboardWidget was not yet set',
);

$Update = $StatsObject->StatsUpdate(
    StatID => ($StatID1),
    Hash   => {
        Cache => 1,
    },
    UserID => 1,
);

$Self->True(
    $Update,
    'StatsUpdate() add Cache flag',
);

# check get function
$Stat = $StatsObject->StatsGet( StatID => $StatID1 );

$Self->Is(
    $Stat->{Cache},
    1,
    'StatsGet() check the Cache flag',
);

$Update = $StatsObject->StatsUpdate(
    StatID => ($StatID1),
    Hash   => {
        ShowAsDashboardWidget => 1,
    },
    UserID => 1,
);

$Self->True(
    $Update,
    'StatsUpdate() add ShowAsDashboardWidget flag',
);

# check get function
$Stat = $StatsObject->StatsGet( StatID => $StatID1 );

$Self->Is(
    $Stat->{ShowAsDashboardWidget},
    1,
    'StatsGet() check the ShowAsDashboardWidget flag',
);

my $ObjectBehaviours = $StatsObject->GetObjectBehaviours(
    ObjectModule => 'Kernel::System::Stats::Dynamic::Ticket'
);

$Self->IsDeeply(
    $ObjectBehaviours,
    {
        ProvidesDashboardWidget => 1,
    },
    "GetObjectBehaviours without cache",
);

$ObjectBehaviours = $StatsObject->GetObjectBehaviours(
    ObjectModule => 'Kernel::System::Stats::Dynamic::Ticket'
);

$Self->IsDeeply(
    $ObjectBehaviours,
    {
        ProvidesDashboardWidget => 1,
    },
    "GetObjectBehaviours with cache",
);

# check StatsList
my $ArrayRef = $StatsObject->GetStatsList(
    OrderBy   => 'StatID',
    Direction => 'ASC',
    UserID    => 1,
);

my $Counter = 0;
for ( @{$ArrayRef} ) {
    if ( $_ eq $StatID1 || $_ eq $StatID2 ) {
        $Counter++;
    }
}

$Self->Is(
    $Counter,
    '2',
    'GetStatsList() check if StatID1 and StatID2 available in the statslist',
);

my $StatsHash = $StatsObject->StatsListGet(
    UserID => 1,
);
$Self->Is(
    $StatsHash->{$StatID1}->{Title},
    'TestTitle from UnitTest.pl',
    'StatsListGet() title of Stat1',
);
$Self->True(
    exists $StatsHash->{$StatID2},
    'StatsListGet() contains Stat2',
);

# check the available DynamicFiles
my $DynamicArrayRef = $StatsObject->GetDynamicFiles(
    UserID => 1,
);
$Self->True(
    $DynamicArrayRef,
    'GetDynamicFiles() check if dynamic files available',
);

# check the sumbuild function
my @StatArray = @{
    $StatsObject->SumBuild(
        Array => [
            ['Title'],
            [ 'SomeText', 'Column1', 'Column2', 'Column3', 'Column4', 'Column5', 'Column6', ],
            [ 'Row1',     1,         1,         1,         0,         1,         undef, ],
            [ 'Row2',     2,         2,         2,         0,         2,         undef, ],
            [ 'Row3',     3,         undef,     3,         0,         3,         undef, ],
        ],
        SumRow => 1,
        SumCol => 1,
    ),
};

my @SubStatArray = @{ $StatArray[-1] };
$Counter = $SubStatArray[-1];
$Self->Is(
    $Counter,
    '21',
    'SumBuild() check total',
);

$Self->Is(
    $SubStatArray[1],
    '6',
    'SumBuild() check x total',
);

$Self->Is(
    $SubStatArray[2],
    '3',
    'SumBuild() check x total w/undefined value',
);

$Self->Is(
    $SubStatArray[4],
    '0',
    'SumBuild() check x total w/0 value',
);

$Self->Is(
    $SubStatArray[6],
    '0',
    'SumBuild() check x total w/all undef values',
);

# export StatID 1
my $ExportFile = $StatsObject->Export(
    StatID => $StatID1,
    UserID => 1,
);
$Self->True(
    $ExportFile->{Content},
    'Export() check if Exportfile has a content',
);

# import the exportet stat
my $StatID3 = $StatsObject->Import(
    Content => $ExportFile->{Content},
    UserID  => 1,
);
$Self->True(
    $StatID3,
    'Import() is StatID3 true',
);

# check the imported stat
my $Stat3 = $StatsObject->StatsGet( StatID => $StatID3 );
$Self->Is(
    $Stat3->{Title},
    'TestTitle from UnitTest.pl',
    'StatsGet() check imported stat',
);

# check delete stat function
$Self->True(
    $StatsObject->StatsDelete(
        StatID => $StatID1,
        UserID => 1,
    ),
    'StatsDelete() delete StatID1',
);
$Self->True(
    $StatsObject->StatsDelete(
        StatID => $StatID2,
        UserID => 1,
    ),
    'StatsDelete() delete StatID2',
);
$Self->True(
    $StatsObject->StatsDelete(
        StatID => $StatID3,
        UserID => 1,
    ),
    'StatsDelete() delete StatID3',
);

# verify stat is deleted
$Stat3 = $StatsObject->StatsGet(
    StatID => $StatID3,
    UserID => 1,
);
$Self->Is(
    $Stat3->{Title},
    undef,
    'StatsGet() check deleted stat',
);

# check StatsList
$ArrayRef = $StatsObject->GetStatsList(
    OrderBy   => 'StatID',
    Direction => 'ASC',
    UserID    => 1,
);

$Counter = 0;
for ( @{$ArrayRef} ) {
    if ( $_ eq $StatID1 || $_ eq $StatID2 ) {
        $Counter++;
    }
}

$Self->Is(
    $Counter,
    0,
    'GetStatsList() check if StatID1 and StatID2 removed from in the statslist',
);

$StatsHash = $StatsObject->StatsListGet(
    UserID => 1,
);
$Self->False(
    exists $StatsHash->{$StatID1},
    'StatsListGet() contains Stat1',
);
$Self->False(
    exists $StatsHash->{$StatID2},
    'StatsListGet() contains Stat2',
);
$Self->False(
    exists $StatsHash->{$StatID3},
    'StatsListGet() contains Stat2',
);

# ---
# import a Stat and export it - then check if it is the same string
# ---

# load example file
my $Path          = $ConfigObject->Get('Home') . '/scripts/test/sample/Stats/Stats.TicketOverview.de.xml';
my $StatID        = 0;
my $ExportContent = {};
my $Filehandle;
if ( !open $Filehandle, '<', $Path ) {    ## no critic
    $Self->True(
        0,
        'Get the file which should be imported',
    );
}

my @Lines = <$Filehandle>;
my $ImportContent = join '', @Lines;

close $Filehandle;

$StatID = $StatsObject->Import(
    Content => $ImportContent,
    UserID  => 1,
);

# check StatsList
$ArrayRef = $StatsObject->GetStatsList(
    OrderBy   => 'StatID',
    Direction => 'ASC',
    UserID    => 1,
);

$Counter = 0;
for ( @{$ArrayRef} ) {
    if ( $_ eq $StatID ) {
        $Counter++;
    }
}

$Self->Is(
    $Counter,
    1,
    'GetStatsList() check if imported stat is in the statslist',
);

$ExportContent = $StatsObject->Export(
    StatID => $StatID,
    UserID => 1,
);

# the following line are because of different spelling 'ISO-8859' or 'iso-8859'
# but this is no solution for the problem if one string is iso and the other utf!
$ImportContent =~ s/^<\?xml.*?>.*?<otrs_stats/<otrs_stats/ms;

# this line is for Windows check-out
$ImportContent =~ s{\r\n}{\n}smxg;

$ExportContent->{Content} =~ s/^<\?xml.*?>.*?<otrs_stats/<otrs_stats/ms;
$Self->Is(
    $ImportContent,
    $ExportContent->{Content},
    "Export-Importcheck - check if import file content equal export file content.\n Be careful, if it gives errors if you run OTRS with default charset uft-8,\n because the examplefile is iso-8859-1, but at my test there a no problems to compare a utf-8 string with an iso string?!\n",
);

# ---
# try to use otrs.Console.pl Maint::Stats::Generate
# ---

# check the imported stat
my $Stat4 = $StatsObject->StatsGet( StatID => $StatID );
my $Home = $ConfigObject->Get('Home');
my ( $Result, $ExitCode );
{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Stats::Generate');
    $ExitCode = $CommandObject->Execute( '--number', $Stat4->{StatNumber}, '--target-directory', "$Home/var/tmp/" );
}

$Self->Is(
    $ExitCode,
    0,
    "Stat successfully generated",
);

my $FileFound;

for my $Line ( split m{\n}, $Result ) {
    if ( $Line =~ /\/\/(.+?csv)\./ ) {
        unlink "$Home/var/tmp/$1";
        $FileFound++;
    }
}

$Self->Is(
    $FileFound,
    1,
    "CSV file generated",
);

$Self->True(
    $StatsObject->StatsDelete(
        StatID => $StatID,
        UserID => 1,
    ),
    'StatsDelete() delete import stat',
);

# try the clean up function
$Result = $StatsObject->StatsCleanUp(
    UserID => 1,
);
$Self->True(
    $Result,
    'StatsCleanUp() - clean up stats',
);

1;
