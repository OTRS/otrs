# --
# Kernel/Modules/AgentTicketQueue.pm - the queue view of all tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketQueue;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::Lock;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # set debug
    $Self->{Debug} = 0;

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject UserObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    # some new objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{LockObject}  = Kernel::System::Lock->new(%Param);

    # get config data
    $Self->{ViewableSenderTypes} = $Self->{ConfigObject}->Get('Ticket::ViewableSenderTypes')
        || $Self->{LayoutObject}->FatalError(
        Message => 'No Config entry "Ticket::ViewableSenderTypes"!'
        );
    $Self->{CustomQueue} = $Self->{ConfigObject}->Get('Ticket::CustomQueue') || '???';

    # get params
    $Self->{ViewAll} = $Self->{ParamObject}->GetParam( Param => 'ViewAll' )  || 0;
    $Self->{Start}   = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;
    $Self->{Filter}  = $Self->{ParamObject}->GetParam( Param => 'Filter' )   || 'Unlocked';
    $Self->{View}    = $Self->{ParamObject}->GetParam( Param => 'View' )     || '';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # store last queue screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    my $SortBy = $Self->{Config}->{'SortBy::Default'} || 'Age';
    if ( $Self->{ParamObject}->GetParam( Param => 'SortBy' ) ) {
        $SortBy = $Self->{ParamObject}->GetParam( Param => 'SortBy' );
    }

    my $OrderBy;
    if ( $Self->{ParamObject}->GetParam( Param => 'OrderBy' ) ) {
        $OrderBy = $Self->{ParamObject}->GetParam( Param => 'OrderBy' );
    }

    # if we have only one queue, check if there
    # is a setting in Config.pm for sorting
    if ( !$OrderBy ) {
        if ( $Self->{Config}->{QueueSort} ) {
            if ( defined $Self->{Config}->{QueueSort}->{ $Self->{QueueID} } ) {
                if ( $Self->{Config}->{QueueSort}->{ $Self->{QueueID} } ) {
                    $OrderBy = 'Down';
                }
                else {
                    $OrderBy = 'Up';
                }
            }
        }
    }
    if ( !$OrderBy ) {
        $OrderBy = $Self->{Config}->{'Order::Default'} || 'Up';
    }

    # build NavigationBar & to get the output faster!
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $Self->{LayoutObject}->Header( Refresh => $Refresh, );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Self->{LayoutObject}->Print( Output => \$Output );
    $Output = '';

    # viewable locks
    my @ViewableLockIDs = $Self->{LockObject}->LockViewableLock( Type => 'ID' );

    # viewable states
    my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
        Type   => 'Viewable',
        Result => 'ID',
    );

    # get permissions
    my $Permission = 'rw';
    if ( $Self->{Config}->{ViewAllPossibleTickets} ) {
        $Permission = 'ro';
    }

    # sort on default by using both (Priority, Age) else use only one sort argument
    my %Sort;

    # get if search result should be pre-sorted by priority
    my $PreSortByPriority = $Self->{Config}->{'PreSort::ByPriority'};
    if ( !$PreSortByPriority ) {
        %Sort = (
            SortBy  => $SortBy,
            OrderBy => $OrderBy,
        );
    }
    else {
        %Sort = (
            SortBy  => [ 'Priority', $SortBy ],
            OrderBy => [ 'Down',     $OrderBy ],
        );
    }

    # get custom queues
    my @ViewableQueueIDs;
    if ( !$Self->{QueueID} ) {
        @ViewableQueueIDs = $Self->{QueueObject}->GetAllCustomQueues( UserID => $Self->{UserID}, );
    }
    else {
        @ViewableQueueIDs = ( $Self->{QueueID} );
    }

    my %Filters = (
        All => {
            Name   => 'All tickets',
            Prio   => 1000,
            Search => {
                StateIDs => \@ViewableStateIDs,
                QueueIDs => \@ViewableQueueIDs,
                %Sort,
                Permission => $Permission,
                UserID     => $Self->{UserID},
            },
        },
        Unlocked => {
            Name   => 'Available tickets',
            Prio   => 1001,
            Search => {
                LockIDs  => \@ViewableLockIDs,
                StateIDs => \@ViewableStateIDs,
                QueueIDs => \@ViewableQueueIDs,
                %Sort,
                Permission => $Permission,
                UserID     => $Self->{UserID},
            },
        },
    );

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
        $Self->{LayoutObject}->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    # get personal page shown count
    my $PageShownPreferencesKey = 'UserTicketOverview' . $Self->{View} . 'PageShown';
    my $PageShown = $Self->{$PageShownPreferencesKey} || 10;

    # get data (viewable tickets...)
    # search all tickets
    my @ViewableTickets;
    if (@ViewableQueueIDs) {
        @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{ $Self->{Filter} }->{Search} },
            Limit  => $Self->{Start} + $PageShown - 1,
            Result => 'ARRAY',
        );
    }

    my $CountTotal = 0;
    my %NavBarFilter;
    for my $Filter ( sort keys %Filters ) {
        my $Count = 0;
        if (@ViewableQueueIDs) {
            $Count = $Self->{TicketObject}->TicketSearch(
                %{ $Filters{$Filter}->{Search} },
                Result => 'COUNT',
            );
        }

        if ( $Filter eq $Self->{Filter} ) {
            $CountTotal = $Count;
        }

        $NavBarFilter{ $Filters{$Filter}->{Prio} } = {
            Count  => $Count,
            Filter => $Filter,
            %{ $Filters{$Filter} },
        };
    }

    my $LinkSort = 'QueueID='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{QueueID} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';';
    my $LinkPage = 'QueueID='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{QueueID} )
        . ';Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . ';';
    my $LinkFilter = 'QueueID='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{QueueID} )
        . ';';

    my %NavBar = $Self->BuildQueueView( QueueIDs => \@ViewableQueueIDs, Filter => $Self->{Filter} );

    # show tickets
    $Self->{LayoutObject}->Print(
        Output => \$Self->{LayoutObject}->TicketListShow(

            Filter     => $Self->{Filter},
            Filters    => \%NavBarFilter,
            FilterLink => $LinkFilter,

            DataInTheMiddle => $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentTicketQueue',
                Data         => \%NavBar,
            ),

            TicketIDs => \@ViewableTickets,
            Total     => $CountTotal,

            NavBar => \%NavBar,
            View   => $Self->{View},

            Bulk       => 1,
            TitleName  => 'QueueView',
            TitleValue => $NavBar{SelectedQueue},

            Env        => $Self,
            LinkPage   => $LinkPage,
            LinkSort   => $LinkSort,
            LinkFilter => $LinkFilter,

            OrderBy => $OrderBy,
            SortBy  => $SortBy,
        ),
    );

    # get page footer
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub BuildQueueView {
    my ( $Self, %Param ) = @_;

    my %Data = $Self->{TicketObject}->TicketAcceleratorIndex(
        UserID        => $Self->{UserID},
        QueueID       => $Self->{QueueID},
        ShownQueueIDs => $Param{QueueIDs},
        Filter        => $Param{Filter},
    );

    # build output ...
    my %AllQueues = $Self->{QueueObject}->QueueList( Valid => 0 );
    return $Self->_MaskQueueView(
        %Data,
        QueueID         => $Self->{QueueID},
        AllQueues       => \%AllQueues,
        ViewableTickets => $Self->{ViewableTickets},
    );
}

