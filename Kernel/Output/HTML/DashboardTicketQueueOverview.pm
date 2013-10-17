# --
# Kernel/Output/HTML/DashboardTicketQueueOverview.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardTicketQueueOverview;

use strict;
use warnings;

use Kernel::System::State;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(
        Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject
        QueueObject UserID
        )
        )
    {
        die "Got no $Object!" if ( !$Self->{$Object} );
    }

    $Self->{StateObject} = Kernel::System::State->new(%Param);

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{CacheKey}
        = $Self->{Name} . '-'
        . $Self->{UserID};

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
    my $CacheKey = 'User' . '-' . $Self->{UserID} . '-' . $LimitGroup;

    my $Content = $Self->{CacheObject}->Get(
        Type => 'DashboardQueueOverview',
        Key  => $CacheKey,
    );
    return $Content if defined $Content;

    # get configured states, get their state ID and test if they exist while we do it
    my %States;
    my $StateIDURL;
    for my $StateOrder ( sort keys %{ $Self->{Config}->{States} } ) {
        my $State = ${ $Self->{Config}->{States} }{$StateOrder};

        # check if state is found, to record StateID
        my $StateID = $Self->{StateObject}->StateLookup(
            State => $State,
        ) || '';
        if ($StateID) {
            $States{$State} = $StateID;

            # append StateID to URL for search string
            $StateIDURL .= "StateIDs=$StateID;";
        }
        else {

            # state does not exist, skipping
            delete ${ $Self->{Config}->{States} }{$StateOrder};
        }
    }

    # get all queues
    my %Queues = $Self->{QueueObject}->GetAllQueues(
        UserID => $Self->{UserID},
        Type   => 'ro',
    );

    # limit them by QueuePermissionGroup if needed
    my $LimitGroupID;
    if ($LimitGroup) {
        $LimitGroupID = $Self->{GroupObject}->GroupLookup(
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
            my $GroupID = $Self->{QueueObject}->GetQueueGroupID(
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

    my %Results;
    for my $QueueID ( sort keys %Queues ) {
        my @Results;
        for my $StateOrderID ( sort keys %{ $Self->{Config}->{States} } ) {
            my $QueueTotal = $Self->{TicketObject}->TicketSearch(
                UserID => $Self->{UserID},
                Result => 'COUNT',
                Queues => [ $Queues{$QueueID} ],
                States => [ ${ $Self->{Config}->{States} }{$StateOrderID} ],
            );
            push @Results, $QueueTotal;
        }

        $Results{ $Queues{$QueueID} } = [@Results];
    }

    # build header
    my @Headers = ( 'Queue', );
    for my $StateOrder ( sort keys %{ $Self->{Config}->{States} } ) {
        push @Headers, ${ $Self->{Config}->{States} }{$StateOrder};
    }

    for my $HeaderItem (@Headers) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketQueueOverviewHeaderStatus',
            Data => {
                Text => $HeaderItem,
            },
        );
    }

    my $HasContent;

    # iterate over all queues, print results;
    my @StatusTotal;
    for my $Queue ( sort values %Queues ) {

        # Hide empty queues
        if ( !grep { $_ > 0 } @{ $Results{$Queue} } ) {
            next;
        }

        $HasContent++;

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketQueueOverviewQueueName',
            Data => { QueueName => $Queue, }
        );

        # iterate over states
        my $Counter = 0;
        my $RowTotal;
        for my $StateOrderID ( sort keys %{ $Self->{Config}->{States} } ) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketQueueOverviewQueueResults',
                Data => {
                    Number  => $Results{$Queue}[$Counter],
                    QueueID => $QueueToID{$Queue},
                    StateID => $States{ ${ $Self->{Config}->{States} }{$StateOrderID} },
                    State   => ${ $Self->{Config}->{States} }{$StateOrderID},
                    Sort    => $Sort,
                },
            );
            $RowTotal += $Results{$Queue}[$Counter];
            $StatusTotal[$StateOrderID] += $Results{$Queue}[$Counter];
            $Counter++;
        }

        # print row (queue) total
        $Self->{LayoutObject}->Block(
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
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketQueueOverviewStatusTotalRow',
        );

        for my $StateOrderID ( sort keys %{ $Self->{Config}->{States} } ) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketQueueOverviewStatusTotal',
                Data => {
                    Number   => $StatusTotal[$StateOrderID],
                    QueueIDs => $QueueIDURL,
                    StateID  => $States{ ${ $Self->{Config}->{States} }{$StateOrderID} },
                    Sort     => $Sort,
                },
            );
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketQueueOverviewNone',
            Data => {
                ColumnCount => ( scalar keys %{ $Self->{Config}->{States} } ) + 2,
                }
        );
    }

    # check for refresh time
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
        my $NameHTML = $Self->{Name};
        $NameHTML =~ s{-}{_}xmsg;
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketQueueOverviewRefresh',
            Data => {
                %{ $Self->{Config} },
                Name        => $Self->{Name},
                NameHTML    => $NameHTML,
                RefreshTime => $Refresh,
            },
        );
    }

    $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardTicketQueueOverview',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
        },
        KeepScriptTags => $Param{AJAX},
    );

    # cache result
    if ( $Self->{Config}->{CacheTTLLocal} ) {
        $Self->{CacheObject}->Set(
            Type  => 'DashboardQueueOverview',
            Key   => $CacheKey,
            Value => $Content || '',
            TTL   => 2 * 60,
        );
    }

    return $Content;
}

1;
