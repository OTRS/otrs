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

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $QueueObject          = $Kernel::OM->Get('Kernel::System::Queue');
my $TypeObject           = $Kernel::OM->Get('Kernel::System::Type');
my $StateObject          = $Kernel::OM->Get('Kernel::System::State');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Turn on the ticket type feature.
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'Ticket::Type',
    Value => 1,
);

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

my @Tests = (
    {
        CreateData => [
            {
                TicketCreate => {
                    Title        => 'HistoryCreateTitle',
                    Queue        => 'Raw',
                    Lock         => 'unlock',
                    PriorityID   => '3',
                    State        => 'new',
                    CustomerID   => '1',
                    CustomerUser => 'customer@example.com',
                    OwnerID      => 1,
                    UserID       => 1,
                },
            },
            {
                ArticleCreate => {
                    SenderType           => 'agent',
                    IsVisibleForCustomer => 0,
                    From                 => 'Some Agent <email@example.com>',
                    To                   => 'Some Customer A <customer-a@example.com>',
                    Subject              => 'some short description',
                    Body                 => 'the message text',
                    Charset              => 'ISO-8859-15',
                    MimeType             => 'text/plain',
                    HistoryType          => 'OwnerUpdate',
                    HistoryComment       => 'Some free text!',
                    UserID               => 1,
                },
            },
            {
                ArticleCreate => {
                    SenderType           => 'agent',
                    IsVisibleForCustomer => 0,
                    From                 => 'Some other Agent <email2@example.com>',
                    To                   => 'Some Customer A <customer-a@example.com>',
                    Subject              => 'some short description',
                    Body                 => 'the message text',
                    Charset              => 'UTF-8',
                    MimeType             => 'text/plain',
                    HistoryType          => 'OwnerUpdate',
                    HistoryComment       => 'Some free text!',
                    UserID               => 1,
                },
            },
        ],
    },
    {
        ReferenceData => [
            {
                TicketIndex => 0,
                HistoryGet  => [
                    {
                        CreateBy    => 1,
                        HistoryType => 'NewTicket',
                        Queue       => 'Raw',
                        OwnerID     => 1,
                        PriorityID  => 3,
                        State       => 'new',
                        HistoryType => 'NewTicket',
                        Type        => 'Unclassified',
                    },

                    # Bug 12702 - TicketHistoryGet() initial ticket type update
                    {
                        CreateBy    => 1,
                        HistoryType => 'TypeUpdate',
                        Queue       => 'Raw',
                        OwnerID     => 1,
                        PriorityID  => 3,
                        State       => 'new',
                        Type        => 'Unclassified',
                        TypeID      => '1',
                    },

                    {
                        CreateBy    => 1,
                        HistoryType => 'CustomerUpdate',
                        Queue       => 'Raw',
                        OwnerID     => 1,
                        PriorityID  => 3,
                        State       => 'new',
                        HistoryType => 'CustomerUpdate',
                        Type        => 'Unclassified',
                    },
                    {
                        CreateBy    => 1,
                        HistoryType => 'OwnerUpdate',
                        Queue       => 'Raw',
                        OwnerID     => 1,
                        PriorityID  => 3,
                        State       => 'new',
                        HistoryType => 'OwnerUpdate',
                        Type        => 'Unclassified',
                    },
                    {
                        CreateBy    => 1,
                        HistoryType => 'OwnerUpdate',
                        Queue       => 'Raw',
                        OwnerID     => 1,
                        PriorityID  => 3,
                        State       => 'new',
                        HistoryType => 'OwnerUpdate',
                        Type        => 'Unclassified',
                    },
                ],
            },
        ],
    },

    # Bug 10856 - TicketHistoryGet() dynamic field values
    {
        CreateData => [
            {
                TicketCreate => {
                    Title                => 'HistoryCreateTitle',
                    Queue                => 'Raw',
                    Lock                 => 'unlock',
                    PriorityID           => '3',
                    State                => 'new',
                    CustomerID           => '1',
                    CustomerUser         => 'customer@example.com',
                    OwnerID              => 1,
                    UserID               => 1,
                    DynamicFieldBug10856 => 'TestValue',
                },

                # history entry for a dynamic field update of OTRS 3.3
                HistoryAdd => {
                    HistoryType => 'TicketDynamicFieldUpdate',
                    Name =>
                        "\%\%FieldName\%\%DynamicFieldBug10856"
                        . "\%\%Value\%\%TestValue",
                    CreateUserID => 1,
                },
            },
        ],
    },

    # Bug 10856 - TicketHistoryGet() dynamic field values
    {
        CreateData => [
            {
                TicketCreate => {
                    Title                => 'HistoryCreateTitle',
                    Queue                => 'Raw',
                    Lock                 => 'unlock',
                    PriorityID           => '3',
                    State                => 'new',
                    CustomerID           => '1',
                    CustomerUser         => 'customer@example.com',
                    OwnerID              => 1,
                    UserID               => 1,
                    DynamicFieldBug10856 => 'TestValue',
                },

                # history entry for a dynamic field update of OTRS 4
                HistoryAdd => {
                    HistoryType => 'TicketDynamicFieldUpdate',
                    Name =>
                        "\%\%FieldName\%\%DynamicFieldBug10856"
                        . "\%\%Value\%\%TestValue"
                        . "\%\%OldValue",
                    CreateUserID => 1,
                },
            },
        ],
    },
);

