package PDF::API2::Resource::XObject::Image::TIFF;

our $VERSION = '2.023'; # VERSION

use base 'PDF::API2::Resource::XObject::Image';

use Compress::Zlib;

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;

no warnings qw[ deprecated recursion uninitialized ];

=head1 NAME

PDF::API2::Resource::XObject::Image::TIFF - TIFF image support

=head1 METHODS

=over

=item  $res = PDF::API2::Resource::XObject::Image::TIFF->new $pdf, $file [, $name]

Returns a tiff-image object.

=cut

sub new 
{
    my ($class,$pdf,$file,$name) = @_;
    my $self;

    my $tif=PDF::API2::Resource::XObject::Image::Tiff::File->new($file);
    
    # in case of problematic things 
    #  proxy to other modules
    
    $class = ref $class if ref $class;

    $self=$class->SUPER::new($pdf,$name|| 'Ix'.pdfkey());
    $pdf->new_obj($self) unless($self->is_obj($pdf));

    $self->{' apipdf'}=$pdf;

    $self->read_tiff($pdf,$tif);

    $tif->close;

    return($self);
}

=item $res = PDF::API2::Resource::XObject::Image::TIFF->new_api $api, $file [, $name]

Returns a tiff-image object. This method is different from 'new' that
it needs an PDF::API2-object rather than a Text::PDF::File-object.

=cut

sub new_api 
{
    my ($class,$api,@opts)=@_;

    my $obj=$class->new($api->{pdf},@opts);
    $obj->{' api'}=$api;

    return($obj);
}

sub deLZW 
{
    my ($ibits,$stream)=@_;
    my $bits=$ibits;
    my $resetcode=1<<($ibits-1);
    my $endcode=$resetcode+1;
    my $nextcode=$endcode+1;
    my $ptr=0;
    $stream=unpack('B*',$stream);
    my $maxptr=length($stream);
    my $tag;
    my $out='';
    my $outptr=0;

#    print STDERR "reset=$resetcode\nend=$endcode\nmax=$maxptr\n";

    my @d=map { chr($_) } (0..$resetcode-1);

    while(($ptr+$bits)<=$maxptr) 
    {
        $tag=0;
        foreach my $off (reverse 1..$bits) 
        {
            $tag<<=1;
            $tag|=substr($stream,$ptr+$bits-$off,1);
        }
#        print STDERR "ptr=$ptr,tag=$tag,bits=$bits,next=$nextcode\n";
#        print STDERR "tag to large\n" if($tag>$nextcode);
        $ptr+=$bits;
        if($tag==$resetcode) 
        {
            $bits=$ibits;
            $nextcode=$endcode+1;
            next;
        } 
        elsif($tag==$endcode) {
            last;
        } 
        elsif($tag<$resetcode) {
            $d[$nextcode]=$d[$tag];
            $out.=$d[$nextcode];
            $nextcode++;
        } 
        elsif($tag>$endcode) 
        {
            $d[$nextcode]=$d[$tag];
            $d[$nextcode].=substr($d[$tag+1],0,1);
            $out.=$d[$nextcode];
            $nextcode++;
        }
        $bits++ if($nextcode == (1<<$bits));
    }
    return($out);
}

sub handle_generic 
{
    my ($self,$pdf,$tif)=@_;
    
    if($tif->{filter}) 
    {
        # should we die here ?
        # die "unknown tiff-compression ";
        $self->filters($tif->{filter});
        $self->{' nofilt'}=1;
    } 
    else 
    {
        $self->filters('FlateDecode');
    }

    if(ref($tif->{imageOffset})) 
    {
        $self->{' stream'}='';
        my $d=scalar @{$tif->{imageOffset}};
        foreach (1..$d) 
        {
            my $buf;
            $tif->{fh}->seek(shift @{$tif->{imageOffset}},0);
            $tif->{fh}->read($buf,shift @{$tif->{imageLength}});
            $self->{' stream'}.=$buf;
        }
    } 
    else 
    {
        $tif->{fh}->seek($tif->{imageOffset},0);
        $tif->{fh}->read($self->{' stream'},$tif->{imageLength});
    }
}

