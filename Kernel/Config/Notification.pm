# --
# Kernel/Config/Notification.pm - Notification config file for OTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Notification.pm,v 1.3 2002-09-10 23:13:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Config::Notification;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub LoadNotification {
    my $Self = shift;
    # ----------------------------------------------------#
    #                                                     #
    #             Start of config options!!!              #
    #                 Notification stuff                  #
    #                                                     #
    # ----------------------------------------------------#

    # --  
    # notification sender
    # --
    $Self->{NotificationSenderName} = 'OTRS Notification Master';
    $Self->{NotificationSenderEmail} = 'otrs@'.$Self->{FQDN};
    # --
    # new ticket in queue
    # --
    $Self->{NotificationSubjectNewTicket} = 'New ticket notification! (<OTRS_CUSTOMER_SUBJECT[10]>)';
    $Self->{NotificationBodyNewTicket} = "
Hi,

there is a new ticket in '<OTRS_QUEUE>'!

<OTRS_CUSTOMER_FROM> wrote:
<snip>
<OTRS_CUSTOMER_EMAIL[10]>
<snip>

http://$Self->{FQDN}/otrs/index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
    # --
    # ticket follow up from customer
    # --
    $Self->{NotificationSubjectFollowUp} = 'You got follow up! (<OTRS_CUSTOMER_SUBJECT[10]>)';
    $Self->{NotificationBodyFollowUp} = "
Hi <OTRS_USER_FIRSTNAME>,

you got a follow up!

<OTRS_CUSTOMER_FROM> wrote:
<snip>
<OTRS_CUSTOMER_EMAIL[10]>
<snip>

http://$Self->{FQDN}/otrs/index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
    # --
    # ticket lock timeout by system
    # --
    $Self->{NotificationSubjectLockTimeout} = 'Lock Timeout! (<OTRS_CUSTOMER_SUBJECT[10]>)';
    $Self->{NotificationBodyLockTimeout} = "
Hi <OTRS_USER_FIRSTNAME>,

unlocked your locked ticket [<OTRS_TICKET_NUMBER>].

http://$Self->{FQDN}/otrs/index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";

    # --
    # mail to new owner by owner update
    # --
    $Self->{NotificationSubjectOwnerUpdate} = 'Ticket assigned to you!';
    $Self->{NotificationBodyOwnerUpdate} = "
Hi <OTRS_USER_FIRSTNAME>,

a ticket [<OTRS_TICKET_NUMBER>] is assigned to you by '<OTRS_CURRENT_USER_FIRSTNAME> <OTRS_CURRENT_USER_LASTNAME>'.

Comment: 
<OTRS_COMMENT>

http://$Self->{FQDN}/otrs/index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
}
# --


1;

