#!/usr/bin/perl -w
# --
# xml2docbook.pl - config xml to docbook
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: xml2docbook.pl,v 1.1 2005-07-22 09:55:41 martin Exp $
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin)."/../";
use lib dirname($RealBin)."/../Kernel/cpan-lib";

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Kernel::Config;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::Config;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{TimeObject} = Kernel::System::Time->new(
    %CommonObject,
);
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-xml2docbook',
    %CommonObject,
);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{SysConfigObject} = Kernel::System::Config->new(%CommonObject);

# list Groups
#my %List = $CommonObject{SysConfigObject}->ConfigGroupList();
my @Groups = (qw(Framework Ticket FAQ));
my $UserLang = 'de';
print '<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.4//EN"
  "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd" [
  <!ENTITY auml   "&#x00E4;"> <!-- LATIN SMALL LETTER A WITH DIAERESIS -->
  <!ENTITY Auml   "&#x00C4;"> <!-- LATIN CAPITAL LETTER A WITH DIAERESIS -->
  <!ENTITY ouml   "&#x00F6;"> <!-- LATIN SMALL LETTER O WITH DIAERESIS -->
  <!ENTITY Ouml   "&#x00D6;"> <!-- LATIN CAPITAL LETTER O WITH DIAERESIS -->
  <!ENTITY uuml   "&#x00FC;"> <!-- LATIN SMALL LETTER U WITH DIAERESIS -->
  <!ENTITY Uuml   "&#x00DC;"> <!-- LATIN CAPITAL LETTER U WITH DIAERESIS -->
  <!ENTITY szlig  "&#x00DF;"> <!-- LATIN SMALL LETTER SHARP S -->
]>
';
print "<appendix id=\"config\"><title>Config Referenzliste</title>\n";
foreach my $Group (@Groups) {
    my %SubList = $CommonObject{SysConfigObject}->ConfigSubGroupList(Name => $Group);
    print "<sect1 id=\"$Group\"><title>$Group</title> \n";
    foreach my $SubGroup (sort keys %SubList) {
        print "<sect2 id=\"$Group:$SubGroup\"><title>$SubGroup</title> \n";
#        print "$Group: $SubGroup \n";
        my @List = $CommonObject{SysConfigObject}->ConfigSubGroupConfigItemList(Group => $Group, SubGroup => $SubGroup);
        foreach my $Name (@List) {
            my %Item = $CommonObject{SysConfigObject}->ConfigItemGet(Name => $Name);
            my $Link = $Name;
            $Link =~ s/###/_/g;
            $Link =~ s/\///g;
            print "<sect3 id=\"$Group:$SubGroup:$Link\"><title>$Name</title> \n";
            #Description
            my %HashLang;
            foreach my $Index (1...$#{$Item{Description}}) {
                $HashLang{$Item{Description}[$Index]{Lang}} = $Item{Description}[$Index]{Content};
            }
            my $Description;
            # Description in User Language
            if (defined $HashLang{$UserLang}) {
                $Description = $HashLang{$UserLang};
            }
            # Description in Default Language
            else {
                $Description = $HashLang{'en'};
            }
#            print " Name: $_ \n";
#            print " Description: $Description\n";
            $Description =~ s/&/&amp;/g;
            $Description =~ s/</&lt;/g;
            $Description =~ s/>/&gt;/g;
            print "<para>$Description</para>\n";
            print "<itemizedlist>\n";
            foreach my $Area (qw(Group SubGroup)) {
                foreach (1..10) {
                    if ($Item{$Area}->[$_]) {
                        print "<listitem><para>\n";
                        print "$Area: $Item{$Area}->[$_]->{Content}\n";
                        print "</para></listitem>\n";
                    }
                }
            }
            my %ConfigItemDefault = $CommonObject{SysConfigObject}->ConfigItemGet(
                Name => $Name,
                Default => 1,
            );
            my $Key = $Name;
            $Key =~ s/\\/\\\\/g;
            $Key =~ s/'/\'/g;
            $Key =~ s/###/'}->{'/g;

            my $Config = " \$Self->{'$Key'} = ".$CommonObject{SysConfigObject}->_XML2Perl(Data => \%ConfigItemDefault);
            $Config =~ s/&/&amp;/g;
            $Config =~ s/</&lt;/g;
            $Config =~ s/>/&gt;/g;
            print "<listitem><para>Config-Setting</para><programlisting>\n";
            print $Config;
            print "</programlisting>\n";
            print "</listitem>\n";
            print "</itemizedlist>\n";
            print "</sect3> \n";
        }
        print "</sect2> \n";
    }
    print "</sect1> \n";
}
print "</appendix> \n";

exit;

