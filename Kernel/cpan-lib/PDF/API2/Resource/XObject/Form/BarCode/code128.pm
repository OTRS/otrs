package PDF::API2::Resource::XObject::Form::BarCode::code128;

use base 'PDF::API2::Resource::XObject::Form::BarCode';

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

=head1 NAME

PDF::API2::Resource::XObject::Form::BarCode::code128 - Code 128 and EAN-128 barcode support

=head1 METHODS

=over

=item $res = PDF::API2::Resource::XObject::Form::BarCode::code128->new($pdf, %options)

Returns a code128 object. Use '-ean' to encode using EAN128 mode.

=back

=cut

sub new {
    my ($class, $pdf, %options) = @_;
    $class = ref($class) if ref($class);

    my $self = $class->SUPER::new($pdf, %options);

    my @bars;
    if ($options{'-ean'}) {
        @bars = $self->encode_ean128($options{'-code'});
    }
    else {
        @bars = $self->encode_128($options{'-type'}, $options{'-code'});
    }

    $self->drawbar(\@bars, $options{'caption'});

    return $self;
}

# CODE-A Encoding Table
my $code128a = q| !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_| . join('', map { chr($_) } (0..31)) . qq/\xf3\xf2\x80\xcc\xcb\xf4\xf1\x8a\x8b\x8c\xff/;

# CODE-B Encoding Table
my $code128b = q| !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|.qq/|}~\x7f\xf3\xf2\x80\xcc\xf4\xca\xf1\x8a\x8b\x8c\xff/;

# CODE-C Encoding Table (00-99 are placeholders)
my $code128c = ("\xfe" x 100) . qq/\xcb\xca\xf1\x8a\x8b\x8c\xff/;

# START A-C
my $bar128Sa = "\x8a";
my $bar128Sb = "\x8b";
my $bar128Sc = "\x8c";

# FNC1-FNC4
my $bar128F1 = "\xf1";
my $bar128F2 = "\xf2";
my $bar128F3 = "\xf3";
my $bar128F4 = "\xf4";

# CODE A-C
my $bar128Ca = "\xca";
my $bar128Cb = "\xcb";
my $bar128Cc = "\xcc";

# SHIFT
my $bar128sh = "\x80";

# STOP
my $bar128St = "\xff";

# Note: The stop code (last position) is longer than the other codes because it also has the
# termination bar appended, rather than requiring it be added as a separate call.
my @bar128 = qw(
    212222 222122 222221 121223 121322 131222 122213 122312 132212 221213
    221312 231212 112232 122132 122231 113222 123122 123221 223211 221132
    221231 213212 223112 312131 311222 321122 321221 312212 322112 322211
    212123 212321 232121 111323 131123 131321 112313 132113 132311 211313
    231113 231311 112133 112331 132131 113123 113321 133121 313121 211331
    231131 213113 213311 213131 311123 311321 331121 312113 312311 332111
    314111 221411 431111 111224 111422 121124 121421 141122 141221 112214
    112412 122114 122411 142112 142211 241211 221114 413111 241112 134111
    111242 121142 121241 114212 124112 124211 411212 421112 421211 212141
    214121 412121 111143 111341 131141 114113 114311 411113 411311 113141
    114131 311141 411131 b1a4a2 b1a2a4 b1a2c2 b3c1a1b
);

sub encode_128_char_idx {
    my ($code, $char) = @_;
    my $index;

    if (lc($code) eq 'a') {
        # Ignore CODE-A request if we're already in CODE-A
        return if $char eq $bar128Ca;

        $index = index($code128a, $char);
    }
    elsif (lc($code) eq 'b') {
        # Ignore CODE-B request if we're already in CODE-B
        return if $char eq $bar128Cb;
        $index = index($code128b, $char);
    }
    elsif (lc($code) eq 'c') {
        # Ignore CODE-C request if we're already in CODE-C
        return if $char eq $bar128Cc;

        if ($char =~ /^([0-9][0-9])$/) {
            $index = $1;
        }
        else {
            $index = index($code128c, $char);
        }
    }

    return ($bar128[$index], $index);
}

