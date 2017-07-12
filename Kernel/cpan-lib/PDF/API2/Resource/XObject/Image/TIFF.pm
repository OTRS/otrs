package PDF::API2::Resource::XObject::Image::TIFF;

use base 'PDF::API2::Resource::XObject::Image';

use strict;
use warnings;

no warnings 'uninitialized';

our $VERSION = '2.033'; # VERSION

use Compress::Zlib;

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Resource::XObject::Image::TIFF::File;
use PDF::API2::Util;
use Scalar::Util qw(weaken);

=head1 NAME

PDF::API2::Resource::XObject::Image::TIFF - TIFF image support

=head1 METHODS

=over

=item  $res = PDF::API2::Resource::XObject::Image::TIFF->new $pdf, $file [, $name]

Returns a tiff-image object.

=cut

sub new {
    my ($class, $pdf, $file, $name) = @_;
    my $self;

    my $tif = PDF::API2::Resource::XObject::Image::TIFF::File->new($file);

    # in case of problematic things
    #  proxy to other modules

    $class = ref($class) if ref($class);

    $self = $class->SUPER::new($pdf, $name || 'Ix' . pdfkey());
    $pdf->new_obj($self) unless $self->is_obj($pdf);

    $self->{' apipdf'} = $pdf;
    weaken $self->{' apipdf'};

    $self->read_tiff($pdf, $tif);

    $tif->close();

    return $self;
}

sub deLZW {
    my ($ibits, $stream) = @_;
    my $bits = $ibits;
    my $resetcode = 1 << ($ibits - 1);
    my $endcode = $resetcode + 1;
    my $nextcode = $endcode + 1;
    my $ptr = 0;
    $stream = unpack('B*', $stream);
    my $maxptr = length($stream);
    my $tag;
    my $out = '';
    my $outptr = 0;

    # print STDERR "reset=$resetcode\nend=$endcode\nmax=$maxptr\n";

    my @d = map { chr($_) } (0 .. $resetcode - 1);

    while (($ptr + $bits) <= $maxptr) {
        $tag=0;
        foreach my $off (reverse 1 .. $bits) {
            $tag <<= 1;
            $tag |= substr($stream, $ptr + $bits - $off, 1);
        }
        # print STDERR "ptr=$ptr,tag=$tag,bits=$bits,next=$nextcode\n";
        # print STDERR "tag to large\n" if($tag>$nextcode);
        $ptr += $bits;
        if ($tag == $resetcode) {
            $bits = $ibits;
            $nextcode = $endcode + 1;
            next;
        }
        elsif ($tag == $endcode) {
            last;
        }
        elsif ($tag < $resetcode) {
            $d[$nextcode] = $d[$tag];
            $out .= $d[$nextcode];
            $nextcode++;
        }
        elsif ($tag > $endcode) {
            $d[$nextcode] = $d[$tag];
            $d[$nextcode] .= substr($d[$tag + 1], 0, 1);
            $out .= $d[$nextcode];
            $nextcode++;
        }
        $bits++ if $nextcode == (1 << $bits);
    }
    return $out;
}

sub handle_generic {
    my ($self, $pdf, $tif) = @_;

    if ($tif->{'filter'}) {
        # should we die here?
        # die "unknown tiff-compression";
        $self->filters($tif->{filter});
        $self->{' nofilt'} = 1;
    }
    else {
        $self->filters('FlateDecode');
    }

    if (ref($tif->{'imageOffset'})) {
        $self->{' stream'} = '';
        my $d = scalar @{$tif->{'imageOffset'}};
        foreach (1..$d) {
            my $buf;
            $tif->{'fh'}->seek(shift(@{$tif->{'imageOffset'}}), 0);
            $tif->{'fh'}->read($buf, shift(@{$tif->{'imageLength'}}));
            $self->{' stream'} .= $buf;
        }
    }
    else {
        $tif->{'fh'}->seek($tif->{'imageOffset'}, 0);
        $tif->{'fh'}->read($self->{' stream'}, $tif->{'imageLength'});
    }

    return $self;
}

sub handle_flate {
    my ($self, $pdf, $tif) = @_;
    $self->filters('FlateDecode');

    if (ref($tif->{'imageOffset'})) {
        $self->{' stream'} = '';
        my $d = scalar @{$tif->{'imageOffset'}};
        foreach (1 .. $d) {
            my $buf;
            $tif->{'fh'}->seek(shift(@{$tif->{'imageOffset'}}),0);
            $tif->{'fh'}->read($buf, shift(@{$tif->{'imageLength'}}));
            $buf=uncompress($buf);
            $self->{' stream'} .= $buf;
        }
    }
    else {
        $tif->{'fh'}->seek($tif->{'imageOffset'}, 0);
        $tif->{'fh'}->read($self->{' stream'}, $tif->{'imageLength'});
        $self->{' stream'} = uncompress($self->{' stream'});
    }

    return $self;
}

sub handle_lzw {
    my ($self, $pdf, $tif) = @_;
    $self->filters('FlateDecode');
    my $imageWidth = $tif->{'imageWidth'};
    my $mod = $imageWidth % 8;
    if ($mod > 0) {
        $imageWidth += 8 - $mod;
    }
    my $max_raw_strip = $imageWidth * $tif->{'bitsPerSample'} * $tif->{'RowsPerStrip'} / 8;

    if (ref($tif->{'imageOffset'})) {
        $self->{' stream'}='';
        my $d = scalar @{$tif->{'imageOffset'}};
        foreach (1 .. $d) {
            my $buf;
            $tif->{'fh'}->seek(shift(@{$tif->{imageOffset}}), 0);
            $tif->{'fh'}->read($buf, shift(@{$tif->{'imageLength'}}));
            $buf = deLZW(9, $buf);
            if (length($buf) > $max_raw_strip) {
                $buf = substr($buf, 0, $max_raw_strip);
            }
            $self->{' stream'} .= $buf;
        }
    }
    else {
        $tif->{'fh'}->seek($tif->{'imageOffset'}, 0);
        $tif->{'fh'}->read($self->{' stream'}, $tif->{'imageLength'});
        $self->{' stream'} = deLZW(9, $self->{' stream'});
    }

    return $self;
}

