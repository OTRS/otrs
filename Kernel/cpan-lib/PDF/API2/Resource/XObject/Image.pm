package PDF::API2::Resource::XObject::Image;

use base 'PDF::API2::Resource::XObject';

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

use PDF::API2::Basic::PDF::Utils;

=head1 NAME

PDF::API2::Resource::XObject::Image - Base class for external raster image objects

=head1 METHODS

=over

=item $image = PDF::API2::Resource::XObject::Image->new($pdf, $name)

Returns an image resource object.

=cut

sub new {
    my ($class, $pdf, $name) = @_;
    my $self = $class->SUPER::new($pdf, $name);

    $self->subtype('Image');

    return $self;
}

=item $width = $image->width($width)

Get or set the width value for the image object.

=cut

sub width {
    my $self = shift();
    $self->{'Width'} = PDFNum(shift()) if scalar @_;
    return $self->{'Width'}->val();
}

=item $height = $image->height($height)

Get or set the height value for the image object.

=cut

sub height {
    my $self = shift();
    $self->{'Height'} = PDFNum(shift()) if scalar @_;
    return $self->{'Height'}->val();
}

=item $image->smask($xobject)

Set the soft-mask image object.

=cut

sub smask {
    my $self = shift();
    $self->{'SMask'} = shift();

    return $self;
}

=item $image->mask(@color_range)

=item $image->mask($xobject)

Set the mask to an image mask XObject or an array containing a range
of colors to be applied as a color key mask.

=cut

sub mask {
    my $self = shift();
    if (ref($_[0])) {
        $self->{'Mask'} = shift();
    }
    else {
        $self->{'Mask'} = PDFArray(map { PDFNum($_) } @_);
    }

    return $self;
}

# Deprecated (rolled into mask)
sub imask { return mask(@_); }

=item $image->colorspace($name)

=item $image->colorspace($array)

Set the color space used by the image.  Depending on the color space,
this will either be just the name of the color space, or it will be an
array containing the color space and any required parameters.

If passing an array, parameters must already be encoded as PDF
objects.  The array itself may also be a PDF object.  If not, one will
be created.

=cut

sub colorspace {
    my ($self, @values) = @_;
    if (scalar @values == 1 and ref($values[0])) {
        $self->{'ColorSpace'} = $values[0];
    }
    elsif (scalar @values == 1) {
        $self->{'ColorSpace'} = PDFName($values[0]);
    }
    else {
        $self->{'ColorSpace'} = PDFArray(@values);
    }

    return $self;
}

=item $image->bits_per_component($integer)

Set the number of bits used to represent each color component.

=cut

sub bits_per_component {
    my $self = shift();
    $self->{'BitsPerComponent'} = PDFNum(shift());

    return $self;
}

# Deprecated (renamed)
sub bpc { return bits_per_component(@_); }

=back

=cut

1;
