use warnings;
use strict;

package Data::ICal;
use base qw/Data::ICal::Entry/;

use Class::ReturnValue;
use Text::vFile::asData;

our $VERSION = '0.22';

use Carp;

=head1 NAME

Data::ICal - Generates iCalendar (RFC 2445) calendar files

=head1 SYNOPSIS

    use Data::ICal;

    my $calendar = Data::ICal->new();

    my $vtodo = Data::ICal::Entry::Todo->new();
    $vtodo->add_properties(
        # ... see Data::ICal::Entry::Todo documentation
    );

    # ... or
    $calendar = Data::ICal->new(filename => 'foo.ics'); # parse existing file
    $calendar = Data::ICal->new(data => 'BEGIN:VCALENDAR...'); # parse from scalar
    $calendar->add_entry($vtodo);
    print $calendar->as_string;

=head1 DESCRIPTION

A L<Data::ICal> object represents a C<VCALENDAR> object as defined in the
iCalendar protocol (RFC 2445, MIME type "text/calendar"), as implemented in many
popular calendaring programs such as Apple's iCal.

Each L<Data::ICal> object is a collection of "entries", which are objects of a
subclass of L<Data::ICal::Entry>.  The types of entries defined by iCalendar
(which refers to them as "components") include events, to-do items, journal
entries, free/busy time indicators, and time zone descriptors; in addition,
events and to-do items can contain alarm entries.  (Currently, L<Data::ICal>
only implements to-do items and events.)

L<Data::ICal> is a subclass of L<Data::ICal::Entry>; see its manpage for more
methods applicable to L<Data::ICal>.

=head1 METHODS

=cut

=head2 new [ data => $data, ] [ filename => $file ], [ calname => $string ], [ vcal10 => $bool ], [ rfc_strict => $bool ], [ auto_uid => $bool ]

Creates a new L<Data::ICal> object.

If it is given a filename or data argument is passed, then this parses the
content of the file or string into the object.  If the C<vcal10> flag is passed,
parses it according to vCalendar 1.0, not iCalendar 2.0; this in particular impacts
the parsing of continuation lines in quoted-printable sections.

If a calname is passed, sets x-wr-calname to the given string.  Although
not specified in RFC2445, most calendar software respects x-wr-calname
as the displayed name of the calendar.

If the C<rfc_strict> flag is set to true, will require Data::ICal to
include UIDs, as per RFC2445:

    4.8.4.7 Unique Identifier
    ... The property MUST be specified in the "VEVENT", "VTODO",
    "VJOURNAL" or "VFREEBUSY" calendar components"

If the C<auto_uid> flag is set to true, will automatically generate a
default UID for each type which requires it, based on the RFC-suggested
algorithm.  Explicitly-set UID attributes will override this
auto-generated value.

If a filename or data argument is not passed, this just sets the
object's C<VERSION> and C<PRODID> properties to "2.0" (or "1.0" if the
C<vcal10> flag is passed) and the value of the C<product_id> method
respectively.

Returns a false value upon failure to open or parse the file or data; this false
value is a L<Class::ReturnValue> object and can be queried as to its
C<error_message>.

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);

    my %args = (
        filename   => undef,
        calname    => undef,
        data       => undef,
        vcal10     => 0,
        rfc_strict => 0,
        auto_uid   => 0,
        @_
    );

    $self->vcal10( $args{vcal10} );
    $self->rfc_strict( $args{rfc_strict} );
    $self->auto_uid( $args{auto_uid} );

    if ( defined $args{filename} or defined $args{data} ) {

        # might return a Class::ReturnValue if parsing fails
        return $self->parse(%args);
    } else {
        $self->add_properties(
            version => ( $self->vcal10 ? '1.0' : '2.0' ),
            prodid => $self->product_id,
        );
        $self->add_property('x-wr-calname' => $args{calname})
            if defined $args{calname};

        return $self;
    }
}

=head2 parse [ data => $data, ] [ filename => $file, ]

Parse a C<.ics> file or string containing one, and populate C<$self>
with its contents.

Should only be called once on a given object, and will be automatically
called by C<new> if you provide arguments to C<new>.

Returns C<$self> on success.  Returns a false value upon failure to
open or parse the file or data; this false value is a
L<Class::ReturnValue> object and can be queried as to its
C<error_message>.

=cut

