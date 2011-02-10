# --
# Invoker.t - Invoker tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Invoker.t,v 1.3 2011-02-10 16:21:11 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

# create needed objects
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Invoker;
my %CommonObject = %{$Self};
$CommonObject{DebuggerObject} = Kernel::GenericInterface::Debugger->new(
    %CommonObject,
    DebuggerConfig => {
        DebugLevel => 'debug',
    },
    WebserviceID => 1,
    TestMode     => 1,
);

my $InvokerObject;

# provide no objects
$InvokerObject = Kernel::GenericInterface::Invoker->new();
$Self->True(
    ref $InvokerObject eq 'HASH',
    'InvokerObject response check',
);
$Self->False(
    $InvokerObject->{Success},
    'InvokerObject required objects check',
);

# correct call (without invoker info)
$InvokerObject = Kernel::GenericInterface::Invoker->new(%CommonObject);
$Self->True(
    ref $InvokerObject eq 'HASH',
    'InvokerObject call without invoker info',
);

# provide incorrect invoker
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    %CommonObject,
    Invoker => 'ItShouldNotBeUsed::ItShouldNotBeUsed',
);
$Self->False(
    $InvokerObject->{Success},
    'InvokerObject invoker check',
);

# correct call
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    %CommonObject,
    Invoker => 'Test::Test',
);
$Self->Is(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'InvokerObject was correctly instantiated',
);

# PrepareRequest without data
my $ReturnData = $InvokerObject->PrepareRequest();
$Self->True(
    ref $ReturnData eq 'HASH',
    'PrepareRequest call without arguments',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'PrepareRequest call without arguments',
);

# PrepareRequest with empty data
$ReturnData = $InvokerObject->PrepareRequest(
    Data => {},
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'PrepareRequest call empty data provided',
);

# PrepareRequest with some data
$ReturnData = $InvokerObject->PrepareRequest(
    Data => {
        'TicketID' => '1',
    },
);
$Self->True(
    $ReturnData->{Success},
    'PrepareRequest call data provided',
);

# HandleResponse without data
$ReturnData = $InvokerObject->HandleResponse();
$Self->True(
    ref $ReturnData eq 'HASH',
    'HandleResponse without arguments',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'HandleResponse call without arguments',
);

# HandleResponse with empty data
$ReturnData = $InvokerObject->HandleResponse(
    Data => {},
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'HandleResponse call empty data provided',
);

# HandleResponse with some data
$ReturnData = $InvokerObject->HandleResponse(
    Data => {
        'TicketNumber' => '20110210171399',
    },
);
$Self->True(
    $ReturnData->{Success},
    'HandleResponse call data provided',
);

1;
