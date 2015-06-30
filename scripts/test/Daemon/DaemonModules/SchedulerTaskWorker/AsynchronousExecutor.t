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

use Kernel::System::ObjectManager;

use vars (qw($Self));

# prevent mails send
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

my @Tests = (
    {
        Name   => 'Empty Config',
        Config => {},
        Result => 0,
    },
    {
        Name   => 'Missing TaskID',
        Config => {
            TaskName => 'UnitTest',
            Data     => {
                Object   => 'Kernel::System::Ticket',
                Function => 'TicketPriorityList',
                Params   => {
                    TicketID => 1,
                    UserID   => 1,
                },
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
        Name   => 'Invalid Data',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => 1,
        },
        Result => 0,
    },
    {
        Name   => 'Invalid Data 2',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => ['1'],
        },
        Result => 0,
    },
    {
        Name   => 'Empty Data',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {},
        },
        Result => 0,
    },
    {
        Name   => 'Missing Function',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Object => 'Kernel::System::Ticket',
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Params format',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Object   => 'Kernel::System::Ticket',
                Function => 'TicketPriorityList',
                Params   => 1,
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Object',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Object   => 'Kernel::System::TicketWRONG',
                Function => 'TicketPriorityList',
                Params   => {
                    TicketID => 1,
                    UserID   => 1,
                },
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Function',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Object   => 'Kernel::System::Ticket',
                Function => 'TicketPriorityListWRONG',
                Params   => {
                    TicketID => 1,
                    UserID   => 1,
                },
            },
        },
        Result => 0,
    },
    {
        Name   => 'Correct with parameters',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Object   => 'Kernel::System::Ticket',
                Function => 'TicketPriorityList',
                Params   => {
                    TicketID => 1,
                    UserID   => 1,
                },
            },
        },
        Result => 1,
    },
    {
        Name   => 'Correct with empty parameters',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Object   => 'Kernel::System::Ticket',
                Function => 'TicketPriorityList',
                Params   => {},
            },
        },
        Result => 0,
    },
    {
        Name   => 'Correct without parameters',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Object   => 'Kernel::System::Ticket',
                Function => 'TicketPriorityList',
            },
        },
        Result => 0,
    },
);

# get task handler objects
my $TaskHandlerObject
    = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::AsynchronousExecutor');

for my $Test (@Tests) {

    # result task
    my $Result = $TaskHandlerObject->Run( %{ $Test->{Config} } );

    $Self->Is(
        $Result || 0,
        $Test->{Result},
        "$Test->{Name} execution result",
    );
}

1;
