# --
# Mapping.t - Mapping tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Mapping.t,v 1.2 2011-02-08 11:13:03 sb Exp $
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
$Self->{DBObject}       = Kernel::System::DB->new( %{$Self} );
$Self->{DebuggerObject} = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugLevel => 'debug',
    },
    WebserviceID => 1,
    TestMode     => 1,
);

# create object with false options
my $MappingObject;

# provide no objects
$MappingObject = Kernel::GenericInterface::Mapping->new();
$Self->True(
    ref $MappingObject eq 'HASH',
    'MappingObject response check',
);
$Self->True(
    $MappingObject->{ErrorMessage},
    'MappingObject required objects check',
);

# provide empty mapping config
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    MappingConfig => {},
);
$Self->True(
    $MappingObject->{ErrorMessage},
    'MappingObject required config check',
);

# provide incorrect mapping type
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    MappingConfig => {
        Type => 'ThisIsCertainlyNotBeingUsed',
    },
);
$Self->True(
    $MappingObject->{ErrorMessage},
    'MappingObject mapping type check',
);

# correct call (with empty config)
$MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    MappingConfig => {
        Type => 'Test',
    },
);
$Self->False(
    $MappingObject->{ErrorMessage},
    'MappingObject creation check',
);

1;
