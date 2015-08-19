# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Time;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

use strict;
use warnings;

use Time::Local;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Time - time functions

=head1 SYNOPSIS

This module is managing time functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a time object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=on;
    $Self->{Debug} = 0;

    $Self->{TimeZone} = $Param{TimeZone}
        || $Param{UserTimeZone}
        || $Kernel::OM->Get('Kernel::Config')->Get('TimeZone')
        || 0;
    $Self->{TimeSecDiff} = $Self->{TimeZone} * 3600;    # 60 * 60

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

    return time() + $Self->{TimeSecDiff};
}

=item SystemTime2TimeStamp()

returns a time stamp in "yyyy-mm-dd 23:59:59" format.

    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $SystemTime,
    );

If you need the short format "23:59:59" for dates that are "today",
pass the Type parameter like this:

    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $SystemTime,
        Type       => 'Short',
    );

=cut

sub SystemTime2TimeStamp {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{SystemTime} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SystemTime!',
        );
        return;
    }

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->SystemTime2Date(%Param);
    if ( $Param{Type} && $Param{Type} eq 'Short' ) {
        my ( $CSec, $CMin, $CHour, $CDay, $CMonth, $CYear ) = $Self->SystemTime2Date(
            SystemTime => $Self->SystemTime(),
        );
        if ( $CYear == $Year && $CMonth == $Month && $CDay == $Day ) {
            return "$Hour:$Min:$Sec";
        }
        return "$Year-$Month-$Day $Hour:$Min:$Sec";
    }
    return "$Year-$Month-$Day $Hour:$Min:$Sec";
}

=item CurrentTimestamp()

returns a time stamp in "yyyy-mm-dd 23:59:59" format.

    my $TimeStamp = $TimeObject->CurrentTimestamp();

=cut

sub CurrentTimestamp {
    my ( $Self, %Param ) = @_;

    return $Self->SystemTime2TimeStamp( SystemTime => $Self->SystemTime() );
}

=item SystemTime2Date()

returns a array of time params.

    my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );

$WeekDay is the day of the week, with 0 indicating Sunday and 3 indicating Wednesday.

=cut

sub SystemTime2Date {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{SystemTime} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SystemTime!',
        );
        return;
    }

    # get time format
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay ) = localtime $Param{SystemTime};    ## no critic
    $Year  += 1900;
    $Month += 1;
    $Month = sprintf "%02d", $Month;
    $Day   = sprintf "%02d", $Day;
    $Hour  = sprintf "%02d", $Hour;
    $Min   = sprintf "%02d", $Min;
    $Sec   = sprintf "%02d", $Sec;

    return ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay );
}

=item TimeStamp2SystemTime()

returns the number of non-leap seconds since what ever time the
system considers to be the epoch (that's 00:00:00, January 1, 1904
for Mac OS, and 00:00:00 UTC, January 1, 1970 for most other systems).

    my $SystemTime = $TimeObject->TimeStamp2SystemTime(
        String => '2004-08-14 22:45:00',
    );

=cut

