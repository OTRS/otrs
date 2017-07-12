package PDF::API2::Resource;

use base 'PDF::API2::Basic::PDF::Dict';

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

use PDF::API2::Util qw(pdfkey);
use PDF::API2::Basic::PDF::Utils; # PDFName

use Scalar::Util qw(weaken);

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

    $pdf->new_obj($self) unless $self->is_obj($pdf);

    $self->name($name or pdfkey());

    $self->{' apipdf'} = $pdf;
    weaken $self->{' apipdf'};

    return $self;
}

# Deprecated (warning added in 2.031)
sub new_api {
    my ($class, $api2, @options) = @_;
    warnings::warnif('deprecated', q{Call to deprecated method "new_api($api2, ...)".  Replace with "new($api2->{'pdf'}, ...)"});

    my $resource = $class->new($api2->{'pdf'}, @options);
    return $resource;
}

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
