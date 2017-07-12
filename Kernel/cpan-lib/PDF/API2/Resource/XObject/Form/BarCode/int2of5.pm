package PDF::API2::Resource::XObject::Form::BarCode::int2of5;

use base 'PDF::API2::Resource::XObject::Form::BarCode';

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

# Interleaved 2 of 5 Barcodes

# Pairs of digits are encoded; the first digit is represented by five
# bars, and the second digit is represented by five spaces interleaved
# with the bars.

sub new {
    my ($class, $pdf, %options) = @_;
    my $self = $class->SUPER::new($pdf,%options);

    my @bars = $self->encode($options{'-code'});

    $self->drawbar([@bars], $options{'caption'});

    return $self;
}

my @bar25interleaved = qw(11221 21112 12112 22111 11212 21211 12211 11122 21121 12121);

sub encode {
    my ($self, $string) = @_;

    # Remove any character that isn't a digit
    $string =~ s/[^0-9]//g;

    # Prepend a 0 if there is an odd number of digits
    $string = '0' . $string if length($string) % 2;

    # Start Code
    my @bars = ('aaaa');

    # Encode pairs of digits
    my ($c1, $c2, $s1, $s2, $pair);
    while (length($string)) {
        ($c1, $c2, $string) = split //, $string, 3;

        $s1 = $bar25interleaved[$c1];
        $s2 = $bar25interleaved[$c2];
        $pair = '';
        foreach my $i (0 .. 4) {
            $pair .= substr($s1, $i, 1);
            $pair .= substr($s2, $i, 1);
        }
        push @bars, [$pair, ($c1 . $c2)];
    }

    # Stop Code
    push @bars, 'baaa';

    return @bars;
}

1;
