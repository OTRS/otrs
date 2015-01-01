# --
# ObjectManager/ObjectParamAdd.t - ObjectManager tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Scalar::Util qw/weaken/;

use Kernel::System::ObjectManager;

local $Kernel::OM = Kernel::System::ObjectManager->new();

$Kernel::OM->ObjectParamAdd(
    'Kernel::Config' => {
        Data => 'Test payload',
    },
);

$Self->IsDeeply(
    $Kernel::OM->{Param}->{'Kernel::Config'},
    {
        Data => 'Test payload',
    },
    'ObjectParamAdd set key',
);

$Kernel::OM->ObjectParamAdd(
    'Kernel::Config' => {
        Data2 => 'Test payload 2',
    },
);

$Self->IsDeeply(
    $Kernel::OM->{Param}->{'Kernel::Config'},
    {
        Data  => 'Test payload',
        Data2 => 'Test payload 2',
    },
    'ObjectParamAdd set key',
);

$Kernel::OM->ObjectParamAdd(
    'Kernel::Config' => {
        Data => undef,
    },
);

$Self->IsDeeply(
    $Kernel::OM->{Param}->{'Kernel::Config'},
    {
        Data2 => 'Test payload 2',
    },
    'ObjectParamAdd removed key',
);

$Kernel::OM->ObjectParamAdd(
    'Kernel::Config' => {
        Data2 => undef,
    },
);

$Self->IsDeeply(
    $Kernel::OM->{Param}->{'Kernel::Config'},
    {},
    'ObjectParamAdd removed key',
);

1;
