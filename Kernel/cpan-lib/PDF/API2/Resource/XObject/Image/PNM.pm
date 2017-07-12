package PDF::API2::Resource::XObject::Image::PNM;

# For spec details, see man pages pam(5), pbm(5), pgm(5), pnm(5),
# ppm(5), which were pasted into the __END__ of this file in an
# earlier revision.

use base 'PDF::API2::Resource::XObject::Image';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use IO::File;
use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;
use Scalar::Util qw(weaken);

sub new {
    my ($class,$pdf,$file,$name) = @_;
    my $self;

    $class = ref $class if ref $class;

    $self=$class->SUPER::new($pdf,$name || 'Nx'.pdfkey());
    $pdf->new_obj($self) unless($self->is_obj($pdf));

    $self->{' apipdf'}=$pdf;
    weaken $self->{' apipdf'};

    $self->read_pnm($pdf,$file);

    return($self);
}

# READPPMHEADER
# taken from Image::PBMLib
# Copyright by Benjamin Elijah Griffin (28 Feb 2003)
#
sub readppmheader {
  my $gr = shift; # input file glob ref
  my $in = '';
  my $no_comments;
  my %info;
  my $rc;
  $info{error} = undef;

  $rc = read($gr, $in, 3);

  if (!defined($rc) or $rc != 3) {
    $info{error} = 'Read error or EOF';
    return \%info;
  }

  if ($in =~ /^P([123456])\s/) {
    $info{type} = $1;
    if ($info{type} > 3) {
      $info{raw} = 1;
    } else {
      $info{raw} = 0;
    }

    if ($info{type} == 1 or $info{type} == 4) {
      $info{max} = 1;
      $info{bgp} = 'b';
    } elsif ($info{type} == 2 or $info{type} == 5) {
      $info{bgp} = 'g';
    } else {
      $info{bgp} = 'p';
    }

    while(1) {
      $rc = read($gr, $in, 1, length($in));
      if (!defined($rc) or $rc != 1) {
        $info{error} = 'Read error or EOF';
        return \%info;
      }

      $no_comments = $in;
      $info{comments} = '';
      while ($no_comments =~ /#.*\n/) {
        $no_comments =~ s/#(.*\n)/ /;
        $info{comments} .= $1;
      }

      if ($info{bgp} eq 'b') {
        if ($no_comments =~ /^P\d\s+(\d+)\s+(\d+)\s/) {
            $info{width}  = $1;
            $info{height} = $2;
            last;
        }
      } else {
        if ($no_comments =~ /^P\d\s+(\d+)\s+(\d+)\s+(\d+)\s/) {
            $info{width}  = $1;
            $info{height} = $2;
            $info{max}    = $3;
            last;
        }
      }
    } # while reading header

    $info{fullheader} = $in;

  } else {
    $info{error} = 'Wrong magic number';
  }

  return \%info;
}

sub read_pnm {
    my $self = shift @_;
    my $pdf = shift @_;
    my $file = shift @_;

    my ($buf,$t,$s,$line);
    my ($w,$h,$bpc,$cs,$img,@img)=(0,0,'','','');
    my $inf;
    if (ref($file)) {
        $inf = $file;
    }
    else {
        open $inf, "<", $file or die "$!: $file";
    }
    binmode($inf,':raw');
    $inf->seek(0,0);
    my $info=readppmheader($inf);
    if($info->{type} == 4) {
        $bpc=1;
        read($inf,$self->{' stream'},($info->{width}*$info->{height}/8));
        $cs='DeviceGray';
        $self->{Decode}=PDFArray(PDFNum(1),PDFNum(0));
    } elsif($info->{type} == 5) {
        $buf.=<$inf>;
        if($info->{max}==255){
            $s=0;
        } else {
            $s=255/$info->{max};
        }
        $bpc=8;
        if($s>0) {
            for($line=($info->{width}*$info->{height});$line>0;$line--) {
                read($inf,$buf,1);
                $self->{' stream'}.=pack('C',(unpack('C',$buf)*$s));
            }
        } else {
            read($inf,$self->{' stream'},$info->{width}*$info->{height});
        }
        $cs='DeviceGray';
    } elsif($info->{type} == 6) {
        if($info->{max}==255){
            $s=0;
        } else {
            $s=255/$info->{max};
        }
        $bpc=8;
        if($s>0) {
            for($line=($info->{width}*$info->{height});$line>0;$line--) {
                read($inf,$buf,1);
                $self->{' stream'}.=pack('C',(unpack('C',$buf)*$s));
                read($inf,$buf,1);
                $self->{' stream'}.=pack('C',(unpack('C',$buf)*$s));
                read($inf,$buf,1);
                $self->{' stream'}.=pack('C',(unpack('C',$buf)*$s));
            }
        } else {
            read($inf,$self->{' stream'},$info->{width}*$info->{height}*3);
        }
        $cs='DeviceRGB';
    }
    close($inf);

    $self->width($info->{width});
    $self->height($info->{height});

    $self->bpc($bpc);

    $self->filters('FlateDecode');

    $self->colorspace($cs);

    return($self);
}

1;
