# --
# Kernel/System/Time.pm - time functions
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: Time.pm,v 1.15 2006-08-29 17:30:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Time;

use strict;
use Time::Local;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.15 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Time - time functions

=head1 SYNOPSIS

This module is managing time functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a language object

  use Kernel::Config;
  use Kernel::System::Time;

  my $ConfigObject = Kernel::Config->new();

  my $LogObject = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );

  my $TimeObject = Kernel::System::Time->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );

=cut

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
    # check needed objects
    foreach (qw(ConfigObject LogObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    # 0=off; 1=on;
    $Self->{Debug} = 0;

    $Self->{TimeZone} = $Param{TimeZone} || $Param{UserTimeZone} || $Self->{ConfigObject}->Get('TimeZone') || 0;
    $Self->{TimeSecDiff} = $Self->{TimeZone}*60*60;

    return $Self;
}

=item SystemTime()

returns the number of non-leap seconds since what ever time the
system considers to be the epoch (that's 00:00:00, January 1, 1904
for Mac OS, and 00:00:00 UTC, January 1, 1970 for most other systems).

    my $SystemTime = $TimeObject->SystemTime();

=cut

sub SystemTime {
    my $Self = shift;
    return time()+$Self->{TimeSecDiff};
}

=item SystemTime2TimeStamp()

returns a time stamp in "yyyy-mm-dd 23:59:59" format.

    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $SystenTime,
    );

Also if needed a short form "23:59:59" if the date is today (if needed).

    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $SystenTime,
        Type => 'Short',
    );

=cut

sub SystemTime2TimeStamp {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SystemTime)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }

    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $Self->SystemTime2Date(
        %Param,
    );
    if ($Param{Type} && $Param{Type} eq 'Short') {
        my ($CSec, $CMin, $CHour, $CDay, $CMonth, $CYear) = $Self->SystemTime2Date(
            SystemTime => $Self->SystemTime(),
        );
#print STDERR "aaaaa $CYear == $Year && $CMonth == $Month && $CDay == $Day\n";
        if ($CYear == $Year && $CMonth == $Month && $CDay == $Day) {
            return "$Hour:$Min:$Sec";
        }
        else {
            return "$Year-$Month-$Day $Hour:$Min:$Sec";
        }
    }
    return "$Year-$Month-$Day $Hour:$Min:$Sec";
}

=item CurrentTimestamp()

returns a time stamp in "yyyy-mm-dd 23:59:59" format.

    my $TimeStamp  = $TimeObject->CurrentTimestamp();

=cut

sub CurrentTimestamp {
    my $Self = shift;
    my %Param = @_;
    return $Self->SystemTime2TimeStamp(
        SystemTime => $Self->SystemTime()
    );
}

=item SystemTime2Date()

returns a array of time params.

    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );

=cut

sub SystemTime2Date {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SystemTime)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # get time format
    my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WDay) = localtime($Param{SystemTime});
    $Year = $Year+1900;
    $Month = $Month+1;
    $Month  = "0$Month" if ($Month <10);
    $Day  = "0$Day" if ($Day <10);
    $Hour  = "0$Hour" if ($Hour <10);
    $Min  = "0$Min" if ($Min <10);
    $Sec  = "0$Sec" if ($Sec <10);

    return ($Sec, $Min, $Hour, $Day, $Month, $Year, $WDay);
}
1;

=item TimeStamp2SystemTime()

returns the number of non-leap seconds since what ever time the
system considers to be the epoch (that's 00:00:00, January 1, 1904
for Mac OS, and 00:00:00 UTC, January 1, 1970 for most other systems).

    my $SystemTime = $TimeObject->TimeStamp2SystemTime(
        String => '2004-08-14 22:45:00',
    );

=cut

