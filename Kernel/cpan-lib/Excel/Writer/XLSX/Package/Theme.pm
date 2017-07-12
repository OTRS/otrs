package Excel::Writer::XLSX::Package::Theme;

###############################################################################
#
# Theme - A class for writing the Excel XLSX Theme file.
#
# Used in conjunction with Excel::Writer::XLSX
#
# Copyright 2000-2016, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

# perltidy with the following options: -mbl=2 -pt=0 -nola


###############################################################################
#
# NOTE: This class doesn't try to create the Excel theme1.xml programmatically.
#       Instead it just writes a stored default theme. This is mainly to
#       facilitate easier comparisons during testing. The theme1.xml file
#       isn't actually required.

use 5.008002;
use strict;
use warnings;
use Exporter;
use Carp;
use IO::File;
use utf8;

our @ISA     = qw(Exporter);
our $VERSION = '0.95';


###############################################################################
#
# Public and private API methods.
#
###############################################################################


###############################################################################
#
# new()
#
# Constructor.
#
sub new {

    my $class = shift;

    my $self = {};

    bless $self, $class;

    return $self;
}


###############################################################################
#
# _assemble_xml_file()
#
# Assemble and write the XML file.
#
sub _assemble_xml_file {

    my $self = shift;

    $self->_write_theme_file();
}


###############################################################################
#
# _set_xml_writer()
#
# Set the filehandle only. This class doesn't use a real XML writer class.
#
sub _set_xml_writer {

    my $self     = shift;
    my $filename = shift;

    my $fh = IO::File->new( $filename, 'w' );
    croak "Couldn't open file $filename for writing.\n" unless $fh;

    binmode $fh, ':utf8';

    $self->{_fh} = $fh;
}


###############################################################################
#
# Internal methods.
#
###############################################################################

