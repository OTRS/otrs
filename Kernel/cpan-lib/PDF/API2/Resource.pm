package PDF::API2::Resource;

our $VERSION = '2.023'; # VERSION

use base 'PDF::API2::Basic::PDF::Dict';

use strict;
use warnings;

use PDF::API2::Util qw(pdfkey);
use PDF::API2::Basic::PDF::Utils; # PDFName

=head1 NAME

PDF::API2::Resource - Base class for PDF resources

=head1 METHODS

=over

=item $resource = PDF::API2::Resource->new($pdf, $name)

Returns a resource object.

=cut

sub new {
    my ($class, $pdf, $name) = @_;
    $class = ref($class) if ref($class);

    my $self = $class->SUPER::new();

    # Instead of having a separate new_api call, check the type here.
    if ($pdf->isa('PDF::API2')) {
        $self->{' api'} = $pdf;
        $pdf = $pdf->{'pdf'};
    }

    $pdf->new_obj($self) unless $self->is_obj($pdf);

    $self->name($name or pdfkey());

    $self->{' apipdf'} = $pdf;

    return $self;
}

# Deprecated (rolled into new)
sub new_api { my $self = shift(); return $self->new(@_); }

=item $name = $resource->name()
=item $resource->name($name)

Get or set the name of the resource.

=cut

sub name {
    my $self = shift @_;
    if (scalar @_ and defined $_[0]) {
        $self->{'Name'} = PDFName($_[0]);
    }
    return $self->{'Name'}->val();
}

sub outobjdeep {
    my ($self, $fh, $pdf, %options) = @_;

    delete $self->{' api'};
    delete $self->{' apipdf'};
    $self->SUPER::outobjdeep($fh, $pdf, %options);
}

=back

=cut

1;
