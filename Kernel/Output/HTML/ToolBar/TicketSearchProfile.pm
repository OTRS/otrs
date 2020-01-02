# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::ToolBar::TicketSearchProfile;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::User',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::SearchProfile'
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get user data
    my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
        UserID => $Self->{UserID},
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # create search profiles string
    my $ProfilesStrg = $LayoutObject->BuildSelection(
        Data => {
            '', '-',
            $Kernel::OM->Get('Kernel::System::SearchProfile')->SearchProfileList(
                Base      => 'TicketSearch',
                UserLogin => $User{UserLogin},
            ),
        },
        Name       => 'Profile',
        ID         => 'ToolBarSearchProfile',
        Title      => $LayoutObject->{LanguageObject}->Translate('Search template'),
        SelectedID => '',
        Max        => $Param{Config}->{MaxWidth},
        Class      => 'Modernize',
    );

    my $Priority = $Param{Config}->{'Priority'};
    my %Return   = ();
    $Return{ $Priority++ } = {
        Block       => $Param{Config}->{Block},
        Description => $Param{Config}->{Description},
        Name        => $Param{Config}->{Name},
        Image       => '',
        Link        => $ProfilesStrg,
        AccessKey   => '',
    };
    return %Return;
}

1;
