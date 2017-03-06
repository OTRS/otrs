use warnings;
use strict;

package Data::ICal::Entry::FreeBusy;

use base qw/Data::ICal::Entry/;

=head1 NAME

Data::ICal::Entry::FreeBusy - Represents blocks of free and busy time in an iCalendar file

=head1 SYNOPSIS

    my $vfreebusy = Data::ICal::Entry::FreeBusy->new();
    $vfreebusy->add_properties(
        organizer => 'MAILTO:jsmith@host.com',
        # Dat*e*::ICal is not a typo here
        freebusy   => Date::ICal->new( epoch => ... )->ical . '/' . Date::ICal->new( epoch => ... )->ical,
    );

    $calendar->add_entry($vfreebusy);

=head1 DESCRIPTION

A L<Data::ICal::Entry::FreeBusy> object represents a request for
information about free and busy time or a reponse to such a request,
in an iCalendar file.  (Note that the iCalendar RFC refers to entries
as "components".)  It is a subclass of L<Data::ICal::Entry> and
accepts all of its methods.

=head1 METHODS

=cut

=head2 ical_entry_type

Returns C<VFREEBUSY>, its iCalendar entry name.

=cut

sub ical_entry_type {'VFREEBUSY'}

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
specified at most one time for a free/busy entry:

        contact  dtstart  dtend  duration  dtstamp
        organizer  uid  url

=cut

sub optional_unique_properties {
    my $self = shift;
    my @ret = qw(
        contact  dtstart  dtend  duration  dtstamp
        organizer  url
    );
    push @ret, "uid" unless $self->rfc_strict;
    return @ret;
}

=head2 optional_repeatable_properties

According to the iCalendar standard, the following properties may be
specified any number of times for free/busy entry:

        attendee comment freebusy request-status

=cut

sub optional_repeatable_properties {
    qw(
        attendee comment freebusy request-status
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
