# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::test::ObjectManager::NonSingleton;    ## no critic

use strict;
use warnings;

use Kernel::System::ObjectManager;

our %ObjectManagerFlags = (
    NonSingleton => 1,
);

our @ObjectDependencies = ();

sub new {
    my ( $Class, %Param ) = @_;

    bless \%Param, $Class;

    return $Class;
}

1;
