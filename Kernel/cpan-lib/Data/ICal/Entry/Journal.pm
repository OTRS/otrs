use warnings;
use strict;

package Data::ICal::Entry::Journal;

use base qw/Data::ICal::Entry/;

=head1 NAME

Data::ICal::Entry::Journal - Represents a journal entry in an iCalendar file

=head1 SYNOPSIS

    my $vjournal = Data::ICal::Entry::Journal->new();
    $vjournal->add_properties(
        summary => "Minutes of my party",
        description => "I cried because I wanted to.",
        # Dat*e*::ICal is not a typo here
        dtstart   => Date::ICal->new( epoch => time )->ical,
    );

    $calendar->add_entry($vjournal);

=head1 DESCRIPTION

A L<Data::ICal::Entry::Journal> object represents a single journal
entry in an iCalendar file.  (Note that the iCalendar RFC refers to
entries as "components".)  It is a subclass of L<Data::ICal::Entry>
and accepts all of its methods.

=head1 METHODS

=cut

=head2 ical_entry_type

Returns C<VJOURNAL>, its iCalendar entry name.

=cut

sub ical_entry_type {'VJOURNAL'}

=head2 mandatory_unique_properties

The C<uid> property is mandatory if C<rfc_strict> was passed to
L<Data::ICal/new>.

=cut

sub mandatory_unique_properties {
    my $self = shift;
    return $self->rfc_strict ? ("uid") : ()
}

=head2 optional_unique_properties

According to the iCalendar standard, the following properties may be
specified at most one time for a journal entry:

    class  created  description  dtstart  dtstamp
    last-modified  organizer  recurrence-id  sequence  status
    summary  uid  url

=cut

sub optional_unique_properties {
    my $self = shift;
    my @ret = qw(
        class  created  description  dtstart  dtstamp
        last-modified  organizer  recurrence-id  sequence  status
        summary url
    );
    push @ret, "uid" unless $self->rfc_strict;
    return @ret;
}

=head2 optional_repeatable_properties

According to the iCalendar standard, the following properties may be
specified any number of times for a journal entry:

        attach  attendee  categories  comment
        contact  exdate  exrule  related-to  rdate
        rrule  request-status

=cut

sub optional_repeatable_properties {
    qw(
        attach  attendee  categories  comment
        contact  exdate  exrule  related-to  rdate
        rrule  request-status
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
