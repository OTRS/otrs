# --
# Kernel/Config/ModulesCustomerPanel.pm - config file of all used application modules
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: ModulesCustomerPanel.pm,v 1.8 2004-09-16 22:03:59 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Config::ModulesCustomerPanel;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
# all custom modules
# --
#use Kernel::Config::ModulesCustomerPanelCustom;

# --
# all OTRS customer frontend modules
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
$Kernel::Config::ModulesCustomerPanel::CommonObject = {
    # key => module
    QueueObject => 'Kernel::System::Queue',
    TicketObject => 'Kernel::System::Ticket',
};
# --
# common needed params
# (so you can access this params in Kernel::Modules::* with
# $Self->{Key})
# --
$Kernel::Config::ModulesCustomerPanel::Param = {
    # param => default value
    Action => 'CustomerTicketOverView',
    QueueID => 0,
    TicketID => '',
};
# --
1; 
