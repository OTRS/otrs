# --
# Kernel/Output/HTML/ToolBarTicketSearchProfile.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarTicketSearchProfile;

use strict;
use warnings;

use Kernel::System::SearchProfile;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID UserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{SearchProfileObject} = Kernel::System::SearchProfile->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get user data
    my %User = $Self->{UserObject}->GetUserData(
        UserID => $Self->{UserID},
    );

    # create search profiles string
    my $ProfilesStrg = $Self->{LayoutObject}->BuildSelection(
        Data => {
            '', '-',
            $Self->{SearchProfileObject}->SearchProfileList(
                Base      => 'TicketSearch',
                UserLogin => $User{UserLogin},
            ),
        },
        Name       => 'Profile',
        ID         => 'ToolBarSearchProfile',
        Title      => $Self->{LayoutObject}->{LanguageObject}->Get('Search template'),
        SelectedID => '',
        Max        => $Param{Config}->{MaxWidth},
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
