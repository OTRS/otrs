# --
# Kernel/Language/en_GB.pm - provides British English language translation
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::en_GB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # http://en.wikipedia.org/wiki/Date_and_time_notation_by_country#United_Kingdom
    # day-month-year (e.g., "31/12/99")

    # $$START$$
    # Last translation file sync: Thu Apr  9 10:12:50 2009

    # possible charsets
    $Self->{Charset} = ['us-ascii', 'UTF-8', 'iso-8859-1', 'iso-8859-15', ];

    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%T - %D/%M/%Y';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Separator}           = ',';

    # maybe nothing ... or help texts
    $Self->{Translation} = {
        'May_long' => 'May',
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
        #CustomerUser fields
        'Title{CustomerUser}' => 'Title',
        'Firstname{CustomerUser}' => 'First name',
        'Lastname{CustomerUser}' => 'Surname',
        'Username{CustomerUser}' => 'Username',
        'Email{CustomerUser}' => 'E-mail address',
        'CustomerID{CustomerUser}' => 'Customer ID',
        'Phone{CustomerUser}' => 'Phone',
        'Fax{CustomerUser}' => 'Fax',
        'Mobile{CustomerUser}' => 'Mobile',
        'Street{CustomerUser}' => 'Street',
        'Zip{CustomerUser}' => 'Postcode',
        'City{CustomerUser}' => 'City',
        'Country{CustomerUser}' => 'Country',
        'Comment{CustomerUser}' => 'Comment',
        #User field
        'Title{user}' => 'Title',
        #'Statuses' is American English
        'Statuses'    => 'Status',
        #'License' is American English
        'License' => 'Licence',
        'To accept some news, a license or some changes.' => 'To accept some news, a licence or some changes.',
        'Accept license' => 'Accept licence',
        'Don\'t accept license' => 'Don\'t accept licence',
        #'Favorite' is American English
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' => 'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.',
        #'Zip' is American English
        'Zip' => 'Postcode',
    };
    # $$STOP$$
    return;
}

1;
