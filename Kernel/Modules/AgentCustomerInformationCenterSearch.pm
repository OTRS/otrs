# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentCustomerInformationCenterSearch;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

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

    # get needed objects
    my $ParamObject           = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject          = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

    my $AutoCompleteConfig            = $ConfigObject->Get('AutoComplete::Agent')->{CustomerSearch};
    my $MaxResults                    = $AutoCompleteConfig->{MaxResultsDisplayed} || 20;
    my $IncludeUnknownTicketCustomers = int( $ParamObject->GetParam( Param => 'IncludeUnknownTicketCustomers' ) || 0 );
    my $SearchTerm                    = $ParamObject->GetParam( Param => 'Term' ) || '';

    if ( $Self->{Subaction} eq 'SearchCustomerID' ) {

        # build result list
        my $UnknownTicketCustomerList;

        if ($IncludeUnknownTicketCustomers) {

            # add customers that are not saved in any backend
            $UnknownTicketCustomerList = $TicketObject->SearchUnknownTicketCustomers(
                SearchTerm => $SearchTerm,
            );
        }

        # Search for Valid customer companies.
        my %CustomerCompanyList = $CustomerCompanyObject->CustomerCompanyList(
            Search => $SearchTerm,
        );
        map { $CustomerCompanyList{$_} = $UnknownTicketCustomerList->{$_} } keys %{$UnknownTicketCustomerList};

        # Search for all customer companies, valid and invalid.
        my %CustomerCompanyListAll = $CustomerCompanyObject->CustomerCompanyList(
            Search => $SearchTerm,
            Valid  => 0,
        );

        my @CustomerIDs = $CustomerUserObject->CustomerIDList(
            SearchTerm => $SearchTerm,
        );

        # add CustomerIDs for which no CustomerCompany are registered
        my %Seen;
        for my $CustomerID (@CustomerIDs) {

            # skip duplicates
            next CUSTOMERID if $Seen{$CustomerID};
            $Seen{$CustomerID} = 1;

            # identifies unknown companies
            if ( !exists $CustomerCompanyListAll{$CustomerID} ) {
                $CustomerCompanyList{$CustomerID} = $CustomerID;
            }

        }

        my @Result;

        CUSTOMERID:
        for my $CustomerID ( sort keys %CustomerCompanyList ) {
            if ( !( grep { $_->{Value} eq $CustomerID } @Result ) ) {
                push @Result,
                    {
                    Label => $CustomerCompanyList{$CustomerID},
                    Value => $CustomerID
                    };
            }
            last CUSTOMERID if scalar @Result >= $MaxResults;

        }

        my $JSON = $LayoutObject->JSONEncode(
            Data => \@Result,
        );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON || '',
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    elsif ( $Self->{Subaction} eq 'SearchCustomerUser' ) {

        my $UnknownTicketCustomerList;

        if ($IncludeUnknownTicketCustomers) {

            # add customers that are not saved in any backend
            $UnknownTicketCustomerList = $TicketObject->SearchUnknownTicketCustomers(
                SearchTerm => $SearchTerm,
            );
        }

        my %CustomerList = $CustomerUserObject->CustomerSearch(
            Search => $SearchTerm,
        );
        map { $CustomerList{$_} = $UnknownTicketCustomerList->{$_} } keys %{$UnknownTicketCustomerList};

        my @Result;

        CUSTOMERLOGIN:
        for my $CustomerLogin ( sort keys %CustomerList ) {
            my %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                User => $CustomerLogin,
            );

            push @Result,
                {
                Label => $CustomerList{$CustomerLogin},
                Value => $CustomerData{UserCustomerID}
                };
            last CUSTOMERLOGIN if scalar @Result >= $MaxResults;

        }

        my $JSON = $LayoutObject->JSONEncode(
            Data => \@Result,
        );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON || '',
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentCustomerInformationCenterSearch',
        Data         => \%Param,
    );
    return $LayoutObject->Attachment(
        NoCache     => 1,
        ContentType => 'text/html',
        Charset     => $LayoutObject->{UserCharset},
        Content     => $Output || '',
        Type        => 'inline',
    );
}

1;
