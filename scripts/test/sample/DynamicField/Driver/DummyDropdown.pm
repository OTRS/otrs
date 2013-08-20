# --
# scripts/test/sample/DynamicField/Driver/DummyDropdown.pm - Delegate for DynamicField Dropdown Driver
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::test::sample::DynamicField::Driver::DummyDropdown;

use strict;
use warnings;

sub DummyFunction2 {
    my ( $Self, %Param ) = @_;
    return 1;
}

1;