# Sparklines styles. Used by the Worksheet class.
our @spark_styles = (
    {   # 0
        series   => { _theme => "4", _tint => "-0.499984740745262" },
        negative => { _theme => "5" },
        markers  => { _theme => "4", _tint => "-0.499984740745262" },
        first    => { _theme => "4", _tint => "0.39997558519241921" },
        last     => { _theme => "4", _tint => "0.39997558519241921" },
        high     => { _theme => "4" },
        low      => { _theme => "4" },
    },
    {   # 1
        series   => { _theme => "4", _tint => "-0.499984740745262" },
        negative => { _theme => "5" },
        markers  => { _theme => "4", _tint => "-0.499984740745262" },
        first    => { _theme => "4", _tint => "0.39997558519241921" },
        last     => { _theme => "4", _tint => "0.39997558519241921" },
        high     => { _theme => "4" },
        low      => { _theme => "4" },
    },
    {   # 2
        series   => { _theme => "5", _tint => "-0.499984740745262" },
        negative => { _theme => "6" },
        markers  => { _theme => "5", _tint => "-0.499984740745262" },
        first    => { _theme => "5", _tint => "0.39997558519241921" },
        last     => { _theme => "5", _tint => "0.39997558519241921" },
        high     => { _theme => "5" },
        low      => { _theme => "5" },
    },
    {   # 3
        series   => { _theme => "6", _tint => "-0.499984740745262" },
        negative => { _theme => "7" },
        markers  => { _theme => "6", _tint => "-0.499984740745262" },
        first    => { _theme => "6", _tint => "0.39997558519241921" },
        last     => { _theme => "6", _tint => "0.39997558519241921" },
        high     => { _theme => "6" },
        low      => { _theme => "6" },
    },
    {   # 4
        series   => { _theme => "7", _tint => "-0.499984740745262" },
        negative => { _theme => "8" },
        markers  => { _theme => "7", _tint => "-0.499984740745262" },
        first    => { _theme => "7", _tint => "0.39997558519241921" },
        last     => { _theme => "7", _tint => "0.39997558519241921" },
        high     => { _theme => "7" },
        low      => { _theme => "7" },
    },
    {   # 5
        series   => { _theme => "8", _tint => "-0.499984740745262" },
        negative => { _theme => "9" },
        markers  => { _theme => "8", _tint => "-0.499984740745262" },
        first    => { _theme => "8", _tint => "0.39997558519241921" },
        last     => { _theme => "8", _tint => "0.39997558519241921" },
        high     => { _theme => "8" },
        low      => { _theme => "8" },
    },
    {   # 6
        series   => { _theme => "9", _tint => "-0.499984740745262" },
        negative => { _theme => "4" },
        markers  => { _theme => "9", _tint => "-0.499984740745262" },
        first    => { _theme => "9", _tint => "0.39997558519241921" },
        last     => { _theme => "9", _tint => "0.39997558519241921" },
        high     => { _theme => "9" },
        low      => { _theme => "9" },
    },
    {   # 7
        series   => { _theme => "4", _tint => "-0.249977111117893" },
        negative => { _theme => "5" },
        markers  => { _theme => "5", _tint => "-0.249977111117893" },
        first    => { _theme => "5", _tint => "-0.249977111117893" },
        last     => { _theme => "5", _tint => "-0.249977111117893" },
        high     => { _theme => "5", _tint => "-0.249977111117893" },
        low      => { _theme => "5", _tint => "-0.249977111117893" },
    },
    {   # 8
        series   => { _theme => "5", _tint => "-0.249977111117893" },
        negative => { _theme => "6" },
        markers  => { _theme => "6", _tint => "-0.249977111117893" },
        first    => { _theme => "6", _tint => "-0.249977111117893" },
        last     => { _theme => "6", _tint => "-0.249977111117893" },
        high     => { _theme => "6", _tint => "-0.249977111117893" },
        low      => { _theme => "6", _tint => "-0.249977111117893" },
    },
    {   # 9
        series   => { _theme => "6", _tint => "-0.249977111117893" },
        negative => { _theme => "7" },
        markers  => { _theme => "7", _tint => "-0.249977111117893" },
        first    => { _theme => "7", _tint => "-0.249977111117893" },
        last     => { _theme => "7", _tint => "-0.249977111117893" },
        high     => { _theme => "7", _tint => "-0.249977111117893" },
        low      => { _theme => "7", _tint => "-0.249977111117893" },
    },
    {   # 10
        series   => { _theme => "7", _tint => "-0.249977111117893" },
        negative => { _theme => "8" },
        markers  => { _theme => "8", _tint => "-0.249977111117893" },
        first    => { _theme => "8", _tint => "-0.249977111117893" },
        last     => { _theme => "8", _tint => "-0.249977111117893" },
        high     => { _theme => "8", _tint => "-0.249977111117893" },
        low      => { _theme => "8", _tint => "-0.249977111117893" },
    },
    {   # 11
        series   => { _theme => "8", _tint => "-0.249977111117893" },
        negative => { _theme => "9" },
        markers  => { _theme => "9", _tint => "-0.249977111117893" },
        first    => { _theme => "9", _tint => "-0.249977111117893" },
        last     => { _theme => "9", _tint => "-0.249977111117893" },
        high     => { _theme => "9", _tint => "-0.249977111117893" },
        low      => { _theme => "9", _tint => "-0.249977111117893" },
    },
    {   # 12
        series   => { _theme => "9", _tint => "-0.249977111117893" },
        negative => { _theme => "4" },
        markers  => { _theme => "4", _tint => "-0.249977111117893" },
        first    => { _theme => "4", _tint => "-0.249977111117893" },
        last     => { _theme => "4", _tint => "-0.249977111117893" },
        high     => { _theme => "4", _tint => "-0.249977111117893" },
        low      => { _theme => "4", _tint => "-0.249977111117893" },
    },
    {   # 13
        series   => { _theme => "4" },
        negative => { _theme => "5" },
        markers  => { _theme => "4", _tint => "-0.249977111117893" },
        first    => { _theme => "4", _tint => "-0.249977111117893" },
        last     => { _theme => "4", _tint => "-0.249977111117893" },
        high     => { _theme => "4", _tint => "-0.249977111117893" },
        low      => { _theme => "4", _tint => "-0.249977111117893" },
    },
    {   # 14
        series   => { _theme => "5" },
        negative => { _theme => "6" },
        markers  => { _theme => "5", _tint => "-0.249977111117893" },
        first    => { _theme => "5", _tint => "-0.249977111117893" },
        last     => { _theme => "5", _tint => "-0.249977111117893" },
        high     => { _theme => "5", _tint => "-0.249977111117893" },
        low      => { _theme => "5", _tint => "-0.249977111117893" },
    },
    {   # 15
        series   => { _theme => "6" },
        negative => { _theme => "7" },
        markers  => { _theme => "6", _tint => "-0.249977111117893" },
        first    => { _theme => "6", _tint => "-0.249977111117893" },
        last     => { _theme => "6", _tint => "-0.249977111117893" },
        high     => { _theme => "6", _tint => "-0.249977111117893" },
        low      => { _theme => "6", _tint => "-0.249977111117893" },
    },
    {   # 16
        series   => { _theme => "7" },
        negative => { _theme => "8" },
        markers  => { _theme => "7", _tint => "-0.249977111117893" },
        first    => { _theme => "7", _tint => "-0.249977111117893" },
        last     => { _theme => "7", _tint => "-0.249977111117893" },
        high     => { _theme => "7", _tint => "-0.249977111117893" },
        low      => { _theme => "7", _tint => "-0.249977111117893" },
    },
    {   # 17
        series   => { _theme => "8" },
        negative => { _theme => "9" },
        markers  => { _theme => "8", _tint => "-0.249977111117893" },
        first    => { _theme => "8", _tint => "-0.249977111117893" },
        last     => { _theme => "8", _tint => "-0.249977111117893" },
        high     => { _theme => "8", _tint => "-0.249977111117893" },
        low      => { _theme => "8", _tint => "-0.249977111117893" },
    },
    {   # 18
        series   => { _theme => "9" },
        negative => { _theme => "4" },
        markers  => { _theme => "9", _tint => "-0.249977111117893" },
        first    => { _theme => "9", _tint => "-0.249977111117893" },
        last     => { _theme => "9", _tint => "-0.249977111117893" },
        high     => { _theme => "9", _tint => "-0.249977111117893" },
        low      => { _theme => "9", _tint => "-0.249977111117893" },
    },
    {   # 19
        series   => { _theme => "4", _tint => "0.39997558519241921" },
        negative => { _theme => "0", _tint => "-0.499984740745262" },
        markers  => { _theme => "4", _tint => "0.79998168889431442" },
        first    => { _theme => "4", _tint => "-0.249977111117893" },
        last     => { _theme => "4", _tint => "-0.249977111117893" },
        high     => { _theme => "4", _tint => "-0.499984740745262" },
        low      => { _theme => "4", _tint => "-0.499984740745262" },
    },
    {   # 20
        series   => { _theme => "5", _tint => "0.39997558519241921" },
        negative => { _theme => "0", _tint => "-0.499984740745262" },
        markers  => { _theme => "5", _tint => "0.79998168889431442" },
        first    => { _theme => "5", _tint => "-0.249977111117893" },
        last     => { _theme => "5", _tint => "-0.249977111117893" },
        high     => { _theme => "5", _tint => "-0.499984740745262" },
        low      => { _theme => "5", _tint => "-0.499984740745262" },
    },
    {   # 21
        series   => { _theme => "6", _tint => "0.39997558519241921" },
        negative => { _theme => "0", _tint => "-0.499984740745262" },
        markers  => { _theme => "6", _tint => "0.79998168889431442" },
        first    => { _theme => "6", _tint => "-0.249977111117893" },
        last     => { _theme => "6", _tint => "-0.249977111117893" },
        high     => { _theme => "6", _tint => "-0.499984740745262" },
        low      => { _theme => "6", _tint => "-0.499984740745262" },
    },
    {   # 22
        series   => { _theme => "7", _tint => "0.39997558519241921" },
        negative => { _theme => "0", _tint => "-0.499984740745262" },
        markers  => { _theme => "7", _tint => "0.79998168889431442" },
        first    => { _theme => "7", _tint => "-0.249977111117893" },
        last     => { _theme => "7", _tint => "-0.249977111117893" },
        high     => { _theme => "7", _tint => "-0.499984740745262" },
        low      => { _theme => "7", _tint => "-0.499984740745262" },
    },
    {   # 23
        series   => { _theme => "8", _tint => "0.39997558519241921" },
        negative => { _theme => "0", _tint => "-0.499984740745262" },
        markers  => { _theme => "8", _tint => "0.79998168889431442" },
        first    => { _theme => "8", _tint => "-0.249977111117893" },
        last     => { _theme => "8", _tint => "-0.249977111117893" },
        high     => { _theme => "8", _tint => "-0.499984740745262" },
        low      => { _theme => "8", _tint => "-0.499984740745262" },
    },
    {   # 24
        series   => { _theme => "9", _tint => "0.39997558519241921" },
        negative => { _theme => "0", _tint => "-0.499984740745262" },
        markers  => { _theme => "9", _tint => "0.79998168889431442" },
        first    => { _theme => "9", _tint => "-0.249977111117893" },
        last     => { _theme => "9", _tint => "-0.249977111117893" },
        high     => { _theme => "9", _tint => "-0.499984740745262" },
        low      => { _theme => "9", _tint => "-0.499984740745262" },
    },
    {   # 25
        series   => { _theme => "1", _tint => "0.499984740745262" },
        negative => { _theme => "1", _tint => "0.249977111117893" },
        markers  => { _theme => "1", _tint => "0.249977111117893" },
        first    => { _theme => "1", _tint => "0.249977111117893" },
        last     => { _theme => "1", _tint => "0.249977111117893" },
        high     => { _theme => "1", _tint => "0.249977111117893" },
        low      => { _theme => "1", _tint => "0.249977111117893" },
    },
    {   # 26
        series   => { _theme => "1", _tint => "0.34998626667073579" },
        negative => { _theme => "0", _tint => "-0.249977111117893" },
        markers  => { _theme => "0", _tint => "-0.249977111117893" },
        first    => { _theme => "0", _tint => "-0.249977111117893" },
        last     => { _theme => "0", _tint => "-0.249977111117893" },
        high     => { _theme => "0", _tint => "-0.249977111117893" },
        low      => { _theme => "0", _tint => "-0.249977111117893" },
    },
    {   # 27
        series   => { _rgb => "FF323232" },
        negative => { _rgb => "FFD00000" },
        markers  => { _rgb => "FFD00000" },
        first    => { _rgb => "FFD00000" },
        last     => { _rgb => "FFD00000" },
        high     => { _rgb => "FFD00000" },
        low      => { _rgb => "FFD00000" },
    },
    {   # 28
        series   => { _rgb => "FF000000" },
        negative => { _rgb => "FF0070C0" },
        markers  => { _rgb => "FF0070C0" },
        first    => { _rgb => "FF0070C0" },
        last     => { _rgb => "FF0070C0" },
        high     => { _rgb => "FF0070C0" },
        low      => { _rgb => "FF0070C0" },
    },
    {   # 29
        series   => { _rgb => "FF376092" },
        negative => { _rgb => "FFD00000" },
        markers  => { _rgb => "FFD00000" },
        first    => { _rgb => "FFD00000" },
        last     => { _rgb => "FFD00000" },
        high     => { _rgb => "FFD00000" },
        low      => { _rgb => "FFD00000" },
    },
    {   # 30
        series   => { _rgb => "FF0070C0" },
        negative => { _rgb => "FF000000" },
        markers  => { _rgb => "FF000000" },
        first    => { _rgb => "FF000000" },
        last     => { _rgb => "FF000000" },
        high     => { _rgb => "FF000000" },
        low      => { _rgb => "FF000000" },
    },
    {   # 31
        series   => { _rgb => "FF5F5F5F" },
        negative => { _rgb => "FFFFB620" },
        markers  => { _rgb => "FFD70077" },
        first    => { _rgb => "FF5687C2" },
        last     => { _rgb => "FF359CEB" },
        high     => { _rgb => "FF56BE79" },
        low      => { _rgb => "FFFF5055" },
    },
    {   # 32
        series   => { _rgb => "FF5687C2" },
        negative => { _rgb => "FFFFB620" },
        markers  => { _rgb => "FFD70077" },
        first    => { _rgb => "FF777777" },
        last     => { _rgb => "FF359CEB" },
        high     => { _rgb => "FF56BE79" },
        low      => { _rgb => "FFFF5055" },
    },
    {   # 33
        series   => { _rgb => "FFC6EFCE" },
        negative => { _rgb => "FFFFC7CE" },
        markers  => { _rgb => "FF8CADD6" },
        first    => { _rgb => "FFFFDC47" },
        last     => { _rgb => "FFFFEB9C" },
        high     => { _rgb => "FF60D276" },
        low      => { _rgb => "FFFF5367" },
    },
    {   # 34
        series   => { _rgb => "FF00B050" },
        negative => { _rgb => "FFFF0000" },
        markers  => { _rgb => "FF0070C0" },
        first    => { _rgb => "FFFFC000" },
        last     => { _rgb => "FFFFC000" },
        high     => { _rgb => "FF00B050" },
        low      => { _rgb => "FFFF0000" },
    },
    {   # 35
        series   => { _theme => "3" },
        negative => { _theme => "9" },
        markers  => { _theme => "8" },
        first    => { _theme => "4" },
        last     => { _theme => "5" },
        high     => { _theme => "6" },
        low      => { _theme => "7" },
    },
    {   # 36
        series   => { _theme => "1" },
        negative => { _theme => "9" },
        markers  => { _theme => "8" },
        first    => { _theme => "4" },
        last     => { _theme => "5" },
        high     => { _theme => "6" },
        low      => { _theme => "7" },
    },
);


