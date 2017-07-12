package PDF::API2::Resource::BaseFont;

use base 'PDF::API2::Resource';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use Compress::Zlib;
use Encode qw(:all);
use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;
use Scalar::Util qw(weaken);

=head1 NAME

PDF::API2::Resource::BaseFont - Base class for font resources

=head1 METHODS

=over

=item $font = PDF::API2::Resource::BaseFont->new $pdf, $name

Returns a font resource object.

=cut

sub new {
    my ($class,$pdf,$name) = @_;
    my $self;

    $class = ref $class if ref $class;
    $self=$class->SUPER::new($pdf,$name);

    $pdf->new_obj($self) unless($self->is_obj($pdf));

    $self->{Type} = PDFName('Font');

    $self->{' apipdf'}=$pdf;
    weaken $self->{' apipdf'};
    return($self);
}

sub data { return( $_[0]->{' data'} ); }

=item $descriptor = $font->descrByData()

Returns the font's FontDescriptor key-structure based on the font's data.

=cut

sub descrByData {
    my $self=shift @_;

    my $des=PDFDict();
    $self->{' apipdf'}->new_obj($des);

    ### $self->{'FontDescriptor'}=$des;

    $des->{'Type'}=PDFName('FontDescriptor');
    $des->{'FontName'}=PDFName($self->fontname);

    my @w = map { PDFNum($_ || 0) } $self->fontbbox;
    $des->{'FontBBox'}=PDFArray(@w);

 #   unless($self->issymbol) {
        $des->{'Ascent'}=PDFNum($self->ascender || 0);
        $des->{'Descent'}=PDFNum($self->descender || 0);
        $des->{'ItalicAngle'}=PDFNum($self->italicangle || 0.0);
        $des->{'XHeight'}=PDFNum($self->xheight || (($self->fontbbox)[3]*0.5) || 500);
        $des->{'CapHeight'}=PDFNum($self->capheight || ($self->fontbbox)[3] || 800);
        $des->{'StemV'}=PDFNum($self->stemv || 0);
        $des->{'StemH'}=PDFNum($self->stemh || 0);
        $des->{'AvgWidth'}=PDFNum($self->avgwidth || 300);
        $des->{'MissingWidth'}=PDFNum($self->missingwidth || 300);
        $des->{'MaxWidth'}=PDFNum($self->maxwidth || $self->missingwidth || ($self->fontbbox)[2]);
        $des->{'Flags'}=PDFNum($self->flags || 0) unless($self->data->{iscore});
        if(defined $self->data->{panose}) {
            $des->{Style}=PDFDict();
            $des->{Style}->{Panose}=PDFStrHex($self->data->{panose});
        }
        $des->{FontFamily}=PDFStr($self->data->{fontfamily})
            if(defined $self->data->{fontfamily});
        $des->{FontWeight}=PDFNum($self->data->{fontweight})
            if(defined $self->data->{fontweight});
        $des->{FontStretch}=PDFName($self->data->{fontstretch})
            if(defined $self->data->{fontstretch});
 #   }

    return($des);
}

