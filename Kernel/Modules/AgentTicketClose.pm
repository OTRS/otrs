# --
# Kernel/Modules/AgentTicketClose.pm - close a ticket
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketClose.pm,v 1.90 2012-11-12 18:14:51 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Modules::AgentTicketClose;

use strict;
use warnings;

use base qw( Kernel::Modules::AgentTicketActionCommon );

use vars qw($VERSION);
$VERSION = qw($Revision: 1.90 $) [1];

1;
