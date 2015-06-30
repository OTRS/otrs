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

use URI::Escape();

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# unregister other ticket handlers
$ConfigObject->Set(
    Key   => 'Ticket::EventModulePost',
    Value => undef,
);

# register the generic interface test handler only
$ConfigObject->Set(
    Key   => 'Ticket::EventModulePost###1000-GenericInterface',
    Value => {
        Module      => 'Kernel::GenericInterface::Event::Handler',
        Event       => '.*',
        Transaction => 1,
    },
);

$Self->Is(
    $ConfigObject->Get('Ticket::EventModulePost')->{'1000-GenericInterface'}->{Module},
    'Kernel::GenericInterface::Event::Handler',
    "Event handler added to config",
);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreSystemConfiguration => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home = $ConfigObject->Get('Home');

my $Daemon = $Home . '/bin/otrs.Daemon.pl';

# get daemon status (stop if necessary to reload configuration with planner daemon disabled)
my $PreviousDaemonStatus = `$Daemon status`;

if ( !$PreviousDaemonStatus ) {
    $Self->False(
        1,
        "Could not determine current daemon status!",
    );
    die "Could not determine current daemon status!";
}

if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {

    my $ResultMessage = system("$Daemon stop");
}
else {
    $Self->True(
        1,
        "Daemon was already stopped.",
    );
}

# Wait for slow systems
my $SleepTime = 120;
print "Waiting at most $SleepTime s until daemon stops\n";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my $DaemonStatus = `$Daemon status`;
    if ( $DaemonStatus =~ m{Daemon not running}i ) {
        last ACTIVESLEEP;
    }
    print "Sleeping for $Seconds seconds...\n";
    sleep 1;
}

my $CurrentDaemonStatus = `$Daemon status`;

$Self->True(
    int $CurrentDaemonStatus =~ m{Daemon not running}i,
    "Daemon is not running",
);

if ( $CurrentDaemonStatus !~ m{Daemon not running}i ) {
    die "Daemon could not be stopped.";
}

my @Tests = (
    {
        Name             => 'Synchronous event call',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
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
                        Type   => 'Test::TestSimple',
                        Events => [
                            {
                                Event        => 'TicketCreate',
                                Asynchronous => 0,
                            },
                        ],
                    },
                },
            },
        },
        Asynchronous => 0,
        ValidID      => 1,
        Success      => 1,
    },
    {
        Name             => 'Asynchronous event call via scheduler daemon',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
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
                        Type   => 'Test::TestSimple',
                        Events => [
                            {
                                Event        => 'TicketCreate',
                                Asynchronous => 1,
                            },
                        ],
                    },
                },
            },
        },
        Asynchronous => 1,
        ValidID      => 1,
        Success      => 1,
    },
    {
        Name             => 'Synchronous event call - Web service set to invalid',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
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
                        Type   => 'Test::TestSimple',
                        Events => [
                            {
                                Event        => 'TicketCreate',
                                Asynchronous => 0,
                            },
                        ],
                    },
                },
            },
        },
        Asynchronous => 0,
        ValidID      => 2,
        Success      => 0,
    },

    # to add the Web Service is needed to have the Requester Transport and Type
    {
        Name             => 'Synchronous event call - Empty Requester configuration',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Requester => {
                Transport => {
                    Type => '',
                },
            },
        },
        Asynchronous => 0,
        ValidID      => 1,
        Success      => 0,
    },
    {
        Name             => 'Synchronous event call - Empty Invoker configuration',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Invoker => {},
            },
        },
        Asynchronous => 0,
        ValidID      => 1,
        Success      => 0,
    },
    {
        Name             => 'Synchronous event call - Invalid Invoker events (not a hash ref)',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
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
                        Type   => 'Test::TestSimple',
                        Events => {
                            Event        => 'TicketCreate',
                            Asynchronous => 0,
                        },
                    },
                },
            },
        },
        Asynchronous => 0,
        ValidID      => 1,
        Success      => 0,
    },
    {
        Name             => 'Synchronous event call - Different Event',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
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
                        Type   => 'Test::TestSimple',
                        Events => [
                            {
                                Event        => 'TicketMove',
                                Asynchronous => 0,
                            },
                        ],
                    },
                },
            },
        },
        Asynchronous => 0,
        ValidID      => 1,
        Success      => 0,
    },
);

# get needed objects
my $WebserviceObject  = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
my $DebugLogObject    = $Kernel::OM->Get('Kernel::System::GenericInterface::DebugLog');
my $TaskWorkerObject  = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker');
my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