sub tounicodemap {
    my $self=shift @_;

    return($self) if(defined $self->{ToUnicode});

    my $cmap=qq|\%\% Custom\n\%\% CMap\n\%\%\n/CIDInit /ProcSet findresource begin\n|;
    $cmap.=qq|12 dict begin begincmap\n|;
    $cmap.=qq|/CIDSystemInfo <<\n|;
    $cmap.=sprintf(qq|   /Registry (%s)\n|,$self->name);
    $cmap.=qq|   /Ordering (XYZ)\n|;
    $cmap.=qq|   /Supplement 0\n|;
    $cmap.=qq|>> def\n|;
    $cmap.=sprintf(qq|/CMapName /pdfapi2-%s+0 def\n|,$self->name);
    if($self->can('uniByCId') and $self->can('glyphNum')) {
        # this is a type0 font
        $cmap.=sprintf(qq|1 begincodespacerange <0000> <%04X> endcodespacerange\n|,$self->glyphNum-1);
        for(my $j=0;$j<$self->glyphNum;$j++) {
            my $i = $self->glyphNum - $j > 100 ? 100 : $self->glyphNum - $j;
            if($j==0) {
                $cmap.=qq|$i beginbfrange\n|;
            } elsif($j%100 == 0) {
                $cmap.=qq|endbfrange\n|;
                $cmap.=qq|$i beginbfrange\n|;
            }
            $cmap.=sprintf(qq|<%04x> <%04x> <%04x>\n|,$j,$j,$self->uniByCId($j));
        }
        $cmap.="endbfrange\n";
    } else {
        # everything else is single byte font
        $cmap.=qq|1 begincodespacerange\n<00> <FF>\nendcodespacerange\n|;
        $cmap.=qq|256 beginbfchar\n|;
        for(my $j=0; $j<256;$j++) {
            $cmap.=sprintf(qq|<%02X> <%04X>\n|,$j,$self->uniByEnc($j));
        }
        $cmap.=qq|endbfchar\n|;
    }
    $cmap.=qq|endcmap CMapName currendict /CMap defineresource pop end end\n|;

    my $tuni=PDFDict();
    $tuni->{Type}=PDFName('CMap');
    $tuni->{CMapName}=PDFName(sprintf(qq|pdfapi2-%s+0|,$self->name));
    $tuni->{CIDSystemInfo}=PDFDict();
    $tuni->{CIDSystemInfo}->{Registry}=PDFStr($self->name);
    $tuni->{CIDSystemInfo}->{Ordering}=PDFStr('XYZ');
    $tuni->{CIDSystemInfo}->{Supplement}=PDFNum(0);

    $self->{' apipdf'}->new_obj($tuni);
    $tuni->{' nofilt'}=1;
    $tuni->{' stream'}=Compress::Zlib::compress($cmap);
    $tuni->{Filter}=PDFArray(PDFName('FlateDecode'));
    $self->{ToUnicode}=$tuni;
    return($self);
}


=back

=head1 FONT-MANAGEMENT RELATED METHODS

=over

=item $name = $font->fontname()

Returns the font's name (aka. display-name).

=cut

sub fontname { return( $_[0]->data->{fontname} ); }

=item $name = $font->altname()

Returns the font's alternative-name (aka. windows-name for a postscript font).

=cut

sub altname { return( $_[0]->data->{altname} ); }

=item $name = $font->subname()

Returns the font's subname (aka. font-variant, schriftschnitt).

=cut

sub subname { return( $_[0]->data->{subname} ); }

=item $name = $font->apiname()

Returns the font's name to be used internally (should be equal to $font->name).

=cut

sub apiname { return( $_[0]->data->{apiname} ); }

=item $issymbol = $font->issymbol()

Returns the font's symbol flag.

=cut

sub issymbol { return( $_[0]->data->{issymbol} ); }

=item $iscff = $font->iscff()

Returns the font's compact-font-format flag.

=cut

sub iscff { return( $_[0]->data->{iscff} ); }

=back

=head1 TYPOGRAPHY RELATED METHODS

=over

=item ($llx, $lly, $urx, $ury) = $font->fontbbox()

Returns the font's bounding-box.

=cut

sub fontbbox { return( @{$_[0]->data->{fontbbox}} ); }

=item $capheight = $font->capheight()

Returns the font's capheight value.

=cut

sub capheight { return( $_[0]->data->{capheight} ); }

=item $xheight = $font->xheight()

Returns the font's xheight value.

=cut

sub xheight { return( $_[0]->data->{xheight} ); }

=item $missingwidth = $font->missingwidth()

Returns the font's missingwidth value.

=cut

sub missingwidth { return( $_[0]->data->{missingwidth} ); }

=item $maxwidth = $font->maxwidth()

Returns the font's maxwidth value.

=cut

sub maxwidth { return( $_[0]->data->{maxwidth} ); }

=item $avgwidth = $font->avgwidth()

Returns the font's avgwidth value.

=cut

