
###############################################################################
##                                                                           ##
##    Copyright (c) 1999-2001 by J. David Eisenberg                          ##
##                                                                           ##
##    Documentation and some of the Perl code                                ##
##    Copyright (c) 1993-2001 by Steffen Beyer.                              ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

package Date::Pcalc;

use strict;

use vars
qw(
    $VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS
    $Year_of_Epoch
    $Century_of_Epoch
    $Epoch
    $pcalc_Language
    $pcalc_Languages
    @arr_Days_in_Year
    @arr_Days_in_Month
    @arr_Month_to_Text
    @arr_Day_of_Week_to_Text
    @arr_Day_of_Week_Abbreviation
    @arr_Language_to_Text
    @english_ordinal_suffix
    @date_long_format
);

require Exporter;

@ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

@EXPORT = qw();
@EXPORT_OK =
qw(
    Days_in_Year
    Days_in_Month
    Weeks_in_Year
    leap_year
    check_date
    check_business_date
    Day_of_Year
    Date_to_Days
    Day_of_Week
    Week_Number
    Week_of_Year
    Monday_of_Week
    Nth_Weekday_of_Month_Year
    Standard_to_Business
    Business_to_Standard
    Delta_Days
    Delta_DHMS
    Add_Delta_Days
    Add_Delta_DHMS
    Add_Delta_YMD
    System_Clock
    Today
    Now
    Today_and_Now
    Easter_Sunday
    Decode_Month
    Decode_Day_of_Week
    Decode_Language
    Compress
    Uncompress
    check_compressed
    Compressed_to_Text
    Date_to_Text
    Date_to_Text_Long
    English_Ordinal
    Calendar
    Month_to_Text
    Day_of_Week_to_Text
    Day_of_Week_Abbreviation
    Language_to_Text
    Language
    Languages
    Decode_Date_EU
    Decode_Date_US
    Decode_Date_EU2
    Decode_Date_US2
    Parse_Date
);

%EXPORT_TAGS = (all => [@EXPORT_OK] );

##################################################
##                                              ##
##  "Version()" is available but not exported   ##
##  in order to avoid possible name clashes.    ##
##  Call with "Date::Pcalc::Version()" instead! ##
##                                              ##
##################################################

$VERSION = '1.2';

use Carp;

$Year_of_Epoch = 70;
$Century_of_Epoch = 1900;
$Epoch = $Century_of_Epoch + $Year_of_Epoch;
$pcalc_Language = 1;
$pcalc_Languages = 7;

#
#    Array names have been changed from the form
#
#       some_name_ --> arr_some_name
#
#    to make them easier to distinguish
#

@arr_Days_in_Year = (
[ 0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 ],
[ 0, 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 ]
);