sub parse {
    my $self = shift;
    my %args = (
        filename => undef,
        data     => undef,
        @_
    );

    unless ( defined $args{filename} or defined $args{data} ) {
        return $self->_error(
            "parse called with no filename or data specified");
    }

    my @lines;

    # open the file (checking as we go, like good little Perl mongers)
    if ( defined $args{filename} ) {
        open my $fh, '<', $args{filename}
            or return $self->_error("could not open '$args{filename}': $!");
        @lines = map { chomp; $_ } <$fh>;
    } else {
        @lines = split /\r?\n/, $args{data};
    }

    @lines = $self->_vcal10_input_cleanup(@lines) if $self->vcal10;

    # Parse the lines; Text::vFile doesn't want trailing newlines
    my $cal = eval { Text::vFile::asData->new->parse_lines(@lines) };
    return $self->_error("parse failure: $@") if $@;

    return $self->_error("parse failure")
        unless $cal and exists $cal->{objects};

    # loop through all the vcards
    foreach my $object ( @{ $cal->{objects} } ) {
        $self->parse_object($object);
    }

    my $version_ref = $self->property("version");
    my $version = $version_ref ? $version_ref->[0]->value : undef;
    unless ( defined $version ) {
        return $self->_error("data does not specify a version property");
    }

    if (   $version eq '1.0' and not $self->vcal10
        or $version eq '2.0' and $self->vcal10 )
    {
        return $self->_error( 'application claims data is'
                . ( $self->vcal10 ? '' : ' not' )
                . ' vCal 1.0 but doc contains VERSION:'
                . $version );
    }

    return $self;
}

sub _error {
    my $self = shift;
    my $msg  = shift;

    my $ret = Class::ReturnValue->new;
    $ret->as_error( errno => 1, message => $msg );
    return $ret;
}

=head2 ical_entry_type

Returns C<VCALENDAR>, its iCalendar entry name.

=cut

sub ical_entry_type {'VCALENDAR'}

=head2 product_id

Returns the product ID used in the calendar's C<PRODID> property; you may
wish to override this in a subclass for your own application.

=cut

sub product_id {
    my $self = shift;
    return "Data::ICal $VERSION";
}

=head2 mandatory_unique_properties

According to the iCalendar standard, the following properties must be specified
exactly one time for a calendar:

      prodid version

=cut

sub mandatory_unique_properties {
    qw(
        prodid version
    );
}

=head2 optional_unique_properties

According to the iCalendar standard, the following properties may be specified
at most one time for a calendar:

      calscale method

=cut

sub optional_unique_properties {
    qw(
        calscale method
    );
}

# In quoted-printable sections, convert from vcal10 "=\n" line endings to
# ical20 "\n ".
sub _vcal10_input_cleanup {
    my $self     = shift;
    my @in_lines = @_;

    my @out_lines;

    my $in_qp = 0;
LINE: while (@in_lines) {
        my $line = shift @in_lines;

        if ( not $in_qp and $line =~ /^[^:]+;ENCODING=QUOTED-PRINTABLE/i ) {
            $in_qp = 1;
        }

        unless ($in_qp) {
            push @out_lines, $line;
            next LINE;
        }

        if ( $line =~ s/=$// ) {
            push @out_lines, $line;
            $in_lines[0] = ' ' . $in_lines[0] if @in_lines;
        } else {
            push @out_lines, $line;
            $in_qp = 0;
        }
    }

    return @out_lines;
}

=head1 DEPENDENCIES

L<Data::ICal> requires L<Class::Accessor>, L<Text::vFile::asData>,
L<MIME::QuotedPrint>, and L<Class::ReturnValue>.

=head1 BUGS AND LIMITATIONS

L<Data::ICal> does not support time zone daylight or standard entries,
so time zone components are basically useless.

While L<Data::ICal> tries to check which properties are required and
repeatable, this only works in simple cases; it does not check for
properties that must either both exist or both not exist, or for
mutually exclusive properties.

L<Data::ICal> does not check to see if property parameter names are
known in general or allowed on the particular property.

L<Data::ICal> does not check to see if nested entries are nested
properly (alarms in todos and events only, everything else in
calendars only).

The only property encoding supported by L<Data::ICal> is quoted
printable.

Please report any bugs or feature requests to
C<bug-data-ical@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005 - 2015, Best Practical Solutions, LLC.  All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

1;
