# --
# Invoker.t - Invoker tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Invoker.t,v 1.1 2011-02-09 17:06:52 cg Exp $
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
use Kernel::GenericInterface::Invoker;
my $DBObject       = Kernel::System::DB->new( %{$Self} );
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DBObject       => $DBObject,
    DebuggerConfig => {
        DebugLevel => 'debug',
    },
    WebserviceID => 1,
    TestMode     => 1,
);

# correct call (with empty config)
my $InvokerObject = Kernel::GenericInterface::Invoker->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    Invoker        => 'Test::Test',
);
$Self->Is(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'InvokerObject was correctly instantiated',
);

#print STDERR $Self->{MainObject}->Dump(\$InvokerObject);

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
        'from' => 'to',
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
        'from' => 'to',
    },
);
$Self->True(
    $ReturnData->{Success},
    'HandleResponse call data provided',
);

#HandleResponse
#print STDERR $ReturnData->{ErrorMessage};
#print STDERR $Self->{MainObject}->Dump(\$ReturnData);

1;
