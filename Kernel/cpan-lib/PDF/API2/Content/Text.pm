package PDF::API2::Content::Text;

use base 'PDF::API2::Content';

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new(@_);
    $self->textstart();
    return $self;
}

1;
