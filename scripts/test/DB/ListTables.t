# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my @Tables = $Kernel::OM->Get('Kernel::System::DB')->ListTables();

$Self->True(
    scalar( grep { $_ eq 'valid' } @Tables ),
    "Valid table found.",
);

1;
