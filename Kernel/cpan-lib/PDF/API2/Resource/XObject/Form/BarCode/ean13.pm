package PDF::API2::Resource::XObject::Form::BarCode::ean13;

use base 'PDF::API2::Resource::XObject::Form::BarCode';

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

sub new {
    my ($class, $pdf, %options) = @_;
    my $self = $class->SUPER::new($pdf, %options);

    my @bars = $self->encode($options{'-code'});

    $self->drawbar([@bars], $options{'caption'});

    return $self;
}

my @ean_code_odd  = qw(3211 2221 2122 1411 1132 1231 1114 1312 1213 3112);
my @ean_code_even = qw(1123 1222 2212 1141 2311 1321 4111 2131 3121 2113);
my @parity = qw(OOOOOO OOEOEE OOEEOE OOEEEO OEOOEE OEEOOE OEEEOO OEOEOE OEOEEO OEEOEO);

sub encode {
    my ($self, $string) = @_;
    my @digits = split //, $string;

    # The first digit determines the even/odd pattern of the next six
    # digits, and is printed to the left of the barcode
    my $first = shift @digits;
    my @bars = (['07', $first]);

    # Start Guard
    push @bars, 'a1a';

    # Digits 2-7
    foreach my $i (0 .. 5) {
        my $digit = shift @digits;
        if (substr($parity[$first], $i, 1) eq 'O') {
            push @bars, [$ean_code_odd[$digit], $digit];
        }
        else {
            push @bars, [$ean_code_even[$digit], $digit];
        }
    }

    # Center Guard
    push @bars, '1a1a1';

    # Digits 8-13
    for (0..5) {
        my $digit = shift @digits;
        push @bars, [$ean_code_odd[$digit], $digit];
    }

    # Right Guard
    push @bars, 'a1a';

    return @bars;
}

sub calculate_check_digit {
    my ($self, $string) = @_;
    my @digits = split //, $string;
    my $weight = 1;
    my $checksum = 0;
    foreach my $i (0..11) {
        $checksum += $digits[$i] * $weight;
        $weight = $weight == 1 ? 3 : 1;
    }

    $checksum = $checksum % 10;
    return 0 unless $checksum;
    return 10 - $checksum;
}

1;
