# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use Kernel::System::Valid;

package Kernel::System::Valid;    ## no critic
use strict;
use warnings;

#
# This file demonstrates how to use the autoload mechanism of OTRS to change existing functionality,
#   adding a method to Kernel::System::Valid in this case.
#

#
# Please note that all autoload files have to be registered via SysConfig (see AutoloadPerlPackages###1000-Test).
#

sub AutoloadTest {
    return 1;
}

1;