@arr_Days_in_Month = (
[ 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ],
[ 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
);

@arr_Month_to_Text =
(
    [
        "???", "???", "???", "???", "???", "???", "???",
        "???", "???", "???", "???", "???", "???"
    ],
    [
        "???", "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ],
    [
        "???", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
        "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
    ],
    [
        "???", "Januar", "Februar", "März", "April", "Mai", "Juni",
        "Juli", "August", "September", "Oktober", "November", "Dezember"
    ],
    [
        "???", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
        "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    ],
    [
        "???", "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ],
    [
        "???", "Januari", "Februari", "Maart", "April", "Mei", "Juni",
        "Juli", "Augustus", "September", "October", "November", "December"
    ],
    [
        "???", "Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno",
        "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"
    ]
);


@arr_Day_of_Week_to_Text =
(
    [
        "???", "???", "???", "???",
        "???", "???", "???", "???"
    ],
    [
        "???", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday", "Sunday"
    ],
    [
        "???", "Lundi", "Mardi", "Mercredi",
        "Jeudi", "Vendredi", "Samedi", "Dimanche"
    ],
    [
        "???", "Montag", "Dienstag", "Mittwoch",
        "Donnerstag", "Freitag", "Samstag", "Sonntag"
    ],
    [
        "???", "Lunes", "Martes", "Miércoles",
        "Jueves", "Viernes", "Sábado", "Domingo"
    ],
    [
        "???", "Segunda-feira", "Terça-feira", "Quarta-feira",
        "Quinta-feira", "Sexta-feira", "Sábado", "Domingo"
    ],
    [
        "???", "Maandag", "Dinsdag", "Woensdag",
        "Donderdag", "Vrijdag", "Zaterdag", "Zondag"
    ],
    [
        "???", "Lunedì", "Martedì", "Mercoledì",
        "Giovedì", "Venerdì", "Sabato", "Domenica"
    ]
);

@arr_Day_of_Week_Abbreviation =

    # Fill the fields below _only_ if special abbreviations are needed!
    # Note that the first field serves as a flag and must be non-empty!
(
    [
        "", "", "", "", "", "", "", ""    # 0
    ],
    [
        "", "", "", "", "", "", "", ""    # 1
    ],
    [
        "", "", "", "", "", "", "", ""    # 2
    ],
    [
        "", "", "", "", "", "", "", ""    # 3
    ],
    [
        "", "", "", "", "", "", "", ""    # 4
    ],
    [
        "???", "2ª", "3ª", "4ª", "5ª", "6ª", "Sáb", "Dom"    # 5
    ],
    [
        "", "", "", "", "", "", "", ""    # 6
    ],
    [
        "", "", "", "", "", "", "", ""    # 7
    ]
);

@english_ordinal_suffix = ("th", "st", "nd", "rd");

@date_long_format = (
    "%s, %d %s %d",                     # 0  Default
    "%s, %s %s %d",                     # 1  English
    "%s, le %d %s %d",                  # 2  Français
    "%s, den %d. %s %d",                # 3  Deutsch
    "%s, %d de %s de %d",               # 4  Español
    "%s, dia %d de %s de %d",           # 5  Português
    "%s, %d. %s %d",                    # 6  Nederlands
    "%s, %d %s %d"                      # 7  Italiano
);

@arr_Language_to_Text =
(
    "???", "English", "Français", "Deutsch", "Español",
    "Português", "Nederlands", "Italiano"
);

sub DATECALC_ERROR
{
    my ($name, $err) = @_;
    croak(__PACKAGE__ ."::${name}(): $err");
}

sub DATECALC_DATE_ERROR
{
    my ($name) = @_;
    croak("Date::Pcalc::${name}(): not a valid date");
}

sub DATECALC_TIME_ERROR
{
    my ($name) = @_;
    croak("Date::Pcalc::${name}(): not a valid time");
}

sub DATECALC_YEAR_ERROR
{
    my ($name) = @_;
    croak("Date::Pcalc::${name}(): year out of range");
}

sub DATECALC_MONTH_ERROR
{
    my ($name) = @_;
    croak("Date::Pcalc::${name}(): month out of range");
}

sub DATECALC_WEEK_ERROR
{
    my ($name) = @_;
    croak("Date::Pcalc::${name}(): week out of range");
}

sub DATECALC_DAYOFWEEK_ERROR
{
    my ($name) = @_;
    croak("Date::Pcalc::${name}(): day of week out of range");
}

sub DATECALC_FACTOR_ERROR
{
    my ($name) = @_;
    croak("Date::Pcalc::${name}(): factor out of range");
}

sub DATECALC_LANGUAGE_ERROR
{
    my ($name) = @_;
    croak("Date::Pcalc::${name}(): language not available");
}

sub DATECALC_SYSTEM_ERROR
{
    my ($name) = @_;
    croak("Date::Pcalc::${name}(): not available on this system");
}

sub DATECALC_MEMORY_ERROR
{
    my ($name) = @_;
    croak("Date::Pcalc::${name}(): unable to allocate memory");
}

sub Year_to_Days
{
    my ($year) = @_;
    my $days = 365 * $year;

    $days += ($year >>= 2);
    $year = int ($year / 25);
    $days -= $year;
    $days += ($year >>  2);
    return $days;
}

sub leap_year
{
    my ($year) = @_;
    my $yy = int ($year/100);
    if ($year > 0)
    {
        return ((($year & 0x03) ==0) &&
            (( $yy * 100 != $year) ||
              (($yy & 0x03) == 0) ) ) ? 1 : 0;
    }
    else
    {
        DATECALC_YEAR_ERROR("leap_year");
    }
}

sub Days_in_Year
{
    my ($year, $month) = @_;
    if ($year > 0)
    {
        if (($month >= 1) && ($month <= 12))
        {
            return $arr_Days_in_Year[leap_year($year)][$month+1];
        }
        else
        {
            DATECALC_MONTH_ERROR("Days_in_Year");
        }
    }
    else
    {
        DATECALC_YEAR_ERROR("Days_in_Year");
    }
}

sub Days_in_Month
{
    my ($year, $month) = @_;
    if ($year > 0)
    {
        if (($month >= 1) && ($month <= 12))
        {
            return $arr_Days_in_Month[leap_year($year)][$month];
        }
        else
        {
            DATECALC_MONTH_ERROR("Days_in_Month");
        }
    }
    else
    {
        DATECALC_YEAR_ERROR("Days_in_Month");
    }
}

sub Weeks_in_Year
{
    my ($year) = @_;
    if ($year > 0)
    {
        return 52 + (((Day_of_Week($year, 1, 1) == 4) ||
            (Day_of_Week($year, 12, 31) == 4) ) ? 1 : 0);
    }
    else
    {
        DATECALC_YEAR_ERROR("Weeks_in_Year");
    }
}

sub check_date
{
    my ($year, $month, $day) = @_;
    return (($year >= 1) &&
        ($month >= 1) && ($month <= 12) &&
        ($day >= 1) &&
        ($day <= $arr_Days_in_Month[leap_year($year)][$month])) ? 1 : 0;
}

#
#    This new function returns
#
#    -1    invalid date
#    0  non-leap year
#     1    valid leap year
#

sub check_date_leap
{
    my ($year, $month, $day) = @_;
    my $leap = leap_year($year);
    return (($year >= 1) &&
        ($month >= 1) && ($month <= 12) &&
        ($day >= 1) &&
        ($day <= $arr_Days_in_Month[$leap][$month])) ? $leap : -1;
}

sub check_business_date
{
    my ($year, $week, $dow) = @_;

    return (($year >= 1) &&
        ($week >= 1) && ($week <= Weeks_in_Year($year)) &&
        ($dow >= 1) && ($dow <= 7)) ? 1 : 0;
}

sub Day_of_Year
{
    my ($year, $month, $day) = @_;
    my ($leap) = check_date_leap($year, $month, $day);
    if ( $leap >= 0)
    {
        return $arr_Days_in_Year[$leap][$month] + $day;
    }
    else
    {
        DATECALC_DATE_ERROR("Day_of_Year");
    }
}

sub Date_to_Days
{
    my ($year, $month, $day) = @_;
    my $leap = check_date_leap( $year, $month, $day );

    if ($leap >= 0)
    {
        return (Year_to_Days(--$year) +
            $arr_Days_in_Year[$leap][$month] + $day );
    }
    else
    {
        DATECALC_DATE_ERROR("Date_to_Days");
    }
}

sub Day_of_Week
{
    my ($year, $month, $day) = @_;
    my $n_days = Date_to_Days($year, $month, $day);
    if ($n_days > 0)
    {
        $n_days--;
        $n_days %= 7;
        $n_days++;
        return $n_days;
    }
    else
    {
        DATECALC_DATE_ERROR("Date_of_Week");
    }
}

sub Week_Number
{
    my ($year, $month, $day) = @_;
    my $first;
    if (check_date($year, $month, $day))
    {
        $first = Day_of_Week($year, 1, 1) - 1;
        return int (( core_delta_days($year, 1, 1, $year, $month, $day) +
           $first) / 7) + (($first < 4) ? 1 : 0);
    }
    else
    {
        DATECALC_DATE_ERROR("Week_Number");
    }
}

sub Week_of_Year
{
    my ($year, $month, $day) = @_;
    my $week;

    if (($week, $year) = core_Week_of_Year( $year, $month, $day ))
    {
        return ($week, $year);
    }
    else
    {
        DATECALC_DATE_ERROR("Week_of_Year");
    }
}

sub core_Week_of_Year
{
    my ($year, $month, $day) = @_;
    my $week;

    if (check_date($year, $month, $day))
    {
        $week = Week_Number($year, $month, $day);
        if ($week == 0)
        {
            $week = Weeks_in_Year(--$year);
        }
        elsif ($week > Weeks_in_Year($year))
        {
            $week = 1;
            $year++;
        }
        return ($week, $year);
    }
    else
    {
        return ();
    }
}

sub Monday_of_Week
{
    my ($week, $year) = @_;
    my ($first, $month, $day);


    if ($year > 0)
    {
        if (($week > 0) && ($week <= Weeks_in_Year($year)))
        {
            $month = $day = 1;
            $first = Day_of_Week($year, 1, 1) - 1;
            if ($first < 4)
            {
                $week--;
            }
            ($year, $month, $day) = core_add_delta_days($year, $month,
                $day, ($week * 7 - $first) );
            return ($year, $month, $day);
        }
        else
        {
            DATECALC_WEEK_ERROR("Monday_of_Week");
        }
    }
    else
    {
        DATECALC_YEAR_ERROR("Monday_of_Week");
    }
}

sub Nth_Weekday_of_Month_Year
{
    my ($year, $month, $dow, $n) = @_;
    my ($day, $first, $delta, $mm);
    $mm = $month;

    if ($year > 0)
    {
        if (($month >= 1) && ($month <= 12))
        {
            if (($dow >= 1) && ($dow <= 7))
            {
                if (($n >= 1) && ($n <= 5))
                {
                    $day = 1;
                    $first = Day_of_Week($year, $mm, 1);
                    if ($dow < $first)
                    {
                        $dow += 7;
                    }
                    $delta = $dow - $first;
                    $delta += ($n-1) * 7;
                    ($year, $month, $day) =
                        core_add_delta_days($year, $month, $day, $delta);
                    if ($year && ($month == $mm))
                    {
                        return ($year, $month, $day);
                    }
                    else
                    {
                        return ();
                    }
                }
                else
                {
                    DATECALC_FACTOR_ERROR("Nth_Weekday_of_Month_Year");
                }
            }
            else
            {
                DATECALC_DAYOFWEEK_ERROR("Nth_Weekday_of_Month_Year");
            }
        }
        else
        {
            DATECALC_MONTH_ERROR("Nth_Weekday_of_Month_Year");
        }
    }
    else
    {
        DATECALC_YEAR_ERROR("Nth_Weekday_of_Month_Year");
    }
}

sub Standard_to_Business
{
    my ($year, $month, $day) = @_;
    my ($week, $dow, $yy);

    $yy = $year;
    if (($week, $year) = core_Week_of_Year($year, $month, $day))
    {
        $dow = Day_of_Week($yy, $month, $day);
        return ($year, $week, $dow);
    }
    else
    {
        DATECALC_DATE_ERROR("Standard_to_Business");
    }
}

sub Business_to_Standard
{
    my ($year, $week, $dow) = @_;
    my ($month, $day, $delta, $first, $result);

        $result = 0;
    if (check_business_date($year, $week, $dow))
    {
        $month = $day = 1;
        $first = Day_of_Week($year, 1, 1);
        $delta = (($week + (($first > 4) ? 1 : 0) - 1) * 7) + ($dow - $first);
        if (($year, $month, $day) = core_add_delta_days($year, $month, $day, $delta))
        { $result = 1; }
    }
    if ($result)
    {
        return ($year, $month, $day);
    }
    else
    {
        DATECALC_DATE_ERROR("Business_to_Standard");
    }
}

sub Delta_Days
{
    my ($year1, $month1, $day1, $year2, $month2, $day2) = @_;
    if (check_date($year1, $month1, $day1) &&
        check_date($year2, $month2, $day2))
    {
        return core_delta_days($year1, $month1, $day1, $year2, $month2, $day2);
    }
    else
    {
        DATECALC_DATE_ERROR("Delta_Days");
    }
}

sub core_delta_days
{
    my ($year1, $month1, $day1, $year2, $month2, $day2) = @_;
    return Date_to_Days($year2, $month2, $day2) -
        Date_to_Days($year1, $month1, $day1);
}

sub Delta_DHMS
{
    my ($year1, $month1, $day1, $hour1, $min1, $sec1,
        $year2, $month2, $day2, $hour2, $min2, $sec2) = @_;
    my ($Dd, $Dh, $Dm, $Ds, $delta, $quot, $sign);

    if (check_date($year1, $month1, $day1) &&
        check_date($year2, $month2, $day2))
    {
        if (($hour1 >= 0) && ($min1 >= 0) && ($sec1 >= 0) &&
            ($hour2 >= 0) && ($min2 >= 0) && ($sec2 >= 0) &&
            ($hour1 < 24) && ($min1 < 60) && ($sec1 < 60) &&
            ($hour2 < 24) && ($min2 < 60) && ($sec2 < 60))
        {
            $Dd = $Dh = $Dm = $Ds = 0;
            $delta = (((($hour2 * 60) + $min2) * 60) + $sec2) -
                    (((($hour1 * 60) + $min1) * 60) + $sec1);
            $Dd = core_delta_days($year1, $month1, $day1, $year2, $month2, $day2);
            if ($Dd != 0)
            {
                if ($Dd > 0)
                {
                    if ($delta < 0)
                    {
                        $delta += 86400;
                        $Dd--;
                    }
                }
                else
                {
                    if ($delta > 0)
                    {
                        $delta -= 86400;
                        $Dd++;
                    }
                }
            }
            if ($delta != 0)
            {
                $sign = 0;
                if ($delta < 0)
                {
                    $sign = 1;
                    $delta = -$delta;
                }
                $quot  = int ($delta / 60);
                $Ds   = $delta - $quot * 60;
                $delta = $quot;
                $quot  = int ($delta / 60);
                $Dm   = $delta - $quot * 60;
                $Dh   = $quot;
                if ($sign)
                {
                    $Ds = -($Ds);
                    $Dm = -($Dm);
                    $Dh = -($Dh);
                }
            }
            return ($Dd, $Dh, $Dm, $Ds);
        }
        else
        {
            DATECALC_TIME_ERROR("Delta_DHMS");
        }
    }
    else
    {
        DATECALC_DATE_ERROR("Delta_DHMS");
    }
}

sub Add_Delta_Days
{
    my ($year, $month, $day, $Dd) = @_;
    ($year, $month, $day) = core_add_delta_days($year, $month, $day, $Dd);
    if ($year)
    {
        return ($year, $month, $day);
    }
    else
    {
        DATECALC_DATE_ERROR("Add_Delta_Days");
    }
}

sub core_add_delta_days
{
    my ($year, $month, $day, $Dd) = @_;
    my ($n_days, $leap);

    if ((check_date($year, $month, $day)) &&
        (($n_days = Date_to_Days($year, $month, $day)) > 0) &&
        (($n_days += $Dd) > 0))
    {
        $year = int ( $n_days / 365.2425 );
        $day  = $n_days - Year_to_Days($year);
        if ($day < 1)
        {
            $day = $n_days - Year_to_Days($year-1);
        }
        else
        {
            $year++;
        }
        $leap = leap_year($year);
        if ($day > $arr_Days_in_Year[$leap][13])
        {
            $day -= $arr_Days_in_Year[$leap][13];
            $leap  = leap_year(++$year);
        }
        for ( $month = 12; $month >= 1; $month-- )
        {
            if ($day > $arr_Days_in_Year[$leap][$month])
            {
                $day -= $arr_Days_in_Year[$leap][$month];
                last;
            }
        }
        return($year, $month, $day);
    }
    else
    {
        return();
    }
}

sub Add_Delta_DHMS
{
    my ($year, $month, $day, $hour, $min, $sec, $Dd, $Dh, $Dm, $Ds) = @_;
    my ($sum, $quot);

    if (check_date($year, $month, $day))
    {
        if (($hour >= 0) && ($min >= 0) && ($sec >= 0) &&
            ($hour < 24) && ($min < 60) && ($sec < 60))
        {
            $quot = int ($Dh / 24);
            $Dh  -= $quot * 24;
            $Dd  += $quot;
            $quot = int ($Dm / 60);
            $Dm  -= $quot * 60;
            $Dh  += $quot;
            $quot = int ($Ds / 60);
            $Ds  -= $quot * 60;
            $Dm  += $quot;
            $quot = int ($Dm / 60);
            $Dm  -= $quot * 60;
            $Dh  += $quot;
            $quot = int ($Dh / 24);
            $Dh  -= $quot * 24;
            $Dd  += $quot;

            $sum = (((($hour * 60) + $min) * 60) + $sec) +
                  (((( $Dh   * 60) +  $Dm)  * 60) +  $Ds);
            if ($sum < 0)
            {
                $quot = int ($sum / 86400);
                $sum -= $quot * 86400;
                $Dd += $quot;
                if ($sum < 0)
                {
                    $sum += 86400;
                    $Dd--;
                }
            }
            if ($sum > 0)
            {
                $quot  = int ($sum / 60);
                $sec  = $sum - $quot * 60;
                $sum  = $quot;
                $quot = int ($sum / 60);
                $min  = $sum - $quot * 60;
                $sum  = $quot;
                $quot = int ($sum / 24);
                $hour = $sum - $quot * 24;
                $Dd   += $quot;
            }
            else
            {
                $hour = $min = $sec = 0;
            }
            if (($year, $month, $day) = core_add_delta_days($year, $month, $day, $Dd))
            {
                return ($year, $month, $day, $hour, $min, $sec);
            }
            else
            {
                DATECALC_DATE_ERROR("Add_Delta_DHMS");
            }
        }
        else
        {
            DATECALC_TIME_ERROR("Add_Delta_DHMS");
        }
    }
    else
    {
        DATECALC_DATE_ERROR("Add_Delta_DHMS");
    }
}

sub Add_Delta_YMD
{
    my ($year, $month, $day, $Dy, $Dm, $Dd) = @_;
    my $delta = 0;

    if (!check_date($year, $month, $day))
    {
        DATECALC_DATE_ERROR("Add_Delta_YMD");
    }
    ($year, $month, $day) = core_add_delta_days($year, $month, $day, $Dd);

    if (($Dd != 0) && (!$year))
    {
        DATECALC_DATE_ERROR("Add_Delta_YMD");
    }
    if ($Dm != 0)
    {
        $Dm += ($month - 1);
        $delta = int ($Dm / 12);
        $Dm -= $delta * 12;
        if ($Dm < 0)
        {
            $Dm += 12;
            $delta--;
        }
        $month = ($Dm + 1);
    }
    $Dy += $delta + $year;
    if ($Dy >= 1)
    {
        $year = $Dy;
        if ($day >
            ($Dd = $arr_Days_in_Month[leap_year($year)][$month]))
        {
            $day = $Dd;
        }
        return ($year, $month, $day);
    }
    else
    {
        DATECALC_DATE_ERROR("Add_Delta_YMD");
    }
}

sub System_Clock
{
    my ($year, $month, $day, $hour, $min, $sec, $doy, $dow, $dst);

    if (($year, $month, $day, $hour, $min, $sec, $doy, $dow, $dst) =
        core_system_clock())
    {
        return ($year, $month, $day, $hour, $min, $sec, $doy, $dow, $dst);
    }
    else
    {
        DATECALC_SYSTEM_ERROR("System_Clock");
    }
}

sub core_system_clock
{
    my ($year, $month, $day, $hour, $min, $sec, $doy, $dow, $dst);

    my ($elapsed_seconds);

    $elapsed_seconds = time();
    if ($elapsed_seconds > 0)
    {
        ($sec, $min, $hour, $day, $month, $year, $dow, $doy, $dst) =
             localtime($elapsed_seconds);
        $year += 1900;
        $month++;
        $doy++;
        if ($dow == 0)
        {
            $dow = 7;
        }
        return ($year, $month, $day, $hour, $min, $sec, $doy, $dow, $dst);
    }
    else
    {
        return ();
    }
}

sub Today
{
    my ($year, $month, $day, $hour, $min, $sec, $doy, $dow, $dst);

    if (($year, $month, $day, $hour, $min, $sec, $doy, $dow, $dst) =
        core_system_clock())
    {
        return ($year, $month, $day);
    }
    else
    {
        DATECALC_SYSTEM_ERROR("Today");
    }

}

sub Now
{
    my ($year, $month, $day, $hour, $min, $sec, $doy, $dow, $dst);

    if (($year, $month, $day, $hour, $min, $sec, $doy, $dow, $dst) =
        core_system_clock())
    {
        return ($hour, $min, $sec);
    }
    else
    {
        DATECALC_SYSTEM_ERROR("Today");
    }
}

sub Today_and_Now
{
    my ($year, $month, $day, $hour, $min, $sec, $doy, $dow, $dst);

    if (($year, $month, $day, $hour, $min, $sec, $doy, $dow, $dst) =
        core_system_clock())
    {
        return ($year, $month, $day, $hour, $min, $sec);
    }
    else
    {
        DATECALC_SYSTEM_ERROR("Today_and_Now");
    }
}

sub Easter_Sunday
{
    my ($year) = @_;
    my ($month, $day);
    ################################################################
    #                                                              #
    #  Gauss'sche Regel (Gaussian Rule)                            #
    #  ================================                            #
    #                                                              #
    #  Quelle / Source:                                            #
    #                                                              #
    #  H. H. Voigt, "Abriss der Astronomie", Wissenschaftsverlag,  #
    #  Bibliographisches Institut, Seite 9.                        #
    #                                                              #
    ################################################################

    my ($a, $b, $c, $d, $e, $m, $n);

    if (($year <= 0) || ($year < 1583) || ($year > 2299))
    {
        DATECALC_YEAR_ERROR("Easter_Sunday");
    }

    if    ($year < 1700) { $m = 22; $n = 2; }
    elsif ($year < 1800) { $m = 23; $n = 3; }
    elsif ($year < 1900) { $m = 23; $n = 4; }
    elsif ($year < 2100) { $m = 24; $n = 5; }
    elsif ($year < 2200) { $m = 24; $n = 6; }
    else                 { $m = 25; $n = 0; }

    $a = $year % 19;
    $b = $year % 4;
    $c = $year % 7;
    $d = (19 * $a + $m) % 30;
    $e = (2 * $b + 4 * $c + 6 * $d + $n) % 7;
    $day = 22 + $d + $e;
    $month = 3;
    if ($day > 31)
    {
        $day -= 31; # same as $day = $d + $e - 9;
        $month++;
    }
    if (($day == 26) && ($month == 4))
    {
        $day = 19;
    }
    if (($day == 25) && ($month == 4) &&
        ($d == 28) && ($e == 6) && ($a > 10))
    {
        $day = 18;
    }
    return ($year, $month, $day);
}

#  Carnival Monday / Rosenmontag / Veille du Mardi Gras   =  easter sunday - 48
#  Mardi Gras / Karnevalsdienstag / Mardi Gras            =  easter sunday - 47
#  Ash Wednesday / Aschermittwoch / Mercredi des Cendres  =  easter sunday - 46
#  Palm Sunday / Palmsonntag / Dimanche des Rameaux       =  easter sunday - 7
#  Easter Friday / Karfreitag / Vendredi Saint            =  easter sunday - 2
#  Easter Saturday / Ostersamstag / Samedi de Paques      =  easter sunday - 1
#  Easter Monday / Ostermontag / Lundi de Paques          =  easter sunday + 1
#  Ascension of Christ / Christi Himmelfahrt / Ascension  =  easter sunday + 39
#  Whitsunday / Pfingstsonntag / Dimanche de Pentecote    =  easter sunday + 49
#  Whitmonday / Pfingstmontag / Lundi de Pentecote        =  easter sunday + 50
#  Feast of Corpus Christi / Fronleichnam / Fete-Dieu     =  easter sunday + 60

sub Decode_Month
{
    my ($month_str) = @_;
    my ($month, $len, $n_matched);

    $n_matched = 0;
    $len = length $month_str;

    $month_str = uc $month_str ;
    for ($month=1; $month<=12; $month++)
    {
        if ($month_str eq substr((uc $arr_Month_to_Text[$pcalc_Language][$month]), 0, $len))
        {
            if ($n_matched > 0)
            {
                return 0;
            }
            $n_matched = $month;
        }
    }
    return $n_matched;
}

sub Decode_Day_of_Week
{
    my ($day_str) = @_;
    my ($day, $len, $n_matched);

    $len = length $day_str;
    $n_matched = 0;

    $day_str = uc $day_str ;
    for ($day=1; $day<=7; $day++)
    {
        if ($day_str eq substr((uc $arr_Day_of_Week_to_Text[$pcalc_Language][$day]), 0, $len))
        {
            if ($n_matched > 0)
            {
                return 0;
            }
            else
            {
                $n_matched = $day;
            }
        }
    }
    return $n_matched;
}

sub Decode_Language
{
    my ($lang_str) = @_;
    my ($lang, $len, $n_matched);

    $len = length $lang_str;
    $n_matched = 0;

    $lang_str = uc $lang_str ;
    for ($lang=1; $lang<=$pcalc_Languages; $lang++)
    {
        if ($lang_str eq substr((uc $arr_Language_to_Text[$lang]), 0, $len))
        {
            if ($n_matched > 0)
            {
                return 0;
            }
            else
            {
                $n_matched = $lang;
            }
        }
    }
    return $n_matched;
}

sub Compress
{
    my ($year, $month, $day) = @_;
    my $yy;

    if (($year >= $Epoch) && ($year < ($Epoch + 100)))
    {
        $yy = $year;
        $year -= $Epoch;
    }
    else
    {
        if (($year < 0) || ($year > 99))
        {
            return(0);
        }
        if ($year < $Year_of_Epoch)
        {
            $yy = $Century_of_Epoch + 100 + $year;
            $year += 100 - $Year_of_Epoch;
        }
        else
        {
            $yy = $Century_of_Epoch + $year;
            $year -= $Year_of_Epoch;
        }
    }
    if (($month < 1) || ($month > 12))
    {
        return(0);
    }
    if (($day < 1) ||
        ($day > $arr_Days_in_Month[leap_year($yy)][$month]))
    {
      return(0);
    }
    return( ($year << 9) | ($month << 5) | $day );
}

sub Uncompress
{
    my ($date) = @_;
    my ($century, $year, $month, $day);
    if ($date > 0)
    {
        $year = $date >> 9;
        $month = ($date & 0x01ff) >> 5;
        $day = $date & 0x001f;

        if ($year < 100)
        {
            if ($year < 100 - $Year_of_Epoch)
            {
                $century = $Century_of_Epoch;
                $year += $Year_of_Epoch;
            }
            else
            {
                $century = $Century_of_Epoch + 100;
                $year -= 100 - $Year_of_Epoch;
            }

            if (check_date($century + $year, $month, $day))
            {
                return ($century, $year, $month, $day);
            }
        }
    }
    return ();
}

sub check_compressed
{
    my ($date) = @_;
    return (Uncompress($date)) ? 1 : 0;
}

sub Compressed_to_Text
{
    my ($date) = @_;
    my $str;
    my ($century, $year, $month, $day) =
        Uncompress($date);
    if (defined $century)
    {
        $str = sprintf "%02d-%.3s-%02d", $day,
            $arr_Month_to_Text[$pcalc_Language][$month], $year;
    }
    else
    {
        $str = "??-???-??";
    }
    return $str;
}

sub Date_to_Text
{
    my ($year, $month, $day) = @_;
    my $str;

    if (check_date($year, $month, $day))
    {
        if ($arr_Day_of_Week_Abbreviation[$pcalc_Language][0] ne "")
        {
            $str = sprintf "%.3s %d-%.3s-%d",
                $arr_Day_of_Week_Abbreviation[$pcalc_Language][Day_of_Week($year, $month, $day)],
                $day, $arr_Month_to_Text[$pcalc_Language][$month], $year;
        }
        else
        {
            $str = sprintf "%.3s %d-%.3s-%d",
                $arr_Day_of_Week_to_Text[$pcalc_Language][Day_of_Week($year, $month, $day)],
                $day, $arr_Month_to_Text[$pcalc_Language][$month], $year;
        }
        return $str;
    }
    return "";
}

sub Date_to_Text_Long
{
    my ($year, $month, $day) = @_;
    my $str = "";

    if (check_date($year, $month, $day))
    {
        if ($pcalc_Language == 1)
        {
            $str = sprintf( $date_long_format[$pcalc_Language],
            $arr_Day_of_Week_to_Text[$pcalc_Language][Day_of_Week($year, $month, $day)],
            $arr_Month_to_Text[$pcalc_Language][$month],
            English_Ordinal($day), $year);
        }
        else
        {
            $str = sprintf( $date_long_format[$pcalc_Language],
            $arr_Day_of_Week_to_Text[$pcalc_Language][Day_of_Week($year, $month, $day)],
            $day,
            $arr_Month_to_Text[$pcalc_Language][$month],
            $year);
        }
    }
    return $str;
}

sub English_Ordinal
{
    my ($n) = @_;
    my $digit = 0;
    my $mod;

    $mod = $n % 10;
    if ($mod <= 3)
    {
        if (int (($n % 100) / 10) != 1)
        {
            $digit = $mod;
        }
    }
    return $n . $english_ordinal_suffix[$digit];
}

sub Center
{
    my ($str, $width) = @_;
    my $len;

    $len = length $str;
    if ($len > $width)
    {
        $len = $width;
    }
    return (' ' x (($width-$len) >> 1)) . $str;
}

sub Calendar
{
    my ($year, $month) = @_;
    my ($first, $last, $day, $buf, $arr_ref);
    my $str = "\n";

    if ($year > 0)
    {
        if (($month >= 1) && ($month <= 12))
        {
            $buf = $arr_Month_to_Text[$pcalc_Language][$month] . " " . $year;
            $buf = Center($buf, 27) . "\n";
            $str .= $buf;
            $arr_ref = ($arr_Day_of_Week_Abbreviation[$pcalc_Language][0] ne "") ?
                \@arr_Day_of_Week_Abbreviation :
                \@arr_Day_of_Week_to_Text;
            $buf = sprintf("%3.3s %3.3s %3.3s %3.3s %3.3s %3.3s %3.3s\n",
                  $$arr_ref[$pcalc_Language][1],
                  $$arr_ref[$pcalc_Language][2],
                  $$arr_ref[$pcalc_Language][3],
                  $$arr_ref[$pcalc_Language][4],
                  $$arr_ref[$pcalc_Language][5],
                  $$arr_ref[$pcalc_Language][6],
                  $$arr_ref[$pcalc_Language][7]);
            $str = $str . $buf;
            $first = Day_of_Week($year, $month, 1);
            $last = $arr_Days_in_Month[leap_year($year)][$month];
            if (--$first > 0)
            {
                $str .= ' ' x (($first << 2) - 1);
            }
            for ($day = 1; $day <= $last; $day++,$first++)
            {
                if ($first > 0)
                {
                    if ($first > 6)
                    {
                        $first = 0;
                        $str .= "\n";
                    }
                    else
                    {
                        $str .= " ";
                    }
                }
                $buf = sprintf(" %2d", $day);
                $str .= $buf;
            }
            $str .= "\n\n";
            return $str;
        }
        else
        {
            DATECALC_MONTH_ERROR("Calendar");
        }
    }
    else
    {
        DATECALC_YEAR_ERROR("Calendar");
    }
}

sub Month_to_Text
{
    my ($month) = @_;

    if (($month >= 1) && ($month <= 12))
    {
        return $arr_Month_to_Text[$pcalc_Language][$month];
    }
    else
    {
        DATECALC_MONTH_ERROR("Month_to_Text");
    }
}

sub Day_of_Week_to_Text
{
    my ($dow) = @_;

    if (($dow >= 1) && ($dow <= 7))
    {
        return $arr_Day_of_Week_to_Text[$pcalc_Language][$dow];
    }
    else
    {
        DATECALC_DAYOFWEEK_ERROR("Day_of_Week_to_Text");
    }
}

sub Day_of_Week_Abbreviation
{
    my ($dow) = @_;

    if (($dow >= 1) && ($dow <= 7))
    {
        if ($arr_Day_of_Week_Abbreviation[$pcalc_Language][$dow])
        {
            return $arr_Day_of_Week_Abbreviation[$pcalc_Language][$dow];
        }
        else
        {
            return substr $arr_Day_of_Week_to_Text[$pcalc_Language][$dow], 0, 3;
        }
    }
    else
    {
        DATECALC_DAYOFWEEK_ERROR("Day_of_Week_to_Text");
    }
}

sub Language_to_Text
{
    my ($lang) = @_;

    if (($lang >= 1) && ($lang <= $pcalc_Languages))
    {
        return $arr_Language_to_Text[$lang];
    }
}

sub Language
{
    my ($lang) = @_;
    my ($items, $previous_language);

    $items = scalar @_;

    $previous_language = $pcalc_Language;

    if (($items >= 0) && ($items <= 1))
    {
        if ($items == 1)
        {
            if (($lang >= 1) && ($lang <= $pcalc_Languages))
            {
                $pcalc_Language = $lang;
            }
            else
            {
                DATECALC_LANGUAGE_ERROR("Language");
            }
        }
    }
    else
    {
        croak('Usage: [$lang = ] Date::Pcalc::Language( [$lang] );');
    }
    return $previous_language;
}

sub Languages
{
    return $pcalc_Languages;
}

sub Decode_Date_EU
{
    croak "Usage: (\$year,\$month,\$day) = Decode_Date_EU(\$date);"
      if (@_ != 1);

    my ($date ) = @_;

    return Decode_Date_EU2( $date );
}

sub Decode_Date_EU2
{
    croak "Usage: (\$year,\$month,\$day) = Decode_Date_EU2(\$date);"
      if (@_ != 1);

    my($buffer) = @_;
    my($year,$month,$day,$length);

    if ($buffer =~ /^\D*  (\d+)  [^A-Za-z0-9]*  ([A-Za-z]+)  [^A-Za-z0-9]*  (\d+)  \D*$/x)
    {
        ($day,$month,$year) = ($1,$2,$3);
        $month = Decode_Month($month);
        unless ($month > 0)
        {
            return(); # can't decode month!
        }
    }
    elsif ($buffer =~ /^\D*  0*(\d+)  \D*$/x)
    {
        $buffer = $1;
        $length = length($buffer);
        if    ($length == 3)
        {
            $day   = substr($buffer,0,1);
            $month = substr($buffer,1,1);
            $year  = substr($buffer,2,1);
        }
        elsif ($length == 4)
        {
            $day   = substr($buffer,0,1);
            $month = substr($buffer,1,1);
            $year  = substr($buffer,2,2);
        }
        elsif ($length == 5)
        {
            $day   = substr($buffer,0,1);
            $month = substr($buffer,1,2);
            $year  = substr($buffer,3,2);
        }
        elsif ($length == 6)
        {
            $day   = substr($buffer,0,2);
            $month = substr($buffer,2,2);
            $year  = substr($buffer,4,2);
        }
        elsif ($length == 7)
        {
            $day   = substr($buffer,0,1);
            $month = substr($buffer,1,2);
            $year  = substr($buffer,3,4);
        }
        elsif ($length == 8)
        {
            $day   = substr($buffer,0,2);
            $month = substr($buffer,2,2);
            $year  = substr($buffer,4,4);
        }
        else { return(); } # wrong number of digits!
    }
    elsif ($buffer =~ /^\D*  (\d+)  \D+  (\d+)  \D+  (\d+)  \D*$/x)
    {
        ($day,$month,$year) = ($1,$2,$3);
    }
    else { return(); } # no match at all!

    if ($year < 100)
    {
        if ($year < $Year_of_Epoch )
        {
            $year += 100;
        }
        $year += $Century_of_Epoch;
    }

    if (check_date($year,$month,$day))
    {
        return($year,$month,$day);
    }
    else { return(); } # not a valid date!
}

sub Decode_Date_US
{
    croak "Usage: (\$year,\$month,\$day) = Decode_Date_US(\$date);"
      if (@_ != 1);
     my ($date) = @_;
    return Decode_Date_US2( $date );
}

sub Decode_Date_US2
{
    croak "Usage: (\$year,\$month,\$day) = Decode_Date_US2(\$date);"
      if (@_ != 1);

    my($buffer) = @_;
    my($year,$month,$day,$length);

    if ($buffer =~ /^[^A-Za-z0-9]*  ([A-Za-z]+)  [^A-Za-z0-9]*  0*(\d+)  \D*$/x)
    {
        ($month,$buffer) = ($1,$2);
        $month = Decode_Month($month);
        unless ($month > 0)
        {
            return(); # can't decode month!
        }
        $length = length($buffer);
        if    ($length == 2)
        {
            $day  = substr($buffer,0,1);
            $year = substr($buffer,1,1);
        }
        elsif ($length == 3)
        {
            $day  = substr($buffer,0,1);
            $year = substr($buffer,1,2);
        }
        elsif ($length == 4)
        {
            $day  = substr($buffer,0,2);
            $year = substr($buffer,2,2);
        }
        elsif ($length == 5)
        {
            $day  = substr($buffer,0,1);
            $year = substr($buffer,1,4);
        }
        elsif ($length == 6)
        {
            $day  = substr($buffer,0,2);
            $year = substr($buffer,2,4);
        }
        else { return(); } # wrong number of digits!
    }
    elsif ($buffer =~ /^[^A-Za-z0-9]*  ([A-Za-z]+)  [^A-Za-z0-9]*  (\d+)  \D+  (\d+)  \D*$/x)
    {
        ($month,$day,$year) = ($1,$2,$3);
        $month = Decode_Month($month);
        unless ($month > 0)
        {
            return(); # can't decode month!
        }
    }
    elsif ($buffer =~ /^\D*  0*(\d+)  \D*$/x)
    {
        $buffer = $1;
        $length = length($buffer);
        if    ($length == 3)
        {
            $month = substr($buffer,0,1);
            $day   = substr($buffer,1,1);
            $year  = substr($buffer,2,1);
        }
        elsif ($length == 4)
        {
            $month = substr($buffer,0,1);
            $day   = substr($buffer,1,1);
            $year  = substr($buffer,2,2);
        }
        elsif ($length == 5)
        {
            $month = substr($buffer,0,1);
            $day   = substr($buffer,1,2);
            $year  = substr($buffer,3,2);
        }
        elsif ($length == 6)
        {
            $month = substr($buffer,0,2);
            $day   = substr($buffer,2,2);
            $year  = substr($buffer,4,2);
        }
        elsif ($length == 7)
        {
            $month = substr($buffer,0,1);
            $day   = substr($buffer,1,2);
            $year  = substr($buffer,3,4);
        }
        elsif ($length == 8)
        {
            $month = substr($buffer,0,2);
            $day   = substr($buffer,2,2);
            $year  = substr($buffer,4,4);
        }
        else { return(); } # wrong number of digits!
    }
    elsif ($buffer =~ /^\D*  (\d+)  \D+  (\d+)  \D+  (\d+)  \D*$/x)
    {
        ($month,$day,$year) = ($1,$2,$3);
    }
    else { return(); } # no match at all!

    if ($year < 100)
    {
        if ($year < $Year_of_Epoch)
        {
            $year += 100;
        }
        $year += $Century_of_Epoch;
    }

    if (check_date($year,$month,$day))
    {
        return($year,$month,$day);
    }
    else { return(); } # not a valid date!
}

sub Parse_Date
{
    croak "Usage: (\$year,\$month,\$day) = Parse_Date(\$date);"
      if (@_ != 1);

    my($date) = @_;
    my($year,$month,$day);
    unless ($date =~ /\b([JFMASOND][aepuco][nbrynlgptvc])\s+([0123]??\d)\b/)
    {
        return();
    }
    $month = $1;
    $day   = $2;
    unless ($date =~ /\b(19\d\d|20\d\d)\b/)
    {
        return();
    }
    $year  = $1;
    $month = Decode_Month($month);
    unless ($month > 0)
    {
        return();
    }
    unless (check_date($year,$month,$day))
    {
        return();
    }
    return($year,$month,$day);
}

sub Version()
{
    return $VERSION;
}

1;

#
#
#    Subsequent documentation taken verbatim from
#    Date::Calc version 4.2
#
#

__END__

=head1 NAME

Date::Pcalc - Gregorian calendar date calculations

=head1 PREFACE

This package consists of a Perl module for all kinds of date calculations based
on the Gregorian calendar (the one used in all western countries today),
thereby complying with all relevant norms and standards: S<ISO/R 2015-1971>,
S<DIN 1355> and, to some extent, S<ISO 8601> (where applicable).

(See also http://www.engelschall.com/u/sb/download/Date-Calc/DIN1355/
for a scan of part of the "S<DIN 1355>" document (in German)).

This module is a direct translation of Steffen Beyer's excellent
Date::Calc module to Perl.

The module of course handles year numbers of 2000 and above correctly
("Year 2000" or "Y2K" compliance) -- actually all year numbers from 1
to the largest positive integer representable on your system (which
is at least 32767) can be dealt with.

Note that this package B<EXTRAPOLATES> the Gregorian calendar B<BACK>
until the year S<1 A.D.> -- even though the Gregorian calendar was only
adopted in 1582 by most (not all) European countries, in obedience to
the corresponding decree of catholic pope S<Gregor I> in that year.

Some (mainly protestant) countries continued to use the Julian calendar
(used until then) until as late as the beginning of the 20th century.

Finally, note that this package is not intended to do everything you could
ever imagine automagically for you; it is rather intended to serve as a
toolbox (in the best of UNIX spirit and traditions) which should, however,
always get you where you want to go.

If nevertheless you can't figure out how to solve a particular problem,
please let me know! (See e-mail address at the bottom of this document.)

=head1 SYNOPSIS

  use Date::Pcalc qw(
      Days_in_Year
      Days_in_Month
      Weeks_in_Year
      leap_year
      check_date
      check_business_date
      Day_of_Year
      Date_to_Days
      Day_of_Week
      Week_Number
      Week_of_Year
      Monday_of_Week
      Nth_Weekday_of_Month_Year
      Standard_to_Business
      Business_to_Standard
      Delta_Days
      Delta_DHMS
      Add_Delta_Days
      Add_Delta_DHMS
      Add_Delta_YMD
      System_Clock
      Today
      Now
      Today_and_Now
      Easter_Sunday
      Decode_Month
      Decode_Day_of_Week
      Decode_Language
      Decode_Date_EU
      Decode_Date_US
      Compress
      Uncompress
      check_compressed
      Compressed_to_Text
      Date_to_Text
      Date_to_Text_Long
      English_Ordinal
      Calendar
      Month_to_Text
      Day_of_Week_to_Text
      Day_of_Week_Abbreviation
      Language_to_Text
      Language
      Languages
      Decode_Date_EU2
      Decode_Date_US2
      Parse_Date
  );

  use Date::Pcalc qw(:all);

  Days_in_Year
      $days = Days_in_Year($year,$month);

  Days_in_Month
      $days = Days_in_Month($year,$month);

  Weeks_in_Year
      $weeks = Weeks_in_Year($year);

  leap_year
      if (leap_year($year))

  check_date
      if (check_date($year,$month,$day))

  check_business_date
      if (check_business_date($year,$week,$dow))

  Day_of_Year
      $doy = Day_of_Year($year,$month,$day);

  Date_to_Days
      $days = Date_to_Days($year,$month,$day);

  Day_of_Week
      $dow = Day_of_Week($year,$month,$day);

  Week_Number
      $week = Week_Number($year,$month,$day);

  Week_of_Year
      ($week,$year) = Week_of_Year($year,$month,$day);

  Monday_of_Week
      ($year,$month,$day) = Monday_of_Week($week,$year);

  Nth_Weekday_of_Month_Year
      if (($year,$month,$day) =
      Nth_Weekday_of_Month_Year($year,$month,$dow,$n))

  Standard_to_Business
      ($year,$week,$dow) =
      Standard_to_Business($year,$month,$day);

  Business_to_Standard
      ($year,$month,$day) =
      Business_to_Standard($year,$week,$dow);

  Delta_Days
      $Dd = Delta_Days($year1,$month1,$day1,
                       $year2,$month2,$day2);

  Delta_DHMS
      ($Dd,$Dh,$Dm,$Ds) =
      Delta_DHMS($year1,$month1,$day1, $hour1,$min1,$sec1,
                 $year2,$month2,$day2, $hour2,$min2,$sec2);

  Add_Delta_Days
      ($year,$month,$day) =
      Add_Delta_Days($year,$month,$day,
                     $Dd);

  Add_Delta_DHMS
      ($year,$month,$day, $hour,$min,$sec) =
      Add_Delta_DHMS($year,$month,$day, $hour,$min,$sec,
                     $Dd,$Dh,$Dm,$Ds);

  Add_Delta_YMD
      ($year,$month,$day) =
      Add_Delta_YMD($year,$month,$day,
                    $Dy,$Dm,$Dd);

  System_Clock
      ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) =
      System_Clock();

  Today
      ($year,$month,$day) = Today();

  Now
      ($hour,$min,$sec) = Now();

  Today_and_Now
      ($year,$month,$day, $hour,$min,$sec) = Today_and_Now();

  Easter_Sunday
      ($year,$month,$day) = Easter_Sunday($year);

  Decode_Month
      if ($month = Decode_Month($string))

  Decode_Day_of_Week
      if ($dow = Decode_Day_of_Week($string))

  Decode_Language
      if ($lang = Decode_Language($string))

  Decode_Date_EU
      if (($year,$month,$day) = Decode_Date_EU($string))

  Decode_Date_US
      if (($year,$month,$day) = Decode_Date_US($string))

  Compress
      $date = Compress($year,$month,$day);

  Uncompress
      if (($century,$year,$month,$day) = Uncompress($date))

  check_compressed
      if (check_compressed($date))

  Compressed_to_Text
      $string = Compressed_to_Text($date);

  Date_to_Text
      $string = Date_to_Text($year,$month,$day);

  Date_to_Text_Long
      $string = Date_to_Text_Long($year,$month,$day);

  English_Ordinal
      $string = English_Ordinal($number);

  Calendar
      $string = Calendar($year,$month);

  Month_to_Text
      $string = Month_to_Text($month);

  Day_of_Week_to_Text
      $string = Day_of_Week_to_Text($dow);

  Day_of_Week_Abbreviation
      $string = Day_of_Week_Abbreviation($dow);

  Language_to_Text
      $string = Language_to_Text($lang);

  Language
      $lang = Language();
      Language($lang);
      $oldlang = Language($newlang);

  Languages
      $max_lang = Languages();

  Decode_Date_EU2
      if (($year,$month,$day) = Decode_Date_EU2($string))

  Decode_Date_US2
      if (($year,$month,$day) = Decode_Date_US2($string))

  Parse_Date
      if (($year,$month,$day) = Parse_Date($string))

  Version
      $string = Date::Pcalc::Version();

=head1 IMPORTANT NOTES

(See the section "RECIPES" at the bottom of this document for
solutions to common problems!)

=over 2

=item *

"Year 2000" ("Y2K") compliance

The upper limit for any year number in this module is only given
by the size of the largest positive integer that can be represented
in a variable of the C type "int" on your system, which is at least
32767, according to the ANSI C standard (exceptions see below).

Note that this package projects the Gregorian calendar back until the
year S<1 A.D.> -- even though the Gregorian calendar was only adopted
in 1582 by most (not all) European countries, in obedience to the
corresponding decree of catholic pope S<Gregor I> in that year.

Therefore, B<BE SURE TO ALWAYS SPECIFY "1998" WHEN YOU MEAN "1998">,
for instance, and B<DO NOT WRITE "98" INSTEAD>, because this will
in fact perform a calculation based on the year "98" A.D. and
B<NOT> "1998"!

The only exceptions from this rule are the functions which contain
the word "compress" in their names (which only handle years between
1970 and 2069 and also accept the abbreviations "00" to "99"), and
the functions whose names begin with "Decode_Date_" (which map year
numbers below 100 to the range 1970 - 2069, using a technique known
as "windowing").

=item *

First index

B<ALL> ranges in this module start with "C<1>", B<NOT> "C<0>"!

I.e., the day of month, day of week, day of year, month of year,
week of year, first valid year number and language B<ALL> start
counting at one, B<NOT> zero!

The only exception is the function "C<Week_Number()>", which may
in fact return "C<0>" when the given date actually lies in the
last week of the B<PREVIOUS> year.

=item *

Function naming conventions

Function names completely in lower case indicate a boolean return value.

=item *

Boolean values

Boolean values in this module are always a numeric zero ("C<0>") for
"false" and a numeric one ("C<1>") for "true".

=item *

Exception handling

The functions in this module will usually die with a corresponding error
message if their input parameters, intermediate results or output values
are out of range.

The following functions handle errors differently:

  -  check_date()
  -  check_business_date()
  -  check_compressed()

(which return a "false" return value when the given input does not represent
a valid date),

  -  Nth_Weekday_of_Month_Year()

(which returns an empty list if the requested 5th day of week does not exist),

  -  Decode_Month()
  -  Decode_Day_of_Week()
  -  Decode_Language()
  -  Compress()

(which return "C<0>" upon failure or invalid input), and

  -  Decode_Date_EU()
  -  Decode_Date_US()
  -  Decode_Date_EU2()
  -  Decode_Date_US2()
  -  Parse_Date()
  -  Uncompress()

(which return an empty list upon failure or invalid input).

Note that you can always catch an exception thrown by any of the functions
in this module and handle it yourself by enclosing the function call in an
"C<eval>" with curly brackets and checking the special variable "C<$@>"
(see L<perlfunc(1)/eval> for details).

=back

=head1 DESCRIPTION

=over 2

=item *

C<use Date::Pcalc qw( Days_in_Year Days_in_Month ... );>

=item *

C<use Date::Pcalc qw(:all);>

You can either specify the functions you want to import explicitly by
enumerating them between the parentheses of the "C<qw()>" operator, or
you can use the "C<:all>" tag instead to import B<ALL> available functions.

=item *

C<$days = Days_in_Year($year,$month);>

This function returns the sum of the number of days in the months starting
with January up to and including "C<$month>" in the given year "C<$year>".

I.e., "C<Days_in_Year(1998,1)>" returns "C<31>", "C<Days_in_Year(1998,2)>"
returns "C<59>", "C<Days_in_Year(1998,3)>" returns "C<90>", and so on.

Note that "C<Days_in_Year($year,12)>" returns the number of days in the
given year "C<$year>", i.e., either "C<365>" or "C<366>".

=item *

C<$days = Days_in_Month($year,$month);>

This function returns the number of days in the given month "C<$month>" of
the given year "C<$year>".

The year must always be supplied, even though it is only needed when the
month is February, in order to determine wether it is a leap year or not.

I.e., "C<Days_in_Month(1998,1)>" returns "C<31>", "C<Days_in_Month(1998,2)>"
returns "C<28>", "C<Days_in_Month(2000,2)>" returns "C<29>",
"C<Days_in_Month(1998,3)>" returns "C<31>", and so on.

=item *

C<$weeks = Weeks_in_Year($year);>

This function returns the number of weeks in the given year "C<$year>",
i.e., either "C<52>" or "C<53>".

=item *

C<if (leap_year($year))>

This function returns "true" ("C<1>") if the given year "C<$year>" is
a leap year and "false" ("C<0>") otherwise.

=item *

C<if (check_date($year,$month,$day))>

This function returns "true" ("C<1>") if the given three numerical
values "C<$year>", "C<$month>" and "C<$day>" constitute a valid date,
and "false" ("C<0>") otherwise.

=item *

C<if (check_business_date($year,$week,$dow))>

This function returns "true" ("C<1>") if the given three numerical
values "C<$year>", "C<$week>" and "C<$dow>" constitute a valid date
in business format, and "false" ("C<0>") otherwise.

B<Beware> that this function does B<NOT> compute whether a given date
is a business day (i.e., Monday to Friday)!

=item *

C<$doy = Day_of_Year($year,$month,$day);>

This function returns the (relative) number of the day of the given date
in the given year.

E.g., "C<Day_of_Year($year,1,1)>" returns "C<1>",
"C<Day_of_Year($year,2,1)>" returns "C<32>", and
"C<Day_of_Year($year,12,31)>" returns either "C<365>" or "C<366>".

=item *

C<$days = Date_to_Days($year,$month,$day);>

This function returns the (absolute) number of the day of the given date,
where counting starts at the 1st of January of the year S<1 A.D.>

I.e., "C<Date_to_Days(1,1,1)>" returns "C<1>", "C<Date_to_Days(1,12,31)>"
returns "C<365>", "C<Date_to_Days(2,1,1)>" returns "C<366>",
"C<Date_to_Days(1998,5,1)>" returns "C<729510>", and so on.

=item *

C<$dow = Day_of_Week($year,$month,$day);>

This function returns the number of the day of week of the given date.

The function returns "C<1>" for Monday, "C<2>" for Tuesday and so on
until "C<7>" for Sunday.

Note that in the Hebrew calendar (on which the Christian calendar is based),
the week starts with Sunday and ends with the Sabbath or Saturday (where
according to the Genesis (as described in the Bible) the Lord rested from
creating the world).

In medieval times, Catholic popes decreed the Sunday to be the official
day of rest, in order to dissociate the Christian from the Hebrew belief.

Nowadays, Sunday B<AND> Saturday are commonly considered (and
used as) days of rest, usually referred to as the "week-end".

Consistent with this practice, current norms and standards (such as
S<ISO/R 2015-1971>, S<DIN 1355> and S<ISO 8601>) define Monday
as the first day of the week.

=item *

C<$week = Week_Number($year,$month,$day);>

This function returns the number of the week the given date lies in.

If the given date lies in the B<LAST> week of the B<PREVIOUS> year,
"C<0>" is returned.

If the given date lies in the B<FIRST> week of the B<NEXT> year,
"C<Weeks_in_Year($year) + 1>" is returned.

=item *

C<($week,$year) = Week_of_Year($year,$month,$day);>

This function returns the number of the week the given date lies in,
as well as the year that week belongs to.

I.e., if the given date lies in the B<LAST> week of the B<PREVIOUS> year,
"C<(Weeks_in_Year($year-1), $year-1)>" is returned.

If the given date lies in the B<FIRST> week of the B<NEXT> year,
"C<(1, $year+1)>" is returned.

Otherwise, "C<(Week_Number($year,$month,$day), $year)>" is returned.

=item *

C<($year,$month,$day) = Monday_of_Week($week,$year);>

This function returns the date of the first day of the given week, i.e.,
the Monday.

"C<$year>" must be greater than or equal to "C<1>", and "C<$week>" must
lie in the range "C<1>" to "C<Weeks_in_Year($year)>".

Note that you can write
"C<($year,$month,$day) = Monday_of_Week(Week_of_Year($year,$month,$day));>"
in order to calculate the date of the Monday of the same week as the
given date.

=item *

C<if (($year,$month,$day) = Nth_Weekday_of_Month_Year($year,$month,$dow,$n))>

This function calculates the date of the "C<$n>"th day of week "C<$dow>"
in the given month "C<$month>" and year "C<$year>"; such as, for example,
the 3rd Thursday of a given month and year.

This can be used to send a notification mail to the members of a group
which meets regularly on every 3rd Thursday of a month, for instance.

(See the section "RECIPES" near the end of this document for a code
snippet to actually do so.)

"C<$year>" must be greater than or equal to "C<1>", "C<$month>" must lie
in the range "C<1>" to "C<12>", "C<$dow>" must lie in the range "C<1>"
to "C<7>" and "C<$n>" must lie in the range "C<1>" to "C<5>", or a fatal
error (with appropriate error message) occurs.

The function returns an empty list when the 5th of a given day of week
does not exist in the given month and year.

=item *

C<($year,$week,$dow) = Standard_to_Business($year,$month,$day);>

This function converts a given date from standard notation (year,
month, day (of month)) to business notation (year, week, day of week).

=item *

C<($year,$month,$day) = Business_to_Standard($year,$week,$dow);>

This function converts a given date from business notation (year,
week, day of week) to standard notation (year, month, day (of month)).

=item *

C<$Dd = Delta_Days($year1,$month1,$day1, $year2,$month2,$day2);>

This function returns the difference in days between the two given
dates.

The result is positive if the two dates are in chronological order,
i.e., if date #1 comes chronologically B<BEFORE> date #2, and negative
if the order of the two dates is reversed.

The result is zero if the two dates are identical.

=item *

C<($Dd,$Dh,$Dm,$Ds) = Delta_DHMS($year1,$month1,$day1, $hour1,$min1,$sec1, $year2,$month2,$day2, $hour2,$min2,$sec2);>

This function returns the difference in days, hours, minutes and seconds
between the two given dates with times.

All four return values will be positive if the two dates are in chronological
order, i.e., if date #1 comes chronologically B<BEFORE> date #2, and negative
(in all four return values!) if the order of the two dates is reversed.

This is so that the two functions "C<Delta_DHMS()>" and "C<Add_Delta_DHMS()>"
(description see further below) are complementary, i.e., mutually inverse:

  Add_Delta_DHMS(@date1,@time1, Delta_DHMS(@date1,@time1, @date2,@time2))

yields "C<(@date2,@time2)>" again, whereas

  Add_Delta_DHMS(@date2,@time2,
      map(-$_, Delta_DHMS(@date1,@time1, @date2,@time2)))

yields "C<(@date1,@time1)>", and

  Delta_DHMS(@date1,@time1, Add_Delta_DHMS(@date1,@time1, @delta))

yields "C<@delta>" again.

The result is zero (in all four return values) if the two dates and times
are identical.

=item *

C<($year,$month,$day) = Add_Delta_Days($year,$month,$day, $Dd);>

This function has two principal uses:

First, it can be used to calculate a new date, given an initial date and
an offset (which may be positive or negative) in days, in order to answer
questions like "today plus 90 days -- which date gives that?".

(In order to add a weeks offset, simply multiply the weeks offset with
"C<7>" and use that as your days offset.)

Second, it can be used to convert the canonical representation of a date,
i.e., the number of that day (where counting starts at the 1st of January
in S<1 A.D.>), back into a date given as year, month and day.

Because counting starts at "C<1>", you will actually have to subtract "C<1>"
from the canonical date in order to get back the original date:

  $canonical = Date_to_Days($year,$month,$day);

  ($year,$month,$day) = Add_Delta_Days(1,1,1, $canonical - 1);

Moreover, this function is the inverse of the function "C<Delta_Days()>":

  Add_Delta_Days(@date1, Delta_Days(@date1, @date2))

yields "C<@date2>" again, whereas

  Add_Delta_Days(@date2, -Delta_Days(@date1, @date2))

yields "C<@date1>", and

  Delta_Days(@date1, Add_Delta_Days(@date1, $delta))

yields "C<$delta>" again.

=item *

C<($year,$month,$day, $hour,$min,$sec) = Add_Delta_DHMS($year,$month,$day, $hour,$min,$sec, $Dd,$Dh,$Dm,$Ds);>

This function serves to add a days, hours, minutes and seconds offset to a
given date and time, in order to answer questions like "today and now plus
7 days but minus 5 hours and then plus 30 minutes, what date and time gives
that?":

  ($y,$m,$d,$H,$M,$S) = Add_Delta_DHMS(Today_and_Now(), +7,-5,+30,0);

=item *

C<($year,$month,$day) = Add_Delta_YMD($year,$month,$day, $Dy,$Dm,$Dd);>

This function serves to add a years, months and days offset to a given date.

(In order to add a weeks offset, simply multiply the weeks offset with "C<7>"
and add this number to your days offset.)

Note that the three offsets for years, months and days are applied separately
from each other, in reverse order.

(This also allows them to have opposite signs.)

In other words, first the days offset is applied (using the function
"C<Add_Delta_Days()>", internally), then the months offset, and finally
the years offset.

If the resulting date happens to fall on a day beyond the end of the
resulting month, like the 31st of April or the 29th of February (in
non-leap years), then the day is replaced by the last valid day of
that month in that year (e.g., the 30th of April or 28th of February).

B<BEWARE> that this behaviour differs from that of previous versions
of this module!

(Formerly, only the 29th of February in non-leap years was checked for
(which - in contrast to the current version - was replaced by the 1st
of March). Other possible invalid dates were not checked (and returned
unwittingly), constituting a severe bug of previous versions.)

B<BEWARE> also that because of this replacement, but even more because
a year and a month offset is not equivalent to a fixed number of days,
the transformation performed by this function is B<NOT REVERSIBLE>!

This is in contrast to the functions "C<Add_Delta_Days()>" and
"C<Add_Delta_DHMS()>", which for this very reason have inverse functions
(namely "C<Delta_Days()>" and "C<Delta_DHMS()>"), whereas there exists no
inverse for this function.

Note that for this same reason, even

  @date = Add_Delta_YMD(
          Add_Delta_YMD(@date, $Dy,$Dm,$Dd), -$Dy,-$Dm,-$Dd);

will (in general!) B<NOT> return the initial date "C<@date>"!

(This might work in some cases, though.)

Note that this is B<NOT> a program bug but B<NECESSARILY> so because of
the varying lengths of years and months!

=item *

C<($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) = System_Clock();>

If your operating system supports the corresponding system calls
("C<time()>" and "C<localtime()>"), this function will return
the information provided by your system clock, i.e., the current
date and time, the number of the day of year, the number of the
day of week and a flag signaling wether daylight savings time
is currently in effect or not.

The ranges of values returned (and their meanings) are as follows:

                $year   :   should at least cover 1900..2038
                $month  :   1..12
                $day    :   1..31
                $hour   :   0..23
                $min    :   0..59
                $sec    :   0..59    (0..61 on some systems)
                $doy    :   1..366
                $dow    :   1..7
                $dst    :  -1..1

The day of week ("C<$dow>") will be "C<1>" for Monday, "C<2>" for
Tuesday and so on until "C<7>" for Sunday.

The daylight savings time flag ("C<$dst>") will be "C<-1>" if this
information is not available on your system, "C<0>" for no daylight
savings time (i.e., normal time) and "C<1>" when daylight savings
time is in effect.

If your operating system does not provide the necessary system calls,
calling this function will result in a fatal "not available on this
system" error message.

If you want to handle this exception yourself, use "C<eval>" as follows:

  eval { ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) =
    System_Clock(); };

  if ($@)
  {
      # Handle missing system clock
      # (For instance, ask user to enter this information manually)
  }

Note that curlies ("{" and "}") are used here to delimit the statement to
be "eval"ed (which is the way to catch exceptions in Perl), and not quotes
(which is a way to evaluate Perl expressions at runtime).

=item *

C<($year,$month,$day) = Today();>

This function returns a subset of the values returned by the function
"C<System_Clock()>" (see above for details), namely the current year,
month and day.

A fatal "not available on this system" error message will appear if the
corresponding system calls are not supported by your current operating
system.

=item *

C<($hour,$min,$sec) = Now();>

This function returns a subset of the values returned by the function
"C<System_Clock()>" (see above for details), namely the current time
(hours, minutes and full seconds).

A fatal "not available on this system" error message will appear if the
corresponding system calls are not supported by your current operating
system.

=item *

C<($year,$month,$day, $hour,$min,$sec) = Today_and_Now();>

This function returns a subset of the values returned by the function
"C<System_Clock()>" (see above for details), namely the current date
(year, month, day) and time (hours, minutes and full seconds).

A fatal "not available on this system" error message will appear if the
corresponding system calls are not supported by your current operating
system.

=item *

C<($year,$month,$day) = Easter_Sunday($year);>

This function calculates the date of easter sunday for all years in the
range from 1583 to 2299 (all other year numbers will result in a fatal
"year out of range" error message) using the method known as the "Gaussian
Rule".

Some related christian feast days which depend on the date of easter sunday:

  Carnival Monday / Rosenmontag / Veille du Mardi Gras   =  -48 days
  Mardi Gras / Karnevalsdienstag / Mardi Gras            =  -47 days
  Ash Wednesday / Aschermittwoch / Mercredi des Cendres  =  -46 days
  Palm Sunday / Palmsonntag / Dimanche des Rameaux       =   -7 days
  Easter Friday / Karfreitag / Vendredi Saint            =   -2 days
  Easter Saturday / Ostersamstag / Samedi de Paques      =   -1 day
  Easter Monday / Ostermontag / Lundi de Paques          =   +1 day
  Ascension of Christ / Christi Himmelfahrt / Ascension  =  +39 days
  Whitsunday / Pfingstsonntag / Dimanche de Pentecote    =  +49 days
  Whitmonday / Pfingstmontag / Lundi de Pentecote        =  +50 days
  Feast of Corpus Christi / Fronleichnam / Fete-Dieu     =  +60 days

Use the offsets shown above to calculate the date of the corresponding
feast day as follows:

  ($year,$month,$day) = Add_Delta_Days(Easter_Sunday($year), $offset));

=item *

C<if ($month = Decode_Month($string))>

This function takes a string as its argument, which should contain the
name of a month B<IN THE CURRENTLY SELECTED LANGUAGE> (see further below
for details about multi-language support by this package), or any uniquely
identifying abbreviation of a month's name (i.e., the first few letters),
and returns the corresponding number (1..12) upon a successful match, or
"C<0>" otherwise (therefore, the return value can also be used as the
conditional expression in an "if" statement).

Note that the input string may not contain any other characters which do not
pertain to the month's name, especially no leading or trailing whitespace.

Note also that matching is performed in a case-insensitive manner (this may
depend on the "locale" setting on your current system, though!)

With "English" as the currently selected language (which is the default),
the following examples will all return the value "C<9>":

  $month = Decode_Month("s");
  $month = Decode_Month("Sep");
  $month = Decode_Month("septemb");
  $month = Decode_Month("September");

=item *

C<if ($dow = Decode_Day_of_Week($string))>

This function takes a string as its argument, which should contain the
name of a day of week B<IN THE CURRENTLY SELECTED LANGUAGE> (see further
below for details about multi-language support by this package), or any
uniquely identifying abbreviation of the name of a day of week (i.e., the
first few letters), and returns the corresponding number (1..7) upon a
successful match, or "C<0>" otherwise (therefore, the return value can
also be used as the conditional expression in an "if" statement).

Note that the input string may not contain any other characters which
do not pertain to the name of the day of week, especially no leading
or trailing whitespace.

Note also that matching is performed in a case-insensitive manner (this may
depend on the "locale" setting on your current system, though!)

With "English" as the currently selected language (which is the default),
the following examples will all return the value "C<3>":

  $dow = Decode_Day_of_Week("w");
  $dow = Decode_Day_of_Week("Wed");
  $dow = Decode_Day_of_Week("wednes");
  $dow = Decode_Day_of_Week("Wednesday");

=item *

C<if ($lang = Decode_Language($string))>

This function takes a string as its argument, which should contain the
name of one of the languages supported by this package (B<IN THIS VERY
LANGUAGE ITSELF>), or any uniquely identifying abbreviation of the name
of a language (i.e., the first few letters), and returns its corresponding
internal number (1..7 in the original distribution) upon a successful match,
or "C<0>" otherwise (therefore, the return value can also be used as the
conditional expression in an "if" statement).

Note that the input string may not contain any other characters which do
not pertain to the name of a language, especially no leading or trailing
whitespace.

Note also that matching is performed in a case-insensitive manner (this may
depend on the "locale" setting on your current system, though!)

The original distribution supports the following seven languages:

            English                    ==>   1    (default)
            Français    (French)       ==>   2
            Deutsch     (German)       ==>   3
            Español     (Spanish)      ==>   4
            Português   (Portuguese)   ==>   5
            Nederlands  (Dutch)        ==>   6
            Italiano    (Italian)      ==>   7

See the section "How to install additional languages" in the file
"INSTALL.txt" in this distribution for how to add more languages
to this package.

In the original distribution (no other languages installed),
the following examples will all return the value "C<3>":

  $lang = Decode_Language("d");
  $lang = Decode_Language("de");
  $lang = Decode_Language("Deutsch");

Note that you may not be able to enter the special international characters
in some of the languages' names over the keyboard directly on some systems.

This should never be a problem, though; just enter an abbreviation of the
name of the language consisting of the first few letters up to the character
before the first special international character.

=item *

C<if (($year,$month,$day) = Decode_Date_EU($string))>

This function scans a given string and tries to parse any date
which might be embedded in it. In the original module this was a
C routine; now it is simply a call to the perl subroutine
Decode_Date_EU2 (see below).

The function returns an empty list if it can't successfully
extract a valid date from its input string, or else it returns
the date found.

The function accepts almost any format, as long as the date is
given in the european order (hence its name) day-month-year.

Thereby, zero or more B<NON-NUMERIC> characters may B<PRECEDE>
the day and B<FOLLOW> the year.

Moreover, zero or more B<NON-ALPHANUMERIC> characters are permitted
B<BETWEEN> these three items (i.e., between day and month and between
month and year).

The month may be given either numerically (i.e., a number from "C<1>"
to "C<12>"), or alphanumerically, i.e., as the name of the month B<IN
THE CURRENTLY SELECTED LANGUAGE>, or any uniquely identifying abbreviation
thereof.

(See further below for details about multi-language support by this package!)

If the year is given as one or two digits only (i.e., if the year is less
than 100), it is mapped to the window "C<1970 - 2069>" as follows:

   0 E<lt>= $year E<lt>  70  ==>  $year += 2000;
  70 E<lt>= $year E<lt> 100  ==>  $year += 1900;

If the day, month and year are all given numerically but B<WITHOUT> any
delimiting characters between them, this string of digits will be mapped
to the day, month and year as follows:

                Length:        Mapping:
                  3              dmy
                  4              dmyy
                  5              dmmyy
                  6              ddmmyy
                  7              dmmyyyy
                  8              ddmmyyyy

(Where "d" stands for "day", "m" stands for "month" and "y" stands for
"year".)

All other strings consisting purely of digits (without any intervening
delimiters) are rejected, i.e., not recognized.

Examples:

  "3.1.64"
  "3 1 64"
  "03.01.64"
  "03/01/64"
  "3. Jan 1964"
  "Birthday: 3. Jan '64 in Backnang/Germany"
  "03-Jan-64"
  "3.Jan1964"
  "3Jan64"
  "030164"
  "3ja64"
  "3164"

Experiment! (See the corresponding example applications in the
"examples" subdirectory of this distribution in order to do so.)

=item *

C<if (($year,$month,$day) = Decode_Date_US($string))>

This function scans a given string and tries to parse any date
which might be embedded in it. In the original module, this was
a C routine. Now it is simply a call to the perl subroutine
Decode_Date_US2 (see below).

The function returns an empty list if it can't successfully
extract a valid date from its input string, or else it returns
the date found.

The function accepts almost any format, as long as the date is
given in the U.S. american order (hence its name) month-day-year.

Thereby, zero or more B<NON-ALPHANUMERIC> characters may B<PRECEDE>
and B<FOLLOW> the month (i.e., precede the month and separate it from
the day which follows behind).

Moreover, zero or more B<NON-NUMERIC> characters are permitted
B<BETWEEN> the day and the year, as well as B<AFTER> the year.

The month may be given either numerically (i.e., a number from "C<1>"
to "C<12>"), or alphanumerically, i.e., as the name of the month B<IN
THE CURRENTLY SELECTED LANGUAGE>, or any uniquely identifying abbreviation
thereof.

(See further below for details about multi-language support by this package!)

If the year is given as one or two digits only (i.e., if the year is less
than 100), it is mapped to the window "C<1970 - 2069>" as follows:

   0 E<lt>= $year E<lt>  70  ==>  $year += 2000;
  70 E<lt>= $year E<lt> 100  ==>  $year += 1900;

If the month, day and year are all given numerically but B<WITHOUT> any
delimiting characters between them, this string of digits will be mapped
to the month, day and year as follows:

                Length:        Mapping:
                  3              mdy
                  4              mdyy
                  5              mddyy
                  6              mmddyy
                  7              mddyyyy
                  8              mmddyyyy

(Where "m" stands for "month", "d" stands for "day" and "y" stands for
"year".)

All other strings consisting purely of digits (without any intervening
delimiters) are rejected, i.e., not recognized.

If only the day and the year form a contiguous string of digits, they
will be mapped as follows:

                Length:        Mapping:
                  2              dy
                  3              dyy
                  4              ddyy
                  5              dyyyy
                  6              ddyyyy

(Where "d" stands for "day" and "y" stands for "year".)

Examples:

  "1 3 64"
  "01/03/64"
  "Jan 3 '64"
  "Jan 3 1964"
  "===> January 3rd 1964 (birthday)"
  "Jan31964"
  "Jan364"
  "ja364"
  "1364"

Experiment! (See the corresponding example applications in the
"examples" subdirectory of this distribution in order to do so.)

=item *

C<$date = Compress($year,$month,$day);>

This function encodes a date in 16 bits, which is the value being returned.

The encoding scheme is as follows:

            Bit number:    FEDCBA9 8765 43210
            Contents:      yyyyyyy mmmm ddddd

(Where the "yyyyyyy" contain the number of the year, "mmmm" the number of
the month and "ddddd" the number of the day.)

The function returns "C<0>" if the given input values do not represent a
valid date. Therefore, the return value of this function can also be used
as the conditional expression in an "if" statement, in order to check
wether the given input values constitute a valid date).

