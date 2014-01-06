# --
# Kernel/Modules/AgentTicketOwner.pm - set ticket owner
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: AgentTicketOwner.pm,v 1.84 2011-05-03 07:53:58 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketOwner;

use strict;
use warnings;

use base qw( Kernel::Modules::AgentTicketActionCommon );

use vars qw($VERSION);
$VERSION = qw($Revision: 1.84 $) [1];

1;
