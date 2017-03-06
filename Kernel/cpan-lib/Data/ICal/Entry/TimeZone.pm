use warnings;
use strict;

package Data::ICal::Entry::TimeZone;

use base qw/Data::ICal::Entry/;

=head1 NAME

Data::ICal::Entry::TimeZone - Represents a time zone definition in an iCalendar file

=head1 SYNOPSIS

    my $vtimezone = Data::ICal::Entry::TimeZone->new();
    $vtimezone->add_properties(
        tzid => "US-Eastern",
        tzurl => "http://zones.stds_r_us.net/tz/US-Eastern"
    );

    $vtimezone->add_entry($daylight); # daylight/ standard not yet implemented
    $vtimezone->add_entry($standard); # :-(

    $calendar->add_entry($vtimezone);

=head1 DESCRIPTION

A L<Data::ICal::Entry::TimeZone> object represents the declaration of
a time zone in an iCalendar file.  (Note that the iCalendar RFC refers
to entries as "components".)  It is a subclass of L<Data::ICal::Entry>
and accepts all of its methods.

This module is not yet useful, because every time zone declaration
needs to contain at least one C<STANDARD> or C<DAYLIGHT> component,
and these have not yet been implemented.

=head1 METHODS

=cut

=head2 ical_entry_type

Returns C<VTIMEZONE>, its iCalendar entry name.

=cut

sub ical_entry_type {'VTIMEZONE'}

=head2 optional_unique_properties

According to the iCalendar standard, the following properties may be
specified at most one time for a time zone declaration:

        last-modified tzurl

=cut

sub optional_unique_properties {
    qw(
        last-modified tzurl
    );
}

=head2 mandatory_unique_properties

According to the iCalendar standard, the C<tzid> property must be
specified exactly one time in a time zone declaration.

=cut

sub mandatory_unique_properties {
    qw(
        tzid
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
