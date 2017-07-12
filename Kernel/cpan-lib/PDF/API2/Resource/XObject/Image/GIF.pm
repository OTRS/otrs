package PDF::API2::Resource::XObject::Image::GIF;

use base 'PDF::API2::Resource::XObject::Image';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use IO::File;
use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;
use Scalar::Util qw(weaken);

# added from PDF::Create:
# PDF::Image::GIFImage - GIF image support
# Author: Michael Gross <mdgrosse@sbox.tugraz.at>
# modified for internal use. (c) 2004 fredo.
sub unInterlace {
    my $self = shift;
    my $data = $self->{' stream'};
    my $row;
    my @result;
    my $width = $self->width;
    my $height = $self->height;
    my $idx = 0;

    #Pass 1 - every 8th row, starting with row 0
    $row = 0;
    while ($row < $height) {
        $result[$row] = substr($data, $idx*$width, $width);
        $row+=8;
        $idx++;
    }

    #Pass 2 - every 8th row, starting with row 4
    $row = 4;
    while ($row < $height) {
        $result[$row] = substr($data, $idx*$width, $width);
        $row+=8;
        $idx++;
    }

    #Pass 3 - every 4th row, starting with row 2
    $row = 2;
    while ($row < $height) {
        $result[$row] = substr($data, $idx*$width, $width);
        $row+=4;
        $idx++;
    }

    #Pass 4 - every 2th row, starting with row 1
    $row = 1;
    while ($row < $height) {
        $result[$row] = substr($data, $idx*$width, $width);
        $row+=2;
        $idx++;
    }

    $self->{' stream'}=join('', @result);
}

sub deGIF {
    my ($ibits,$stream)=@_;
    my $bits=$ibits;
    my $resetcode=1<<($ibits-1);
    my $endcode=$resetcode+1;
    my $nextcode=$endcode+1;
    my $ptr=0;
    my $maxptr=8*length($stream);
    my $tag;
    my $out='';
    my $outptr=0;

 #   print STDERR "reset=$resetcode\nend=$endcode\nmax=$maxptr\n";

    my @d=map { chr($_) } (0..$resetcode-1);

    while(($ptr+$bits)<=$maxptr) {
        $tag=0;
        foreach my $off (reverse 0..$bits-1) {
            $tag<<=1;
            $tag|=vec($stream,$ptr+$off,1);
        }
    #    foreach my $off (0..$bits-1) {
    #        $tag<<=1;
    #        $tag|=vec($stream,$ptr+$off,1);
    #    }
    #    print STDERR "ptr=$ptr,tag=$tag,bits=$bits,next=$nextcode\n";
    #    print STDERR "tag to large\n" if($tag>$nextcode);
        $ptr+=$bits;
        $bits++ if $nextcode == 1<<$bits and $bits < 12;
        if($tag==$resetcode) {
            $bits=$ibits;
            $nextcode=$endcode+1;
            next;
        } elsif($tag==$endcode) {
            last;
        } elsif($tag<$resetcode) {
            $d[$nextcode]=$d[$tag];
            $out.=$d[$nextcode];
            $nextcode++;
        } elsif($tag>$endcode) {
            $d[$nextcode]=$d[$tag];
            $d[$nextcode].=substr($d[$tag+1],0,1);
            $out.=$d[$nextcode];
            $nextcode++;
        }
    }
    return($out);
}

sub new {
    my ($class,$pdf,$file,$name,%opts) = @_;
    my $self;
    my $inter=0;

    $class = ref $class if ref $class;

    $self=$class->SUPER::new($pdf,$name || 'Gx'.pdfkey());
    $pdf->new_obj($self) unless($self->is_obj($pdf));

    $self->{' apipdf'}=$pdf;
    weaken $self->{' apipdf'};

    my $fh = IO::File->new;
    if (ref($file)) {
        $fh = $file;
    }
    else {
        open $fh, "<", $file or die "$!: $file";
    }
    binmode $fh, ':raw';
    my $buf;
    $fh->seek(0,0);
    $fh->read($buf,6); # signature
    die "unknown image signature '$buf' -- not a gif." unless($buf=~/^GIF[0-9][0-9][a-b]/);

    $fh->read($buf,7); # logical descr.
    my($wg,$hg,$flags,$bgColorIndex,$aspect)=unpack('vvCCC',$buf);

    if($flags&0x80) {
        my $colSize=2**(($flags&0x7)+1);
        my $dict=PDFDict();
        $pdf->new_obj($dict);
        $self->colorspace(PDFArray(PDFName('Indexed'),PDFName('DeviceRGB'),PDFNum($colSize-1),$dict));
        $fh->read($dict->{' stream'},3*$colSize); # color-table
    }

    while(!$fh->eof) {
        $fh->read($buf,1); # tag.
        my $sep=unpack('C',$buf);
        if($sep==0x2C){
            $fh->read($buf,9); # image-descr.
            my ($left,$top,$w,$h,$flags)=unpack('vvvvC',$buf);

            $self->width($w||$wg);
            $self->height($h||$hg);
            $self->bpc(8);

            if($flags&0x80) { # local colormap
                my $colSize=2**(($flags&0x7)+1);
                my $dict=PDFDict();
                $pdf->new_obj($dict);
                $self->colorspace(PDFArray(PDFName('Indexed'),PDFName('DeviceRGB'),PDFNum($colSize-1),$dict));
                $fh->read($dict->{' stream'},3*$colSize); # color-table
            }
            if($flags&0x40) { # need de-interlace
                $inter=1;
            }

            $fh->read($buf,1); # image-lzw-start (should be 9).
            my ($sep)=unpack('C',$buf);

            $fh->read($buf,1); # first chunk.
            my ($len)=unpack('C',$buf);
            my $stream='';
            while($len>0) {
                $fh->read($buf,$len);
                $stream.=$buf;
                $fh->read($buf,1);
                $len=unpack('C',$buf);
            }
            $self->{' stream'}=deGIF($sep+1,$stream);
            $self->unInterlace if($inter);
            last;
        } elsif($sep==0x3b) {
            last;
        } elsif($sep==0x21) {
            # Graphic Control Extension
            $fh->read($buf,1); # tag.
            my $tag=unpack('C',$buf);
            die "unsupported graphic control extension ($tag)" unless($tag==0xF9);
            $fh->read($buf,1); # len.
            my $len=unpack('C',$buf);
            my $stream='';
            while($len>0) {
                $fh->read($buf,$len);
                $stream.=$buf;
                $fh->read($buf,1);
                $len=unpack('C',$buf);
            }
            my ($cFlags,$delay,$transIndex)=unpack('CvC',$stream);
            if(($cFlags&0x01) && !$opts{-notrans}) {
                $self->{Mask}=PDFArray(PDFNum($transIndex),PDFNum($transIndex));
            }
        } else {
            # extension
            $fh->read($buf,1); # tag.
            my $tag=unpack('C',$buf);
            $fh->read($buf,1); # tag.
            my $len=unpack('C',$buf);
            while($len>0) {
                $fh->read($buf,$len);
                $fh->read($buf,1);
                $len=unpack('C',$buf);
            }
        }
    }
    $fh->close;

    $self->filters('FlateDecode');

    return($self);
}

1;
