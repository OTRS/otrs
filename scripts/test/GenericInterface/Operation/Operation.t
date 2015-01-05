# --
# Operation.t - Operation tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: Operation.t,v 1.6 2011-03-29 12:36:15 mg Exp $
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
use Kernel::GenericInterface::Operation;
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
);

# create object with false options
my $OperationObject;

# provide no objects
$OperationObject = Kernel::GenericInterface::Operation->new();
$Self->IsNot(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() fail check, no arguments',
);

# provide empty operation
$OperationObject = Kernel::GenericInterface::Operation->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    WebserviceID   => 1,
    OperationType  => {},
);
$Self->IsNot(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() fail check, no OperationType',
);

# provide incorrect operation
$OperationObject = Kernel::GenericInterface::Operation->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    WebserviceID   => 1,
    OperationType  => 'Test::ThisIsCertainlyNotBeingUsed',
);
$Self->IsNot(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() fail check, wrong OperationType',
);

# provide no WebserviceID
$OperationObject = Kernel::GenericInterface::Operation->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    OperationType  => 'Test::Test',
);
$Self->IsNot(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() fail check, no WebserviceID',
);

# create object
$OperationObject = Kernel::GenericInterface::Operation->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    WebserviceID   => 1,
    OperationType  => 'Test::Test',
);
$Self->Is(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() success',
);

# run without data
my $ReturnData = $OperationObject->Run();
$Self->Is(
    ref $ReturnData,
    'HASH',
    'OperationObject call response',
);
$Self->True(
    $ReturnData->{Success},
    'OperationObject call no data provided',
);

# run with empty data
$ReturnData = $OperationObject->Run(
    Data => {},
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'OperationObject call response',
);
$Self->True(
    $ReturnData->{Success},
    'OperationObject call empty data provided',
);

# run with invalid data
$ReturnData = $OperationObject->Run(
    Data => [],
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'OperationObject call response',
);
$Self->False(
    $ReturnData->{Success},
    'OperationObject call invalid data provided',
);

# run with some data
$ReturnData = $OperationObject->Run(
    Data => {
        'from' => 'to',
    },
);
$Self->True(
    $ReturnData->{Success},
    'OperationObject call data provided',
);

1;
