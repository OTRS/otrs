use warnings;
use strict;

package Data::ICal::Property;

use base qw/Class::Accessor/;

use Carp;
use MIME::QuotedPrint ();

our $VERSION = '0.06';

=head1 NAME

Data::ICal::Property - Represents a property on an entry in an iCalendar file

=head1 DESCRIPTION

A L<Data::ICal::Property> object represents a single property on an
entry in an iCalendar file.  Properties have parameters in addition to
their value.

You shouldn't need to create L<Data::ICal::Property> values directly
-- just use C<add_property> in L<Data::ICal::Entry>.

The C<encoding> parameter value is only interpreted by L<Data::ICal>
in the C<decoded_value> and C<encode> methods: all other methods
access the encoded version directly (if there is an encoding).

Currently, the only supported encoding is C<QUOTED-PRINTABLE>.

=head1 METHODS

=cut

=head2 new $key, $value, [$parameter_hash]

Creates a new L<Data::ICal::Property> with key C<$key> and value C<$value>.

If C<$parameter_hash> is provided, sets the property's parameters to
it.  The parameter hash should have keys equal to the names of the
parameters (case insensitive; parameter hashes should not contain two
different keys which are the same when converted to upper case); the
values should either be a string if the parameter has a single value
or an array reference of strings if the parameter has multiple values.

=cut

sub new {
    my $class = shift;
    my $self  = {};

    bless $self, $class;

    $self->key(shift);
    $self->value(shift);
    $self->parameters( shift || {} );
    return ($self);
}

=head2 key [$key]

Gets or sets the key name of this property.

=head2 value [$value]

Gets or sets the value of this property.

=head2 parameters [$param_hash]

Gets or sets the parameter hash reference of this property.  Parameter
keys are converted to upper case.

=head2 vcal10 [$bool]

Gets or sets a boolean saying whether this should be interpreted as
vCalendar 1.0 (as opposed to iCalendar 2.0).  Generally, you can just
set this on your main L<Data::ICal> object when you construct it;
C<add_entry> automatically makes sure that sub-entries end up with the
same value as their parents, and C<add_property> makes sure that
properties end up with the same value as their entry.

=cut

__PACKAGE__->mk_accessors(qw(key value _parameters vcal10));

sub parameters {
    my $self = shift;

    if (@_) {
        my $params     = shift;
        my $new_params = {};
        while ( my ( $k, $v ) = each %$params ) {
            $new_params->{ uc $k } = $v;
        }
        $self->_parameters($new_params);
    }

    return $self->_parameters;
}

my %ENCODINGS = (
    'QUOTED-PRINTABLE' => {
        encode => sub {
            my $dec = shift || '';
            $dec =~ s/\n/\r\n/g;
            return MIME::QuotedPrint::encode( $dec, '' );
        },
        decode => sub {
            my $dec = MIME::QuotedPrint::decode( shift || '' );
            $dec =~ s/\r\n/\n/g;
            return $dec;
            }
    },
);

=head2 decoded_value

Gets the value of this property, converted from the encoding specified
in its encoding parameter.  (That is, C<value> will return the encoded
version; this will apply the encoding.)  If the encoding is not
specified or recognized, just returns the raw value.

=cut

sub decoded_value {
    my $self     = shift;
    my $value    = $self->value;
    my $encoding = uc( $self->parameters->{'ENCODING'} || "" );

    if ( $ENCODINGS{$encoding} ) {
        return $ENCODINGS{$encoding}{'decode'}->($value);
    } else {
        return $value;
    }
}

=head2 encode $encoding

Calls C<decoded_value> to get the current decoded value, then encodes
it in C<$encoding>, sets the value to that, and sets the encoding
parameter to C<$encoding>. (C<$encoding> is first converted to upper
case.)

If C<$encoding> is undef, deletes the encoding parameter and sets the
value to the decoded value.  Does nothing if the encoding is not
recognized.

=cut

sub encode {
    my $self     = shift;
    my $encoding = uc shift;

    my $decoded_value = $self->decoded_value;

    if ( not defined $encoding ) {
        $self->value($decoded_value);
        delete $self->parameters->{'ENCODING'};
    } elsif ( $ENCODINGS{$encoding} ) {
        $self->value( $ENCODINGS{$encoding}{'encode'}->($decoded_value) );
        $self->parameters->{'ENCODING'} = $encoding;
    }
    return $self;
}

