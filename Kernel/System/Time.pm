# --
# Kernel/System/Time.pm - time functions
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Time.pm,v 1.41 2008-04-11 15:53:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Time;

use strict;
use warnings;

use Time::Local;

use vars qw(@ISA $VERSION);

$VERSION = qw($Revision: 1.41 $) [1];

=head1 NAME

Kernel::System::Time - time functions

=head1 SYNOPSIS

This module is managing time functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a time object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Time;

    my $ConfigObject = Kernel::Config->new();

    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );

    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = { %Param };
    bless( $Self, $Type );

    # check needed objects
    for (qw(ConfigObject LogObject)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    # 0=off; 1=on;
    $Self->{Debug} = 0;

    $Self->{TimeZone} = $Param{TimeZone}
        || $Param{UserTimeZone}
        || $Self->{ConfigObject}->Get('TimeZone')
        || 0;
    $Self->{TimeSecDiff} = $Self->{TimeZone} * 3600; # 60 * 60

    return $Self;
}

=item SystemTime()

returns the number of non-leap seconds since what ever time the
system considers to be the epoch (that's 00:00:00, January 1, 1904
for Mac OS, and 00:00:00 UTC, January 1, 1970 for most other systems).

    my $SystemTime = $TimeObject->SystemTime();

=cut

sub SystemTime {
    my ($Self) = @_;

    return time() + $Self->{TimeSecDiff};
}

=item SystemTime2TimeStamp()

returns a time stamp in "yyyy-mm-dd 23:59:59" format.

    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $SystemTime,
    );

If you need the short format "23:59:59" if the date is today (if needed).

    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $SystemTime,
        Type       => 'Short',
    );

=cut

sub SystemTime2TimeStamp {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SystemTime} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need SystemTime!' );
        return;
    }

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->SystemTime2Date( %Param );
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

    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );

=cut

