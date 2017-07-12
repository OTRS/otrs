package PDF::API2::Resource::XObject::Image::PNG;

use base 'PDF::API2::Resource::XObject::Image';

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

use Compress::Zlib;
use POSIX qw(ceil floor);

use IO::File;
use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;
use Scalar::Util qw(weaken);

sub new {
    my ($class, $pdf, $file, $name, %opts) = @_;
    my $self;

    $class = ref($class) if ref($class);

    $self = $class->SUPER::new($pdf, $name || 'Px' . pdfkey());
    $pdf->new_obj($self) unless $self->is_obj($pdf);

    $self->{' apipdf'} = $pdf;
    weaken $self->{' apipdf'};

    my $fh = IO::File->new();
    if (ref($file)) {
        $fh = $file;
    }
    else {
        open $fh, '<', $file or die "$!: $file";
    }
    binmode $fh, ':raw';

    my ($buf, $l, $crc, $w, $h, $bpc, $cs, $cm, $fm, $im, $palete, $trns);
    seek($fh, 8, 0);
    $self->{' stream'} = '';
    $self->{' nofilt'} = 1;
    while (!eof($fh)) {
        read($fh, $buf, 4);
        $l = unpack('N', $buf);
        read($fh, $buf, 4);
        if ($buf eq 'IHDR') {
            read($fh, $buf, $l);
            ($w, $h, $bpc, $cs, $cm, $fm, $im) = unpack('NNCCCCC', $buf);
            die "Unsupported Compression($cm) Method" if $cm;
            die "Unsupported Interlace($im) Method"   if $im;
            die "Unsupported Filter($fm) Method"      if $fm;
        }
        elsif ($buf eq 'PLTE') {
            read($fh, $buf, $l);
            $palete = $buf;
        }
        elsif($buf eq 'IDAT') {
            read($fh, $buf, $l);
            $self->{' stream'} .= $buf;
        }
        elsif($buf eq 'tRNS') {
            read($fh, $buf, $l);
            $trns = $buf;
        }
        elsif($buf eq 'IEND') {
            last;
        }
        else {
            # skip ahead
            seek($fh, $l, 1);
        }
        read($fh, $buf, 4);
        $crc = $buf;
    }
    close $fh;

    $self->width($w);
    $self->height($h);

    if ($cs == 0) {     # greyscale
        # scanline = ceil(bpc * comp / 8)+1
        if ($bpc > 8) {
            die "16-bits of greylevel in png not supported.";
        }
        else {
            $self->filters('FlateDecode');
            $self->colorspace('DeviceGray');
            $self->bpc($bpc);
            my $dict = PDFDict();
            $self->{'DecodeParms'} = PDFArray($dict);
            $dict->{'Predictor'} = PDFNum(15);
            $dict->{'BitsPerComponent'} = PDFNum($bpc);
            $dict->{'Colors'} = PDFNum(1);
            $dict->{'Columns'} = PDFNum($w);
            if (defined $trns && !$opts{-notrans}) {
                my $m = mMax(unpack('n*', $trns));
                my $n = mMin(unpack('n*', $trns));
                $self->{'Mask'} = PDFArray(PDFNum($n), PDFNum($m));
            }
        }
    }
    elsif ($cs == 2) {  # rgb 8/16 bits
        if ($bpc > 8) {
            die "16-bits of rgb in png not supported.";
        }
        else {
            $self->filters('FlateDecode');
            $self->colorspace('DeviceRGB');
            $self->bpc($bpc);
            my $dict = PDFDict();
            $self->{'DecodeParms'} = PDFArray($dict);
            $dict->{'Predictor'} = PDFNum(15);
            $dict->{'BitsPerComponent'} = PDFNum($bpc);
            $dict->{'Colors'} = PDFNum(3);
            $dict->{'Columns'} = PDFNum($w);
            if (defined $trns && !$opts{-notrans}) {
                my @v = unpack('n*', $trns);
                my (@cr, @cg, @cb, $m, $n);
                while (scalar @v > 0) {
                    push @cr, shift(@v);
                    push @cg, shift(@v);
                    push @cb, shift(@v);
                }
                @v = ();
                $m = mMax(@cr);
                $n = mMin(@cr);
                push @v, $n, $m;
                $m = mMax(@cg);
                $n = mMin(@cg);
                push @v, $n, $m;
                $m = mMax(@cb);
                $n = mMin(@cb);
                push @v, $n, $m;
                $self->{'Mask'} = PDFArray(map { PDFNum($_) } @v);
            }
        }
    }
    elsif ($cs == 3){  # palette
        if ($bpc > 8) {
            die 'bits>8 of palette in png not supported.';
        }
        else {
            my $dict = PDFDict();
            $pdf->new_obj($dict);
            $dict->{'Filter'} = PDFArray(PDFName('FlateDecode'));
            $dict->{' stream'} = $palete;
            $palete = '';
            $self->filters('FlateDecode');
            $self->colorspace(PDFArray(PDFName('Indexed'), PDFName('DeviceRGB'), PDFNum(int(length($dict->{' stream'}) / 3) - 1), $dict));
            $self->bpc($bpc);
            $dict = PDFDict();
            $self->{'DecodeParms'} = PDFArray($dict);
            $dict->{'Predictor'} = PDFNum(15);
            $dict->{'BitsPerComponent'} = PDFNum($bpc);
            $dict->{'Colors'} = PDFNum(1);
            $dict->{'Columns'} = PDFNum($w);
            if (defined $trns && !$opts{-notrans}) {
                $trns .= "\xFF" x 256;
                $dict = PDFDict();
                $pdf->new_obj($dict);
                $dict->{'Type'} = PDFName('XObject');
                $dict->{'Subtype'} = PDFName('Image');
                $dict->{'Width'} = PDFNum($w);
                $dict->{'Height'} = PDFNum($h);
                $dict->{'ColorSpace'} = PDFName('DeviceGray');
                $dict->{'Filter'} = PDFArray(PDFName('FlateDecode'));
                $dict->{'BitsPerComponent'} = PDFNum(8);
                $self->{'SMask'} = $dict;
                my $scanline = 1 + ceil($bpc * $w / 8);
                my $bpp = ceil($bpc / 8);
                my $clearstream = unprocess($bpc, $bpp, 1, $w, $h, $scanline, \$self->{' stream'});
                foreach my $n (0 .. ($h * $w) - 1) {
                    vec($dict->{' stream'}, $n, 8) = vec($trns, vec($clearstream, $n, $bpc), 8);
                }
            }
        }
    }
    elsif ($cs == 4) {        # greyscale+alpha
        if ($bpc > 8) {
            die '16-bits of greylevel+alpha in png not supported.';
        }
        else {
            $self->filters('FlateDecode');
            $self->colorspace('DeviceGray');
            $self->bpc($bpc);
            my $dict = PDFDict();
            $self->{'DecodeParms'} = PDFArray($dict);
            # $dict->{'Predictor'} = PDFNum(15);
            $dict->{'BitsPerComponent'} = PDFNum($bpc);
            $dict->{'Colors'} = PDFNum(1);
            $dict->{'Columns'} = PDFNum($w);

            $dict = PDFDict();
            unless ($opts{-notrans}) {
                $pdf->new_obj($dict);
                $dict->{'Type'}             = PDFName('XObject');
                $dict->{'Subtype'}          = PDFName('Image');
                $dict->{'Width'}            = PDFNum($w);
                $dict->{'Height'}           = PDFNum($h);
                $dict->{'ColorSpace'}       = PDFName('DeviceGray');
                $dict->{'Filter'}           = PDFArray(PDFName('FlateDecode'));
                $dict->{'BitsPerComponent'} = PDFNum($bpc);
                $self->{'SMask'}            = $dict;
            }
            my $scanline = 1 + ceil($bpc * 2 * $w / 8);
            my $bpp = ceil($bpc * 2 / 8);
            my $clearstream = unprocess($bpc, $bpp, 2, $w, $h, $scanline, \$self->{' stream'});
            delete $self->{' nofilt'};
            delete $self->{' stream'};
            foreach my $n (0 .. ($h * $w) - 1) {
                vec($dict->{' stream'}, $n, $bpc) = vec($clearstream, ($n * 2) + 1, $bpc);
                vec($self->{' stream'}, $n, $bpc) = vec($clearstream, $n * 2, $bpc);
            }
        }
    }
    elsif ($cs == 6) {  # rgb+alpha
        if ($bpc > 8) {
            die '16-bits of rgb+alpha in png not supported.';
        }
        else {
            $self->filters('FlateDecode');
            $self->colorspace('DeviceRGB');
            $self->bpc($bpc);
            my $dict = PDFDict();
            $self->{'DecodeParms'} = PDFArray($dict);
            # $dict->{'Predictor'} = PDFNum(15);
            $dict->{'BitsPerComponent'} = PDFNum($bpc);
            $dict->{'Colors'} = PDFNum(3);
            $dict->{'Columns'} = PDFNum($w);

            $dict = PDFDict();
            unless($opts{-notrans}) {
                $pdf->new_obj($dict);
                $dict->{'Type'}             = PDFName('XObject');
                $dict->{'Subtype'}          = PDFName('Image');
                $dict->{'Width'}            = PDFNum($w);
                $dict->{'Height'}           = PDFNum($h);
                $dict->{'ColorSpace'}       = PDFName('DeviceGray');
                $dict->{'Filter'}           = PDFArray(PDFName('FlateDecode'));
                $dict->{'BitsPerComponent'} = PDFNum($bpc);
                $self->{'SMask'}            = $dict;
            }
            my $scanline = 1 + ceil($bpc * 4 * $w / 8);
            my $bpp = ceil($bpc * 4 / 8);
            my $clearstream = unprocess($bpc, $bpp, 4, $w, $h, $scanline, \$self->{' stream'});
            delete $self->{' nofilt'};
            delete $self->{' stream'};
            foreach my $n (0 .. ($h * $w) - 1) {
                vec($dict->{' stream'}, $n, $bpc) = vec($clearstream, ($n * 4) + 3, $bpc);
                vec($self->{' stream'}, ($n * 3), $bpc) = vec($clearstream, ($n * 4), $bpc);
                vec($self->{' stream'}, ($n * 3) + 1, $bpc) = vec($clearstream, ($n * 4) + 1, $bpc);
                vec($self->{' stream'}, ($n * 3) + 2, $bpc) = vec($clearstream, ($n * 4) + 2, $bpc);
            }
        }
    }
    else {
        die "unsupported png-type ($cs).";
    }

    return $self;
}

