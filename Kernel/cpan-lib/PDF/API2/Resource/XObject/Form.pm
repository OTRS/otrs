package PDF::API2::Resource::XObject::Form;

use base 'PDF::API2::Resource::XObject';

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

use PDF::API2::Basic::PDF::Utils;

=head1 NAME

PDF::API2::Resource::XObject::Form - Base class for external form objects

=head1 METHODS

=over

=item $form = PDF::API2::Resource::XObject::Form->new($pdf)

Creates a form resource.

=cut

sub new {
    my ($class, $pdf, $name) = @_;
    my $self = $class->SUPER::new($pdf, $name);

    $self->subtype('Form');
    $self->{'FormType'} = PDFNum(1);

    return $self;
}

=item ($llx, $lly, $urx, $ury) = $form->bbox($llx, $lly, $urx, $ury)

Get or set the coordinates of the form object's bounding box

=cut

sub bbox {
    my $self = shift();

    if (scalar @_) {
        $self->{'BBox'} = PDFArray(map { PDFNum($_) } @_);
    }

    return map { $_->val() } $self->{'BBox'}->elements();
}

=item $resource = $form->resource($type, $key)

=item $form->resource($type, $key, $object, $force)

Get or add a resource required by the form's contents, such as a Font, XObject, ColorSpace, etc.

By default, an existing C<$key> will not be overwritten.  Set C<$force> to override this behavior.

=cut

sub resource {
    my ($self, $type, $key, $object, $force) = @_;
    # we are a self-contained content stream.

    $self->{'Resources'} ||= PDFDict();

    my $dict = $self->{'Resources'};
    $dict->realise() if ref($dict) =~ /Objind$/;

    $dict->{$type} ||= PDFDict();
    $dict->{$type}->realise() if ref($dict->{$type}) =~ /Objind$/;

    unless (defined $object) {
        return $dict->{$type}->{$key} || undef;
    }

    if ($force) {
        $dict->{$type}->{$key} = $object;
    }
    else {
        $dict->{$type}->{$key} ||= $object;
    }

    return $dict;
}

=back

=cut

1;