sub SystemTime2Date {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SystemTime} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need SystemTime!' );
        return;
    }

    # get time format
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay ) = localtime $Param{SystemTime};
    $Year  = $Year + 1900;
    $Month = $Month + 1;
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need String!' );
        return;
    }

    my $SytemTime = 0;

    # match iso date format
    if ( $Param{String} =~ /(\d\d\d\d)-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/ ) {
        $SytemTime = $Self->Date2SystemTime(
            Year   => $1,
            Month  => $2,
            Day    => $3,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # match euro time format
    elsif ( $Param{String} =~ /(\d\d|\d)\.(\d\d|\d)\.(\d\d\d\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/ ) {
        $SytemTime = $Self->Date2SystemTime(
            Year   => $3,
            Month  => $2,
            Day    => $1,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # match mail time format
    elsif ( $Param{String} =~ /((...),\s+|)(\d\d|\d)\s(...)\s(\d\d\d\d)\s(\d\d|\d):(\d\d|\d):(\d\d|\d)\s((\+|\-)(\d\d)(\d\d)|...)/ ) {
        my $DiffTime = 0;
        if ( $10 eq '+' ) {

            #            $DiffTime = $DiffTime - ($11 * 60 * 60);
            #            $DiffTime = $DiffTime - ($12 * 60);
        }
        elsif ( $10 eq '-' ) {

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
        $SytemTime = $Self->Date2SystemTime(
            Year   => $5,
            Month  => $Month,
            Day    => $3,
            Hour   => $6,
            Minute => $7,
            Second => $8,
        ) + $DiffTime + $Self->{TimeSecDiff};
    }

    # return error
    if ( !$SytemTime ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Invalid Date '$Param{String}'!",
        );
    }

    # return system time
    return $SytemTime;

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my $SytemTime = eval {
        timelocal( $Param{Second}, $Param{Minute}, $Param{Hour}, $Param{Day}, ( $Param{Month} - 1 ), $Param{Year} );
    };

    if ( !$SytemTime ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Invalid Date '$Param{Year}-$Param{Month}-$Param{Day} $Param{Hour}:$Param{Minute}:$Param{Second}'!",
        );
        return;
    }

    return $SytemTime;
}

=item MailTimeStamp()

returns the current utc time stamp in "Wed, 22 Sep 2004 16:30:57 +0000"
format (used for email Date time stamps).

    my $MailTimeStamp = $TimeObject->MailTimeStamp();

=cut

sub MailTimeStamp {
    my ( $Self, %Param ) = @_;

    my @DayMap   = qw/Sun Mon Tue Wed Thu Fri Sat/;
    my @MonthMap = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
    my @GMTime   = gmtime();
    my @LTime    = localtime();
    my $GUTime   = $Self->Date2SystemTime(
        Year   => $GMTime[5] + 1900,
        Month  => $GMTime[4] + 1,
        Day    => $GMTime[3],
        Hour   => $GMTime[2],
        Minute => $GMTime[1],
        Second => $GMTime[0],
    );
    my $LUTime = $Self->Date2SystemTime(
        Year   => $LTime[5] + 1900,
        Month  => $LTime[4] + 1,
        Day    => $LTime[3],
        Hour   => $LTime[2],
        Minute => $LTime[1],
        Second => $LTime[0],
    );
    my $DifTime = $LUTime - $GUTime;
    my ( $DH, $DM, $DP );

    if ( $DifTime =~ /^-(.*)/ ) {
        $DifTime = $1;
        $DP      = '-';
    }
    if ( !$DP ) {
        $DP = '+';
    }
    if ( $DifTime >= 3599 ) {
        $DH = sprintf( "%02d", int( $DifTime / 3600 ) );
        $DM = sprintf( "%02d", int( ( $DifTime / 60 ) % 60 ) );
    }
    else {
        $DH = '00';
        $DM = sprintf( "%02d", int( $DifTime / 60 ) );
    }
    $GMTime[5] = $GMTime[5] + 1900;
    $LTime[5]  = $LTime[5] + 1900;
    my $TimeString = "$DayMap[$LTime[6]], $LTime[3] $MonthMap[$LTime[4]] $LTime[5] "
        . sprintf( "%02d", $LTime[2] ) . ":"
        . sprintf( "%02d", $LTime[1] ) . ":"
        . sprintf( "%02d", $LTime[0] )
        . " $DP$DH$DM";
    return $TimeString;
}

=item WorkingTime()

get the working time in secondes between this times

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my $TimeWorkingHours        = $Self->{ConfigObject}->Get('TimeWorkingHours');
    my $TimeVacationDays        = $Self->{ConfigObject}->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $Self->{ConfigObject}->Get('TimeVacationDaysOneTime');
    if ( $Param{Calendar} ) {
        if ( $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $Param{Calendar} . "Name" ) ) {
            $TimeWorkingHours = $Self->{ConfigObject}->Get( "TimeWorkingHours::Calendar" . $Param{Calendar} );
            $TimeVacationDays = $Self->{ConfigObject}->Get( "TimeVacationDays::Calendar" . $Param{Calendar} );
            $TimeVacationDaysOneTime = $Self->{ConfigObject}->Get( "TimeVacationDaysOneTime::Calendar" . $Param{Calendar} );
            my $Zone = $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $Param{Calendar} );
            if ($Zone) {
                if ( $Zone > 0 ) {
                    $Zone = '+' . ( $Zone * 60 * 60 );
                }
                else {
                    $Zone = ( $Zone * 60 * 60 );
                    $Zone =~ s/\+/-/;
                }
                $Param{StartTime} = $Param{StartTime} + $Zone;
                $Param{StopTime}  = $Param{StopTime} + $Zone;
            }
        }
    }
    my $Counted = 0;
    my ( $ASec, $AMin, $AHour, $ADay, $AMonth, $AYear, $AWDay ) = localtime $Param{StartTime};
    $AYear  = $AYear + 1900;
    $AMonth = $AMonth + 1;
    my $ADate = "$AYear-$AMonth-$ADay";
    my ( $BSec, $BMin, $BHour, $BDay, $BMonth, $BYear, $BWDay ) = localtime $Param{StopTime};
    $BYear  = $BYear + 1900;
    $BMonth = $BMonth + 1;
    my $BDate = "$BYear-$BMonth-$BDay";

    while ( $Param{StartTime} < $Param{StopTime} ) {
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay ) = localtime $Param{StartTime};
        $Year  = $Year + 1900;
        $Month = $Month + 1;
        my $CDate = "$Year-$Month-$Day";
        my %LDay  = (
            1 => 'Mon',
            2 => 'Tue',
            3 => 'Wed',
            4 => 'Thu',
            5 => 'Fri',
            6 => 'Sat',
            0 => 'Sun',
        );

        # count noting because of vacation
        if (   $TimeVacationDays->{$Month}->{$Day}
            || $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day} )
        {

            # do noting
        }
        else {
            if ( $TimeWorkingHours->{ $LDay{$WDay} } ) {
                for ( @{ $TimeWorkingHours->{ $LDay{$WDay} } } ) {

                    # count minutes on same date and same hour of start/end date
                    # within service hour => start counting and finish immediatly
                    if ( $ADate eq $BDate && $AHour == $BHour && $AHour == $_ ) {
                        return ( ( $BMin - $AMin ) * 60 );
                    }

                    # do nothing because we are on start day and not yet within service hour
                    elsif ( $CDate eq $ADate && $_ < $AHour ) {
                    }

                    # count minutes because we are on start day and within start hour
                    elsif ( $CDate eq $ADate && $AHour == $_ ) {
                        $Counted = $Counted + ( 60 - $AMin ) * 60;
                    }

                    # do nothing because we are on end day but greater than service hour
                    elsif ( $CDate eq $BDate && $BHour < $_ ) {
                    }

                    # count minutes because we are on end day and within end hour
                    elsif ( $CDate eq $BDate && $BHour == $_ ) {
                        $Counted = $Counted + $BMin * 60;
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
        $Param{StartTime} = $Param{StartTime} + 60 * 60 * ( 24 - $Hour ) - 60 * $Min - $Sec;
    }
    return $Counted;
}

=item DestinationTime()

get the destination time (working time cal.) from start plus some time in secondes

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

    my $Zone = 0;

    # check needed stuff
    for (qw(StartTime Time)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my $TimeWorkingHours        = $Self->{ConfigObject}->Get('TimeWorkingHours');
    my $TimeVacationDays        = $Self->{ConfigObject}->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $Self->{ConfigObject}->Get('TimeVacationDaysOneTime');
    if ( $Param{Calendar} ) {
        if ( $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $Param{Calendar} . "Name" ) ) {
            $TimeWorkingHours = $Self->{ConfigObject}->Get( "TimeWorkingHours::Calendar" . $Param{Calendar} );
            $TimeVacationDays = $Self->{ConfigObject}->Get( "TimeVacationDays::Calendar" . $Param{Calendar} );
            $TimeVacationDaysOneTime = $Self->{ConfigObject}->Get( "TimeVacationDaysOneTime::Calendar" . $Param{Calendar} );
            $Zone = $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $Param{Calendar} );
            if ( $Zone > 0 ) {
                $Zone = '+' . ( $Zone * 3600 ); # 60 * 60
            }
            else {
                $Zone = ( $Zone * 3600 ); # 60 * 60
                $Zone =~ s/\+/-/;
            }
            $Param{StartTime} = $Param{StartTime} + $Zone;
        }
    }
    my $DestinationTime = $Param{StartTime};
    my $CTime           = $Param{StartTime};
    my $First           = 0;
    my $FirstTurn       = 1;
    my $Count           = 1;
    my ( $ASec, $AMin, $AHour, $ADay, $AMonth, $AYear, $AWDay ) = localtime $Param{StartTime};
    $AYear  = $AYear + 1900;
    $AMonth = $AMonth + 1;
    my $ADate = "$AYear-$AMonth-$ADay";
    $Param{Time}++;

    while ( $Param{Time} > 1 ) {
        $Count++;
        last if $Count > 100;

        my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay ) = localtime $CTime;
        $Year  = $Year + 1900;
        $Month = $Month + 1;
        my $CDate = "$Year-$Month-$Day";
        my %LDay  = (
            1 => 'Mon',
            2 => 'Tue',
            3 => 'Wed',
            4 => 'Thu',
            5 => 'Fri',
            6 => 'Sat',
            0 => 'Sun',
        );

        # count noting becouse of vacation
        if (   $TimeVacationDays->{$Month}->{$Day}
            || $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day} )
        {

            # do noting
            if ($FirstTurn) {
                $First           = 1;
                $DestinationTime = $Self->Date2SystemTime(
                    Year   => $Year,
                    Month  => $Month,
                    Day    => $Day,
                    Hour   => 0,
                    Minute => 0,
                    Second => 0,
                );
            }
            $DestinationTime = $DestinationTime + 60 * 60 * 24;
            $FirstTurn       = 0;
        }
        else {
            if ( $TimeWorkingHours->{ $LDay{$WDay} } ) {
                for my $H ( $Hour .. 23 ) {
                    my $Hit = 0;
                    for ( @{ $TimeWorkingHours->{ $LDay{$WDay} } } ) {
                        if ( $H == $_ ) {
                            $Hit = 1;
                        }
                    }
                    if ($Hit) {
                        if ( $Param{Time} > 60 * 60 ) {
                            if ( $Min != 0 && $FirstTurn ) {
                                my $Max = 60 - $Min;
                                $Param{Time} = $Param{Time} - ( $Max * 60 );
                                $DestinationTime = $DestinationTime + ( $Max * 60 );
                                $FirstTurn = 0;
                            }
                            else {
                                $Param{Time} = $Param{Time} - ( 60 * 60 );
                                $DestinationTime = $DestinationTime + ( 60 * 60 );
                                $FirstTurn = 0;
                            }
                        }
                        elsif ( $Param{Time} > 1 * 60 ) {
                            for my $M ( 0 .. 59 ) {
                                if ( $Param{Time} > 1 ) {
                                    $Param{Time}     = $Param{Time} - 60;
                                    $DestinationTime = $DestinationTime + 60;
                                    $FirstTurn       = 0;
                                }
                            }
                        }
                        else {
                            last;
                        }
                    }
                    else {
                        if ($FirstTurn) {
                            $First           = 1;
                            $DestinationTime = $Self->Date2SystemTime(
                                Year   => $Year,
                                Month  => $Month,
                                Day    => $Day,
                                Hour   => $H,
                                Minute => 0,
                                Second => 0,
                            );
                        }
                        if ( $Param{Time} > 59 ) {
                            $DestinationTime = $DestinationTime + ( 60 * 60 );
                        }
                    }
                }
            }
        }

        # Find the unix time stamp for the next day at 00:00:00 to
        # start for calculation.
        my $NewCTime = $Self->Date2SystemTime(
            Year   => $Year,
            Month  => $Month,
            Day    => $Day,
            Hour   => 0,
            Minute => 0,
            Second => 0,
        ) + ( 60 * 60 * 24 );

        # Protect local time zone problems on your machine
        # (e. g. sommertime -> wintertime) and not getting
        # over to the next day.
        if ($NewCTime == $CTime) {
            $CTime = $CTime + ( 60 * 60 * 24 );

            # reduce destination time diff between today and tomrrow
            my ( $NextSec, $NextMin, $NextHour, $NextDay, $NextMonth, $NextYear ) = localtime $CTime;
            $NextYear  = $NextYear + 1900;
            $NextMonth = $NextMonth + 1;

            my $Diff = ( $Self->Date2SystemTime(
                Year   => $NextYear,
                Month  => $NextMonth,
                Day    => $NextDay,
                Hour   => 0,
                Minute => 0,
                Second => 0,
            ) - $Self->Date2SystemTime(
                Year   => $Year,
                Month  => $Month,
                Day    => $Day,
                Hour   => 0,
                Minute => 0,
                Second => 0,
            ) ) - ( 60 * 60 * 24 );
            $DestinationTime = $DestinationTime - $Diff;
        }

        # Set next loop time to 00:00:00 of next day.
        else {
            $CTime = $NewCTime;
        }
    }

    # return destination time - e. g. with diff of calendar time zone
    return $DestinationTime - $Zone;
}

