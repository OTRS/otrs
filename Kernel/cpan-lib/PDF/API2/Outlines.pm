package PDF::API2::Outlines;

our $VERSION = '2.023'; # VERSION

use warnings;
use strict;

use base 'PDF::API2::Outline';

use PDF::API2::Basic::PDF::Utils;

sub new {
    my ($class, $api) = @_;
    my $self = $class->SUPER::new($api);
    $self->{'Type'} = PDFName('Outlines');

    return $self;
}

1;
