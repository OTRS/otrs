# --
# Kernel/Modules/AgentTicketPhoneInbound.pm - to handle inbound phone calls
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketPhoneInbound.pm,v 1.4 2012-11-20 14:50:43 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketPhoneInbound;

use strict;
use warnings;

use base qw( Kernel::Modules::AgentTicketPhoneCommon );

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

1;