my $RandomID = $HelperObject->GetRandomID();

for my $Test (@Tests) {

    # add config
    my $WebserviceID = $WebserviceObject->WebserviceAdd(
        Config  => $Test->{WebserviceConfig},
        Name    => "$Test->{Name} $RandomID",
        ValidID => $Test->{ValidID},
        UserID  => 1,
    );

    $Self->IsNot(
        $WebserviceID,
        undef,
        "$Test->{Name} WebserviceAdd() - should not be undef",
    );

    #
    # Run actual test
    #

    my $TicketID;

    # enclose in block because the events are executed in destructor of ticket object
    {
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        $TicketID = $TicketObject->TicketCreate(
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'closed successful',
            CustomerNo   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "$Test->{Name} TicketCreate()",
        );

        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::Ticket'],
        );
    }

    # If this is asynchronous, wait for the daemon to handle the task
    if ( $Test->{Asynchronous} ) {

        # Wait for slow systems
        my $SleepTime = 5;
        print "Waiting at most $SleepTime s until tasks are registered\n";
        ACTIVESLEEP:
        for my $Seconds ( 1 .. $SleepTime ) {
            my @List = $SchedulerDBObject->TaskList(
                Type => 'GenericInterface',
            );
            last ACTIVESLEEP if scalar @List;
            print "Sleeping for $Seconds seconds...\n";
            sleep 1;
        }

        # run worker tasks
        my $Success = $TaskWorkerObject->Run();
        $Self->True(
            $Success,
            'TaskWorker Run() - To execute current tasks, with true',
        );

        my $TotalWaitToExecute = 120;

        # wait for daemon children to actually execute tasks
        WAITEXECUTE:
        for my $Wait ( 1 .. $TotalWaitToExecute ) {
            print "Waiting for Daemon to execute tasks, $Wait seconds\n";
            sleep 1;

            my @List = $SchedulerDBObject->TaskList(
                Type => 'GenericInterface',
            );

            if ( scalar @List eq 0 ) {
                $Self->True(
                    1,
                    "$Test->{Name} - all tasks are dropped from task list",
                );
                last WAITEXECUTE;
            }

            next WAITEXECUTE if $Wait < $TotalWaitToExecute;

            $Self->True(
                0,
                "$Test->{Name} - all tasks are not dropped from task list after $TotalWaitToExecute seconds!",
            );
        }
    }

    my $LogData = $DebugLogObject->LogSearch(
        CommunicationType => 'Requester',
        WebserviceID      => $WebserviceID,
        WithData          => 1,
    );

    if ( $Test->{Success} ) {
        $Self->Is(
            scalar @{$LogData},
            1,
            "$Test->{Name} log data found",
        );

        $Self->Is(
            ref $LogData->[0],
            'HASH',
            "$Test->{Name} log data found entry",
        );

        $Self->Is(
            ref $LogData->[0]->{Data},
            'ARRAY',
            "$Test->{Name} log data found data entry",
        );

        $Self->Is(
            scalar(
                grep { $_->{Data} =~ m/'ResponseContent' \s+ => \s+ 'TicketID=$TicketID'/smx }
                    @{ $LogData->[0]->{Data} }
            ),
            1,
            "$Test->{Name} event handler communication result data found ('ResponseContent' => 'TicketID=$TicketID')",
        );
    }
    else {
        $Self->Is(
            scalar @{$LogData},
            0,
            "$Test->{Name} no log data found",
        );
    }

    # delete config
    my $Success = $WebserviceObject->WebserviceDelete(
        ID     => $WebserviceID,
        UserID => 1,
    );

    $Self->True(
        $Success,
        "$Test->{Name} WebserviceDelete()",
    );
}

# start daemon if it was already running before this test
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    my $Result = system("$Daemon start");
    $Self->Is(
        $Result,
        0,
        "Daemon start call returned successfully.",
    );

    # Wait for slow systems
    my $SleepTime = 120;
    print "Waiting at most $SleepTime s until daemon start\n";
    ACTIVESLEEP:
    for my $Seconds ( 1 .. $SleepTime ) {
        my $DaemonStatus = `$Daemon status`;
        if ( $DaemonStatus =~ m{Daemon running}i ) {
            last ACTIVESLEEP;
        }
        print "Sleeping for $Seconds seconds...\n";
        sleep 1;
    }
}

$CurrentDaemonStatus = `$Daemon status`;

$Self->Is(
    $CurrentDaemonStatus,
    $PreviousDaemonStatus,
    "Daemon has original state again.",
);

1;
