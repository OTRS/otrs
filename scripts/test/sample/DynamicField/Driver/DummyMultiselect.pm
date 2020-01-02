# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::test::sample::DynamicField::Driver::DummyMultiselect;

use strict;
use warnings;

sub DummyFunction2 {
    my ( $Self, %Param ) = @_;
    return 'Multiselect';
}

1;