Through this special encoding scheme, it is possible to B<COMPARE>
compressed dates for equality and order (less than/greater than)
B<WITHOUT> any previous B<DECODING>!

Note however that contiguous dates do B<NOT> necessarily have contiguous
compressed representations!

I.e., incrementing the compressed representation of a date B<MAY OR MAY NOT>
yield a valid new date!

Note also that this function can only handle dates within one century.

This century can be chosen at random by defining a base century and year
(also called the "epoch"). In the original distribution of this package,
the base century is set to "1900" and the base year to "70" (which is
standard on UNIX systems).

This allows this function to handle dates from "1970" up to "2069".

If the given year is equal to, say, "95", this package will automatically
assume that you really mean "1995" instead. However, if you specify a year
number which is B<SMALLER> than 70, like "64", for instance, this package
will assume that you really mean "2064".

You are not confined to two-digit (abbreviated) year numbers, though.

The function also accepts "full-length" year numbers, provided that they
lie in the supported range (i.e., from "1970" to "2069", in the original
configuration of this package).

Note that this function is maintained mainly for backward compatibility,
and that its use is not recommended.

=item *

C<if (($century,$year,$month,$day) = Uncompress($date))>

This function decodes dates that were encoded previously using the function
"C<Compress()>".

It returns the century, year, month and day of the date encoded in "C<$date>"
if "C<$date>" represents a valid date, or an empty list otherwise.