sub _MaskQueueView {
    my ( $Self, %Param ) = @_;

    my $QueueID         = $Param{QueueID} || 0;
    my @QueuesNew       = @{ $Param{Queues} };
    my $QueueIDOfMaxAge = $Param{QueueIDOfMaxAge} || -1;
    my %AllQueues       = %{ $Param{AllQueues} };
    my %Counter;
    my %UsedQueue;
    my @ListedQueues;
    my $Level       = 0;
    my $CustomQueue = $Self->{LayoutObject}->{LanguageObject}->Get( $Self->{CustomQueue} );
    $Self->{HighlightAge1} = $Self->{Config}->{HighlightAge1};
    $Self->{HighlightAge2} = $Self->{Config}->{HighlightAge2};
    $Self->{Blink}         = $Self->{Config}->{Blink};

    $Param{SelectedQueue} = $AllQueues{$QueueID} || $CustomQueue;
    my @MetaQueue = split /::/, $Param{SelectedQueue};
    $Level = $#MetaQueue + 2;

    # prepare shown queues (short names)
    # - get queue total count -
    for my $QueueRef (@QueuesNew) {
        push @ListedQueues, $QueueRef;
        my %Queue = %$QueueRef;
        my @Queue = split /::/, $Queue{Queue};

        # remember counted/used queues
        $UsedQueue{ $Queue{Queue} } = 1;

        # move to short queue names
        my $QueueName = '';
        for ( 0 .. $#Queue ) {
            if ( !$QueueName ) {
                $QueueName .= $Queue[$_];
            }
            else {
                $QueueName .= '::' . $Queue[$_];
            }
            if ( !$Counter{$QueueName} ) {
                $Counter{$QueueName} = 0;
            }
            $Counter{$QueueName} = $Counter{$QueueName} + $Queue{Count};
            if ( $Counter{$QueueName} && !$Queue{$QueueName} && !$UsedQueue{$QueueName} ) {
                my %Hash = ();
                $Hash{Queue} = $QueueName;
                $Hash{Count} = $Counter{$QueueName};
                for ( sort keys %AllQueues ) {
                    if ( $AllQueues{$_} eq $QueueName ) {
                        $Hash{QueueID} = $_;
                    }
                }
                $Hash{MaxAge} = 0;
                push( @ListedQueues, \%Hash );
                $UsedQueue{$QueueName} = 1;
            }
        }
    }

    # build queue string
    for my $QueueRef (@ListedQueues) {
        my $QueueStrg = '';
        my %Queue     = %$QueueRef;

        # replace name of CustomQueue
        if ( $Queue{Queue} eq 'CustomQueue' ) {
            $Counter{$CustomQueue} = $Counter{ $Queue{Queue} };
            $Queue{Queue} = $CustomQueue;
        }
        my @QueueName = split /::/, $Queue{Queue};
        my $ShortQueueName = $QueueName[-1];
        $Queue{MaxAge} = $Queue{MaxAge} / 60;
        $Queue{QueueID} = 0 if ( !$Queue{QueueID} );

        $QueueStrg
            .= "<li><a href=\"$Self->{LayoutObject}->{Baselink}Action=AgentTicketQueue;QueueID=$Queue{QueueID}";
        $QueueStrg .= ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} ) . '"';

        $QueueStrg .= ' class="';

        # should i highlight this queue
        # the oldest queue
        if ( $Queue{QueueID} == $QueueIDOfMaxAge && $Self->{Blink} ) {
            $QueueStrg .= 'Oldest';
        }
        elsif ( $Queue{MaxAge} >= $Self->{HighlightAge2} ) {
            $QueueStrg .= 'OlderLevel2';
        }
        elsif ( $Queue{MaxAge} >= $Self->{HighlightAge1} ) {
            $QueueStrg .= 'OlderLevel1';
        }

        # display the current and all its lower levels in bold
        my $CheckQueueName;
        if (
            $Level > scalar @QueueName
            && scalar @MetaQueue >= scalar @QueueName
            && $Param{SelectedQueue} =~ m{ \A \Q$QueueName[0]\E }xms
            )
        {
            my $CheckLevel = 0;
            CHECKLEVEL:
            for ( $CheckLevel = 0; $CheckLevel < scalar @QueueName; ++$CheckLevel ) {
                if ($CheckQueueName) {
                    $CheckQueueName .= '::';
                }
                $CheckQueueName .= $MetaQueue[$CheckLevel];
            }
        }

        # should i display this queue in bold?
        if ( $CheckQueueName && $Queue{Queue} =~ m{ \A \Q$CheckQueueName\E \z }xms ) {
            $QueueStrg .= ' Active';
        }

        $QueueStrg .= '">';

        # remember to selected queue info
        if ( $QueueID eq $Queue{QueueID} ) {
            $Param{SelectedQueue} = $Queue{Queue};
            $Param{AllSubTickets} = $Counter{ $Queue{Queue} };
        }

        # QueueStrg
        $QueueStrg .= $Self->{LayoutObject}->Ascii2Html( Text => $ShortQueueName )
            . " ($Counter{$Queue{Queue}})";

        $QueueStrg .= '</a></li>';

        if ( scalar @QueueName eq 1 ) {
            $Param{QueueStrg} .= $QueueStrg;
        }
        elsif ( $Level >= scalar @QueueName ) {
            my $CheckQueueStrgName = '';
            for ( my $LevelCount = 0; $LevelCount < scalar @QueueName - 1; ++$LevelCount ) {
                $CheckQueueStrgName .= $MetaQueue[$LevelCount] . '::';
            }
            if ( $Queue{Queue} =~ m{ \A \Q$CheckQueueStrgName\E }xms ) {

                $Param{ 'QueueStrg' . scalar @QueueName - 1 } .= $QueueStrg;
            }
        }
    }

    my $Counter = 0;
    KEYS:
    for my $Keys ( sort keys %Param ) {
        if ( $Keys !~ /^QueueStrg/ ) {
            next KEYS;
        }
        my $Class = $Counter;
        if ( $Counter > 10 ) {
            $Class = 'X';
        }

        $Param{QueueStrgLevel}
            .= '<ul class="QueueOverviewList Level_' . $Class . '">' . $Param{$Keys} . '</ul>';
        $Counter++;
    }

    return (
        MainName      => 'Queues',
        SelectedQueue => $Param{SelectedQueue},
        MainContent   => $Param{QueueStrgLevel},
        Total         => $Param{TicketsShown},
    );
}

1;
