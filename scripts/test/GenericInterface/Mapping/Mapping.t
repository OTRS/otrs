# --
# Mapping.t - Mapping tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Mapping;

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,            # hardcoded because it is not used
    CommunicationType => 'Provider',
);

# create object with false options
my $MappingObject;

$MappingObject = Kernel::GenericInterface::Mapping->new();
$Self->IsNot(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'Mapping::new() constructor failure - no arguments',
);

$MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    MappingConfig  => {},
);
$Self->IsNot(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'Mapping::new() constructor failure - no MappingType',
);

$MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    MappingConfig  => {
        Type => 'ThisIsCertainlyNotBeingUsed',
    },
);
$Self->IsNot(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'Mapping::new() constructor failure - wrong MappingType',
);

# call with empty config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    MappingConfig  => {
        Type   => 'Test',
        Config => {},
    },
);
$Self->IsNot(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'Mapping::new() constructor failure - empty config',
);

# call with invalid config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    MappingConfig  => {
        Type   => 'Test',
        Config => 'invalid',
    },
);
$Self->IsNot(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'Mapping::new() constructor failure - invalid config, string',
);

# call with invalid config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    MappingConfig  => {
        Type   => 'Test',
        Config => [],
    },
);
$Self->IsNot(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'Mapping::new() constructor failure - invalid config, array',
);

# call with invalid config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    MappingConfig  => {
        Type   => 'Test',
        Config => '',
    },
);
$Self->IsNot(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'Mapping::new() constructor failure - invalid config, empty string',
);

# call without config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    MappingConfig  => {
        Type => 'Test',
    },
);
$Self->Is(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'MappingObject creation check without config',
);

# map without data
my $ReturnData = $MappingObject->Map();
$Self->Is(
    ref $ReturnData,
    'HASH',
    'MappingObject call response type',
);
$Self->True(
    $ReturnData->{Success},
    'MappingObject call no data provided',
);

# map with empty data
$ReturnData = $MappingObject->Map(
    Data => {},
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'MappingObject call response type',
);
$Self->True(
    $ReturnData->{Success},
    'MappingObject call empty data provided',
);

# map with invalid data
$ReturnData = $MappingObject->Map(
    Data => [],
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'MappingObject call response type',
);
$Self->False(
    $ReturnData->{Success},
    'MappingObject call invalid data provided',
);

# map with some data
$ReturnData = $MappingObject->Map(
    Data => {
        'from' => 'to',
    },
);
$Self->True(
    $ReturnData->{Success},
    'MappingObject call data provided',
);

1;