sub avgwidth {
    my ($self) = @_;
    my $aw=$self->data->{avgwidth};
    $aw||=((
        $self->wxByGlyph('a')*64  +
        $self->wxByGlyph('b')*14  +
        $self->wxByGlyph('c')*27  +
        $self->wxByGlyph('d')*35  +
        $self->wxByGlyph('e')*100 +
        $self->wxByGlyph('f')*20  +
        $self->wxByGlyph('g')*14  +
        $self->wxByGlyph('h')*42  +
        $self->wxByGlyph('i')*63  +
        $self->wxByGlyph('j')* 3  +
        $self->wxByGlyph('k')* 6  +
        $self->wxByGlyph('l')*35  +
        $self->wxByGlyph('m')*20  +
        $self->wxByGlyph('n')*56  +
        $self->wxByGlyph('o')*56  +
        $self->wxByGlyph('p')*17  +
        $self->wxByGlyph('q')* 4  +
        $self->wxByGlyph('r')*49  +
        $self->wxByGlyph('s')*56  +
        $self->wxByGlyph('t')*71  +
        $self->wxByGlyph('u')*31  +
        $self->wxByGlyph('v')*10  +
        $self->wxByGlyph('w')*18  +
        $self->wxByGlyph('x')* 3  +
        $self->wxByGlyph('y')*18  +
        $self->wxByGlyph('z')* 2  +
        $self->wxByGlyph('A')*64  +
        $self->wxByGlyph('B')*14  +
        $self->wxByGlyph('C')*27  +
        $self->wxByGlyph('D')*35  +
        $self->wxByGlyph('E')*100 +
        $self->wxByGlyph('F')*20  +
        $self->wxByGlyph('G')*14  +
        $self->wxByGlyph('H')*42  +
        $self->wxByGlyph('I')*63  +
        $self->wxByGlyph('J')* 3  +
        $self->wxByGlyph('K')* 6  +
        $self->wxByGlyph('L')*35  +
        $self->wxByGlyph('M')*20  +
        $self->wxByGlyph('N')*56  +
        $self->wxByGlyph('O')*56  +
        $self->wxByGlyph('P')*17  +
        $self->wxByGlyph('Q')* 4  +
        $self->wxByGlyph('R')*49  +
        $self->wxByGlyph('S')*56  +
        $self->wxByGlyph('T')*71  +
        $self->wxByGlyph('U')*31  +
        $self->wxByGlyph('V')*10  +
        $self->wxByGlyph('W')*18  +
        $self->wxByGlyph('X')* 3  +
        $self->wxByGlyph('Y')*18  +
        $self->wxByGlyph('Z')* 2  +
        $self->wxByGlyph('space')*332
    ) / 2000);
    return( int($aw) );
}

=item $flags = $font->flags()

Returns the font's flags value.

=cut

sub flags { return( $_[0]->data->{flags} ); }

=item $stemv = $font->stemv()

Returns the font's stemv value.

=cut

sub stemv { return( $_[0]->data->{stemv} ); }

=item $stemh = $font->stemh()

Returns the font's stemh value.

=cut

sub stemh { return( $_[0]->data->{stemh} ); }

=item $italicangle = $font->italicangle()

Returns the font's italicangle value.

=cut

sub italicangle { return( $_[0]->data->{italicangle} ); }

=item $isfixedpitch = $font->isfixedpitch()

Returns the font's isfixedpitch flag.

=cut

sub isfixedpitch { return( $_[0]->data->{isfixedpitch} ); }

=item $underlineposition = $font->underlineposition()

Returns the font's underlineposition value.

=cut

sub underlineposition { return( $_[0]->data->{underlineposition} ); }

=item $underlinethickness = $font->underlinethickness()

Returns the font's underlinethickness value.

=cut

sub underlinethickness { return( $_[0]->data->{underlinethickness} ); }

=item $ascender = $font->ascender()

Returns the font's ascender value.

=cut

sub ascender { return( $_[0]->data->{ascender} ); }

=item $descender = $font->descender()

Returns the font's descender value.

=cut

sub descender { return( $_[0]->data->{descender} ); }

=back

=head1 GLYPH RELATED METHODS

=over 4

=item @names = $font->glyphNames()

Returns the defined glyph-names of the font.

=cut

sub glyphNames { return ( keys %{$_[0]->data->{wx}} ); }

=item $glNum = $font->glyphNum()

Returns the number of defined glyph-names of the font.

=cut

sub glyphNum { return ( scalar keys %{$_[0]->data->{wx}} ); }

=item $uni = $font->uniByGlyph $char

Returns the unicode by glyph-name.

=cut

sub uniByGlyph { return( $_[0]->data->{n2u}->{$_[1]} ); }

=item $uni = $font->uniByEnc $char

Returns the unicode by the fonts encoding map.

=cut

