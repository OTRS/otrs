# --
# Kernel/Language/en_CA.pm - provides en_CA language translation
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::en_CA;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Hit should be "%y-%m-%d". This is the standard date format in Canada (as specified by
    # the Canadian Standards Association in CSA Z234.5:1989, which adopts the ISO 8601 standard)
    #
    # http://en.wikipedia.org/wiki/Date_and_time_notation_by_country#Canada
    # year(2009)-month(06)-day(09),

    # $$START$$
    # Last translation file sync: Mon Jun  8 07:32:04 2009

    # possible charsets
    $Self->{Charset} = ['us-ascii', 'UTF-8', 'iso-8859-1', 'iso-8859-15', ];

    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y-%M-%D %T';
    $Self->{DateFormatLong}      = '%T - %Y-%M-%D';
    $Self->{DateFormatShort}     = '%Y-%M-%D';
    $Self->{DateInputFormat}     = '%Y-%M-%D';
    $Self->{DateInputFormatLong} = '%Y-%M-%D - %T';
    $Self->{Separator}           = ',';

    $Self->{Translation} = {

        # we call it cell in canada
        'Mobile' => 'Cell',

        # Zip is american reference, postal code is canadian
        'Zip' => 'Postal Code',

        # history translation
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
        'Updated Type to %s (ID=%s).' => 'Updated Type to %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Updated Service to %s (ID=%s).',
        'Updated SLA to %s (ID=%s).' => 'Updated SLA to %s (ID=%s).',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
        'FollowUp for [%s]. %s' => 'FollowUp for [%s]. %s',
        'AutoReject sent to "%s".' => 'AutoReject sent to "%s".',
        'AutoReply sent to "%s".' => 'AutoReply sent to "%s".',
        'AutoFollowUp sent to "%s".' => 'AutoFollowUp sent to "%s".',
        'Forwarded to "%s".' => 'Forwarded to "%s".',
        'Bounced to "%s".' => 'Bounced to "%s".',
        'Email sent to "%s".' => 'Email sent to "%s".',
        '"%s"-notification sent to "%s".' => '"%s"-notification sent to "%s".',
        'Notification sent to "%s".' => 'Notification sent to "%s".',
        'Email sent to customer.' => 'Email sent to customer.',
        'Added email. %s' => 'Added email. %s',
        'Agent called customer.' => 'Agent called customer.',
        'Customer called us.' => 'Customer called us.',
        'Added note (%s)' => 'Added note (%s)',
        'Locked ticket.' => 'Locked ticket.',
        'Unlocked ticket.' => 'Unlocked ticket.',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s time unit(s) accounted. Now total %s time unit(s).',
        '%s' => '%s',
        'Updated: %s' => 'Updated: %s',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Changed priority from "%s" (%s) to "%s" (%s).',
        'New owner is "%s" (ID=%s).' => 'New owner is "%s" (ID=%s).',
        'New responsible is "%s" (ID=%s).' => 'New responsible is "%s" (ID=%s).',
        'Loop-Protection! No auto-response sent to "%s".' => 'Loop-Protection! No auto-response sent to "%s".',
        '%s' => '%s',
        'Updated: %s' => 'Updated: %s',
        'Old: "%s" New: "%s"' => 'Old: "%s" New: "%s"',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Updated: %s=%s;%s=%s;%s=%s;',
        'Customer request via web.' => 'Customer request via web.',
        'Added link to ticket "%s".' => 'Added link to ticket "%s".',
        'Deleted link to ticket "%s".' => 'Deleted link to ticket "%s".',
        'Added subscription for user "%s".' => 'Added subscription for user "%s".',
        'Removed subscription for user "%s".' => 'Removed subscription for user "%s".',
        'System Request (%s).' => 'System Request (%s).',
        'Escalation response time forewarned' => 'Escalation response time forewarned',
        'Escalation update time forewarned' => 'Escalation update time forewarned',
        'Escalation solution time forewarned' => 'Escalation solution time forewarned',
        'Escalation response time in effect' => 'Escalation response time in effect',
        'Escalation update time in effect' => 'Escalation update time in effect',
        'Escalation solution time in effect' => 'Escalation solution time in effect',
        'Escalation response time finished' => 'Escalation response time finished',
        'Escalation update time finished' => 'Escalation update time finished',
        'Escalation solution time finished' => 'Escalation solution time finished',
        'Archive state changed: "%s"' => 'Archive state changed: "%s"',
        # There's a difference between May (short) and May (long) in some languages, not in en
        'May_long' => 'May',
        #CustomerUser fields
        'Title{CustomerUser}' => 'Title',
        'Firstname{CustomerUser}' => 'First name',
        'Lastname{CustomerUser}' => 'Last name',
        'Username{CustomerUser}' => 'Username',
        'Email{CustomerUser}' => 'E-mail address',
        'CustomerID{CustomerUser}' => 'Customer ID',
        'Phone{CustomerUser}' => 'Phone',
        'Fax{CustomerUser}' => 'Fax',
        'Mobile{CustomerUser}' => 'Cellphone',
        'Street{CustomerUser}' => 'Street',
        'Zip{CustomerUser}' => 'ZIP code',
        'City{CustomerUser}' => 'City',
        'Country{CustomerUser}' => 'Country',
        'Comment{CustomerUser}' => 'Comment',
        #User field
        'Title{user}' => 'Title',
    };
    # $$STOP$$
    return;
}

1;
