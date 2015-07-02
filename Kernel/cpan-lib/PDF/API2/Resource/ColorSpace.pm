package PDF::API2::Resource::ColorSpace;

our $VERSION = '2.023'; # VERSION

use base 'PDF::API2::Basic::PDF::Array';

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;

no warnings qw[ deprecated recursion uninitialized ];

=head1 NAME

PDF::API2::Resource::ColorSpace - Base class for PDF color spaces

=head1 METHODS

=over

=item $cs = PDF::API2::Resource::ColorSpace->new $pdf, $key, %parameters

Returns a new colorspace object. base class for all colorspaces.

=cut

sub new {
    my ($class,$pdf,$key,%opts)=@_;

    $class = ref $class if ref $class;
    $self=$class->SUPER::new();
    $pdf->new_obj($self) unless($self->is_obj($pdf));
    $self->name($key || pdfkey());
    $self->{' apipdf'}=$pdf;

    return($self);
}

=item $cs = PDF::API2::Resource::ColorSpace->new_api $api, $name

Returns a color-space object. This method is different from 'new' that
it needs an PDF::API2-object rather than a Text::PDF::File-object.

=cut

sub new_api {
    my ($class,$api,@opts)=@_;

    my $obj=$class->new($api->{pdf},@opts);
    $self->{' api'}=$api;

    return($obj);
}

=item $name = $res->name $name

Returns or sets the Name of the resource.

=cut

sub name {
    my $self=shift @_;
    if(scalar @_ >0 && defined($_[0])) {
        $self->{' name'}=$_[0];
    }
    return($self->{' name'});
}
sub type {
    my $self=shift @_;
    if(scalar @_ >0 && defined($_[0])) {
        $self->{' type'}=$_[0];
    }
    return($self->{' type'});
}

=item @param = $cs->param @param

Returns properly formatted color-parameters based on the colorspace.

=cut

sub param {
    my $self=shift @_;
    return(@_);
}

sub outobjdeep {
    my ($self, @opts) = @_;
    foreach my $k (qw/ api apipdf /) {
        $self->{" $k"}=undef;
        delete($self->{" $k"});
    }
    $self->SUPER::outobjdeep(@opts);
}

=back

=cut

1;