sub TimeStamp2SystemTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{String} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need String!',
        );
        return;
    }

    my $SystemTime = 0;

    # match iso date format
    if ( $Param{String} =~ /(\d{4})-(\d{1,2})-(\d{1,2})\s(\d{1,2}):(\d{1,2}):(\d{1,2})/ ) {
        $SystemTime = $Self->Date2SystemTime(
            Year   => $1,
            Month  => $2,
            Day    => $3,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # match iso date format (wrong format)
    elsif ( $Param{String} =~ /(\d{1,2})-(\d{1,2})-(\d{4})\s(\d{1,2}):(\d{1,2}):(\d{1,2})/ ) {
        $SystemTime = $Self->Date2SystemTime(
            Year   => $3,
            Month  => $2,
            Day    => $1,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # match euro time format
    elsif ( $Param{String} =~ /(\d{1,2})\.(\d{1,2})\.(\d{4})\s(\d{1,2}):(\d{1,2}):(\d{1,2})/ ) {
        $SystemTime = $Self->Date2SystemTime(
            Year   => $3,
            Month  => $2,
            Day    => $1,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # match yyyy-mm-ddThh:mm:ss+tt:zz time format
    elsif (
        $Param{String}
        =~ /(\d{4})-(\d{1,2})-(\d{1,2})T(\d{1,2}):(\d{1,2}):(\d{1,2})(\+|\-)((\d{1,2}):(\d{1,2}))/i
        )
    {
        $SystemTime = $Self->Date2SystemTime(
            Year   => $1,
            Month  => $2,
            Day    => $3,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # match mail time format
    elsif (
        $Param{String}
        =~ /((...),\s+|)(\d{1,2})\s(...)\s(\d{4})\s(\d{1,2}):(\d{1,2}):(\d{1,2})\s((\+|\-)(\d{2})(\d{2})|...)/
        )
    {
        my $DiffTime = 0;
        if ( $10 && $10 eq '+' ) {

            #            $DiffTime = $DiffTime - ($11 * 60 * 60);
            #            $DiffTime = $DiffTime - ($12 * 60);
        }
        elsif ( $10 && $10 eq '-' ) {

            #            $DiffTime = $DiffTime + ($11 * 60 * 60);
            #            $DiffTime = $DiffTime + ($12 * 60);
        }
        my @MonthMap    = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
        my $Month       = 1;
        my $MonthString = $4;
        for my $MonthCount ( 0 .. $#MonthMap ) {
            if ( $MonthString =~ /$MonthMap[$MonthCount]/i ) {
                $Month = $MonthCount + 1;
            }
        }
        $SystemTime = $Self->Date2SystemTime(
            Year   => $5,
            Month  => $Month,
            Day    => $3,
            Hour   => $6,
            Minute => $7,
            Second => $8,
        ) + $DiffTime + $Self->{TimeSecDiff};
    }
    elsif (    # match yyyy-mm-ddThh:mm:ssZ
        $Param{String} =~ /(\d{4})-(\d{1,2})-(\d{1,2})T(\d{1,2}):(\d{1,2}):(\d{1,2})Z$/
        )
    {
        $SystemTime = $Self->Date2SystemTime(
            Year   => $1,
            Month  => $2,
            Day    => $3,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # return error
    if ( !defined $SystemTime ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid Date '$Param{String}'!",
        );
    }

    # return system time
    return $SystemTime;

}

=item Date2SystemTime()

returns the number of non-leap seconds since what ever time the
system considers to be the epoch (that's 00:00:00, January 1, 1904
for Mac OS, and 00:00:00 UTC, January 1, 1970 for most other systems).

    my $SystemTime = $TimeObject->Date2SystemTime(
        Year   => 2004,
        Month  => 8,
        Day    => 14,
        Hour   => 22,
        Minute => 45,
        Second => 0,
    );

=cut

sub Date2SystemTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Year Month Day Hour Minute Second)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }
    my $SystemTime = eval {
        timelocal(
            $Param{Second}, $Param{Minute}, $Param{Hour}, $Param{Day}, ( $Param{Month} - 1 ),
            $Param{Year}
        );
    };

    if ( !defined $SystemTime ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Invalid Date '$Param{Year}-$Param{Month}-$Param{Day} $Param{Hour}:$Param{Minute}:$Param{Second}'!",
        );
        return;
    }

    return $SystemTime;
}

=item MailTimeStamp()

returns the current time stamp in RFC 2822 format to be used in email headers:
"Wed, 22 Sep 2014 16:30:57 +0200".

    my $MailTimeStamp = $TimeObject->MailTimeStamp();

=cut

sub MailTimeStamp {
    my ( $Self, %Param ) = @_;

    # According to RFC 2822, section 3.3

    # ---
    # The date and time-of-day SHOULD express local time.

    # The zone specifies the offset from Coordinated Universal Time (UTC,
    # formerly referred to as "Greenwich Mean Time") that the date and
    # time-of-day represent.  The "+" or "-" indicates whether the
    # time-of-day is ahead of (i.e., east of) or behind (i.e., west of)
    # Universal Time.  The first two digits indicate the number of hours
    # difference from Universal Time, and the last two digits indicate the
    # number of minutes difference from Universal Time.  (Hence, +hhmm
    # means +(hh * 60 + mm) minutes, and -hhmm means -(hh * 60 + mm)
    # minutes).  The form "+0000" SHOULD be used to indicate a time zone at
    # Universal Time.  Though "-0000" also indicates Universal Time, it is
    # used to indicate that the time was generated on a system that may be
    # in a local time zone other than Universal Time and therefore
    # indicates that the date-time contains no information about the local
    # time zone.
    # ---

    my @DayMap   = qw/Sun Mon Tue Wed Thu Fri Sat/;
    my @MonthMap = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;

    # check if server is in UTC (server diff should be 0 or very close to)
    my $ServerTimeDiff = Time::Local::timegm_nocheck( localtime( time() ) ) - time();

    # calculate offset - should be '+0200', '-0600', or '+0000'
    my $Diff = $Self->{TimeZone};
    if ($ServerTimeDiff) {
        $Diff = int( $ServerTimeDiff / 3600 );
    }
    my $Direction = $Diff < 0 ? '-' : '+';
    $Diff = abs $Diff;
    my $OffsetHours = $Diff;

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $Self->SystemTime2Date(
        SystemTime => $Self->SystemTime(),
    );

    my $TimeString = sprintf "%s, %d %s %d %02d:%02d:%02d %s%02d%02d",
        $DayMap[$WeekDay],    # 'Sat'
        $Day, $MonthMap[ $Month - 1 ], $Year,    # '2', 'Aug', '2014'
        $Hour,      $Min,         $Sec,          # '12', '34', '36'
        $Direction, $OffsetHours, 0;             # '+', '02', '00'

    return $TimeString;
}

=item WorkingTime()

get the working time in seconds between these times.

    my $WorkingTime = $TimeObject->WorkingTime(
        StartTime => $Created,
        StopTime  => $TimeObject->SystemTime(),
    );

    my $WorkingTime = $TimeObject->WorkingTime(
        StartTime => $Created,
        StopTime  => $TimeObject->SystemTime(),
        Calendar  => 3, # '' is default
    );

=cut

sub WorkingTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(StartTime StopTime)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $TimeWorkingHours        = $ConfigObject->Get('TimeWorkingHours');
    my $TimeVacationDays        = $ConfigObject->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $ConfigObject->Get('TimeVacationDaysOneTime');
    if ( $Param{Calendar} ) {
        if ( $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} . "Name" ) ) {
            $TimeWorkingHours        = $ConfigObject->Get( "TimeWorkingHours::Calendar" . $Param{Calendar} );
            $TimeVacationDays        = $ConfigObject->Get( "TimeVacationDays::Calendar" . $Param{Calendar} );
            $TimeVacationDaysOneTime = $ConfigObject->Get(
                "TimeVacationDaysOneTime::Calendar" . $Param{Calendar}
            );
            my $Zone = $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} );
            if ($Zone) {
                $Zone *= 3600;
                $Param{StartTime} += $Zone;
                $Param{StopTime}  += $Zone;
            }
        }
    }

    my %LDay = (
        1 => 'Mon',
        2 => 'Tue',
        3 => 'Wed',
        4 => 'Thu',
        5 => 'Fri',
        6 => 'Sat',
        0 => 'Sun',
    );

    my $Counted = 0;
    my ( $ASec, $AMin, $AHour, $ADay, $AMonth, $AYear, $AWDay ) = localtime $Param{StartTime};    ## no critic
    $AYear  += 1900;
    $AMonth += 1;
    my $ADate = "$AYear-$AMonth-$ADay";
    my ( $BSec, $BMin, $BHour, $BDay, $BMonth, $BYear, $BWDay ) = localtime $Param{StopTime};     ## no critic
    $BYear  += 1900;
    $BMonth += 1;
    my $BDate = "$BYear-$BMonth-$BDay";

    while ( $Param{StartTime} < $Param{StopTime} ) {
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay ) = localtime $Param{StartTime};       ## no critic
        $Year  += 1900;
        $Month += 1;
        my $CDate   = "$Year-$Month-$Day";
        my $CTime00 = $Param{StartTime} - ( ( $Hour * 60 + $Min ) * 60 + $Sec );                  # 00:00:00

        # count nothing because of vacation
        if (
            $TimeVacationDays->{$Month}->{$Day}
            || $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day}
            )
        {

            # do nothing
        }
        else {
            if ( $TimeWorkingHours->{ $LDay{$WDay} } ) {
                for my $WorkingHour ( @{ $TimeWorkingHours->{ $LDay{$WDay} } } ) {

                    # same date and same hour of start/end date within service hour
                    # => start counting and finish immediatly
                    if ( $ADate eq $BDate && $AHour == $BHour && $AHour == $WorkingHour ) {
                        return $Param{StopTime} - $Param{StartTime};
                    }

                    # do nothing because we are on start day and not yet within service hour
                    elsif ( $CDate eq $ADate && $WorkingHour < $AHour ) {
                    }

                    # we are on start day and within start hour => count to end of this hour
                    elsif ( $CDate eq $ADate && $AHour == $WorkingHour ) {
                        $Counted
                            += ( $CTime00 + ( $WorkingHour + 1 ) * 60 * 60 ) - $Param{StartTime};
                    }

                    # do nothing because we are on end day but greater than service hour
                    elsif ( $CDate eq $BDate && $BHour < $WorkingHour ) {
                    }

                    # we are on end day and within end hour => count from start of this hour
                    elsif ( $CDate eq $BDate && $BHour == $WorkingHour ) {
                        $Counted += $Param{StopTime} - ( $CTime00 + $WorkingHour * 60 * 60 );
                    }

                    # count full hour because we are in service hour that is greater than
                    # start hour and smaller than end hour
                    else {
                        $Counted = $Counted + ( 60 * 60 );
                    }
                }
            }
        }

        # reduce time => go to next day 00:00:00
        $Param{StartTime} = $Self->Date2SystemTime(
            Year   => $Year,
            Month  => $Month,
            Day    => $Day,
            Hour   => 23,
            Minute => 59,
            Second => 59,
        ) + 1;
    }
    return $Counted;
}