sub TimeStamp2SystemTime {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(String)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my $SytemTime = 0;
    # match iso date format
    if ($Param{String} =~ /(\d\d\d\d)-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/) {
        $SytemTime = $Self->Date2SystemTime(
            Year => $1,
            Month => $2,
            Day => $3,
            Hour => $4,
            Minute => $5,
            Second => $6,
        );
    }
    # match euro time format
    elsif ($Param{String} =~ /(\d\d|\d)\.(\d\d|\d)\.(\d\d\d\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/) {
        $SytemTime = $Self->Date2SystemTime(
            Year => $3,
            Month => $2,
            Day => $1,
            Hour => $4,
            Minute => $5,
            Second => $6,
        );
    }
    # match mail time format
    elsif ($Param{String} =~ /((...),\s+|)(\d\d|\d)\s(...)\s(\d\d\d\d)\s(\d\d|\d):(\d\d|\d):(\d\d|\d)\s((\+|\-)(\d\d)(\d\d)|...)/) {
        my $DiffTime = 0;
        if ($10 eq '+') {
#            $DiffTime = $DiffTime - ($11 * 60 * 60);
#            $DiffTime = $DiffTime - ($12 * 60);
        }
        elsif ($10 eq '-') {
#            $DiffTime = $DiffTime + ($11 * 60 * 60);
#            $DiffTime = $DiffTime + ($12 * 60);
        }
        my @MonthMap = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
        my $Month = 1;
        my $MonthString = $4;
        foreach my $MonthCount (0..$#MonthMap) {
            if ($MonthString =~ /$MonthMap[$MonthCount]/i) {
                $Month = $MonthCount+1;
            }
        }
        $SytemTime = $Self->Date2SystemTime(
            Year => $5,
            Month => $Month,
            Day => $3,
            Hour => $6,
            Minute => $7,
            Second => $8,
        ) + $DiffTime + $Self->{TimeSecDiff};
    }
    # return system time
    if ($SytemTime) {
        return $SytemTime;
    }
    # return error
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Invalid Date '$Param{String}'!");
        return;
    }
}

=item Date2SystemTime()

returns the number of non-leap seconds since what ever time the
system considers to be the epoch (that's 00:00:00, January 1, 1904
for Mac OS, and 00:00:00 UTC, January 1, 1970 for most other systems).

    my $SystemTime = $TimeObject->Date2SystemTime(
        Year => 2004,
        Month => 8,
        Day => 14,
        Hour => 22,
        Minute => 45,
        Second => 0,
    );

=cut

sub Date2SystemTime {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Year Month Day Hour Minute Second)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my $SytemTime = eval {timelocal($Param{Second},$Param{Minute},$Param{Hour},$Param{Day},($Param{Month}-1),$Param{Year})};
    if ($SytemTime) {
        return $SytemTime;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Invalid Date '$Param{Year}-$Param{Month}-$Param{Day} $Param{Hour}:$Param{Minute}:$Param{Second}'!",
        );
        return;
    }
}


=item MailTimeStamp()

returns the current utc time stamp in "Wed, 22 Sep 2004 16:30:57 +0000"
format (used for email Date time stamps).

    my $MailTimeStamp = $TimeObject->MailTimeStamp();

=cut

