# --
# scripts/test/sample/DynamicField/Driver/DummyCheckbox.pm - Delegate for DynamicField Checkbox Driver
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::test::sample::DynamicField::Driver::DummyCheckbox;

use strict;
use warnings;

sub DummyFunction1 {
    my ( $Self, %Param ) = @_;
    return 1;
}

sub DummyFunction2 {
    my ( $Self, %Param ) = @_;
    return 2;
}

1;