###############################################################################
#
# XML writing methods.
#
###############################################################################


###############################################################################
#
# _write_theme_file()
#
# Write a default theme.xml file.
#
sub _write_theme_file {

    my $self   = shift;
    my $theme  = << 'XML_DATA';
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Office Theme"><a:themeElements><a:clrScheme name="Office"><a:dk1><a:sysClr val="windowText" lastClr="000000"/></a:dk1><a:lt1><a:sysClr val="window" lastClr="FFFFFF"/></a:lt1><a:dk2><a:srgbClr val="1F497D"/></a:dk2><a:lt2><a:srgbClr val="EEECE1"/></a:lt2><a:accent1><a:srgbClr val="4F81BD"/></a:accent1><a:accent2><a:srgbClr val="C0504D"/></a:accent2><a:accent3><a:srgbClr val="9BBB59"/></a:accent3><a:accent4><a:srgbClr val="8064A2"/></a:accent4><a:accent5><a:srgbClr val="4BACC6"/></a:accent5><a:accent6><a:srgbClr val="F79646"/></a:accent6><a:hlink><a:srgbClr val="0000FF"/></a:hlink><a:folHlink><a:srgbClr val="800080"/></a:folHlink></a:clrScheme><a:fontScheme name="Office"><a:majorFont><a:latin typeface="Cambria"/><a:ea typeface=""/><a:cs typeface=""/><a:font script="Jpan" typeface="ＭＳ Ｐゴシック"/><a:font script="Hang" typeface="맑은 고딕"/><a:font script="Hans" typeface="宋体"/><a:font script="Hant" typeface="新細明體"/><a:font script="Arab" typeface="Times New Roman"/><a:font script="Hebr" typeface="Times New Roman"/><a:font script="Thai" typeface="Tahoma"/><a:font script="Ethi" typeface="Nyala"/><a:font script="Beng" typeface="Vrinda"/><a:font script="Gujr" typeface="Shruti"/><a:font script="Khmr" typeface="MoolBoran"/><a:font script="Knda" typeface="Tunga"/><a:font script="Guru" typeface="Raavi"/><a:font script="Cans" typeface="Euphemia"/><a:font script="Cher" typeface="Plantagenet Cherokee"/><a:font script="Yiii" typeface="Microsoft Yi Baiti"/><a:font script="Tibt" typeface="Microsoft Himalaya"/><a:font script="Thaa" typeface="MV Boli"/><a:font script="Deva" typeface="Mangal"/><a:font script="Telu" typeface="Gautami"/><a:font script="Taml" typeface="Latha"/><a:font script="Syrc" typeface="Estrangelo Edessa"/><a:font script="Orya" typeface="Kalinga"/><a:font script="Mlym" typeface="Kartika"/><a:font script="Laoo" typeface="DokChampa"/><a:font script="Sinh" typeface="Iskoola Pota"/><a:font script="Mong" typeface="Mongolian Baiti"/><a:font script="Viet" typeface="Times New Roman"/><a:font script="Uigh" typeface="Microsoft Uighur"/></a:majorFont><a:minorFont><a:latin typeface="Calibri"/><a:ea typeface=""/><a:cs typeface=""/><a:font script="Jpan" typeface="ＭＳ Ｐゴシック"/><a:font script="Hang" typeface="맑은 고딕"/><a:font script="Hans" typeface="宋体"/><a:font script="Hant" typeface="新細明體"/><a:font script="Arab" typeface="Arial"/><a:font script="Hebr" typeface="Arial"/><a:font script="Thai" typeface="Tahoma"/><a:font script="Ethi" typeface="Nyala"/><a:font script="Beng" typeface="Vrinda"/><a:font script="Gujr" typeface="Shruti"/><a:font script="Khmr" typeface="DaunPenh"/><a:font script="Knda" typeface="Tunga"/><a:font script="Guru" typeface="Raavi"/><a:font script="Cans" typeface="Euphemia"/><a:font script="Cher" typeface="Plantagenet Cherokee"/><a:font script="Yiii" typeface="Microsoft Yi Baiti"/><a:font script="Tibt" typeface="Microsoft Himalaya"/><a:font script="Thaa" typeface="MV Boli"/><a:font script="Deva" typeface="Mangal"/><a:font script="Telu" typeface="Gautami"/><a:font script="Taml" typeface="Latha"/><a:font script="Syrc" typeface="Estrangelo Edessa"/><a:font script="Orya" typeface="Kalinga"/><a:font script="Mlym" typeface="Kartika"/><a:font script="Laoo" typeface="DokChampa"/><a:font script="Sinh" typeface="Iskoola Pota"/><a:font script="Mong" typeface="Mongolian Baiti"/><a:font script="Viet" typeface="Arial"/><a:font script="Uigh" typeface="Microsoft Uighur"/></a:minorFont></a:fontScheme><a:fmtScheme name="Office"><a:fillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:gradFill rotWithShape="1"><a:gsLst><a:gs pos="0"><a:schemeClr val="phClr"><a:tint val="50000"/><a:satMod val="300000"/></a:schemeClr></a:gs><a:gs pos="35000"><a:schemeClr val="phClr"><a:tint val="37000"/><a:satMod val="300000"/></a:schemeClr></a:gs><a:gs pos="100000"><a:schemeClr val="phClr"><a:tint val="15000"/><a:satMod val="350000"/></a:schemeClr></a:gs></a:gsLst><a:lin ang="16200000" scaled="1"/></a:gradFill><a:gradFill rotWithShape="1"><a:gsLst><a:gs pos="0"><a:schemeClr val="phClr"><a:shade val="51000"/><a:satMod val="130000"/></a:schemeClr></a:gs><a:gs pos="80000"><a:schemeClr val="phClr"><a:shade val="93000"/><a:satMod val="130000"/></a:schemeClr></a:gs><a:gs pos="100000"><a:schemeClr val="phClr"><a:shade val="94000"/><a:satMod val="135000"/></a:schemeClr></a:gs></a:gsLst><a:lin ang="16200000" scaled="0"/></a:gradFill></a:fillStyleLst><a:lnStyleLst><a:ln w="9525" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"><a:shade val="95000"/><a:satMod val="105000"/></a:schemeClr></a:solidFill><a:prstDash val="solid"/></a:ln><a:ln w="25400" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:prstDash val="solid"/></a:ln><a:ln w="38100" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:prstDash val="solid"/></a:ln></a:lnStyleLst><a:effectStyleLst><a:effectStyle><a:effectLst><a:outerShdw blurRad="40000" dist="20000" dir="5400000" rotWithShape="0"><a:srgbClr val="000000"><a:alpha val="38000"/></a:srgbClr></a:outerShdw></a:effectLst></a:effectStyle><a:effectStyle><a:effectLst><a:outerShdw blurRad="40000" dist="23000" dir="5400000" rotWithShape="0"><a:srgbClr val="000000"><a:alpha val="35000"/></a:srgbClr></a:outerShdw></a:effectLst></a:effectStyle><a:effectStyle><a:effectLst><a:outerShdw blurRad="40000" dist="23000" dir="5400000" rotWithShape="0"><a:srgbClr val="000000"><a:alpha val="35000"/></a:srgbClr></a:outerShdw></a:effectLst><a:scene3d><a:camera prst="orthographicFront"><a:rot lat="0" lon="0" rev="0"/></a:camera><a:lightRig rig="threePt" dir="t"><a:rot lat="0" lon="0" rev="1200000"/></a:lightRig></a:scene3d><a:sp3d><a:bevelT w="63500" h="25400"/></a:sp3d></a:effectStyle></a:effectStyleLst><a:bgFillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:gradFill rotWithShape="1"><a:gsLst><a:gs pos="0"><a:schemeClr val="phClr"><a:tint val="40000"/><a:satMod val="350000"/></a:schemeClr></a:gs><a:gs pos="40000"><a:schemeClr val="phClr"><a:tint val="45000"/><a:shade val="99000"/><a:satMod val="350000"/></a:schemeClr></a:gs><a:gs pos="100000"><a:schemeClr val="phClr"><a:shade val="20000"/><a:satMod val="255000"/></a:schemeClr></a:gs></a:gsLst><a:path path="circle"><a:fillToRect l="50000" t="-80000" r="50000" b="180000"/></a:path></a:gradFill><a:gradFill rotWithShape="1"><a:gsLst><a:gs pos="0"><a:schemeClr val="phClr"><a:tint val="80000"/><a:satMod val="300000"/></a:schemeClr></a:gs><a:gs pos="100000"><a:schemeClr val="phClr"><a:shade val="30000"/><a:satMod val="200000"/></a:schemeClr></a:gs></a:gsLst><a:path path="circle"><a:fillToRect l="50000" t="50000" r="50000" b="50000"/></a:path></a:gradFill></a:bgFillStyleLst></a:fmtScheme></a:themeElements><a:objectDefaults/><a:extraClrSchemeLst/></a:theme>
XML_DATA

    local $\ = undef; # Protect print from -l on commandline.
    print { $self->{_fh} } $theme;
}


1;


__END__

=pod

=head1 NAME

Theme - A class for writing the Excel XLSX Theme file.

=head1 SYNOPSIS

See the documentation for L<Excel::Writer::XLSX>.

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::Writer::XLSX>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

(c) MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

=head1 LICENSE

Either the Perl Artistic Licence L<http://dev.perl.org/licenses/artistic.html> or the GPL L<http://www.opensource.org/licenses/gpl-license.php>.

=head1 DISCLAIMER OF WARRANTY

See the documentation for L<Excel::Writer::XLSX>.

=cut
