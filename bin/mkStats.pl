#! /usr/bin/perl
# --
# mkStats.pl - generate stats pics
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: mkStats.pl,v 1.2 2002-05-30 15:00:50 martin Exp $
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
use lib '/opt/OpenTRS/';
use GD;
use GD::Graph;
use GD::Graph::lines;
use Date::Calc qw(:all);
use Kernel::System::DB;
use Kernel::Config;
use Kernel::System::Syslog;

umask 022;

my $ConfigObject = Kernel::Config->new();
my $LogObject = Kernel::System::Syslog->new();
my $DBObject = Kernel::System::DB->new(
    ConfigObject => $ConfigObject,
    LogObject => $LogObject,
);

my $PicDataDir = $ConfigObject->Get('StatsPicDir') 
  || die 'No StatsPicDir in Kenrel::Config.pm!';

my ($Year, $Month) = Today_and_Now();
$Year = shift || $Year;
$Month = shift || $Month;
my $Day = Days_in_Month($Year,$Month) + 1;

#my $graph = GD::Graph::lines->new(600, 400);
my $graph = GD::Graph::lines->new(500, 300);
#my $graph = GD::Graph::lines->new(800, 500);

my $XLable = "Days";
my $YLable = 'Actions';
my $Title  = "OpenTRS stats for $Month/$Year";

my %States = GetHistoryTypes();
my @PossibleStates;
foreach (keys %States) {
    push (@PossibleStates, $States{$_});
}
# set graph
$graph->set(
    x_label           => $XLable,
    y_label           => $YLable,
    title             => $Title,
#		y_max_value       => 20,
#            y_tick_number     => 16,
#		y_label_skip      => 4,
#            x_tick_number     => 8,
    t_margin => 10, b_margin => 10, l_margin => 10, r_margin => 20,
    bgclr => 'white',
    transparent => 0,
    interlaced => 1,
    fgclr => 'black',
    boxclr => 'white',
    accentclr => 'black',
    shadowclr => 'black',
    legendclr => 'black',
    textclr => 'black',
    dclrs => [ qw(red green blue yellow black purple orange pink marine cyan lgray lblue lyellow lgreen lred lpurple lorange lbrown) ],
    x_tick_offset => 0,
    x_label_position => 1/2, y_label_position => 1/2,
    x_labels_vertical => 31,
    
    line_width => 1,
    
    legend_placement => 'BC', legend_spacing => 4,
    legend_marker_width => 12, legend_marker_height => 8,
);

# set legend
$graph->set_legend(@PossibleStates);

# bouild x_lable
my $DayCounter = 1; my @Days;
while ($DayCounter < $Day) {
    my $Dow = Day_of_Week($Year, $Month, $DayCounter);
    $Dow = Day_of_Week_Abbreviation($Dow);
    my $Text = $DayCounter;
    $Text = "$Dow $DayCounter";
    push (@Days,$Text);
    $DayCounter++;
}

# get data ...
my @Data = (\@Days); my %AHash;
foreach (keys %States) {
    my @TmpData = GetDBDataPerMonth($DayCounter, $_);
    push (@Data, \@TmpData);
}

# plot graph
$graph->plot(\@Data);
my $ext = $graph->export_format;
print STDOUT "writing $PicDataDir/$Year-$Month.$ext\n";
open (OUT, "> $PicDataDir/$Year-$Month.$ext") || die $!;
binmode OUT;
print OUT $graph->gd->$ext();
close();

# GetDBDataPerMonth
sub GetDBDataPerMonth {
    my $Days = shift;
    my $State = shift;
    my @Data;
    my $Counter=1;
    while ($Days >= $Counter) {
        my $DayData = 0;
        my $StartDate = $Counter;
        my $EndDate = $StartDate+1;
        my $SQL = "SELECT count(*) FROM ticket_history " .
        " WHERE " .
        " history_type_id = $State " .
        " AND " .
        " change_time >= '$Year-$Month-$StartDate'" .
        " AND " .
        " change_time <= '$Year-$Month-$EndDate'";
        $DBObject->Prepare(SQL => $SQL);
        while (my @RowTmp = $DBObject->FetchrowArray()) {
            $DayData= $RowTmp[0];
        }
#		print $State . " ($Year-$Month-$StartDate) " . $DayData . "\n";
        push (@Data, $DayData);
        $Counter++;
    }
    return @Data;
}
# GetHistoryTypes
sub GetHistoryTypes {
    my %Stats;
    my $SQL = "SELECT id, name FROM ticket_history_type " .
    " WHERE " .
    " valid_id = 1";
    $DBObject->Prepare(SQL => $SQL);
    while (my @RowTmp = $DBObject->FetchrowArray()) {
        $Stats{$RowTmp[0]} = $RowTmp[1];
    }
    return %Stats;
}

# the end
exit (0);
