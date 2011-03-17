# --
# RequestSystemGuid.t - RequestSystemGuid Operation tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: RequestSystemGuid.t,v 1.1 2011-03-17 19:52:05 cg Exp $
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
my %CommonObject = %{$Self};
$CommonObject{DBObject}       = Kernel::System::DB->new(%CommonObject);
$CommonObject{DebuggerObject} = Kernel::GenericInterface::Debugger->new(
    %CommonObject,
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
);

# create object
my $OperationObject = Kernel::GenericInterface::Operation->new(
    %CommonObject,
    OperationType => 'SolMan::RequestSystemGuid',
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
    'RequestSystemGuid call response',
);

$Self->True(
    $ReturnData->{Success},
    'RequestSystemGuid call no data provided',
);
$Self->Is(
    length( $ReturnData->{Data}->{SystemGuid} ),
    32,
    'RequestSystemGuid call response',
);

# run with empty data
$ReturnData = $OperationObject->Run(
    Data => {},
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'RequestSystemGuid call response',
);
$Self->True(
    $ReturnData->{Success},
    'RequestSystemGuid call empty data provided',
);
$Self->Is(
    length( $ReturnData->{Data}->{SystemGuid} ),
    32,
    'RequestSystemGuid call response',
);

# run with invalid data
$ReturnData = $OperationObject->Run(
    Data => [],
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'RequestSystemGuid call response',
);
$Self->False(
    $ReturnData->{Success},
    'RequestSystemGuid call invalid data provided',
);
$Self->False(
    $ReturnData->{Data}->{SystemGuid},
    'RequestSystemGuid call response',
);

# run with some data
$ReturnData = $OperationObject->Run(
    Data => {
        'from' => 'to',
    },
);
$Self->True(
    $ReturnData->{Success},
    'RequestSystemGuid call data provided',
);
$Self->Is(
    length( $ReturnData->{Data}->{SystemGuid} ),
    32,
    'RequestSystemGuid call response',
);

1;
