#!/usr/bin/perl -w
# --
# xml2html.pl - a "_simple_" xml2html viewer
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: xml2html.pl,v 1.3 2004-11-28 07:43:00 martin Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --


use strict;
use XML::Parser;

my $Title = 'xml2html: ';

my $HTML = '';
my $Layer = -1;
my %Attr = ();
my $File = shift;
my $FileContent = '';
if ($File) {
    open(IN, "< $File") || die "Can't open file $File: $!";
    while (<IN>) {
        $FileContent .= $_;
    }
    close (IN);
}
else {
    my @File = <STDIN>;
    foreach (@File) {
        $FileContent .= $_;
    }
}

my $p1 = new XML::Parser(Handlers => {Start => \&HS, End => \&ES, Char => \&CS});

my @Data = $p1->parse($FileContent);

sub HS {
    my ($Expat, $Element, %Attr) = @_;
#    print "s:'$Element'\n";
    $Layer++;
    if ($Layer == 0) {
        $Title .= $Element;
    }
    $HTML .= "<span style=\"font-family:Geneva,Helvetica,Arial,sans-serif;vertical-align:top;margin:".($Layer*18)."px\">";
    $HTML .= "<hr width=\"".(100-($Layer*2))."%\" align=\"right\">\n";
    $HTML .= "<b>$Element:</b>";
    $HTML .= " <font size=\"-2\">";
    my $AttrList = '';
    foreach (sort keys %Attr) {
        if ($AttrList) {
            $AttrList .= ", ";
        }
        $AttrList .= "$_: $Attr{$_}";
    }
    if ($AttrList) {
        $AttrList = "(".$AttrList.")";
    }
    $HTML .= "$AttrList</font>";
    $HTML .= "<br>";
    $HTML .= "</span>\n";
}

sub CS {
    my ($Expat, $Element, $I, $II) = @_;
    $Element = $Expat->recognized_string();
#    print "v:'$Element'\n";
    if ($Element !~ /^\W+$/) {
        $Element =~ s/(.{100}.+?\s)/$1\n/g;
        $Element =~ s/  /&nbsp; /g;
        my @Data = split(/\n/, $Element);
        foreach (@Data) {
            $HTML .= Content($_);
        }
    }
}

sub Content {
    my $C = shift;
    return "<span style=\"font-size:10pt;font-family:monospace,fixed;margin:".(($Layer*20)+5)."px;\">$C<br>\n</span>";
}

sub ES {
    my ($Expat, $Element) = @_;
#    print "e:'$Element'\n";
    $Layer = $Layer - 1;
}

$HTML = "<html><head><title>$Title</title></head><body><center><table width=\"900\"><tr><td>\n".$HTML;
$HTML .= "<hr></td></tr></table></center></body></html>\n";

print $HTML;

