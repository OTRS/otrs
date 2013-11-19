# --
# Kernel/Modules/AgentTicketMailbox.pm - just for compat. redirect to new screen
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: AgentTicketMailbox.pm,v 1.33 2009-08-12 06:50:58 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketMailbox;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.33 $) [1];

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
    return $Self->{LayoutObject}->Redirect(
        OP => $Self->{LayoutObject}->{Baselink} . 'Action=AgentTicketLockedView',
    );
}

1;