The year returned in "C<$year>" is actually a two-digit year number
(i.e., the year number taken modulo 100), and only the expression
"C<$century + $year>" yields the "full-length" year number
(for example, C<1900 + 95 = 1995>).

Note that this function is maintained mainly for backward compatibility,
and that its use is not recommended.

=item *

C<if (check_compressed($date))>

This function returns "true" ("C<1>") if the given input value
constitutes a valid compressed date, and "false" ("C<0>") otherwise.

Note that this function is maintained mainly for backward compatibility,
and that its use is not recommended.

=item *

C<$string = Compressed_to_Text($date);>

This function returns a string of fixed length (always 9 characters long)
containing a textual representation of the compressed date encoded in
"C<$date>".

This string has the form "dd-Mmm-yy", where "dd" is the two-digit number
of the day, "Mmm" are the first three letters of the name of the month
in the currently selected language (see further below for details about
multi-language support by this package), and "yy" is the two-digit year
number (i.e., the year number taken modulo 100).

If "C<$date>" does not represent a valid date, the string "??-???-??" is
returned instead.

Note that this function is maintained mainly for backward compatibility,
and that its use is not recommended.

=item *

C<$string = Date_to_Text($year,$month,$day);>

This function returns a string containing a textual representation of the
given date of the form "www dd-Mmm-yyyy", where "www" are the first three
letters of the name of the day of week in the currently selected language,
or a special abbreviation, if special abbreviations have been defined for
the currently selected language (see further below for details about
multi-language support by this package), "dd" is the day (one or two digits),
"Mmm" are the first three letters of the name of the month in the currently
selected language, and "yyyy" is the number of the year in full length.

