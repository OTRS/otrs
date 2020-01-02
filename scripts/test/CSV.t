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

# get needed objects
my $CSVObject = $Kernel::OM->Get('Kernel::System::CSV');

my $CSV = $CSVObject->Array2CSV(
    WithHeader => [ 'Title', 'Example' ],
    Head       => [ 'RowA',  'RowB', 'RowC', ],
    Data => [
        [ 1,  4, 1 ],
        [ 7,  3, 2 ],
        [ 1,  9, 3 ],
        [ 34, 4, 4 ],
    ],
);

my $CSVReference = qq{"Title";"Example"\n}
    . qq{"RowA";"RowB";"RowC"\n}
    . qq{"1";"4";"1"\n}
    . qq{"7";"3";"2"\n}
    . qq{"1";"9";"3"\n}
    . qq{"34";"4";"4"\n};

$Self->Is(
    $CSV || '',
    $CSVReference,
    '#0 Array2CSV()',
);

my $Array = $CSVObject->CSV2Array(
    String    => '"field1";"field2";"field3"' . "\n" . '"2";"3";"4"' . "\n",
    Separator => ';',
    Quote     => '"',
);

$Self->Is(
    $Array->[0]->[0] || '',
    'field1',
    '#1 CSV2Array() - with quote "',
);
$Self->Is(
    $Array->[0]->[2] || '',
    'field3',
    '#1 CSV2Array() - with quote "',
);
$Self->Is(
    $Array->[1]->[1] || '',
    '3',
    '#1 CSV2Array() - with quote "',
);
$Self->Is(
    $#{$Array} || '',
    1,
    '#1 CSV2Array() - with quote "',
);
$Self->Is(
    $#{ $Array->[1] } || '',
    2,
    '#1 CSV2Array() - with quote "',
);

$Array = $CSVObject->CSV2Array(
    String    => "field1;field2;field3\n2;3;4\n",
    Separator => ';',
    Quote     => '',
);

$Self->Is(
    $Array->[0]->[0] || '',
    'field1',
    '#2 CSV2Array()',
);
$Self->Is(
    $Array->[0]->[2] || '',
    'field3',
    '#2 CSV2Array()',
);
$Self->Is(
    $Array->[1]->[1] || '',
    '3',
    '#2 CSV2Array()',
);
$Self->Is(
    $#{$Array} || '',
    1,
    '#2 CSV2Array()',
);
$Self->Is(
    $#{ $Array->[1] } || '',
    2,
    '#2 CSV2Array()',
);

# Working with CSVString with \n
my $String = '"field1";"field2";"field3"' . "\n" . '"a' . "\n"
    . 'b";"FirstLine' . "\n"
    . 'SecondLine";"4"' . "\n";
$Array = $CSVObject->CSV2Array(
    String    => $String,
    Separator => ';',
    Quote     => '"',
);

$Self->Is(
    $Array->[0]->[0] || '',
    'field1',
    '#3 CSV2Array() - with  new line in content',
);
$Self->Is(
    $Array->[0]->[2] || '',
    'field3',
    '#3 CSV2Array() - with  new line in content',
);
$Self->Is(
    $Array->[1]->[0] || '',
    "a\nb",
    '#3 CSV2Array() - with  new line in content',
);
$Self->Is(
    $#{$Array} || '',
    1,
    '#3 CSV2Array() - with  new line in content',
);
$Self->Is(
    $#{ $Array->[1] } || '',
    2,
    '#3 CSV2Array() - with  new line in content',
);

# Working with CSVString with \r
$String = '"field1";"field2";"field3"' . "\r" . '"a' . "\r"
    . 'b";"FirstLine' . "\r"
    . 'SecondLine";"4"' . "\r";
$Array = $CSVObject->CSV2Array(
    String    => $String,
    Separator => ';',
    Quote     => '"',
);

$Self->Is(
    $Array->[0]->[0] || '',
    'field1',
    '#4 CSV2Array() - with dos file',
);
$Self->Is(
    $Array->[0]->[2] || '',
    'field3',
    '#4 CSV2Array() - with dos file',
);
$Self->Is(
    $Array->[1]->[0] || '',
    "a\nb",
    '#4 CSV2Array() - with dos file',
);
$Self->Is(
    $#{$Array} || '',
    1,
    '#4 CSV2Array() - with dos file',
);
$Self->Is(
    $#{ $Array->[1] } || '',
    2,
    '#4 CSV2Array() - with dos file',
);

# values with \n quoted; other not quoted
$String = 'c1;c2;c3' . "\n"
    . 'v1;"v2 line1' . "\n" . 'v2 line 2";v3' . "\n";
$Array = $CSVObject->CSV2Array(
    String    => $String,
    Separator => ';',
    Quote     => '"',
);

