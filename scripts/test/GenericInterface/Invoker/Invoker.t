# --
# Invoker.t - Invoker tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Requester',
);

my $InvokerObject;

# provide no objects
$InvokerObject = Kernel::GenericInterface::Invoker->new();
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, no arguments',
);

# correct call (without invoker info)
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    DebuggerObject => $DebuggerObject,
    WebserviceID   => 1,
);
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, no InvokerType',
);

# provide incorrect invoker
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    DebuggerObject => $DebuggerObject,
    InvokerType    => 'ItShouldNotBeUsed::ItShouldNotBeUsed',
    WebserviceID   => 1,
);
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, wrong InvokerType',
);

# provide no WebserviceID
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    DebuggerObject => $DebuggerObject,
    InvokerType    => 'Test::Test',
);
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, wrong InvokerType',
);

# correct call
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    DebuggerObject => $DebuggerObject,
    InvokerType    => 'Test::Test',
    WebserviceID   => 1,
);
$Self->Is(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'InvokerObject was correctly instantiated',
);

# PrepareRequest without data
my $ReturnData = $InvokerObject->PrepareRequest();
$Self->Is(
    ref $ReturnData,
    'HASH',
    'PrepareRequest call without arguments',
);
$Self->False(
    $ReturnData->{Success},
    'PrepareRequest call without arguments success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'PrepareRequest call without arguments error message',
);

# PrepareRequest with empty data
$ReturnData = $InvokerObject->PrepareRequest(
    Data => {},
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'PrepareRequest call empty data',
);
$Self->False(
    $ReturnData->{Success},
    'PrepareRequest call empty data success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'PrepareRequest call empty data error message',
);

# PrepareRequest with some data
$ReturnData = $InvokerObject->PrepareRequest(
    Data => {
        TicketNumber => '1',
    },
);
$Self->True(
    $ReturnData->{Success},
    'PrepareRequest call data provided',
);

# HandleResponse without data
$ReturnData = $InvokerObject->HandleResponse();
$Self->Is(
    ref $ReturnData,
    'HASH',
    'HandleResponse without arguments',
);
$Self->False(
    $ReturnData->{Success},
    'HandleResponse call without arguments success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'HandleResponse call without arguments error message',
);

# HandleResponse with empty data
$ReturnData = $InvokerObject->HandleResponse(
    Data => {},
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'HandleResponse empty data',
);
$Self->False(
    $ReturnData->{Success},
    'HandleResponse call empty data success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'HandleResponse call empty data error message',
);

# HandleResponse with some data
$ReturnData = $InvokerObject->HandleResponse(
    ResponseSuccess => '0',
    Data            => {
        TicketNumber => '1345',
    },
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'HandleResponse response failure without error message',
);
$Self->False(
    $ReturnData->{Success},
    'HandleResponse response failure without error message success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'HandleResponse call response failure without error message error message',
);

$ReturnData = $InvokerObject->HandleResponse(
    ResponseSuccess      => '0',
    ResponseErrorMessage => 'Just an error message.',
    Data                 => {
        TicketNumber => '123',
    },
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'HandleResponse response failure ',
);
$Self->False(
    $ReturnData->{Success},
    'HandleResponse response failure success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'HandleResponse call response failure error message',
);

# HandleResponse with some data (Success)
$ReturnData = $InvokerObject->HandleResponse(
    ResponseSuccess => '1',
    Data            => {
        TicketNumber => '234',
    },
);
$Self->True(
    $ReturnData->{Success},
    'HandleResponse call with response success',
);

1;
