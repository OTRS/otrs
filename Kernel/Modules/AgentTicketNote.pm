# --
# Kernel/Modules/AgentTicketNote.pm - to add notes to a ticket
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: AgentTicketNote.pm,v 1.92 2011-05-03 07:53:58 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketNote;

use strict;
use warnings;

use base qw( Kernel::Modules::AgentTicketActionCommon );

use vars qw($VERSION);
$VERSION = qw($Revision: 1.92 $) [1];

1;
