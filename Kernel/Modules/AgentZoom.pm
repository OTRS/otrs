# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

#
# LEGACY: This module redirects to AgentTicketZoom. It should be kept for a while
#   because existing legacy/upgraded systems have it in their notifications.
#   To drop it, existing notifications would have to be changed by the database
#   upgrading script.
#

package Kernel::Modules::AgentZoom;

use strict;
use warnings;

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # compat link
    my $Redirect = $ENV{REQUEST_URI};
    if ($Redirect) {
        $Redirect =~ s/AgentZoom/AgentTicketZoom/;
    }
    else {
        $Redirect = $LayoutObject->{Baselink}
            . 'Action=AgentTicketZoom;TicketID='
            . $Self->{TicketID};
    }
    return $LayoutObject->Redirect( OP => $Redirect );
}

1;
