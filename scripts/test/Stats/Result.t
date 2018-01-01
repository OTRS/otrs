# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::ObjectManager;
use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject              = $Kernel::OM->Get('Kernel::Config');
my $QueueObject               = $Kernel::OM->Get('Kernel::System::Queue');
my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');
my $TimeObject                = $Kernel::OM->Get('Kernel::System::Time');
my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

# get stats object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::Stats' => {
        UserID => 1,
    },
);
my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

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

for my $Count ( 1 .. 3 ) {

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

# create some dynamic fields
my @DynamicFieldProperties = (
    {
        Name       => "Text$RandomID",
        Label      => "Text$RandomID",
        FieldOrder => 9991,
        FieldType  => 'Text',
        Config     => {
            DefaultValue => 'Default',
        },
    },
    {
        Name       => "TextArea$RandomID",
        Label      => "TextArea$RandomID",
        FieldOrder => 9992,
        FieldType  => 'TextArea',
        Config     => {
            DefaultValue => 'Default',
        },
    },
);

my %DynamicFieldFieldConfig;

for my $DynamicFieldProperty (@DynamicFieldProperties) {
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        %{$DynamicFieldProperty},
        ObjectType => 'Ticket',
        ValidID    => 1,
        UserID     => 1,
        Reorder    => 0,
    );

    $DynamicFieldFieldConfig{ $DynamicFieldProperty->{Name} } = $DynamicFieldObject->DynamicFieldGet(
        ID => $FieldID,
    );
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
            State        => 'new',
            CustomerID   => 'example + test',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },

    # add the ticket in the first statistic queue
    {
        TimeStamp  => '2014-12-10 11:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[0],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'test & example',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },

    # add the ticket in the first statistic queue
    {
        TimeStamp  => '2015-07-31 21:10:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[0],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },

    # add the ticket in the first statistic queue
    {
        TimeStamp  => '2015-08-09 19:15:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[0],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },

    # add the ticket in the first statistic queue
    {
        TimeStamp  => '2015-08-10 20:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[0],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },

    # add the ticket in the first statistic queue
    {
        TimeStamp  => '2015-08-10 10:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[0],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },

    # add the ticket in the second statistic queue
    {
        TimeStamp  => '2015-08-12 22:00:00',
        TicketData => {
            Title         => 'Statistic Ticket Title',
            Queue         => $QueueNames[1],
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'new',
            CustomerID    => '123465',
            CustomerUser  => 'customer@example.com',
            OwnerID       => 1,
            UserID        => 1,
            DynamicFields => {
                Text     => 'Example 123',
                TextArea => 'Example 123',
            },
        },
    },

    # add the ticket in the second statistic queue
    {
        TimeStamp  => '2015-09-10 18:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[1],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },

    # add the ticket in the third statistic queue
    {
        TimeStamp  => '2014-09-20 12:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[2],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },

    # add the ticket in the third statistic queue
    {
        TimeStamp  => '2015-08-11 12:00:00',
        TicketData => {
            Title         => 'Statistic Ticket Title',
            Queue         => $QueueNames[2],
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'new',
            CustomerID    => '123465',
            CustomerUser  => 'customer@example.com',
            OwnerID       => 1,
            UserID        => 1,
            DynamicFields => {
                TextArea => 'Example 123',
            },
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

    my $SystemTime = $TimeObject->TimeStamp2SystemTime(
        String => $Ticket->{TimeStamp},
    );

    # set the fixed time
    $Helper->FixedTimeSet($SystemTime);

    # create the ticket
    my $TicketID = $TicketObject->TicketCreate(
        %{ $Ticket->{TicketData} },
    );

    if ( IsHashRefWithData( $Ticket->{TicketData}->{DynamicFields} ) ) {

        for my $DynamicFieldName ( sort keys %{ $Ticket->{TicketData}->{DynamicFields} } ) {

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldFieldConfig{ $DynamicFieldName . $RandomID },
                ObjectID           => $TicketID,
                Value              => $Ticket->{TicketData}->{DynamicFields}->{$DynamicFieldName},
                UserID             => 1,
            );
        }
    }

    # sanity check
    $Self->True(
        $TicketID,
        "TicketCreate() successful for test - TicketID $TicketID",
    );

    push @TicketIDs, $TicketID;
}
continue {
    $Helper->FixedTimeUnset();
}

# set the language to 'en' before the StatsRun
$Kernel::OM->ObjectParamAdd(
    'Kernel::Language' => {
        UserLanguage => 'en',
    },
);

my $StatID = $StatsObject->StatsAdd(
    UserID => 1,
);

# sanity check
$Self->True(
    $StatID,
    'StatsAdd() successful - StatID $StatID',
);

my $UpdateSuccess = $StatsObject->StatsUpdate(
    StatID => $StatID,
    Hash   => {
        Title        => 'Title for result tests',
        Description  => 'some Description',
        Object       => 'Ticket',
        Format       => 'CSV',
        ObjectModule => 'Kernel::System::Stats::Dynamic::Ticket',
        StatType     => 'dynamic',
        Cache        => 1,
        Valid        => 1,
    },
    UserID => 1,
);

# sanity check
$Self->True(
    $UpdateSuccess,
    'StatsUpdate() successful - StatID $StatID',
);

my @Tests = (

    # Test with a relative time period
    # Fixed TimeStamp: '2015-08-15 20:00:00'
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: -
    {
        Description => 'Test stat without a time zone (last complete 7 days and scale 1 day)',
        TimeStamp   => '2015-08-15 20:00:00',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 7,
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
                'Title for result tests 2015-08-08 00:00:00-2015-08-14 23:59:59',
            ],
            [
                'Queue',
                'Sat 8',
                'Sun 9',
                'Mon 10',
                'Tue 11',
                'Wed 12',
                'Thu 13',
                'Fri 14',
            ],
            [
                $QueueNames[0],
                0,
                1,
                2,
                0,
                0,
                0,
                0,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                1,
                0,
                0,
            ],
            [
                $QueueNames[2],
                0,
                0,
                0,
                1,
                0,
                0,
                0,
            ],
        ],
    },

    # Test with a relative time period and a other language
    # Fixed TimeStamp: '2015-08-15 20:00:00'
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: -
    # Language: de
    {
        Description => "Test stat without a time zone (last complete 7 days and scale 1 day) and language 'de'",
        TimeStamp   => '2015-08-15 20:00:00',
        Language    => 'de',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 7,
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
                'Title for result tests 2015-08-08 00:00:00-2015-08-14 23:59:59',
            ],
            [
                'Queue',
                'Sa 8',
                'So 9',
                'Mo 10',
                'Di 11',
                'Mi 12',
                'Do 13',
                'Fr 14',
            ],
            [
                $QueueNames[0],
                0,
                1,
                2,
                0,
                0,
                0,
                0,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                1,
                0,
                0,
            ],
            [
                $QueueNames[2],
                0,
                0,
                0,
                1,
                0,
                0,
                0,
            ],
        ],
    },

    # Test with a relative time period and a other language
    # Fixed TimeStamp: '2015-08-15 20:00:00'
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: -
    # Language: es
    {
        Description => "Test stat without a time zone (last complete 7 days and scale 1 day) and language 'es'",
        TimeStamp   => '2015-08-15 20:00:00',
        Language    => 'es',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 7,
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
                'Title for result tests 2015-08-08 00:00:00-2015-08-14 23:59:59',
            ],
            [
                'Cola',
                'Sáb 8',
                'Dom 9',
                'Lun 10',
                'Mar 11',
                'Mié 12',
                'Jue 13',
                'Vie 14',
            ],
            [
                $QueueNames[0],
                0,
                1,
                2,
                0,
                0,
                0,
                0,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                1,
                0,
                0,
            ],
            [
                $QueueNames[2],
                0,
                0,
                0,
                1,
                0,
                0,
                0,
            ],
        ],
    },

    # Test with a relative time period and a other language
    # Fixed TimeStamp: '2015-08-15 20:00:00'
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: -
    # Language: es_MX
    {
        Description => "Test stat without a time zone (last complete 7 days and scale 1 day) and language 'es_MX'",
        TimeStamp   => '2015-08-15 20:00:00',
        Language    => 'es_MX',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 7,
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
                'Title for result tests 2015-08-08 00:00:00-2015-08-14 23:59:59',
            ],
            [
                'Fila',
                'Sáb 8',
                'Dom 9',
                'Lun 10',
                'Mar 11',
                'Mié 12',
                'Jue 13',
                'Vie 14',
            ],
            [
                $QueueNames[0],
                0,
                1,
                2,
                0,
                0,
                0,
                0,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                1,
                0,
                0,
            ],
            [
                $QueueNames[2],
                0,
                0,
                0,
                1,
                0,
                0,
                0,
            ],
        ],
    },

    # Test with a relative time period and with selected SumRow
    # Fixed TimeStamp: '2015-08-15 20:00:00'
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: -
    # SumRow: 'Yes'
    # SumCol: 'No'
    {
        Description => 'Test stat with selected SumRow (last complete 7 days and scale 1 day)',
        TimeStamp   => '2015-08-15 20:00:00',
        Language    => 'en',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                SumRow      => 1,
                SumCol      => 0,
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 7,
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
                'Title for result tests 2015-08-08 00:00:00-2015-08-14 23:59:59',
            ],
            [
                'Queue',
                'Sat 8',
                'Sun 9',
                'Mon 10',
                'Tue 11',
                'Wed 12',
                'Thu 13',
                'Fri 14',
            ],
            [
                $QueueNames[0],
                0,
                1,
                2,
                0,
                0,
                0,
                0,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                1,
                0,
                0,
            ],
            [
                $QueueNames[2],
                0,
                0,
                0,
                1,
                0,
                0,
                0,
            ],
            [
                'Sum',
                0,
                1,
                2,
                1,
                1,
                0,
                0,
            ],
        ],
    },

    # Test with a relative time period and with selected SumCol
    # Fixed TimeStamp: '2015-08-15 20:00:00'
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: -
    # SumRow: 'No'
    # SumCol: 'Yes'
    {
        Description => 'Test stat with selected SumCol (last complete 7 days and scale 1 day)',
        TimeStamp   => '2015-08-15 20:00:00',
        Language    => 'en',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                SumRow      => 0,
                SumCol      => 1,
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 7,
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
                'Title for result tests 2015-08-08 00:00:00-2015-08-14 23:59:59',
            ],
            [
                'Queue',
                'Sat 8',
                'Sun 9',
                'Mon 10',
                'Tue 11',
                'Wed 12',
                'Thu 13',
                'Fri 14',
                'Sum',
            ],
            [
                $QueueNames[0],
                0,
                1,
                2,
                0,
                0,
                0,
                0,
                3,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                1,
            ],
            [
                $QueueNames[2],
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                1,
            ],
        ],
    },

    # Test with a relative time period and with selected SumRow and SumCol
    # Fixed TimeStamp: '2015-08-15 20:00:00'
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: -
    # SumRow: 'No'
    # SumCol: 'Yes'
    {
        Description => 'Test stat with selected SumRow and SumCol (last complete 7 days and scale 1 day)',
        TimeStamp   => '2015-08-15 20:00:00',
        Language    => 'en',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                SumRow      => 1,
                SumCol      => 1,
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 7,
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
                'Title for result tests 2015-08-08 00:00:00-2015-08-14 23:59:59',
            ],
            [
                'Queue',
                'Sat 8',
                'Sun 9',
                'Mon 10',
                'Tue 11',
                'Wed 12',
                'Thu 13',
                'Fri 14',
                'Sum',
            ],
            [
                $QueueNames[0],
                0,
                1,
                2,
                0,
                0,
                0,
                0,
                3,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                1,
            ],
            [
                $QueueNames[2],
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                1,
            ],
            [
                'Sum',
                0,
                1,
                2,
                1,
                1,
                0,
                0,
                5,
            ],
        ],
    },

    # ------------------------------------------------------------ #
    # some special tests for dynamic fields text and textarea
    # ------------------------------------------------------------ #

    # Test with a relative time period and a restriction for a dynamic field textarea
    # Fixed TimeStamp: '2015-08-15 20:00:00'
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: 'TextArea' => 'Example*',
    {
        Description =>
            'Test stat with a restriction for a dynamic field textarea (last complete 7 days and scale 1 day)',
        TimeStamp   => '2015-08-15 20:00:00',
        Language    => 'en',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                SumRow      => 0,
                SumCol      => 0,
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 7,
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
                UseAsRestriction => [
                    {
                        'Element'        => 'DynamicField_TextArea' . $RandomID,
                        'Block'          => 'InputField',
                        'Selected'       => 1,
                        'Fixed'          => 1,
                        'SelectedValues' => [
                            'Example*',
                        ],
                    },
                ],
            },
            UserID => 1,
        },
        ReferenceResultData => [
            [
                'Title for result tests 2015-08-08 00:00:00-2015-08-14 23:59:59',
            ],
            [
                'Queue',
                'Sat 8',
                'Sun 9',
                'Mon 10',
                'Tue 11',
                'Wed 12',
                'Thu 13',
                'Fri 14',
            ],
            [
                $QueueNames[0],
                0,
                0,
                0,
                0,
                0,
                0,
                0,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                1,
                0,
                0,
            ],
            [
                $QueueNames[2],
                0,
                0,
                0,
                1,
                0,
                0,
                0,
            ],
        ],
    },

    # Test with a relative time period and a restriction for a dynamic field text
    # Fixed TimeStamp: '2015-08-15 20:00:00'
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: 'Text' => 'Example*',
    {
        Description => 'Test stat with a restriction for a dynamic field text (last complete 7 days and scale 1 day)',
        TimeStamp   => '2015-08-15 20:00:00',
        Language    => 'en',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                SumRow      => 0,
                SumCol      => 0,
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 7,
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
                UseAsRestriction => [
                    {
                        'Element'        => 'DynamicField_Text' . $RandomID,
                        'Block'          => 'InputField',
                        'Selected'       => 1,
                        'Fixed'          => 1,
                        'SelectedValues' => [
                            'Example*',
                        ],
                    },
                ],
            },
            UserID => 1,
        },
        ReferenceResultData => [
            [
                'Title for result tests 2015-08-08 00:00:00-2015-08-14 23:59:59',
            ],
            [
                'Queue',
                'Sat 8',
                'Sun 9',
                'Mon 10',
                'Tue 11',
                'Wed 12',
                'Thu 13',
                'Fri 14',
            ],
            [
                $QueueNames[0],
                0,
                0,
                0,
                0,
                0,
                0,
                0,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                1,
                0,
                0,
            ],
            [
                $QueueNames[2],
                0,
                0,
                0,
                0,
                0,
                0,
                0,
            ],
        ],
    },

    # Test with a relative time period and a restriction for a dynamic field text and textarea
    # Fixed TimeStamp: '2015-08-15 20:00:00'
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: 'Text' => 'Example*' & 'TextArea' => 'Example*',
    {
        Description =>
            'Test stat with a restriction for a dynamic field text and textarea (last complete 7 days and scale 1 day)',
        TimeStamp   => '2015-08-15 20:00:00',
        Language    => 'en',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                SumRow      => 0,
                SumCol      => 0,
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 7,
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
                UseAsRestriction => [
                    {
                        'Element'        => 'DynamicField_Text' . $RandomID,
                        'Block'          => 'InputField',
                        'Selected'       => 1,
                        'Fixed'          => 1,
                        'SelectedValues' => [
                            'Example*',
                        ],
                    },
                    {
                        'Element'        => 'DynamicField_TextArea' . $RandomID,
                        'Block'          => 'InputField',
                        'Selected'       => 1,
                        'Fixed'          => 1,
                        'SelectedValues' => [
                            'Example*',
                        ],
                    },
                ],
            },
            UserID => 1,
        },
        ReferenceResultData => [
            [
                'Title for result tests 2015-08-08 00:00:00-2015-08-14 23:59:59',
            ],
            [
                'Queue',
                'Sat 8',
                'Sun 9',
                'Mon 10',
                'Tue 11',
                'Wed 12',
                'Thu 13',
                'Fri 14',
            ],
            [
                $QueueNames[0],
                0,
                0,
                0,
                0,
                0,
                0,
                0,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                1,
                0,
                0,
            ],
            [
                $QueueNames[2],
                0,
                0,
                0,
                0,
                0,
                0,
                0,
            ],
        ],
    },

    # Test with a relative time period and a restriction (special CustomerID value with '+')
    # Fixed TimeStamp: '2014-10-12 20:00:00'
    # TimeZone: -
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: 'CustomerID' => 'example + test' (exact match),
    {
        Description =>
            'Test stat with a restriction for a special customer id with a "+" (last complete 7 days and scale 1 day)',
        TimeStamp   => '2014-10-12 20:00:00',
        Language    => 'en',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                SumRow      => 0,
                SumCol      => 0,
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 7,
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
                UseAsRestriction => [
                    {
                        'Element'        => 'CustomerID',
                        'Block'          => 'MultiSelectField',
                        'Selected'       => 1,
                        'Fixed'          => 1,
                        'SelectedValues' => [
                            'example + test',
                        ],
                    },
                ],
            },
            UserID => 1,
        },
        ReferenceResultData => [
            [
                'Title for result tests 2014-10-05 00:00:00-2014-10-11 23:59:59',
            ],
            [
                'Queue',
                'Sun 5',
                'Mon 6',
                'Tue 7',
                'Wed 8',
                'Thu 9',
                'Fri 10',
                'Sat 11',
            ],
            [
                $QueueNames[0],
                0,
                0,
                0,
                0,
                0,
                1,
                0,
            ],
            [
                $QueueNames[1],
                0,
                0,
                0,
                0,
                0,
                0,
                0,
            ],
            [
                $QueueNames[2],
                0,
                0,
                0,
                0,
                0,
                0,
                0,
            ],
        ],
    },

    # Test with a relative time period and a restriction (special CustomerID value with '&')
    # Fixed TimeStamp: '2014-12-11 20:00:00'
    # TimeZone: -
    # X-Axis: 'CreateTime' with a relative period 'the last complete 7 days' and 'scale 1 day'.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: 'CustomerID' => 'test & example' (exact match),
    {
        Description =>
            'Test stat with a restriction for a special customer id with a "&" (last complete 7 days and scale 1 day)',
        TimeStamp   => '2014-12-11 20:00:00',
        Language    => 'en',
        StatsUpdate => {
            StatID => $StatID,
            Hash   => {
                SumRow      => 0,
                SumCol      => 0,
                UseAsXvalue => [
                    {
                        Element                   => 'CreateTime',
                        Block                     => 'Time',
                        Fixed                     => 1,
                        Selected                  => 1,
                        TimeRelativeCount         => 2,
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
                UseAsRestriction => [
                    {
                        'Element'        => 'CustomerID',
                        'Block'          => 'MultiSelectField',
                        'Selected'       => 1,
                        'Fixed'          => 1,
                        'SelectedValues' => [
                            'test & example',
                        ],
                    },
                ],
            },
            UserID => 1,
        },
        ReferenceResultData => [
            [
                'Title for result tests 2014-12-09 00:00:00-2014-12-10 23:59:59',
            ],
            [
                'Queue',
                'Tue 9',
                'Wed 10',
            ],
            [
                $QueueNames[0],
                0,
                1,
            ],
            [
                $QueueNames[1],
                0,
                0,
            ],
            [
                $QueueNames[2],
                0,
                0,
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
    my $SystemTime = $TimeObject->TimeStamp2SystemTime(
        String => $Test->{TimeStamp},
    );
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

    my $Stat = $StatsObject->StatsGet( StatID => $StatID );

    $Self->True(
        $Stat->{Title},
        "Test $TestCount: StatsGet() - Get the stat data - success.",
    );

    my $ResultData = $StatsObject->StatsRun(
        StatID   => $StatID,
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
