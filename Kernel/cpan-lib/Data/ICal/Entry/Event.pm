use warnings;
use strict;

package Data::ICal::Entry::Event;

use base qw/Data::ICal::Entry/;

=head1 NAME

Data::ICal::Entry::Event - Represents an event in an iCalendar file

=head1 SYNOPSIS

    my $vevent = Data::ICal::Entry::Event->new();
    $vevent->add_properties(
        summary => "my party",
        description => "I'll cry if I want to",
        # Dat*e*::ICal is not a typo here
        dtstart   => Date::ICal->new( epoch => time )->ical,
    );

    $calendar->add_entry($vevent);

    $vevent->add_entry($alarm);

=head1 DESCRIPTION

A L<Data::ICal::Entry::Event> object represents a single event in an
iCalendar file.  (Note that the iCalendar RFC refers to entries as
"components".)  It is a subclass of L<Data::ICal::Entry> and accepts
all of its methods.

=head1 METHODS

=cut

=head2 ical_entry_type

Returns C<VEVENT>, its iCalendar entry name.

=cut

sub ical_entry_type {'VEVENT'}

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
specified at most one time for an event:

        class  created  description  dtstart  geo
        last-modified  location  organizer  priority
        dtstamp  sequence  status  summary  transp
        uid  url  recurrence-id

In addition, C<dtend> and C<duration> may be specified at most once
each, but not both in the same entry (though this restriction is not
enforced).

Or if C<< vcal10 => 1 >>:

        class dcreated completed description dtstart dtend
        last-modified location rnum priority
        sequence status summary transp
        url uid

=cut

sub optional_unique_properties {
    my $self = shift;
    my @ret = $self->rfc_strict ? () : ("uid");
    if (not $self->vcal10) {
        push @ret, qw(
            class  created  description  dtstart  geo
            last-modified  location  organizer  priority
            dtstamp  sequence  status  summary  transp
            url  recurrence-id

            dtend duration
        );
    } else {
        push @ret, qw(
            class dcreated completed description dtstart dtend
            last-modified location rnum priority
            sequence status summary transp
            url
        );
    }
    return @ret;
}

=head2 optional_repeatable_properties

According to the iCalendar standard, the following properties may be
specified any number of times for an event:

        attach  attendee  categories  comment
        contact  exdate  exrule  request-status  related-to
        resources  rdate  rrule

Or if C<< vcal10 => 1 >>:

        aalarm  attach  attendee  categories
        dalarm  exdate  exrule  malarm  palarm  related-to
        resources  rdate  rrule

=cut

sub optional_repeatable_properties {
    my $self = shift;
    if (not $self->vcal10) {
        qw(
            attach  attendee  categories  comment
            contact  exdate  exrule  request-status  related-to
            resources  rdate  rrule
        );
    } else {
        qw(
            aalarm  attach  attendee  categories
            dalarm  exdate  exrule  malarm  palarm  related-to
            resources  rdate  rrule
        );
    }
}

=head1 SEE ALSO

=over 4

=item L<Data::ICal::DateTime>

For date parsing and formatting, including denoting "all day" events,
considering using this module. Because it's a "mix in", you can still
use all the methods here as well as the new date handling methods it
defines.

=back

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005 - 2015, Best Practical Solutions, LLC.  All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

1;
