package PDF::API2::Resource::Font::CoreFont;

use base 'PDF::API2::Resource::Font';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use File::Basename;

use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;

our $fonts;
our $alias;
our $subs;

=head1 NAME

PDF::API2::Resource::Font::CoreFont - Module for using the 14 PDF built-in Fonts.

=head1 SYNOPSIS

    #
    use PDF::API2;
    #
    $pdf = PDF::API2->new;
    $cft = $pdf->corefont('Times-Roman');
    #

=head1 METHODS

=over

=item $font = PDF::API2::Resource::Font::CoreFont->new $pdf, $fontname, %options

Returns a corefont object.

=cut

=pod

Valid %options are:

I<-encode>
... changes the encoding of the font from its default.
See I<perl's Encode> for the supported values.

I<-pdfname> ... changes the reference-name of the font from its default.
The reference-name is normally generated automatically and can be
retrieved via $pdfname=$font->name.

=cut

sub _look_for_font
{
    my $fname=shift;
    ## return(%{$fonts->{$fname}}) if(defined $fonts->{$fname});
    eval "require PDF::API2::Resource::Font::CoreFont::$fname; ";
    unless($@)
    {
        my $class = "PDF::API2::Resource::Font::CoreFont::$fname";
        $fonts->{$fname} = deep_copy($class->data());
        $fonts->{$fname}->{uni}||=[];
        foreach my $n (0..255)
        {
            $fonts->{$fname}->{uni}->[$n]=uniByName($fonts->{$fname}->{char}->[$n]) unless(defined $fonts->{$fname}->{uni}->[$n]);
        }
        return(%{$fonts->{$fname}});
    }
    else
    {
        die "requested font '$fname' not installed ";
    }
}

#
# Deep copy something, thanks to Randal L. Schwartz
# Changed to deal w/ CODE refs, in which case it doesn't try to deep copy
#
sub deep_copy
{
    my $this = shift;
    if (not ref $this)
    {
    $this;
    }
    elsif (ref $this eq "ARRAY")
    {
    [map &deep_copy($_), @$this];
    }
    elsif (ref $this eq "HASH")
    {
    +{map { $_ => &deep_copy($this->{$_}) } keys %$this};
    }
    elsif (ref $this eq "CODE")
    {
    # Can't deep copy code refs
    return $this;
    }
    else
    {
    die "what type is $_?";
    }
}

sub new
{
    my ($class,$pdf,$name,@opts) = @_;
    my ($self,$data);
    my %opts=();
    if(-f $name)
    {
        eval "require '$name'; ";
        $name=basename($name,'.pm');
    }
    my $lookname=lc($name);
    $lookname=~s/[^a-z0-9]+//gi;
    %opts=@opts if((scalar @opts)%2 == 0);
    $opts{-encode}||='asis';

    $lookname = defined($alias->{$lookname}) ? $alias->{$lookname} : $lookname ;

    if(defined $subs->{$lookname})
    {
        $data={_look_for_font($subs->{$lookname}->{-alias})};
        foreach my $k (keys %{$subs->{$lookname}})
        {
            next if($k=~/^\-/);
            $data->{$k}=$subs->{$lookname}->{$k};
        }
    }
    else
    {
        unless(defined $opts{-metrics})
        {
            $data={_look_for_font($lookname)};
        }
        else
        {
            $data={%{$opts{-metrics}}};
        }
    }

    die "Undefined Font '$name($lookname)'" unless($data->{fontname});

    # we have data now here so we need to check if
    # there is a -ttfile or -afmfile/-pfmfile/-pfbfile
    # and proxy the call to the relevant modules
    #
    #if(defined $data->{-ttfile} && $data->{-ttfile}=_look_for_fontfile($data->{-ttfile}))
    #{
    #    return(PDF::API2::Resource::CIDFont::TrueType->new($pdf,$data->{-ttfile},@opts));
    #}
    #elsif(defined $data->{-pfbfile} && $data->{-pfbfile}=_look_for_fontfile($data->{-pfbfile}))
    #{
    #    $data->{-afmfile}=_look_for_fontfile($data->{-afmfile});
    #    return(PDF::API2::Resource::Font::Postscript->new($pdf,$data->{-pfbfile},$data->{-afmfile},@opts));
    #}
    #elsif(defined $data->{-gfx})
    #{ # to be written and tested in 'Maki' first!
    #    return(PDF::API2::Resource::Font::gFont->new($pdf,$data,@opts);
    #}

    $class = ref $class if ref $class;
    $self = $class->SUPER::new($pdf, $data->{apiname}.pdfkey().'~'.time());
    $pdf->new_obj($self) unless($self->is_obj($pdf));
    $self->{' data'}=$data;
    $self->{-dokern}=1 if($opts{-dokern});

    $self->{'Subtype'} = PDFName($self->data->{type});
    $self->{'BaseFont'} = PDFName($self->fontname);
    if($opts{-pdfname})
    {
        $self->name($opts{-pdfname});
    }

    unless($self->data->{iscore})
    {
        $self->{'FontDescriptor'}=$self->descrByData();
    }

    $self->encodeByData($opts{-encode});

    return($self);
}

=item PDF::API2::Resource::Font::CoreFont->loadallfonts()

"Requires in" all fonts available as corefonts.

=cut

