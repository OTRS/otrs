use warnings;
use strict;

package Data::ICal::Entry::TimeZone::Standard;

use base qw/Data::ICal::Entry/;

=head1 NAME

Data::ICal::Entry::TimeZone::Standard - Represents a Standard Time base offset from UTC for parent TimeZone

=head1 DESCRIPTION

A time zone is unambiguously defined by the set of time measurement
rules determined by the governing body for a given geographic
area. These rules describe at a minimum the base offset from UTC for
the time zone, often referred to as the Standard Time offset. Many
locations adjust their Standard Time forward or backward by one hour,
in order to accommodate seasonal changes in number of daylight hours,
often referred to as Daylight Saving Time. Some locations adjust their
time by a fraction of an hour. Standard Time is also known as Winter
Time. Daylight Saving Time is also known as Advanced Time, Summer
Time, or Legal Time in certain countries. The following table shows
the changes in time zone rules in effect for New York City starting
from 1967. Each line represents a description or rule for a particular
observance.

     Effective Observance Rule

     Date       (Date/Time)             Offset  Abbreviation

     1967-*     last Sun in Oct, 02:00  -0500   EST

     1967-1973  last Sun in Apr, 02:00  -0400   EDT

     1974-1974  Jan 6,  02:00           -0400   EDT

     1975-1975  Feb 23, 02:00           -0400   EDT

     1976-1986  last Sun in Apr, 02:00  -0400   EDT

     1987-*     first Sun in Apr, 02:00 -0400   EDT

Note: The specification of a global time zone registry is not
addressed by this document and is left for future study.  However,
implementers may find the Olson time zone database [TZ] a useful
reference. It is an informal, public-domain collection of time zone
information, which is currently being maintained by volunteer Internet
participants, and is used in several operating systems. This database
contains current and historical time zone information for a wide
variety of locations around the globe; it provides a time zone
identifier for every unique time zone rule set in actual use since
1970, with historical data going back to the introduction of standard
time.

=head1 METHODS

=cut

=head2 ical_entry_type

Returns C<STANDARD>, its iCalendar entry name.

=cut

sub ical_entry_type {'STANDARD'}

=head2 mandatory_unique_properties

According to the iCalendar standard, the following properties must be
specified exactly one time in a standard time declaration:

        dtstart  tzoffsetto  tzoffsetfrom

=cut

sub mandatory_unique_properties {
    qw(
        dtstart
        tzoffsetto
        tzoffsetfrom
    );
}

=head2 optional_repeatable_properties

According to the iCalendar standard, the following properties may be
specified any number of times for a standard time declaration:

        comment  rdate  rrule  tzname

=cut

sub optional_repeatable_properties {
    qw(
        comment
        rdate
        rrule
        tzname
    );
}

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005 - 2015, Best Practical Solutions, LLC.  All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

1;
