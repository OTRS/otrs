# --
# Debugger.t - GenericInterface debugger tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Debugger.t,v 1.4 2011-02-15 09:10:33 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::GenericInterface::Debugger;

# first test the debugger in general

my $DebuggerObject;

# a few tests to instanciate incorrectly
eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new();
};
$Self->False(
    ref $DebuggerObject,
    'DebuggerObject instanciate no objects',
);

eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        %{$Self},
    );
};
$Self->False(
    ref $DebuggerObject,
    'DebuggerObject instanciate with objects, no options',
);

eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        %{$Self},
        DebuggerConfig => {
            DebugLevel => 'debug',
        },
        TestMode => 1,
    );
};
$Self->False(
    ref $DebuggerObject,
    'DebuggerObject instanciate without WebserviceID',
);

eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        %{$Self},
        WebserviceID => 1,
        TestMode     => 1,
    );
};
$Self->False(
    ref $DebuggerObject,
    'DebuggerObject instanciate without DebuggerConfig',
);

eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        %{$Self},
        DebuggerConfig => {},
        WebserviceID   => 1,
        TestMode       => 1,
    );
};
$Self->False(
    ref $DebuggerObject,
    'DebuggerObject instanciate without DebugLevel',
);

eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        %{$Self},
        DebuggerConfig => {
            DebugLevel => 'nonexistinglevel',
        },
        WebserviceID => 1,
        TestMode     => 1,
    );
};
$Self->False(
    ref $DebuggerObject,
    'DebuggerObject instanciate with non existing DebugLevel',
);

# correctly now
$DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugLevel => 'debug',
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
    TestMode          => 1,
);
$Self->Is(
    ref $DebuggerObject,
    'Kernel::GenericInterface::Debugger',
    'DebuggerObject instanciate correctly',
);

my $Result;

# log without Summary
eval {
    $Result = $DebuggerObject->DebugLog() || 0;
};
$Self->False(
    $Result,
    'DebuggerObject call without summary',
);

# log with incorrect debug level
eval {
    $Result = $DebuggerObject->DebugLog(
        Summary    => 'an entry with incorrect debug level',
        DebugLevel => 'notexistingdebuglevel',
    ) || 0;
};
$Self->False(
    $Result,
    'DebuggerObject call with invalid debug level',
);

# log correctly
$Result = $DebuggerObject->DebugLog(
    Summary    => 'a correct entry',
    DebugLevel => 'debug',
) || 0;
$Self->True(
    $Result,
    'DebuggerObject correct call',
);

# log with custom functions -debug level should be overwritten by function
$Result = $DebuggerObject->Error(
    Summary    => 'a correct entry',
    DebugLevel => 'notexistingbutshouldnotbeused',
) || 0;
$Self->True(
    $Result,
    'DebuggerObject call to custom function error, debug level should be overwritten',
);
$Result = $DebuggerObject->Debug(
    Summary    => 'a correct entry',
    DebugLevel => 'notexistingbutshouldnotbeused',
) || 0;
$Self->True(
    $Result,
    'DebuggerObject call to custom function debug',
);
$Result = $DebuggerObject->Info(
    Summary    => 'a correct entry',
    DebugLevel => 'notexistingbutshouldnotbeused',
) || 0;
$Self->True(
    $Result,
    'DebuggerObject call to custom function debug',
);
$Result = $DebuggerObject->Notice(
    Summary    => 'a correct entry',
    DebugLevel => 'notexistingbutshouldnotbeused',
) || 0;
$Self->True(
    $Result,
    'DebuggerObject call to custom function debug',
);

1;