sub PaethPredictor {
    my ($a, $b, $c) = @_;
    my $p = $a + $b - $c;
    my $pa = abs($p - $a);
    my $pb = abs($p - $b);
    my $pc = abs($p - $c);
    if (($pa <= $pb) && ($pa <= $pc)) {
        return $a;
    }
    elsif ($pb <= $pc) {
        return $b;
    }
    else {
        return $c;
    }
}

sub unprocess {
    my ($bpc, $bpp, $comp, $width, $height, $scanline, $sstream) = @_;
    my $stream = uncompress($$sstream);
    my $prev = '';
    my $clearstream = '';
    foreach my $n (0 .. $height - 1) {
        # print STDERR "line $n:";
        my $line = substr($stream, $n * $scanline, $scanline);
        my $filter = vec($line, 0, 8);
        my $clear = '';
        $line = substr($line, 1);
        # print STDERR " filter=$filter";
        if ($filter == 0) {
            $clear = $line;
        }
        elsif ($filter == 1) {
            foreach my $x (0 .. length($line) - 1) {
                vec($clear, $x, 8) = (vec($line, $x, 8) + vec($clear, $x - $bpp, 8)) % 256;
            }
        }
        elsif ($filter == 2) {
            foreach my $x (0 .. length($line) - 1) {
                vec($clear, $x, 8) = (vec($line, $x, 8) + vec($prev, $x, 8)) % 256;
            }
        }
        elsif ($filter == 3) {
            foreach my $x (0 .. length($line) - 1) {
                vec($clear, $x, 8) = (vec($line, $x, 8) + floor((vec($clear, $x - $bpp, 8) + vec($prev, $x, 8)) / 2)) % 256;
            }
        }
        elsif ($filter == 4) {
            foreach my $x (0 .. length($line) - 1) {
                vec($clear,$x,8) = (vec($line, $x, 8) + PaethPredictor(vec($clear, $x - $bpp, 8), vec($prev, $x, 8), vec($prev, $x - $bpp, 8))) % 256;
            }
        }
        $prev = $clear;
        foreach my $x (0 .. ($width * $comp) - 1) {
            vec($clearstream, ($n * $width * $comp) + $x, $bpc) = vec($clear, $x, $bpc);
        }
    }
    return $clearstream;
}

