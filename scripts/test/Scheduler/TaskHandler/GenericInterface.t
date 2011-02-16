# --
# GenericInterface.t - Generic Interface Scheduler Task Handler Backend tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: GenericInterface.t,v 1.2 2011-02-16 08:26:44 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::GenericInterface::Webservice;
use Kernel::GenericInterface::Requester;
use Kernel::System::UnitTest::Helper;
use Kernel::Scheduler;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
my $RequesterObject  = Kernel::GenericInterface::Requester->new( %{$Self} );
my $SchedulerObject  = Kernel::Scheduler->new( %{$Self} );

my $RandomID = $HelperObject->GetRandomID();

# webservice config
my $WebserviceConfig = {
    Debugger => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    Requester => {
        Transport => {
            Type   => 'HTTP::Test',
            Config => {
                Fail => 0,
            },
        },
        Invoker => {
            test_operation => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# add webserver config
my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Config  => $WebserviceConfig,
    Name    => "GenericInterface Scheduler Task Manager Backend Test $RandomID",
    ValidID => 1,
    UserID  => 1,
);

$Self->IsNot(
    $WebserviceID,
    undef,
    "WebserviceAdd()",
);

# task config
my @TaskList = (
    {
        Name         => 'Normal',
        WebserviceID => $WebserviceID,
        Invoker      => 'test_operation',
        Data         => {
            var1 => 'a',
        },
        Execute => 1,
    },
    {
        Name         => 'Empty Data',
        WebserviceID => $WebserviceID,
        Invoker      => 'test_operation',
        Data         => {
        },
        Execute => 0,
    },
    {
        Name         => 'Empty Invoker',
        WebserviceID => $WebserviceID,
        Invoker      => '',
        Data         => {
            var1 => 'a',
        },
        Execute => 0,
    },
    {
        Name         => 'No WebService',
        WebserviceID => 0,
        Invoker      => 'test_operation',
        Data         => {
            var1 => 'a',
        },
        Execute => 0,
    },
    {
        Name         => 'Undefined Data',
        WebserviceID => $WebserviceID,
        Invoker      => 'test_operation',
        Data         => undef,
        Execute      => 0,
    },
    {
        Name         => 'Undefined Invoker',
        WebserviceID => $WebserviceID,
        Invoker      => undef,
        Data         => {
            var1 => 'a',
        },
        Execute => 0,
    },
    {
        Name         => 'Undefined WebService',
        WebserviceID => undef,
        Invoker      => 'test_operation',
        Data         => {
            var1 => 'a',
        },
        Execute => 0,
    },
    {
        Name         => 'Wrong invoker',
        WebserviceID => $WebserviceID,
        Invoker      => 'no_configured_invoker',
        Data         => {
            var1 => 'a',
        },
        Execute => 0,
    },
    {
        Name         => 'Wrong Service ID',
        WebserviceID => 9999999,
        Invoker      => 'test_operation',
        Data         => {
            var1 => 'a',
        },
        Execute => 0,
    },
    {
        Name    => 'Empty task data',
        Execute => 0,
    },
);

for my $TaskData (@TaskList) {

    # register task
    my $TaskID = $SchedulerObject->TaskRegister(
        Type => 'GenericInterface',
        Data => $TaskData,
    );
    $Self->True(
        $TaskID,
        "$TaskData->{Name} Test TaskRegister()",
    );

    # execute task
    my $Result = $SchedulerObject->Run();

    if ( $TaskData->{Execute} ) {
        $Self->IsNot(
            $Result,
            undef,
            "$TaskData->{Name} Test SchedulerRun()",
        );
    }
    else {
        $Self->Is(
            $Result,
            undef,
            "$TaskData->{Name} Test SchedulerRun()",
        );
    }
}

# delete webserice config
my $Success = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);

$Self->IsNot(
    $Success,
    undef,
    "WebserviceDelete()",
);

1;
