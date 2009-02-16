#!/usr/bin/perl -w
# --
# xml2html.pl - a "_simple_" xml2html viewer
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: xml2html.pl,v 1.16 2009-02-16 12:40:23 tr Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";

use strict;
use warnings;

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::XML;

my $ConfigObject = Kernel::Config->new();
my $LogObject    = Kernel::System::Log->new( ConfigObject => $ConfigObject, );
my $MainObject   = Kernel::System::Main->new(
    ConfigObject => $ConfigObject,
    LogObject    => $LogObject,
);
my $DBObject = Kernel::System::DB->new(
    MainObject   => $MainObject,
    ConfigObject => $ConfigObject,
    LogObject    => $LogObject,
);
my $XMLObject = Kernel::System::XML->new(
    MainObject   => $MainObject,
    ConfigObject => $ConfigObject,
    LogObject    => $LogObject,
    DBObject     => $DBObject,
);

my $Title       = 'xml2html: ';
my $HTML        = '';
my $Layer       = -1;
my $File        = shift;
my $FileContent = '';

if ($File) {
    open my $IN, '<', $File or die "Can't open file $File: $!";
    $FileContent = do { local $/; <$IN> };
    close $IN;
}
else {
    my @File = <STDIN>;
    for (@File) {
        $FileContent .= $_;
    }
}

my @XMLARRAY = $XMLObject->XMLParse( String => $FileContent );
for my $Tag (@XMLARRAY) {
    if ( $Tag->{TagType} eq 'Start' ) {
        $Layer++;
        if ( $Layer == 0 ) {
            $Title .= $Tag->{Tag};
        }
        $HTML
            .= "<span style=\"font-family:Geneva,Helvetica,Arial,sans-serif;vertical-align:top;margin:"
            . ( $Layer * 18 ) . "px\">";
        $HTML .= "<hr width=\"" . ( 100 - ( $Layer * 2 ) ) . "%\" align=\"right\">\n";
        $HTML .= "<b>$Tag->{Tag}:</b>";
        $HTML .= " <font size=\"-2\">";
        my $AttrList = '';

        for ( sort keys %{$Tag} ) {
            if ( $_ =~ /^(Tag|TagType|Content)$/ ) {
                next;
            }
            if ($AttrList) {
                $AttrList .= ", ";
            }
            $AttrList .= "$_: $Tag->{$_}";
        }
        if ($AttrList) {
            $AttrList = "(" . $AttrList . ")";
        }
        $HTML .= "$AttrList</font>";
        $HTML .= "<br>";
        $HTML .= "</span>\n";
        if ( $Tag->{Content} !~ /^\W+$/ ) {
            $Tag->{Content} =~ s/(.{100}.+?\s)/$1\n/g;
            $Tag->{Content} =~ s/  /&nbsp; /g;
            my @Data = split( /\n/, $Tag->{Content} );
            for (@Data) {
                $HTML .= Content($_);
            }
        }
    }
    elsif ( $Tag->{TagType} eq 'End' ) {
        $Layer = $Layer - 1;
    }
}

sub Content {
    my $C = shift;

    return "<span style=\"font-size:10pt;font-family:monospace,fixed;margin:"
        . ( ( $Layer * 20 ) + 5 )
        . "px;\">$C<br>\n</span>";
}

$HTML = "<html><head><title>$Title</title></head><body><center><table width=\"900\"><tr><td>\n"
    . $HTML;
$HTML .= "<hr></td></tr></table></center></body></html>\n";

print $HTML;
