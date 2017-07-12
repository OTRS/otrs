package PDF::API2::Resource::CIDFont::CJKFont;

use base 'PDF::API2::Resource::CIDFont';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;

our $fonts = {};
our $cmap  = {};
our $alias;
our $subs;

=head1 NAME

PDF::API2::Resource::CIDFont::CJKFont - Base class for CJK fonts

=head1 METHODS

=over

=item $font = PDF::API2::Resource::CIDFont::CJKFont->new $pdf, $cjkname, %options

Returns a cjk-font object.

Traditional Chinese: Ming Ming-Bold Ming-Italic Ming-BoldItalic

Simplified Chinese: Song Song-Bold Song-Italic Song-BoldItalic

Korean: MyungJo MyungJo-Bold MyungJo-Italic MyungJo-BoldItalic

Japanese (Mincho): KozMin KozMin-Bold KozMin-Italic KozMin-BoldItalic

Japanese (Gothic): KozGo KozGo-Bold KozGo-Italic KozGo-BoldItalic

Defined Options:

    -encode ... specify fonts encoding for non-utf8 text.

=cut

sub _look_for_font {
    my $fname=lc(shift);
    $fname=~s/[^a-z0-9]+//gi;
    $fname=$alias->{$fname} if(defined $alias->{$fname});
    return({%{$fonts->{$fname}}}) if(defined $fonts->{$fname});

    if(defined $subs->{$fname}) {
        my $data=_look_for_font($subs->{$fname}->{-alias});
        foreach my $k (keys %{$subs->{$fname}}) {
          next if($k=~/^\-/);
          if(substr($k,0,1) eq '+')
          {
              $data->{substr($k,1)}.=$subs->{$fname}->{$k};
          }
          else
          {
              $data->{$k}=$subs->{$fname}->{$k};
          }
        }
        $fonts->{$fname}=$data;
        return({%{$data}})
    }

    eval "require 'PDF/API2/Resource/CIDFont/CJKFont/$fname.data'";
    unless($@){
        return({%{$fonts->{$fname}}});
    } else {
        die "requested font '$fname' not installed ";
    }
}

sub _look_for_cmap {
    my $fname=lc(shift);
    $fname=~s/[^a-z0-9]+//gi;
    return({%{$cmap->{$fname}}}) if(defined $cmap->{$fname});
    eval "require \"PDF/API2/Resource/CIDFont/CMap/$fname.cmap\"";
    unless($@){
        return({%{$cmap->{$fname}}});
    } else {
        die "requested cmap '$fname' not installed ";
    }
}
sub new {
    my ($class,$pdf,$name,@opts) = @_;
    my %opts=();
    %opts=@opts if((scalar @opts)%2 == 0);
    $opts{-encode}||='ident';

    my $data = _look_for_font($name);

    my $cmap = _look_for_cmap($data->{cmap});

    $data->{u2g} = { %{$cmap->{u2g}} };
    $data->{g2u} = [ @{$cmap->{g2u}} ];

    $class = ref $class if ref $class;
    my $self=$class->SUPER::new($pdf,$data->{apiname}.pdfkey());
    $pdf->new_obj($self) if(defined($pdf) && !$self->is_obj($pdf));

    $self->{' data'}=$data;

    my $des=$self->descrByData;

    my $de=$self->{' de'};

    if(defined $opts{-encode} && $opts{-encode} ne 'ident') {
        $self->data->{encode}=$opts{-encode};
    }

    my $emap={
        'reg'=>'Adobe',
        'ord'=>'Identity',
        'sup'=> 0,
        'map'=>'Identity',
        'dir'=>'H',
        'dec'=>'ident',
    };

    if(defined $cmap->{ccs}) {
        $emap->{reg}=$cmap->{ccs}->[0];
        $emap->{ord}=$cmap->{ccs}->[1];
        $emap->{sup}=$cmap->{ccs}->[2];
    }

    #if(defined $cmap->{cmap} && defined $cmap->{cmap}->{$opts{-encode}} ) {
    #    $emap->{dec}=$cmap->{cmap}->{$opts{-encode}}->[0];
    #    $emap->{map}=$cmap->{cmap}->{$opts{-encode}}->[1];
    #} elsif(defined $cmap->{cmap} && defined $cmap->{cmap}->{'utf8'} ) {
    #    $emap->{dec}=$cmap->{cmap}->{'utf8'}->[0];
    #    $emap->{map}=$cmap->{cmap}->{'utf8'}->[1];
    #}

    $self->data->{decode}=$emap->{dec};

    $self->{'BaseFont'} = PDFName($self->fontname."-$emap->{map}-$emap->{dir}");
    $self->{'Encoding'} = PDFName("$emap->{map}-$emap->{dir}");

    $de->{'FontDescriptor'} = $des;
    $de->{'Subtype'} = PDFName('CIDFontType0');
    $de->{'BaseFont'} = PDFName($self->fontname);
    $de->{'DW'} = PDFNum($self->missingwidth);
    $de->{'CIDSystemInfo'}->{Registry} = PDFStr($emap->{reg});
    $de->{'CIDSystemInfo'}->{Ordering} = PDFStr($emap->{ord});
    $de->{'CIDSystemInfo'}->{Supplement} = PDFNum($emap->{sup});
    ## $de->{'CIDToGIDMap'} = PDFName($emap->{map}); # ttf only

    return($self);
}

sub tounicodemap {
    my $self=shift @_;
    # noop since pdf knows its char-collection
    return($self);
}

sub glyphByCId
{
    my ($self,$cid)=@_;
    my $uni = $self->uniByCId($cid);
    return( nameByUni($uni) );
}