=item DestinationTime()

get the destination time based on the current calendar working time (fallback: default
system working time) configuration.

The algorithm roughly works as follows:
    - Check if the start time is actually in the configured working time.
        - If not, set it to the next working time second. Example: start time is
            on a weekend, start time would be set to 8:00 on the following Monday.
    - Then the diff time (in seconds) is added to the start time incrementally, only considering
        the configured working times. So adding 24 hours could actually span multiple days because
        they would be spread over the configured working hours. If we have 8-20, 24 hours would be
        spread over 2 days (13/11 hours).

NOTE: Currently, the implementation stops silently after 600 iterations, making it impossible to
    specify longer escalation times, for example.

    my $DestinationTime = $TimeObject->DestinationTime(
        StartTime => $Created,
        Time      => 60*60*24*2,
    );

    my $DestinationTime = $TimeObject->DestinationTime(
        StartTime => $Created,
        Time      => 60*60*24*2,
        Calendar  => 3, # '' is default
    );

=cut

sub DestinationTime {
    my ( $Self, %Param ) = @_;

    # "Time zone" diff in seconds
    my $Zone = 0;

    # check needed stuff
    for (qw(StartTime Time)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $TimeWorkingHours        = $ConfigObject->Get('TimeWorkingHours');
    my $TimeVacationDays        = $ConfigObject->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $ConfigObject->Get('TimeVacationDaysOneTime');
    if ( $Param{Calendar} ) {
        if ( $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} . "Name" ) ) {
            $TimeWorkingHours        = $ConfigObject->Get( "TimeWorkingHours::Calendar" . $Param{Calendar} );
            $TimeVacationDays        = $ConfigObject->Get( "TimeVacationDays::Calendar" . $Param{Calendar} );
            $TimeVacationDaysOneTime = $ConfigObject->Get(
                "TimeVacationDaysOneTime::Calendar" . $Param{Calendar}
            );
            $Zone = $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} );
            $Zone *= 3600;
            $Param{StartTime} += $Zone;
        }
    }
    my $DestinationTime = $Param{StartTime};
    my $CTime           = $Param{StartTime};

    my %LDay = (
        1 => 'Mon',
        2 => 'Tue',
        3 => 'Wed',
        4 => 'Thu',
        5 => 'Fri',
        6 => 'Sat',
        0 => 'Sun',
    );

    my $LoopCounter;

    LOOP:
    while ( $Param{Time} > 1 ) {
        $LoopCounter++;
        last LOOP if $LoopCounter > 600;

        my ( $Second, $Minute, $Hour, $Day, $Month, $Year, $WDay ) = localtime $CTime;    ## no critic
        $Year  += 1900;
        $Month += 1;
        my $CTime00 = $CTime - ( ( $Hour * 60 + $Minute ) * 60 + $Second );               # 00:00:00

        # Skip vacation days, or days without working hours, do not count.
        if (
            $TimeVacationDays->{$Month}->{$Day}
            || $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day}
            || !$TimeWorkingHours->{ $LDay{$WDay} }
            )
        {
            # Set destination time to next day, 00:00:00
            $DestinationTime = $Self->Date2SystemTime(
                Year   => $Year,
                Month  => $Month,
                Day    => $Day,
                Hour   => 23,
                Minute => 59,
                Second => 59,
            ) + 1;
        }

        # Regular day with working hours
        else {
            HOUR:
            for my $H ( $Hour .. 23 ) {

                # Check if we have a working hour
                if ( grep { $H == $_ } @{ $TimeWorkingHours->{ $LDay{$WDay} } } ) {
                    if ( $Param{Time} > 60 * 60 ) {
                        my $RestOfHour = 3600 - ( $Minute * 60 + $Second );
                        $DestinationTime += $RestOfHour;
                        $Param{Time} -= $RestOfHour;
                    }
                    else {
                        $DestinationTime += $Param{Time};
                        last LOOP;
                    }
                }

                # Not a working hour
                else {
                    my $RestOfHour = 3600 - ( $Minute * 60 + $Second );
                    $DestinationTime += $RestOfHour;
                }

                # Here we are always aligned at an hour boundary
                $Minute = 0;
                $Second = 0;
            }
        }

        # Find the unix time stamp for the next day at 00:00:00 to start for calculation.
        my $NewCTime = $Self->Date2SystemTime(
            Year   => $Year,
            Month  => $Month,
            Day    => $Day,
            Hour   => 23,
            Minute => 59,
            Second => 59,
        ) + 1;

        # Compensate for switching to/from daylight saving time
        # (day is shorter or longer than 24h)
        if ( $NewCTime != $CTime00 + 24 * 60 * 60 ) {
            my $Diff = $NewCTime - $CTime00 - 24 * 60 * 60;
            $DestinationTime += $Diff;
        }

        # Set next loop time to 00:00:00 of next day.
        $CTime = $NewCTime;
    }

    # return destination time - e. g. with diff of calendar time zone
    return $DestinationTime - $Zone;
}