$Self->Is(
    $Array->[0]->[0] || '',
    'c1',
    '#5 CSV2Array() - values with \n quoted; other not quoted',
);
$Self->Is(
    $Array->[0]->[1] || '',
    'c2',
    '#5 CSV2Array() - values with \n quoted; other not quoted',
);
$Self->Is(
    $Array->[0]->[2] || '',
    'c3',
    '#5 CSV2Array() - values with \n quoted; other not quoted',
);
$Self->Is(
    $Array->[1]->[0] || '',
    'v1',
    '#5 CSV2Array() - values with \n quoted; other not quoted',
);
$Self->Is(
    $Array->[1]->[1] || '',
    "v2 line1\nv2 line 2",
    '#5 CSV2Array() - values with \n quoted; other not quoted',
);
$Self->Is(
    $Array->[1]->[2] || '',
    'v3',
    '#5 CSV2Array() - values with \n quoted; other not quoted',
);
$Self->Is(
    $#{$Array} || '',
    1,
    '#5 CSV2Array() - values with \n quoted; other not quoted',
);
$Self->Is(
    $#{ $Array->[1] } || '',
    2,
    '#5 CSV2Array() - values with \n quoted; other not quoted',
);

# values with \r quoted; other not quoted
$String = 'c1ø;c2;c3' . "\r"
    . 'v1;"v2 line1' . "\r" . 'v2 line 2";v3' . "\r";
$Array = $CSVObject->CSV2Array(
    String    => $String,
    Separator => ';',
    Quote     => '"',
);

$Self->Is(
    $Array->[0]->[0] || '',
    'c1ø',
    '#6 CSV2Array() - values with \r quoted; other not quoted',
);
$Self->Is(
    $Array->[0]->[1] || '',
    'c2',
    '#6 CSV2Array() - values with \r quoted; other not quoted',
);
$Self->Is(
    $Array->[0]->[2] || '',
    'c3',
    '#6 CSV2Array() - values with \r quoted; other not quoted',
);
$Self->Is(
    $Array->[1]->[0] || '',
    'v1',
    '#6 CSV2Array() - values with \r quoted; other not quoted',
);
$Self->Is(
    $Array->[1]->[1] || '',
    "v2 line1\nv2 line 2",
    '#6 CSV2Array() - values with \r quoted; other not quoted',
);
$Self->Is(
    $Array->[1]->[2] || '',
    'v3',
    '#6 CSV2Array() - values with \r quoted; other not quoted',
);
$Self->Is(
    $#{$Array} || '',
    1,
    '#6 CSV2Array() - values with \r quoted; other not quoted',
);
$Self->Is(
    $#{ $Array->[1] } || '',
    2,
    '#6 CSV2Array() - values with \r quoted; other not quoted',
);

#
# tests because of the double "" problem bug# 2263
#
my $TextWithNewLine = "Hallo guys,\nhere was a newline. And again.\n";
my @TableData       = (
    [
        '<a href="/sirios-cvs-utf8/index.pl?Action=AgentStats&Subaction=Overview" class="navitem">Übersicht</a>',
        '"'
    ],
    [ '4""4', 'asdf"SDF' ],
    [ '"a"',  "xxx" ],
    [ 34,     $TextWithNewLine ],
);

$CSV = $CSVObject->Array2CSV(
    Head => [ 'RowA', 'RowB', ],
    Data => \@TableData,
);

$CSVReference = qq{"RowA";"RowB"\n}
    . qq{"<a href=""/sirios-cvs-utf8/index.pl?Action=AgentStats&Subaction=Overview"" class=""navitem"">Übersicht</a>";""""\n}
    . qq{"4""""4";"asdf""SDF"\n}
    . qq{"""a""";"xxx"\n}
    . qq{"34";"} . $TextWithNewLine . qq{"\n};

$Self->Is(
    $CSV || '',
    $CSVReference,
    'Array2CSV() with ""',
);

my $ArrayRef = $CSVObject->CSV2Array(
    String    => $CSV,
    Separator => ';',
    Quote     => '"',
);

shift @{$ArrayRef};

for my $Row ( 0 .. $#TableData ) {
    for my $Column ( 0 .. $#{ $TableData[0] } ) {
        $Self->Is(
            $TableData[$Row][$Column],
            $ArrayRef->[$Row][$Column],
            'CSV2Array() with " in content',
        );
    }
}

#
# tests export in Excel file - bug# 10656
#

$TextWithNewLine = "Some chinese characters: 你好.\n";
@TableData       = (
    [ 'TestData1', '你好' ],
    [ 'TestData2', '晚安' ],
    [ 'TestData3', '早安' ],
    [ 11,          $TextWithNewLine ],
);

my $Excel = $CSVObject->Array2CSV(
    Head => [ 'RowA', 'RowB', ],
    Data => \@TableData,
);

$Self->True(
    $Excel,
    'Array2CSV() with Format => Excel return data',
);

1;