If the given input values do not constitute a valid date, a fatal "not a
valid date" error occurs.

(See the section "RECIPES" near the end of this document for a code snippet
for how to print dates in any format you like.)

=item *

C<$string = Date_to_Text_Long($year,$month,$day);>

This function returns a string containing a textual representation of the
given date roughly of the form "Wwwwww, dd Mmmmmm yyyy", where "Wwwwww"
is the name of the day of week in the currently selected language (see
further below for details about the multi-language support of this package),
"dd" is the day (one or two digits), "Mmmmmm" is the name of the month
in the currently selected language, and "yyyy" is the number of the year
in full length.

The exact format of the output string depends on the currently selected
language. In the original distribution of this package, these formats are
defined as follows:

  1  English    :  "Wwwwww, Mmmmmm ddth yyyy"
  2  French     :  "Wwwwww, le dd Mmmmmm yyyy"
  3  German     :  "Wwwwww, den dd. Mmmmmm yyyy"
  4  Spanish    :  "Wwwwww, dd de Mmmmmm de yyyy"
  5  Portuguese :  "Wwwwww, dia dd de Mmmmmm de yyyy"
  6  Dutch      :  "Wwwwww, dd. Mmmmmm yyyy"
  7  Italian    :  "Wwwwww, dd Mmmmmm yyyy"

