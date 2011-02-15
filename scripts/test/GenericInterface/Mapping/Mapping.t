# --
# Mapping.t - Mapping tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Mapping.t,v 1.6 2011-02-15 15:52:03 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

# create needed objects
use Kernel::System::DB;
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Mapping;
my %CommonObject = %{$Self};
$CommonObject{DBObject}       = Kernel::System::DB->new(%CommonObject);
$CommonObject{DebuggerObject} = Kernel::GenericInterface::Debugger->new(
    %CommonObject,
    DebuggerConfig => {
        DebugThreshold => 'debug',
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
    TestMode          => 1,
);

# create object with false options
my $MappingObject;

# provide no objects
$MappingObject = Kernel::GenericInterface::Mapping->new();
$Self->True(
    ref $MappingObject eq 'HASH',
    'MappingObject response check',
);
$Self->False(
    $MappingObject->{Success},
    'MappingObject required objects check',
);

# provide empty mapping config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %CommonObject,
    MappingConfig => {},
);
$Self->False(
    $MappingObject->{Success},
    'MappingObject required config check',
);

# provide incorrect mapping type
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %CommonObject,
    MappingConfig => {
        Type => 'ThisIsCertainlyNotBeingUsed',
    },
);
$Self->False(
    $MappingObject->{Success},
    'MappingObject mapping type check',
);

# call with empty config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %CommonObject,
    MappingConfig => {
        Type   => 'Test',
        Config => {},
    },
);
$Self->False(
    $MappingObject->{Success},
    'MappingObject creation check with empty config',
);

# call with invalid config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %CommonObject,
    MappingConfig => {
        Type   => 'Test',
        Config => 'invalid',
    },
);
$Self->False(
    $MappingObject->{Success},
    'MappingObject creation check with config as string',
);

# call with invalid config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %CommonObject,
    MappingConfig => {
        Type   => 'Test',
        Config => [],
    },
);
$Self->False(
    $MappingObject->{Success},
    'MappingObject creation check with config as array ref',
);

# call with invalid config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %CommonObject,
    MappingConfig => {
        Type   => 'Test',
        Config => '',
    },
);
$Self->False(
    $MappingObject->{Success},
    'MappingObject creation check with config as empty string',
);

# call without config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %CommonObject,
    MappingConfig => {
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
$Self->True(
    ref $ReturnData eq 'HASH',
    'MappingObject call response type',
);
$Self->False(
    $ReturnData->{Success},
    'MappingObject call no data provided',
);

# map with empty data
$ReturnData = $MappingObject->Map(
    Data => {},
);
$Self->False(
    $ReturnData->{Success},
    'MappingObject call empty data provided',
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
