package PDF::API2::Resource::XObject::Image::TIFF::File;

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

use IO::File;

sub new {
    my ($class, $file) = @_;

    my $self = {};
    bless($self, $class);
    if (ref($file)) {
        $self->{'fh'} = $file;
        seek($self->{'fh'}, 0, 0);
    }
    else {
        $self->{'fh'} = IO::File->new();
        open($self->{'fh'}, '<', $file) or die "$!: $file";
    }
    binmode($self->{'fh'}, ':raw');
    my $fh = $self->{'fh'};

    $self->{'offset'} = 0;
    $fh->seek($self->{'offset'}, 0);

    # checking byte order of data
    $fh->read($self->{'byteOrder'}, 2);
    $self->{'byte'} = 'C';
    $self->{'short'} = (($self->{'byteOrder'} eq 'MM') ? 'n' : 'v' );
    $self->{'long'} = (($self->{'byteOrder'} eq 'MM') ? 'N' : 'V' );
    $self->{'rational'} = (($self->{'byteOrder'} eq 'MM') ? 'NN' : 'VV' );

    # get/check version id
    $fh->read($self->{'version'}, 2);
    $self->{'version'} = unpack($self->{'short'}, $self->{'version'});
    die "Wrong TIFF Id '$self->{version}' (should be 42)." if $self->{'version'} != 42;

    # get the offset to the first tag directory.
    $fh->read($self->{'ifdOffset'}, 4);
    $self->{'ifdOffset'} = unpack($self->{'long'}, $self->{'ifdOffset'});

    $self->readTags();

    return $self;
}

sub readTag {
    my $self = shift();
    my $fh = $self->{'fh'};
    my $buf;
    $fh->read($buf, 12);
    my $tag = unpack($self->{'short'}, substr($buf, 0, 2));
    my $type = unpack($self->{'short'}, substr($buf, 2, 2));
    my $count = unpack($self->{'long'}, substr($buf, 4, 4));
    my $len = 0;

    $len = ($type == 1 ? $count     : # byte
            $type == 2 ? $count     : # char2
            $type == 3 ? $count * 2 : # int16
            $type == 4 ? $count * 4 : # int32
            $type == 5 ? $count * 8 : # rational: 2 * int32
            $count);

    my $off = substr($buf, 8, 4);

    if ($len > 4) {
        $off = unpack($self->{'long'}, $off);
    }
    else {
        $off = ($type == 1 ? unpack($self->{'byte'},  $off) :
                $type == 2 ? unpack($self->{'long'},  $off) :
                $type == 3 ? unpack($self->{'short'}, $off) :
                $type == 4 ? unpack($self->{'long'},  $off) : unpack($self->{'short'}, $off));
    }

    return ($tag, $type, $count, $len, $off);
}

sub close { ## no critic
    my $self = shift();
    return $self->{'fh'}->close();
}

