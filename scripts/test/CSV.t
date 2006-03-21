# --
# CSV.t - CSV tests
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CSV.t,v 1.2 2006-03-21 11:18:29 rk Exp $
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
        String => '"field1";"field2";"field3";\n"2";"3";"4";\n',
        Separator => ';',
        Quote => '"',
    );

$Self->True(
    ($Array->[0][0] eq 'field1' && $Array->[0][2] eq 'field3' &&
     $Array->[1][1] eq '3' && $#{$Array} eq 1 && $#{$Array->[1]} eq 2),
    'CSV2Array()',
);


1;
