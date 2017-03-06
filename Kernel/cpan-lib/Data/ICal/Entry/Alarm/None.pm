use warnings;
use strict;

package Data::ICal::Entry::Alarm::None;

use base qw/Data::ICal::Entry::Alarm/;

=head1 NAME

Data::ICal::Entry::Alarm::None - Represents an default no-op alarm

=head1 SYNOPSIS

    my $valarm = Data::ICal::Entry::Alarm::None->new();
    $vevent->add_entry($valarm);

=head1 DESCRIPTION

A L<Data::ICal::Entry::Alarm::None> object represents a default alarm
that does nothing; this is different from a lack of alarm, because
clients may be expected to "override" any default alarm present in
calendar data with the current value retrieved from the server.  This
class is a subclass of L<Data::ICal::Entry::Alarm> and accepts all of
its methods.

This element is not included in the official iCal RFC, but is rather an
unaccepted draft standard; see
L<https://tools.ietf.org/html/draft-daboo-valarm-extensions-04#section-11>
B<Its interoperability and support is thus limited.> This is alarm type
is primarily used by Apple.

=head1 METHODS

=cut

=head2 new

Creates a new L<Data::ICal::Entry::Alarm::None> object; sets its
C<ACTION> property to C<NONE>.

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->add_property( action => "NONE" );
    return $self;
}

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005 - 2015, Best Practical Solutions, LLC.  All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

1;
