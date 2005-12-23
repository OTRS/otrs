# --
# Kernel/System/Stats/TicketOverview.pm - stats module
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: TicketOverview.pm,v 1.4 2005-12-23 09:19:44 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Stats::TicketOverview;

use strict;
use Kernel::System::Ticket;
use Kernel::System::State;
use Date::Pcalc qw(Today_and_Now Days_in_Month Day_of_Week Day_of_Week_Abbreviation);

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $ ';
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
    $Self->{StateObject} = Kernel::System::State->new(%Param);

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
            SelectedID => '550x350',
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
    $Param{Month} = sprintf("%02d", $Param{Month});
    my $Title = "$Param{Year}-$Param{Month}";
    my %TicketStatus = $Self->{TicketObject}->HistoryTicketStatusGet(
        StartYear => $Param{Year}-1,
        StartMonth => $Param{Month},
        StartDay => 1,
        StopYear => $Param{Year},
        StopMonth => $Param{Month},
        StopDay => Date::Pcalc::Days_in_Month($Param{Year}, $Param{Month}),
    );
    my %Queue = ();
    my @HeadData = ('Queue');
    foreach my $TicketID (keys %TicketStatus) {
        my %Ticket = %{$TicketStatus{$TicketID}};
        if ($Ticket{Queue}) {
            $Queue{$Ticket{Queue}}->{$Ticket{State}}++;
        }
    }


    my %States = $Self->{StateObject}->StateList(UserID => 1);
    foreach my $StateID (sort {$States{$a} cmp $States{$b}} keys %States) {
        push (@HeadData, $States{$StateID});
    }

    my @Data = ();
    foreach my $QueueName (sort {$Queue{$a} cmp $Queue{$b}} keys %Queue) {
        my @Row = ($QueueName);
        foreach my $StateID (sort {$States{$a} cmp $States{$b}} keys %States) {
            if ($Queue{$QueueName}->{$States{$StateID}}) {
                push (@Row, $Queue{$QueueName}->{$States{$StateID}});
            }
            else {
                push (@Row, 0);
            }
        }
        push(@Data, \@Row);
    }

    return ([$Title],[@HeadData], @Data);
}
# --
1;
