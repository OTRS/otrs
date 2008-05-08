# --
# Kernel/Modules/AgentTicketMailbox.pm - to view all locked tickets
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketMailbox.pm,v 1.25 2008-05-08 22:05:25 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketMailbox;

use strict;
use warnings;

use Kernel::System::State;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.25 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject UserObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    $Self->{StateObject}     = Kernel::System::State->new(%Param);

    $Self->{StartHit}        = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;
    $Self->{PageShown}       = $Self->{UserQueueViewShowTickets}
        || $Self->{ConfigObject}->Get('PreferencesGroups')->{QueueViewShownTickets}->{DataSelected}
        || 10;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;
    my $QueueID = $Self->{QueueID};
    my $SortBy = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'Age';
    my $OrderBy = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Up';

    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # store last queue screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # starting with page ...
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    $Self->{LayoutObject}->Block(
        Name => 'MetaLink',
        Data => {
            Rel   => 'search',
            Type  => 'application/opensearchdescription+xml',
            Title => '$Quote{"$Config{"ProductName"}"} ($Quote{"$Config{"Ticket::Hook"}"})',
            Href  => '$Env{"Baselink"}Action=AgentTicketSearch&Subaction=OpenSearchDescription',
        },
    );
    $Output .= $Self->{LayoutObject}->Header( Refresh => $Refresh, );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    my %LockedData = $Self->{TicketObject}->GetLockedCount( UserID => $Self->{UserID} );

    # get locked  viewable tickets...
    my @ViewableTickets = ();
    my $SortByS         = $SortBy;
    if ( $SortByS eq 'CreateTime' ) {
        $SortByS = 'Age';
    }

    # check view type
    if ( !$Self->{Subaction} ) {
        $Self->{Subaction} = 'All';
    }

    if ( $Self->{Subaction} eq 'Pending' ) {
        my @StateIDs = $Self->{StateObject}->StateGetStatesByType(
            Type   => 'PendingReminder',
            Result => 'ARRAY',
        );
        push(
            @StateIDs,
            $Self->{StateObject}->StateGetStatesByType(
                Type   => 'PendingAuto',
                Result => 'ARRAY',
                )
        );
        @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            Result     => 'ARRAY',
            Limit      => 1000,
            StateIDs   => \@StateIDs,
            Locks      => ['lock'],
            OwnerIDs   => [ $Self->{UserID} ],
            OrderBy    => $OrderBy,
            SortBy     => $SortByS,
            UserID     => 1,
            Permission => 'ro',
        );
    }
    elsif ( $Self->{Subaction} eq 'Reminder' ) {
        my @StateIDs = $Self->{StateObject}->StateGetStatesByType(
            Type   => 'PendingReminder',
            Result => 'ARRAY',
        );
        @ViewableTickets = ();
        my @ViewableTicketsTmp = $Self->{TicketObject}->TicketSearch(
            Result     => 'ARRAY',
            Limit      => 1000,
            StateIDs   => \@StateIDs,
            Locks      => ['lock'],
            OwnerIDs   => [ $Self->{UserID} ],
            OrderBy    => $OrderBy,
            SortBy     => $SortByS,
            UserID     => 1,
            Permission => 'ro',
        );
        for my $TicketID (@ViewableTicketsTmp) {
            my @Index = $Self->{TicketObject}->ArticleIndex( TicketID => $TicketID );
            if (@Index) {
                my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Index[-1] );
                if ( $Article{UntilTime} < 1 ) {
                    push( @ViewableTickets, $TicketID );
                }
            }
        }
    }
    elsif ( $Self->{Subaction} eq 'New' ) {
        @ViewableTickets = ();
        my @ViewableTicketsTmp = $Self->{TicketObject}->TicketSearch(
            Result     => 'ARRAY',
            Limit      => 1000,
            Locks      => ['lock'],
            OwnerIDs   => [ $Self->{UserID} ],
            OrderBy    => $OrderBy,
            SortBy     => $SortByS,
            UserID     => 1,
            Permission => 'ro',
        );
        for my $TicketID (@ViewableTicketsTmp) {

            # check what tickets are new
            my $Message = '';
            if ( $LockedData{NewTicketIDs}->{$TicketID} ) {
                $Message = 'New message!';
            }
            if ($Message) {
                push( @ViewableTickets, $TicketID );
            }
        }
    }
    elsif ( $Self->{Subaction} eq 'Responsible' ) {
        @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            Result         => 'ARRAY',
            Limit          => 1000,
            StateType      => 'Open',
            ResponsibleIDs => [ $Self->{UserID} ],
            OrderBy        => $OrderBy,
            SortBy         => $SortByS,
            UserID         => 1,
            Permission     => 'ro',
        );
    }
    elsif ( $Self->{Subaction} eq 'Watched' ) {
        @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            Result       => 'ARRAY',
            Limit        => 1000,
            OrderBy      => $OrderBy,
            SortBy       => $SortByS,
            WatchUserIDs => [ $Self->{UserID} ],
            UserID       => 1,
            Permission   => 'ro',
        );
    }
    else {
        @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            Result     => 'ARRAY',
            Limit      => 1000,
            Locks      => ['lock'],
            OwnerIDs   => [ $Self->{UserID} ],
            OrderBy    => $OrderBy,
            SortBy     => $SortByS,
            UserID     => 1,
            Permission => 'ro',
        );
    }

    # get article data
    my $Counter      = 0;
    my $CounterShown = 0;
    my $AllTickets   = 0;
    if (@ViewableTickets) {
        $AllTickets = $#ViewableTickets + 1;
    }
    for my $TicketID (@ViewableTickets) {
        $Counter++;
        if (
            $Counter >= $Self->{StartHit}
            && $Counter < ( $Self->{PageShown} + $Self->{StartHit} )
            )
        {
            my %Article = ();
            my @ArticleBody = $Self->{TicketObject}->ArticleGet( TicketID => $TicketID );
            if ( !@ArticleBody ) {
                next;
            }
            %Article = %{ $ArticleBody[-1] };

            # return latest non internal article
            for my $Content ( reverse @ArticleBody ) {
                my %ArticlePart = %{$Content};
                if ( $ArticlePart{SenderType} eq 'customer' ) {
                    %Article = %ArticlePart;
                    last;
                }
            }

            # check what tickets are new
            my $Message = '';
            if ( $LockedData{NewTicketIDs}->{$TicketID} ) {
                $Message = 'New message!';
            }

            # show ticket
            $CounterShown++;
            $Self->MaskMailboxTicket(
                %Article,
                Message => $Message,
                Counter => $CounterShown,
            );
        }
    }

    # create & return output
    my %PageNav = $Self->{LayoutObject}->PageNavBar(
        Limit     => 10000,
        StartHit  => $Self->{StartHit},
        PageShown => $Self->{PageShown},
        AllHits   => $AllTickets,
        Action    => "Action=AgentTicketMailbox",
        Link      => "Subaction=$Self->{Subaction}&SortBy=$SortBy&OrderBy=$OrderBy&",
    );
    $Self->{LayoutObject}->Block(
        Name => 'NavBar',
        Data => {
            %LockedData,
            SortBy   => $SortBy,
            OrderBy  => $OrderBy,
            ViewType => $Self->{Subaction},
            %PageNav,
            }
    );

    # create & return output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketMailbox',
        Data         => { %Param, },
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub MaskMailboxTicket {
    my ( $Self, %Param ) = @_;

    $Param{Message} = $Self->{LayoutObject}->{LanguageObject}->Get( $Param{Message} ) . ' ';

    # get ack actions
    $Self->{TicketObject}->TicketAcl(
        Data          => '-',
        Action        => $Self->{Action},
        TicketID      => $Param{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $Self->{TicketObject}->TicketAclActionData();

    # check if the pending ticket is Over Time
    if ( $Param{UntilTime} < 0 && $Param{State} !~ /^pending auto/i ) {
        $Param{Message} .= $Self->{LayoutObject}->{LanguageObject}->Get('Timeover') . ' '
            . $Self->{LayoutObject}->CustomerAge( Age => $Param{UntilTime}, Space => ' ' ) . '!';
    }

    # create PendingUntil string if UntilTime is < -1
    if ( $Param{UntilTime} ) {
        if ( $Param{UntilTime} < -1 ) {
            $Param{PendingUntil} = "<font color='red'>";
        }
        $Param{PendingUntil} .= $Self->{LayoutObject}->CustomerAge(
            Age   => $Param{UntilTime},
            Space => '<br>',
        );
        if ( $Param{UntilTime} < -1 ) {
            $Param{PendingUntil} .= "</font>";
        }
    }

    # do some strips && quoting
    $Param{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Param{Age}, Space => ' ' );
    $Self->{LayoutObject}->Block(
        Name => 'Ticket',
        Data => { %Param, %AclAction, },
    );

    # ticket bulk block
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::BulkFeature') ) {
        $Self->{LayoutObject}->Block(
            Name => 'Bulk',
            Data => {%Param},
        );
    }

    # ticket title
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::Title') ) {
        $Self->{LayoutObject}->Block(
            Name => 'Title',
            Data => {%Param},
        );
    }

    # build ticket view
    for (qw(From To Cc Subject)) {
        if ( $Param{$_} ) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    Key   => $_,
                    Value => $Param{$_},
                },
            );
        }
    }
    for ( 1 .. 3 ) {
        if ( $Param{"ArticleFreeText$_"} ) {
            $Self->{LayoutObject}->Block(
                Name => 'ArticleFreeText',
                Data => {
                    Key   => $Param{"ArticleFreeKey$_"},
                    Value => $Param{"ArticleFreeText$_"},
                },
            );
        }
    }

    # run ticket pre menu modules
    if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') eq 'HASH' ) {
        my %Menus   = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') };
        my $Counter = 0;
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    TicketID => $Self->{TicketID},
                );

                # run module
                $Counter = $Object->Run(
                    %Param,
                    Ticket  => \%Param,
                    Counter => $Counter,
                    ACL     => \%AclAction,
                    Config  => $Menus{$Menu},
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }
    return 1;
}

1;
