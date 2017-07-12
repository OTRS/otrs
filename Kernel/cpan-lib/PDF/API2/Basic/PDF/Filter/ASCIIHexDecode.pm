package PDF::API2::Basic::PDF::Filter::ASCIIHexDecode;

use base 'PDF::API2::Basic::PDF::Filter';

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

# Maintainer's Note: ASCIIHexDecode is described in the PDF 1.7 spec
# in section 7.4.2.

sub outfilt {
    my ($self, $string, $include_eod) = @_;

    # Each byte of the input string gets encoded as two hexadecimal
    # characters.
    $string =~ s/(.)/sprintf('%02x', ord($1))/oge;

    # The EOD (end-of-document) marker is a greater-than sign
    $string .= '>' if $include_eod;

    return $string;
}

sub infilt {
    my ($self, $string) = @_;

    # "All white-space characters shall be ignored."
    $string =~ s/\s//og;

    # "A GREATER-THAN SIGN (3Eh) indicates EOD."
    my $has_eod_marker = 0;
    if (substr($string, -1, 1) eq '>') {
        $has_eod_marker = 1;
        chop $string;
    }

    # "Any other characters [than 0-9, A-F, or a-f] shall cause an
    # error."
    die "Illegal character found in ASCII hex-encoded stream"
        if $string =~ /[^0-9A-Fa-f]/;

    # "If the filter encounters the EOD marker after reading an odd
    # number of hexadecimal digits, it shall behave as if a 0 (zero)
    # followed the last digit."
    if ($has_eod_marker and length($string) % 2 == 1) {
        $string .= '0';
    }

    # "The ASCIIHexDecode filter shall produce one byte of binary data
    # for each pair of ASCII hexadecimal digits."
    $string =~ s/([0-9A-Fa-f]{2})/pack("C", hex($1))/oge;

    return $string;
}

1;