=head2 as_string ARGS

Returns the property formatted as a string (including trailing
newline).

Takes named arguments:

=over

=item fold

Defaults to true. pass in a false value if you need to generate
non-rfc-compliant calendars.

=item crlf

Defaults to C<\x0d\x0a>, per RFC 2445 spec.  This option is primarily
for backwards compatibility with version of this module prior to 0.16,
which used C<\x0a>.

=back

=cut

sub as_string {
    my $self = shift;
    my %args = (
        fold => 1,
        crlf => Data::ICal::Entry->CRLF,
        @_
    );
    my $string
        = uc( $self->key )
        . $self->_parameters_as_string . ":"
        . $self->_value_as_string( $self->key )
        . $args{crlf};

  # Assumption: the only place in an iCalendar that needs folding are property
  # lines
    if ( $args{'fold'} ) {
        return $self->_fold( $string, $args{crlf} );
    }

    return $string;
}

=begin private

=head2 _value_as_string

Returns the property's value as a string.  Comma and semicolon are not
escaped when the value is recur type (the key is rrule).

Values are quoted according the iCal spec, unless this is in vCal 1.0
mode.

=end private

=cut

sub _value_as_string {
    my $self  = shift;
    my $key   = shift;
    my $value = defined( $self->value() ) ? $self->value() : '';

    unless ( $self->vcal10 ) {
        $value =~ s/\\/\\\\/gs;
        $value =~ s/;/\\;/gs unless lc($key) eq 'rrule';
        $value =~ s/,/\\,/gs unless lc($key) eq 'rrule';
        $value =~ s/\x0d?\x0a/\\n/gs;
    }

    return $value;
}

=begin private

=head2 _parameters_as_string

Returns the property's parameters as a string.  Properties are sorted alphabetically
to aid testing.

=end private

=cut

sub _parameters_as_string {
    my $self = shift;
    my $out  = '';
    for my $name ( sort keys %{ $self->parameters } ) {
        my $value = $self->parameters->{$name};
        $out
            .= ';'
            . $name . '='
            . $self->_quoted_parameter_values(
            ref $value ? @$value : $value );
    }
    return $out;
}

=begin private

=head2 _quoted_parameter_values @values

Quotes any of the values in C<@values> that need to be quoted and
returns the quoted values joined by commas.

If any of the values contains a double-quote, erases it and emits a
warning.

=end private

=cut

sub _quoted_parameter_values {
    my $self   = shift;
    my @values = @_;

    for my $val (@values) {
        if ( $val =~ /"/ ) {

            # Get all the way back to the user's code
            local $Carp::CarpLevel = $Carp::CarpLevel + 1;
            carp "Invalid parameter value (contains double quote): $val";
            $val =~ tr/"//d;
        }
    }

    return join ',', map { /[;,:]/ ? qq("$_") : $_ } @values;
}

=begin private

=head2 _fold $string $crlf

Returns C<$string> folded with newlines and leading whitespace so that
each line is at most 75 characters.

(Note that it folds at 75 characters, not 75 bytes as specified in the
standard.)

If this is vCalendar 1.0 and encoded with QUOTED-PRINTABLE, does not
fold at all.

=end private

=cut

sub _fold {
    my $self   = shift;
    my $string = shift;
    my $crlf   = shift;

    my $quoted_printable = $self->vcal10
        && uc( $self->parameters->{'ENCODING'} || '' ) eq 'QUOTED-PRINTABLE';

    if ($quoted_printable) {

     # In old vcal, quoted-printable properties have different folding rules.
     # But some interop tests suggest it's wiser just to not fold for vcal 1.0
     # at all (in quoted-printable).
    } else {
        my $pos = 0;

        # Walk through the value, looking to replace 75 characters at
        # a time.  We assign to pos() to update where to pick up for
        # the next match.
        while ( $string =~ s/\G(.{75})(?=.)/$1$crlf / ) {
            $pos += 75 + length($crlf);
            pos($string) = $pos;
        }
    }

    return $string;
}

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005 - 2015, Best Practical Solutions, LLC.  All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

1;

