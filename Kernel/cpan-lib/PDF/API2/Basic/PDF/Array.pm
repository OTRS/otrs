#=======================================================================
#
#   THIS IS A REUSED PERL MODULE, FOR PROPER LICENCING TERMS SEE BELOW:
#
#   Copyright Martin Hosken <Martin_Hosken@sil.org>
#
#   No warranty or expression of effectiveness, least of all regarding
#   anyone's safety, is implied in this software or documentation.
#
#   This specific module is licensed under the Perl Artistic License.
#
#=======================================================================
package PDF::API2::Basic::PDF::Array;

use base 'PDF::API2::Basic::PDF::Objind';

use strict;

our $VERSION = '2.033'; # VERSION

=head1 NAME

PDF::API2::Basic::PDF::Array - Corresponds to a PDF array. Inherits from L<PDF::Objind>

=head1 METHODS

=head2 PDF::Array->new($parent, @vals)

Creates an array with the given storage parent and an optional list of values to
initialise the array with.

=cut

sub new {
    my ($class, @vals) = @_;
    my $self = {};

    $self->{' val'} = [@vals];
    $self->{' realised'} = 1;
    bless $self, $class;
    return $self;
}

=head2 $a->outobjdeep($fh, $pdf)

Outputs an array as a PDF array to the given filehandle.

=cut

sub outobjdeep {
    my ($self, $fh, $pdf, %opts) = @_;

    $fh->print('[ ');
    foreach my $obj (@{$self->{' val'}}) {
        $obj->outobj($fh, $pdf);
        $fh->print(' ');
    }
    $fh->print(']');
}

=head2 $a->removeobj($elem)

Removes all occurrences of an element from an array.

=cut

sub removeobj {
    my ($self, $elem) = @_;

    $self->{' val'} = [grep($_ ne $elem, @{$self->{' val'}})];
}

=head2 $a->elementsof

Returns a list of all the elements in the array. Notice that this is
not the array itself but the elements in the array.

Also available as C<elements>.

=cut

sub elementsof {
    return wantarray ? @{$_[0]->{' val'}} : scalar @{$_[0]->{' val'}};
}

sub elements {
    my $self = shift();
    return @{$self->{' val'}};
}

=head2 $a->add_elements

Appends the given elements to the array. An element is only added if it
is defined.

=cut

sub add_elements {
    my $self = shift();

    foreach my $e (@_) {
        push @{$self->{' val'}}, $e if defined $e;
    }
    return $self;
}

=head2 $a->val

Returns the value of the array, this is a reference to the actual array
containing the elements.

=cut

sub val {
    return $_[0]->{' val'};
}

=head2 $a->copy($pdf)

Copies the array with deep-copy on elements which are not full PDF objects
with respect to a particular $pdf output context

=cut

sub copy {
    my ($self, $pdf) = @_;
    my $res = $self->SUPER::copy($pdf);

    $res->{' val'} = [];
    foreach my $e (@{$self->{' val'}}) {
        if (ref($e) and $e->can('is_obj') and not $e->is_obj($pdf)) {
            push(@{$res->{' val'}}, $e->copy($pdf));
        }
        else {
            push(@{$res->{' val'}}, $e);
        }
    }
    return $res;
}

1;