my @HistoryCreateTicketIDs;
for my $Test (@Tests) {
    my $HistoryCreateTicketID;
    my @HistoryCreateArticleIDs;

    if ( $Test->{CreateData} ) {
        for my $CreateData ( @{ $Test->{CreateData} } ) {

            if ( $CreateData->{TicketCreate} ) {
                $HistoryCreateTicketID = $TicketObject->TicketCreate(
                    %{ $CreateData->{TicketCreate} },
                );
                $Self->True(
                    $HistoryCreateTicketID,
                    'HistoryGet - TicketCreate()',
                );

                if ($HistoryCreateTicketID) {
                    push @HistoryCreateTicketIDs, $HistoryCreateTicketID;
                }
            }

            if ( $CreateData->{ArticleCreate} ) {
                my $HistoryCreateArticleID = $ArticleBackendObject->ArticleCreate(
                    TicketID => $HistoryCreateTicketID,
                    %{ $CreateData->{ArticleCreate} },
                );
                $Self->True(
                    $HistoryCreateArticleID,
                    'HistoryGet - ArticleCreate()',
                );
                if ($HistoryCreateArticleID) {
                    push @HistoryCreateArticleIDs, $HistoryCreateArticleID;
                }
            }

            if ( $CreateData->{HistoryAdd} ) {
                my $Success = $TicketObject->HistoryAdd(
                    %{ $CreateData->{HistoryAdd} },
                    TicketID => $HistoryCreateTicketID,
                );

                $Self->True(
                    $Success,
                    'HistoryAdd() - Create raw history entry',
                );
            }

            if ( $CreateData->{TicketCreate} ) {
                my %ComputedTicketState = $TicketObject->HistoryTicketGet(
                    StopDay   => 1,
                    StopMonth => 1,
                    StopYear  => 1990,
                    TicketID  => $HistoryCreateTicketID,
                );

                $Self->False(
                    %ComputedTicketState ? 1 : 0,
                    "HistoryTicketGet() - state before ticket was created",
                );

                my %ComputedTicketStateCached = $TicketObject->HistoryTicketGet(
                    StopDay   => 1,
                    StopMonth => 1,
                    StopYear  => 1990,
                    TicketID  => $HistoryCreateTicketID,
                );

                $Self->IsDeeply(
                    \%ComputedTicketStateCached,
                    \%ComputedTicketState,
                    "HistoryTicketGet() - cached ticket data before ticket was created",
                );

                %ComputedTicketState = $TicketObject->HistoryTicketGet(
                    StopDay   => 1,
                    StopMonth => 1,
                    StopYear  => 2990,
                    TicketID  => $HistoryCreateTicketID,
                );

                for my $Key (qw(OwnerID PriorityID Queue State DynamicFieldBug10856)) {

                    $Self->Is(
                        $ComputedTicketState{$Key},
                        $CreateData->{TicketCreate}->{$Key},
                        "HistoryTicketGet() - uncached value $Key",
                    );
                }

                %ComputedTicketStateCached = $TicketObject->HistoryTicketGet(
                    StopDay   => 1,
                    StopMonth => 1,
                    StopYear  => 2990,
                    TicketID  => $HistoryCreateTicketID,
                );

                $Self->IsDeeply(
                    \%ComputedTicketStateCached,
                    \%ComputedTicketState,
                    "HistoryTicketGet() - cached ticket data",
                );
            }
        }

    }

    if ( $Test->{ReferenceData} ) {

        REFERENCEDATA:
        for my $ReferenceData ( @{ $Test->{ReferenceData} } ) {

            $HistoryCreateTicketID = $HistoryCreateTicketIDs[ $ReferenceData->{TicketIndex} ];

            next REFERENCEDATA if !$ReferenceData->{HistoryGet};
            my @ReferenceResults = @{ $ReferenceData->{HistoryGet} };

            my @HistoryGet = $TicketObject->HistoryGet(
                UserID   => 1,
                TicketID => $HistoryCreateTicketID,
            );

            my %LookForHistoryTypes = (
                NewTicket      => 1,
                TypeUpdate     => 1,
                OwnerUpdate    => 1,
                CustomerUpdate => 1,
            );

            @HistoryGet = grep { $LookForHistoryTypes{ $_->{HistoryType} } } @HistoryGet;

            $Self->True(
                scalar @HistoryGet,
                'HistoryGet - HistoryGet()',
            );

            next REFERENCEDATA if !@HistoryGet;

            for my $ResultCount ( 0 .. ( ( scalar @ReferenceResults ) - 1 ) ) {

                my $Result = $ReferenceData->{HistoryGet}->[$ResultCount];
                RESULTENTRY:
                for my $ResultEntry ( sort keys %{$Result} ) {
                    next RESULTENTRY if !$Result->{$ResultEntry};

                    if ( $ResultEntry eq 'Queue' ) {
                        my $HistoryQueueID = $QueueObject->QueueLookup(
                            Queue => $Result->{$ResultEntry},
                        );

                        $ResultEntry = 'QueueID';
                        $Result->{$ResultEntry} = $HistoryQueueID;
                    }

                    if ( $ResultEntry eq 'State' ) {
                        my %HistoryState = $StateObject->StateGet(
                            Name => $Result->{$ResultEntry},
                        );
                        $ResultEntry = 'StateID';
                        $Result->{$ResultEntry} = $HistoryState{ID};
                    }

                    if ( $ResultEntry eq 'HistoryType' ) {
                        my $HistoryTypeID = $TicketObject->HistoryTypeLookup(
                            Type => $Result->{$ResultEntry},
                        );
                        $ResultEntry = 'HistoryTypeID';
                        $Result->{$ResultEntry} = $HistoryTypeID;
                    }

                    if ( $ResultEntry eq 'Type' ) {
                        my $TypeID = $TypeObject->TypeLookup(
                            Type => $Result->{$ResultEntry},
                        );
                        $ResultEntry = 'TypeID';
                        $Result->{$ResultEntry} = $TypeID;
                    }

                    $Self->Is(
                        $Result->{$ResultEntry},
                        $HistoryGet[$ResultCount]->{$ResultEntry},
                        "HistoryGet - Check returned content $ResultEntry",
                    );
                }
            }
        }
    }
}

# cleanup is done by RestoreDatabase.

1;
