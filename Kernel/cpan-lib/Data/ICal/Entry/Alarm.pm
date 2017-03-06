use warnings;
use strict;

package Data::ICal::Entry::Alarm;

use base qw/Data::ICal::Entry/;

=head1 NAME

Data::ICal::Entry::Alarm - Abstract base class for alarms

=head1 DESCRIPTION

L<Data::ICal::Entry::Alarm> is an abstract base class for the other type
of supported by alarms:

=over

=item L<Data::ICal::Entry::Alarm::Audio>

=item L<Data::ICal::Entry::Alarm::Display>

=item L<Data::ICal::Entry::Alarm::Email>

=item L<Data::ICal::Entry::Alarm::Procedure>

=back

It is a subclass of L<Data::ICal::Entry> and accepts all of its methods.

=head1 METHODS

=cut

=head2 new


=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    die "Can't instantiate abstract base class Data::ICal::Entry::Alarm"
        if $class eq __PACKAGE__;
    return $self;
}

=head2 ical_entry_type

Returns C<VALARM>, its iCalendar entry name.

=cut

sub ical_entry_type {'VALARM'}

=head2 optional_unique_properties

According to the iCalendar standard, the C<duration> and C<retreat>
properties may be specified at most one time all types of alarms; if one
is specified, the other one must be also, though this module does not
enforce that restriction.

=cut

sub optional_unique_properties {
    qw(
        duration repeat
    );
}

=head2 mandatory_unique_properties

According to the iCalendar standard, the C<trigger> property must be
specified exactly once for an all types of alarms; subclasses may have
additional required properties.

In addition, the C<action> property must be specified exactly once, but
all subclasses automatically set said property appropriately.

=cut

sub mandatory_unique_properties {
    qw(
        action trigger
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
