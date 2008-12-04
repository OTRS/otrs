# --
# Kernel/Modules/AgentTicketCustomer.pm - to set the ticket customer and show the customer history
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketCustomer.pm,v 1.25 2008-12-04 14:52:37 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketCustomer;

use strict;
use warnings;

use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.25 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed Objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{Search}     = $Self->{ParamObject}->GetParam( Param => 'Search' )     || 0;
    $Self->{CustomerID} = $Self->{ParamObject}->GetParam( Param => 'CustomerID' ) || '';

    # customer user object
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # check needed stuff
    if ( !$Self->{TicketID} ) {

        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    if (
        !$Self->{TicketObject}->Permission(
            Type     => $Self->{Config}->{Permission},
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID}
        )
        )
    {

        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # check permissions
    if ( $Self->{TicketID} ) {
        if (
            !$Self->{TicketObject}->Permission(
                Type     => 'customer',
                TicketID => $Self->{TicketID},
                UserID   => $Self->{UserID}
            )
            )
        {

            # no permission screen, don't show ticket
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }
    }

    if ( $Self->{Subaction} eq 'Update' ) {

        # set customer id
        my $ExpandCustomerName1 = $Self->{ParamObject}->GetParam( Param => 'ExpandCustomerName1' )
            || 0;
        my $ExpandCustomerName2 = $Self->{ParamObject}->GetParam( Param => 'ExpandCustomerName2' )
            || 0;
        my $CustomerUserOption = $Self->{ParamObject}->GetParam( Param => 'CustomerUserOption' )
            || '';
        $Param{CustomerUserID} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserID' ) || '';
        $Param{CustomerID}     = $Self->{ParamObject}->GetParam( Param => 'CustomerID' )     || '';

        # Expand Customer Name
        if ($ExpandCustomerName1) {

            # search customer
            my %CustomerUserList = ();
            %CustomerUserList
                = $Self->{CustomerUserObject}->CustomerSearch( Search => $Param{CustomerUserID}, );

            # check if just one customer user exists
            # if just one, fillup CustomerUserID and CustomerID
            $Param{CustomerUserListCount} = 0;
            for ( keys %CustomerUserList ) {
                $Param{CustomerUserListCount}++;
                $Param{CustomerUserListLast}     = $CustomerUserList{$_};
                $Param{CustomerUserListLastUser} = $_;
            }
            if ( $Param{CustomerUserListCount} == 1 ) {
                $Param{CustomerUserID} = $Param{CustomerUserListLastUser};
                my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $Param{CustomerUserListLastUser},
                );
                if ( $CustomerUserData{UserCustomerID} ) {
                    $Param{CustomerID} = $CustomerUserData{UserCustomerID};
                }

            }

            # if more the one customer user exists, show list
            # and clean CustomerUserID and CustomerID
            else {

                #                $Param{CustomerUserID} = '';
                $Param{CustomerID} = '';
                $Param{"CustomerUserOptions"} = \%CustomerUserList;
            }
            return $Self->Form(%Param);
        }

        # get customer user and customer id
        elsif ($ExpandCustomerName2) {
            my %CustomerUserData
                = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $CustomerUserOption, );
            my %CustomerUserList
                = $Self->{CustomerUserObject}->CustomerSearch( UserLogin => $CustomerUserOption, );
            for ( keys %CustomerUserList ) {
                $Param{CustomerUserID} = $_;
            }
            if ( $CustomerUserData{UserCustomerID} ) {
                $Param{CustomerID} = $CustomerUserData{UserCustomerID};
            }
            return $Self->Form(%Param);
        }

        # update customer user data
        if (
            $Self->{TicketObject}->SetCustomerData(
                TicketID => $Self->{TicketID},
                No       => $Param{CustomerID},
                User     => $Param{CustomerUserID},
                UserID   => $Self->{UserID},
            )
            )
        {

            # redirect
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentTicketZoom&TicketID=$Self->{TicketID}"
            );
        }
        else {

            # error?!
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # show form
    else {
        return $Self->Form(%Param);
    }
}

sub Form {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get autocomplete config
    my $AutoCompleteConfig
        = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerSearchAutoComplete');

    # print header
    $Output .= $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    my $TicketCustomerID = $Self->{CustomerID};

    # print change form if ticket id is given
    my %CustomerUserData = ();
    if ( $Self->{TicketID} ) {

        # set some customer search autocomplete properties
        if ( $AutoCompleteConfig->{Active} ) {
            $Self->{LayoutObject}->Block(
                Name => 'CustomerSearchAutoComplete',
                Data => {
                    minQueryLength      => $AutoCompleteConfig->{MinQueryLength}      || 2,
                    queryDelay          => $AutoCompleteConfig->{QueryDelay}          || 0.1,
                    typeAhead           => $AutoCompleteConfig->{TypeAhead}           || 'false',
                    maxResultsDisplayed => $AutoCompleteConfig->{MaxResultsDisplayed} || 20,
                },
            );
        }

        # get ticket data
        my %TicketData = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
        if ( $TicketData{CustomerUserID} || $Param{CustomerUserID} ) {
            %CustomerUserData
                = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Param{CustomerUserID}
                    || $TicketData{CustomerUserID},
                );
        }
        $TicketCustomerID = $TicketData{CustomerID};
        $Param{Table} = $Self->{LayoutObject}->AgentCustomerViewTable( Data => \%CustomerUserData );
        $Self->{LayoutObject}->Block(
            Name => 'Customer',
            Data => { %TicketData, %Param, },
        );

        # build customer search autocomplete field
        if ( $AutoCompleteConfig->{Active} ) {
            $Self->{LayoutObject}->Block(
                Name => 'CustomerSearchAutoCompleteDivStart',
            );
            $Self->{LayoutObject}->Block(
                Name => 'CustomerSearchAutoCompleteDivEnd',
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'SearchCustomerButton',
            );
        }

        # build from string
        if ( $Param{CustomerUserOptions} && %{ $Param{CustomerUserOptions} } ) {
            $Param{'CustomerUserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data => $Param{CustomerUserOptions},
                Name => 'CustomerUserOption',
                Max  => 70,
            );
            $Self->{LayoutObject}->Block(
                Name => 'CustomerTakeOver',
                Data => { %Param, },
            );
        }
    }

    $Output
        .= $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketCustomer', Data => \%Param );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
