# --
# Kernel/Modules/AgentTicketFreeText.pm - free text for ticket
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketFreeText.pm,v 1.77 2010-06-18 17:43:52 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketFreeText;

use strict;
use warnings;

use Kernel::Modules::AgentTicketActionCommon;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.77 $) [1];

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