sub handle_flate 
{
    my ($self,$pdf,$tif)=@_;
    $self->filters('FlateDecode');

    if(ref($tif->{imageOffset})) 
    {
        $self->{' stream'}='';
        my $d=scalar @{$tif->{imageOffset}};
        foreach (1..$d) 
        {
            my $buf;
            $tif->{fh}->seek(shift @{$tif->{imageOffset}},0);
            $tif->{fh}->read($buf,shift @{$tif->{imageLength}});
            $buf=uncompress($buf);
            $self->{' stream'}.=$buf;
        }
    } 
    else 
    {
        $tif->{fh}->seek($tif->{imageOffset},0);
        $tif->{fh}->read($self->{' stream'},$tif->{imageLength});
        $self->{' stream'}=uncompress($self->{' stream'});
    }
}

sub handle_lzw 
{
    my ($self,$pdf,$tif)=@_;
    $self->filters('FlateDecode');

    if(ref($tif->{imageOffset})) {
        $self->{' stream'}='';
        my $d=scalar @{$tif->{imageOffset}};
        foreach (1..$d) 
        {
            my $buf;
            $tif->{fh}->seek(shift @{$tif->{imageOffset}},0);
            $tif->{fh}->read($buf,shift @{$tif->{imageLength}});
            $buf=deLZW(9,$buf);
            $self->{' stream'}.=$buf;
        }
    } 
    else 
    {
        $tif->{fh}->seek($tif->{imageOffset},0);
        $tif->{fh}->read($self->{' stream'},$tif->{imageLength});
        $self->{' stream'}=deLZW(9,$self->{' stream'});
    }
}

sub handle_ccitt 
{
    my ($self,$pdf,$tif)=@_;

    $self->{' nofilt'}=1;
    $self->{Filter}=PDFName('CCITTFaxDecode');
    $self->{DecodeParms}=PDFDict();
    $self->{DecodeParms}->{K}=(($tif->{ccitt}==4 || ($tif->{g3Options}&0x1)) ? PDFNum(-1) : PDFNum(0));
    $self->{DecodeParms}->{Columns}=PDFNum($tif->{imageWidth});
    $self->{DecodeParms}->{Rows}=PDFNum($tif->{imageHeight});
    $self->{DecodeParms}->{Blackls1}=PDFBool($tif->{whiteIsZero}==1?1:0);
    if(defined($tif->{g3Options}) && ($tif->{g3Options}&0x4)) 
    {
        $self->{DecodeParms}->{EndOfLine}=PDFBool(1);
        $self->{DecodeParms}->{EncodedByteAlign}=PDFBool(1);
    }
    # $self->{DecodeParms}=PDFArray($self->{DecodeParms});
    $self->{DecodeParms}->{DamagedRowsBeforeError}=PDFNum(100);

    if(ref($tif->{imageOffset})) 
    {
        die "chunked ccitt g4 tif not supported.";
    } 
    else 
    {
        $tif->{fh}->seek($tif->{imageOffset},0);
        $tif->{fh}->read($self->{' stream'},$tif->{imageLength});
    }
}

