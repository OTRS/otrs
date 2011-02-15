# --
# Invoker.t - Invoker tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Invoker.t,v 1.8 2011-02-15 16:24:07 mg Exp $
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
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Requester',
);

my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $Self->{TimeObject}->SystemTime2Date(
    SystemTime => $Self->{TimeObject}->SystemTime(),
);
$Sec   = sprintf "%02d", '00';
$Min   = sprintf "%02d", $Min;
$Hour  = sprintf "%02d", $Hour;
$Day   = sprintf "%02d", $Day;
$Month = sprintf "%02d", $Month;
my $CurrentTime = "$Year$Month$Day$Hour$Min$Sec";

my $InvokerObject;

# provide no objects
$InvokerObject = Kernel::GenericInterface::Invoker->new();
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, no arguments',
);

# correct call (without invoker info)
$InvokerObject = Kernel::GenericInterface::Invoker->new(%CommonObject);
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, no InvokerType',
);

# provide incorrect invoker
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    %CommonObject,
    InvokerType => 'ItShouldNotBeUsed::ItShouldNotBeUsed',
);
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, wrong InvokerType',
);

# correct call
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    %CommonObject,
    InvokerType => 'Test::Test',
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
        'TicketID' => '1',
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
        TicketNumber => $CurrentTime,
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
        TicketNumber => $CurrentTime,
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
        TicketNumber => $CurrentTime . '1',
    },
);
$Self->True(
    $ReturnData->{Success},
    'HandleResponse call with response success',
);

1;
