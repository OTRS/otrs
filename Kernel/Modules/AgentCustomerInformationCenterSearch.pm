# --
# Kernel/Modules/AgentCustomerInformationCenterSearch.pm - customer information
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentCustomerInformationCenterSearch;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::CustomerCompany;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject MainObject EncodeObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{CustomerUserObject}    = Kernel::System::CustomerUser->new(%Param);
    $Self->{CustomerCompanyObject} = Kernel::System::CustomerCompany->new(%Param);

    $Self->{SlaveDBObject}     = $Self->{DBObject};
    $Self->{SlaveTicketObject} = $Self->{TicketObject};

    # use a slave db to search dashboard date
    if ( $Self->{ConfigObject}->Get('Core::MirrorDB::DSN') ) {

        $Self->{SlaveDBObject} = Kernel::System::DB->new(
            LogObject    => $Param{LogObject},
            ConfigObject => $Param{ConfigObject},
            MainObject   => $Param{MainObject},
            EncodeObject => $Param{EncodeObject},
            DatabaseDSN  => $Self->{ConfigObject}->Get('Core::MirrorDB::DSN'),
            DatabaseUser => $Self->{ConfigObject}->Get('Core::MirrorDB::User'),
            DatabasePw   => $Self->{ConfigObject}->Get('Core::MirrorDB::Password'),
        );

        if ( $Self->{SlaveDBObject} ) {

            $Self->{SlaveTicketObject} = Kernel::System::Ticket->new(
                %Param,
                DBObject => $Self->{SlaveDBObject},
            );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $AutoCompleteConfig
        = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerSearchAutoComplete');

    my $MaxResults = $AutoCompleteConfig->{MaxResultsDisplayed} || 20;

    if ( $Self->{Subaction} eq 'SearchCustomerID' ) {

        my @CustomerIDs = $Self->{CustomerUserObject}->CustomerIDList(
            SearchTerm => $Self->{ParamObject}->GetParam( Param => 'Term' ) || '',
        );

        my %CustomerCompanyList = $Self->{CustomerCompanyObject}->CustomerCompanyList(
            Search => $Self->{ParamObject}->GetParam( Param => 'Term' ) || '',
        );

        # add CustomerIDs for which no CustomerCompany are registered
        my %Seen;
        for my $CustomerID ( @CustomerIDs ) {

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
            push @Result, { Label => $CustomerCompanyList{$CustomerID}, Value => $CustomerID };
            last CUSTOMERID if scalar @Result >= $MaxResults;
        }

        my $JSON = $Self->{LayoutObject}->JSONEncode(
            Data => \@Result,
        );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON || '',
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    elsif ( $Self->{Subaction} eq 'SearchCustomerUser' ) {

        my %CustomerList = $Self->{CustomerUserObject}->CustomerSearch(
            Search => $Self->{ParamObject}->GetParam( Param => 'Term' ) || '',
        );

        my @Result;

        my $Count = 1;

        CUSTOMERLOGIN:
        for my $CustomerLogin ( sort keys %CustomerList ) {
            my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $CustomerLogin,
            );
            push @Result,
                { Label => $CustomerList{$CustomerLogin}, Value => $CustomerData{UserCustomerID} };

            last CUSTOMERLOGIN if $Count++ >= $MaxResults;
        }

        my $JSON = $Self->{LayoutObject}->JSONEncode(
            Data => \@Result,
        );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON || '',
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # build customer search autocomplete fields
    $Self->{LayoutObject}->Block(
        Name => 'CustomerSearchAutoComplete',
        Data => {
            ActiveAutoComplete  => $AutoCompleteConfig->{Active},
            minQueryLength      => $AutoCompleteConfig->{MinQueryLength} || 2,
            queryDelay          => $AutoCompleteConfig->{QueryDelay} || 100,
            maxResultsDisplayed => $AutoCompleteConfig->{MaxResultsDisplayed} || 20,
        },
    );

    my $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentCustomerInformationCenterSearch',
        Data         => \%Param,
    );
    return $Output;
}

1;
