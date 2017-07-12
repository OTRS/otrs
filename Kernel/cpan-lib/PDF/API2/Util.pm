package PDF::API2::Util;

use strict;
no warnings qw[ recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

BEGIN {
    use Encode qw(:all);
    use Math::Trig;
    use List::Util qw(min max);
    use PDF::API2::Basic::PDF::Utils;
    use PDF::API2::Basic::PDF::Filter;
    use PDF::API2::Resource::Colors;
    use PDF::API2::Resource::Glyphs;
    use PDF::API2::Resource::PaperSizes;
    use POSIX qw( HUGE_VAL floor );

    use vars qw(
        @ISA
        @EXPORT
        @EXPORT_OK
        %colors
        $key_var
        %u2n
        %n2u
        $pua
        %PaperSizes
    );

    use Exporter;
    @ISA = qw(Exporter);
    @EXPORT = qw(
        pdfkey
        float floats floats5 intg intgs
        mMin mMax
        HSVtoRGB RGBtoHSV HSLtoRGB RGBtoHSL RGBtoLUM
        namecolor namecolor_cmyk namecolor_lab optInvColor defineColor
        dofilter unfilter
        nameByUni uniByName initNameTable defineName
        page_size
        getPaperSizes
    );
    @EXPORT_OK = qw(
        pdfkey
        digest digestx digest16 digest32
        float floats floats5 intg intgs
        mMin mMax
        cRGB cRGB8 RGBasCMYK
        HSVtoRGB RGBtoHSV HSLtoRGB RGBtoHSL RGBtoLUM
        namecolor namecolor_cmyk namecolor_lab optInvColor defineColor
        dofilter unfilter
        nameByUni uniByName initNameTable defineName
        page_size
    );

    %colors = PDF::API2::Resource::Colors->get_colors();
    %PaperSizes = PDF::API2::Resource::PaperSizes->get_paper_sizes();

    no warnings qw[ recursion uninitialized ];

    $key_var = 'CBA';

    $pua = 0xE000;

    %u2n = %{$PDF::API2::Resource::Glyphs::u2n};
    %n2u = %{$PDF::API2::Resource::Glyphs::n2u};
}

sub pdfkey {
    return $PDF::API2::Util::key_var++;
}

sub digestx {
    my $len = shift();
    my $mask = $len - 1;
    my $ddata = join('', @_);
    my $mdkey = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789gT';
    my $xdata = '0' x $len;
    my $off = 0;
    foreach my $set (0 .. (length($ddata) << 1)) {
        $off += vec($ddata, $set, 4);
        $off += vec($xdata, ($set & $mask), 8);
        vec($xdata, ($set & ($mask << 1 | 1)), 4) = vec($mdkey, ($off & 0x7f), 4);
    }

    # foreach $set (0 .. $mask) {
    #     vec($xdata, $set, 8) = (vec($xdata, $set, 8) & 0x7f) | 0x40;
    # }

    # $off = 0;
    # foreach $set (0 .. $mask) {
    #     $off += vec($xdata, $set, 8);
    #     vec($xdata, $set, 8) = vec($mdkey, ($off & 0x3f), 8);
    # }

    return $xdata;
}

sub digest {
    return digestx(32, @_);
}

sub digest16 {
    return digestx(16, @_);
}

sub digest32 {
    return digestx(32, @_);
}

sub xlog10 {
    my $n = shift();
    if ($n) {
        return log(abs($n)) / log(10);
    }
    else {
        return 0;
    }
}

sub float {
    my $f = shift();
    my $mxd = shift() || 4;
    $f = 0 if abs($f) < 0.0000000000000001;
    my $ad = floor(xlog10($f) - $mxd);
    if (abs($f - int($f)) < (10 ** (-$mxd))) {
        # just in case we have an integer
        return sprintf('%i', $f);
    }
    elsif ($ad > 0) {
        my $value = sprintf('%f', $f);
        # Remove trailing zeros
        $value =~ s/(\.\d*?)0+$/$1/;
        $value =~ s/\.$//;
        return $value;
    }
    else {
        my $value = sprintf('%.*f', abs($ad), $f);
        # Remove trailing zeros
        $value =~ s/(\.\d*?)0+$/$1/;
        $value =~ s/\.$//;
        return $value;
    }
}
sub floats { return map { float($_) } @_; }
sub floats5 { return map { float($_, 5) } @_; }

sub intg {
    my $f = shift();
    return sprintf('%i', $f);
}
sub intgs { return map { intg($_) } @_; }

sub mMin {
    my $n = HUGE_VAL();
    map { $n = ($n > $_) ? $_ : $n } @_;
    return $n;
}

sub mMax {
    my $n = -HUGE_VAL();
    map { $n = ($n < $_) ? $_ : $n } @_;
    return $n;
}

sub cRGB {
    my @cmy = (map { 1 - $_ } @_);
    my $k = mMin(@cmy);
    return (map { $_ - $k } @cmy), $k;
}

sub cRGB8 {
    return cRGB(map { $_ / 255 } @_);
}

sub RGBtoLUM {
    my ($r, $g, $b) = @_;
    return $r * 0.299 + $g * 0.587 + $b * 0.114;
}

sub RGBasCMYK {
    my @rgb = @_;
    my @cmy = map { 1 - $_ } @rgb;
    my $k = mMin(@cmy) * 0.44;
    return (map { $_ - $k } @cmy), $k;
}

sub HSVtoRGB {
    my ($h, $s, $v) = @_;
    my ($r, $g, $b, $i, $f, $p, $q, $t);

    if ($s == 0) {
        # achromatic (grey)
        return ($v, $v, $v);
    }

    $h %= 360;
    $h /= 60;       ## sector 0 to 5
    $i = POSIX::floor($h);
    $f = $h - $i;   ## factorial part of h
    $p = $v * (1 - $s);
    $q = $v * (1 - $s * $f);
    $t = $v * (1 - $s * (1 - $f));

    if ($i < 1) {
        $r = $v;
        $g = $t;
        $b = $p;
    }
    elsif ($i < 2) {
        $r = $q;
        $g = $v;
        $b = $p;
    }
    elsif ($i < 3) {
        $r = $p;
        $g = $v;
        $b = $t;
    }
    elsif ($i < 4) {
        $r = $p;
        $g = $q;
        $b = $v;
    }
    elsif ($i < 5) {
        $r = $t;
        $g = $p;
        $b = $v;
    }
    else {
        $r = $v;
        $g = $p;
        $b = $q;
    }

    return ($r, $g, $b);
}

sub RGBquant {
    my ($q1, $q2, $h) = @_;
    while ($h < 0){
        $h += 360;
    }
    $h %= 360;
    if ($h < 60) {
        return $q1 + (($q2 - $q1) * $h / 60);
    }
    elsif ($h < 180) {
        return $q2;
    }
    elsif ($h < 240) {
        return $q1 + (($q2 - $q1) * (240 - $h) / 60);
    }
    else {
        return $q1;
    }
}

sub RGBtoHSV {
    my ($r, $g, $b) = @_;
    my ($h, $s, $v, $min, $max, $delta);

    $min = mMin($r, $g, $b);
    $max = mMax($r, $g, $b);

    $v = $max;

    $delta = $max - $min;

    if ($delta > 0.000000001) {
        $s = $delta / $max;
    }
    else {
        $s = 0;
        $h = 0;
        return ($h, $s, $v);
    }

    if ($r == $max) {
        $h = ($g - $b) / $delta;
    }
    elsif ($g == $max) {
        $h = 2 + ($b - $r) / $delta;
    }
    else {
        $h = 4 + ($r - $g) / $delta;
    }
    $h *= 60;
    if ($h < 0) {
        $h += 360;
    }
    return ($h, $s, $v);
}

sub RGBtoHSL {
    my ($r, $g, $b) = @_;
    my ($h, $s, $v, $l, $min, $max, $delta);

    $min = mMin($r, $g, $b);
    $max = mMax($r, $g, $b);
    ($h, $s, $v) = RGBtoHSV($r, $g, $b);
    $l = ($max + $min) / 2.0;
    $delta = $max - $min;
    if ($delta < 0.00000000001) {
        return (0, 0, $l);
    }
    else {
        if ($l <= 0.5) {
            $s = $delta / ($max + $min);
        }
        else {
            $s = $delta / (2 - $max - $min);
        }
    }
    return ($h, $s, $l);
}

sub HSLtoRGB {
    my ($h, $s, $l, $r, $g, $b, $p1, $p2) = @_;
    if ($l <= 0.5) {
        $p2 = $l * (1 + $s);
    }
    else {
        $p2 = $l + $s - ($l * $s);
    }
    $p1 = 2 * $l - $p2;
    if ($s < 0.0000000000001) {
        $r = $g = $b = $l;
    }
    else {
        $r = RGBquant($p1, $p2, $h + 120);
        $g = RGBquant($p1, $p2, $h);
        $b = RGBquant($p1, $p2, $h - 120);
    }
    return ($r, $g, $b);
}

sub optInvColor {
    my ($r, $g, $b) = @_;

    my $ab = (0.2 * $r) + (0.7 * $g) + (0.1 * $b);

    if ($ab > 0.45) {
        return (0, 0, 0);
    }
    else {
        return (1, 1, 1);
    }
}

sub defineColor {
    my ($name, $mx, $r, $g, $b) = @_;
    $colors{$name} ||= [ map {$_ / $mx} ($r, $g, $b) ];
    return $colors{$name};
}

sub rgbHexValues {
    my $name = lc(shift());
    my ($r, $g, $b);
    if (length($name) < 5) {     # zb. #fa4,          #cf0
        $r = hex(substr($name, 1, 1)) / 0xf;
        $g = hex(substr($name, 2, 1)) / 0xf;
        $b = hex(substr($name, 3, 1)) / 0xf;
    }
    elsif (length($name) < 8) {  # zb. #ffaa44,       #ccff00
        $r = hex(substr($name, 1, 2)) / 0xff;
        $g = hex(substr($name, 3, 2)) / 0xff;
        $b = hex(substr($name, 5, 2)) / 0xff;
    }
    elsif(length($name) < 11) {  # zb. #fffaaa444,    #cccfff000
        $r = hex(substr($name, 1, 3)) / 0xfff;
        $g = hex(substr($name, 4, 3)) / 0xfff;
        $b = hex(substr($name, 7, 3)) / 0xfff;
    }
    else {                       # zb. #ffffaaaa4444, #ccccffff0000
        $r = hex(substr($name, 1, 4)) / 0xffff;
        $g = hex(substr($name, 5, 4)) / 0xffff;
        $b = hex(substr($name, 9, 4)) / 0xffff;
    }
    return ($r, $g, $b);
}

sub cmykHexValues {
    my $name = lc(shift());
    my ($c, $m, $y, $k);
    if (length($name) < 6) {     # zb. %cmyk
        $c = hex(substr($name, 1, 1)) / 0xf;
        $m = hex(substr($name, 2, 1)) / 0xf;
        $y = hex(substr($name, 3, 1)) / 0xf;
        $k = hex(substr($name, 4, 1)) / 0xf;
    }
    elsif (length($name) < 10) { # zb. %ccmmyykk
        $c = hex(substr($name, 1, 2)) / 0xff;
        $m = hex(substr($name, 3, 2)) / 0xff;
        $y = hex(substr($name, 5, 2)) / 0xff;
        $k = hex(substr($name, 7, 2)) / 0xff;
    }
    elsif (length($name) < 14) { # zb. %cccmmmyyykkk
        $c = hex(substr($name, 1, 3)) / 0xfff;
        $m = hex(substr($name, 4, 3)) / 0xfff;
        $y = hex(substr($name, 7, 3)) / 0xfff;
        $k = hex(substr($name, 10, 3)) / 0xfff;
    }
    else {                       # zb. %ccccmmmmyyyykkkk
        $c = hex(substr($name, 1, 4)) / 0xffff;
        $m = hex(substr($name, 5, 4)) / 0xffff;
        $y = hex(substr($name, 9, 4)) / 0xffff;
        $k = hex(substr($name, 13, 4)) / 0xffff;
    }
    return ($c, $m, $y, $k);
}

sub hsvHexValues {
    my $name = lc(shift());
    my ($h, $s, $v);
    if (length($name) < 5) {
        $h = 360 * hex(substr($name, 1, 1)) / 0x10;
        $s = hex(substr($name, 2, 1)) / 0xf;
        $v = hex(substr($name, 3, 1)) / 0xf;
    }
    elsif (length($name) < 8) {
        $h = 360 * hex(substr($name, 1, 2)) / 0x100;
        $s = hex(substr($name, 3, 2)) / 0xff;
        $v = hex(substr($name, 5, 2)) / 0xff;
    }
    elsif (length($name) < 11) {
        $h = 360 * hex(substr($name, 1, 3)) / 0x1000;
        $s = hex(substr($name, 4, 3)) / 0xfff;
        $v = hex(substr($name, 7, 3)) / 0xfff;
    }
    else {
        $h = 360 * hex(substr($name, 1, 4)) / 0x10000;
        $s = hex(substr($name, 5, 4)) / 0xffff;
        $v = hex(substr($name, 9, 4)) / 0xffff;
    }
    return ($h, $s, $v);
}

sub labHexValues {
    my $name = lc(shift());
    my ($l, $a, $b);
    if (length($name) < 5) {
        $l =  100 * hex(substr($name, 1, 1)) / 0xf;
        $a = (200 * hex(substr($name, 2, 1)) / 0xf) - 100;
        $b = (200 * hex(substr($name, 3, 1)) / 0xf) - 100;
    }
    elsif (length($name) < 8) {
        $l =  100 * hex(substr($name, 1, 2)) / 0xff;
        $a = (200 * hex(substr($name, 3, 2)) / 0xff) - 100;
        $b = (200 * hex(substr($name, 5, 2)) / 0xff) - 100;
    }
    elsif (length($name) < 11) {
        $l =  100 * hex(substr($name, 1, 3)) / 0xfff;
        $a = (200 * hex(substr($name, 4, 3)) / 0xfff) - 100;
        $b = (200 * hex(substr($name, 7, 3)) / 0xfff) - 100;
    }
    else {
        $l =  100 * hex(substr($name, 1, 4)) / 0xffff;
        $a = (200 * hex(substr($name, 5, 4)) / 0xffff) - 100;
        $b = (200 * hex(substr($name, 9, 4)) / 0xffff) - 100;
    }

    return ($l, $a, $b);
}

sub namecolor {
    my $name = shift();
    unless (ref($name)) {
        $name = lc($name);
        $name =~ s/[^\#!%\&\$a-z0-9]//g;
    }
    if ($name =~ /^[a-z]/) { # name spec.
        return namecolor($colors{$name});
    }
    elsif ($name =~ /^#/) { # rgb spec.
        return floats5(rgbHexValues($name));
    }
    elsif ($name =~ /^%/) { # cmyk spec.
        return floats5(cmykHexValues($name));
    }
    elsif ($name =~ /^!/) { # hsv spec.
        return floats5(HSVtoRGB(hsvHexValues($name)));
    }
    elsif ($name =~ /^&/) { # hsl spec.
        return floats5(HSLtoRGB(hsvHexValues($name)));
    }
    else { # or it is a ref ?
        return floats5(@{$name || [0.5, 0.5, 0.5]});
    }
}

sub namecolor_cmyk {
    my $name = shift();
    unless (ref($name)) {
        $name = lc($name);
        $name =~ s/[^\#!%\&\$a-z0-9]//g;
    }
    if ($name =~ /^[a-z]/) { # name spec.
        return namecolor_cmyk($colors{$name});
    }
    elsif ($name =~ /^#/) { # rgb spec.
        return floats5(RGBasCMYK(rgbHexValues($name)));
    }
    elsif ($name =~ /^%/) { # cmyk spec.
        return floats5(cmykHexValues($name));
    }
    elsif ($name =~ /^!/) { # hsv spec.
        return floats5(RGBasCMYK(HSVtoRGB(hsvHexValues($name))));
    }
    elsif ($name =~ /^&/) { # hsl spec.
        return floats5(RGBasCMYK(HSLtoRGB(hsvHexValues($name))));
    }
    else { # or it is a ref ?
        return floats5(RGBasCMYK(@{$name || [0.5, 0.5, 0.5]}));
    }
}

sub namecolor_lab {
    my $name = shift();
    unless (ref($name)) {
        $name = lc($name);
        $name =~ s/[^\#!%\&\$a-z0-9]//g;
    }
    if ($name =~ /^[a-z]/) { # name spec.
        return namecolor_lab($colors{$name});
    }
    elsif ($name =~ /^\$/) { # lab spec.
        return floats5(labHexValues($name));
    }
    elsif ($name =~ /^#/) { # rgb spec.
        my ($h, $s, $v) = RGBtoHSV(rgbHexValues($name));
        my $a = cos(deg2rad($h)) * $s * 100;
        my $b = sin(deg2rad($h)) * $s * 100;
        my $l = 100 * $v;
        return floats5($l,$a,$b);
    }
    elsif ($name =~ /^!/) { # hsv spec.
        # fake conversion
        my ($h, $s, $v) = hsvHexValues($name);
        my $a = cos(deg2rad($h)) * $s * 100;
        my $b = sin(deg2rad($h)) * $s * 100;
        my $l = 100 * $v;
        return floats5($l,$a,$b);
    }
    elsif ($name =~ /^&/) { # hsl spec.
        my ($h, $s, $v) = hsvHexValues($name);
        my $a = cos(deg2rad($h)) * $s * 100;
        my $b = sin(deg2rad($h)) * $s * 100;
        ($h, $s, $v) = RGBtoHSV(HSLtoRGB($h, $s, $v));
        my $l = 100 * $v;
        return floats5($l,$a,$b);
    }
    else { # or it is a ref ?
        my ($h, $s, $v) = RGBtoHSV(@{$name || [0.5, 0.5, 0.5]});
        my $a = cos(deg2rad($h)) * $s * 100;
        my $b = sin(deg2rad($h)) * $s * 100;
        my $l = 100 * $v;
        return floats5($l,$a,$b);
    }
}

sub unfilter {
    my ($filter, $stream) = @_;

    if (defined $filter) {
        # we need to fix filter because it MAY be
        # an array BUT IT COULD BE only a name
        if (ref($filter) !~ /Array$/) {
            $filter = PDFArray($filter);
        }
        my @filts;
        my ($hasflate) = -1;
        my ($temp, $i, $temp1);

        @filts = map { ("PDF::API2::Basic::PDF::Filter::" . $_->val())->new() } $filter->elementsof();

        foreach my $f (@filts) {
            $stream = $f->infilt($stream, 1);
        }
    }

    return $stream;
}

sub dofilter {
    my ($filter, $stream) = @_;

    if (defined $filter) {
        # we need to fix filter because it MAY be
        # an array BUT IT COULD BE only a name
        if (ref($filter) !~ /Array$/) {
            $filter = PDFArray($filter);
        }
        my @filts;
        my $hasflate = -1;
        my ($temp, $i, $temp1);

        @filts = map { ("PDF::API2::Basic::PDF::Filter::" . $_->val())->new() } $filter->elementsof();

        foreach my $f (@filts) {
            $stream = $f->outfilt($stream, 1);
        }
    }

    return $stream;
}

sub nameByUni {
    my $e = shift();
    return $u2n{$e} || sprintf('uni%04X', $e);
}

sub uniByName {
    my $e = shift();
    if ($e =~ /^uni([0-9A-F]{4})$/) {
        return hex($1);
    }
    return $n2u{$e} || undef;
}

sub initNameTable {
    %u2n = %{$PDF::API2::Resource::Glyphs::u2n};
    %n2u = %{$PDF::API2::Resource::Glyphs::n2u};
    $pua = 0xE000;
    return;
}

sub defineName {
    my $name = shift();
    return $n2u{$name} if defined $n2u{$name};

    $pua++ while defined $u2n{$pua};

    $u2n{$pua} = $name;
    $n2u{$name} = $pua;

    return $pua;
}

sub page_size {
    my ($x1, $y1, $x2, $y2) = @_;

    # full bbox
    if (defined $x2) {
        return ($x1, $y1, $x2, $y2);
    }

    # half bbox
    elsif (defined $y1) {
        return (0, 0, $x1, $y1);
    }

    # textual spec.
    elsif (defined $PaperSizes{lc $x1}) {
        return (0, 0, @{$PaperSizes{lc $x1}});
    }

    # single quadratic
    elsif ($x1 =~ /^[\d\.]+$/) {
        return(0, 0, $x1, $x1);
    }

    # pdf default.
    else {
        return (0, 0, 612, 792);
    }
}

sub getPaperSizes {
    my %sizes = ();
    foreach my $type (keys %PaperSizes) {
        $sizes{$type} = [@{$PaperSizes{$type}}];
    }
    return %sizes;
}

1;

__END__

=head1 NAME

PDF::API2::Util - utility package for often use methods across the package.

=head1 PREDEFINED PAPERSIZES

=over 4

=item %sizes = getPaperSizes();

Returns a hash containing the available paper size aliases as keys and
their dimensions as a two-element array reference.

=back

=head1 PREDEFINED COLORS

See the source of L<PDF::API2::Resource::Colors> for a complete list.

B<Please Note:> This is an amalgamation of the X11, SGML and (X)HTML
specification sets.

=head1 PREDEFINED GLYPH-NAMES

See the file C<uniglyph.txt> for a complete list.

B<Please Note:> You may notice that apart from the 'AGL/WGL4', names
from the XML, (X)HTML and SGML specification sets have been included
to enable interoperability towards PDF.

=cut
