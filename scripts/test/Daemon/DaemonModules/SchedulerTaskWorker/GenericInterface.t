# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# prevent mails send
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# web service config
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

# get helper object
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID     = $HelperObject->GetRandomID();

# freeze time
$HelperObject->FixedTimeSet();

# get web service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

# add web service config
my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Config  => $WebserviceConfig,
    Name    => "GenericInterface Scheduler Task Manager Backend Test $RandomID",
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $WebserviceID,
    "WebserviceAdd()",
);

# task config
my @Test = (
    {
        Name   => 'Empty',
        Config => {},
        Result => 0,
    },
    {
        Name   => 'Missing TaskID',
        Config => {
            TaskName => 'UnitTest',
            Data     => {
                Command => '/bin/df',
                Params  => '-h',
            },
        },
        Result => 0,
    },
    {
        Name   => 'Missing Data',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
        },
        Result => 0,
    },
    {
        Name   => 'Empty Invoker',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                WebserviceID => $WebserviceID,
                Invoker      => '',
                Data         => {
                    var1 => 'a',
                },
            },
        },
        Result => 0,
    },
    {
        Name   => 'No WebService',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                WebserviceID => 0,
                Invoker      => 'test_operation',
                Data         => {
                    var1 => 'a',
                },
            },
        },
        Result => 0,
    },
    {
        Name   => 'Undefined Data',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                WebserviceID => $WebserviceID,
                Invoker      => 'test_operation',
                Data         => undef,
            },
        },
        Result => 0,
    },
    {
        Name   => 'Undefined Invoker',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                WebserviceID => $WebserviceID,
                Invoker      => undef,
                Data         => {
                    var1 => 'a',
                },
            },
        },
        Result => 0,
    },
    {
        Name   => 'Undefined WebService',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                WebserviceID => undef,
                Invoker      => 'test_operation',
                Data         => {
                    var1 => 'a',
                },
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong invoker',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                WebserviceID => $WebserviceID,
                Invoker      => 'no_configured_invoker',
                Data         => {
                    var1 => 'a',
                },
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Webservice ID',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                WebserviceID => 9999999,
                Invoker      => 'test_operation',
                Data         => {
                    var1 => 'a',
                },
            },
        },
        Result => 0,
    },
    {
        Name   => 'Normal',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                WebserviceID => $WebserviceID,
                Invoker      => 'test_operation',
                Data         => {
                    var1 => 'a',
                },
            },
        },
        Result => 1,
    },
    {
        Name   => 'Empty Data',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                WebserviceID => $WebserviceID,
                Invoker      => 'test_operation',
                Data         => {
                },
            },
        },
        Result => 1,
    },
    {
        Name   => 'ReSchedule',
        Config => {
            TaskID   => 123,
            TaskName => 'Invoker-test_operation',
            Data     => {
                WebserviceID => $WebserviceID,
                Invoker      => 'test_operation',
                Data         => {
                    ReSchedule => 1,
                },
            },
        },
        Result             => 0,
        Reschedule         => 1,
        RescheculeTimeDiff => 300,
    },
    {
        Name   => 'ReSchedule ExecutionTime',
        Config => {
            TaskID   => 123,
            TaskName => 'Invoker-test_operation',
            Data     => {
                WebserviceID => $WebserviceID,
                Invoker      => 'test_operation',
                Data         => {
                    ReSchedule    => 1,
                    ExecutionTime => '2030-12-12 12:00:00',
                },
            },
        },
        Result                  => 0,
        Reschedule              => 1,
        RescheculeExecutionTime => '2030-12-12 12:00:00',
    },

);

# get needed objects
my $TaskHandlerObject
    = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericInterface');
my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');
my $TimeObject        = $Kernel::OM->Get('Kernel::System::Time');

TEST:
for my $Test (@Test) {

    # result task
    my $Result = $TaskHandlerObject->Run( %{ $Test->{Config} } );

    $Self->Is(
        $Result || 0,
        $Test->{Result},
        "$Test->{Name} - execution result",
    );

    if ( $Test->{Reschedule} ) {

        # get a list of all future task
        my @ListRaw = $SchedulerDBObject->FutureTaskList(
            Type => 'GenericInterface',
        );

        # filter only the ones for this invoker
        my @List = grep { $_->{Name} eq 'Invoker-' . $Test->{Config}->{Data}->{Invoker} } @ListRaw;

        $Self->Is(
            scalar @List,
            1,
            "$Test->{Name} FutureTaskList - exists with only 1 element"
        );

        my $TaskID = $List[0]->{TaskID};

        my %Task = $SchedulerDBObject->FutureTaskGet(
            TaskID => $TaskID,
        );

        my $ExecutionTime = $Test->{RescheculeExecutionTime};
        if ( !$ExecutionTime ) {

            $ExecutionTime = $TimeObject->SystemTime2TimeStamp(
                SystemTime => $TimeObject->SystemTime() + $Test->{RescheculeTimeDiff},
            );
        }

        my $TimeStamp = $TimeObject->CurrentTimestamp();

        $Self->IsDeeply(
            \%Task,
            {
                TaskID        => $TaskID,
                ExecutionTime => $ExecutionTime,
                Name          => $Test->{Config}->{TaskName},
                Type          => 'GenericInterface',
                Data          => $Test->{Config}->{Data},
                Attempts      => 10,
                LockKey       => 0,
                LockTime      => '',
                CreateTime    => $TimeStamp,
            },
            "$Test->{Name} FutureTask - TaskData",
        );

        my $Success = $SchedulerDBObject->FutureTaskDelete(
            TaskID => $List[0]->{TaskID},
        );

        $Self->True(
            $Success,
            "$Test->{Name} FutureTaskDelete() - for TaskID $List[0]->{TaskID} with true",
        );

    }
}

# delete web service config
my $Success = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);

$Self->True(
    $Success,
    "WebserviceDelete()",
);

1;