sub outobjdeep {
    my ($self, $fh, $pdf, %opts) = @_;

    my $notdefbefore=1;

    my $wx=PDFArray();
    $self->{' de'}->{'W'} = $wx;
    my $ml;

    foreach my $w (0..(scalar @{$self->data->{g2u}} - 1 )) {
        if(ref($self->data->{wx}) eq 'ARRAY'
            && (defined $self->data->{wx}->[$w])
            && ($self->data->{wx}->[$w] != $self->missingwidth)
            && $notdefbefore==1)
        {
            $notdefbefore=0;
            $ml=PDFArray();
            $wx->add_elements(PDFNum($w),$ml);
            $ml->add_elements(PDFNum($self->data->{wx}->[$w]));
        }
        elsif(ref($self->data->{wx}) eq 'HASH'
            && (defined $self->data->{wx}->{$w})
            && ($self->data->{wx}->{$w} != $self->missingwidth)
            && $notdefbefore==1)
        {
            $notdefbefore=0;
            $ml=PDFArray();
            $wx->add_elements(PDFNum($w),$ml);
            $ml->add_elements(PDFNum($self->data->{wx}->{$w}));
        }
        elsif(ref($self->data->{wx}) eq 'ARRAY'
            && (defined $self->data->{wx}->[$w])
            && ($self->data->{wx}->[$w] != $self->missingwidth)
            && $notdefbefore==0)
        {
            $notdefbefore=0;
            $ml->add_elements(PDFNum($self->data->{wx}->[$w]));
        }
        elsif(ref($self->data->{wx}) eq 'HASH'
            && (defined $self->data->{wx}->{$w})
            && ($self->data->{wx}->{$w} != $self->missingwidth)
            && $notdefbefore==0)
        {
            $notdefbefore=0;
            $ml->add_elements(PDFNum($self->data->{wx}->{$w}));
        }
        else
        {
            $notdefbefore=1;
        }
    }

    $self->SUPER::outobjdeep($fh, $pdf, %opts);
}

BEGIN {

    $alias={
        'traditional'           => 'adobemingstdlightacro',
        'traditionalbold'       => 'mingbold',
        'traditionalitalic'     => 'mingitalic',
        'traditionalbolditalic' => 'mingbolditalic',
        'ming'                  => 'adobemingstdlightacro',

        'simplified'            => 'adobesongstdlightacro',
        'simplifiedbold'        => 'songbold',
        'simplifieditalic'      => 'songitalic',
        'simplifiedbolditalic'  => 'songbolditalic',
        'song'                  => 'adobesongstdlightacro',

        'korean'                => 'adobemyungjostdmediumacro',
        'koreanbold'            => 'myungjobold',
        'koreanitalic'          => 'myungjoitalic',
        'koreanbolditalic'      => 'myungjobolditalic',
        'myungjo'               => 'adobemyungjostdmediumacro',

        'japanese'              => 'kozminproregularacro',
        'japanesebold'          => 'kozminbold',
        'japaneseitalic'        => 'kozminitalic',
        'japanesebolditalic'    => 'kozminbolditalic',
        'kozmin'                => 'kozminproregularacro',
        'kozgo'                 => 'kozgopromediumacro',

    };
    $subs={
    # Chinese Traditional (ie. Taiwan) Fonts
        'mingitalic' => {
            '-alias'            => 'adobemingstdlightacro',
            '+fontname'          => ',Italic',
        },
        'mingbold' => {
            '-alias'            => 'adobemingstdlightacro',
            '+fontname'          => ',Bold',
        },
        'mingbolditalic' => {
            '-alias'            => 'adobemingstdlightacro',
            '+fontname'          => ',BoldItalic',
        },
    # Chinese Simplified (ie. Mainland China) Fonts
        'songitalic' => {
            '-alias'            => 'adobesongstdlightacro',
            '+fontname'          => ',Italic',
        },
        'songbold' => {
            '-alias'            => 'adobesongstdlightacro',
            '+fontname'          => ',Bold',
        },
        'songbolditalic' => {
            '-alias'            => 'adobesongstdlightacro',
            '+fontname'          => ',BoldItalic',
        },
    # Japanese Gothic (ie. sans) Fonts
        'kozgoitalic' => {
            '-alias'            => 'kozgopromediumacro',
            '+fontname'          => ',Italic',
        },
        'kozgobold' => {
            '-alias'            => 'kozgopromediumacro',
            '+fontname'          => ',Bold',
        },
        'kozgobolditalic' => {
            '-alias'            => 'kozgopromediumacro',
            '+fontname'          => ',BoldItalic',
        },
    # Japanese Mincho (ie. serif) Fonts
        'kozminitalic' => {
            '-alias'            => 'kozminproregularacro',
            '+fontname'          => ',Italic',
        },
        'kozminbold' => {
            '-alias'            => 'kozminproregularacro',
            '+fontname'          => ',Bold',
        },
        'kozminbolditalic' => {
            '-alias'            => 'kozminproregularacro',
            '+fontname'          => ',BoldItalic',
        },
    # Korean Fonts
        'myungjoitalic' => {
            '-alias'            => 'adobemyungjostdmediumacro',
            '+fontname'          => ',Italic',
        },
        'myungjobold' => {
            '-alias'            => 'adobemyungjostdmediumacro',
            '+fontname'          => ',Bold',
        },
        'myungjobolditalic' => {
            '-alias'            => 'adobemyungjostdmediumacro',
            '+fontname'          => ',BoldItalic',
        },
    };

}

=back

=cut

1;
