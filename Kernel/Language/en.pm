# --
# Kernel/Language/en.pm - provides en languag translation
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: en.pm,v 1.22 2007-10-02 10:45:42 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::en;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

sub Data {
    my ( $Self, %Param ) = @_;

    my %Hash = ();

    # $$START$$

    # possible charsets
    $Self->{Charset} = [ 'us-ascii', 'UTF-8', 'iso-8859-1', 'iso-8859-15' ];

    $Self->{DateFormat}          = '%M/%D/%Y %T';
    $Self->{DateFormatShort}     = '%M/%D/%Y';
    $Self->{DateFormatLong}      = '%T - %M/%D/%Y';
    $Self->{DateFormatShort}     = '%M/%D/%Y';
    $Self->{DateInputFormat}     = '%M/%D/%Y';
    $Self->{DateInputFormatLong} = '%M/%D/%Y - %T';

    # maybe nothing ... or help texts
    $Self->{Translation} = {
        'History::Move'             => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
        'History::NewTicket'        => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
        'History::FollowUp'         => 'FollowUp for [%s]. %s',
        'History::SendAutoReject'   => 'AutoReject sent to "%s".',
        'History::SendAutoReply'    => 'AutoReply sent to "%s".',
        'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
        'History::Forward'          => 'Forwarded to "%s".',
        'History::Bounce'           => 'Bounced to "%s".',
        'History::SendAnswer'       => 'Email sent to "%s".',
        'History::SendAgentNotification'    => '"%s"-notification sent to "%s".',
        'History::SendCustomerNotification' => 'Notification sent to "%s".',
        'History::EmailAgent'               => 'Email sent to customer.',
        'History::EmailCustomer'            => 'Added email. %s',
        'History::PhoneCallAgent'           => 'Agent called customer.',
        'History::PhoneCallCustomer'        => 'Customer called us.',
        'History::AddNote'                  => 'Added note (%s)',
        'History::Lock'                     => 'Locked ticket.',
        'History::Unlock'                   => 'Unlocked ticket.',
        'History::TimeAccounting'       => '%s time unit(s) accounted. Now total %s time unit(s).',
        'History::Remove'               => '%s',
        'History::CustomerUpdate'       => 'Updated: %s',
        'History::PriorityUpdate'       => 'Changed priority from "%s" (%s) to "%s" (%s).',
        'History::OwnerUpdate'          => 'New owner is "%s" (ID=%s).',
        'History::LoopProtection'       => 'Loop-Protection! No auto-response sent to "%s".',
        'History::Misc'                 => '%s',
        'History::SetPendingTime'       => 'Updated: %s',
        'History::StateUpdate'          => 'Old: "%s" New: "%s"',
        'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
        'History::WebRequestCustomer'   => 'Customer request via web.',
        'History::TicketLinkAdd'        => 'Added link to ticket "%s".',
        'History::TicketLinkDelete'     => 'Deleted link to ticket "%s".',
        'History::SystemRequest'        => 'System Request (%s).',
        'History::TypeUpdate'           => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate'        => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate'            => 'Updated SLA to %s (ID=%s).',
    };

    # $$STOP$$
    return;
}

1;
