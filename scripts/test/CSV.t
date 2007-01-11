# --
# CSV.t - CSV tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CSV.t,v 1.5 2007-01-11 10:54:08 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::CSV;

$Self->{CSVObject} = Kernel::System::CSV->new(%{$Self});

my $CSV = $Self->{CSVObject}->Array2CSV(
    Head => ['RowA', 'RowB', ],
    Data => [
        [1,4],
        [7,3],
        [1,9],
        [34,4],
    ],
);

$Self->True(
    $CSV eq
'"RowA";"RowB";
"1";"4";
"7";"3";
"1";"9";
"34";"4";
',
    'GenerateCSV()',
);

my $Array = $Self->{CSVObject}->CSV2Array(
    String => '"field1";"field2";"field3";'."\n".'"2";"3";"4";'."\n",
    Separator => ';',
    Quote => '"',
);

$Self->True(
    ($Array->[0][0] eq 'field1' && $Array->[0][2] eq 'field3' &&
     $Array->[1][1] eq '3' && $#{$Array} eq 1 && $#{$Array->[1]} eq 2),
    'CSV2Array() - with quote "',
);

$Array = $Self->{CSVObject}->CSV2Array(
    String => 'field1;field2;field3;'."\n".'2;3;4;'."\n",
    Separator => ';',
    Quote => '',
);

$Self->True(
    ($Array->[0][0] eq 'field1' && $Array->[0][2] eq 'field3' &&
     $Array->[1][1] eq '3' && $#{$Array} eq 1 && $#{$Array->[1]} eq 2),
    'CSV2Array() without quote "',
);

# Working with CSVString with \n
my $String = '"field1";"field2";"field3";'."\n".'"a'."\n" .'b";"FirstLine'."\n" .'SecondLine";"4";'."\n";
$Self->{LogObject}->Dumper($String);
$Array = $Self->{CSVObject}->CSV2Array(
    String => $String,
    Separator => ';',
    Quote => '"',
);
$Self->{LogObject}->Dumper($Array);
$Self->True(
    ($Array->[0][0] eq 'field1' && $Array->[0][2] eq 'field3' &&
     $Array->[1][0] eq "a\nb" && $#{$Array} eq 1 && $#{$Array->[1]} eq 2),
    'CSV2Array() - with included \n',
);

1;
