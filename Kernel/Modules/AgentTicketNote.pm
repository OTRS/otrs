# --
# Kernel/Modules/AgentTicketNote.pm - to add notes to a ticket
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketNote.pm,v 1.93 2012-11-12 18:18:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Modules::AgentTicketNote;

use strict;
use warnings;

use base qw( Kernel::Modules::AgentTicketActionCommon );

use vars qw($VERSION);
$VERSION = qw($Revision: 1.93 $) [1];

1;
