# --
# Kernel/Config/ModulesCustomerPanel.pm - config file of all used application modules
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: ModulesCustomerPanel.pm,v 1.3 2002-10-22 16:07:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Config::ModulesCustomerPanel;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
# allow module Action=? (regexpr)
# --
$Kernel::Config::ModulesCustomerPanel::Allow = "^(Customer).+?";


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
use Kernel::System::EmailSend;

# web agent middle ware modules
use Kernel::Modules::CustomerZoom;
use Kernel::Modules::CustomerTicketOverView;
use Kernel::Modules::CustomerMessage;
use Kernel::Modules::CustomerPreferences;

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