sub readTags {
    my $self = shift();
    my $fh = $self->{'fh'};
    $self->{'fillOrder'} = 1;
    $self->{'ifd'} = $self->{'ifdOffset'};

    while ($self->{'ifd'} > 0) {
        $fh->seek($self->{'ifd'}, 0);
        $fh->read($self->{'ifdNum'}, 2);
        $self->{'ifdNum'} = unpack($self->{'short'}, $self->{'ifdNum'});
        $self->{'bitsPerSample'} = 1;
        foreach (1 .. $self->{'ifdNum'}) {
            my ($valTag, $valType, $valCount, $valLen, $valOffset) = $self->readTag();
            # print "tag=$valTag type=$valType count=$valCount len=$valLen off=$valOffset\n";
            if ($valTag == 0) {
            }
            elsif ($valTag == 256) {
                $self->{'imageWidth'} = $valOffset;
            }
            elsif ($valTag == 257) {
                $self->{'imageHeight'} = $valOffset;
            }
            elsif ($valTag == 258) {
                # bits per sample
                if ($valCount > 1) {
                    my $here = $fh->tell();
                    my $val;
                    $fh->seek($valOffset, 0);
                    $fh->read($val, 2);
                    $self->{'bitsPerSample'} = unpack($self->{'short'}, $val);
                    $fh->seek($here, 0);
                }
                else {
                    $self->{'bitsPerSample'} = $valOffset;
                }
            }
            elsif ($valTag == 259) {
                # compression
                $self->{'filter'} = $valOffset;
                if ($valOffset == 1) {
                    delete $self->{'filter'};
                }
                elsif ($valOffset == 3 || $valOffset == 4) {
                    $self->{'filter'} = 'CCITTFaxDecode';
                    $self->{'ccitt'} = $valOffset;
                }
                elsif ($valOffset == 5) {
                    $self->{'filter'} = 'LZWDecode';
                }
                elsif ($valOffset == 6 || $valOffset == 7) {
                    $self->{'filter'} = 'DCTDecode';
                }
                elsif ($valOffset == 8 || $valOffset == 0x80b2) {
                    $self->{'filter'} = 'FlateDecode';
                }
                elsif ($valOffset == 32773) {
                    $self->{'filter'} = 'RunLengthDecode';
                }
                else {
                    die "unknown/unsupported TIFF compression method with id '$self->{filter}'.";
                }
            }
            elsif ($valTag == 262) {
                # photometric interpretation
                $self->{'colorSpace'} = $valOffset;
                if ($valOffset == 0) {
                    $self->{'colorSpace'} = 'DeviceGray';
                    $self->{'whiteIsZero'} = 1;
                }
                elsif ($valOffset == 1) {
                    $self->{'colorSpace'} = 'DeviceGray';
                    $self->{'blackIsZero'} = 1;
                }
                elsif ($valOffset == 2) {
                    $self->{'colorSpace'} = 'DeviceRGB';
                }
                elsif($valOffset == 3) {
                    $self->{'colorSpace'} = 'Indexed';
                }
                # elsif($valOffset == 4) {
                #     $self->{'colorSpace'} = 'TransMask';
                # }
                elsif ($valOffset == 5) {
                    $self->{'colorSpace'} = 'DeviceCMYK';
                }
                elsif($valOffset == 6) {
                    $self->{'colorSpace'} = 'DeviceRGB';
                }
                elsif ($valOffset == 8) {
                    $self->{'colorSpace'} = 'Lab';
                }
                else {
                    die "unknown/unsupported TIFF photometric interpretation with id '$self->{colorSpace}'.";
                }
            }
            elsif ($valTag == 266) {
                $self->{'fillOrder'} = $valOffset;
            }
            elsif ($valTag == 270) {
                # ImageDescription
                my $here = $fh->tell();
                $fh->seek($valOffset, 0);
                $fh->read($self->{'imageDescription'}, $valLen);
                $fh->seek($here, 0);
            }
            elsif($valTag == 282) {
                # xRes
                my $here = $fh->tell();
                $fh->seek($valOffset, 0);
                $fh->read($self->{'xRes'}, $valLen);
                $fh->seek($here, 0);
                $self->{'xRes'} = [unpack($self->{'rational'}, $self->{'xRes'})];
                $self->{'xRes'} = ($self->{'xRes'}->[0] / $self->{'xRes'}->[1]);
            }
            elsif($valTag == 283) {
                # yRes
                my $here = $fh->tell();
                $fh->seek($valOffset, 0);
                $fh->read($self->{'yRes'}, $valLen);
                $fh->seek($here, 0);
                $self->{'yRes'} = [unpack($self->{'rational'}, $self->{'yRes'})];
                $self->{'yRes'} = ($self->{'yRes'}->[0] / $self->{'yRes'}->[1]);
            }
            elsif ($valTag == 296) {
                # resolution Unit
                $self->{'resUnit'} = $valOffset;
            }
            elsif ($valTag == 273) {
                # image data offset/strip offsets
                if ($valCount == 1) {
                    $self->{'imageOffset'} = $valOffset;
                }
                else {
                    my $here =$fh->tell();
                    my $val;
                    $fh->seek($valOffset, 0);
                    $fh->read($val, $valLen);
                    $fh->seek($here, 0);
                    $self->{'imageOffset'} = [unpack($self->{'long'} . '*', $val)];
                }
            }
            elsif ($valTag == 277) {
                $self->{'samplesPerPixel'} = $valOffset;
            }
            elsif ($valTag == 278) {
                $self->{'RowsPerStrip'} = $valOffset;
            }
            elsif ($valTag == 279) {
                # image data length/strip lengths
                if ($valCount == 1) {
                    $self->{'imageLength'} = $valOffset;
                }
                else {
                    my $here = $fh->tell();
                    my $val;
                    $fh->seek($valOffset, 0);
                    $fh->read($val, $valLen);
                    $fh->seek($here, 0);
                    $self->{'imageLength'} = [unpack($self->{'long'} . '*', $val)];
                }
            }
            elsif ($valTag == 292) {
                $self->{'g3Options'} = $valOffset;
            }
            elsif ($valTag == 293) {
                $self->{'g4Options'} = $valOffset;
            }
            elsif ($valTag == 320) {
                # color map
                $self->{'colorMapOffset'} = $valOffset;
                $self->{'colorMapSamples'} = $valCount;
                $self->{'colorMapLength'} = $valCount * 2; # shorts!
            }
            elsif ($valTag == 317) {
                $self->{'lzwPredictor'} = $valOffset;
            }
            elsif ($valTag == 0x800d) {
                # imageID
                my $here = $fh->tell();
                $fh->seek($valOffset, 0);
                $fh->read($self->{'imageId'}, $valLen);
                $fh->seek($here, 0);
            }
            # else {
            #     print "tag=$valTag, type=$valType, len=$valLen\n";
            # }
        }
        $fh->read($self->{'ifd'}, 4);
        $self->{'ifd'} = unpack($self->{'long'}, $self->{'ifd'});
    }

    return $self;
}

1;
