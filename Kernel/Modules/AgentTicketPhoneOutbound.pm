# --
# Kernel/Modules/AgentTicketPhoneOutbound.pm - to handle outbound phone calls
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketPhoneOutbound.pm,v 1.75 2012-11-12 18:18:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Modules::AgentTicketPhoneOutbound;

use strict;
use warnings;

use base qw( Kernel::Modules::AgentTicketPhoneCommon );

use vars qw($VERSION);
$VERSION = qw($Revision: 1.75 $) [1];

1;