sub MailTimeStamp {
    my $Self = shift;
    my %Param = @_;
    my @DayMap = qw/Sun Mon Tue Wed Thu Fri Sat/;
    my @MonthMap = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
    my @GMTime = gmtime();
    my @LTime = localtime();
    my $GUTime = $Self->Date2SystemTime(
        Year => $GMTime[5]+1900,
        Month => $GMTime[4]+1,
        Day => $GMTime[3],
        Hour => $GMTime[2],
        Minute => $GMTime[1],
        Second => $GMTime[0],
    );
    my $LUTime = $Self->Date2SystemTime(
        Year => $LTime[5]+1900,
        Month => $LTime[4]+1,
        Day => $LTime[3],
        Hour => $LTime[2],
        Minute => $LTime[1],
        Second => $LTime[0],
    );
    my $DifTime = $LUTime - $GUTime;
    my ($DH, $DM, $DP);
    if ($DifTime =~ /^-(.*)/) {
        $DifTime = $1;
        $DP = '-';
    }
    if (!$DP) {
        $DP = '+';
    }
    if ($DifTime >= 3599) {
        $DH = sprintf("%02d", int($DifTime/3600));
        $DM = sprintf("%02d", int(($DifTime/60) % 60));
    }
    else {
        $DH = '00';
        $DM = sprintf("%02d", int($DifTime/60));
    }
    $GMTime[5] = $GMTime[5] + 1900;
    $LTime[5] = $LTime[5] + 1900;
    my $TimeString = "$DayMap[$LTime[6]], $LTime[3] $MonthMap[$LTime[4]] $LTime[5] ".
     sprintf("%02d", $LTime[2]).":".sprintf("%02d", $LTime[1]).":".sprintf("%02d", $LTime[0])." $DP$DH$DM";
#print STDERR "dddd$DifTime dddd $TimeString\n";
    return $TimeString;
}

=item WorkingTime()

get the working time in secondes between this times

    my $WorkingTime = $TimeObject->WorkingTime(
        StartTime => $Created,
        StopTime => $Self->SystemTime(),
    );

    my $WorkingTime = $TimeObject->WorkingTime(
        StartTime => $Created,
        StopTime => $Self->SystemTime(),
        Calendar => 3, # '' is default
    );

=cut

sub WorkingTime {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(StartTime StopTime)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %TimeWorkingHours = %{$Self->{ConfigObject}->Get('TimeWorkingHours')};
    my %TimeVacationDays = %{$Self->{ConfigObject}->Get('TimeVacationDays')};
    my %TimeVacationDaysOneTime = %{$Self->{ConfigObject}->Get('TimeVacationDaysOneTime')};
    if ($Param{Calendar}) {
        foreach (1..20) {
            if ($Self->{ConfigObject}->Get("TimeZone::Calendar".$_."Name")) {
                %TimeWorkingHours = %{$Self->{ConfigObject}->Get("TimeWorkingHours::Calendar$_")};
                %TimeVacationDays = %{$Self->{ConfigObject}->Get("TimeVacationDays::Calendar$_")};
                %TimeVacationDaysOneTime = %{$Self->{ConfigObject}->Get("TimeVacationDaysOneTime::Calendar$_")};
                $Param{StartTime} = $Param{StartTime} + ($Self->{ConfigObject}->Get("TimeZone::Calendar$_") * 60 * 60);
                $Param{StopTime} = $Param{StopTime} + ($Self->{ConfigObject}->Get("TimeZone::Calendar$_") * 60 * 60);
            }
        }
    }
    my $Counted = 0;
    my ($ASec, $AMin, $AHour, $ADay, $AMonth, $AYear, $AWDay) = localtime($Param{StartTime});
    $AYear = $AYear+1900;
    $AMonth = $AMonth+1;
    my $ADate = "$AYear-$AMonth-$ADay";
    my ($BSec, $BMin, $BHour, $BDay, $BMonth, $BYear, $BWDay) = localtime($Param{StopTime});
    $BYear = $BYear+1900;
    $BMonth = $BMonth+1;
    my $BDate = "$BYear-$BMonth-$BDay";
    while ($Param{StartTime} < $Param{StopTime}+60*60*24) {
        my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WDay) = localtime($Param{StartTime});
        $Year = $Year+1900;
        $Month = $Month+1;
        my $CDate = "$Year-$Month-$Day";
        my %LDay = (
            1 => 'Mon',
            2 => 'Tue',
            3 => 'Wed',
            4 => 'Thu',
            5 => 'Fri',
            6 => 'Sat',
            0 => 'Sun',
        );
        # count noting becouse of vacation
        if ($TimeVacationDays{$Month}->{$Day} || $TimeVacationDaysOneTime{$Year}->{$Month}->{$Day}) {
            # do noting
#print STDERR "Vacation: $Year-$Month-$Day\n";
        }
        else {
            if ($TimeWorkingHours{$LDay{$WDay}}) {
                foreach (@{$TimeWorkingHours{$LDay{$WDay}}}) {
#print STDERR "$CDate eq $ADate: $_ - $WDay - $LDay{$WDay}\n";
#print STDERR "$Year-$Month-$Day: $LDay{$WDay}: $_\n";
                    if ($Param{StartTime} - 60*60*$_ > $Param{StopTime}) {
#                        print STDERR "Stop reached at $Year-$Month-$Day ($WDay): $_:00\n";
                        return $Counted;
                    }
                    # count minutes
                    if ($CDate eq $ADate && $AHour == $_ && $CDate eq $BDate && $BHour == $_) {
                        $Counted = $Counted + ($BMin-$AMin)*60;
#                         print STDERR "SameHDay.. $_:00 ".($BMin-$AMin)."\n";
                    }
                    # do nothing
                    elsif ($CDate eq $ADate && $AHour > $_) {
#                         print STDERR "StartDay.. $_:00 (not counted)\n";
                    }
                    # count minutes
                    elsif ($CDate eq $ADate && $AHour == $_) {
                        $Counted = $Counted + ((60-$AMin)*60);
#                         print STDERR "StartDay.. $_:00 ". (60-$AMin)*60 ."\n";
                    }
                    # do nothing
                    elsif ($CDate eq $BDate && $BHour < $_) {
#                         print STDERR "StopDay.. $_:00 (not counted)\n";
                    }
                    # count minutes
                    elsif ($CDate eq $BDate && $BHour == $_) {
                        $Counted = $Counted + $BMin*60;
#                         print STDERR "StopDay.. $_:00 ".$BMin."\n";
                    }
                    # count full hour
                    else {
                        $Counted = $Counted + (60*60);
#                         print STDERR "Counted.. $Year-$Month-$Day $_:00 ($WDay/$LDay{$WDay}):".(60*60)."\n";
                    }
                }
            }
        }
        # reduce time
        $Param{StartTime} = $Param{StartTime} + 60*60*24;
    }
    return $Counted;
}

