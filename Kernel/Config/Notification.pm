# --
# Kernel/Config/Notification.pm - Notification config file for OTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Notification.pm,v 1.5 2002-10-03 17:30:17 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Config::Notification;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
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
#    $Self->{NotificationAlwaysCcNewTicket} = 'Maybe a Mailinglist <list@example.com>';
    $Self->{NotificationAlwaysCcNewTicket} = '';
    $Self->{NotificationSubjectNewTicket} = 'New ticket notification! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyNewTicket} = "
Hi,

there is a new ticket in '<OTRS_QUEUE>'!

<OTRS_CUSTOMER_FROM> wrote:
<snip>
<OTRS_CUSTOMER_EMAIL[16]>
<snip>

http://$Self->{FQDN}/otrs/index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
    # --
    # ticket follow up from customer
    # --
#    $Self->{NotificationAlwaysCcFollowUp} = 'Maybe a Mailinglist <list@example.com>';
    $Self->{NotificationAlwaysCcFollowUp} = '';
    $Self->{NotificationSubjectFollowUp} = 'You got follow up! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyFollowUp} = "
Hi <OTRS_OWNER_USERFIRSTNAME>,

you got a follow up!

<OTRS_CUSTOMER_FROM> wrote:
<snip>
<OTRS_CUSTOMER_EMAIL[16]>
<snip>

http://$Self->{FQDN}/otrs/index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
    # --
    # ticket lock timeout by system
    # --
#    $Self->{NotificationAlwaysCcLockTimeout} = 'Maybe a Mailinglist <list@example.com>';
    $Self->{NotificationAlwaysCcLockTimeout} = '';
    $Self->{NotificationSubjectLockTimeout} = 'Lock Timeout! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyLockTimeout} = "
Hi <OTRS_OWNER_USERFIRSTNAME>,

unlocked (lock timeout) your locked ticket [<OTRS_TICKET_NUMBER>].

<OTRS_CUSTOMER_FROM> wrote:
<snip>
<OTRS_CUSTOMER_EMAIL[8]>
<snip>

http://$Self->{FQDN}/otrs/index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";

    # --
    # mail to new owner by owner update
    # --
#    $Self->{NotificationAlwaysCcOwnerUpdate} = 'Maybe a Mailinglist <list@example.com>';
    $Self->{NotificationAlwaysCcOwnerUpdate} = '';
    $Self->{NotificationSubjectOwnerUpdate} = 'Ticket assigned to you! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyOwnerUpdate} = "
Hi <OTRS_OWNER_USERFIRSTNAME>,

a ticket [<OTRS_TICKET_NUMBER>] is assigned to you by '<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>'.

Comment: 
<OTRS_COMMENT>

http://$Self->{FQDN}/otrs/index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
    # --
    # mail to owner by note add
    # --
#    $Self->{NotificationAlwaysCcNote} = '';
    $Self->{NotificationSubjectAddNote} = 'New note! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyAddNote} = "
Hi <OTRS_OWNER_USERFIRSTNAME>,

'<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>' added a new note to ticket [<OTRS_TICKET_NUMBER>].

Note: 
<OTRS_CUSTOMER_BODY>

http://$Self->{FQDN}/otrs/index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
    # --
    # mail to queue subscriber by move 
    # --
#    $Self->{NotificationAlwaysCcMove} = 'Maybe a Mailinglist <list@example.com>';
    $Self->{NotificationAlwaysCcMove} = '';
    $Self->{NotificationSubjectMove} = 'Moved ticket in "<OTRS_CUSTOMER_QUEUE>" queue! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyMove} = "
Hi,

'<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>' moved a ticket [<OTRS_TICKET_NUMBER>] into '<OTRS_CUSTOMER_QUEUE>'.

http://$Self->{FQDN}/otrs/index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";

}
# --


1;

