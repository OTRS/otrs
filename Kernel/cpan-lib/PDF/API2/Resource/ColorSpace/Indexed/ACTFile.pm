package PDF::API2::Resource::ColorSpace::Indexed::ACTFile;

use base 'PDF::API2::Resource::ColorSpace::Indexed';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;
use Scalar::Util qw(weaken);

=head1 NAME

PDF::API2::Resource::ColorSpace::Indexed::ACTFile - Adobe Color Table support

=head1 METHODS

=over

=item $cs = PDF::API2::Resource::ColorSpace::Indexed::ACTFile->new $pdf, $actfile

Returns a new colorspace object created from an adobe color table file (ACT/8BCT).
See
Adobe Photoshop(R) 6.0 --
File Formats Specification Version 6.0 Release 2,
November 2000
for details.

=cut

sub new {
    my ($class,$pdf,$file)=@_;
    die "could not find act-file '$file'." unless(-f $file);
    $class = ref $class if ref $class;
    my $self=$class->SUPER::new($pdf,pdfkey());
    $pdf->new_obj($self) unless($self->is_obj($pdf));
    $self->{' apipdf'}=$pdf;
    weaken $self->{' apipdf'};
    my $csd=PDFDict();
    $pdf->new_obj($csd);
    $csd->{Filter}=PDFArray(PDFName('FlateDecode'));

    $csd->{WhitePoint}=PDFArray(map {PDFNum($_)} (0.95049, 1, 1.08897));
    $csd->{BlackPoint}=PDFArray(map {PDFNum($_)} (0, 0, 0));
    $csd->{Gamma}=PDFArray(map {PDFNum($_)} (2.22218, 2.22218, 2.22218));

    my $fh;
    open($fh, "<", $file) or die "$!: $file";
    binmode($fh,':raw');
    read($fh,$csd->{' stream'},768);
    close($fh);

    $csd->{' stream'}.="\x00" x 768;
    $csd->{' stream'}=substr($csd->{' stream'},0,768);

    $self->add_elements(PDFName('DeviceRGB'),PDFNum(255),$csd);
    $self->{' csd'}=$csd;

    return($self);
}

=back

=cut

1;
