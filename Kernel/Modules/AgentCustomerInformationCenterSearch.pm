# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');

    my $AutoCompleteConfig = $ConfigObject->Get('AutoComplete::Agent###CustomerSearch');
    my $MaxResults = $AutoCompleteConfig->{MaxResultsDisplayed} || 20;

    if ( $Self->{Subaction} eq 'SearchCustomerID' ) {

        my @CustomerIDs = $CustomerUserObject->CustomerIDList(
            SearchTerm => $ParamObject->GetParam( Param => 'Term' ) || '',
        );

        my %CustomerCompanyList = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyList(
            Search => $ParamObject->GetParam( Param => 'Term' ) || '',
        );

        # add CustomerIDs for which no CustomerCompany are registered
        my %Seen;
        for my $CustomerID (@CustomerIDs) {

            # skip duplicates
            next CUSTOMERID if $Seen{$CustomerID};
            $Seen{$CustomerID} = 1;

            # identifies unknown companies
            if ( !exists $CustomerCompanyList{$CustomerID} ) {
                $CustomerCompanyList{$CustomerID} = $CustomerID;
            }

        }

        # build result list
        my @Result;
        CUSTOMERID:
        for my $CustomerID ( sort keys %CustomerCompanyList ) {
            push @Result,
                {
                Label => $CustomerCompanyList{$CustomerID},
                Value => $CustomerID
                };
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

        my %CustomerList = $CustomerUserObject->CustomerSearch(
            Search => $ParamObject->GetParam( Param => 'Term' ) || '',
        );

        my @Result;

        my $Count = 1;

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

            last CUSTOMERLOGIN if $Count++ >= $MaxResults;
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

    my $Output .= $LayoutObject->Output(
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
