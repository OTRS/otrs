# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Set some config options for the testing.
$ConfigObject->Set(
    Key   => 'OTRSTimeZone',
    Value => 'UTC',
);

my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

my $StatsObject    = $Kernel::OM->Get('Kernel::System::Stats');
my $QueueObject    = $Kernel::OM->Get('Kernel::System::Queue');
my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# create new queues
my @QueueNames;
my @QueueIDs;

for my $Count ( 1 .. 2 ) {

    my $QueueName = "Statistic-$Count-Queue-" . $RandomID;
    my $QueueID   = $QueueObject->QueueAdd(
        Name            => "Statistic-$Count-Queue-" . $RandomID,
        ValidID         => 1,
        GroupID         => 1,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        Comment         => 'Some comment',
        UserID          => 1,
    );

    # sanity check
    $Self->True(
        $QueueID,
        "QueueAdd() successful for test - QueueID $QueueID",
    );

    push @QueueIDs,   $QueueID;
    push @QueueNames, $QueueName;
}

# define the tickets for the statistic result tests
my @Tickets = (

    # add the ticket in the first statistic queue
    {
        TimeStamp  => '2014-10-10 08:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[0],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => 'example + test',
            CustomerUser => 'customer1@example.com',
            OwnerID      => 1,
            UserID       => 1,
            AccountTimes => [
                60,
                100,
            ],
        },
    },
    {
        TimeStamp  => '2014-10-12 08:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[0],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => 'example + test',
            CustomerUser => 'customer1@example.com',
            OwnerID      => 1,
            UserID       => 1,
            AccountTimes => [
                30,
            ],
        },
    },
    {
        TimeStamp  => '2014-10-14 08:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[1],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => 'example + test',
            CustomerUser => 'customer1@example.com',
            OwnerID      => 1,
            UserID       => 1,
            AccountTimes => [
                10.5,
                30,
            ],
        },
    },
    {
        TimeStamp  => '2014-10-11 08:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[1],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => 'example + test',
            CustomerUser => 'customer1@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },
);

my @TicketIDs;

TICKET:
for my $Ticket (@Tickets) {

    # check TicketData attribute
    if ( !$Ticket->{TicketData} || ref $Ticket->{TicketData} ne 'HASH' ) {

        $Self->True(
            0,
            "No TicketData found for this test ticket.",
        );
        next TICKET;
    }

    my $SystemTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Ticket->{TimeStamp},
        }
    )->ToEpoch();

    # set the fixed time
    $Helper->FixedTimeSet($SystemTime);

    # create the ticket
    my $TicketID = $TicketObject->TicketCreate(
        %{ $Ticket->{TicketData} },
    );

    # sanity check
    $Self->True(
        $TicketID,
        "TicketCreate() successful for test - TicketID $TicketID",
    );

    if ( IsArrayRefWithData( $Ticket->{TicketData}->{AccountTimes} ) ) {

        for my $AccountTime ( @{ $Ticket->{TicketData}->{AccountTimes} } ) {

            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
                From                 => 'Agent Some Agent Some Agent <email@example.com>',
                To                   => 'Customer A <customer-a@example.com>',
                Cc                   => 'Customer B <customer-b@example.com>',
                ReplyTo              => 'Customer B <customer-b@example.com>',
                Subject              => 'some short subject',
                Body                 => 'some short body',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',
                UserID               => 1,
                NoAgentNotify        => 1,
            );

            my $TicketAccountTime = $TicketObject->TicketAccountTime(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                TimeUnit  => $AccountTime,
                UserID    => 1,
            );
        }
    }

    my %TicketData = $TicketObject->TicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );

    push @TicketIDs, \%TicketData;
}
continue {
    $Helper->FixedTimeUnset();
}

my %StateList = $Kernel::OM->Get('Kernel::System::State')->StateList(
    UserID => 1,
);
my %LookupStateList = map { $StateList{$_} => $_ } sort keys %StateList;

# set the language to 'en' before the StatsRun
$Kernel::OM->ObjectParamAdd(
    'Kernel::Language' => {
        UserLanguage => 'en',
    },
);

# generate the TicketAccountedTime test statistic
my $TicketAccountedTimeStatID = $StatsObject->StatsAdd(
    UserID => 1,
);

# sanity check
$Self->True(
    $TicketAccountedTimeStatID,
    'StatsAdd() TicketAccountedTime successful - StatID $TicketAccountedTimeStatID',
);

