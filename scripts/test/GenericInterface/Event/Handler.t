# --
# Handler.t - GenericInterface event handler tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Handler.t,v 1.1 2011-02-25 11:22:31 mg Exp $
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
        Event       => '(.*)',
        Transaction => 1,
    },
);

$Self->Is(
    $ConfigObject->Get('Ticket::EventModulePost')->{'1000-GenericInterface'}->{Module},
    'Kernel::GenericInterface::Event::Handler',
    "Event handler added to config",
);

# check if scheduler is running (start if neccessary)
my $Home      = $ConfigObject->Get('Home');
my $Scheduler = $Home . '/bin/otrs.Scheduler.pl';
if ( $^O =~ /^win/i ) {
    $Scheduler = $Home . '/bin/otrs.Scheduler4win.pl';
}
my $OriginalSchedulerStatus = `$Scheduler -a status`;
if ( $OriginalSchedulerStatus =~ /not running/i ) {
    `$Scheduler -a start`;
}

for my $Test (@Tests) {

    # add config
    my $WebserviceID = $WebserviceObject->WebserviceAdd(
        Config  => $Test->{WebserviceConfig},
        Name    => "$Test->{Name} $RandomID",
        ValidID => 1,
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
        sleep 7;
    }

    my $LogData = $DebugLogObject->LogSearch(
        CommunicationType => 'Requester',
        WebserviceID      => $WebserviceID,
        WithData          => 1,
    );

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

# Stop scheduler if it was not running in the first place
if ( $OriginalSchedulerStatus =~ /not running/i ) {
    `$Scheduler -a stop`;
}

1;
