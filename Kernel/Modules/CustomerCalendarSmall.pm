# --
# Kernel/Modules/CustomerCalendarSmall.pm - small calendar lookup
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerCalendarSmall.pm,v 1.2 2006-03-11 15:56:06 cs Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerCalendarSmall;

use strict;

use Date::Pcalc qw(Today Days_in_Month Day_of_Week);

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
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
    foreach (qw(TicketObject ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $Year  = 0;
    my $Month = 0;
    my $Day   = 1;
    my $Prefix = "";
    # Prefix
    if ($Self->{ParamObject}->GetParam(Param => 'Prefix')) {
        $Prefix = $Self->{ParamObject}->GetParam(Param => 'Prefix');
    }
    my $TimeVacationDays = $Self->{ConfigObject}->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $Self->{ConfigObject}->Get('TimeVacationDaysOneTime');
    # Today
    my ($CYear, $CMonth, $CDay) = Today;
    $TimeVacationDaysOneTime->{$CYear}->{$CMonth}->{$CDay} = 'Today';
    my @MonthArray = (
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
    );
    # show month
    if ($Self->{ParamObject}->GetParam(Param => 'Month')) {
        my @Date = split /,/, $Self->{ParamObject}->GetParam(Param => 'Month');
        $Month = $Date[0];
        $Year = $Date[1];
    }
    else {
        ($Year, $Month, $Day) = Today;
    }
    my $DaysOfMonth = Days_in_Month($Year, $Month);
    my $FirstWeekDay = Day_of_Week($Year, $Month, 1);
    $Param{Month} = $MonthArray[$Month];
    $Param{Year} = $Year;
    # Last Month
    if ($Month == 1) {
        $Param{Back} = '12,'.($Year - 1);
    }
    else {
        $Param{Back} = ($Month - 1).','.$Year;
    }
    # Next Month
    if ($Month == 12) {
        $Param{Next} = '1,'.($Year + 1);
    }
    else {
        $Param{Next} = ($Month + 1).','.$Year;
    }

    # TimeInputFormat
    my $DateFormat = 'Option';
    if ($Self->{ConfigObject}->Get('TimeInputFormat') eq 'Input') {
        $DateFormat = 'Input';
    }
    $Self->{LayoutObject}->Block(
        Name => "DateFormat".$DateFormat,
        Data => {
            Prefix => $Prefix,
        },
    );
    # generate Calendar sheet
    my $CalDay = 1;
    while ($CalDay <= $DaysOfMonth) {
        $Self->{LayoutObject}->Block(
            Name => "Row",
            Data => {},
        );
        for (my $Col=1;$Col<8 && $CalDay <= $DaysOfMonth; $Col++) {
            if ($CalDay == 1 && $FirstWeekDay > $Col) {
                $Self->{LayoutObject}->Block(
                    Name => "ColEmpty",
                    Data => {},
                );
            }
            else {
                #styles
                my $Style = '';
                if (defined($TimeVacationDaysOneTime->{$Year}->{$Month}->{$CalDay}) && $TimeVacationDaysOneTime->{$Year}->{$Month}->{$CalDay} eq 'Today') {
                    $Style = 'bgcolor="orange"';
                }
                elsif (defined($TimeVacationDays->{$Month}->{$CalDay}) || defined($TimeVacationDaysOneTime->{$Year}->{$Month}->{$CalDay})) {
                    $Style = 'bgcolor="#ffcf00"';
                }
                elsif ($Col == 7 || $Col == 6) {
                    $Style = 'bgcolor="#FFE0E0"';
                }
                $Self->{LayoutObject}->Block(
                    Name => "Col",
                    Data => {
                        Day   => $CalDay,
                        Month => $Month,
                        Year  => $Year,
                        Style => $Style,
                        Prefix => $Prefix,
                    },
                );
                $CalDay++;
            }
        }
    }
    # --
    # start with page ...
    # --
    $Output .= $Self->{LayoutObject}->CustomerHeader(Type => 'Small');
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentCalendarSmall',
        Data => {
            %Param,
            Prefix => $Prefix,
        }
    );
    $Output .= $Self->{LayoutObject}->CustomerFooter(Type => 'Small');
    return $Output;
}

1;