sub uniByEnc { return($_[0]->data->{e2u}->[$_[1]] ); }

=item $uni = $font->uniByMap $char

Returns the unicode by the fonts default map.

=cut

sub uniByMap { return($_[0]->data->{uni}->[$_[1]]); }

=item $char = $font->encByGlyph $glyph

Returns the character by the given glyph-name of the fonts encoding map.

=cut

sub encByGlyph { return( $_[0]->data->{n2e}->{$_[1]} || 0 ); }

=item $char = $font->encByUni $uni

Returns the character by the given unicode of the fonts encoding map.

=cut

sub encByUni { return( $_[0]->data->{u2e}->{$_[1]} || $_[0]->data->{u2c}->{$_[1]} || 0 ); }

=item $char = $font->mapByGlyph $glyph

Returns the character by the given glyph-name of the fonts default map.

=cut

sub mapByGlyph { return( $_[0]->data->{n2c}->{$_[1]} || 0 ); }

=item $char = $font->mapByUni $uni

Returns the character by the given unicode of the fonts default map.

=cut

sub mapByUni { return( $_[0]->data->{u2c}->{$_[1]} || 0 ); }

=item $name = $font->glyphByUni $unicode

Returns the glyph's name by the fonts unicode map.
B<BEWARE:> non-standard glyph-names are mapped onto
the ms-symbol area (0xF000).

=cut

sub glyphByUni { return ( $_[0]->data->{u2n}->{$_[1]} || '.notdef' ); }

=item $name = $font->glyphByEnc $char

Returns the glyph's name by the font's encoding map.

=cut

sub glyphByEnc {
    my ($self,$e)=@_;
    my $g=$self->data->{e2n}->[$e];
    return( $g );
}

=item $name = $font->glyphByMap $char

Returns the glyph's name by the font's default map.

=cut

sub glyphByMap { return ( $_[0]->data->{char}->[$_[1]] ); }

=item $width = $font->wxByGlyph $glyph

Returns the glyph's width.

=cut

sub wxByGlyph
{
    my $self=shift;
    my $val=shift;
    my $ret=undef;
    if(ref($self->data->{wx}) eq 'HASH')
    {
    	$ret=$self->data->{wx}->{$val};
    	if(!defined($ret))
    	{
    		$ret=$self->missingwidth;
    	}
    	if(!defined($ret))
    	{
    		$ret=300;
    	}
    }
    else
    {
    	my $cid=$self->cidByUni(uniByName($val));
    	$ret=$self->data->{wx}->[$cid];
    	if(!defined($ret))
    	{
    		$ret=$self->missingwidth;
    	}
    	if(!defined($ret))
    	{
    		$ret=300;
    	}
    }
    return $ret;
}

=item $width = $font->wxByUni $uni

Returns the unicode's width.

=cut

sub wxByUni
{
    my $self=shift;
    my $val=shift;
    my $gid=$self->glyphByUni($val);
    my $ret=$self->data->{wx}->{$gid};
   	if(!defined($ret))
   	{
   		$ret=$self->missingwidth;
   	}
   	if(!defined($ret))
   	{
   		$ret=300;
   	}
    return $ret;
}

=item $width = $font->wxByEnc $char

Returns the character's width based on the current encoding.

=cut

sub wxByEnc
{
    my ($self,$e)=@_;
    my $g=$self->glyphByEnc($e);
    my $ret=$self->data->{wx}->{$g};
   	if(!defined($ret))
   	{
   		$ret=$self->missingwidth;
   	}
   	if(!defined($ret))
   	{
   		$ret=300;
   	}
    return $ret;
}

=item $width = $font->wxByMap $char

Returns the character's width based on the font's default encoding.

=cut

sub wxByMap
{
    my ($self,$m)=@_;
    my $g=$self->glyphByMap($m);
    my $ret=$self->data->{wx}->{$g};
   	if(!defined($ret))
   	{
   		$ret=$self->missingwidth;
   	}
   	if(!defined($ret))
   	{
   		$ret=300;
   	}
    return $ret;
}

=item $wd = $font->width $text

Returns the width of $text as if it were at size 1.
B<BEWARE:> works only correctly if a proper perl-string
is used either in native or utf8 format (check utf8-flag).

=cut

