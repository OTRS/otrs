#!/usr/bin/perl -w
# --
# scripts/test/XML.pl - test script for xml parse, create, ... 
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: XML.pl,v 1.1 2005-02-08 12:56:12 martin Exp $
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
use lib dirname($RealBin).'/..';
use lib dirname($RealBin).'/../Kernel/cpan-lib';

use strict;

use Kernel::Config;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::XML;
 
my $VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
# create common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-XMLTest',
    %CommonObject,
);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{XMLObject} = Kernel::System::XML->new(%CommonObject);

print "OTRS::XML::Test ($VERSION)\n";
print "==========================\n";

my $String = '
    <Contact role="admin" type="organization">
      <Name type="long">Example Inc.</Name>
      <Email type="primary">info@exampe.com<Domain>1234.com</Domain></Email>
      <Email type="secundary">sales@example.com</Email>
      <Telephone country="germany">+49-999-99999</Telephone>
    </Contact>
';
print "XML sting:\n=========\n $String\n";

print "XML parse: ...\n=========\n";
# parse xml package
my @XMLHash = $CommonObject{XMLObject}->XMLParse2XMLHash(String => $String);

print "XML to db: ...\n==========\n";
# add xmlhash to db
$CommonObject{XMLObject}->XMLHashAdd(
    Type => 'SomeType',
    Key => '123',
    XMLHash => \@XMLHash,
);

print "\n\nXML from db: ...\n============\n";
# get xml hash from db
@XMLHash = $CommonObject{XMLObject}->XMLHashGet(
    Type => 'SomeType',
    Key => '123',
);

# print xml sting 
print "\n\nXML to XML: ...\n===========\n";
my $XML = $CommonObject{XMLObject}->XMLHash2XML(@XMLHash);
print $XML;

print "\n\nXML to XML²: ...\n============\n";
@XMLHash = $CommonObject{XMLObject}->XMLParse2XMLHash(String => $XML);
$XML = $CommonObject{XMLObject}->XMLHash2XML(@XMLHash);
print $XML;

exit;