sub loadallfonts
{
    foreach my $f (qw[
        courier courierbold courierboldoblique courieroblique
        georgia georgiabold georgiabolditalic georgiaitalic
        helveticaboldoblique helveticaoblique helveticabold helvetica
        symbol
        timesbolditalic timesitalic timesroman timesbold
        verdana verdanabold verdanabolditalic verdanaitalic
        webdings
        wingdings
        zapfdingbats
    ])
    {
        _look_for_font($f);
    }
}

#    andalemono
#    arialrounded
#    bankgothic
#    impact
#    ozhandicraft
#    trebuchet
#    trebuchetbold
#    trebuchetbolditalic
#    trebuchetitalic

BEGIN
{

    $alias = {
        ## Windows Fonts with Type1 equivalence
        'arial'                     => 'helvetica',
        'arialitalic'               => 'helveticaoblique',
        'arialbold'                 => 'helveticabold',
        'arialbolditalic'           => 'helveticaboldoblique',

        'times'                     => 'timesroman',
        'timesnewromanbolditalic'   => 'timesbolditalic',
        'timesnewromanbold'         => 'timesbold',
        'timesnewromanitalic'       => 'timesitalic',
        'timesnewroman'             => 'timesroman',

        'couriernewbolditalic'      => 'courierboldoblique',
        'couriernewbold'            => 'courierbold',
        'couriernewitalic'          => 'courieroblique',
        'couriernew'                => 'courier',
    };

    $subs = {
        #'bankgothicbold' => {
        #    'apiname'       => 'Bg2',
        #    '-alias'        => 'bankgothic',
        #    'fontname'      => 'BankGothicMediumBT,Bold',
        #    'flags'         => 32+262144,
        #},
        #'bankgothicbolditalic' => {
        #    'apiname'       => 'Bg3',
        #    '-alias'        => 'bankgothic',
        #    'fontname'      => 'BankGothicMediumBT,BoldItalic',
        #    'italicangle'   => -15,
        #    'flags'         => 96+262144,
        #},
        #'bankgothicitalic' => {
        #    'apiname'       => 'Bg4',
        #    '-alias'        => 'bankgothic',
        #    'fontname'      => 'BankGothicMediumBT,Italic',
        #    'italicangle'   => -15,
        #    'flags'         => 96,
        #},
        #  'impactitalic'      => {
        #            'apiname' => 'Imp2',
        #            '-alias'  => 'impact',
        #            'fontname'  => 'Impact,Italic',
        #            'italicangle' => -12,
        #          },
        #  'ozhandicraftbold'    => {
        #            'apiname' => 'Oz2',
        #            '-alias'  => 'ozhandicraft',
        #            'fontname'  => 'OzHandicraftBT,Bold',
        #            'italicangle' => 0,
        #            'flags' => 32+262144,
        #          },
        #  'ozhandicraftitalic'    => {
        #            'apiname' => 'Oz3',
        #            '-alias'  => 'ozhandicraft',
        #            'fontname'  => 'OzHandicraftBT,Italic',
        #            'italicangle' => -15,
        #            'flags' => 96,
        #          },
        #  'ozhandicraftbolditalic'  => {
        #            'apiname' => 'Oz4',
        #            '-alias'  => 'ozhandicraft',
        #            'fontname'  => 'OzHandicraftBT,BoldItalic',
        #            'italicangle' => -15,
        #            'flags' => 96+262144,
        #          },
        #  'arialroundeditalic'  => {
        #            'apiname' => 'ArRo2',
        #            '-alias'  => 'arialrounded',
        #            'fontname'  => 'ArialRoundedMTBold,Italic',
        #            'italicangle' => -15,
        #            'flags' => 96+262144,
        #          },
        #  'arialitalic'  => {
        #            'apiname' => 'Ar2',
        #            '-alias'  => 'arial',
        #            'fontname'  => 'Arial,Italic',
        #            'italicangle' => -15,
        #            'flags' => 96,
        #          },
        #  'arialbolditalic'  => {
        #            'apiname' => 'Ar3',
        #            '-alias'  => 'arial',
        #            'fontname'  => 'Arial,BoldItalic',
        #            'italicangle' => -15,
        #            'flags' => 96+262144,
        #          },
        #  'arialbold'  => {
        #            'apiname' => 'Ar4',
        #            '-alias'  => 'arial',
        #            'fontname'  => 'Arial,Bold',
        #            'flags' => 32+262144,
        #          },
    };

    $fonts = { };

}

1;

__END__

=back

=head1 SUPPORTED FONTS

=over

=item PDF::API2::CoreFont supports the following 'Adobe Core Fonts':

  Courier
  Courier-Bold
  Courier-BoldOblique
  Courier-Oblique
  Helvetica
  Helvetica-Bold
  Helvetica-BoldOblique
  Helvetica-Oblique
  Symbol
  Times-Bold
  Times-BoldItalic
  Times-Italic
  Times-Roman
  ZapfDingbats

=item PDF::API2::CoreFont supports the following 'Windows Fonts':

  Georgia
  Georgia,Bold
  Georgia,BoldItalic
  Georgia,Italic
  Verdana
  Verdana,Bold
  Verdana,BoldItalic
  Verdana,Italic
  Webdings
  Wingdings

=back

=head1 AUTHOR

Alfred Reibenschuh

=cut


