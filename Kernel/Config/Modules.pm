# --
# Kernel/Config/Modules.pm - config file of all used application modules
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Modules.pm,v 1.23 2004-09-16 22:03:59 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Config::Modules;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.23 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
# all custom modules
# --
use Kernel::Config::ModulesCustom;

# --
# all OTRS modules
# --
# system basic lib modules
use Kernel::System::Queue;
use Kernel::System::Ticket;
use Kernel::System::Email;

# --
# common needed objects
# (so you can access this modules in Kernel::Modules::* with
# $Self->{Key})
# --
$Kernel::Config::Modules::CommonObject = {
    # key => module
    QueueObject => 'Kernel::System::Queue',
    TicketObject => 'Kernel::System::Ticket',
};
# --
# common needed params
# (so you can access this params in Kernel::Modules::* with
# $Self->{Key})
# --
$Kernel::Config::Modules::Param = {
    # param => default value
    Action => 'AgentQueueView',
    QueueID => 0,
    TicketID => '',
};
# --
1; 
