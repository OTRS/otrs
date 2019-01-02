# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::test::ObjectManager::Disabled;    ## no critic

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Class, %Param ) = @_;

    bless \%Param, $Class;
}

sub Data {
    my ($Self) = @_;

    return $Self->{Data};
}

1;
