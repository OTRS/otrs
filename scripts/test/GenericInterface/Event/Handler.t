# --
# Handler.t - GenericInterface event handler tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Handler.t,v 1.5 2011-03-11 09:16:04 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use URI::Escape();

use Kernel::System::GenericInterface::Webservice;
use Kernel::System::GenericInterface::DebugLog;
use Kernel::System::Ticket;
use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $RandomID = $HelperObject->GetRandomID();

my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
my $DebugLogObject   = Kernel::System::GenericInterface::DebugLog->new( %{$Self} );
my $ConfigObject     = Kernel::Config->new();

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
        Name             => 'Asynchronous event call via scheduler',
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
        Name             => 'Synchronous event call - Webservice set to invald',
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
    {
        Name             => 'Synchronous event call - Empty Requester configuration',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Requester => {},
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

# unregister other ticket handlers
$ConfigObject->Set(
    Key   => 'Ticket::EventModulePost',
    Value => undef,
);

# register the genericinterface test handler only
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

my $Home = $ConfigObject->Get('Home');

# check if scheduler is running (start, if neccessary)
my $Scheduler = $Home . '/bin/otrs.Scheduler.pl';
if ( $^O =~ /^win/i ) {
    $Scheduler = $Home . '/bin/otrs.Scheduler4win.pl';
}
my $PreviousSchedulerStatus = `$Scheduler -a status`;

if ( !$PreviousSchedulerStatus ) {
    $Self->False(
        1,
        "Could not determine current scheduler status!",
    );
    die "Could not determine current scheduler status!";
}

if ( $PreviousSchedulerStatus =~ /^not running/i ) {
    my $Result = system("$Scheduler -a start");
    $Self->Is(
        $Result,
        0,
        "Scheduler start call returned successfully.",
    );
}
else {
    $Self->True(
        1,
        "Scheduler was already running.",
    );
}

my $CurrentSchedulerStatus = `$Scheduler -a status`;

$Self->True(
    $CurrentSchedulerStatus =~ /^running/i,
    "Scheduler is running",
);

if ( $CurrentSchedulerStatus !~ /^running/i ) {
    die "Scheduler could not be started.";
}
for my $Test (@Tests) {

    # add config
    my $WebserviceID = $WebserviceObject->WebserviceAdd(
        Config  => $Test->{WebserviceConfig},
        Name    => "$Test->{Name} $RandomID",
        ValidID => $Test->{ValidID},
        UserID  => 1,
    );

    $Self->True(
        $WebserviceID,
        "$Test->{Name} WebserviceAdd()",
    );

    #
    # Run actual test
    #

    my $TicketID;

    # enclose in block because the events are executed in destructor of ticket object
    {
        my $TicketObject = Kernel::System::Ticket->new(
            %{$Self},
            ConfigObject => $ConfigObject,
        );

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
    }

    # If this is asynchronous, wait for the scheduler to handle the task
    if ( $Test->{Asynchronous} ) {
        $Self->True(
            1,
            "Sleeping 10s to let the scheduler process the tasks...",
        );
        sleep 10;
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

# stop scheduler if it was not already running before this test
if ( $PreviousSchedulerStatus =~ /^not running/i ) {
    my $Result = system("$Scheduler -a stop");
    $Self->Is(
        $Result,
        0,
        "Scheduler start call returned successfully.",
    );

}

$CurrentSchedulerStatus = `$Scheduler -a status`;

$Self->Is(
    $CurrentSchedulerStatus,
    $PreviousSchedulerStatus,
    "Scheduler has original state again.",
);

1;
