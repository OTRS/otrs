# --
# Kernel/Modules/AgentZoom.pm - to get a closer view
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentZoom.pm,v 1.96 2009-02-16 11:20:53 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentZoom;

use strict;
use warnings;

use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.96 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject )) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # compat link
    my $Redirect = $ENV{REQUEST_URI};
    if ($Redirect) {
        $Redirect =~ s/AgentZoom/AgentTicketZoom/;
    }
    else {
        $Redirect
            = $Self->{LayoutObject}->{Baselink}
            . 'Action=AgentTicketZoom&TicketID='
            . $Self->{TicketID};
    }
    return $Self->{LayoutObject}->Redirect( OP => $Redirect );
}

1;
