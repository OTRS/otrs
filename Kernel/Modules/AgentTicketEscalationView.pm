# --
# Kernel/Modules/AgentTicketEscalationView.pm - status for all open tickets
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketEscalationView.pm,v 1.5 2008-06-13 08:09:44 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketEscalationView;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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

    # needed objects
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    # get params
    $Self->{SortBy} = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'EscalationTime';
    $Self->{Order} = $Self->{ParamObject}->GetParam( Param => 'Order' )
        || $Self->{Config}->{'Order::Default'}
        || 'Up';

    # viewable tickets a page
    $Self->{Limit} = $Self->{ParamObject}->GetParam( Param => 'Limit' ) || 6000;

    $Self->{StartHit} = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;
    $Self->{PageShown} = $Self->{Config}->{ViewableTicketsPage} || 50;
    $Self->{Escalation} = $Self->{ParamObject}->GetParam( Param => 'Escalation' ) || 'Today';

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
    my $Output = $Self->{LayoutObject}->Header( Refresh => $Refresh, );

    # build NavigationBar
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # to get the output faster!
    $Self->{LayoutObject}->Print( Output => \$Output );
    $Output = '';

    my $TimeStamp;
    if ( $Self->{Escalation} eq 'NextWeek' ) {
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime() + 60 * 60 * 24 * 7,
        );
        $TimeStamp = "$Year-$Month-$Day 23:59:59";
    }
    elsif ( $Self->{Escalation} eq 'Tomorrow' ) {
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime() + 60 * 60 * 24,
        );
        $TimeStamp = "$Year-$Month-$Day 23:59:59";
    }
    else {
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );
        $TimeStamp = "$Year-$Month-$Day 23:59:59";
    }

    # get shown tickets
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        Result                        => 'ARRAY',
        Limit                         => $Self->{Limit},
        TicketEscalationTimeOlderDate => $TimeStamp,
        OrderBy                       => $Self->{Order},
        SortBy                        => $Self->{SortBy},
        UserID                        => $Self->{UserID},
        Permission                    => 'ro',
    );

    # show ticket's
    my $Counter = 0;
    for my $TicketID (@TicketIDs) {
        $Counter++;
        if (
            $Counter >= $Self->{StartHit}
            && $Counter < ( $Self->{PageShown} + $Self->{StartHit} )
            )
        {

            # get last customer article
            my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
                TicketID => $TicketID,
            );

            # prepare subject
            $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
                TicketNumber => $Article{TicketNumber},
                Subject => $Article{Subject} || '',
            );

            # create human age
            $Article{Age} = $Self->{LayoutObject}->CustomerAge(
                Age   => $Article{Age},
                Space => ' ',
            );

            $Article{EscalationTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Article{EscalationTime},
                Space => ' ',
            );

            $Article{EscalationTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Article{EscalationTimeWorkingTime},
                Space => ' ',
            );

            # customer info (customer name)
            my %CustomerData = ();
            if ( $Article{CustomerUserID} ) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $Article{CustomerUserID},
                );
            }
            if ( $CustomerData{UserLogin} ) {
                $Article{CustomerName} = $Self->{CustomerUserObject}->CustomerName(
                    UserLogin => $CustomerData{UserLogin},
                );
            }

            # user info
            my %UserInfo = $Self->{UserObject}->GetUserData(
                User   => $Article{Owner},
                Cached => 1
            );

            # seperate each searchresult line by using several css
            if ( $Counter % 2 ) {
                $Article{css} = "searchpassive";
            }
            else {
                $Article{css} = "searchactive";
            }
            $Self->{LayoutObject}->Block(
                Name => 'Record',
                Data => { %Article, %UserInfo },
            );

            if ( $Article{EscalationTime} < 60 * 60 * 1 ) {
                $Self->{LayoutObject}->Block(
                    Name => 'RecordEscalationFontStart',
                    Data => { %Article, %UserInfo },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'RecordEscalationFontStop',
                    Data => { %Article, %UserInfo },
                );
            }
        }
    }

    # build search navigation bar
    my %PageNav = $Self->{LayoutObject}->PageNavBar(
        Limit     => $Self->{Limit},
        StartHit  => $Self->{StartHit},
        PageShown => $Self->{PageShown},
        AllHits   => $Counter,
        Action    => "Action=AgentTicketEscalationView&",
        Link      => "SortBy=$Self->{SortBy}&Order=$Self->{Order}&Escalation=$Self->{Escalation}&",
    );

    # use template
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketEscalationView',
        Data => { %Param, %PageNav, Escalation => $Self->{Escalation}, },
    );

    # get page footer
    $Output .= $Self->{LayoutObject}->Footer();

    # return page
    return $Output;
}

1;