sub encode_128_char {
    my ($code, $char) = @_;
    my ($b) = encode_128_char_idx($code, $char);
    return $b;
}

sub encode_128_string {
    my ($code, $string) = @_;
    my ($bar, $index, @bars, @checksum);
    my @characters = split(//, $string);

    my $character;
    while (defined($character = shift @characters)) {
        if ($character =~ /[\xf1-\xf4]/) {
            # CODE-C doesn't have FNC2-FNC4
            if ($character =~ /[\xf2-\xf4]/ and $code eq 'c') {
                ($bar, $index) = encode_128_char_idx($code, "\xCB");
                push @bars, $bar;
                push @checksum, $index;
                $code = 'b';
            }

            ($bar, $index) = encode_128_char_idx($code, $character);
        }
        elsif ($character =~ /[\xCA-\xCC]/) {
            ($bar, $index) = encode_128_char_idx($code, $character);
            $code = ($character eq "\xCA" ? 'a' :
                     $character eq "\xCB" ? 'b' : 'c');
        }
        else {
            if ($code ne 'c') {
                # SHIFT: Switch codes for the following character only
                if ($character eq $bar128sh) {
                    ($bar, $index) = encode_128_char_idx($code, $character);
                    push @bars, $bar;
                    push @checksum, $index;
                    $character = shift(@characters);
                    ($bar, $index) = encode_128_char_idx($code eq 'a' ? 'b' : 'a', $character);
                }
                else {
                    ($bar, $index) = encode_128_char_idx($code, $character);
                }
            }
            else {
                $character .= shift(@characters) if $character =~ /\d/ and scalar @characters;
                if ($character =~ /^[^\d]*$/ or $character =~ /^\d[^\d]*$/) {
                    ($bar, $index) = encode_128_char_idx($code, "\xCB");
                    push @bars, $bar;
                    push @checksum, $index;
                    $code = 'b';
                }
                if ($character =~ /^\d[^\d]*$/) {
                    unshift(@characters, substr($character, 1, 1)) if length($character) > 1;
                    $character = substr($character, 0, 1);
                }
                ($bar, $index) = encode_128_char_idx($code, $character);
            }
        }
        $character = '' if $character =~ /[^\x20-\x7e]/;
        push @bars, [$bar, $character];
        push @checksum, $index;
    }
    return ([@bars], @checksum);
}

sub encode_128 {
    my ($self, $code, $string) = @_;
    my @bars;
    my $checksum_value;

    # Default to Code C if all characters are digits (and there are at
    # least two of them).  Otherwise, default to Code B.
    $code ||= $string =~ /^\d{2,}$/ ? 'c' : 'b';

    # Allow the character set to be passed as a capital letter
    # (consistent with the specification).
    $code = lc($code) if $code =~ /^[A-C]$/;

    # Ensure a valid character set has been chosen.
    die "Character set must be A, B, or C (not '$code')" unless $code =~ /^[a-c]$/;

    if ($code eq 'a') {
        push @bars, encode_128_char($code, $bar128Sa);
        $checksum_value = 103;
    }
    elsif ($code eq 'b') {
        push @bars, encode_128_char($code, $bar128Sb);
        $checksum_value = 104;
    }
    elsif ($code eq 'c') {
        push @bars, encode_128_char($code, $bar128Sc);
        $checksum_value = 105;
    }
    my ($bar, @checksum_values) = encode_128_string($code, $string);

    push @bars, @{$bar};

    # Calculate the checksum value
    foreach my $i (1 .. scalar @checksum_values) {
        $checksum_value += $i * $checksum_values[$i - 1];
    }
    $checksum_value %= 103;
    push @bars, $bar128[$checksum_value];
    push @bars, encode_128_char($code, $bar128St);

    return @bars;
}

sub encode_ean128 {
    my ($self, $string) = @_;
    $string =~ s/[^a-zA-Z\d]+//g;
    $string =~ s/(\d+)([a-zA-Z]+)/$1\xcb$2/g;
    $string =~ s/([a-zA-Z]+)(\d+)/$1\xcc$2/g;

    return $self->encode_128('c', "\xf1$string");
}

1;
