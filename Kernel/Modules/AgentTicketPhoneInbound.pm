# --
# Kernel/Modules/AgentTicketPhoneInbound.pm - to handle inbound phone calls
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: AgentTicketPhoneInbound.pm,v 1.2 2011-05-03 07:06:25 mg Exp $
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
$VERSION = qw($Revision: 1.2 $) [1];

1;
