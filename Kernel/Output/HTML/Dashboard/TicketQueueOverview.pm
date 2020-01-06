# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Dashboard::TicketQueueOverview;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed parameters
    for my $Needed (qw( Config Name UserID )) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    $Self->{PrefKey}  = 'UserDashboardPref' . $Self->{Name} . '-Shown';
    $Self->{CacheKey} = $Self->{Name} . '-' . $Self->{UserID};

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} },

        # remember, do not allow to use page cache
        # (it's not working because of internal filter)
        CacheKey => undef,
        CacheTTL => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LimitGroup = $Self->{Config}->{QueuePermissionGroup} || 0;
    my $CacheKey   = 'User' . '-' . $Self->{UserID} . '-' . $LimitGroup;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $Content = $CacheObject->Get(
        Type => 'DashboardQueueOverview',
        Key  => $CacheKey,
    );
    return $Content if defined $Content;

    # get configured states, get their state ID and test if they exist while we do it
    my %States;
    my $StateIDURL;
    my %ConfiguredStates = %{ $Self->{Config}->{States} };
    for my $StateOrder ( sort { $a <=> $b } keys %ConfiguredStates ) {
        my $State = $ConfiguredStates{$StateOrder};

        # check if state is found, to record StateID
        my $StateID = $Kernel::OM->Get('Kernel::System::State')->StateLookup(
            State => $State,
        ) || '';
        if ($StateID) {
            $States{$State} = $StateID;

            # append StateID to URL for search string
            $StateIDURL .= "StateIDs=$StateID;";
        }
        else {

            # state does not exist, skipping
            delete $ConfiguredStates{$StateOrder};
        }
    }

    # get queue object
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    # get all queues
    my %Queues = $QueueObject->GetAllQueues(
        UserID => $Self->{UserID},
        Type   => 'ro',
    );

    # limit them by QueuePermissionGroup if needed
    my $LimitGroupID;
    if ($LimitGroup) {
        $LimitGroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
            Group => $LimitGroup,
        );
    }

    my $Sort = $Self->{Config}->{Sort} || '';

    my %QueueToID;
    my $QueueIDURL;

    # lookup queues, add their QueueID to new hash (needed for Search)
    QUEUES:
    for my $QueueID ( sort keys %Queues ) {

        # see if we have to remove the queue based on LimitGroup
        if ($LimitGroup) {
            my $GroupID = $QueueObject->GetQueueGroupID(
                QueueID => $QueueID,
            );
            if ( $GroupID != $LimitGroupID ) {
                delete $Queues{$QueueID};
                next QUEUES;
            }
        }

        # add queue to reverse hash
        $QueueToID{ $Queues{$QueueID} } = $QueueID;

        # add queue to SearchURL
        $QueueIDURL .= "QueueIDs=$QueueID;";
    }

    # Prepare ticket count.
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my @QueueIDs     = sort keys %Queues;
    if ( !@QueueIDs ) {
        @QueueIDs = (999_999);
    }

    my %Results;
    for my $StateOrderID ( sort { $a <=> $b } keys %ConfiguredStates ) {

        # Run ticket search for all Queues and appropriate available State.
        my @StateOrderTicketIDs = $TicketObject->TicketSearch(
            UserID   => $Self->{UserID},
            Result   => 'ARRAY',
            QueueIDs => \@QueueIDs,
            States   => [ $ConfiguredStates{$StateOrderID} ],
            Limit    => 100_000,
        );

        # Count of tickets per QueueID.
        my $TicketCountByQueueID = $TicketObject->TicketCountByAttribute(
            Attribute => 'QueueID',
            TicketIDs => \@StateOrderTicketIDs,
        );

        # Gather ticket count for corresponding Queue <-> State.
        for my $QueueID (@QueueIDs) {
            push @{ $Results{ $Queues{$QueueID} } },
                $TicketCountByQueueID->{$QueueID} ? $TicketCountByQueueID->{$QueueID} : 0;
        }
    }

    # build header
    my @Headers = ( 'Queue', );
    for my $StateOrder ( sort { $a <=> $b } keys %ConfiguredStates ) {
        push @Headers, $ConfiguredStates{$StateOrder};
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $HeaderItem (@Headers) {
        $LayoutObject->Block(
            Name => 'ContentLargeTicketQueueOverviewHeaderStatus',
            Data => {
                Text => $HeaderItem,
            },
        );
    }

    my $HasContent;

    # iterate over all queues, print results;
    my @StatusTotal;
    QUEUE:
    for my $Queue ( sort values %Queues ) {

        # Hide empty queues
        if ( !grep { defined $_ && $_ > 0 } @{ $Results{$Queue} } ) {
            next QUEUE;
        }

        $HasContent++;

        $LayoutObject->Block(
            Name => 'ContentLargeTicketQueueOverviewQueueName',
            Data => {
                QueueID   => $QueueToID{$Queue},
                QueueName => $Queue,
            }
        );

        # iterate over states
        my $Counter = 0;
        my $RowTotal;
        for my $StateOrderID ( sort { $a <=> $b } keys %ConfiguredStates ) {
            $LayoutObject->Block(
                Name => 'ContentLargeTicketQueueOverviewQueueResults',
                Data => {
                    Number  => $Results{$Queue}->[$Counter],
                    QueueID => $QueueToID{$Queue},
                    StateID => $States{ $ConfiguredStates{$StateOrderID} },
                    State   => $ConfiguredStates{$StateOrderID},
                    Sort    => $Sort,
                },
            );
            $RowTotal                   += $Results{$Queue}->[$Counter] || 0;
            $StatusTotal[$StateOrderID] += $Results{$Queue}->[$Counter] || 0;
            $Counter++;
        }

        # print row (queue) total
        $LayoutObject->Block(
            Name => 'ContentLargeTicketQueueOverviewQueueTotal',
            Data => {
                Number   => $RowTotal,
                QueueID  => $QueueToID{$Queue},
                StateIDs => $StateIDURL,
                Sort     => $Sort,
            },
        );

    }

    if ($HasContent) {
        $LayoutObject->Block(
            Name => 'ContentLargeTicketQueueOverviewStatusTotalRow',
        );

        for my $StateOrderID ( sort { $a <=> $b } keys %ConfiguredStates ) {
            $LayoutObject->Block(
                Name => 'ContentLargeTicketQueueOverviewStatusTotal',
                Data => {
                    Number   => $StatusTotal[$StateOrderID],
                    QueueIDs => $QueueIDURL,
                    StateID  => $States{ $ConfiguredStates{$StateOrderID} },
                    Sort     => $Sort,
                },
            );
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'ContentLargeTicketQueueOverviewNone',
            Data => {
                ColumnCount => ( scalar keys %ConfiguredStates ) + 2,
            }
        );
    }

    # check for refresh time
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
        my $NameHTML = $Self->{Name};
        $NameHTML =~ s{-}{_}xmsg;

        # send data to JS
        $LayoutObject->AddJSData(
            Key   => 'QueueOverview',
            Value => {
                Name        => $Self->{Name},
                NameHTML    => $NameHTML,
                RefreshTime => $Refresh,
            },
        );
    }

    $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardTicketQueueOverview',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
        },
        AJAX => $Param{AJAX},
    );

    # cache result
    if ( $Self->{Config}->{CacheTTLLocal} ) {
        $CacheObject->Set(
            Type  => 'DashboardQueueOverview',
            Key   => $CacheKey,
            Value => $Content || '',
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
    }

    return $Content;
}

1;
