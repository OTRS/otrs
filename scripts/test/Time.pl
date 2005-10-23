#!/usr/bin/perl -w
# --
# scripts/test/Time.pl - test script for time
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Time.pl,v 1.1 2005-10-23 23:43:18 martin Exp $
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
use Kernel::System::Log;

my $VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
# create common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-TimeTest',
    %CommonObject,
);

print "OTRS::Time::Test ($VERSION)\n";
print "========================\n\n";


my $SystemTime = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-20 10:00:00',
);
my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $CommonObject{TimeObject}->SystemTime2Date(
    SystemTime => $SystemTime,
);
print "Test String2SystemTime2Date: $Year-$Month-$Day $Hour:$Min:$Sec\n\n";

my $SystemTime2 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-21 10:00:00',
);
my $SystemTime3 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-24 10:00:00',
);
my $SystemTime4 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-27 10:00:00',
);
my $SystemTime5 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-11-03 10:00:00',
);
my $SystemTime6 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-12-21 10:00:00',
);
my $SystemTime7 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-12-31 10:00:00',
);
my $SystemTime8 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2003-12-21 10:00:00',
);
my $SystemTime9 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2003-12-31 10:00:00',
);
my $SystemTime10 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-23 10:00:00',
);
my $SystemTime11 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-24 10:00:00',
);
my $SystemTime12 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-23 10:00:00',
);
my $SystemTime13 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-25 13:00:00',
);
my $SystemTime14 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-23 10:00:00',
);
my $SystemTime15 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-30 13:00:00',
);
my $SystemTime16 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-24 11:44:12',
);
my $SystemTime17 = $CommonObject{TimeObject}->TimeStamp2SystemTime(
    String => '2005-10-24 16:13:31',
);
my $WorkingTime = $CommonObject{TimeObject}->WorkingTime(
    StartTime => $SystemTime,
    StopTime => $SystemTime2,
);
my $WorkingTime2 = $CommonObject{TimeObject}->WorkingTime(
    StartTime => $SystemTime,
    StopTime => $SystemTime3,
);
my $WorkingTime3 = $CommonObject{TimeObject}->WorkingTime(
    StartTime => $SystemTime,
    StopTime => $SystemTime4,
);
my $WorkingTime4 = $CommonObject{TimeObject}->WorkingTime(
    StartTime => $SystemTime,
    StopTime => $SystemTime5,
);
my $WorkingTime5 = $CommonObject{TimeObject}->WorkingTime(
    StartTime => $SystemTime6,
    StopTime => $SystemTime7,
);
my $WorkingTime6 = $CommonObject{TimeObject}->WorkingTime(
    StartTime => $SystemTime8,
    StopTime => $SystemTime9,
);
my $WorkingTime7 = $CommonObject{TimeObject}->WorkingTime(
    StartTime => $SystemTime10,
    StopTime => $SystemTime11,
);
my $WorkingTime8 = $CommonObject{TimeObject}->WorkingTime(
    StartTime => $SystemTime12,
    StopTime => $SystemTime13,
);
my $WorkingTime9 = $CommonObject{TimeObject}->WorkingTime(
    StartTime => $SystemTime14,
    StopTime => $SystemTime15,
);
my $WorkingTime10 = $CommonObject{TimeObject}->WorkingTime(
    StartTime => $SystemTime16,
    StopTime => $SystemTime17,
);

print "Test1: ".($WorkingTime/60/60)." (should be 13 h in a default installation)\n";
print "Test2: ".($WorkingTime2/60/60)." (should be 26 h in a default installation)\n";
print "Test3: ".($WorkingTime3/60/60)." (should be 65 h in a default installation)\n";
print "Test4: ".($WorkingTime4/60/60)." (should be 130 h in a default installation)\n";
print "Test5: ".($WorkingTime5/60/60)." (should be 89 h in a default installation)\n";
print "Test6: ".($WorkingTime6/60/60)." (should be 52 h in a default installation)\n";
print "Test7: ".($WorkingTime7/60/60)." (should be 2 h in a default installation)\n";
print "Test8: ".($WorkingTime8/60/60)." (should be 18 h in a default installation)\n";
print "Test9: ".($WorkingTime9/60/60)." (should be 65 h in a default installation)\n";
print "Test10: ".($WorkingTime10/60/60)." (should be 4.48... h in a default installation)\n";

exit;
