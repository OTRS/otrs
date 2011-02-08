# --
# Debugger.t - GenericInterface debugger tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Debugger.t,v 1.1 2011-02-08 09:21:57 mg Exp $
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

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %$Self,
    DebuggerConfig => {
        DebugLevel => 'debug',
    },
    WebserviceID => 1,
    TestMode     => 1,
);

$Self->Is(
    ref $DebuggerObject,
    'Kernel::GenericInterface::Debugger',
    'DebuggerObject was correctly instantiated',
);

$DebuggerObject->DebugLog(
    DebugLevel => 'debug',
    Title      => 'Debug test title',
    Data       => 'Debug test data',
);

1;
