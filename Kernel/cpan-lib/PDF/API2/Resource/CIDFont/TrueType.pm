package PDF::API2::Resource::CIDFont::TrueType;

use base 'PDF::API2::Resource::CIDFont';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Resource::CIDFont::TrueType::FontFile;
use PDF::API2::Util;

=head1 NAME

PDF::API2::Resource::CIDFont::TrueType - TrueType font support

=head1 METHODS

=over

=item $font = PDF::API2::Resource::CIDFont::TrueType->new $pdf, $file, %options

Returns a font object.

Defined Options:

    -encode ... specify fonts encoding for non-utf8 text.

    -nosubset ... disables subsetting.

=cut

sub new {
    my ($class,$pdf,$file,@opts) = @_;
    my %opts=();
    %opts=@opts if((scalar @opts)%2 == 0);
    $opts{-encode}||='latin1';
    my ($ff,$data)=PDF::API2::Resource::CIDFont::TrueType::FontFile->new($pdf,$file,@opts);

    $class = ref $class if ref $class;
    my $self=$class->SUPER::new($pdf,$data->{apiname}.pdfkey().'~'.time());
    $pdf->new_obj($self) if(defined($pdf) && !$self->is_obj($pdf));

    $self->{' data'}=$data;

    my $des=$self->descrByData;

    $self->{'BaseFont'} = PDFName($self->fontname);

    my $de=$self->{' de'};

    $de->{'FontDescriptor'} = $des;
    $de->{'Subtype'} = PDFName($self->iscff ? 'CIDFontType0' : 'CIDFontType2');
    ## $de->{'BaseFont'} = PDFName(pdfkey().'+'.($self->fontname).'~'.time());
    $de->{'BaseFont'} = PDFName($self->fontname);
    $de->{'DW'} = PDFNum($self->missingwidth);
    if($opts{-noembed} != 1)
    {
    	$des->{$self->data->{iscff} ? 'FontFile3' : 'FontFile2'}=$ff;
    }
    unless($self->issymbol) {
        $self->encodeByName($opts{-encode});
        $self->data->{encode}=$opts{-encode};
        $self->data->{decode}='ident';
    }

    if($opts{-nosubset}) {
        $self->data->{nosubset}=1;
    }


    $self->{' ff'} = $ff;
    $pdf->new_obj($ff);

    $self->{-dokern}=1 if($opts{-dokern});

    return($self);
}


sub fontfile { return( $_[0]->{' ff'} ); }
sub fontobj { return( $_[0]->data->{obj} ); }

sub wxByCId
{
    my $self=shift @_;
    my $g=shift @_;
    my $t = $self->fontobj->{'hmtx'}->read->{'advance'}[$g];
    my $w;

    if(defined $t)
    {
        $w = int($t*1000/$self->data->{upem});
    }
    else
    {
        $w = $self->missingwidth;
    }

    return($w);
}

sub haveKernPairs
{
    my $self = shift @_;
    return($self->fontfile->haveKernPairs(@_));
}

sub kernPairCid
{
    my $self = shift @_;
    return($self->fontfile->kernPairCid(@_));
}

sub subsetByCId
{
    my $self = shift @_;
    return if($self->iscff);
    my $g = shift @_;
    $self->fontfile->subsetByCId($g);
}
sub subvec
{
    my $self = shift @_;
    return(1) if($self->iscff);
    my $g = shift @_;
    $self->fontfile->subvec($g);
}

sub glyphNum { return ( $_[0]->fontfile->glyphNum ); }

sub outobjdeep
{
    my ($self, $fh, $pdf, %opts) = @_;

    my $notdefbefore=1;

    my $wx=PDFArray();
    $self->{' de'}->{'W'} = $wx;
    my $ml;

    foreach my $w (0..(scalar @{$self->data->{g2u}} - 1 ))
    {
        if($self->subvec($w) && $notdefbefore==1)
        {
            $notdefbefore=0;
            $ml=PDFArray();
            $wx->add_elements(PDFNum($w),$ml);
        #    $ml->add_elements(PDFNum($self->data->{wx}->[$w]));
            $ml->add_elements(PDFNum($self->wxByCId($w)));
        }
        elsif($self->subvec($w) && $notdefbefore==0)
        {
            $notdefbefore=0;
        #    $ml->add_elements(PDFNum($self->data->{wx}->[$w]));
            $ml->add_elements(PDFNum($self->wxByCId($w)));
        }
        else
        {
            $notdefbefore=1;
        }
        # optimization for cjk
        #if($self->subvec($w) && $notdefbefore==1 && $self->data->{wx}->[$w]!=$self->missingwidth) {
        #    $notdefbefore=0;
        #    $ml=PDFArray();
        #    $wx->add_elements(PDFNum($w),$ml);
        #    $ml->add_elements(PDFNum($self->data->{wx}->[$w]));
        #} elsif($self->subvec($w) && $notdefbefore==0 && $self->data->{wx}->[$w]!=$self->missingwidth) {
        #    $notdefbefore=0;
        #    $ml->add_elements(PDFNum($self->data->{wx}->[$w]));
        #} else {
        #    $notdefbefore=1;
        #}
    }

    $self->SUPER::outobjdeep($fh, $pdf, %opts);
}

=back

=cut

1;
