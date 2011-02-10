# --
# Operation.t - Operation tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Operation.t,v 1.1 2011-02-10 08:45:20 cr Exp $
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
        DebugLevel => 'debug',
    },
    WebserviceID => 1,
    TestMode     => 1,
);

# create object with false options
my $OperationObject;

# provide no objects
$OperationObject = Kernel::GenericInterface::Operation->new();
$Self->True(
    ref $OperationObject eq 'HASH',
    'OperationObject response check',
);
$Self->False(
    $OperationObject->{Success},
    'OperationObject required objects check',
);

# provide empty operation
$OperationObject = Kernel::GenericInterface::Operation->new(
    %CommonObject,
    Operation => {},
);
$Self->False(
    $OperationObject->{Operation},
    'OperationObject required operation check',
);

# provide incorrect operation
$OperationObject = Kernel::GenericInterface::Operation->new(
    %CommonObject,
    MappingConfig => {
        Type => 'Test::ThisIsCertainlyNotBeingUsed',
    },
);
$Self->False(
    $OperationObject->{Success},
    'OperationObject operation check',
);

# create object
$OperationObject = Kernel::GenericInterface::Operation->new(
    %CommonObject,
    Operation => 'Test::PerformTest',
);
$Self->Is(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'OperationObject creation check',
);

# run without data
my $ReturnData = $OperationObject->Run();
$Self->True(
    ref $ReturnData eq 'HASH',
    'OperationObject call response',
);
$Self->False(
    $ReturnData->{Success},
    'OperationObject call no data provided',
);

# run with empty data
$ReturnData = $OperationObject->Run(
    Data => {},
);
$Self->False(
    $ReturnData->{Success},
    'OperationObject call empty data provided',
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
