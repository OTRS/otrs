package PDF::API2::Resource::XObject::Form::BarCode::codabar;

our $VERSION = '2.023'; # VERSION

use base 'PDF::API2::Resource::XObject::Form::BarCode';

use strict;
use warnings;

sub new {
    my ($class, $pdf, %options) = @_;
    my $self = $class->SUPER::new($pdf, %options);

    my @bars = $self->encode($options{'-code'});

    $self->drawbar([@bars]);

    return $self;
}

my $codabar = q|0123456789-$:/.+ABCD|;

my @barcodabar = qw(
    11111221 11112211 11121121 22111111 11211211
    21111211 12111121 12112111 12211111 21121111
    11122111 11221111 21112121 21211121 21212111
    11212121 aabbabaa ababaaba ababaaba aaabbbaa
);

sub encode_char {
    my $self = shift();
    my $char = uc shift();
    return $barcodabar[index($codabar, $char)];
}

1;
