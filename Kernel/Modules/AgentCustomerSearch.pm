# --
# Kernel/Modules/AgentCustomerSearch.pm - a module used for the autocomplete feature
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentCustomerSearch.pm,v 1.5 2008-11-13 14:49:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentCustomerSearch;

use strict;
use warnings;

use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create needed objects
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    # get config
    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get needed params
    for (qw(Search)) {
        $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    # search customers
    if ( !$Self->{Subaction} ) {

        # get customer list
        my %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
            Search => $Param{Search},
        );

        # build data
        my @Data;
        for my $CustomerUserID ( sort { $CustomerUserList{$a} cmp $CustomerUserList{$b} } keys %CustomerUserList ) {

            # html quote characters like <>
            my $CustomerValuePlain = $CustomerUserList{$CustomerUserID};
            $CustomerUserList{$CustomerUserID} = $Self->{LayoutObject}->Ascii2Html(
                Text => $CustomerUserList{$CustomerUserID},
            );

            push @Data, {
                CustomerKey        => $CustomerUserID,
                CustomerValue      => $CustomerUserList{$CustomerUserID},
                CustomerValuePlain => $CustomerValuePlain,
            };
        }

        # build JSON output
        my $JSON = $Self->{LayoutObject}->JSON(
            Data => {
                Response => {
                    Results => \@Data,
                }
            },
        );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # get customer info and customer tickets
    elsif ( $Self->{Subaction} eq 'CustomerInfo' ) {

        # get params
        my $CustomerUserID = $Self->{ParamObject}->GetParam( Param => 'CustomerUserID' ) || '';
        my $ParentAction = $Self->{ParamObject}->GetParam( Param => 'ParentAction' ) || '';

        my $JSON = '';
        my $CustomerID = '';
        my $CustomerTableHTMLString = '';
        my $CustomerTicketsHTMLString = '';

        # get customer data
        my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $CustomerUserID,
        );

        # get customer id
        if ( $CustomerData{UserCustomerID} ) {
            $CustomerID = $CustomerData{UserCustomerID};
        }

        # build html for customer info table
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {

            $CustomerTableHTMLString = $Self->{LayoutObject}->AgentCustomerViewTable(
                Data => { %CustomerData },
                Max  => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoComposeMaxSize'),
            );
        }

        # get config of ParentAction
        my $ParentActionConfig = $Self->{ConfigObject}->Get("Ticket::Frontend::$ParentAction");

        my $ShowCustomerTickets = 0;
        if ( !defined $ParentActionConfig->{ShownCustomerTickets} ) {
            $ShowCustomerTickets = 1;
        }
        else {
            $ShowCustomerTickets = $ParentActionConfig->{ShownCustomerTickets};
        }

        # show customer tickets
        if ( $CustomerUserID && $ShowCustomerTickets ) {

            # get secondary customer ids
            my @CustomerIDs = $Self->{CustomerUserObject}->CustomerIDs(
                User => $CustomerUserID,
            );
            # get own customer id
            if ( $CustomerID ) {
                push @CustomerIDs, $CustomerID;
            }

            my $View    = $Self->{ParamObject}->GetParam( Param => 'View' );
            my $SortBy  = $Self->{ParamObject}->GetParam( Param => 'SortBy' )  || 'Age';
            my $OrderBy = $Self->{ParamObject}->GetParam( Param => 'OrderBy' ) || 'Down';

            my @ViewableTickets = ();
            if (@CustomerIDs) {
                @ViewableTickets = $Self->{TicketObject}->TicketSearch(
                    Result     => 'ARRAY',
                    Limit      => $ParentActionConfig->{ShownCustomerTickets},
                    SortBy     => [ $SortBy ],
                    OrderBy    => [ $OrderBy ],
                    CustomerID => \@CustomerIDs,
                    UserID     => $Self->{UserID},
                    Permission => 'ro',
                );
            }

            my $LinkSort = 'Subaction=' . $Self->{Subaction}
                . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $View )
                . '&CustomerUserID=' . $Self->{LayoutObject}->Ascii2Html( Text => $CustomerUserID )
                . '&ParentAction=' . $Self->{LayoutObject}->Ascii2Html( Text => $ParentAction )
                . '&';
            my $LinkPage = 'Subaction=' . $Self->{Subaction}
                . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $View )
                . '&SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
                . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
                . '&CustomerUserID=' . $Self->{LayoutObject}->Ascii2Html( Text => $CustomerUserID )
                . '&ParentAction=' . $Self->{LayoutObject}->Ascii2Html( Text => $ParentAction )
                . '&';
            my $LinkFilter = 'Subaction=' . $Self->{Subaction}
                . '&CustomerUserID=' . $Self->{LayoutObject}->Ascii2Html( Text => $CustomerUserID )
                . '&ParentAction=' . $Self->{LayoutObject}->Ascii2Html( Text => $ParentAction )
                . '&';

            $CustomerTicketsHTMLString .= $Self->{LayoutObject}->TicketListShow(
                TicketIDs   => \@ViewableTickets,
                Total       => scalar @ViewableTickets,
                Env         => $Self,
                View        => $View,
                TitleName   => 'Customer Tickets',
                LinkPage    => $LinkPage,
                LinkSort    => $LinkSort,
                LinkFilter  => $LinkFilter,
                Output      => 'raw',
            );

        }

        # build JSON output
        $JSON = $Self->{LayoutObject}->JSON(
            Data => {
                CustomerID => $CustomerID,
                CustomerTableHTMLString   => $CustomerTableHTMLString,
                CustomerTicketsHTMLString => $CustomerTicketsHTMLString,
            },
        );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON || '',
            Type        => 'inline',
            NoCache     => 1,
        );
    }
}

1;
