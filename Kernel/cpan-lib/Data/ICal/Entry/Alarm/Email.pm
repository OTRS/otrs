use warnings;
use strict;

package Data::ICal::Entry::Alarm::Email;

use base qw/Data::ICal::Entry::Alarm/;

=head1 NAME

Data::ICal::Entry::Alarm::Email - Represents an emailed alarm in an iCalendar file

=head1 SYNOPSIS

    my $valarm = Data::ICal::Entry::Alarm::Audio->new();
    $valarm->add_properties(
        attach => [ "basic:ftp://host.com/pub/sounds/bell-01.aud", { fmttype => "audio/basic" } ],
        # Dat*e*::ICal is not a typo here
        trigger   => [ Date::ICal->new( epoch => ... )->ical, { value => 'DATE-TIME' } ],
    );

    $vevent->add_entry($valarm);

=head1 DESCRIPTION

A L<Data::ICal::Entry::Alarm::Email> object represents an emailed
alarm attached to a todo item or event in an iCalendar file.  (Note
that the iCalendar RFC refers to entries as "components".)  It is a
subclass of L<Data::ICal::Entry::Alarm> and accepts all of its methods.

The C<attendee> properties are intended as the recipient list of the
email; the C<summary> as its subject; the C<description> as its body;
and the C<attach> as its attachments.

=head1 METHODS

=cut

=head2 new

Creates a new L<Data::ICal::Entry::Alarm::Email> object; sets its
C<ACTION> property to C<EMAIL>.

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->add_property( action => "EMAIL" );
    return $self;
}

=head2 mandatory_unique_properties

In addition to C<action> and C<trigger> (see
L<Data::ICal::Entry::Alarm/mandatory_unique_properties>), emailed alarms
must also specify a value for C<description> and C<summary>.

=cut

sub mandatory_unique_properties {
    return (
        shift->SUPER::mandatory_unique_properties,
        "description", "summary",
    );
}

=head2 mandatory_repeatable_properties

According to the iCalendar standard, the C<attendee> property must be
specified at least once for an emailed alarm.

=cut

sub mandatory_repeatable_properties {
    qw(
        attendee
    );
}

=head2 optional_repeatable_properties

According to the iCalendar standard, the C<attach> property may be
specified any number of times for an emailed alarm.

=cut

sub optional_repeatable_properties {
    qw(
        attach
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
