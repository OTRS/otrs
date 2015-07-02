package PDF::API2::Resource::XObject;

our $VERSION = '2.023'; # VERSION

use base 'PDF::API2::Resource';

use strict;
use warnings;

use PDF::API2::Basic::PDF::Utils;

=head1 NAME

PDF::API2::Resource::XObject - Base class for external objects

=head1 METHODS

=over

=item $xobject = PDF::API2::Resource::XObject->new($pdf, $name)

Creates an XObject resource.

=cut

sub new {
    my ($class, $pdf, $name) = @_;
    my $self = $class->SUPER::new($pdf, $name);

    $self->type('XObject');

    return $self;
}

# Deprecated (rolled into new)
sub new_api { my $self = shift(); return $self->new(@_); }

=item $type = $xobject->subtype($type)

Get or set the Subtype of the XObject resource.

=cut

sub subtype {
    my $self = shift();
    if (scalar @_) {
        $self->{'Subtype'} = PDFName(shift());
    }
    return $self->{'Subtype'}->val();
}

=back

=cut

1;