=item VacationCheck()

check if the selected day is a vacation (it doesn't matter if you
insert 01 or 1 for month or day in the function or in the SysConfig)

returns (true) vacation day if exists, returns false if date is no
vacation day

    $TimeObject->VacationCheck(
        Year     => 2005,
        Month    => 7 || '07',
        Day      => 13,
    );

    $TimeObject->VacationCheck(
        Year     => 2005,
        Month    => 7 || '07',
        Day      => 13,
        Calendar => 3, # '' is default; 0 is handled like ''
    );

=cut

sub VacationCheck {
    my ( $Self, %Param ) = @_;

    # check required params
    for (qw(Year Month Day)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "VacationCheck: Need $_!",
            );
            return;
        }
    }

    my $Year  = $Param{Year};
    my $Month = sprintf "%02d", $Param{Month};
    my $Day   = sprintf "%02d", $Param{Day};

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $TimeVacationDays        = $ConfigObject->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $ConfigObject->Get('TimeVacationDaysOneTime');
    if ( $Param{Calendar} ) {
        if ( $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} . "Name" ) ) {
            my $Prefix = 'TimeVacationDays';
            my $Key    = '::Calendar' . $Param{Calendar};
            $TimeVacationDays        = $ConfigObject->Get( $Prefix . $Key );
            $TimeVacationDaysOneTime = $ConfigObject->Get( $Prefix . 'OneTime' . $Key );
        }
    }

    # '01' - format
    if ( defined $TimeVacationDays->{$Month}->{$Day} ) {
        return $TimeVacationDays->{$Month}->{$Day};
    }
    if ( defined $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day} ) {
        return $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day};
    }

    # 1 - int format
    $Month = int $Month;
    $Day   = int $Day;
    if ( defined $TimeVacationDays->{$Month}->{$Day} ) {
        return $TimeVacationDays->{$Month}->{$Day};
    }
    if ( defined $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day} ) {
        return $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day};
    }

    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
