# --
# CSV.t - CSV tests
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CSV.t,v 1.1 2006-03-20 09:42:44 rk Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::CSV;
use Kernel::System::Log;

$Self->{CSVObject} = Kernel::System::CSV->new(%{$Self});
$Self->{LogObject} = Kernel::System::Log->new(%{$Self});

my $CSV = $Self->{CSVObject}->GenerateCSV(
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

1;
