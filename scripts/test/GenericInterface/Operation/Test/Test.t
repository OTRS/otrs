# --
# Test.t - Operations tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Test.t,v 1.3 2011-03-24 09:46:46 mg Exp $
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

# create a operation instance
my $OperationObject = Kernel::GenericInterface::Operation->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    OperationType  => 'Test::Test',
);
$Self->Is(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'OperationObject was correctly instantiated',
);

my @OperationTests = (
    {
        Data => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultSuccess => 1,
    },
    {
        Data          => [],
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Data          => undef,
        ResultData    => undef,
        ResultSuccess => 1,
    },
    {
        Data          => {},
        ResultData    => {},
        ResultSuccess => 1,
    },
);

my $Counter;
for my $Test (@OperationTests) {
    $Counter++;
    my $OperationResult = $OperationObject->Run(
        Data => $Test->{Data},
    );

    # check if function return correct status
    $Self->Is(
        $OperationResult->{Success},
        $Test->{ResultSuccess},
        'Test data set ' . $Counter . ' Test: Success.',
    );

    # check if function return correct data
    $Self->IsDeeply(
        $OperationResult->{Data},
        $Test->{ResultData},
        'Test data set ' . $Counter . ' Test: Data Structure.',
    );

    $Self->Is(
        $OperationResult->{Success},
        $Test->{ResultSuccess},
        'Test data set ' . $Counter . ' success status',
    );
}

1;