1;

__END__

RFC 2083
PNG: Portable Network Graphics
January 1997


4.1.3. IDAT Image data

    The IDAT chunk contains the actual image data.  To create this
    data:

     * Begin with image scanlines represented as described in
       Image layout (Section 2.3); the layout and total size of
       this raw data are determined by the fields of IHDR.
     * Filter the image data according to the filtering method
       specified by the IHDR chunk.  (Note that with filter
       method 0, the only one currently defined, this implies
       prepending a filter type byte to each scanline.)
     * Compress the filtered data using the compression method
       specified by the IHDR chunk.

    The IDAT chunk contains the output datastream of the compression
    algorithm.

    To read the image data, reverse this process.

    There can be multiple IDAT chunks; if so, they must appear
    consecutively with no other intervening chunks.  The compressed
    datastream is then the concatenation of the contents of all the
    IDAT chunks.  The encoder can divide the compressed datastream
    into IDAT chunks however it wishes.  (Multiple IDAT chunks are
    allowed so that encoders can work in a fixed amount of memory;
    typically the chunk size will correspond to the encoder's buffer
    size.) It is important to emphasize that IDAT chunk boundaries
    have no semantic significance and can occur at any point in the
    compressed datastream.  A PNG file in which each IDAT chunk
    contains only one data byte is legal, though remarkably wasteful
    of space.  (For that matter, zero-length IDAT chunks are legal,
    though even more wasteful.)