=item VacationCheck()

check if the selected day is a vacation (it doesn't matter if you
insert 01 or 1 for month or day in the function or in the SysConfig)

    $TimeAccountingObject->VacationCheck(
        Year  => 2005,
        Month => 7 || '07',
        Day   => 13,
    );

=cut

sub VacationCheck {
    my ( $Self, %Param ) = @_;

    my $VacationName = '';

    # check required params
    for (qw(Year Month Day)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "VacationCheck: Need $_!"
            );
            return;
        }
    }
    $Param{Month} = sprintf "%02d", $Param{Month};
    $Param{Day}   = sprintf "%02d", $Param{Day};

    my $TimeVacationDays        = $Self->{ConfigObject}->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $Self->{ConfigObject}->Get('TimeVacationDaysOneTime');

    if ( defined $TimeVacationDays->{ $Param{Month} }->{ $Param{Day} } ) {
        return $TimeVacationDays->{ $Param{Month} }->{ $Param{Day} };
    }
    elsif ( defined $TimeVacationDaysOneTime->{ $Param{Year} }->{ $Param{Month} }->{ $Param{Day} } ) {
        return $TimeVacationDaysOneTime->{ $Param{Year} }->{ $Param{Month} }->{ $Param{Day} };
    }
    elsif ( defined $TimeVacationDays->{ int( $Param{Month} ) }->{ int( $Param{Day} ) } ) {
        return $TimeVacationDays->{ int( $Param{Month} ) }->{ int( $Param{Day} ) };
    }
    elsif ( defined $TimeVacationDaysOneTime->{ $Param{Year} }->{ int( $Param{Month} ) }->{ int( $Param{Day} ) } ) {
        return $TimeVacationDaysOneTime->{ $Param{Year} }->{ int( $Param{Month} ) }->{ int( $Param{Day} ) };
    }
    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.41 $ $Date: 2008-04-11 15:53:42 $

=cut
