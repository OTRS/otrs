# --
# Kernel/System/Stats/NewTickets.pm - stats module
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NewTickets.pm,v 1.8 2006-01-31 12:53:20 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Stats::NewTickets;

use strict;
use Kernel::System::Ticket;
use Kernel::System::Queue;
use Date::Pcalc qw(Today_and_Now Days_in_Month Day_of_Week Day_of_Week_Abbreviation);

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{TicketObject} = Kernel::System::Ticket->new(%Param);
    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);

    return $Self;
}
# --
sub Param {
    my $Self = shift;
    my @Params = ();
    # get current time
    my ($s,$m,$h, $D,$M,$Y) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
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
            SelectedID => '800x600',
            Data => {
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
    my $Days = Days_in_Month($Param{Year},$Param{Month});
    $Param{Month} = sprintf("%02d", $Param{Month});
    my $Title = "$Param{Year}-$Param{Month}";
    my %TicketStatus = $Self->{TicketObject}->HistoryTicketStatusGet(
        StartYear  => $Param{Year},
        StartMonth => $Param{Month},
        StartDay   => 1,
        StopYear   => $Param{Year},
        StopMonth  => $Param{Month},
        StopDay    => $Days,
    );
    my %Queue = ();
    my @HeadData = ('Queue');
    foreach my $TicketID (keys %TicketStatus) {
        my %Ticket = %{$TicketStatus{$TicketID}};
        if ($Ticket{CreateTime} && $Ticket{CreateTime} =~ /^$Param{Year}-$Param{Month}-(.+?)\s/) {
            $Queue{$Ticket{CreateQueue}}->{int($1)}++;
        }
    }

    my $Day = Days_in_Month($Param{Year},$Param{Month});
    my $DayCounter = 1;
    while ($Day >= $DayCounter) {
        my $Dow = Day_of_Week($Param{Year}, $Param{Month}, $DayCounter);
        $Dow = Day_of_Week_Abbreviation($Dow);
        my $Text = "$Dow $DayCounter";
        push (@HeadData, $Text);
        $DayCounter++;
    }

    my %Queues = $Self->{QueueObject}->GetAllQueues();
    my @Data = ();
    foreach my $QueueName (sort {$Queue{$a} cmp $Queue{$b}} keys %Queue) {
        $DayCounter = 1;
        my @Row = ($QueueName);
        while ($Day >= $DayCounter) {
            if ($Queue{$QueueName}->{$DayCounter}) {
                push (@Row, $Queue{$QueueName}->{$DayCounter});
            }
            else {
                push (@Row, 0);
            }
            $DayCounter++;
        }
        push(@Data, \@Row);
    }

    return ([$Title],[@HeadData], @Data);
}
# --
1;
