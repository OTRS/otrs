# --
# Kernel/Output/HTML/DashboardCustomerCompanyInformation.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardCustomerCompanyInformation;

use strict;
use warnings;

use Kernel::System::CustomerCompany;
use Kernel::System::Valid;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    $Self->{CustomerCompanyObject} = Kernel::System::CustomerCompany->new( %{$Self} );
    $Self->{ValidObject}           = Kernel::System::Valid->new( %{$Self} );

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{CacheKey} = $Self->{Name};

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} },

        # caching not needed
        CacheKey => undef,
        CacheTTL => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    return if !$Param{CustomerID};

    my $CustomerCompanyConfig = $Self->{ConfigObject}->Get('CustomerCompany');
    return if ref $CustomerCompanyConfig ne 'HASH';
    return if ref $CustomerCompanyConfig->{Map} ne 'ARRAY';

    my %CustomerCompany = $Self->{CustomerCompanyObject}->CustomerCompanyGet(
        CustomerID => $Param{CustomerID},
    );

    return if !%CustomerCompany;

    # make ValidID readable
    if ( $CustomerCompany{ValidID} ) {
        $CustomerCompany{ValidID} = $Self->{ValidObject}->ValidLookup(
            ValidID => $CustomerCompany{ValidID},
        );

        $CustomerCompany{ValidID}
            = $Self->{LayoutObject}->{LanguageObject}->Get( $CustomerCompany{ValidID} );
    }

    ENTRY:
    for my $Entry ( @{ $CustomerCompanyConfig->{Map} } ) {
        my $Key = $Entry->[0];

        # do not show items if they're not marked as visible
        next ENTRY if !$Entry->[3];

        # do not show empty entries
        next ENTRY if !length( $CustomerCompany{$Key} );

        $Self->{LayoutObject}->Block( Name => "ContentSmallCustomerCompanyInformationRow" );

        if ( $Key eq 'CustomerID' ) {
            $Self->{LayoutObject}->Block(
                Name => "ContentSmallCustomerCompanyInformationRowLink",
                Data => {
                    %CustomerCompany,
                    Label => $Entry->[1],
                    Value => $CustomerCompany{$Key},
                    URL =>
                        '$Env{"Baselink"}Action=AdminCustomerCompany;Subaction=Change;CustomerID=$QData{"CustomerID"};Nav=Agent',
                    Target => '',
                },
            );

            next ENTRY;
        }

        # check if a link must be placed
        if ( $Entry->[6] ) {
            $Self->{LayoutObject}->Block(
                Name => "ContentSmallCustomerCompanyInformationRowLink",
                Data => {
                    %CustomerCompany,
                    Label  => $Entry->[1],
                    Value  => $CustomerCompany{$Key},
                    URL    => $Entry->[6],
                    Target => '_blank',
                },
            );

            next ENTRY;

        }

        $Self->{LayoutObject}->Block(
            Name => "ContentSmallCustomerCompanyInformationRowText",
            Data => {
                %CustomerCompany,
                Label => $Entry->[1],
                Value => $CustomerCompany{$Key},
            },
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardCustomerCompanyInformation',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %CustomerCompany,
        },
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

1;
