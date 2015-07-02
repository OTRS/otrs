package PDF::API2::Resource::XObject::Image::JPEG;

our $VERSION = '2.023'; # VERSION

use base 'PDF::API2::Resource::XObject::Image';

use IO::File;
use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;

no warnings qw[ deprecated recursion uninitialized ];

sub new 
{
    my ($class,$pdf,$file,$name) = @_;
    my $self;
    my $fh = IO::File->new;

    $class = ref $class if ref $class;

    $self=$class->SUPER::new($pdf,$name|| 'Jx'.pdfkey());
    $pdf->new_obj($self) unless($self->is_obj($pdf));

    $self->{' apipdf'}=$pdf;

    if(ref $file) 
    {
        $fh=$file;
    } 
    else 
    {
        open($fh,$file);
    }
    binmode($fh,':raw');

    $self->read_jpeg($fh);

    if(ref $file) 
    {
        seek($fh,0,0);
        $self->{' stream'}='';
        my $buf='';
        while(!eof($fh)) {
            read($fh,$buf,512);
            $self->{' stream'}.=$buf;
        }
        $self->{Length}=PDFNum(length $self->{' stream'});
    } 
    else 
    {
        $self->{Length}=PDFNum(-s $file);
        $self->{' streamfile'}=$file;
    }

    $self->filters('DCTDecode');
    $self->{' nofilt'}=1;

    return($self);
}

sub new_api {
    my ($class,$api,@opts)=@_;

    my $obj=$class->new($api->{pdf},@opts);
    $obj->{' api'}=$api;

    return($obj);
}

sub read_jpeg {
    my $self = shift @_;
    my $fh = shift @_;

    my ($buf, $p, $h, $w, $c, $ff, $mark, $len);

    $fh->seek(0,0);
    $fh->read($buf,2);
    while (1) {
        $fh->read($buf,4);
        my($ff, $mark, $len) = unpack("CCn", $buf);
        last if( $ff != 0xFF);
        last if( $mark == 0xDA || $mark == 0xD9);  # SOS/EOI
        last if( $len < 2);
        last if( $fh->eof);
        $fh->read($buf,$len-2);
        next if ($mark == 0xFE);
        next if ($mark >= 0xE0 && $mark <= 0xEF);
        if (($mark >= 0xC0) && ($mark <= 0xCF) && 
            ($mark != 0xC4) && ($mark != 0xC8) && ($mark != 0xCC)) {
            ($p, $h, $w, $c) = unpack("CnnC", substr($buf, 0, 6));
            last;
        }
    }

    $self->width($w);
    $self->height($h);

    $self->bpc($p);

    if($c==3) {
            $self->colorspace('DeviceRGB');
    } elsif($c==4) {
            $self->colorspace('DeviceCMYK');
    } elsif($c==1) {
            $self->colorspace('DeviceGray');
    }

    return($self);
}



1;
