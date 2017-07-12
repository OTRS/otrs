package PDF::API2::Basic::PDF::Filter::RunLengthDecode;

use base 'PDF::API2::Basic::PDF::Filter';

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

# Maintainer's Note: RunLengthDecode is described in the PDF 1.7 spec
# in section 7.4.5.

sub outfilt {
    my ($self, $input, $include_eod) = @_;
    my $output;

    while ($input ne '') {
        my ($unrepeated, $repeated);

        # Look for a repeated character (which can be repeated up to
        # 127 times)
        if ($input =~ m/^(.*?)((.)\3{1,127})(.*)$/so) {
            $unrepeated = $1;
            $repeated = $2;
            $input = $4;
        }
        else {
            $unrepeated = $input;
            $input = '';
        }

        # Print any non-repeating bytes at the beginning of the input
        # in chunks of up to 128 bytes, prefixed with a run-length (0
        # to 127, signifying 1 to 128 bytes)
        while (length($unrepeated) > 127) {
            $output .= pack('C', 127) . substr($unrepeated, 0, 128);
            substr($unrepeated, 0, 128) = '';
        }
        $output .= pack('C', length($unrepeated) - 1) . $unrepeated if length($unrepeated) > 0;

        # Then print the number of times the repeated byte was
        # repeated (using the formula "257 - length" to give a result
        # in the 129-255 range) followed by the byte to be repeated
        if (length($repeated)) {
            $output .= pack('C', 257 - length($repeated)) . substr($repeated, 0, 1);
        }
    }

    # A byte value of 128 signifies that we're done.
    $output .= "\x80" if $include_eod;

    return $output;
}

sub infilt {
    my ($self, $input, $is_terminated) = @_;
    my ($output, $length);

    # infilt may be called multiple times, and is expected to continue
    # where it left off
    if (exists $self->{'incache'}) {
        $input = $self->{'incache'} . $input;
        delete $self->{'incache'};
    }

    while (length($input)) {
        # Read a length byte
        $length = unpack("C", $input);

        # A "length" of 128 represents the end of the document
        if ($length == 128) {
            return $output;
        }

        # Any other length needs to be followed by at least one other byte
        if (length($input) == 1 and not $is_terminated) {
            die "Premature end to RunLengthEncoded data";
        }

        # A length of 129-255 represents a repeated string
        # (number of repeats = 257 - length)
        if ($length > 128) {
            if (length($input) == 1) {
                # Out of data.  Defer until the next call.
                $self->{'incache'} = $input;
                return $output;
            }
            $output .= substr($input, 1, 1) x (257 - $length);
            substr($input, 0, 2) = '';
        }

        # Any other length (under 128) represents a non-repeated
        # stream of bytes (with a length of 0 to 127 representing 1 to
        # 128 bytes)
        else {
            if (length($input) < $length + 2) {
                # Insufficient data.  Defer until the next call.
                $self->{'incache'} = $input;
                return $output;
            }
            $output .= substr($input, 1, $length + 1);
            substr($input, 0, $length + 2) = '';
        }
    }

    return $output;
}

1;