(You can change these formats in the file "DateCalc.c" before
building this module in order to suit your personal preferences.)

If the given input values do not constitute a valid date, a fatal "not a
valid date" error occurs.

(See the section "RECIPES" near the end of this document for a code snippet
for how to print dates in any format you like.)

=item *

C<$string = English_Ordinal($number);>

This function returns a string containing the (english) abbreviation
of the ordinal number for the given (cardinal) number "C<$number>".

I.e.,

    0  =>  '0th'    10  =>  '10th'    20  =>  '20th'
    1  =>  '1st'    11  =>  '11th'    21  =>  '21st'
    2  =>  '2nd'    12  =>  '12th'    22  =>  '22nd'
    3  =>  '3rd'    13  =>  '13th'    23  =>  '23rd'
    4  =>  '4th'    14  =>  '14th'    24  =>  '24th'
    5  =>  '5th'    15  =>  '15th'    25  =>  '25th'
    6  =>  '6th'    16  =>  '16th'    26  =>  '26th'
    7  =>  '7th'    17  =>  '17th'    27  =>  '27th'
    8  =>  '8th'    18  =>  '18th'    28  =>  '28th'
    9  =>  '9th'    19  =>  '19th'    29  =>  '29th'

etc.

=item *

C<$string = Calendar($year,$month);>

