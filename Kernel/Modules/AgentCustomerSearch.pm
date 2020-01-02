# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentCustomerSearch;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $EncodeObject       = $Kernel::OM->Get('Kernel::System::Encode');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

    # get config for frontend
    $Self->{Config} = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    my $AutoCompleteConfig = $ConfigObject->Get('AutoComplete::Agent')->{CustomerSearch};
    my $MaxResults         = int( $ParamObject->GetParam( Param => 'MaxResults' ) || 0 )
        || $AutoCompleteConfig->{MaxResultsDisplayed}
        || 20;
    my $IncludeUnknownTicketCustomers = int( $ParamObject->GetParam( Param => 'IncludeUnknownTicketCustomers' ) || 0 );
    my $SearchTerm                    = $ParamObject->GetParam( Param => 'Term' ) || '';

    my $JSON = '';

    if ( !$Self->{Subaction} || $Self->{Subaction} eq 'SearchCustomerUser' ) {

        my $UnknownTicketCustomerList;

        if ($IncludeUnknownTicketCustomers) {

            # add customers that are not saved in any backend
            $UnknownTicketCustomerList = $TicketObject->SearchUnknownTicketCustomers(
                SearchTerm => $SearchTerm,
            );
        }

        # get customer list
        my %CustomerUserList = $CustomerUserObject->CustomerSearch(
            Search => $SearchTerm,
        );
        map { $CustomerUserList{$_} = $UnknownTicketCustomerList->{$_} } keys %{$UnknownTicketCustomerList};

        # build data
        my @Data;
        CUSTOMERUSERID:
        for my $CustomerUserID ( sort keys %CustomerUserList ) {

            my $CustomerValue = $CustomerUserList{$CustomerUserID};

            # replace new lines with one space (see bug#11133)
            $CustomerValue =~ s/\n/ /gs;
            $CustomerValue =~ s/\r/ /gs;

            if ( !( grep { $_->{Label} eq $CustomerValue } @Data ) ) {
                push @Data, {
                    Label => $CustomerValue,
                    Value => $CustomerUserID,
                };
            }
            last CUSTOMERUSERID if scalar @Data >= $MaxResults;
        }

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => \@Data,
        );
    }

    elsif ( $Self->{Subaction} eq 'SearchCustomerID' ) {

        # Build the result list.
        my $UnknownTicketCustomerList;

        if ($IncludeUnknownTicketCustomers) {

            # Add customers that are not saved in any backend.
            $UnknownTicketCustomerList = $TicketObject->SearchUnknownTicketCustomers(
                SearchTerm => $SearchTerm,
            );
        }

        my %CustomerCompanyList = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyList(
            Search => $SearchTerm,
        );
        map { $CustomerCompanyList{$_} = $UnknownTicketCustomerList->{$_} } keys %{$UnknownTicketCustomerList};

        my @CustomerIDs = $CustomerUserObject->CustomerIDList(
            SearchTerm => $SearchTerm,
        );

        # Add CustomerIDs for which no CustomerCompany are registered.
        my %Seen;
        for my $CustomerID (@CustomerIDs) {

            # Skip duplicate entries.
            next CUSTOMERID if $Seen{$CustomerID};
            $Seen{$CustomerID} = 1;

            # Identifies unknown companies.
            if ( !exists $CustomerCompanyList{$CustomerID} ) {
                $CustomerCompanyList{$CustomerID} = $CustomerID;
            }
        }

        my @Data;

        CUSTOMERID:
        for my $CustomerID ( sort keys %CustomerCompanyList ) {
            if ( !( grep { $_->{Value} eq $CustomerID } @Data ) ) {
                push @Data, {
                    Label => $CustomerCompanyList{$CustomerID},
                    Value => $CustomerID,
                };
            }
            last CUSTOMERID if scalar @Data >= $MaxResults;
        }

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => \@Data,
        );
    }

    # Get all assigned customer ids from the given customer user id.
    elsif ( $Self->{Subaction} eq 'AssignedCustomerIDs' ) {

        my $CustomerUserID = $ParamObject->GetParam( Param => 'CustomerUserID' ) || '';

        my @CustomerIDs;
        if ($CustomerUserID) {
            @CustomerIDs = $CustomerUserObject->CustomerIDs(
                User => $CustomerUserID,
            );
        }

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => \@CustomerIDs,
        );
    }

    # get customer info
    elsif ( $Self->{Subaction} eq 'CustomerInfo' ) {

        # get params
        my $CustomerUserID = $ParamObject->GetParam( Param => 'CustomerUserID' ) || '';

        my $CustomerID              = '';
        my $CustomerTableHTMLString = '';

        # get customer data
        my %CustomerData = $CustomerUserObject->CustomerUserDataGet(
            User => $CustomerUserID,
        );

        if ( $CustomerData{UserTitle} ) {
            $CustomerData{UserTitle} = $LayoutObject->{LanguageObject}->Translate( $CustomerData{UserTitle} );
        }

        # get customer id
        if ( $CustomerData{UserCustomerID} ) {
            $CustomerID = $CustomerData{UserCustomerID};
        }

        my @CustomerIDs;

        if ($CustomerUserID) {
            @CustomerIDs = $CustomerUserObject->CustomerIDs(
                User => $CustomerUserID,
            );
        }

        # build html for customer info table
        if ( $ConfigObject->Get('Ticket::Frontend::CustomerInfoCompose') ) {

            $CustomerTableHTMLString = $LayoutObject->AgentCustomerViewTable(
                Data => {%CustomerData},
                Max  => $ConfigObject->Get('Ticket::Frontend::CustomerInfoComposeMaxSize'),
            );
        }

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => {
                CustomerID              => $CustomerID,
                CustomerTableHTMLString => $CustomerTableHTMLString,
                CustomerIDs             => \@CustomerIDs,
            },
        );
    }

    # get customer tickets
    elsif ( $Self->{Subaction} eq 'CustomerTickets' ) {

        # get params
        my $CustomerUserID = $ParamObject->GetParam( Param => 'CustomerUserID' ) || '';
        my $CustomerID     = $ParamObject->GetParam( Param => 'CustomerID' )     || '';

        # get secondary customer ids
        my @CustomerIDs;
        if ($CustomerUserID) {
            @CustomerIDs = $CustomerUserObject->CustomerIDs(
                User => $CustomerUserID,
            );
        }

        # add own customer id
        if ($CustomerID) {
            push @CustomerIDs, $CustomerID;
        }

        my $View    = $ParamObject->GetParam( Param => 'View' )    || '';
        my $SortBy  = $ParamObject->GetParam( Param => 'SortBy' )  || 'Age';
        my $OrderBy = $ParamObject->GetParam( Param => 'OrderBy' ) || 'Down';

        my @ViewableTickets;
        if (@CustomerIDs) {
            @ViewableTickets = $TicketObject->TicketSearch(
                Result        => 'ARRAY',
                Limit         => 250,
                SortBy        => [$SortBy],
                OrderBy       => [$OrderBy],
                CustomerIDRaw => \@CustomerIDs,
                UserID        => $Self->{UserID},
                Permission    => 'ro',
            );
        }

        my $LinkSort = 'Subaction=' . $Self->{Subaction}
            . ';View=' . $LayoutObject->Ascii2Html( Text => $View )
            . ';CustomerUserID=' . $LayoutObject->Ascii2Html( Text => $CustomerUserID )
            . ';CustomerID=' . $LayoutObject->Ascii2Html( Text => $CustomerID )
            . '&';
        my $LinkPage = 'Subaction=' . $Self->{Subaction}
            . ';View=' . $LayoutObject->Ascii2Html( Text => $View )
            . ';SortBy=' . $LayoutObject->Ascii2Html( Text => $SortBy )
            . ';OrderBy=' . $LayoutObject->Ascii2Html( Text => $OrderBy )
            . ';CustomerUserID=' . $LayoutObject->Ascii2Html( Text => $CustomerUserID )
            . ';CustomerID=' . $LayoutObject->Ascii2Html( Text => $CustomerID )
            . '&';
        my $LinkFilter = 'Subaction=' . $Self->{Subaction}
            . ';CustomerUserID=' . $LayoutObject->Ascii2Html( Text => $CustomerUserID )
            . ';CustomerID=' . $LayoutObject->Ascii2Html( Text => $CustomerID )
            . '&';

        my $CustomerTicketsHTMLString = '';
        if (@ViewableTickets) {
            $CustomerTicketsHTMLString .= $LayoutObject->TicketListShow(
                TicketIDs  => \@ViewableTickets,
                Total      => scalar @ViewableTickets,
                Env        => $Self,
                View       => $View,
                TitleName  => Translatable('Customer History'),
                LinkPage   => $LinkPage,
                LinkSort   => $LinkSort,
                LinkFilter => $LinkFilter,
                Output     => 'raw',

                OrderBy => $OrderBy,
                SortBy  => $SortBy,
                AJAX    => 1,
            );
        }

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => {
                CustomerTicketsHTMLString => $CustomerTicketsHTMLString,
            },
        );
    }

    # send JSON response
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON || '',
        Type        => 'inline',
        NoCache     => 1,
    );

}

1;