my $UpdateSuccess = $StatsObject->StatsUpdate(
    StatID => $TicketAccountedTimeStatID,
    Hash   => {
        Title        => 'Title for result tests',
        Description  => 'some Description',
        Object       => 'TicketAccountedTime',
        Format       => 'CSV',
        ObjectModule => 'Kernel::System::Stats::Dynamic::TicketAccountedTime',
        StatType     => 'dynamic',
        Cache        => 1,
        Valid        => 1,
    },
    UserID => 1,
);

# sanity check
$Self->True(
    $UpdateSuccess,
    'StatsUpdate() TicketAccountedTime successful - StatID $TicketAccountedTimeStatID',
);

my @Tests = (

    # Test with a relative time period and without a defined time zone
    # Fixed TimeStamp: '2014-10-15 12:00:00'
    # TimeZone: -
    # X-Axis: 'CreateTime' with a relative period 'the last complete 5 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: -
    {
        Description => 'Test stat without a time zone (last complete 5 days and scale 1 day)',
        TimeStamp   => '2014-10-15 12:00:00',
        StatsUpdate => {
            StatID => $TicketAccountedTimeStatID,
            Hash   => {
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 5,
                        TimeRelativeUpcomingCount => 0,
                        TimeRelativeUnit          => 'Day',
                        TimeScaleCount            => 1,
                        SelectedValues            => [
                            'Day',
                        ],
                    },
                ],
                UseAsValueSeries => [
                    {
                        'Element'        => 'QueueIDs',
                        'Block'          => 'MultiSelectField',
                        'Selected'       => 1,
                        'Fixed'          => 1,
                        'SelectedValues' => \@QueueIDs,
                    },
                ],
                UseAsRestriction => [],
            },
            UserID => 1,
        },
        ReferenceResultData => [
            [
                'Title for result tests 2014-10-10 00:00:00-2014-10-14 23:59:59',
            ],
            [
                'Queue',
                'Fri 10',
                'Sat 11',
                'Sun 12',
                'Mon 13',
                'Tue 14',
            ],
            [
                $QueueNames[0],
                160,
                0,
                30,
                0,
                0,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                40.5,
            ],
        ],
    },
);

# ------------------------------------------------------------ #
# run general result statistic tests
# ------------------------------------------------------------ #

# define test counter
my $TestCount = 1;

TEST:
for my $Test (@Tests) {

    # set the language for the test (for the translatable content)
    if ( $Test->{Language} ) {

        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::Language'],
        );

        $Kernel::OM->ObjectParamAdd(
            'Kernel::Language' => {
                UserLanguage => $Test->{Language},
            },
        );
    }

    # check ContractAdd attribute
    if ( !$Test->{StatsUpdate} || ref $Test->{StatsUpdate} ne 'HASH' ) {

        $Self->True(
            0,
            "Test $TestCount: No StatsUpdate found for this test.",
        );

        next TEST;
    }

    # set the fixed time
    my $SystemTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Test->{TimeStamp},
        }
    )->ToEpoch();
    $Helper->FixedTimeSet($SystemTime);

    # print test case description
    if ( $Test->{Description} ) {
        $Self->True(
            1,
            "Test $TestCount: $Test->{Description}",
        );
    }

    my $UpdateSuccess = $StatsObject->StatsUpdate(
        %{ $Test->{StatsUpdate} },
    );

    $Self->True(
        $UpdateSuccess,
        "Test $TestCount: StatsUpdate() - Update stat - success.",
    );

    my $Stat = $StatsObject->StatsGet( StatID => $Test->{StatsUpdate}->{StatID} );

    # Add the ExchangeAxis param to the stat hash, because this can only be changed at runtime.
    $Stat->{ExchangeAxis} = $Test->{StatsUpdate}->{Hash}->{ExchangeAxis};

    $Self->True(
        $Stat->{Title},
        "Test $TestCount: StatsGet() - Get the stat data - success.",
    );

    my $ResultData = $StatsObject->StatsRun(
        StatID   => $Test->{StatsUpdate}->{StatID},
        GetParam => $Stat,
        UserID   => 1,
    );

    $Self->IsDeeply(
        $ResultData,
        $Test->{ReferenceResultData},
        "Test $TestCount: StatsRun() - test the result",
    );
}
continue {

    $Helper->FixedTimeUnset();

    $TestCount++;
}

# to get the system default language in the next test
$Kernel::OM->ObjectsDiscard(
    Objects => ['Kernel::Language'],
);

# cleanup is done by RestoreDatabase.

1;