4.2.9. tRNS Transparency

    The tRNS chunk specifies that the image uses simple
    transparency: either alpha values associated with palette
    entries (for indexed-color images) or a single transparent
    color (for grayscale and truecolor images).  Although simple
    transparency is not as elegant as the full alpha channel, it
    requires less storage space and is sufficient for many common
    cases.

    For color type 3 (indexed color), the tRNS chunk contains a
    series of one-byte alpha values, corresponding to entries in
    the PLTE chunk:

        Alpha for palette index 0:  1 byte
        Alpha for palette index 1:  1 byte
        ... etc ...

    Each entry indicates that pixels of the corresponding palette
    index must be treated as having the specified alpha value.
    Alpha values have the same interpretation as in an 8-bit full
    alpha channel: 0 is fully transparent, 255 is fully opaque,
    regardless of image bit depth. The tRNS chunk must not contain
    more alpha values than there are palette entries, but tRNS can
    contain fewer values than there are palette entries.  In this
    case, the alpha value for all remaining palette entries is
    assumed to be 255.  In the common case in which only palette
    index 0 need be made transparent, only a one-byte tRNS chunk is
    needed.

    For color type 0 (grayscale), the tRNS chunk contains a single
    gray level value, stored in the format:

        Gray:  2 bytes, range 0 .. (2^bitdepth)-1

    (For consistency, 2 bytes are used regardless of the image bit
    depth.) Pixels of the specified gray level are to be treated as
    transparent (equivalent to alpha value 0); all other pixels are
    to be treated as fully opaque (alpha value (2^bitdepth)-1).

    For color type 2 (truecolor), the tRNS chunk contains a single
    RGB color value, stored in the format:

        Red:   2 bytes, range 0 .. (2^bitdepth)-1
        Green: 2 bytes, range 0 .. (2^bitdepth)-1
        Blue:  2 bytes, range 0 .. (2^bitdepth)-1

    (For consistency, 2 bytes per sample are used regardless of the
    image bit depth.) Pixels of the specified color value are to be
    treated as transparent (equivalent to alpha value 0); all other
    pixels are to be treated as fully opaque (alpha value
    2^bitdepth)-1).

    tRNS is prohibited for color types 4 and 6, since a full alpha
    channel is already present in those cases.

    Note: when dealing with 16-bit grayscale or truecolor data, it
    is important to compare both bytes of the sample values to
    determine whether a pixel is transparent.  Although decoders
    may drop the low-order byte of the samples for display, this
    must not occur until after the data has been tested for
    transparency.  For example, if the grayscale level 0x0001 is
    specified to be transparent, it would be incorrect to compare
    only the high-order byte and decide that 0x0002 is also
    transparent.

    When present, the tRNS chunk must precede the first IDAT chunk,
    and must follow the PLTE chunk, if any.


6. Filter Algorithms

    This chapter describes the filter algorithms that can be applied
    before compression.  The purpose of these filters is to prepare the
    image data for optimum compression.