This function returns a calendar of the given month in the given year
(somewhat similar to the UNIX "cal" command), B<IN THE CURRENTLY SELECTED
LANGUAGE> (see further below for details about multi-language support by
this package).

Example:

  print Calendar(1998,5);

This will print:

           May 1998
  Mon Tue Wed Thu Fri Sat Sun
                    1   2   3
    4   5   6   7   8   9  10
   11  12  13  14  15  16  17
   18  19  20  21  22  23  24
   25  26  27  28  29  30  31

=item *

C<$string = Month_to_Text($month);>

This function returns the name of the given month in the currently selected
language (see further below for details about multi-language support by this
package).

If the given month lies outside of the valid range from "C<1>" to "C<12>",
a fatal "month out of range" error will occur.

=item *

C<$string = Day_of_Week_to_Text($dow);>

This function returns the name of the given day of week in the currently
selected language (see further below for details about multi-language support
by this package).

If the given day of week lies outside of the valid range from "C<1>" to "C<7>",
a fatal "day of week out of range" error will occur.

=item *

C<$string = Day_of_Week_Abbreviation($dow);>

This function returns the special abbreviation of the name of the given
day of week, B<IF> such special abbreviations have been defined for the
currently selected language (see further below for details about
multi-language support by this package).

(In the original distribution of this package, this is only true for
Portuguese.)

If not, the first three letters of the name of the day of week in the
currently selected language are returned instead.

If the given day of week lies outside of the valid range from "C<1>"
to "C<7>", a fatal "day of week out of range" error will occur.

Currently, this table of special abbreviations is only used by the
functions "C<Date_to_Text()>" and "C<Calendar()>", internally.

=item *

C<$string = Language_to_Text($lang);>

This function returns the name of any language supported by this package
when the internal number representing that language is given as input.

The original distribution supports the following seven languages:

            1   ==>   English     (default)
            2   ==>   Français    (French)
            3   ==>   Deutsch     (German)
            4   ==>   Español     (Spanish)
            5   ==>   Português   (Portuguese)
            6   ==>   Nederlands  (Dutch)
            7   ==>   Italiano    (Italian)

See the section "How to install additional languages" in the file
"INSTALL.txt" in this distribution for how to add more languages
to this package.

See the description of the function "C<Languages()>" further below
to determine how many languages are actually available in a given
installation of this package.

=item *

C<$lang = Language();>

=item *

C<Language($lang);>

=item *

C<$oldlang = Language($newlang);>

This function can be used to determine which language is currently selected,
and to change the selected language.

Thereby, each language has a unique internal number.

The original distribution contains the following seven languages:

            1   ==>   English     (default)
            2   ==>   Français    (French)
            3   ==>   Deutsch     (German)
            4   ==>   Español     (Spanish)
            5   ==>   Português   (Portuguese)
            6   ==>   Nederlands  (Dutch)
            7   ==>   Italiano    (Italian)

See the section "How to install additional languages" in the file
"INSTALL.txt" in this distribution for how to add more languages
to this package.

See the description of the function "C<Languages()>" further below
to determine how many languages are actually available in a given
installation of this package.

B<BEWARE> that in order for your programs to be portable, you should B<NEVER>
actually use the internal number of a language in this package B<EXPLICITLY>,
because the same number could mean different languages on different systems,
depending on what languages have been added to any given installation of this
package.

Therefore, you should always use a statement such as

  Language(Decode_Language("Name_of_Language"));

to select the desired language, and

  $language = Language_to_Text(Language());

or

  $old_language = Language_to_Text(Language("Name_of_new_Language"));

to determine the (previously) selected language.

If the so chosen language is not available in the current installation,
this will result in an appropriate error message, instead of silently
using the wrong (a random) language (which just happens to have the
same internal number in the other installation).

Note that in the current implementation of this package, the selected
language is a global setting valid for B<ALL> functions that use the names
of months, days of week or languages internally, valid for B<ALL PROCESSES>
using the same copy of the "Date::Pcalc" shared library in memory!

This may have surprising side-effects in a multi-user environment, and even
more so when Perl will be capable of multi-threading in some future release.

=item *

C<$max_lang = Languages();>

This function returns the (maximum) number of languages which are
currently available in your installation of this package.

(This may vary from installation to installation.)

See the section "How to install additional languages" in the file
"INSTALL.txt" in this distribution for how to add more languages
to this package.

In the original distribution of this package there are seven built-in
languages, therefore the value returned by this function will be "C<7>"
if no other languages have been added to your particular installation.

=item *

C<if (($year,$month,$day) = Decode_Date_EU2($string))>

This function is the Perl equivalent of the function "C<Decode_Date_EU()>"
(implemented in C), included here merely as an example to demonstrate how
easy it is to write your own routine in Perl (using regular expressions)
adapted to your own special needs, should the necessity arise, and intended
primarily as a basis for your own development.

In one particular case this Perl version is actually slightly more permissive
than its C equivalent, as far as the class of permitted intervening (i.e.,
delimiting) characters is concerned.

(Can you tell the subtle, almost insignificant difference by looking at
the code? Or by experimenting? Hint: Try the string "a3b1c64d" with both
functions.)

=item *

C<if (($year,$month,$day) = Decode_Date_US2($string))>

This function is the Perl equivalent of the function "C<Decode_Date_US()>"
(implemented in C), included here merely as an example to demonstrate how
easy it is to write your own routine in Perl (using regular expressions)
adapted to your own special needs, should the necessity arise, and intended
primarily as a basis for your own development.

In one particular case this Perl version is actually slightly more permissive
than its C equivalent.

(Hint: This is the same difference as with the "C<Decode_Date_EU()>" and
"C<Decode_Date_EU2()>" pair of functions.)

In a different case, the C version is a little bit more permissive than its
Perl equivalent.

(Can you tell the difference by looking at the code? Or by experimenting?
Hint: Try the string "(1/364)" with both functions.)

=item *

C<if (($year,$month,$day) = Parse_Date($string))>

This function is useful for parsing dates as returned by the UNIX "C<date>"
command or as found in the headers of e-mail (in order to determine the
date at which some e-mail has been sent or received, for instance).

Example #1:

  ($year,$month,$day) = Parse_Date(`/bin/date`);

Example #2:

  while (<MAIL>)
  {
      if (/^From \S/)
      {
          ($year,$month,$day) = Parse_Date($_);
          ...
      }
      ...
  }

The function returns an empty list if it can't extract a valid date from
the input string.

=item *

C<$string = Date::Pcalc::Version();>

This function returns a string with the (numeric) version number of the
S<C library> ("DateCalc.c") at the core of this package (which is also
(automatically) the version number of the "Calc.xs" file).

Note that under all normal circumstances, this version number should be
identical with the one found in the Perl variable "C<$Date::Pcalc::VERSION>"
(the version number of the "Calc.pm" file).

Since this function is not exported, you always have to qualify it explicitly,
i.e., "C<Date::Pcalc::Version()>".

This is to avoid possible name space conflicts with version functions from
other modules.

=back

=head1 RECIPES

=over 4

=item 1)

How do I compare two dates?

Solution #1:

  use Date::Pcalc qw( Date_to_Days );

  if (Date_to_Days($year1,$month1,$day1)  <
      Date_to_Days($year2,$month2,$day2))

  if (Date_to_Days($year1,$month1,$day1)  <=
      Date_to_Days($year2,$month2,$day2))

  if (Date_to_Days($year1,$month1,$day1)  >
      Date_to_Days($year2,$month2,$day2))

  if (Date_to_Days($year1,$month1,$day1)  >=
      Date_to_Days($year2,$month2,$day2))

  if (Date_to_Days($year1,$month1,$day1)  ==
      Date_to_Days($year2,$month2,$day2))

  if (Date_to_Days($year1,$month1,$day1)  !=
      Date_to_Days($year2,$month2,$day2))

  $cmp = (Date_to_Days($year1,$month1,$day1)  <=>
          Date_to_Days($year2,$month2,$day2));

Solution #2:

  use Date::Pcalc qw( Delta_Days );

  if (Delta_Days($year1,$month1,$day1,
                 $year2,$month2,$day2) > 0)

  if (Delta_Days($year1,$month1,$day1,
                 $year2,$month2,$day2) >= 0)

  if (Delta_Days($year1,$month1,$day1,
                 $year2,$month2,$day2) < 0)

  if (Delta_Days($year1,$month1,$day1,
                 $year2,$month2,$day2) <= 0)

  if (Delta_Days($year1,$month1,$day1,
                 $year2,$month2,$day2) == 0)

  if (Delta_Days($year1,$month1,$day1,
                 $year2,$month2,$day2) != 0)

=item 2)

How do I check wether a given date lies within a certain range of dates?

  use Date::Pcalc qw( Date_to_Days );

  $lower = Date_to_Days($year1,$month1,$day1);
  $upper = Date_to_Days($year2,$month2,$day2);

  $date = Date_to_Days($year,$month,$day);

  if (($date >= $lower) && ($date <= $upper))
  {
      # ok
  }
  else
  {
      # not ok
  }

=item 3)

