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
        Name   => 'Wrong Data',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => 1,
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
        Name   => 'Missing Command and Module',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Params => '-h',
            },
        },
        Result => 0,
    },
    {
        Name   => 'Command and Module',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Command => '/bin/df',
                Module  => 'Kernel::System::Console::Command::Maint::Ticket::Dump',
                Params  => '-h',
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong External Command',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Command => '/bin/OTRSnotexisitng',
                Params  => '-h',
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Console Module',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Console::Command::Maint::Ticket::Test',
                Function => 'Execute',
                Params   => '-h',
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Console Module Function',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Console::Command::Admin::Group::Add',
                Function => 'Execute',
                Params   => '--no-ansi',
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Console Module Params',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Console::Command::Admin::Group::Add',
                Function => 'Execute',
                Params   => '-h',
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Core Module Function',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Priority',
                Function => 'Test',
                Params   => 'PriorityID 1',
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Core Module Params',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Priority',
                Function => 'PriorityLookup',
                Params   => 'TicketID 1',
            },
        },
        Result => 0,
    },

    # there is a bug in current Ubuntu 12 with DF it produces a message in the STDERR that
    #   the daemon catches and sets the command as a failure, the message reads
    #   df: `/sys/kernel/debug': Function not implemented, please also take a look at:
    #   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1465322
    # {
    #     Name   => 'External Command',
    #     Config => {
    #         TaskID   => 123,
    #         TaskName => 'UnitTest',
    #         Data     => {
    #             Command => '/bin/df',
    #             Params  => '-h',
    #         },
    #     },
    #     Result => 1,
    # },
    {
        Name   => 'External Command',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Command => '/bin/ls',
                Params  => '-l',
            },
        },
        Result => 1,
    },
    {
        Name   => 'Internal Command',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Command => '$OTRSHOME/bin/otrs.CheckModules.pl',
                Params  => '',
            },
        },
        Result => 1,
    },
    {
        Name   => 'Console Command Module',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Console::Command::Maint::Ticket::Dump',
                Function => 'Execute',
                Params   => '--article-limit 2 1',
            },
        },
        Result => 1,
    },
    {
        Name   => 'Core Module',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Priority',
                Function => 'PriorityLookup',
                Params   => 'PriorityID 1',
            },
        },
        Result => 1,
    },
);

# get task handler object
my $TaskHandlerObject = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::Cron');

for my $Test (@Tests) {

    # result task
    my $Result = $TaskHandlerObject->Run( %{ $Test->{Config} } );

    $Self->Is(
        $Result || 0,
        $Test->{Result},
        "$Test->{Name} - execution result",
    );
}

1;