6.1. Filter types

    PNG filter method 0 defines five basic filter types:

        Type    Name

        0       None
        1       Sub
        2       Up
        3       Average
        4       Paeth

    (Note that filter method 0 in IHDR specifies exactly this set of
    five filter types.  If the set of filter types is ever extended, a
    different filter method number will be assigned to the extended
    set, so that decoders need not decompress the data to discover
    that it contains unsupported filter types.)

    The encoder can choose which of these filter algorithms to apply
    on a scanline-by-scanline basis.  In the image data sent to the
    compression step, each scanline is preceded by a filter type byte
    that specifies the filter algorithm used for that scanline.

    Filtering algorithms are applied to bytes, not to pixels,
    regardless of the bit depth or color type of the image.  The
    filtering algorithms work on the byte sequence formed by a
    scanline that has been represented as described in Image layout
    (Section 2.3).  If the image includes an alpha channel, the alpha
    data is filtered in the same way as the image data.

    When the image is interlaced, each pass of the interlace pattern
    is treated as an independent image for filtering purposes.  The
    filters work on the byte sequences formed by the pixels actually
    transmitted during a pass, and the "previous scanline" is the one
    previously transmitted in the same pass, not the one adjacent in
    the complete image.  Note that the subimage transmitted in any one
    pass is always rectangular, but is of smaller width and/or height
    than the complete image.  Filtering is not applied when this
    subimage is empty.

    For all filters, the bytes "to the left of" the first pixel in a
    scanline must be treated as being zero.  For filters that refer to
    the prior scanline, the entire prior scanline must be treated as
    being zeroes for the first scanline of an image (or of a pass of
    an interlaced image).

    To reverse the effect of a filter, the decoder must use the
    decoded values of the prior pixel on the same line, the pixel
    immediately above the current pixel on the prior line, and the
    pixel just to the left of the pixel above.  This implies that at
    least one scanline's worth of image data will have to be stored by
    the decoder at all times.  Even though some filter types do not
    refer to the prior scanline, the decoder will always need to store
    each scanline as it is decoded, since the next scanline might use
    a filter that refers to it.

    PNG imposes no restriction on which filter types can be applied to
    an image.  However, the filters are not equally effective on all
    types of data.  See Recommendations for Encoders: Filter selection
    (Section 9.6).

    See also Rationale: Filtering (Section 12.9).



6.2. Filter type 0: None

    With the None filter, the scanline is transmitted unmodified; it
    is only necessary to insert a filter type byte before the data.


6.3. Filter type 1: Sub

    The Sub filter transmits the difference between each byte and the
    value of the corresponding byte of the prior pixel.

    To compute the Sub filter, apply the following formula to each
    byte of the scanline:

        Sub(x) = Raw(x) - Raw(x-bpp)

    where x ranges from zero to the number of bytes representing the
    scanline minus one, Raw(x) refers to the raw data byte at that
    byte position in the scanline, and bpp is defined as the number of
    bytes per complete pixel, rounding up to one. For example, for
    color type 2 with a bit depth of 16, bpp is equal to 6 (three
    samples, two bytes per sample); for color type 0 with a bit depth
    of 2, bpp is equal to 1 (rounding up); for color type 4 with a bit
    depth of 16, bpp is equal to 4 (two-byte grayscale sample, plus
    two-byte alpha sample).

    Note this computation is done for each byte, regardless of bit
    depth.  In a 16-bit image, each MSB is predicted from the
    preceding MSB and each LSB from the preceding LSB, because of the
    way that bpp is defined.

    Unsigned arithmetic modulo 256 is used, so that both the inputs
    and outputs fit into bytes.  The sequence of Sub values is
    transmitted as the filtered scanline.

    For all x < 0, assume Raw(x) = 0.

    To reverse the effect of the Sub filter after decompression,
    output the following value:

        Sub(x) + Raw(x-bpp)

    (computed mod 256), where Raw refers to the bytes already decoded.


6.4. Filter type 2: Up

    The Up filter is just like the Sub filter except that the pixel
    immediately above the current pixel, rather than just to its left,
    is used as the predictor.

    To compute the Up filter, apply the following formula to each byte
    of the scanline:

        Up(x) = Raw(x) - Prior(x)

    where x ranges from zero to the number of bytes representing the
    scanline minus one, Raw(x) refers to the raw data byte at that
    byte position in the scanline, and Prior(x) refers to the
    unfiltered bytes of the prior scanline.

    Note this is done for each byte, regardless of bit depth.
    Unsigned arithmetic modulo 256 is used, so that both the inputs
    and outputs fit into bytes.  The sequence of Up values is
    transmitted as the filtered scanline.

    On the first scanline of an image (or of a pass of an interlaced
    image), assume Prior(x) = 0 for all x.

    To reverse the effect of the Up filter after decompression, output
    the following value:

        Up(x) + Prior(x)

    (computed mod 256), where Prior refers to the decoded bytes of the
    prior scanline.