sub handle_ccitt {
    my ($self, $pdf, $tif) = @_;

    $self->{' nofilt'} = 1;
    $self->{'Filter'} = PDFName('CCITTFaxDecode');
    $self->{'DecodeParms'} = PDFDict();
    $self->{'DecodeParms'}->{'K'} = (($tif->{'ccitt'} == 4 || ($tif->{'g3Options'} & 0x1)) ? PDFNum(-1) : PDFNum(0));
    $self->{'DecodeParms'}->{'Columns'} = PDFNum($tif->{'imageWidth'});
    $self->{'DecodeParms'}->{'Rows'} = PDFNum($tif->{'imageHeight'});
    $self->{'DecodeParms'}->{'Blackls1'} = PDFBool($tif->{'whiteIsZero'} == 1 ? 1 : 0);
    if (defined($tif->{'g3Options'}) && ($tif->{'g3Options'} & 0x4)) {
        $self->{'DecodeParms'}->{'EndOfLine'} = PDFBool(1);
        $self->{'DecodeParms'}->{'EncodedByteAlign'} = PDFBool(1);
    }
    # $self->{'DecodeParms'} = PDFArray($self->{'DecodeParms'});
    $self->{'DecodeParms'}->{'DamagedRowsBeforeError'} = PDFNum(100);

    if (ref($tif->{'imageOffset'})) {
        die "chunked ccitt g4 tif not supported.";
    }
    else {
        $tif->{'fh'}->seek($tif->{'imageOffset'}, 0);
        $tif->{'fh'}->read($self->{' stream'}, $tif->{'imageLength'});
    }

    return $self;
}

sub read_tiff {
    my ($self, $pdf, $tif) = @_;

    $self->width($tif->{'imageWidth'});
    $self->height($tif->{'imageHeight'});
    if ($tif->{'colorSpace'} eq 'Indexed') {
        my $dict = PDFDict();
        $pdf->new_obj($dict);
        $self->colorspace(PDFArray(PDFName($tif->{'colorSpace'}), PDFName('DeviceRGB'), PDFNum(255), $dict));
        $dict->{'Filter'} = PDFArray(PDFName('FlateDecode'));
        $tif->{'fh'}->seek($tif->{'colorMapOffset'}, 0);
        my $colormap;
        my $straight;
        $tif->{'fh'}->read($colormap, $tif->{'colorMapLength'});
        $dict->{' stream'} = '';
        $straight .= pack('C', ($_ / 256)) for unpack($tif->{'short'} . '*', $colormap);
        foreach my $c (0 .. (($tif->{'colorMapSamples'} / 3) - 1)) {
            $dict->{' stream'} .= substr($straight, $c, 1);
            $dict->{' stream'} .= substr($straight, $c + ($tif->{'colorMapSamples'} / 3), 1);
            $dict->{' stream'} .= substr($straight, $c + ($tif->{'colorMapSamples'} / 3) * 2, 1);
        }
    }
    else {
        $self->colorspace($tif->{'colorSpace'});
    }

    $self->{'Interpolate'} = PDFBool(1);
    $self->bpc($tif->{'bitsPerSample'});

    if ($tif->{'whiteIsZero'} == 1 && $tif->{'filter'} ne 'CCITTFaxDecode') {
        $self->{'Decode'} = PDFArray(PDFNum(1), PDFNum(0));
    }

    # check filters and handle seperately
    if (defined $tif->{'filter'} and $tif->{'filter'} eq 'CCITTFaxDecode') {
        $self->handle_ccitt($pdf, $tif);
    }
    elsif (defined $tif->{'filter'} and $tif->{'filter'} eq 'LZWDecode') {
        $self->handle_lzw($pdf, $tif);
    }
    elsif (defined $tif->{'filter'} and $tif->{filter} eq 'FlateDecode') {
        $self->handle_flate($pdf, $tif);
    }
    else {
        $self->handle_generic($pdf, $tif);
    }

    if ($tif->{'fillOrder'} == 2) {
        my @bl = ();
        foreach my $n (0 .. 255) {
            my $b = $n;
            my $f = 0;
            foreach (0 .. 7) {
                my $bit = 0;
                if ($b & 0x1) {
                    $bit = 1;
                }
                $b >>= 1;
                $f <<= 1;
                $f |= $bit;
            }
            $bl[$n] = $f;
        }
        my $l = length($self->{' stream'}) - 1;
        foreach my $n (0 .. $l) {
            vec($self->{' stream'}, $n, 8) = $bl[vec($self->{' stream'}, $n, 8)];
        }
    }
    $self->{' tiff'} = $tif;

    return $self;
}

=item $value = $tif->tiffTag $tag

returns the value of the internal tiff-tag.

B<Useful Tags:>

    imageDescription, imageId (strings)
    xRes, yRes (dpi; pixel/cm if resUnit==3)
    resUnit

=cut

sub tiffTag {
    my ($self, $tag) = @_;
    return $self->{' tiff'}->{$tag};
}

=back

=cut

1;
