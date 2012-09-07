# --
# Kernel/Output/HTML/DashboardCustomerCompanyInformation.pm
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: DashboardCustomerCompanyInformation.pm,v 1.1 2012-09-07 13:16:58 mg Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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

    my %CustomerCompany = $Self->{CustomerCompanyObject}->CustomerCompanyGet(
        CustomerID => $Param{CustomerID},
    );

    return if !%CustomerCompany;

    for my $Key ( keys %CustomerCompany ) {
        $Self->{LayoutObject}->Block(
            Name => "ContentSmallUserOnlineRow$Key",
            Data => \%CustomerCompany,
        );
    }

    $CustomerCompany{Valid} = $Self->{ValidObject}->ValidLookup(
        ValidID => $CustomerCompany{ValidID},
    );

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