sub read_tiff 
{
    my ($self,$pdf,$tif)=@_;

    $self->width($tif->{imageWidth});
    $self->height($tif->{imageHeight});
    if($tif->{colorSpace} eq 'Indexed') 
    {
        my $dict=PDFDict();
        $pdf->new_obj($dict);
        $self->colorspace(PDFArray(PDFName($tif->{colorSpace}),PDFName('DeviceRGB'),PDFNum(255),$dict));
        $dict->{Filter}=PDFArray(PDFName('FlateDecode'));
        $tif->{fh}->seek($tif->{colorMapOffset},0);
        my $colormap;
        my $straight;
        $tif->{fh}->read($colormap,$tif->{colorMapLength});
        $dict->{' stream'}='';
        map { $straight.=pack('C',($_/256)) } unpack($tif->{short}.'*',$colormap);
        foreach my $c (0..(($tif->{colorMapSamples}/3)-1)) 
        {
            $dict->{' stream'}.=substr($straight,$c,1);
            $dict->{' stream'}.=substr($straight,$c+($tif->{colorMapSamples}/3),1);
            $dict->{' stream'}.=substr($straight,$c+($tif->{colorMapSamples}/3)*2,1);
        }
    } 
    else 
    {
        $self->colorspace($tif->{colorSpace});
    }

    $self->{Interpolate}=PDFBool(1);
    $self->bpc($tif->{bitsPerSample});

    if($tif->{whiteIsZero}==1 && $tif->{filter} ne 'CCITTFaxDecode') 
    {
        $self->{Decode}=PDFArray(PDFNum(1),PDFNum(0));
    }

    # check filters and handle seperately 
    if($tif->{filter} eq 'CCITTFaxDecode') 
    {
        $self->handle_ccitt($pdf,$tif);
    } 
    elsif($tif->{filter} eq 'LZWDecode') 
    {
        $self->handle_lzw($pdf,$tif);
    } 
    elsif($tif->{filter} eq 'FlateDecode') 
    {
        $self->handle_flate($pdf,$tif);
    } 
    else 
    {
        $self->handle_generic($pdf,$tif);
    }

    if($tif->{fillOrder}==2) 
    {
        my @bl=();
        foreach my $n (0..255) 
        {
            my $b=$n;
            my $f=0;
            foreach (0..7) 
            {
                my $bit=0;
                if($b &0x1) 
                {
                    $bit=1;
                }
                $b>>=1;
                $f<<=1;
                $f|=$bit;
            }
            $bl[$n]=$f;
        }
        my $l=length($self->{' stream'})-1;
        foreach my $n (0..$l) 
        {
            vec($self->{' stream'},$n,8)=$bl[vec($self->{' stream'},$n,8)];
        }
    }
    $self->{' tiff'}=$tif;

    return($self);
}

=item $value = $tif->tiffTag $tag

returns the value of the internal tiff-tag.

B<Useful Tags:>

    imageDescription, imageId (strings)
    xRes, yRes (dpi; pixel/cm if resUnit==3)
    resUnit

=cut

sub tiffTag {
    my $self=shift @_;
    my $tag=shift @_;
    return($self->{' tiff'}->{$tag});
}

package PDF::API2::Resource::XObject::Image::Tiff::File;

use IO::File;

sub new {
  my $class=shift @_;
  my $file=shift @_;
  my $self={};
  bless($self,$class);
  if(ref($file)) {
    $self->{fh} = $file;
    seek($self->{fh},0,0);
  } else {
    $self->{fh} = IO::File->new;
    open($self->{fh},"< $file");
  }
  binmode($self->{fh},':raw');
  my $fh = $self->{fh};

  $self->{offset}=0;
  $fh->seek( $self->{offset}, 0 );

  # checking byte order of data
  $fh->read( $self->{byteOrder}, 2 );
  $self->{byte}='C';
  $self->{short}=(($self->{byteOrder} eq 'MM') ? 'n' : 'v' );
  $self->{long}=(($self->{byteOrder} eq 'MM') ? 'N' : 'V' );
  $self->{rational}=(($self->{byteOrder} eq 'MM') ? 'NN' : 'VV' );;

  # get/check version id
  $fh->read( $self->{version}, 2 );
  $self->{version}=unpack($self->{short},$self->{version});
  die "Wrong TIFF Id '$self->{version}' (should be 42)." if($self->{version} != 42);

  # get the offset to the first tag directory.
  $fh->read( $self->{ifdOffset}, 4 );
  $self->{ifdOffset}=unpack($self->{long},$self->{ifdOffset});

  $self->readTags;

  return($self);
}

