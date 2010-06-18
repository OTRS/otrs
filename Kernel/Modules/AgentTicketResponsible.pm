# --
# Kernel/Modules/AgentTicketResponsible.pm - set ticket responsible
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketResponsible.pm,v 1.76 2010-06-18 17:33:38 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketResponsible;

use strict;
use warnings;

use Kernel::Modules::AgentTicketActionCommon;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.76 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self = Kernel::Modules::AgentTicketActionCommon->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    return Kernel::Modules::AgentTicketActionCommon->Run( \@_ );
}

1;
