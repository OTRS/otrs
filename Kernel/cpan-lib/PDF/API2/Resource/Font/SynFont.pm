package PDF::API2::Resource::Font::SynFont;

use base 'PDF::API2::Resource::Font';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use Math::Trig;
use Unicode::UCD 'charinfo';

use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;

=head1 NAME

PDF::API2::Resource::Font::SynFont - Module for using synthetic Fonts.

=head1 SYNOPSIS

    #
    use PDF::API2;
    #
    $pdf = PDF::API2->new;
    $sft = $pdf->synfont($cft);
    #

=head1 METHODS

=over 4

=cut

=item $font = PDF::API2::Resource::Font::SynFont->new $pdf, $fontobj, %options

Returns a synfont object.

=cut

=pod

Valid %options are:

I<-encode>
... changes the encoding of the font from its default.
See I<perl's Encode> for the supported values.

I<-pdfname>
... changes the reference-name of the font from its default.
The reference-name is normally generated automatically and can be
retrieved via $pdfname=$font->name.

I<-slant>
... slant/expansion factor (0.1-0.9 = slant, 1.1+ = expansion).

I<-oblique>
... italic angle (+/-)

I<-bold>
... embolding factor (0.1+, bold=1, heavy=2, ...).

I<-space>
... additional charspacing in em (0-1000).

I<-caps>
... create synthetic small-caps.

=back

=cut

