# --
# Mapping.t - Mapping tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Mapping.t,v 1.1 2011-02-08 09:47:54 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::GenericInterface::Mapping;
use Kernel::GenericInterface::Debugger;
$Self->{DebuggerObject} = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugLevel => 'debug',
    },
    WebserviceID => 12,
);

# create local object
my $MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    MappingConfig => {
        Type   => 'Simple',
        Config => {
            something => 'asdfadsf',
        },
    },
);

my $MappingResult = $MappingObject->Map(
    Data => {
        one   => 1,
        two   => 2,
        three => 3,
    },
);

$Self->Is(
    $MappingResult->{Success},
    1,
    '#1 Mapping::Map() - Dummy test. "',
);

1;
