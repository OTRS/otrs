# --
# Test.t - Invoker tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Test.t,v 1.1 2011-02-10 19:57:09 cg Exp $
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
use Kernel::System::Time;
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Invoker;
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

# get the current time
my $CurrentTime = $Self->{TimeObject}->SystemTime();
my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $Self->{TimeObject}->SystemTime2Date(
    SystemTime => $CurrentTime,
);
$Min   = sprintf "%02d", $Min;
$Hour  = sprintf "%02d", $Hour;
$Day   = sprintf "%02d", $Day;
$Month = sprintf "%02d", $Month;
my $ReturnedTicketNumber = "$Year$Month$Day$Hour$Min";

# create a Invoker instance
my $InvokerObject = Kernel::GenericInterface::Invoker->new(
    %CommonObject,
    Invoker => 'Test::Test',
);
$Self->Is(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'InvokerObject was correctly instantiated',
);

# PrepareRequest Tests
my @InvokerPrepareRequestTests = (

    {
        Name          => 'Test no data',
        Data          => undef,
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name          => 'Test empty data',
        Data          => {},
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test wrong data',
        Data => {
            ASoWrongParameter => 'JustAValue',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test TicketID parameter empty value',
        Data => {
            TicketID => '',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },

    # Ask if is valid
    #    {
    #        Name   => 'Test TicketID parameter wrong value',
    #        Data   => {
    #            TicketID => 'asdf0987opiu',
    #        },
    #        ResultData => undef,
    #        ResultSuccess => 0,
    #    },
    {
        Name => 'Test Action parameter empty value',
        Data => {
            Action => '',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test Action parameter without TicketID',
        Data => {
            Action => 'Add',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test correct call just TicketID',
        Data => {
            TicketID => '12345',
        },
        ResultData => {
            TicketNumber => $ReturnedTicketNumber . '12345',
        },
        ResultSuccess => 1,
    },
    {
        Name => 'Test correct call TicketID and Action',
        Data => {
            TicketID => '12345',
            Action   => 'Add',
        },
        ResultData => {
            TicketNumber => $ReturnedTicketNumber . '12345',
            Action       => 'AddTest',
        },
        ResultSuccess => 1,
    },

);

for my $Test (@InvokerPrepareRequestTests) {
    my $InvokerResult = $InvokerObject->PrepareRequest(
        Data => $Test->{Data},
    );

    # check if function return correct status
    $Self->Is(
        $InvokerResult->{Success},
        $Test->{ResultSuccess},
        $Test->{Name} . ' (Success).',
    );

    # check if function return correct data
    $Self->IsDeeply(
        $InvokerResult->{Data},
        $Test->{ResultData},
        $Test->{Name} . ' (Data Structure).',
    );

    if ( !$Test->{ResultSuccess} ) {
        $Self->False(
            $InvokerResult->{Success},
            $Test->{Name} . ' (Error Message: ' .
                $InvokerResult->{ErrorMessage} . ')',
        );
    }
    else {
        $Self->Is(
            ref $InvokerObject,
            'Kernel::GenericInterface::Invoker',
            $Test->{Name} . ' (Not Error Message).',
        );
    }
}

# HandleResponse Tests
my @InvokerHandleResponseTests = (

    {
        Name          => 'Test no data',
        Data          => undef,
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name          => 'Test empty data',
        Data          => {},
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test wrong data',
        Data => {
            ASoWrongParameter => 'JustAValue',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test TicketID parameter empty value',
        Data => {
            TicketID => '',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test TicketID parameter wrong value',
        Data => {
            TicketID => 'asdf0987opiu',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test Action parameter empty value',
        Data => {
            Action => '',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test Action parameter without TicketID',
        Data => {
            Action => 'Add',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test correct call just TicketNumber',
        Data => {
            TicketNumber => $ReturnedTicketNumber . '12345',
        },
        ResultData => {
            TicketID => '12345',
        },
        ResultSuccess => 1,
    },
    {
        Name => 'Test correct call TicketNumber and Action',
        Data => {
            TicketNumber => $ReturnedTicketNumber . '12345',
            Action       => 'AddTest',
        },
        ResultData => {
            TicketID => '12345',
            Action   => 'Add',
        },
        ResultSuccess => 1,
    },

);

for my $Test (@InvokerHandleResponseTests) {
    my $InvokerResult = $InvokerObject->HandleResponse(
        Data => $Test->{Data},
    );

    # check if function return correct status
    $Self->Is(
        $InvokerResult->{Success},
        $Test->{ResultSuccess},
        $Test->{Name} . ' (Success).',
    );

    # check if function return correct data
    $Self->IsDeeply(
        $InvokerResult->{Data},
        $Test->{ResultData},
        $Test->{Name} . ' (Data Structure).',
    );

    if ( !$Test->{ResultSuccess} ) {
        $Self->False(
            $InvokerResult->{Success},
            $Test->{Name} . ' (Error Message: ' .
                $InvokerResult->{ErrorMessage} . ')',
        );
    }
    else {
        $Self->Is(
            ref $InvokerObject,
            'Kernel::GenericInterface::Invoker',
            $Test->{Name} . ' (Not Error Message).',
        );
    }
}

# complete cicle

# PrepareRequest call
my $InvokerResult = $InvokerObject->PrepareRequest(
    Data => {
        TicketID => '12345',
        Action   => 'Add',
    },
);

# check invoker call success
$Self->True(
    $InvokerResult->{Success},
    '(Complete Cicle) Check PrepareRequest call success.',
);

# returned data should match with expected data
$Self->IsDeeply(
    \%{$InvokerResult},
    {
        'Data' => {
            'Action'       => 'AddTest',
            'TicketNumber' => $ReturnedTicketNumber . '12345'
        },
        'Success' => 1
    },
    'Returned data should match with expected data.A',
);

# handleresponse call
$InvokerResult = $InvokerObject->HandleResponse(
    %{$InvokerResult},
);

# checkhandleresponse call success
$Self->True(
    $InvokerResult->{Success},
    '(Complete Cicle) Check HandleResponse call success.',
);

# HandleResponse data should match the initial data
$Self->IsDeeply(
    \%{$InvokerResult},
    {
        'Data' => {
            'Action'   => 'Add',
            'TicketID' => '12345'
        },
        'Success' => 1
    },
    'Returned data should match with expected data.',
);

1;
