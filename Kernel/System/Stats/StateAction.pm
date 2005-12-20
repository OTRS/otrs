# --
# Kernel/System/Stats/StateAction.pm - stats module
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: StateAction.pm,v 1.3 2005-12-20 23:33:13 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Stats::StateAction;

use strict;
use Date::Pcalc qw(Today_and_Now Days_in_Month Day_of_Week Day_of_Week_Abbreviation);

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Param {
    my $Self = shift;
    my @Params = ();
    # get current time
    my ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst) = localtime(time());
    $Y = $Y+1900;
    $M++;
    # get one month bevore
    if ($M == 1) {
        $M = 12;
        $Y = $Y - 1;
    }
    else {
        $M = $M -1;
    }
    # create possible time selections 
    my %Year = ();
    foreach ($Y-10..$Y+1) {
        $Year{$_} = $_;
    }
    my %Month = ();
    foreach (1..12) {
        my $Tmp = sprintf("%02d", $_);
        $Month{$_} = $Tmp;
    }
 
    push (@Params, {
            Frontend => 'Year',
            Name => 'Year',
            Multiple => 0,
            Size => 0,
            SelectedID => $Y,
            Data => {
                %Year,
            },
        },
    );
    push (@Params, {
            Frontend => 'Month',
            Name => 'Month',
            Multiple => 0,
            Size => 0,
            SelectedID => $M,
            Data => {
                %Month,
            },
        },
    );
    push (@Params, {
            Frontend => 'Graph Size',
            Name => 'GraphSize',
            Multiple => 0,
            Size => 0,
            SelectedID => '550x350',
            Data => {
                '550x350' => ' 550x350',
                '800x600' => ' 800x600',
                '1200x800' => '1200x800',
            },
        },
    );
    return @Params;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Title = "$Param{Year}-$Param{Month}";
    my $Year = $Param{Year};
    my $Month = $Param{Month};
    my $Day = Days_in_Month($Year,$Month);

    my %States = $Self->_GetHistoryTypes();
    my @PossibleStates;
    foreach (sort {$States{$a} cmp $States{$b}} keys %States) {
        $States{$_} =~ s/^(.{18}).*$/$1\.\.\./;
        push (@PossibleStates, $States{$_});
    }
    # build x_lable
    my $DayCounter = 0;
    my @Data;
    my @Days = ();
    my %StateDate = ();
    while ($Day >= $DayCounter+1) {
      $DayCounter++;
      my $Dow = Day_of_Week($Year, $Month, $DayCounter);
      $Dow = Day_of_Week_Abbreviation($Dow);
      my $Text = $DayCounter;
      $Text = "$Dow $DayCounter";
      push (@Days, $Text);
      my @Row = ();
      foreach (sort {$States{$a} cmp $States{$b}} keys %States) {
        my $Count = $Self->_GetDBDataPerDay(Year => $Year, Month=> $Month, Day => $DayCounter, StateID => $_);
        push (@Row,  $Count);
#        $StateDate{}->$States{$_}} = $StateDate{$States{$_}}+$Count;
          $StateDate{$Text}->{$_} = ($StateDate{$Text}->{$_} || 0) + $Count;
      }
    }
    foreach my $StateID (sort {$States{$a} cmp $States{$b}} keys %States) {
        my @Row = ($States{$StateID});
        foreach my $Day (@Days) {
            my %Hash = %{$StateDate{$Day}};
            push (@Row, $Hash{$StateID});
        }
        push (@Data, \@Row);
    }
    return ([$Title],['Days',@Days], @Data);
#    return ([$Title],[@PossibleStates], [4,1,2,8], [4,1,2,6], [24,11,7,2], [1,23,4,6]);
}
# --
sub _GetHistoryTypes {
    my $Self = shift;
    my %Param = @_;
    my %Stats;
    my $SQL = "SELECT id, name FROM ticket_history_type ".
    " WHERE ".
    " valid_id = 1";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Stats{$RowTmp[0]} = $RowTmp[1];
    }
    return %Stats;
}
# --
sub _GetDBDataPerDay {
    my $Self = shift;
    my %Param = @_; 
    my $DayData = 0;
    my $SQL = "SELECT count(*) FROM ticket_history " .
        " WHERE " .
        " history_type_id = $Param{StateID} " .
        " AND " .
        " create_time >= '$Param{Year}-$Param{Month}-$Param{Day} 00:00:01'".
        " AND " .
        " create_time <= '$Param{Year}-$Param{Month}-$Param{Day} 23:59:59'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $DayData= $Row[0];
    }
    return $DayData;
}
# --
1;