sub width {
    my ($self,$text)=@_;
    my $width=0;
    my @widths_cache;
    if(is_utf8($text)) {
        $text=$self->strByUtf($text)
    }

    my $kern = $self->{-dokern} && ref($self->data->{kern});
    my $lastglyph='';
    foreach my $n (unpack('C*',$text))
    {
        $widths_cache[$n] = $self->wxByEnc($n) unless defined $widths_cache[$n];
        $width += $widths_cache[$n];
        if ($kern)
        {
            $width+=$self->data->{kern}->{$lastglyph.':'.$self->data->{e2n}->[$n]};
            $lastglyph=$self->data->{e2n}->[$n];
        }
    }
    $width/=1000;
    return($width);
}

=item @widths = $font->width_array $text

Returns the widths of the words in $text as if they were at size 1.

=cut

sub width_array {
    my ($self,$text)=@_;
    if(!is_utf8($text)) {
        $text=$self->utfByStr($text);
    }
    my @text=split(/\s+/,$text);
    my @widths=map { $self->width($_) } @text;
    return(@widths);
}

=back

=head1 STRING METHODS

=over

=item $utf8string = $font->utfByStr $string

Returns the utf8-string from string based on the fonts encoding map.

=cut

sub utfByStr {
    my ($self,$s)=@_;
    $s=pack('U*',map { $self->uniByEnc($_) } unpack('C*',$s));
    utf8::upgrade($s);
    return($s);
}

=item $string = $font->strByUtf $utf8string

Returns the encoded string from utf8-string based on the font's encoding map.

=cut

sub strByUtf {
    my ($self,$s)=@_;
    $s=pack('C*',map { $self->encByUni($_) & 0xFF } unpack('U*',$s));
    utf8::downgrade($s);
    return($s);
}

=item $pdfstring = $font->textByStr $text

Returns a properly formatted representation of $text for use in the PDF.

=cut

sub textByStr
{
    my ($self,$text)=@_;
    my $newtext='';
    if(is_utf8($text))
    {
        $text=$self->strByUtf($text);
    }
    $newtext=$text;
    $newtext=~s/\\/\\\\/go;
    $newtext=~s/([\x00-\x1f])/sprintf('\%03lo',ord($1))/ge;
    $newtext=~s/([\{\}\[\]\(\)])/\\$1/g;
    return($newtext);
}

sub textByStrKern
{
    my ($self,$text)=@_;
    if($self->{-dokern} && ref($self->data->{kern}))
    {
        my $newtext=' ';
        if(is_utf8($text))
        {
            $text=$self->strByUtf($text);
        }

        my $lastglyph='';
        my $tBefore=0;
        foreach my $n (unpack('C*',$text))
        {
            if(defined $self->data->{kern}->{$lastglyph.':'.$self->data->{e2n}->[$n]})
            {
                $newtext.=') ' if($tBefore);
                $newtext.=sprintf('%i ',-($self->data->{kern}->{$lastglyph.':'.$self->data->{e2n}->[$n]}));
                $tBefore=0;
            }
            $lastglyph=$self->data->{e2n}->[$n];
            my $t=pack('C',$n);
            $t=~s/\\/\\\\/go;
            $t=~s/([\x00-\x1f])/sprintf('\%03lo',ord($1))/ge;
            $t=~s/([\{\}\[\]\(\)])/\\$1/g;
            $newtext.='(' if(!$tBefore);
            $newtext.="$t";
            $tBefore=1;
        }
        $newtext.=') ' if($tBefore);
        return($newtext);
    }
    else
    {
        return('('.$self->textByStr($text).')');
    }
}

sub text
{
    my ($self,$text,$size,$ident)=@_;

    my $newtext=$self->textByStr($text);

    if(defined $size && $self->{-dokern})
    {
        $newtext=$self->textByStrKern($text);
        if(defined($ident) && $ident!=0)
        {
	        return("[ $ident $newtext ] TJ");
        }
        else
        {
	        return("[ $newtext ] TJ");
        }
    }
    elsif(defined $size)
    {
        if(defined($ident) && $ident!=0)
        {
	        return("[ $ident ($newtext) ] TJ");
        }
        else
        {
	        return("[ ($newtext) ] TJ");
        }
    }
    else
    {
        return("($newtext)");
    }
}

sub isvirtual { return(0); }

=back

=cut

1;