6.5. Filter type 3: Average

    The Average filter uses the average of the two neighboring pixels
    (left and above) to predict the value of a pixel.

    To compute the Average filter, apply the following formula to each
    byte of the scanline:

        Average(x) = Raw(x) - floor((Raw(x-bpp)+Prior(x))/2)

    where x ranges from zero to the number of bytes representing the
    scanline minus one, Raw(x) refers to the raw data byte at that
    byte position in the scanline, Prior(x) refers to the unfiltered
    bytes of the prior scanline, and bpp is defined as for the Sub
    filter.

    Note this is done for each byte, regardless of bit depth.  The
    sequence of Average values is transmitted as the filtered
    scanline.

    The subtraction of the predicted value from the raw byte must be
    done modulo 256, so that both the inputs and outputs fit into
    bytes.  However, the sum Raw(x-bpp)+Prior(x) must be formed
    without overflow (using at least nine-bit arithmetic).  floor()
    indicates that the result of the division is rounded to the next
    lower integer if fractional; in other words, it is an integer
    division or right shift operation.

    For all x < 0, assume Raw(x) = 0.  On the first scanline of an
    image (or of a pass of an interlaced image), assume Prior(x) = 0
    for all x.

    To reverse the effect of the Average filter after decompression,
    output the following value:

        Average(x) + floor((Raw(x-bpp)+Prior(x))/2)

    where the result is computed mod 256, but the prediction is
    calculated in the same way as for encoding.  Raw refers to the
    bytes already decoded, and Prior refers to the decoded bytes of
    the prior scanline.


6.6. Filter type 4: Paeth

    The Paeth filter computes a simple linear function of the three
    neighboring pixels (left, above, upper left), then chooses as
    predictor the neighboring pixel closest to the computed value.
    This technique is due to Alan W. Paeth [PAETH].

    To compute the Paeth filter, apply the following formula to each
    byte of the scanline:

        Paeth(x) = Raw(x) - PaethPredictor(Raw(x-bpp), Prior(x), Prior(x-bpp))

    where x ranges from zero to the number of bytes representing the
    scanline minus one, Raw(x) refers to the raw data byte at that
    byte position in the scanline, Prior(x) refers to the unfiltered
    bytes of the prior scanline, and bpp is defined as for the Sub
    filter.

    Note this is done for each byte, regardless of bit depth.
    Unsigned arithmetic modulo 256 is used, so that both the inputs
    and outputs fit into bytes.  The sequence of Paeth values is
    transmitted as the filtered scanline.

    The PaethPredictor function is defined by the following
    pseudocode:

        function PaethPredictor (a, b, c)
        begin
            ; a = left, b = above, c = upper left
            p := a + b - c        ; initial estimate
            pa := abs(p - a)      ; distances to a, b, c
            pb := abs(p - b)
            pc := abs(p - c)
            ; return nearest of a,b,c,
            ; breaking ties in order a,b,c.
            if pa <= pb AND pa <= pc then return a
            else if pb <= pc then return b
            else return c
        end

    The calculations within the PaethPredictor function must be
    performed exactly, without overflow.  Arithmetic modulo 256 is to
    be used only for the final step of subtracting the function result
    from the target byte value.

    Note that the order in which ties are broken is critical and must
    not be altered.  The tie break order is: pixel to the left, pixel
    above, pixel to the upper left.  (This order differs from that
    given in Paeth's article.)

    For all x < 0, assume Raw(x) = 0 and Prior(x) = 0.  On the first
    scanline of an image (or of a pass of an interlaced image), assume
    Prior(x) = 0 for all x.

    To reverse the effect of the Paeth filter after decompression,
    output the following value:

        Paeth(x) + PaethPredictor(Raw(x-bpp), Prior(x), Prior(x-bpp))

    (computed mod 256), where Raw and Prior refer to bytes already
    decoded.  Exactly the same PaethPredictor function is used by both
    encoder and decoder.
