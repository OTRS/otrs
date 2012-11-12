# --
# Kernel/Modules/AgentTicketOwner.pm - set ticket owner
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketOwner.pm,v 1.85 2012-11-12 18:18:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Modules::AgentTicketOwner;

use strict;
use warnings;

use base qw( Kernel::Modules::AgentTicketActionCommon );

use vars qw($VERSION);
$VERSION = qw($Revision: 1.85 $) [1];

1;
