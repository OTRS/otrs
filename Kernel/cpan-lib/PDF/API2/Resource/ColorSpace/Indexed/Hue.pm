package PDF::API2::Resource::ColorSpace::Indexed::Hue;

use base 'PDF::API2::Resource::ColorSpace::Indexed';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;
use Scalar::Util qw(weaken);

sub new {
    my ($class,$pdf)=@_;

    $class = ref $class if ref $class;
    my $self=$class->SUPER::new($pdf,pdfkey());
    $pdf->new_obj($self) unless($self->is_obj($pdf));
    $self->{' apipdf'}=$pdf;
    weaken $self->{' apipdf'};
    my $csd=PDFDict();
    $pdf->new_obj($csd);
    $csd->{Filter}=PDFArray(PDFName('FlateDecode'));

    ## $csd->{WhitePoint}=PDFArray(map { PDFNum($_) } (0.95049, 1, 1.08897));
    ## $csd->{BlackPoint}=PDFArray(map { PDFNum($_) } (0, 0, 0));
    ## $csd->{Gamma}=PDFArray(map { PDFNum($_) } (2.22218, 2.22218, 2.22218));

    $csd->{' stream'}='';

    my %cc=();

    foreach my $s (4,3,2,1) {
        foreach my $v (4,3) {
            foreach my $r (0..31) {
                $csd->{' stream'}.=pack('CCC',map { $_*255 } namecolor('!'.sprintf('%02X',$r*255/31).sprintf('%02X',$s*255/4).sprintf('%02X',$v*255/4)));
            }
        }
    }

    $csd->{' stream'}.="\x00" x 768;
    $csd->{' stream'}=substr($csd->{' stream'},0,768);

    $self->add_elements(PDFName('DeviceRGB'),PDFNum(255),$csd);
    $self->{' csd'}=$csd;

    return($self);
}

1;
