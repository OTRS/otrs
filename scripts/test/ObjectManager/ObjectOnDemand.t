# --
# ObjectManager/ObjectOnDemand.t - ObjectManager tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

#
# This test makes sure that object dependencies are only created when
#   the object actively asks for them, not earlier
#

use Kernel::System::ObjectManager;

local $Kernel::OM = Kernel::System::ObjectManager->new();

$Self->True( $Kernel::OM, 'Could build object manager' );

$Self->False(
    exists $Kernel::OM->{Objects}->{'Kernel::System::Time'},
    'Kernel::System::Time was not yet loaded',
);

$Self->False(
    exists $Kernel::OM->{Objects}->{'Kernel::System::Log'},
    'Kernel::System::Log was not yet loaded',
);

$Kernel::OM->Get('Kernel::System::Time');

$Self->True(
    exists $Kernel::OM->{Objects}->{'Kernel::System::Time'},
    'Kernel::System::Time was loaded',
);

$Self->False(
    exists $Kernel::OM->{Objects}->{'Kernel::System::Log'},
    'Kernel::System::Log is a dependency of Kernel::System::Time, but was not yet loaded',
);

1;
