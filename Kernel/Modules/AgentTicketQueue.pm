# --
# Kernel/Modules/AgentTicketQueue.pm - the queue view of all tickets
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketQueue.pm,v 1.63 2009-01-12 12:50:08 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketQueue;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::Lock;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.63 $) [1];

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

    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    my $SortDefault = 1;

    my $SortBy = $Self->{Config}->{'SortBy::Default'} || 'Age';
    if ( $Self->{ParamObject}->GetParam( Param => 'SortBy' ) ) {
        $SortBy = $Self->{ParamObject}->GetParam( Param => 'SortBy' );
        $SortDefault = 0;
    }

    my $OrderBy;
    if ( $Self->{ParamObject}->GetParam( Param => 'OrderBy' ) ) {
        $OrderBy = $Self->{ParamObject}->GetParam( Param => 'OrderBy' );
        $SortDefault = 0;
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

    # get custom queues
    my @ViewableQueueIDs = ();
    if ( !$Self->{QueueID} ) {
        @ViewableQueueIDs = $Self->{QueueObject}->GetAllCustomQueues( UserID => $Self->{UserID}, );
    }
    else {
        @ViewableQueueIDs = ( $Self->{QueueID} );
    }

    # get data (viewable tickets...)
    my @ViewableTickets = ();
    if (@ViewableQueueIDs) {

        # viewable states
        my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
            Type   => 'Viewable',
            Result => 'ID',
        );

        # viewable locks
        my @ViewableLockIDs = $Self->{LockObject}->LockViewableLock( Type => 'ID' );

        # get permissions
        my $Permission = 'rw';
        if ( $Self->{Config}->{ViewAllPossibleTickets} ) {
            $Permission = 'ro';
        }

        # sort on default by using both (Priority, Age) else use only one sort argument
        my %Sort;
        if ( !$SortDefault ) {
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

        # search all tickets
        @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            StateIDs => \@ViewableStateIDs,
            LockIDs  => \@ViewableLockIDs,
            QueueIDs => \@ViewableQueueIDs,
            %Sort,
            Permission => $Permission,
            UserID     => $Self->{UserID},
            Result     => 'ARRAY',
            Limit      => $Self->{Start} + 50,
        );
    }

    my $LinkSort = 'QueueID='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{QueueID} )
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&';
    my $LinkPage = 'QueueID='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{QueueID} )
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . '&';
    my $LinkFilter = 'QueueID='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{QueueID} )
        . '&';

    my %NavBar = $Self->BuildQueueView( QueueIDs => \@ViewableQueueIDs );

    # show ticket's
    $Self->{LayoutObject}->Print(
        Output => \$Self->{LayoutObject}->TicketListShow(
            TicketIDs  => \@ViewableTickets,
            Total      => $NavBar{Total},
            Env        => $Self,
            NavBar     => \%NavBar,
            Bulk       => 1,
            View       => $Self->{View},
            TitleName  => 'QueueView',
            TitleValue => $NavBar{SelectedQueue},
            LinkPage   => $LinkPage,
            LinkSort   => $LinkSort,
            LinkFilter => $LinkFilter,
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
    );

    # build output ...
    my %AllQueues = $Self->{QueueObject}->GetAllQueues();
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
    my %Counter         = ();
    my %UsedQueue       = ();
    my @ListedQueues    = ();
    my $Level           = 0;
    my $CustomQueue     = $Self->{LayoutObject}->{LanguageObject}->Get( $Self->{CustomQueue} );
    $Self->{HighlightAge1}   = $Self->{Config}->{HighlightAge1};
    $Self->{HighlightAge2}   = $Self->{Config}->{HighlightAge2};
    $Self->{HighlightColor1} = $Self->{Config}->{HighlightColor1};
    $Self->{HighlightColor2} = $Self->{Config}->{HighlightColor2};

    $Param{SelectedQueue} = $AllQueues{$QueueID} || $CustomQueue;
    my @MetaQueue = split( /::/, $Param{SelectedQueue} );
    $Level = $#MetaQueue + 2;

    # prepare shown queues (short names)
    # - get queue total count -
    for my $QueueRef (@QueuesNew) {
        push( @ListedQueues, $QueueRef );
        my %Queue = %$QueueRef;
        my @Queue = split( /::/, $Queue{Queue} );

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
                for ( keys %AllQueues ) {
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
        my @QueueName = split( /::/, $Queue{Queue} );
        my $ShortQueueName = $QueueName[-1];
        $Queue{MaxAge} = $Queue{MaxAge} / 60;
        $Queue{QueueID} = 0 if ( !$Queue{QueueID} );

        # should i highlight this queue
        if ( $Param{SelectedQueue} =~ /^\Q$QueueName[0]\E/ && $Level - 1 >= $#QueueName ) {
            if ( $#QueueName == 0 && $#MetaQueue >= 0 && $Queue{Queue} =~ /^\Q$MetaQueue[0]\E$/ ) {
                $QueueStrg .= '<b>';
            }
            if (
                $#QueueName == 1
                && $#MetaQueue >= 1
                && $Queue{Queue} =~ /^\Q$MetaQueue[0]::$MetaQueue[1]\E$/
                )
            {
                $QueueStrg .= '<b>';
            }
            if (
                $#QueueName == 2
                && $#MetaQueue >= 2
                && $Queue{Queue} =~ /^\Q$MetaQueue[0]::$MetaQueue[1]::$MetaQueue[2]\E$/
                )
            {
                $QueueStrg .= '<b>';
            }
            if (
                $#QueueName == 3
                && $#MetaQueue >= 3
                && $Queue{Queue}
                =~ /^\Q$MetaQueue[0]::$MetaQueue[1]::$MetaQueue[2]::$MetaQueue[3]\E$/
                )
            {
                $QueueStrg .= '<b>';
            }
        }

        # remember to selected queue info
        if ( $QueueID eq $Queue{QueueID} ) {
            $Param{SelectedQueue} = $Queue{Queue};
            $Param{AllSubTickets} = $Counter{ $Queue{Queue} };
        }
        $QueueStrg
            .= "<a href=\"$Self->{LayoutObject}->{Baselink}Action=AgentTicketQueue&QueueID=$Queue{QueueID}";
        $QueueStrg .= '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} ) . '"';
        $QueueStrg
            .= ' onmouseover="window.status=\'$Text{"Queue"}: '
            . $Queue{Queue}
            . '\'; return true;" onmouseout="window.status=\'\';">';

        # should i highlight this queue
        if ( $Queue{MaxAge} >= $Self->{HighlightAge2} ) {
            $QueueStrg .= "<font color='$Self->{HighlightColor2}'>";
        }
        elsif ( $Queue{MaxAge} >= $Self->{HighlightAge1} ) {
            $QueueStrg .= "<font color='$Self->{HighlightColor1}'>";
        }

        # the oldest queue
        if ( $Queue{QueueID} == $QueueIDOfMaxAge ) {
            $QueueStrg .= "<blink>";
        }

        # QueueStrg
        $QueueStrg .= $Self->{LayoutObject}->Ascii2Html( Text => $ShortQueueName )
            . " ($Counter{$Queue{Queue}})";

        # the oldest queue
        if ( $Queue{QueueID} == $QueueIDOfMaxAge ) {
            $QueueStrg .= "</blink>";
        }

        # should i highlight this queue
        if ( $Queue{MaxAge} >= $Self->{HighlightAge1} || $Queue{MaxAge} >= $Self->{HighlightAge2} )
        {
            $QueueStrg .= "</font>";
        }
        $QueueStrg .= "</a>";

        # should i highlight this queue
        if ( $Param{SelectedQueue} =~ /^\Q$QueueName[0]\E/ && $Level >= $#QueueName ) {
            if ( $#QueueName == 0 && $#MetaQueue >= 0 && $Queue{Queue} =~ /^\Q$MetaQueue[0]\E$/ ) {
                $QueueStrg .= '</b>';
            }
            if (
                $#QueueName == 1
                && $#MetaQueue >= 1
                && $Queue{Queue} =~ /^\Q$MetaQueue[0]::$MetaQueue[1]\E$/
                )
            {
                $QueueStrg .= '</b>';
            }
            if (
                $#QueueName == 2
                && $#MetaQueue >= 2
                && $Queue{Queue} =~ /^\Q$MetaQueue[0]::$MetaQueue[1]::$MetaQueue[2]\E$/
                )
            {
                $QueueStrg .= '</b>';
            }
            if (
                $#QueueName == 3
                && $#MetaQueue >= 3
                && $Queue{Queue}
                =~ /^\Q$MetaQueue[0]::$MetaQueue[1]::$MetaQueue[2]::$MetaQueue[3]\E$/
                )
            {
                $QueueStrg .= '</b>';
            }
        }

        if ( $#QueueName == 0 ) {
            if ( $Param{QueueStrg} ) {
                $QueueStrg = ' - ' . $QueueStrg;
            }
            $Param{QueueStrg} .= $QueueStrg;
        }
        elsif ( $#QueueName == 1 && $Level >= 2 && $Queue{Queue} =~ /^\Q$MetaQueue[0]::\E/ ) {
            if ( $Param{QueueStrg1} ) {
                $QueueStrg = ' - ' . $QueueStrg;
            }
            $Param{QueueStrg1} .= $QueueStrg;
        }
        elsif (
            $#QueueName == 2
            && $Level >= 3
            && $Queue{Queue} =~ /^\Q$MetaQueue[0]::$MetaQueue[1]::\E/
            )
        {
            if ( $Param{QueueStrg2} ) {
                $QueueStrg = ' - ' . $QueueStrg;
            }
            $Param{QueueStrg2} .= $QueueStrg;
        }
        elsif (
            $#QueueName == 3
            && $Level >= 4
            && $Queue{Queue} =~ /^\Q$MetaQueue[0]::$MetaQueue[1]::$MetaQueue[2]::\E/
            )
        {
            if ( $Param{QueueStrg3} ) {
                $QueueStrg = ' - ' . $QueueStrg;
            }
            $Param{QueueStrg3} .= $QueueStrg;
        }
        elsif (
            $#QueueName == 4
            && $Level >= 5
            && $Queue{Queue}
            =~ /^\Q$MetaQueue[0]::$MetaQueue[1]::$MetaQueue[2]::$MetaQueue[3]::\E/
            )
        {
            if ( $Param{QueueStrg4} ) {
                $QueueStrg = ' - ' . $QueueStrg;
            }
            $Param{QueueStrg4} .= $QueueStrg;
        }
    }
    for ( 1 .. 5 ) {
        if ( $Param{ 'QueueStrg' . $_ } ) {
            $Param{'QueueStrg'} .= '<br>' . $Param{ 'QueueStrg' . $_ };
        }
    }
    return (
        MainName      => 'Queues',
        SelectedQueue => $Param{SelectedQueue},
        MainContent   => $Param{QueueStrg},
        PageNavBar    => $Param{PageNavBar},
        Total         => $Param{TicketsShown},
    );
}

1;
