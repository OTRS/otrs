use warnings;
use strict;

package Data::ICal::Entry::Alarm::Audio;

use base qw/Data::ICal::Entry::Alarm/;

=head1 NAME

Data::ICal::Entry::Alarm::Audio - Represents an audio alarm in an iCalendar file

=head1 SYNOPSIS

    my $valarm = Data::ICal::Entry::Alarm::Audio->new();
    $valarm->add_properties(
        attach => [ "ftp://host.com/pub/sounds/bell-01.aud", { fmttype => "audio/basic" } ],
        # Dat*e*::ICal is not a typo here
        trigger   => [ Date::ICal->new( epoch => ... )->ical, { value => 'DATE-TIME' } ],
    );

    $vevent->add_entry($valarm);

=head1 DESCRIPTION

A L<Data::ICal::Entry::Alarm::Audio> object represents an audio alarm
attached to a todo item or event in an iCalendar file.  (Note that the
iCalendar RFC refers to entries as "components".)  It is a subclass of
L<Data::ICal::Entry::Alarm> and accepts all of its methods.

=head1 METHODS

=cut

=head2 new

Creates a new L<Data::ICal::Entry::Alarm::Audio> object; sets its
C<ACTION> property to C<AUDIO>.

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->add_property( action => "AUDIO" );
    return $self;
}

=head2 optional_unique_properties

In addition to C<duration> and C<repeat> (see
L<Data::ICal::Entry::Alarm/optional_unique_properties>), audio alarms
may specify a value for C<attach>.

=cut

sub optional_unique_properties {
    return (
        shift->SUPER::optional_unique_properties,
        "attach",
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
