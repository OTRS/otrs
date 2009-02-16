# --
# Kernel/Output/HTML/NavBarTicketSearchProfile.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: NavBarTicketSearchProfile.pm,v 1.2 2009-02-16 11:16:22 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBarTicketSearchProfile;

use strict;
use warnings;
use Kernel::System::SearchProfile;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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

    my %Return = ();

    # get user data
    my %User = $Self->{UserObject}->GetUserData(
        UserID => $Self->{UserID},
        Cached => 1,
    );

    # create search profiles string
    my $ProfilesStrg = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            '', '-',
            $Self->{SearchProfileObject}->SearchProfileList(
                Base      => 'TicketSearch',
                UserLogin => $User{UserLogin},
            ),
        },
        Name       => 'Profile',
        SelectedID => '',
        OnChange   => 'document.Search.submit()',
        Max        => $Param{Config}{MaxWidth},
    );

    $Return{'0990000'} = {
        Block       => $Param{Config}{Block},
        Description => $Param{Config}{Description},
        Name        => $Param{Config}{Name},
        Image       => '',
        Link        => $ProfilesStrg,
        AccessKey   => '',
    };
    return %Return;
}

1;