=item VacationCheck()

check if the selected day is a vacation (it doesn't matter if you
insert 01 or 1 for month or day in the function or in the SysConfig)

    $TimeAccountingObject->VacationCheck(
        Year  => '2005',
        Month => '7', || 07
        Day   => '13',
    );

=cut

sub VacationCheck {
    my $Self         = shift;
    my %Param        = @_;
    my $VacationName = '';

    # check required params
    foreach (qw(Year Month Day)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "VacationCheck: Need $_!"
            );
            return;
        }
    }
    $Param{Month} = sprintf("%02d", $Param{Month});
    $Param{Day}   = sprintf("%02d", $Param{Day});

    my $TimeVacationDays        = $Self->{ConfigObject}->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $Self->{ConfigObject}->Get('TimeVacationDaysOneTime');
    if (defined($TimeVacationDays->{$Param{Month}}->{$Param{Day}})) {
        return $TimeVacationDays->{$Param{Month}}->{$Param{Day}};
    }
    elsif (defined($TimeVacationDaysOneTime->{$Param{Year}}->{$Param{Month}}->{$Param{Day}})) {
        return $TimeVacationDaysOneTime->{$Param{Year}}->{$Param{Month}}->{$Param{Day}};
    }
    elsif (defined($TimeVacationDays->{int($Param{Month})}->{int($Param{Day})})) {
        return $TimeVacationDays->{int($Param{Month})}->{int($Param{Day})};
    }
    elsif (defined($TimeVacationDaysOneTime->{$Param{Year}}->{int($Param{Month})}->{int($Param{Day})})) {
        return $TimeVacationDaysOneTime->{$Param{Year}}->{int($Param{Month})}->{int($Param{Day})};
    }
    return;
}


1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.15 $ $Date: 2006-08-29 17:30:36 $

=cut