sub readTag {
  my $self = shift @_;
  my $fh = $self->{fh};
  my $buf;
  $fh->read( $buf, 12 );
  my $tag = unpack($self->{short}, substr($buf, 0, 2 ) );
  my $type = unpack($self->{short}, substr($buf, 2, 2 ) );
  my $count = unpack($self->{long}, substr($buf, 4, 4 ) );
  my $len=0;

  if($type==1) {
    # byte
    $len=$count;
  } elsif($type==2) {
    # charZ
    $len=$count;
  } elsif($type==3) {
    # int16
    $len=$count*2;
  } elsif($type==4) {
    # int32
    $len=$count*4;
  } elsif($type==5) {
    # rational: 2 * int32
    $len=$count*8;
  } else {
    $len=$count;
  }

  my $off = substr($buf, 8, 4 );

  if($len>4) {
    $off=unpack($self->{long},$off);
  } else {
    if($type==1) {
      $off=unpack($self->{byte},$off);
    } elsif($type==2) {
      $off=unpack($self->{long},$off);
    } elsif($type==3) {
      $off=unpack($self->{short},$off);
    } elsif($type==4) {
      $off=unpack($self->{long},$off);
    } else {
      $off=unpack($self->{short},$off);
    }
  }

  return ($tag,$type,$count,$len,$off);
}

sub close {
  my $self = shift @_;
  my $fh = $self->{fh};
  $fh->close;
#  %{$self}=();
}