sub new
{
    my ($class,$pdf,$font,@opts) = @_;
    my ($self,$data);
    my %opts=@opts;
    my $first=1;
    my $last=255;
    my $slant=$opts{-slant}||1;
    my $oblique=$opts{-oblique}||0;
    my $space=$opts{-space}||'0';
    my $bold=($opts{-bold}||0)*10; # convert to em

    $self->{' slant'}=$slant;
    $self->{' oblique'}=$oblique;
    $self->{' bold'}=$bold;
    $self->{' boldmove'}=0.001;
    $self->{' space'}=$space;

    $class = ref $class if ref $class;
    $self = $class->SUPER::new($pdf,
        pdfkey()
        .'+'.($font->name)
        .($opts{-caps} ? '+Caps' : '')
        .($opts{-vname} ? '+'.$opts{-vname} : '')
    );
    $pdf->new_obj($self) unless($self->is_obj($pdf));
    $self->{' font'}=$font;
    $self->{' data'}={
        'type' => 'Type3',
        'ascender' => $font->ascender,
        'capheight' => $font->capheight,
        'descender' => $font->descender,
        'iscore' => '0',
        'isfixedpitch' => $font->isfixedpitch,
        'italicangle' => $font->italicangle + $oblique,
        'missingwidth' => $font->missingwidth * $slant,
        'underlineposition' => $font->underlineposition,
        'underlinethickness' => $font->underlinethickness,
        'xheight' => $font->xheight,
        'firstchar' => $first,
        'lastchar' => $last,
        'char' => [ '.notdef' ],
        'uni' => [ 0 ],
        'u2e' => { 0 => 0 },
        'fontbbox' => '',
        'wx' => { 'space' => '600' },
    };

    if(ref($font->fontbbox))
    {
        $self->data->{fontbbox}=[ @{$font->fontbbox} ];
    }
    else
    {
        $self->data->{fontbbox}=[ $font->fontbbox ];
    }
    $self->data->{fontbbox}->[0]*=$slant;
    $self->data->{fontbbox}->[2]*=$slant;

    $self->{'Subtype'} = PDFName('Type3');
    $self->{'FirstChar'} = PDFNum($first);
    $self->{'LastChar'} = PDFNum($last);
    $self->{'FontMatrix'} = PDFArray(map { PDFNum($_) } ( 0.001, 0, 0, 0.001, 0, 0 ) );
    $self->{'FontBBox'} = PDFArray(map { PDFNum($_) } ( $self->fontbbox ) );

    my $procs=PDFDict();
    $pdf->new_obj($procs);
    $self->{'CharProcs'} = $procs;

    $self->{Resources}=PDFDict();
    $self->{Resources}->{ProcSet}=PDFArray(map { PDFName($_) } qw[ PDF Text ImageB ImageC ImageI ]);
    my $xo=PDFDict();
    $self->{Resources}->{Font}=$xo;
    $self->{Resources}->{Font}->{FSN}=$font;
    foreach my $w ($first..$last)
    {
        $self->data->{char}->[$w]=$font->glyphByEnc($w);
        $self->data->{uni}->[$w]=uniByName($self->data->{char}->[$w]);
        $self->data->{u2e}->{$self->data->{uni}->[$w]}=$w;
    }

    if($font->isa('PDF::API2::Resource::CIDFont'))
    {
      $self->{'Encoding'}=PDFDict();
      $self->{'Encoding'}->{Type}=PDFName('Encoding');
      $self->{'Encoding'}->{Differences}=PDFArray();
      foreach my $w ($first..$last)
      {
          if(defined $self->data->{char}->[$w] && $self->data->{char}->[$w] ne '.notdef')
          {
            $self->{'Encoding'}->{Differences}->add_elements(PDFNum($w),PDFName($self->data->{char}->[$w]));
          }
      }
    }
    else
    {
      $self->{'Encoding'}=$font->{Encoding};
    }

    my @widths=();
    foreach my $w ($first..$last)
    {
        if($self->data->{char}->[$w] eq '.notdef')
        {
            push @widths,$self->missingwidth;
            next;
        }
        my $char=PDFDict();
        my $wth=int($font->width(chr($w))*1000*$slant+2*$space);
        $procs->{$font->glyphByEnc($w)}=$char;
        #$char->{Filter}=PDFArray(PDFName('FlateDecode'));
        $char->{' stream'}=$wth." 0 ".join(' ',map { int($_) } $self->fontbbox)." d1\n";
        $char->{' stream'}.="BT\n";
        $char->{' stream'}.=join(' ',1,0,tan(deg2rad($oblique)),1,0,0)." Tm\n" if($oblique);
        $char->{' stream'}.="2 Tr ".($bold)." w\n" if($bold);
        # my $ci = charinfo($self->data->{uni}->[$w]);
        my $ci={};
  		if ($self->data->{uni}->[$w] ne '')
  		{
    		$ci = charinfo($self->data->{uni}->[$w]);
  		}
        if($opts{-caps} && $ci->{upper})
        {
            $char->{' stream'}.="/FSN 800 Tf\n";
            $char->{' stream'}.=($slant*110)." Tz\n";
            $char->{' stream'}.=" [ -$space ] TJ\n" if($space);
            my $ch=$self->encByUni(hex($ci->{upper}));
            $wth=int($font->width(chr($ch))*800*$slant*1.1+2*$space);
            $char->{' stream'}.=$font->text(chr($ch));
        }
        else
        {
            $char->{' stream'}.="/FSN 1000 Tf\n";
            $char->{' stream'}.=($slant*100)." Tz\n" if($slant!=1);
            $char->{' stream'}.=" [ -$space ] TJ\n" if($space);
            $char->{' stream'}.=$font->text(chr($w));
        }
        $char->{' stream'}.=" Tj\nET\n";
        push @widths,$wth;
        $self->data->{wx}->{$font->glyphByEnc($w)}=$wth;
        $pdf->new_obj($char);
    }

    $procs->{'.notdef'}=$procs->{$font->data->{char}->[32]};
    $self->{Widths}=PDFArray(map { PDFNum($_) } @widths);
    $self->data->{e2n}=$self->data->{char};
    $self->data->{e2u}=$self->data->{uni};

    $self->data->{u2c}={};
    $self->data->{u2e}={};
    $self->data->{u2n}={};
    $self->data->{n2c}={};
    $self->data->{n2e}={};
    $self->data->{n2u}={};

    foreach my $n (reverse 0..255)
    {
        $self->data->{n2c}->{$self->data->{char}->[$n] || '.notdef'}=$n unless(defined $self->data->{n2c}->{$self->data->{char}->[$n] || '.notdef'});
        $self->data->{n2e}->{$self->data->{e2n}->[$n] || '.notdef'}=$n unless(defined $self->data->{n2e}->{$self->data->{e2n}->[$n] || '.notdef'});

        $self->data->{n2u}->{$self->data->{e2n}->[$n] || '.notdef'}=$self->data->{e2u}->[$n] unless(defined $self->data->{n2u}->{$self->data->{e2n}->[$n] || '.notdef'});
        $self->data->{n2u}->{$self->data->{char}->[$n] || '.notdef'}=$self->data->{uni}->[$n] unless(defined $self->data->{n2u}->{$self->data->{char}->[$n] || '.notdef'});

        $self->data->{u2c}->{$self->data->{uni}->[$n]}=$n unless(defined $self->data->{u2c}->{$self->data->{uni}->[$n]});
        $self->data->{u2e}->{$self->data->{e2u}->[$n]}=$n unless(defined $self->data->{u2e}->{$self->data->{e2u}->[$n]});

        $self->data->{u2n}->{$self->data->{e2u}->[$n]}=($self->data->{e2n}->[$n] || '.notdef') unless(defined $self->data->{u2n}->{$self->data->{e2u}->[$n]});
        $self->data->{u2n}->{$self->data->{uni}->[$n]}=($self->data->{char}->[$n] || '.notdef') unless(defined $self->data->{u2n}->{$self->data->{uni}->[$n]});
    }

    return($self);
}

1;
