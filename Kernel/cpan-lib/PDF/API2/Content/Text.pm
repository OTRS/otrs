package PDF::API2::Content::Text;

our $VERSION = '2.023'; # VERSION

use warnings;
use strict;

use base 'PDF::API2::Content';

sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new(@_);
    $self->textstart();
    return $self;
}

1;
