use warnings;
use strict;

package Data::ICal::Entry::Todo;

use base qw/Data::ICal::Entry/;

=head1 NAME

Data::ICal::Entry::Todo - Represents a to-do entry in an iCalendar file

=head1 SYNOPSIS

    my $vtodo = Data::ICal::Entry::Todo->new();
    $vtodo->add_properties(
        summary   => "go to sleep",
        status    => 'INCOMPLETE',
        # Dat*e*::ICal is not a typo here
        dtstart   => Date::ICal->new( epoch => time )->ical,
    );

    $calendar->add_entry($vtodo);

    $vtodo->add_entry($alarm);

=head1 DESCRIPTION

A L<Data::ICal::Entry::Todo> object represents a single to-do entry in
an iCalendar file.  (Note that the iCalendar RFC refers to entries as
"components".)  It is a subclass of L<Data::ICal::Entry> and accepts
all of its methods.

=head1 METHODS

=cut

=head2 ical_entry_type

Returns C<VTODO>, its iCalendar entry name.

=cut

sub ical_entry_type {'VTODO'}

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
specified at most one time for a to-do item:

      class  completed  created  description  dtstamp
      dtstart  geo  last-modified  location  organizer
      percent-complete  priority  recurrence-id  sequence  status
      summary  uid  url

In addition, C<due> and C<duration> may be specified at most once
each, but not both in the same entry (though this restriction is not
enforced).

Or if C<< vcal10 => 1 >>:

        class dcreated completed description dtstart due
        last-modified location rnum priority
        sequence status summary transp
        url uid

=cut

sub optional_unique_properties {
    my $self = shift;
    my @ret = $self->rfc_strict ? () : ("uid");
    if (not $self->vcal10) {
        push @ret, qw(
            class  completed  created  description  dtstamp
            dtstart  geo  last-modified  location  organizer
            percent-complete  priority  recurrence-id  sequence  status
            summary  uid  url

            due duration
        );
    } else {
        push @ret, qw(
            class dcreated completed description dtstart due
            last-modified location rnum priority
            sequence status summary transp
            url uid
        );
    }
    return @ret;
}

=head2 optional_repeatable_properties

According to the iCalendar standard, the following properties may be
specified any number of times for a to-do item:

      attach  attendee  categories  comment  contact
      exdate  exrule  request-status  related-to  resources
      rdate  rrule

Or if C<< vcal10 => 1 >>:

        aalarm  attach  attendee  categories
        dalarm  exdate  exrule  malarm  palarm  related-to
        resources  rdate  rrule

=cut

sub optional_repeatable_properties {
    my $self = shift;
    if (not $self->vcal10) {
        qw(
            attach  attendee  categories  comment  contact
            exdate  exrule  request-status  related-to  resources
            rdate  rrule
        );
    } else {
        qw(
            aalarm  attach  attendee  categories
            dalarm  exdate  exrule  malarm  palarm  related-to
            resources  rdate  rrule
        );
    }
}

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005 - 2015, Best Practical Solutions, LLC.  All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

1;