sub readTags {
  my $self = shift @_;
  my $fh = $self->{fh};
  $self->{fillOrder}=1;
  $self->{ifd}=$self->{ifdOffset};

  while($self->{ifd} > 0) {
    $fh->seek( $self->{ifd}, 0 );
    $fh->read( $self->{ifdNum}, 2 );
    $self->{ifdNum}=unpack($self->{short},$self->{ifdNum});
    $self->{bitsPerSample}=1;
    foreach (1..$self->{ifdNum}) {
      my ($valTag,$valType,$valCount,$valLen,$valOffset)=$self->readTag;
  #    print "tag=$valTag type=$valType count=$valCount len=$valLen off=$valOffset\n";
      if($valTag==0) {
      } elsif($valTag==256) {
        # imagewidth
        $self->{imageWidth}=$valOffset;
      } elsif($valTag==257) {
        # imageheight
        $self->{imageHeight}=$valOffset;
      } elsif($valTag==258) {
        # bits per sample
        if($valCount>1) {
          my $here=$fh->tell;
          my $val;
          $fh->seek($valOffset,0);
          $fh->read($val,2);
          $self->{bitsPerSample}=unpack($self->{short},$val);
          $fh->seek($here,0);
        } else {
          $self->{bitsPerSample}=$valOffset;
        }
      } elsif($valTag==259) {
        # compression
        $self->{filter}=$valOffset;
        if($valOffset==1) {
          delete $self->{filter};
        } elsif($valOffset==3 || $valOffset==4) {
          $self->{filter}='CCITTFaxDecode';
          $self->{ccitt}=$valOffset;
        } elsif($valOffset==5) {
          $self->{filter}='LZWDecode';
        } elsif($valOffset==6 || $valOffset==7) {
          $self->{filter}='DCTDecode';
        } elsif($valOffset==8 || $valOffset==0x80b2) {
          $self->{filter}='FlateDecode';
        } elsif($valOffset==32773) {
          $self->{filter}='RunLengthDecode';
        } else {
          die "unknown/unsupported TIFF compression method with id '$self->{filter}'.";
        }
      } elsif($valTag==262) {
        # photometric interpretation
        $self->{colorSpace}=$valOffset;
        if($valOffset==0) {
          $self->{colorSpace}='DeviceGray';
          $self->{whiteIsZero}=1;
        } elsif($valOffset==1) {
          $self->{colorSpace}='DeviceGray';
          $self->{blackIsZero}=1;
        } elsif($valOffset==2) {
          $self->{colorSpace}='DeviceRGB';
        } elsif($valOffset==3) {
          $self->{colorSpace}='Indexed';
      #  } elsif($valOffset==4) {
      #    $self->{colorSpace}='TransMask';
        } elsif($valOffset==5) {
          $self->{colorSpace}='DeviceCMYK';
        } elsif($valOffset==6) {
          $self->{colorSpace}='DeviceRGB';
        } elsif($valOffset==8) {
          $self->{colorSpace}='Lab';
        } else {
          die "unknown/unsupported TIFF photometric interpretation with id '$self->{colorSpace}'.";
        }
      } elsif($valTag==266) {
        $self->{fillOrder}=$valOffset;
      } elsif($valTag==270) {
        # ImageDescription
        my $here=$fh->tell;
        $fh->seek($valOffset,0);
        $fh->read($self->{imageDescription},$valLen);
        $fh->seek($here,0);
      } elsif($valTag==282) {
        # xRes
        my $here=$fh->tell;
        $fh->seek($valOffset,0);
        $fh->read($self->{xRes},$valLen);
        $fh->seek($here,0);
        $self->{xRes}=[unpack($self->{rational},$self->{xRes})];
        $self->{xRes}=($self->{xRes}->[0]/$self->{xRes}->[1]);
      } elsif($valTag==283) {
        # yRes
        my $here=$fh->tell;
        $fh->seek($valOffset,0);
        $fh->read($self->{yRes},$valLen);
        $fh->seek($here,0);
        $self->{yRes}=[unpack($self->{rational},$self->{yRes})];
        $self->{yRes}=($self->{yRes}->[0]/$self->{yRes}->[1]);
      } elsif($valTag==296) {
        # resolution Unit
        $self->{resUnit}=$valOffset;
      } elsif($valTag==273) {
        # image data offset/strip offsets
        if($valCount==1) {
          $self->{imageOffset}=$valOffset;
        } else {
          my $here=$fh->tell;
          my $val;
          $fh->seek($valOffset,0);
          $fh->read($val,$valLen);
          $fh->seek($here,0);
          $self->{imageOffset}=[ unpack($self->{long}.'*',$val) ];
        }
      } elsif($valTag==277) {
        # samples per pixel
        $self->{samplesPerPixel}=$valOffset;
      } elsif($valTag==279) {
        # image data length/strip lengths
        if($valCount==1) {
          $self->{imageLength}=$valOffset;
        } else {
          my $here=$fh->tell;
          my $val;
          $fh->seek($valOffset,0);
          $fh->read($val,$valLen);
          $fh->seek($here,0);
          $self->{imageLength}=[ unpack($self->{long}.'*',$val) ];
        }
      } elsif($valTag==292) {
        $self->{g3Options}=$valOffset;
      } elsif($valTag==293) {
        $self->{g4Options}=$valOffset;
      } elsif($valTag==320) {
        # color map
        $self->{colorMapOffset}=$valOffset;
        $self->{colorMapSamples}=$valCount;
        $self->{colorMapLength}=$valCount*2; # shorts!
      } elsif($valTag==317) {
        # lzwPredictor
        $self->{lzwPredictor}=$valOffset;
      } elsif($valTag==0x800d) {
        # imageID
        my $here=$fh->tell;
        $fh->seek($valOffset,0);
        $fh->read($self->{imageId},$valLen);
        $fh->seek($here,0);
#      } elsif($valTag==) {
#      } elsif($valTag==) {
#      } elsif($valTag==) {
#      } elsif($valTag==) {
#      } else {
#        print "tag=$valTag, type=$valType, len=$valLen\n";
      }
    }
    $fh->read( $self->{ifd}, 4 );
    $self->{ifd}=unpack($self->{long},$self->{ifd});
  }
}

=back

=cut

1;
