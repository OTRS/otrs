# --
# Kernel/Modules/AgentCustomerSearch.pm - a module used for the autocomplete feature
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentCustomerSearch.pm,v 1.2 2008-11-10 10:54:30 ub Exp $
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
$VERSION = qw($Revision: 1.2 $) [1];

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

    # get customer info
    elsif ( $Self->{Subaction} eq 'CustomerInfo' ) {

        # get params
        my $CustomerUserID = $Self->{ParamObject}->GetParam( Param => 'CustomerUserID' ) || '';

        my $JSON = '';
        my $CustomerID = '';
        my $CustomerTableHTMLString = '';

        # build html for customer info table
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {

            # get customer data
            my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $CustomerUserID,
            );

            # get customer id
            if ( $CustomerData{UserCustomerID} ) {
                $CustomerID = $CustomerData{UserCustomerID};
            }

            # build html string
            $CustomerTableHTMLString = $Self->{LayoutObject}->AgentCustomerViewTable(
                Data => { %CustomerData },
                Max  => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoComposeMaxSize'),
            );
        }

        # build JSON output
        $JSON = $Self->{LayoutObject}->JSON(
            Data => {
                CustomerID => $CustomerID,
                CustomerTableHTMLString => $CustomerTableHTMLString,
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