How do I verify wether someone has a certain age?

  use Date::Pcalc qw( Decode_Date_EU Today leap_year Delta_Days );

  $date = <STDIN>; # get birthday

  ($year1,$month1,$day1) = Decode_Date_EU($date);

  ($year2,$month2,$day2) = Today();

  if (($day1 == 29) && ($month1 == 2) && !leap_year($year2))
      { $day1--; }

  if ( (($year2 - $year1) >  18) ||
     ( (($year2 - $year1) == 18) &&
     (Delta_Days($year2,$month1,$day1, $year2,$month2,$day2) >= 0) ) )
  {
      print "Ok - you are over 18.\n";
  }
  else
  {
      print "Sorry - you aren't 18 yet!\n";
  }

=item 4)

How do I calculate the number of the week of month
the current date lies in?

For example:

            April 1998
    Mon Tue Wed Thu Fri Sat Sun
              1   2   3   4   5  =  week #1
      6   7   8   9  10  11  12  =  week #2
     13  14  15  16  17  18  19  =  week #3
     20  21  22  23  24  25  26  =  week #4
     27  28  29  30              =  week #5

Solution:

  use Date::Pcalc qw( Today Day_of_Week );

  ($year,$month,$day) = Today();

  $week = int(($day + Day_of_Week($year,$month,1) - 2) / 7) + 1;

=item 5)

How do I calculate wether a given date is the 1st, 2nd, 3rd, 4th or 5th
of that day of week in the given month?

For example:

           October 2000
    Mon Tue Wed Thu Fri Sat Sun
                              1
      2   3   4   5   6   7   8
      9  10  11  12  13  14  15
     16  17  18  19  20  21  22
     23  24  25  26  27  28  29
     30  31

Is Sunday, the 15th of October 2000, the 1st, 2nd, 3rd, 4th or 5th
Sunday of that month?

Solution:

  use Date::Pcalc qw( Day_of_Week Delta_Days
                     Nth_Weekday_of_Month_Year
                     Date_to_Text_Long English_Ordinal
                     Day_of_Week_to_Text Month_to_Text );

  ($year,$month,$day) = (2000,10,15);

  $dow = Day_of_Week($year,$month,$day);

  $n = int( Delta_Days(
            Nth_Weekday_of_Month_Year($year,$month,$dow,1),
            $year,$month,$day)
            / 7) + 1;

  printf("%s is the %s %s in %s %d.\n",
      Date_to_Text_Long($year,$month,$day),
      English_Ordinal($n),
      Day_of_Week_to_Text($dow),
      Month_to_Text($month),
      $year);

This prints:

  Sunday, October 15th 2000 is the 3rd Sunday in October 2000.

=item 6)

How do I calculate the date of the Wednesday of the same week as
the current date?

Solution #1:

  use Date::Pcalc qw( Today Day_of_Week Add_Delta_Days );

  $searching_dow = 3; # 3 = Wednesday

  @today = Today();

  $current_dow = Day_of_Week(@today);

  @date = Add_Delta_Days(@today, $searching_dow - $current_dow);

Solution #2:

  use Date::Pcalc qw( Today Add_Delta_Days
                     Monday_of_Week Week_of_Year );

  $searching_dow = 3; # 3 = Wednesday

  @today = Today();

  @date = Add_Delta_Days( Monday_of_Week( Week_of_Year(@today) ),
                          $searching_dow - 1 );

Solution #3:

  use Date::Pcalc qw( Standard_to_Business Today
                     Business_to_Standard );

  @business = Standard_to_Business(Today());

  $business[2] = 3; # 3 = Wednesday

  @date = Business_to_Standard(@business);

=item 7)

How can I add a week offset to a business date (including across
year boundaries)?

  use Date::Pcalc qw( Business_to_Standard Add_Delta_Days
                     Standard_to_Business );

  @temp = Business_to_Standard($year,$week,$dow);

  @temp = Add_Delta_Days(@temp, $week_offset * 7);

  ($year,$week,$dow) = Standard_to_Business(@temp);

=item 8)

How do I calculate the last and the next Saturday for any
given date?

  use Date::Pcalc qw( Today Day_of_Week Add_Delta_Days
                     Day_of_Week_to_Text Date_to_Text );

  $searching_dow = 6; # 6 = Saturday

  @today = Today();

  $current_dow = Day_of_Week(@today);

  if ($searching_dow == $current_dow)
  {
      @prev = Add_Delta_Days(@today,-7);
      @next = Add_Delta_Days(@today,+7);
  }
  else
  {
      if ($searching_dow > $current_dow)
      {
          @next = Add_Delta_Days(@today,
                    $searching_dow - $current_dow);
          @prev = Add_Delta_Days(@next,-7);
      }
      else
      {
          @prev = Add_Delta_Days(@today,
                    $searching_dow - $current_dow);
          @next = Add_Delta_Days(@prev,+7);
      }
  }

  $dow = Day_of_Week_to_Text($searching_dow);

  print "Today is:      ", ' ' x length($dow),
                               Date_to_Text(@today), "\n";
  print "Last $dow was:     ", Date_to_Text(@prev),  "\n";
  print "Next $dow will be: ", Date_to_Text(@next),  "\n";

This will print something like:

  Today is:              Sun 12-Apr-1998
  Last Saturday was:     Sat 11-Apr-1998
  Next Saturday will be: Sat 18-Apr-1998

=item 9)

How can I calculate the last business day (payday!) of a month?

Solution #1 (holidays B<NOT> taken into account):

  use Date::Pcalc qw( Days_in_Month Day_of_Week Add_Delta_Days );

  $day = Days_in_Month($year,$month);
  $dow = Day_of_Week($year,$month,$day);
  if ($dow > 5)
  {
      ($year,$month,$day) =
          Add_Delta_Days($year,$month,$day, 5-$dow);
  }

Solution #2 (holidays taken into account):

This solution expects a multi-dimensional array "C<@holiday>", which
contains all holidays, as follows: "C<$holiday[$year][$month][$day] = 1;>".

(See the description of the function "C<Easter_Sunday()>" further above for
how to calculate the moving (variable) christian feast days!)

Days which are not holidays remain undefined or should have a value of zero
in this array.

  use Date::Pcalc qw( Days_in_Month Add_Delta_Days Day_of_Week );

  $day = Days_in_Month($year,$month);
  while (1)
  {
      while ($holiday[$year][$month][$day])
      {
          ($year,$month,$day) =
              Add_Delta_Days($year,$month,$day, -1);
      }
      $dow = Day_of_Week($year,$month,$day);
      if ($dow > 5)
      {
          ($year,$month,$day) =
              Add_Delta_Days($year,$month,$day, 5-$dow);
      }
      else { last; }
  }

=item 10)

How do I convert a MS Visual Basic "DATETIME" value into its date
and time constituents?

  use Date::Pcalc qw( Add_Delta_DHMS Date_to_Text );

  $datetime = "35883.121653";

  ($Dd,$Dh,$Dm,$Ds) = ($datetime =~ /^(\d+)\.(\d\d)(\d\d)(\d\d)$/);

  ($year,$month,$day, $hour,$min,$sec) =
      Add_Delta_DHMS(1900,1,1, 0,0,0, $Dd,$Dh,$Dm,$Ds);

  printf("The given date is %s %02d:%02d:%02d\n",
      Date_to_Text($year,$month,$day), $hour, $min, $sec);

This prints:

  The given date is Tue 31-Mar-1998 12:16:53

=item 11)

How can I send a reminder to members of a group on the day
before a meeting which occurs every first Friday of a month?

  use Date::Pcalc qw( Today Date_to_Days Add_Delta_YMD
                     Nth_Weekday_of_Month_Year );

  ($year,$month,$day) = Today();

  $tomorrow = Date_to_Days($year,$month,$day) + 1;

  $dow = 5; # 5 = Friday
  $n   = 1; # 1 = First of that day of week

  $meeting_this_month = Date_to_Days(
      Nth_Weekday_of_Month_Year($year,$month,$dow,$n) );

  ($year,$month,$day) = Add_Delta_YMD($year,$month,$day, 0,1,0);

  $meeting_next_month = Date_to_Days(
      Nth_Weekday_of_Month_Year($year,$month,$dow,$n) );

  if (($tomorrow == $meeting_this_month) ||
      ($tomorrow == $meeting_next_month))
  {
      # Send reminder e-mail!
  }

=item 12)

How can I print a date in a different format than provided by
the functions "C<Date_to_Text()>", "C<Date_to_Text_Long()>" or
"C<Compressed_to_Text()>"?

  use Date::Pcalc qw( Today Day_of_Week_to_Text
                     Day_of_Week Month_to_Text
                     English_Ordinal );

  ($year,$month,$day) = Today();

For example with leading zeros for the day: "S<Fri 03-Jan-1964>"

  printf("%.3s %02d-%.3s-%d\n",
      Day_of_Week_to_Text(Day_of_Week($year,$month,$day)),
      $day,
      Month_to_Text($month),
      $year);

For example in U.S. american format: "S<April 12th, 1998>"

  $string = sprintf("%s %s, %d",
                Month_to_Text($month),
                English_Ordinal($day),
                $year);

(See also L<perlfunc(1)/printf> and/or L<perlfunc(1)/sprintf>!)

=item 13)

How can I iterate through a range of dates?

  use Date::Pcalc qw( Delta_Days Add_Delta_Days );

  @start = (1999,5,27);
  @stop  = (1999,6,1);

  $j = Delta_Days(@start,@stop);

  for ( $i = 0; $i <= $j; $i++ )
  {
      @date = Add_Delta_Days(@start,$i);
      printf("%4d/%02d/%02d\n", @date);
  }

Note that the loop can be improved; see also the recipe below.

=item 14)

How can I create a (Perl) list of dates in a certain range?

  use Date::Pcalc qw( Delta_Days Add_Delta_Days Date_to_Text );

  sub date_range
  {
      my(@date) = (@_)[0,1,2];
      my(@list);
      my($i);

      $i = Delta_Days(@_);
      while ($i-- >= 0)
      {
          push( @list, [ @date ] );
          @date = Add_Delta_Days(@date, 1) if ($i >= 0);
      }
      return(@list);
  }

  @range = &date_range(1999,11,3, 1999,12,24); # in chronological order

  foreach $date (@range)
  {
      print Date_to_Text(@{$date}), "\n";
  }

Note that you probably shouldn't use this one, because it is much
more efficient to iterate through all the dates (as shown in the
recipe immediately above) than to construct such an array and then
to loop through it. Also, it is much more space-efficient not to
create this array.

=item 15)

How can I calculate the difference in days between dates,
but without counting Saturdays and Sundays?

  sub Delta_Business_Days
  {
      my(@date1) = (@_)[0,1,2];
      my(@date2) = (@_)[3,4,5];
      my($minus,$result,$dow1,$dow2,$diff,$temp);

      $minus  = 0;
      $result = Delta_Days(@date1,@date2);
      if ($result != 0)
      {
          if ($result < 0)
          {
              $minus = 1;
              $result = -$result;
              $dow1 = Day_of_Week(@date2);
              $dow2 = Day_of_Week(@date1);
          }
          else
          {
              $dow1 = Day_of_Week(@date1);
              $dow2 = Day_of_Week(@date2);
          }
          $diff = $dow2 - $dow1;
          $temp = $result;
          if ($diff != 0)
          {
              if ($diff < 0)
              {
                  $diff += 7;
              }
              $temp -= $diff;
              $dow1 += $diff;
              if ($dow1 > 6)
              {
                  $result--;
                  if ($dow1 > 7)
                  {
                      $result--;
                  }
              }
          }
          if ($temp != 0)
          {
              $temp /= 7;
              $result -= ($temp << 1);
          }
      }
      if ($minus) { return -$result; }
      else        { return  $result; }
  }

This solution is probably of little practical value, however,
because it doesn't take legal holidays into account.

=back

=head1 SEE ALSO

  "The Calendar FAQ":
  http://www.tondering.dk/claus/calendar.html
  by Claus Tondering <claus@tondering.dk>

=head1 LIMITATIONS

In the current implementation of this package, the selected language
is stored in a global variable named $pcalc_Language.

Therefore, on systems where the "Date::Pcalc" module is a shared library,
or as soon as Perl will be capable of multi-threading, this may cause
undesired effects (of one process or thread always selecting the language
for B<ALL OTHER> processes or threads as well).

=head1 VERSION

This man page documents "Date::Pcalc" version 1.2.

=head1 AUTHOR

  J. David Eisenberg
  4604 Corrida Circle
  San Jose, California 95129
  USA

  mailto: nessus@best.com
  http://www.best.com/~nessus/date/pcalc.html

B<Please contact me by e-mail whenever possible!>

All the mistakes in this implementation are caused by
my translation of the original C code to perl.

Anything that works does so because it was written
correctly by the original author:

  Steffen Beyer
  mailto:sb@engelschall.com
  http://www.engelschall.com/u/sb/download/

=head1 COPYRIGHT

Copyright (c) 1999-2001 by J. David Eisenberg; portions
Copyright (c) 1993-2001 by Steffen Beyer.
All rights reserved.

=head1 LICENSE

This package is free software; you can redistribute it and/or
modify it under the same terms as Perl itself, i.e., under the
terms of the "Artistic License" or the "GNU General Public License".

Please refer to the files "Artistic.txt" and "GNU_GPL.txt" in this
distribution for details!

=head1 DISCLAIMER

This package is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the "GNU General Public License" for more details.

=cut

