# --
# Kernel/Modules/AgentTicketPriority.pm - set ticket priority
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: AgentTicketPriority.pm,v 1.78 2011-05-03 07:53:58 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketPriority;

use strict;
use warnings;

use base qw( Kernel::Modules::AgentTicketActionCommon );

use vars qw($VERSION);
$VERSION = qw($Revision: 1.78 $) [1];

1;
