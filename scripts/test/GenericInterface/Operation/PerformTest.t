# --
# PerformTest.t - Operations tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: PerformTest.t,v 1.1 2011-02-10 08:45:20 cr Exp $
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

# create a operation instance
my $OperationObject = Kernel::GenericInterface::Operation->new(
    %CommonObject,
    Operation => 'Test::PerformTest',
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
        Data          => {},
        ResultData    => undef,
        ResultSuccess => 0,
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

    if ( !$Test->{ResultSuccess} ) {
        $Self->False(
            $OperationResult->{Success},
            'Test data set ' . $Counter . ' (Error Message: ' .
                $OperationResult->{ErrorMessage} . ')',
        );
    }
    else {
        $Self->Is(
            ref $OperationObject,
            'Kernel::GenericInterface::Operation',
            'Test data set ' . $Counter . ' Test: Not Error Message.',
        );
    }
}

1;
