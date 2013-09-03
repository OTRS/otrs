
###############################################################################
##                                                                           ##
##    Copyright (c) 1995 - 2009 by Steffen Beyer.                            ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

package Date::Pcalc;

BEGIN { eval { require bytes; }; }
use strict;
use vars qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $VERSION);

use Carp::Clan qw(^Date::);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);

@EXPORT = qw();

@EXPORT_OK = qw(
    Days_in_Year
    Days_in_Month
    Weeks_in_Year
    leap_year
    check_date
    check_time
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
    Delta_YMD
    Delta_YMDHMS
    N_Delta_YMD
    N_Delta_YMDHMS
    Normalize_DHMS
    Add_Delta_Days
    Add_Delta_DHMS
    Add_Delta_YM
    Add_Delta_YMD
    Add_Delta_YMDHMS
    Add_N_Delta_YMD
    Add_N_Delta_YMDHMS
    System_Clock
    Today
    Now
    Today_and_Now
    This_Year
    Gmtime
    Localtime
    Mktime
    Timezone
    Date_to_Time
    Time_to_Date
    Easter_Sunday
    Decode_Month
    Decode_Day_of_Week
    Decode_Language
    Decode_Date_EU
    Decode_Date_US
    Fixed_Window
    Moving_Window
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
    ISO_LC
    ISO_UC
);

%EXPORT_TAGS = (all => [@EXPORT_OK]);

##################################################
##                                              ##
##  "Version()" is available but not exported   ##
##  in order to avoid possible name clashes.    ##
##  Call with "Date::Pcalc::Version()" instead! ##
##                                              ##
##################################################

$VERSION = '6.1';

sub Version
{
    return $VERSION;
}

#################
##             ##
##  Resources  ##
##             ##
#################

my $DateCalc_YEAR_OF_EPOCH    =   70;   # year of reference (epoch)
my $DateCalc_CENTURY_OF_EPOCH = 1900;   # century of reference (epoch)
my $DateCalc_EPOCH = $DateCalc_CENTURY_OF_EPOCH + $DateCalc_YEAR_OF_EPOCH;

my $DateCalc_DAYS_TO_EPOCH;
my $DateCalc_DAYS_TO_OVFLW;
my $DateCalc_SECS_TO_OVFLW;

## MacOS (Classic):                                            ##
## <695056.0>     = Fri  1-Jan-1904 00:00:00 (time=0x00000000) ##
## <744766.23295> = Mon  6-Feb-2040 06:28:15 (time=0xFFFFFFFF) ##

## Unix:                                                       ##
## <719163.0>     = Thu  1-Jan-1970 00:00:00 (time=0x00000000) ##
## <744018.11647> = Tue 19-Jan-2038 03:14:07 (time=0x7FFFFFFF) ##

if ($^O eq 'MacOS')
{
    $DateCalc_DAYS_TO_EPOCH = 695056;
    $DateCalc_DAYS_TO_OVFLW = 744766;
    $DateCalc_SECS_TO_OVFLW =  23295;
}
else
{
    $DateCalc_DAYS_TO_EPOCH = 719163;
    $DateCalc_DAYS_TO_OVFLW = 744018;
    $DateCalc_SECS_TO_OVFLW =  11647;
}

my(@DateCalc_Days_in_Year_) =
(
    [ 0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 ],
    [ 0, 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 ]
);

my(@DateCalc_Days_in_Month_) =
(
    [ 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ],
    [ 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
);

my $DateCalc_LANGUAGES = 14;

my $DateCalc_Language = 1; # Default = 1 (English)

my(@DateCalc_Month_to_Text_) =
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
        "???", "janvier", "février", "mars", "avril", "mai", "juin",
        "juillet", "août", "septembre", "octobre", "novembre", "décembre"
    ],
    [
        "???", "Januar", "Februar", "März", "April", "Mai", "Juni",
        "Juli", "August", "September", "Oktober", "November", "Dezember"
    ],
    [
        "???", "enero", "febrero", "marzo", "abril", "mayo", "junio",
        "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"
    ],
    [
        "???", "janeiro", "fevereiro", "março", "abril", "maio", "junho",
        "julho", "agosto", "setembro", "outubro", "novembro", "dezembro"
    ],
    [
        "???", "januari", "februari", "maart", "april", "mei", "juni",
        "juli", "augustus", "september", "oktober", "november", "december"
    ],
    [
        "???", "Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno",
        "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"
    ],
    [
        "???", "januar", "februar", "mars", "april", "mai", "juni",
        "juli", "august", "september", "oktober", "november", "desember"
    ],
    [
        "???", "januari", "februari", "mars", "april", "maj", "juni",
        "juli", "augusti", "september", "oktober", "november", "december"
    ],
    [
        "???", "januar", "februar", "marts", "april", "maj", "juni",
        "juli", "august", "september", "oktober", "november", "december"
    ],
    [
        "???", "tammikuu", "helmikuu", "maaliskuu", "huhtikuu",
        "toukokuu", "kesäkuu", "heinäkuu", "elokuu",
        "syyskuu", "lokakuu", "marraskuu", "joulukuu"
    ],
    [
        "???", "Január", "Február", "Március", "Április", "Május", "Június",
        "Július", "Augusztus", "Szeptember", "Október", "November", "December"
    ],
    [
        "???", "Styczen", "Luty", "Marzec", "Kwiecien", "Maj", "Czerwiec",     # ISO-Latin-1 approximation
        "Lipiec", "Sierpien", "Wrzesien", "Pazdziernik", "Listopad", "Grudzien"
    ],
    [
        "???", "Ianuarie", "Februarie", "Martie", "Aprilie", "Mai", "Iunie",
        "Iulie", "August", "Septembrie", "Octombrie", "Noiembrie", "Decembrie"
    ]
);

my(@DateCalc_Day_of_Week_to_Text_) =
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
    ],
    [
        "???", "mandag", "tirsdag", "onsdag",
        "torsdag", "fredag", "lørdag", "søndag"
    ],
    [
        "???", "måndag", "tisdag", "onsdag",
        "torsdag", "fredag", "lördag", "söndag"
    ],
    [
        "???", "mandag", "tirsdag", "onsdag",
        "torsdag", "fredag", "lørdag", "søndag"
    ],
    [
        "???", "maanantai", "tiistai", "keskiviikko",
        "torstai", "perjantai", "lauantai", "sunnuntai"
    ],
    [
        "???", "hétfõ", "kedd", "szerda",
        "csütörtök", "péntek", "szombat", "vasárnap"
    ],
    [
        "???", "poniedzialek", "wtorek", "sroda",     # ISO-Latin-1 approximation
        "czwartek", "piatek", "sobota", "niedziela"
    ],
    [
        "???", "Luni", "Marti", "Miercuri",
        "Joi", "Vineri", "Sambata", "Duminica"
    ]
);

my(@DateCalc_Day_of_Week_Abbreviation_) =
(
    #  Fill the fields below _only_ if special abbreviations are needed!
    #  Note that the first field serves as a flag and must be non-empty!
    [
        "", "", "", "", "", "", "", ""    #   0  #
    ],
    [
        "", "", "", "", "", "", "", ""    #   1  #
    ],
    [
        "", "", "", "", "", "", "", ""    #   2  #
    ],
    [
        "", "", "", "", "", "", "", ""    #   3  #
    ],
    [
        "", "", "", "", "", "", "", ""    #   4  #
    ],
    [
        "", "", "", "", "", "", "", ""    #   5  #
#       "???", "2ª", "3ª", "4ª", "5ª", "6ª", "Sáb", "Dom"    #   5  #
    ],
    [
        "", "", "", "", "", "", "", ""    #   6  #
    ],
    [
        "", "", "", "", "", "", "", ""    #   7  #
    ],
    [
        "", "", "", "", "", "", "", ""    #   8  #
    ],
    [
        "", "", "", "", "", "", "", ""    #   9  #
    ],
    [
        "", "", "", "", "", "", "", ""    #  10  #
    ],
    [
        "", "", "", "", "", "", "", ""    #  11  #
    ],
    [
        "", "", "", "", "", "", "", ""    #  12  #
    ],
    [
        "???", "Pn", "Wt", "Sr", "Cz", "Pt", "So", "Ni"    #  13  #    ISO-Latin-1 approximation
    ],
    [
        "", "", "", "", "", "", "", ""    #  14  #
    ]
);

my(@DateCalc_English_Ordinals_) =
(
    "th",
    "st",
    "nd",
    "rd"
);

my(@DateCalc_Date_Long_Format_) =
(
    "%s, %d %s %d",                     #   0  Default      #
    "%s, %s %s %d",                     #   1  English      #
    "%s %d %s %d",                      #   2  Français     #
    "%s, den %d. %s %d",                #   3  Deutsch      #
    "%s, %d de %s de %d",               #   4  Español      #
    "%s, dia %d de %s de %d",           #   5  Português    #
    "%s, %d %s %d",                     #   6  Nederlands   #
    "%s, %d %s %d",                     #   7  Italiano     #
    "%s, %d. %s %d",                    #   8  Norsk        #
    "%s, %d %s %d",                     #   9  Svenska      #
    "%s, %d. %s %d",                    #  10  Dansk        #
    "%s, %d. %sta %d",                  #  11  suomi        #
    "%d. %s %d., %s",                   #  12  Magyar       #
    "%s, %d %s %d",                     #  13  polski       #
    "%s %d %s %d"                       #  14  Romaneste    #
);

my(@DateCalc_Language_to_Text_) =
(
    "???", "English", "Français", "Deutsch", "Español",
    "Português", "Nederlands", "Italiano", "Norsk", "Svenska",
    "Dansk", "suomi", "Magyar", "polski", "Romaneste"
);

###############
##           ##
##  Calc.xs  ##
##           ##
###############

###############################################################################
##                                                                           ##
##    Copyright (c) 1995 - 2009 by Steffen Beyer.                            ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

sub DATECALC_USAGE
{
    croak('Usage: Date::Pcalc::' . $_[0]);
}
sub DATECALC_ERROR
{
    croak("Date::Pcalc::$_[0](): $_[1]");
}
sub DATECALC_DATE_ERROR
{
    croak("Date::Pcalc::$_[0](): not a valid date");
}
sub DATECALC_TIME_ERROR
{
    croak("Date::Pcalc::$_[0](): not a valid time");
}
sub DATECALC_YEAR_ERROR
{
    croak("Date::Pcalc::$_[0](): year out of range");
}
sub DATECALC_MONTH_ERROR
{
    croak("Date::Pcalc::$_[0](): month out of range");
}
sub DATECALC_WEEK_ERROR
{
    croak("Date::Pcalc::$_[0](): week out of range");
}
sub DATECALC_DAYOFWEEK_ERROR
{
    croak("Date::Pcalc::$_[0](): day of week out of range");
}
sub DATECALC_DATE_RANGE_ERROR
{
    croak("Date::Pcalc::$_[0](): date out of range");
}
sub DATECALC_TIME_RANGE_ERROR
{
    croak("Date::Pcalc::$_[0](): time out of range");
}
sub DATECALC_FACTOR_ERROR
{
    croak("Date::Pcalc::$_[0](): factor out of range");
}
sub DATECALC_LANGUAGE_ERROR
{
    croak("Date::Pcalc::$_[0](): language not available");
}
sub DATECALC_SYSTEM_ERROR
{
    croak("Date::Pcalc::$_[0](): not available on this system");
}
sub DATECALC_MEMORY_ERROR
{
    croak("Date::Pcalc::$_[0](): unable to allocate memory");
}
sub DATECALC_STRING_ERROR
{
    croak("Date::Pcalc::$_[0](): argument is not a string");
}
sub DATECALC_SCALAR_ERROR
{
    croak("Date::Pcalc::$_[0](): argument is not a scalar");
}

sub Days_in_Year
{
    DATECALC_USAGE('Days_in_Year($year,$month)') unless (@_ == 2);
    my($year,$month) = @_;
    if ($year > 0)
    {
        if (($month >= 1) and ($month <= 12))
        {
            return $DateCalc_Days_in_Year_[DateCalc_leap_year($year)][$month+1];
        }
        else { DATECALC_MONTH_ERROR('Days_in_Year'); }
    }
    else { DATECALC_YEAR_ERROR('Days_in_Year'); }
}

sub Days_in_Month
{
    DATECALC_USAGE('Days_in_Month($year,$month)') unless (@_ == 2);
    my($year,$month) = @_;
    if ($year > 0)
    {
        if (($month >= 1) and ($month <= 12))
        {
            return $DateCalc_Days_in_Month_[DateCalc_leap_year($year)][$month];
        }
        else { DATECALC_MONTH_ERROR('Days_in_Month'); }
    }
    else { DATECALC_YEAR_ERROR('Days_in_Month'); }
}

sub Weeks_in_Year
{
    DATECALC_USAGE('Weeks_in_Year($year)') unless (@_ == 1);
    my($year) = shift;
    if ($year > 0)
    {
        return DateCalc_Weeks_in_Year($year);
    }
    else { DATECALC_YEAR_ERROR('Weeks_in_Year'); }
}

sub leap_year
{
    DATECALC_USAGE('leap_year($year)') unless (@_ == 1);
    my($year) = shift;
    if ($year > 0)
    {
        return DateCalc_leap_year($year);
    }
    else { DATECALC_YEAR_ERROR('leap_year'); }
}

sub check_date
{
    DATECALC_USAGE('check_date($year,$month,$day)') unless (@_ == 3);
    my($year,$month,$day) = @_;
    return DateCalc_check_date($year,$month,$day);
}

sub check_time
{
    DATECALC_USAGE('check_time($hour,$min,$sec)') unless (@_ == 3);
    my($hour,$min,$sec) = @_;
    return DateCalc_check_time($hour,$min,$sec);
}

sub check_business_date
{
    DATECALC_USAGE('check_business_date($year,$week,$dow)') unless (@_ == 3);
    my($year,$week,$dow) = @_;
    return DateCalc_check_business_date($year,$week,$dow);
}

sub Day_of_Year
{
    DATECALC_USAGE('Day_of_Year($year,$month,$day)') unless (@_ == 3);
    my($year,$month,$day) = @_;
    my $retval = DateCalc_Day_of_Year($year,$month,$day);
    if ($retval == 0) { DATECALC_DATE_ERROR('Day_of_Year'); }
    return $retval;
}

sub Date_to_Days
{
    DATECALC_USAGE('Date_to_Days($year,$month,$day)') unless (@_ == 3);
    my($year,$month,$day) = @_;
    my $retval = DateCalc_Date_to_Days($year,$month,$day);
    if ($retval == 0) { DATECALC_DATE_ERROR('Date_to_Days'); }
    return $retval;
}

sub Day_of_Week
{
    DATECALC_USAGE('Day_of_Week($year,$month,$day)') unless (@_ == 3);
    my($year,$month,$day) = @_;
    my $retval = DateCalc_Day_of_Week($year,$month,$day);
    if ($retval == 0) { DATECALC_DATE_ERROR('Day_of_Week'); }
    return $retval;
}

sub Week_Number
{
    DATECALC_USAGE('Week_Number($year,$month,$day)') unless (@_ == 3);
    my($year,$month,$day) = @_;
    my($retval);
    if (DateCalc_check_date($year,$month,$day))
    {
        $retval = DateCalc_Week_Number($year,$month,$day);
    }
    else { DATECALC_DATE_ERROR('Week_Number'); }
    return $retval;
}

sub Week_of_Year
{
    DATECALC_USAGE('Week_of_Year($year,$month,$day)') unless (@_ == 3);
    my($year,$month,$day) = @_;
    my($week);
    if (DateCalc_week_of_year(\$week,\$year,$month,$day))
    {
        if (wantarray) { return($week,$year); }
        else           { return $week;        }
    }
    else { DATECALC_DATE_ERROR('Week_of_Year'); }
}

sub Monday_of_Week
{
    DATECALC_USAGE('Monday_of_Week($week,$year)') unless (@_ == 2);
    my($week,$year) = @_;
    my($month,$day);
    if ($year > 0)
    {
        if (($week > 0) and ($week <= DateCalc_Weeks_in_Year($year)))
        {
            if (DateCalc_monday_of_week($week,\$year,\$month,\$day))
            {
                return($year,$month,$day);
            }
            else { DATECALC_DATE_ERROR('Monday_of_Week'); }
        }
        else { DATECALC_WEEK_ERROR('Monday_of_Week'); }
    }
    else { DATECALC_YEAR_ERROR('Monday_of_Week'); }
}

sub Nth_Weekday_of_Month_Year
{
    DATECALC_USAGE('Nth_Weekday_of_Month_Year($year,$month,$dow,$n)') unless (@_ == 4);
    my($year,$month,$dow,$n) = @_;
    my($day);
    if ($year > 0)
    {
        if (($month >= 1) and ($month <= 12))
        {
            if (($dow >= 1) and ($dow <= 7))
            {
                if (($n >= 1) and ($n <= 5))
                {
                    if (DateCalc_nth_weekday_of_month_year(\$year,\$month,\$day,$dow,$n))
                    {
                        return($year,$month,$day);
                    }
                    else { return(); }
                }
                else { DATECALC_FACTOR_ERROR('Nth_Weekday_of_Month_Year'); }
            }
            else { DATECALC_DAYOFWEEK_ERROR('Nth_Weekday_of_Month_Year'); }
        }
        else { DATECALC_MONTH_ERROR('Nth_Weekday_of_Month_Year'); }
    }
    else { DATECALC_YEAR_ERROR('Nth_Weekday_of_Month_Year'); }
}

sub Standard_to_Business
{
    DATECALC_USAGE('Standard_to_Business($year,$month,$day)') unless (@_ == 3);
    my($year,$month,$day) = @_;
    my($week,$dow);
    if (DateCalc_standard_to_business(\$year,\$week,\$dow,$month,$day))
    {
        return($year,$week,$dow);
    }
    else { DATECALC_DATE_ERROR('Standard_to_Business'); }
}

sub Business_to_Standard
{
    DATECALC_USAGE('Business_to_Standard($year,$week,$dow)') unless (@_ == 3);
    my($year,$week,$dow) = @_;
    my($month,$day);
    if (DateCalc_business_to_standard(\$year,\$month,\$day,$week,$dow))
    {
        return($year,$month,$day);
    }
    else { DATECALC_DATE_ERROR('Business_to_Standard'); }
}

sub Delta_Days
{
    DATECALC_USAGE('Delta_Days($year1,$month1,$day1,$year2,$month2,$day2)') unless (@_ == 6);
    my($year1,$month1,$day1,$year2,$month2,$day2) = @_;
    my($retval);
    if (DateCalc_check_date($year1,$month1,$day1) and
        DateCalc_check_date($year2,$month2,$day2))
    {
        $retval = DateCalc_Delta_Days($year1,$month1,$day1, $year2,$month2,$day2);
    }
    else { DATECALC_DATE_ERROR('Delta_Days'); }
    return $retval;
}

sub Delta_DHMS
{
    DATECALC_USAGE('Delta_DHMS($year1,$month1,$day1,$hour1,$min1,$sec1,$year2,$month2,$day2,$hour2,$min2,$sec2)') unless (@_ == 12);
    my($year1,$month1,$day1,$hour1,$min1,$sec1,$year2,$month2,$day2,$hour2,$min2,$sec2) = @_;
    my($Dd,$Dh,$Dm,$Ds);
    if (DateCalc_check_date($year1,$month1,$day1) and
        DateCalc_check_date($year2,$month2,$day2))
    {
        if (DateCalc_check_time($hour1,$min1,$sec1) and
            DateCalc_check_time($hour2,$min2,$sec2))
        {
            if (DateCalc_delta_dhms(\$Dd,\$Dh,\$Dm,\$Ds,
                                    $year1,$month1,$day1, $hour1,$min1,$sec1,
                                    $year2,$month2,$day2, $hour2,$min2,$sec2))
            {
                return($Dd,$Dh,$Dm,$Ds);
            }
            else { DATECALC_DATE_ERROR('Delta_DHMS'); }
        }
        else { DATECALC_TIME_ERROR('Delta_DHMS'); }
    }
    else { DATECALC_DATE_ERROR('Delta_DHMS'); }
}

sub Delta_YMD
{
    DATECALC_USAGE('Delta_YMD($year1,$month1,$day1,$year2,$month2,$day2)') unless (@_ == 6);
    my($year1,$month1,$day1,$year2,$month2,$day2) = @_;
    if (DateCalc_delta_ymd(\$year1,\$month1,\$day1, $year2,$month2,$day2))
    {
        return($year1,$month1,$day1);
    }
    else { DATECALC_DATE_ERROR('Delta_YMD'); }
}

sub Delta_YMDHMS
{
    DATECALC_USAGE('Delta_YMDHMS($year1,$month1,$day1,$hour1,$min1,$sec1,$year2,$month2,$day2,$hour2,$min2,$sec2)') unless (@_ == 12);
    my($year1,$month1,$day1,$hour1,$min1,$sec1,$year2,$month2,$day2,$hour2,$min2,$sec2) = @_;
    my($D_y,$D_m,$D_d,$Dh,$Dm,$Ds);
    if (DateCalc_check_date($year1,$month1,$day1) and
        DateCalc_check_date($year2,$month2,$day2))
    {
        if (DateCalc_check_time($hour1,$min1,$sec1) and
            DateCalc_check_time($hour2,$min2,$sec2))
        {
            if (DateCalc_delta_ymdhms(\$D_y,\$D_m,\$D_d,    \$Dh,\$Dm,\$Ds,
                                      $year1,$month1,$day1, $hour1,$min1,$sec1,
                                      $year2,$month2,$day2, $hour2,$min2,$sec2))
            {
                return($D_y,$D_m,$D_d,$Dh,$Dm,$Ds);
            }
            else { DATECALC_DATE_ERROR('Delta_YMDHMS'); }
        }
        else { DATECALC_TIME_ERROR('Delta_YMDHMS'); }
    }
    else { DATECALC_DATE_ERROR('Delta_YMDHMS'); }
}

sub N_Delta_YMD
{
    DATECALC_USAGE('N_Delta_YMD($year1,$month1,$day1,$year2,$month2,$day2)') unless (@_ == 6);
    my($year1,$month1,$day1,$year2,$month2,$day2) = @_;
    if (DateCalc_norm_delta_ymd(\$year1,\$month1,\$day1, $year2,$month2,$day2))
    {
        return($year1,$month1,$day1);
    }
    else { DATECALC_DATE_ERROR('N_Delta_YMD'); }
}

sub N_Delta_YMDHMS
{
    DATECALC_USAGE('N_Delta_YMDHMS($year1,$month1,$day1,$hour1,$min1,$sec1,$year2,$month2,$day2,$hour2,$min2,$sec2)') unless (@_ == 12);
    my($year1,$month1,$day1,$hour1,$min1,$sec1,$year2,$month2,$day2,$hour2,$min2,$sec2) = @_;
    my($D_y,$D_m,$D_d,$Dhh,$Dmm,$Dss);
    if (DateCalc_check_date($year1,$month1,$day1) and
        DateCalc_check_date($year2,$month2,$day2))
    {
        if (DateCalc_check_time($hour1,$min1,$sec1) and
            DateCalc_check_time($hour2,$min2,$sec2))
        {
            if (DateCalc_norm_delta_ymdhms(\$D_y,\$D_m,\$D_d,    \$Dhh,\$Dmm,\$Dss,
                                           $year1,$month1,$day1, $hour1,$min1,$sec1,
                                           $year2,$month2,$day2, $hour2,$min2,$sec2))
            {
                return($D_y,$D_m,$D_d,$Dhh,$Dmm,$Dss);
            }
            else { DATECALC_DATE_ERROR('N_Delta_YMDHMS'); }
        }
        else { DATECALC_TIME_ERROR('N_Delta_YMDHMS'); }
    }
    else { DATECALC_DATE_ERROR('N_Delta_YMDHMS'); }
}

sub Normalize_DHMS
{
    DATECALC_USAGE('Normalize_DHMS($Dd,$Dh,$Dm,$Ds)') unless (@_ == 4);
    my($Dd,$Dh,$Dm,$Ds) = @_;
    DateCalc_Normalize_DHMS(\$Dd,\$Dh,\$Dm,\$Ds);
    return($Dd,$Dh,$Dm,$Ds);
}

sub Add_Delta_Days
{
    DATECALC_USAGE('Add_Delta_Days($year,$month,$day,$Dd)') unless (@_ == 4);
    my($year,$month,$day,$Dd) = @_;
    if (DateCalc_add_delta_days(\$year,\$month,\$day, $Dd))
    {
        return($year,$month,$day);
    }
    else { DATECALC_DATE_ERROR('Add_Delta_Days'); }
}

sub Add_Delta_DHMS
{
    DATECALC_USAGE('Add_Delta_DHMS($year,$month,$day,$hour,$min,$sec,$Dd,$Dh,$Dm,$Ds)') unless (@_ == 10);
    my($year,$month,$day,$hour,$min,$sec,$Dd,$Dh,$Dm,$Ds) = @_;
    if (DateCalc_check_date($year,$month,$day))
    {
        if (DateCalc_check_time($hour,$min,$sec))
        {
            if (DateCalc_add_delta_dhms(\$year,\$month,\$day,
                                        \$hour,\$min,\$sec,
                                        $Dd,$Dh,$Dm,$Ds))
            {
                return($year,$month,$day,$hour,$min,$sec);
            }
            else { DATECALC_DATE_ERROR('Add_Delta_DHMS'); }
        }
        else { DATECALC_TIME_ERROR('Add_Delta_DHMS'); }
    }
    else { DATECALC_DATE_ERROR('Add_Delta_DHMS'); }
}

sub Add_Delta_YM
{
    DATECALC_USAGE('Add_Delta_YM($year,$month,$day,$Dy,$Dm)') unless (@_ == 5);
    my($year,$month,$day,$Dy,$Dm) = @_;
    if (DateCalc_add_delta_ym(\$year,\$month,\$day, $Dy,$Dm))
    {
        return($year,$month,$day);
    }
    else { DATECALC_DATE_ERROR('Add_Delta_YM'); }
}

sub Add_Delta_YMD
{
    DATECALC_USAGE('Add_Delta_YMD($year,$month,$day,$Dy,$Dm,$Dd)') unless (@_ == 6);
    my($year,$month,$day,$Dy,$Dm,$Dd) = @_;
    if (DateCalc_add_delta_ymd(\$year,\$month,\$day, $Dy,$Dm,$Dd))
    {
        return($year,$month,$day);
    }
    else { DATECALC_DATE_ERROR('Add_Delta_YMD'); }
}

sub Add_Delta_YMDHMS
{
    DATECALC_USAGE('Add_Delta_YMDHMS($year,$month,$day,$hour,$min,$sec,$D_y,$D_m,$D_d,$Dh,$Dm,$Ds)') unless (@_ == 12);
    my($year,$month,$day,$hour,$min,$sec,$D_y,$D_m,$D_d,$Dh,$Dm,$Ds) = @_;
    if (DateCalc_check_date($year,$month,$day))
    {
        if (DateCalc_check_time($hour,$min,$sec))
        {
            if (DateCalc_add_delta_ymdhms(\$year,\$month,\$day,
                                          \$hour,\$min,\$sec,
                                          $D_y,$D_m,$D_d,
                                          $Dh,$Dm,$Ds))
            {
                return($year,$month,$day,$hour,$min,$sec);
            }
            else { DATECALC_DATE_ERROR('Add_Delta_YMDHMS'); }
        }
        else { DATECALC_TIME_ERROR('Add_Delta_YMDHMS'); }
    }
    else { DATECALC_DATE_ERROR('Add_Delta_YMDnMS'); }
}

sub Add_N_Delta_YMD
{
    DATECALC_USAGE('Add_N_Delta_YMD($year,$month,$day,$Dy,$Dm,$Dd)') unless (@_ == 6);
    my($year,$month,$day,$Dy,$Dm,$Dd) = @_;
    if (DateCalc_add_norm_delta_ymd(\$year,\$month,\$day, $Dy,$Dm,$Dd))
    {
        return($year,$month,$day);
    }
    else { DATECALC_DATE_ERROR('Add_N_Delta_YMD'); }
}

sub Add_N_Delta_YMDHMS
{
    DATECALC_USAGE('Add_N_Delta_YMDHMS($year,$month,$day,$hour,$min,$sec,$D_y,$D_m,$D_d,$Dhh,$Dmm,$Dss)') unless (@_ == 12);
    my($year,$month,$day,$hour,$min,$sec,$D_y,$D_m,$D_d,$Dhh,$Dmm,$Dss) = @_;
    if (DateCalc_check_date($year,$month,$day))
    {
        if (DateCalc_check_time($hour,$min,$sec))
        {
            if (DateCalc_add_norm_delta_ymdhms(\$year,\$month,\$day,
                                               \$hour,\$min,\$sec,
                                               $D_y,$D_m,$D_d,
                                               $Dhh,$Dmm,$Dss))
            {
                return($year,$month,$day,$hour,$min,$sec);
            }
            else { DATECALC_DATE_ERROR('Add_N_Delta_YMDHMS'); }
        }
        else { DATECALC_TIME_ERROR('Add_N_Delta_YMDHMS'); }
    }
    else { DATECALC_DATE_ERROR('Add_N_Delta_YMDHMS'); }
}

sub System_Clock
{
    DATECALC_USAGE('System_Clock([$gmt])') unless ((@_ == 0) or (@_ == 1));
    my($year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst,$gmt);
    if (@_ == 1) { $gmt = shift; }
    else         { $gmt =     0; }
    if (DateCalc_system_clock(\$year,\$month,\$day,
                              \$hour,\$min,\$sec,
                              \$doy,\$dow,\$dst,
                              $gmt))
    {
        return($year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst);
    }
    else { DATECALC_SYSTEM_ERROR('System_Clock'); }
}

sub Today
{
    DATECALC_USAGE('Today([$gmt])') unless ((@_ == 0) or (@_ == 1));
    my($year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst,$gmt);
    if (@_ == 1) { $gmt = shift; }
    else         { $gmt =     0; }
    if (DateCalc_system_clock(\$year,\$month,\$day,
                              \$hour,\$min,\$sec,
                              \$doy,\$dow,\$dst,
                              $gmt))
    {
        return($year,$month,$day);
    }
    else { DATECALC_SYSTEM_ERROR('Today'); }
}

sub Now
{
    DATECALC_USAGE('Now([$gmt])') unless ((@_ == 0) or (@_ == 1));
    my($year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst,$gmt);
    if (@_ == 1) { $gmt = shift; }
    else         { $gmt =     0; }
    if (DateCalc_system_clock(\$year,\$month,\$day,
                              \$hour,\$min,\$sec,
                              \$doy,\$dow,\$dst,
                              $gmt))
    {
        return($hour,$min,$sec);
    }
    else { DATECALC_SYSTEM_ERROR('Now'); }
}

sub Today_and_Now
{
    DATECALC_USAGE('Today_and_Now([$gmt])') unless ((@_ == 0) or (@_ == 1));
    my($year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst,$gmt);
    if (@_ == 1) { $gmt = shift; }
    else         { $gmt =     0; }
    if (DateCalc_system_clock(\$year,\$month,\$day,
                              \$hour,\$min,\$sec,
                              \$doy,\$dow,\$dst,
                              $gmt))
    {
        return($year,$month,$day,$hour,$min,$sec);
    }
    else { DATECALC_SYSTEM_ERROR('Today_and_Now'); }
}

sub This_Year
{
    DATECALC_USAGE('This_Year([$gmt])') unless ((@_ == 0) or (@_ == 1));
    my($year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst,$gmt);
    if (@_ == 1) { $gmt = shift; }
    else         { $gmt =     0; }
    if (DateCalc_system_clock(\$year,\$month,\$day,
                              \$hour,\$min,\$sec,
                              \$doy,\$dow,\$dst,
                              $gmt))
    {
        return($year);
    }
    else { DATECALC_SYSTEM_ERROR('This_Year'); }
}

sub Gmtime
{
    DATECALC_USAGE('Gmtime([time])') unless ((@_ == 0) or (@_ == 1));
    my($seconds,$year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst);
    if (@_ == 1) { $seconds = shift; }
    else         { $seconds =  time; }
    if (($seconds < 0) or ($seconds > 0xFFFFFFFF)) { DATECALC_TIME_RANGE_ERROR('Gmtime'); }
    if (DateCalc_gmtime(\$year,\$month,\$day,
                        \$hour,\$min,\$sec,
                        \$doy,\$dow,\$dst,
                        $seconds))
    {
        return($year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst);
    }
    else { DATECALC_TIME_RANGE_ERROR('Gmtime'); }
}

sub Localtime
{
    DATECALC_USAGE('Localtime([time])') unless ((@_ == 0) or (@_ == 1));
    my($seconds,$year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst);
    if (@_ == 1) { $seconds = shift; }
    else         { $seconds =  time; }
    if (($seconds < 0) or ($seconds > 0xFFFFFFFF)) { DATECALC_TIME_RANGE_ERROR('Localtime'); }
    if (DateCalc_localtime(\$year,\$month,\$day,
                           \$hour,\$min,\$sec,
                           \$doy,\$dow,\$dst,
                           $seconds))
    {
        return($year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst);
    }
    else { DATECALC_TIME_RANGE_ERROR('Localtime'); }
}

sub Mktime
{
    DATECALC_USAGE('Mktime($year,$month,$day,$hour,$min,$sec)') unless (@_ == 6);
    my($year,$month,$day,$hour,$min,$sec) = @_;
    my($seconds);
    if (DateCalc_mktime(\$seconds, $year,$month,$day, $hour,$min,$sec, -1,-1,-1))
    {
        return $seconds;
    }
    else { DATECALC_DATE_RANGE_ERROR('Mktime'); }
}

sub Timezone
{
    DATECALC_USAGE('Timezone([time])') unless ((@_ == 0) or (@_ == 1));
    my($when,$year,$month,$day,$hour,$min,$sec,$dst);
    if (@_ == 1) { $when = shift; }
    else         { $when =  time; }
    if (($when < 0) or ($when > 0xFFFFFFFF)) { DATECALC_TIME_RANGE_ERROR('Timezone'); }
    if (DateCalc_timezone(\$year,\$month,\$day,
                          \$hour,\$min,\$sec,
                          \$dst,$when))
    {
        return($year,$month,$day,$hour,$min,$sec,$dst);
    }
    else { DATECALC_TIME_RANGE_ERROR('Timezone'); }
}

sub Date_to_Time
{
    DATECALC_USAGE('Date_to_Time($year,$month,$day,$hour,$min,$sec)') unless (@_ == 6);
    my($year,$month,$day,$hour,$min,$sec) = @_;
    my($seconds);
    if (DateCalc_date2time(\$seconds, $year,$month,$day, $hour,$min,$sec))
    {
        return $seconds;
    }
    else { DATECALC_DATE_RANGE_ERROR('Date_to_Time'); }
}

sub Time_to_Date
{
    DATECALC_USAGE('Time_to_Date([time])') unless ((@_ == 0) or (@_ == 1));
    my($seconds,$year,$month,$day,$hour,$min,$sec);
    if (@_ == 1) { $seconds = shift; }
    else         { $seconds =  time; }
    if (($seconds < 0) or ($seconds > 0xFFFFFFFF)) { DATECALC_TIME_RANGE_ERROR('Time_to_Date'); }
    if (DateCalc_time2date(\$year,\$month,\$day, \$hour,\$min,\$sec, $seconds))
    {
        return($year,$month,$day,$hour,$min,$sec);
    }
    else { DATECALC_TIME_RANGE_ERROR('Time_to_Date'); }
}

sub Easter_Sunday
{
    DATECALC_USAGE('Easter_Sunday($year)') unless (@_ == 1);
    my($year) = shift;
    my($month,$day);
    if (($year > 0) and DateCalc_easter_sunday(\$year,\$month,\$day))
    {
        return($year,$month,$day);
    }
    else { DATECALC_YEAR_ERROR('Easter_Sunday'); }
}

sub Decode_Month
{
    DATECALC_USAGE('Decode_Month($string[,$lang])') unless ((@_ == 1) or (@_ == 2));
    my($string) = shift;
    my($lang)   = shift || 0;
    return DateCalc_Decode_Month($string,$lang);
}

sub Decode_Day_of_Week
{
    DATECALC_USAGE('Decode_Day_of_Week($string[,$lang])') unless ((@_ == 1) or (@_ == 2));
    my($string) = shift;
    my($lang)   = shift || 0;
    return DateCalc_Decode_Day_of_Week($string,$lang);
}

sub Decode_Language
{
    DATECALC_USAGE('Decode_Language($string)') unless (@_ == 1);
    my($string) = shift;
    return DateCalc_Decode_Language($string);
}

sub Decode_Date_EU
{
    DATECALC_USAGE('Decode_Date_EU($string[,$lang])') unless ((@_ == 1) or (@_ == 2));
    my($string) = shift;
    my($lang)   = shift || 0;
    my($year,$month,$day);
    if (DateCalc_decode_date_eu($string,\$year,\$month,\$day,$lang))
    {
        return($year,$month,$day);
    }
    else { return(); }
}

sub Decode_Date_US
{
    DATECALC_USAGE('Decode_Date_US($string[,$lang])') unless ((@_ == 1) or (@_ == 2));
    my($string) = shift;
    my($lang)   = shift || 0;
    my($year,$month,$day);
    if (DateCalc_decode_date_us($string,\$year,\$month,\$day,$lang))
    {
        return($year,$month,$day);
    }
    else { return(); }
}

sub Fixed_Window
{
    DATECALC_USAGE('Fixed_Window($year)') unless (@_ == 1);
    my($year) = shift;
    return DateCalc_Fixed_Window($year);
}

sub Moving_Window
{
    DATECALC_USAGE('Moving_Window($year)') unless (@_ == 1);
    my($year) = shift;
    return DateCalc_Moving_Window($year);
}

sub Compress
{
    DATECALC_USAGE('Compress($year,$month,$day)') unless (@_ == 3);
    my($year,$month,$day) = @_;
    return DateCalc_Compress($year,$month,$day);
}

sub Uncompress
{
    DATECALC_USAGE('Uncompress($date)') unless (@_ == 1);
    my($date) = shift;
    my($century,$year,$month,$day);
    if (DateCalc_uncompress($date,\$century,\$year,\$month,\$day))
    {
        return($century,$year,$month,$day);
    }
    else { return(); }
}

sub check_compressed
{
    DATECALC_USAGE('check_compressed($date)') unless (@_ == 1);
    my($date) = shift;
    return DateCalc_check_compressed($date);
}

sub Compressed_to_Text
{
    DATECALC_USAGE('Compressed_to_Text($date[,$lang])') unless ((@_ == 1) or (@_ == 2));
    my($date) = shift;
    my($lang) = shift || 0;
    return DateCalc_Compressed_to_Text($date,$lang);
}

sub Date_to_Text
{
    DATECALC_USAGE('Date_to_Text($year,$month,$day[,$lang])') unless ((@_ == 3) or (@_ == 4));
    my($year)  = shift;
    my($month) = shift;
    my($day)   = shift;
    my($lang)  = shift || 0;
    if (DateCalc_check_date($year,$month,$day))
    {
        return DateCalc_Date_to_Text($year,$month,$day,$lang);
    }
    else { DATECALC_DATE_ERROR('Date_to_Text'); }
}

sub Date_to_Text_Long
{
    DATECALC_USAGE('Date_to_Text_Long($year,$month,$day[,$lang])') unless ((@_ == 3) or (@_ == 4));
    my($year)  = shift;
    my($month) = shift;
    my($day)   = shift;
    my($lang)  = shift || 0;
    if (DateCalc_check_date($year,$month,$day))
    {
        return DateCalc_Date_to_Text_Long($year,$month,$day,$lang);
    }
    else { DATECALC_DATE_ERROR('Date_to_Text_Long'); }
}

sub English_Ordinal
{
    DATECALC_USAGE('English_Ordinal($number)') unless (@_ == 1);
    my($number) = shift;
    return DateCalc_English_Ordinal($number);
}

sub Calendar
{
    DATECALC_USAGE('Calendar($year,$month[,$orthodox[,$lang]])') if ((@_ < 2) or (@_ > 4));
    my($year)  = shift;
    my($month) = shift;
    my($orthodox,$lang);
    if    (@_ == 2) { $orthodox = shift; $lang = shift; }
    elsif (@_ == 1) { $orthodox = shift; $lang =     0; }
    else            { $orthodox =     0; $lang =     0; }
    if ($year > 0)
    {
        if (($month >= 1) and ($month <= 12))
        {
            return DateCalc_Calendar($year,$month,$orthodox,$lang);
        }
        else { DATECALC_MONTH_ERROR('Calendar'); }
    }
    else { DATECALC_YEAR_ERROR('Calendar'); }
}

sub Month_to_Text
{
    DATECALC_USAGE('Month_to_Text($month[,$lang])') unless ((@_ == 1) or (@_ == 2));
    my($month) = shift;
    my($lang)  = shift || 0;
    if (($lang < 1) or ($lang > $DateCalc_LANGUAGES)) { $lang = $DateCalc_Language; }
    if (($month >= 1) and ($month <= 12))
    {
        return $DateCalc_Month_to_Text_[$lang][$month];
    }
    else { DATECALC_MONTH_ERROR('Month_to_Text'); }
}

sub Day_of_Week_to_Text
{
    DATECALC_USAGE('Day_of_Week_to_Text($dow[,$lang])') unless ((@_ == 1) or (@_ == 2));
    my($dow)  = shift;
    my($lang) = shift || 0;
    if (($lang < 1) or ($lang > $DateCalc_LANGUAGES)) { $lang = $DateCalc_Language; }
    if (($dow >= 1) and ($dow <= 7))
    {
        return $DateCalc_Day_of_Week_to_Text_[$lang][$dow];
    }
    else { DATECALC_DAYOFWEEK_ERROR('Day_of_Week_to_Text'); }
}

sub Day_of_Week_Abbreviation
{
    DATECALC_USAGE('Day_of_Week_Abbreviation($dow[,$lang])') unless ((@_ == 1) or (@_ == 2));
    my($dow)  = shift;
    my($lang) = shift || 0;
    if (($lang < 1) or ($lang > $DateCalc_LANGUAGES)) { $lang = $DateCalc_Language; }
    if (($dow >= 1) and ($dow <= 7))
    {
        if ($DateCalc_Day_of_Week_Abbreviation_[$lang][0] ne '')
        {
            return $DateCalc_Day_of_Week_Abbreviation_[$lang][$dow];
        }
        else
        {
            return substr($DateCalc_Day_of_Week_to_Text_[$lang][$dow],0,3);
        }
    }
    else { DATECALC_DAYOFWEEK_ERROR('Day_of_Week_Abbreviation'); }
}

sub Language_to_Text
{
    DATECALC_USAGE('Language_to_Text($lang)') unless (@_ == 1);
    my($lang) = shift;
    if (($lang >= 1) and ($lang <= $DateCalc_LANGUAGES))
    {
        return $DateCalc_Language_to_Text_[$lang];
    }
    else { DATECALC_LANGUAGE_ERROR('Language_to_Text'); }
}

sub Language
{
    DATECALC_USAGE('Language([$lang])') unless ((@_ == 0) or (@_ == 1));
    my($retval) = $DateCalc_Language;
    my($lang);
    if (@_ == 1)
    {
        $lang = shift || 0;
        if (($lang >= 1) and ($lang <= $DateCalc_LANGUAGES))
        {
            $DateCalc_Language = $lang;
        }
        else { DATECALC_LANGUAGE_ERROR('Language'); }
    }
    return $retval;
}

sub Languages
{
    DATECALC_USAGE('Languages()') unless (@_ == 0);
    return $DateCalc_LANGUAGES;
}

sub ISO_LC
{
    DATECALC_USAGE('ISO_LC($string)') unless (@_ == 1);
    my($string) = shift;
    $string =~ s!([\x41-\x5A\xC0-\xD6\xD8-\xDE])!chr(ord($1)+0x20)!ge;
    return $string;
}

sub ISO_UC
{
    DATECALC_USAGE('ISO_UC($string)') unless (@_ == 1);
    my($string) = shift;
    $string =~ s!([\x61-\x7A\xE0-\xF6\xF8-\xFE])!chr(ord($1)-0x20)!ge;
    return $string;
}

##################
##              ##
##  DateCalc.c  ##
##              ##
##################

########################
## Private functions: ##
########################

sub DateCalc_is_digit
{
    return 1 if ($_[0] =~ /^[0-9]+$/);
    return 0;
}

sub DateCalc_is_alnum
{
    return 1 if ($_[0] =~ /^[\x30-\x39\x41-\x5A\x61-\x7A\xC0-\xD6\xD8-\xF6\xF8-\xFF]+$/);
    return 0;
}

sub DateCalc_ISO_LC
{
    my($char) = $_[0];
    $char =~ s!([\x41-\x5A\xC0-\xD6\xD8-\xDE])!chr(ord($1)+0x20)!ge;
    return $char;
}

sub DateCalc_ISO_UC
{
    my($char) = $_[0];
    $char =~ s!([\x61-\x7A\xE0-\xF6\xF8-\xFE])!chr(ord($1)-0x20)!ge;
    return $char;
}

sub DateCalc_ISO_UC_First
{
    my($string) = $_[0];
    $string =~ s!([\x41-\x5A\xC0-\xD6\xD8-\xDE])!chr(ord($1)+0x20)!ge;
    $string =~ s!^([\x61-\x7A\xE0-\xF6\xF8-\xFE])!chr(ord($1)-0x20)!e;
    return $string;
}

sub DateCalc_Year_to_Days
{
    my($year) = $_[0];
    my($days) = $year * 365;
    $year >>= 2;
    $days += $year;
    $year = int($year / 25);
    $days -= $year;
    $days += ($year >>  2);
    return $days;
}

sub DateCalc_scan9
{   ## Mnemonic: COBOL "PIC 9" ##
    my($str,$buf,$len,$idx,$neg) = @_;
    $idx += $buf;
    $len += $buf;
    if (($idx >= 0) and ($idx < $len)) { return DateCalc_is_digit(substr($str,$idx,1)) ^ $neg; }
    return 0;
}

sub DateCalc_scanx
{   ## Mnemonic: COBOL "PIC X" ##
    my($str,$buf,$len,$idx,$neg) = @_;
    $idx += $buf;
    $len += $buf;
    if (($idx >= 0) and ($idx < $len)) { return DateCalc_is_alnum(substr($str,$idx,1)) ^ $neg; }
    return 0;
}

sub DateCalc_Center
{
    my($_target,$source,$width) = @_;
    my($length,$blank);
    $length = length($source);
    $length = $width if ($length > $width);
    $blank = $width - $length;
    $blank >>= 1;
    $$_target .= ' ' x $blank;
    $$_target .= substr($source,0,$length);
    $$_target .= "\n";
}

sub DateCalc_Blank
{
    my($_target,$count) = @_;
    $$_target .= ' ' x $count;
}

sub DateCalc_Newline
{
    my($_target,$count) = @_;
    $$_target .= "\n" x $count;
}

sub DateCalc_Normalize_Time
{
    my($_Dd,$_Dh,$_Dm,$_Ds) = @_;
    my($quot);
    $quot = int($$_Ds / 60);
    $$_Ds -= $quot * 60;
    $$_Dm += $quot;
    $quot = int($$_Dm / 60);
    $$_Dm -= $quot * 60;
    $$_Dh += $quot;
    $quot = int($$_Dh / 24);
    $$_Dh -= $quot * 24;
    $$_Dd += $quot;
}

## Prevent overflow errors on systems ##
## with short "long"s (e.g. 32 bits): ##

sub DateCalc_Normalize_Ranges
{
    my($_Dd,$_Dh,$_Dm,$_Ds) = @_;
    my($quot);
    $quot = int($$_Dh / 24);
    $$_Dh -= $quot * 24;
    $$_Dd += $quot;
    $quot = int($$_Dm / 60);
    $$_Dm -= $quot * 60;
    $$_Dh += $quot;
    DateCalc_Normalize_Time($_Dd,$_Dh,$_Dm,$_Ds);
}

# $_Dh and $_Dm are assumed to be empty;
# the whole time part must be in $_Ds:

sub DateCalc_Normalize_Signs
{
    my($_Dd,$_Dh,$_Dm,$_Ds) = @_;
    my($quot);
    $quot = int($$_Ds / 86400);
    $$_Ds -= $quot * 86400;
    $$_Dd += $quot;
    if ($$_Dd != 0)
    {
        if ($$_Dd > 0)
        {
            if ($$_Ds < 0)
            {
                $$_Ds += 86400;
                ${$_Dd}--;
            }
        }
        else
        {
            if ($$_Ds > 0)
            {
                $$_Ds -= 86400;
                ${$_Dd}++;
            }
        }
    }
    $$_Dh = 0;
    $$_Dm = 0;
    if ($$_Ds != 0) { DateCalc_Normalize_Time($_Dd,$_Dh,$_Dm,$_Ds); }
}

sub DateCalc_Normalize_DHMS
{
    my($_Dd,$_Dh,$_Dm,$_Ds) = @_;
    DateCalc_Normalize_Ranges($_Dd,$_Dh,$_Dm,$_Ds);
    $$_Ds += (($$_Dh * 60) + $$_Dm) * 60;
    DateCalc_Normalize_Signs($_Dd,$_Dh,$_Dm,$_Ds);
}

#######################
## Public functions: ##
#######################

sub DateCalc_leap_year
{
    my($year) = $_[0];
    my($yy);
    return( (($year & 0x03) == 0) and
            ( ((($yy = int($year / 100)) * 100) != $year) or
                (($yy & 0x03) == 0) ) );
}

sub DateCalc_check_date
{
    my($year,$month,$day) = @_;
    return 1 if
        (($year  >= 1) and
         ($month >= 1) and ($month <= 12) and
         ($day   >= 1) and
         ($day   <= $DateCalc_Days_in_Month_[DateCalc_leap_year($year)][$month]));
    return 0;
}

sub DateCalc_check_time
{
    my($hour,$min,$sec) = @_;
    return 1 if
        (($hour >= 0) and ($min >= 0) and ($sec >= 0) and
         ($hour < 24) and ($min < 60) and ($sec < 60));
    return 0;
}

sub DateCalc_check_business_date
{
    my($year,$week,$dow) = @_;
    return 1 if
        (($year >= 1) and
         ($week >= 1) and ($week <= DateCalc_Weeks_in_Year($year)) and
         ($dow  >= 1) and ($dow <= 7));
    return 0;
}

sub DateCalc_Day_of_Year
{
    my($year,$month,$day) = @_;
    my($leap);
    if (($year  >= 1) and
        ($month >= 1) and ($month <= 12) and
        ($day   >= 1) and
        ($day   <= $DateCalc_Days_in_Month_[($leap=DateCalc_leap_year($year))][$month]))
    {
        return $DateCalc_Days_in_Year_[$leap][$month] + $day;
    }
    return 0;
}

sub DateCalc_Date_to_Days
{
    my($year,$month,$day) = @_;
    my($leap);
    if (($year  >= 1) and
        ($month >= 1) and ($month <= 12) and
        ($day   >= 1) and
        ($day   <= $DateCalc_Days_in_Month_[($leap=DateCalc_leap_year($year))][$month]))
    {
        return DateCalc_Year_to_Days(--$year)
             + $DateCalc_Days_in_Year_[$leap][$month]
             + $day;
    }
    return 0;
}

sub DateCalc_Day_of_Week
{
    my($year,$month,$day) = @_;
    my($days);
    $days = DateCalc_Date_to_Days($year,$month,$day);
    if ($days > 0)
    {
        $days--;
        $days %= 7;
        $days++;
    }
    return $days;
}

sub DateCalc_Weeks_in_Year
{
    my($year) = $_[0];
    if ((DateCalc_Day_of_Week($year,1,1)   == 4) or
        (DateCalc_Day_of_Week($year,12,31) == 4))
        { return 53; }
    else
        { return 52; }
}

sub DateCalc_Week_Number
{
    my($year,$month,$day) = @_;
    my($first,$week);
    $first = DateCalc_Day_of_Week($year,1,1) - 1;
    $week = int((DateCalc_Delta_Days($year,1,1, $year,$month,$day) + $first) / 7);
    if ($first < 4) { return ++$week; }
    else            { return   $week; }
}

sub DateCalc_week_of_year
{
    my($_week,$_year,$month,$day) = @_;
    if (DateCalc_check_date($$_year,$month,$day))
    {
        $$_week = DateCalc_Week_Number($$_year,$month,$day);
        if ($$_week == 0) { $$_week = DateCalc_Weeks_in_Year(--${$_year}); }
        elsif ($$_week > DateCalc_Weeks_in_Year($$_year))
        {
            $$_week = 1;
            ${$_year}++;
        }
        return 1;
    }
    return 0;
}

sub DateCalc_monday_of_week
{
    my($week,$_year,$_month,$_day) = @_;
    my($first);
    $$_month = $$_day = 1;
    $first = DateCalc_Day_of_Week($$_year,1,1) - 1;
    $week-- if ($first < 4);
    return DateCalc_add_delta_days($_year,$_month,$_day, ($week * 7 - $first));
}

sub DateCalc_nth_weekday_of_month_year
{
    my($_year,$_month,$_day,$dow,$n) = @_;
    my($mm) = $$_month;
    my($first,$delta);
    $$_day = 1;
    return 0 if
        (($$_year < 1) or
         ($mm     < 1) or ($mm  > 12) or
         ($dow    < 1) or ($dow >  7) or
         ($n      < 1) or ($n   >  5));
    $first = DateCalc_Day_of_Week($$_year,$mm,1);
    $dow += 7 if ($dow < $first);
    $delta = $dow - $first;
    $delta += --$n * 7;
    return 1 if (DateCalc_add_delta_days($_year,$_month,$_day,$delta) and ($$_month == $mm));
    return 0;
}

sub DateCalc_standard_to_business
{
    my($_year,$_week,$_dow,$month,$day) = @_;
    my($yy) = $$_year;

    if (DateCalc_week_of_year($_week,$_year,$month,$day))
    {
        $$_dow = DateCalc_Day_of_Week($yy,$month,$day);
        return 1;
    }
    return 0;
}

sub DateCalc_business_to_standard
{
    my($_year,$_month,$_day,$week,$dow) = @_;
    my($first,$delta);
    if (DateCalc_check_business_date($$_year,$week,$dow))
    {
        $$_month = $$_day = 1;
        $first = DateCalc_Day_of_Week($$_year,1,1);
        $week++ if ($first > 4);
        $delta = --$week * 7 + $dow - $first;
        return DateCalc_add_delta_days($_year,$_month,$_day,$delta);
    }
    return 0;
}

sub DateCalc_Delta_Days
{
    return DateCalc_Date_to_Days(@_[3..5]) -
           DateCalc_Date_to_Days(@_[0..2]);
}

sub DateCalc_delta_hms
{
    my($_Dd,$_Dh,$_Dm,$_Ds,$hour1,$min1,$sec1,$hour2,$min2,$sec2) = @_;
    if (DateCalc_check_time($hour1,$min1,$sec1) and
        DateCalc_check_time($hour2,$min2,$sec2))
    {
        $$_Ds = (((($hour2 * 60) + $min2) * 60) + $sec2) -
                (((($hour1 * 60) + $min1) * 60) + $sec1);
        DateCalc_Normalize_Signs($_Dd,$_Dh,$_Dm,$_Ds);
        return 1;
    }
    return 0;
}

sub DateCalc_delta_dhms
{
    my($_Dd,$_Dh,$_Dm,$_Ds,$year1,$month1,$day1,$hour1,$min1,$sec1,$year2,$month2,$day2,$hour2,$min2,$sec2) = @_;
    $$_Dd = $$_Dh = $$_Dm = $$_Ds = 0;
    if (DateCalc_check_date($year1,$month1,$day1) and
        DateCalc_check_date($year2,$month2,$day2))
    {
        $$_Dd = DateCalc_Delta_Days($year1,$month1,$day1, $year2,$month2,$day2);
        return DateCalc_delta_hms($_Dd,$_Dh,$_Dm,$_Ds, $hour1,$min1,$sec1, $hour2,$min2,$sec2);
    }
    return 0;
}

sub DateCalc_delta_ymd
{
    my($_year1,$_month1,$_day1,$year2,$month2,$day2) = @_;
    if (DateCalc_check_date($$_year1,$$_month1,$$_day1) and
        DateCalc_check_date(  $year2,  $month2,  $day2))
    {
        $$_day1   = $day2   - $$_day1;
        $$_month1 = $month2 - $$_month1;
        $$_year1  = $year2  - $$_year1;
        return 1;
    }
    return 0;
}

sub DateCalc_delta_ymdhms
{
    my($_D_y,$_D_m,$_D_d,$_Dh,$_Dm,$_Ds,$year1,$month1,$day1,$hour1,$min1,$sec1,$year2,$month2,$day2,$hour2,$min2,$sec2) = @_;
    return 0 unless (DateCalc_delta_ymd(\$year1,\$month1,\$day1, $year2,$month2,$day2));
    $$_D_d = $day1;
    return 0 unless (DateCalc_delta_hms($_D_d,$_Dh,$_Dm,$_Ds, $hour1,$min1,$sec1, $hour2,$min2,$sec2));
    $$_D_y = $year1;
    $$_D_m = $month1;
    return 1;
}

sub DateCalc_norm_delta_ymd
{
    my($_year1,$_month1,$_day1,$year2,$month2,$day2) = @_;
    my($Dy) = 0;
    my($Dm) = 0;
    my($Dd) = 0;
    my($d2,$ty,$tm,$td);

    if (DateCalc_check_date($$_year1,$$_month1,$$_day1) and
        DateCalc_check_date(  $year2,  $month2,  $day2))
    {
        $d2 =     DateCalc_Date_to_Days(  $year2,  $month2,  $day2);
        $Dd = $d2-DateCalc_Date_to_Days($$_year1,$$_month1,$$_day1);
        if (($Dd < -30) or ($Dd > 30))
        {
            $Dy = ($year2  - $$_year1);
            $Dm = ($month2 - $$_month1);
            $ty=$$_year1; $tm=$$_month1; $td=$$_day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td);
            unless ((($Dy >= 0) and ($Dm >= 0) and ($Dd >= 0)) or
                    (($Dy <= 0) and ($Dm <= 0) and ($Dd <= 0)))
            {
                if    (($Dy < 0) and ($Dm > 0)) { $Dy++; $Dm -= 12; }
                elsif (($Dy > 0) and ($Dm < 0)) { $Dy--; $Dm += 12; }
                if    (($Dm < 0) and ($Dd > 0)) { $Dm++; $ty=$$_year1; $tm=$$_month1; $td=$$_day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
                elsif (($Dm > 0) and ($Dd < 0)) { $Dm--; $ty=$$_year1; $tm=$$_month1; $td=$$_day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
                if    (($Dy < 0) and ($Dd > 0)) { $Dy++; $Dm -= 12; }
                elsif (($Dy > 0) and ($Dd < 0)) { $Dy--; $Dm += 12; }
                if    (($Dm < 0) and ($Dd > 0)) { $Dm++; $ty=$$_year1; $tm=$$_month1; $td=$$_day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
                elsif (($Dm > 0) and ($Dd < 0)) { $Dm--; $ty=$$_year1; $tm=$$_month1; $td=$$_day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
            }
        }
        $$_year1  = $Dy;
        $$_month1 = $Dm;
        $$_day1   = $Dd;
        return 1;
    }
    return 0;
}

sub DateCalc_norm_delta_ymdhms
{
    my($_D_y,$_D_m,$_D_d,$_Dhh,$_Dmm,$_Dss,$year1,$month1,$day1,$hour1,$min1,$sec1,$year2,$month2,$day2,$hour2,$min2,$sec2) = @_;
    my($Dy) = 0;
    my($Dm) = 0;
    my($Dd) = 0;
    my($d2,$ty,$tm,$td,$hh,$mm,$ss);
    if (DateCalc_check_date($year1,$month1,$day1) and
        DateCalc_check_time($hour1,$min1,  $sec1) and
        DateCalc_check_date($year2,$month2,$day2) and
        DateCalc_check_time($hour1,$min2,  $sec2))
    {
        $ss = ( ($hour2-$hour1) * 60 + ($min2-$min1) ) * 60 + ($sec2-$sec1);
        $d2 =     DateCalc_Date_to_Days($year2,$month2,$day2);
        $Dd = $d2-DateCalc_Date_to_Days($year1,$month1,$day1);
        if (($Dd < -30) or ($Dd > 30))
        {
            $Dy = $year2  - $year1;
            $Dm = $month2 - $month1;
            $ty=$year1; $tm=$month1; $td=$day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td);
            unless ((($Dy >= 0) and ($Dm >= 0) and ($Dd >= 0) and ($ss >= 0)) or
                    (($Dy <= 0) and ($Dm <= 0) and ($Dd <= 0) and ($ss <= 0)))
            {
                if    (($Dy < 0) and ($Dm > 0)) { $Dy++; $Dm -= 12; }
                elsif (($Dy > 0) and ($Dm < 0)) { $Dy--; $Dm += 12; }
                if    (($Dm < 0) and ($Dd > 0)) { $Dm++; $ty=$year1; $tm=$month1; $td=$day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
                elsif (($Dm > 0) and ($Dd < 0)) { $Dm--; $ty=$year1; $tm=$month1; $td=$day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
                if    (($Dy < 0) and ($Dd > 0)) { $Dy++; $Dm -= 12; }
                elsif (($Dy > 0) and ($Dd < 0)) { $Dy--; $Dm += 12; }
                if    (($Dm < 0) and ($Dd > 0)) { $Dm++; $ty=$year1; $tm=$month1; $td=$day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
                elsif (($Dm > 0) and ($Dd < 0)) { $Dm--; $ty=$year1; $tm=$month1; $td=$day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
                if    (($Dd < 0) and ($ss > 0)) { $Dd++; $ss -= 86400; }
                elsif (($Dd > 0) and ($ss < 0)) { $Dd--; $ss += 86400; }
                if    (($Dm < 0) and ($ss > 0)) { $Dm++; $ty=$year1; $tm=$month1; $td=$day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
                elsif (($Dm > 0) and ($ss < 0)) { $Dm--; $ty=$year1; $tm=$month1; $td=$day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
                if    (($Dy < 0) and ($ss > 0)) { $Dy++; $Dm -= 12; }
                elsif (($Dy > 0) and ($ss < 0)) { $Dy--; $Dm += 12; }
                if    (($Dm < 0) and ($ss > 0)) { $Dm++; $ty=$year1; $tm=$month1; $td=$day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
                elsif (($Dm > 0) and ($ss < 0)) { $Dm--; $ty=$year1; $tm=$month1; $td=$day1; return 0 unless (DateCalc_add_delta_ym(\$ty,\$tm,\$td,$Dy,$Dm)); $Dd=$d2-DateCalc_Date_to_Days($ty,$tm,$td); }
                if    (($Dd < 0) and ($ss > 0)) { $Dd++; $ss -= 86400; }
                elsif (($Dd > 0) and ($ss < 0)) { $Dd--; $ss += 86400; }
            }
        }
        else
        {
            if    (($Dd < 0) and ($ss > 0)) { $Dd++; $ss -= 86400; }
            elsif (($Dd > 0) and ($ss < 0)) { $Dd--; $ss += 86400; }
        }
        $mm = int( $ss / 60 );
        $ss -= $mm * 60;
        $hh = int( $mm / 60 );
        $mm -= $hh * 60;
        $$_D_y = $Dy;
        $$_D_m = $Dm;
        $$_D_d = $Dd;
        $$_Dhh = $hh;
        $$_Dmm = $mm;
        $$_Dss = $ss;
        return 1;
    }
    return 0;
}

sub DateCalc_add_delta_days
{
    my($_year,$_month,$_day,$Dd) = @_;
    my($days,$leap);
    if ((($days = DateCalc_Date_to_Days($$_year,$$_month,$$_day)) > 0) and
        (($days += $Dd) > 0))
    {
        if ($Dd != 0)
        {
            $$_year = int( $days / 365.2425 );
            $$_day  = $days - DateCalc_Year_to_Days($$_year);
            if ($$_day < 1)
            {
                $$_day = $days - DateCalc_Year_to_Days($$_year-1);
            }
            else { ${$_year}++; }
            $leap = DateCalc_leap_year($$_year);
            if ($$_day > $DateCalc_Days_in_Year_[$leap][13])
            {
                $$_day -= $DateCalc_Days_in_Year_[$leap][13];
                $leap  = DateCalc_leap_year(++${$_year});
            }
            for ( $$_month = 12; $$_month >= 1; ${$_month}-- )
            {
                if ($$_day > $DateCalc_Days_in_Year_[$leap][$$_month])
                {
                    $$_day -= $DateCalc_Days_in_Year_[$leap][$$_month];
                    last;
                }
            }
        }
        return 1;
    }
    return 0;
}

sub DateCalc_add_delta_dhms
{
    my($_year,$_month,$_day,$_hour,$_min,$_sec,$Dd,$Dh,$Dm,$Ds) = @_;
    if (DateCalc_check_date($$_year,$$_month,$$_day) and
        DateCalc_check_time($$_hour,$$_min,  $$_sec))
    {
        DateCalc_Normalize_Ranges(\$Dd,\$Dh,\$Dm,\$Ds);
        $Ds += (((($$_hour * 60) + $$_min) * 60) + $$_sec) +
                (((  $Dh   * 60) +   $Dm)  * 60);
        while ($Ds < 0)
        {
            $Ds += 86400;
            $Dd--;
        }
        if ($Ds > 0)
        {
            $Dh = 0;
            $Dm = 0;
            DateCalc_Normalize_Time(\$Dd,\$Dh,\$Dm,\$Ds);
            $$_hour = $Dh;
            $$_min  = $Dm;
            $$_sec  = $Ds;
        }
        else { $$_hour = $$_min = $$_sec = 0; }
        return DateCalc_add_delta_days($_year,$_month,$_day,$Dd);
    }
    return 0;
}

sub DateCalc_add_year_month
{
    my($_year,$_month,$Dy,$Dm) = @_;
    my($quot);
    return 0 if (($$_year < 1) or ($$_month < 1) or ($$_month > 12));
    if ($Dm != 0)
    {
        $Dm  += $$_month - 1;
        $quot = int($Dm / 12);
        $Dm  -= $quot * 12;
        if ($Dm < 0)
        {
            $Dm += 12;
            $quot--;
        }
        $$_month = $Dm + 1;
        $Dy += $quot;
    }
    if ($Dy != 0)
    {
        $$_year += $Dy;
    }
    return 0 if ($$_year < 1);
    return 1;
}

sub DateCalc_add_delta_ym
{
    my($_year,$_month,$_day,$Dy,$Dm) = @_;
    my($Dd);
    return 0 unless (DateCalc_check_date($$_year,$$_month,$$_day));
    return 0 unless (DateCalc_add_year_month($_year,$_month,$Dy,$Dm));
    if ($$_day > ($Dd = $DateCalc_Days_in_Month_[DateCalc_leap_year($$_year)][$$_month]))
    {
        $$_day = $Dd;
    }
    return 1;
}

sub DateCalc_add_delta_ymd
{
    my($_year,$_month,$_day,$Dy,$Dm,$Dd) = @_;
    return 0 unless (DateCalc_check_date($$_year,$$_month,$$_day));
    return 0 unless (DateCalc_add_year_month($_year,$_month,$Dy,$Dm));
    $Dd += $$_day - 1;
    $$_day = 1;
    return DateCalc_add_delta_days($_year,$_month,$_day,$Dd);
}

sub DateCalc_add_delta_ymdhms
{
    my($_year,$_month,$_day,$_hour,$_min,$_sec,$D_y,$D_m,$D_d,$Dh,$Dm,$Ds) = @_;
    return 0 unless (DateCalc_check_date($$_year,$$_month,$$_day) and DateCalc_check_time($$_hour,$$_min,$$_sec));
    return 0 unless (DateCalc_add_year_month($_year,$_month,$D_y,$D_m));
    $D_d += $$_day - 1;
    $$_day = 1;
    return DateCalc_add_delta_dhms($_year,$_month,$_day,$_hour,$_min,$_sec,$D_d,$Dh,$Dm,$Ds);
}

sub DateCalc_add_norm_delta_ymd
{
    my($_year,$_month,$_day,$Dy,$Dm,$Dd) = @_;
    return 0 unless (DateCalc_add_delta_ym($_year,$_month,$_day,$Dy,$Dm));
    return DateCalc_add_delta_days($_year,$_month,$_day,$Dd);
}

sub DateCalc_add_norm_delta_ymdhms
{
    my($_year,$_month,$_day,$_hour,$_min,$_sec,$D_y,$D_m,$D_d,$Dh,$Dm,$Ds) = @_;
    return 0 unless (DateCalc_add_delta_ym($_year,$_month,$_day,$D_y,$D_m));
    return DateCalc_add_delta_dhms($_year,$_month,$_day,$_hour,$_min,$_sec,$D_d,$Dh,$Dm,$Ds);
}

sub DateCalc_system_clock
{
    my($_year,$_month,$_day,$_hour,$_min,$_sec,$_doy,$_dow,$_dst,$gmt) = @_;
    my($seconds) = time();
    if ($seconds >= 0)
    {
        $$_dst = 0;
        if ($gmt) { ($$_sec,$$_min,$$_hour,$$_day,$$_month,$$_year,$$_dow,$$_doy)        =    gmtime($seconds); }
        else      { ($$_sec,$$_min,$$_hour,$$_day,$$_month,$$_year,$$_dow,$$_doy,$$_dst) = localtime($seconds); }
        ${$_year} += 1900;
        ${$_month}++;
        ${$_dow} = 7 if (${$_dow} == 0);
        ${$_doy}++;
        if ($$_dst != 0)
        {
            if ($$_dst < 0) { $$_dst = -1; }
            else            { $$_dst =  1; }
        }
        return 1;
    }
    return 0;
}

sub DateCalc_gmtime
{
    my($_year,$_month,$_day,$_hour,$_min,$_sec,$_doy,$_dow,$_dst,$seconds) = @_;
    if ($seconds >= 0)
    {
        $$_dst = 0;
        ($$_sec,$$_min,$$_hour,$$_day,$$_month,$$_year,$$_dow,$$_doy) = gmtime($seconds);
        ${$_year} += 1900;
        ${$_month}++;
        ${$_dow} = 7 if (${$_dow} == 0);
        ${$_doy}++;
        return 1;
    }
    return 0;
}

sub DateCalc_localtime
{
    my($_year,$_month,$_day,$_hour,$_min,$_sec,$_doy,$_dow,$_dst,$seconds) = @_;
    if ($seconds >= 0)
    {
        ($$_sec,$$_min,$$_hour,$$_day,$$_month,$$_year,$$_dow,$$_doy,$$_dst) = localtime($seconds);
        ${$_year} += 1900;
        ${$_month}++;
        ${$_dow} = 7 if (${$_dow} == 0);
        ${$_doy}++;
        if ($$_dst != 0)
        {
            if ($$_dst < 0) { $$_dst = -1; }
            else            { $$_dst =  1; }
        }
        return 1;
    }
    return 0;
}

## MacOS (Classic):                                            ##
## <695056.0>     = Fri  1-Jan-1904 00:00:00 (time=0x00000000) ##
## <744766.23295> = Mon  6-Feb-2040 06:28:15 (time=0xFFFFFFFF) ##

## Unix:                                                       ##
## <719163.0>     = Thu  1-Jan-1970 00:00:00 (time=0x00000000) ##
## <744018.11647> = Tue 19-Jan-2038 03:14:07 (time=0x7FFFFFFF) ##

sub DateCalc_mktime
{
    my($_seconds,$year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst) = @_;
    my(@DT) =   ($year,$month,$day,$hour,$min,$sec); # needed for faking "mktime()"
    local($_);                                       # needed for faking "mktime()"
    $$_seconds = 0;
    if ($^O eq 'MacOS')
    {
        return 0 if
        (
            ($year  < 1904) or ($year  > 2040) or
            ($month <    1) or ($month >   12) or
            ($day   <    1) or ($day   >   31) or
            ($hour  <    0) or ($hour  >   23) or
            ($min   <    0) or ($min   >   59) or
            ($sec   <    0) or ($sec   >   59)
        );
        return 0 if
        (
            ($year == 2040) and ( ($month >  2) or
                                ( ($month == 2) and ( ($day >  6) or
                                                    ( ($day == 6) and ( ($hour >  6) or
                                                                      ( ($hour == 6) and ( ($min >  28) or
                                                                                         ( ($min == 28) and ($sec > 15) ) )))))))
        );
    }
    else
    {
        return 0 if
        (
            ($year  < 1970) or ($year  > 2038) or
            ($month <    1) or ($month >   12) or
            ($day   <    1) or ($day   >   31) or
            ($hour  <    0) or ($hour  >   23) or
            ($min   <    0) or ($min   >   59) or
            ($sec   <    0) or ($sec   >   59)
        );
        return 0 if
        (
            ($year == 2038) and ( ($month >  1) or
                                ( ($month == 1) and ( ($day >  19) or
                                                    ( ($day == 19) and ( ($hour >  3) or
                                                                       ( ($hour == 3) and ( ($min >  14) or
                                                                                          ( ($min == 14) and ($sec > 7) ) )))))))
        );
    }
    $year -= 1900;
    $month--;
    if ($doy <= 0) { $doy = -1; }
    else           { $doy--;    }
    if    ($dow <= 0) { $dow = -1; }
    elsif ($dow == 7) { $dow =  0; }
    if ($dst != 0)
    {
        if ($dst < 0) { $dst = -1; }
        else          { $dst =  1; }
    }
#   $$_seconds = mktime($year,$month,$day,$hour,$min,$sec,$doy,$dow,$dst);                         # "mktime()" is not implemented in Perl!
    $$_seconds = Date_to_Time(Add_Delta_YMDHMS(@DT,map(-$_,(Timezone(Date_to_Time(@DT)))[0..5]))); # Therefore we have to fake it ...
    return 1 if ($$_seconds >= 0);
    return 0;
}

sub DateCalc_timezone
{
    my($_year,$_month,$_day,$_hour,$_min,$_sec,$_dst,$when) = @_;
    my($year1,$month1,$day1,$hour1,$min1,$sec1,$year2,$month2,$day2,$hour2,$min2,$sec2);
    if ($when >= 0)
    {
        ($year1,$month1,$day1,$hour1,$min1,$sec1)        =    (gmtime($when))[5,4,3,2,1,0];
        $year1 += 1900;
        $month1++;
        ($year2,$month2,$day2,$hour2,$min2,$sec2,$$_dst) = (localtime($when))[5,4,3,2,1,0,8];
        $year2 += 1900;
        $month2++;
        if (DateCalc_delta_ymdhms($_year,$_month,$_day, $_hour,$_min,$_sec,
                                  $year1,$month1,$day1, $hour1,$min1,$sec1,
                                  $year2,$month2,$day2, $hour2,$min2,$sec2))
        {
            if ($$_dst != 0)
            {
                if ($$_dst < 0) { $$_dst = -1; }
                else            { $$_dst =  1; }
            }
            return 1;
        }
    }
    return 0;
}

## MacOS (Classic):                                            ##
## <695056.0>     = Fri  1-Jan-1904 00:00:00 (time=0x00000000) ##
## <744766.23295> = Mon  6-Feb-2040 06:28:15 (time=0xFFFFFFFF) ##

## Unix:                                                       ##
## <719163.0>     = Thu  1-Jan-1970 00:00:00 (time=0x00000000) ##
## <744018.11647> = Tue 19-Jan-2038 03:14:07 (time=0x7FFFFFFF) ##

#ifdef MACOS_TRADITIONAL
    #define DateCalc_DAYS_TO_EPOCH  695056
    #define DateCalc_DAYS_TO_OVFLW  744766
    #define DateCalc_SECS_TO_OVFLW   23295
#else
    #define DateCalc_DAYS_TO_EPOCH  719163
    #define DateCalc_DAYS_TO_OVFLW  744018
    #define DateCalc_SECS_TO_OVFLW   11647
#endif

## Substitute for BSD's timegm(3) function: ##

sub DateCalc_date2time
{
    my($_seconds,$year,$month,$day,$hour,$min,$sec) = @_;
    my($days,$secs);
    $$_seconds = 0;
    $days = DateCalc_Date_to_Days($year,$month,$day);
    $secs = ((($hour * 60) + $min) * 60) + $sec;
    return 0 if
    (
        ($days <  $DateCalc_DAYS_TO_EPOCH) or
        ($secs <  0)                       or
        ($days >  $DateCalc_DAYS_TO_OVFLW) or
        (
            ($days == $DateCalc_DAYS_TO_OVFLW) and
            ($secs >  $DateCalc_SECS_TO_OVFLW)
        )
    );
    $$_seconds = (($days - $DateCalc_DAYS_TO_EPOCH) * 86400) + $secs;
    return 1;
}

## Substitute for POSIX's gmtime(3) function: ##

sub DateCalc_time2date
{
    my($_year,$_month,$_day,$_hour,$_min,$_sec,$ss) = @_;
    my($mm,$hh,$dd);
    return 0 if ($ss < 0);
    $dd = int($ss / 86400);
    $ss -= $dd * 86400;
    $mm = int($ss / 60);
    $ss -= $mm * 60;
    $hh = int($mm / 60);
    $mm -= $hh * 60;
    $dd += $DateCalc_DAYS_TO_EPOCH-1;
    $$_sec   = $ss;
    $$_min   = $mm;
    $$_hour  = $hh;
    $$_day   = 1;
    $$_month = 1;
    $$_year  = 1;
    return DateCalc_add_delta_days($_year,$_month,$_day,$dd);
}

sub DateCalc_easter_sunday
{
    ##**************************************************************##
    ##                                                              ##
    ##  Gauss'sche Regel (Gaussian Rule)                            ##
    ##  ================================                            ##
    ##                                                              ##
    ##  Quelle / Source:                                            ##
    ##                                                              ##
    ##  H. H. Voigt, "Abriss der Astronomie", Wissenschaftsverlag,  ##
    ##  Bibliographisches Institut, Seite 9.                        ##
    ##                                                              ##
    ##**************************************************************##

    my($_year,$_month,$_day) = @_;
    my($a,$b,$c,$d,$e,$m,$n);

    return 0 if (($$_year < 1583) or ($$_year > 2299));

    if    ($$_year < 1700) { $m = 22; $n = 2; }
    elsif ($$_year < 1800) { $m = 23; $n = 3; }
    elsif ($$_year < 1900) { $m = 23; $n = 4; }
    elsif ($$_year < 2100) { $m = 24; $n = 5; }
    elsif ($$_year < 2200) { $m = 24; $n = 6; }
    else                   { $m = 25; $n = 0; }

    $a = $$_year % 19;
    $b = $$_year % 4;
    $c = $$_year % 7;
    $d = (19 * $a + $m) % 30;
    $e = (2 * $b + 4 * $c + 6 * $d + $n) % 7;
    $$_day = 22 + $d + $e;
    $$_month = 3;
    if ($$_day > 31)
    {
        $$_day -= 31; ## same as $$_day = $d + $e - 9; ##
        ${$_month}++;
    }
    $$_day = 19 if (($$_day == 26) and ($$_month == 4));
    $$_day = 18 if (($$_day == 25) and ($$_month == 4) and ($d == 28) and ($e == 6) and ($a > 10));
    return 1;
}

##  Carnival Monday / Rosenmontag / Veille du Mardi Gras   =  easter sunday - 48  ##
##  Mardi Gras / Karnevalsdienstag / Mardi Gras            =  easter sunday - 47  ##
##  Ash Wednesday / Aschermittwoch / Mercredi des Cendres  =  easter sunday - 46  ##
##  Palm Sunday / Palmsonntag / Dimanche des Rameaux       =  easter sunday - 7   ##
##  Easter Friday / Karfreitag / Vendredi Saint            =  easter sunday - 2   ##
##  Easter Saturday / Ostersamstag / Samedi de Paques      =  easter sunday - 1   ##
##  Easter Monday / Ostermontag / Lundi de Paques          =  easter sunday + 1   ##
##  Ascension of Christ / Christi Himmelfahrt / Ascension  =  easter sunday + 39  ##
##  Whitsunday / Pfingstsonntag / Dimanche de Pentecote    =  easter sunday + 49  ##
##  Whitmonday / Pfingstmontag / Lundi de Pentecote        =  easter sunday + 50  ##
##  Feast of Corpus Christi / Fronleichnam / Fete-Dieu     =  easter sunday + 60  ##

sub DateCalc_Decode_Month ## 0 = error ##
{
    my($string,$lang) = @_;
    my($length,$buffer,$month,$ok,$m);
    $lang = $DateCalc_Language if (($lang < 1) or ($lang > $DateCalc_LANGUAGES));
    $length = length($string);
    $buffer = DateCalc_ISO_UC($string);
    $month = 0;
    $ok = 0;
    MONTH:
    for ( $m = 1; $m <= 12; $m++ )
    {
        next MONTH if ($length > length($DateCalc_Month_to_Text_[$lang][$m]));
        next MONTH if (DateCalc_ISO_UC(substr($DateCalc_Month_to_Text_[$lang][$m],0,$length)) ne $buffer);
        if ($month > 0) { $ok = 0; last MONTH; }
        else            { $ok = 1; $month = $m; }
    }
    return $month if ($ok);
    return 0;
}

sub DateCalc_Decode_Day_of_Week ## 0 = error ##
{
    my($string,$lang) = @_;
    my($length,$buffer,$dow,$ok,$d);
    $lang = $DateCalc_Language if (($lang < 1) or ($lang > $DateCalc_LANGUAGES));
    $length = length($string);
    $buffer = DateCalc_ISO_UC($string);
    $dow = 0;
    $ok = 0;
    DAYOFWEEK:
    for ( $d = 1; $d <= 7; $d++ )
    {
        next DAYOFWEEK if ($length > length($DateCalc_Day_of_Week_to_Text_[$lang][$d]));
        next DAYOFWEEK if (DateCalc_ISO_UC(substr($DateCalc_Day_of_Week_to_Text_[$lang][$d],0,$length)) ne $buffer);
        if ($dow > 0) { $ok = 0; last DAYOFWEEK; }
        else          { $ok = 1; $dow = $d; }
    }
    return $dow if ($ok);
    return 0;
}

sub DateCalc_Decode_Language ## 0 = error ##
{
    my($string) = $_[0];
    my($length,$buffer,$lang,$ok,$l);
    $length = length($string);
    $buffer = DateCalc_ISO_UC($string);
    $lang = 0;
    $ok = 0;
    LANGUAGE:
    for ( $l = 1; $l <= $DateCalc_LANGUAGES; $l++ )
    {
        next LANGUAGE if ($length > length($DateCalc_Language_to_Text_[$l]));
        next LANGUAGE if (DateCalc_ISO_UC(substr($DateCalc_Language_to_Text_[$l],0,$length)) ne $buffer);
        if ($lang > 0) { $ok = 0; last LANGUAGE; }
        else           { $ok = 1; $lang = $l; }
    }
    return $lang if ($ok);
    return 0;
}

sub DateCalc_decode_date_eu
{
    my($string,$_year,$_month,$_day,$lang) = @_;
    my($length,$buffer,$i,$j);
    $lang = $DateCalc_Language if (($lang < 1) or ($lang > $DateCalc_LANGUAGES));
    $$_year = $$_month = $$_day = 0;
    return 0 unless ($length = length($string));
    $buffer = 0;
    $i = 0;
    while (DateCalc_scan9($string,$buffer,$length,$i,1)) { $i++; }
    $j = $length-1;
    while (DateCalc_scan9($string,$buffer,$length,$j,1)) { $j--; }
    if ($i+1 < $j)      ## at least 3 chars, else error! ##
    {
        $buffer += $i;
        $length = $j-$i+1;
        $i = 1;
        while (DateCalc_scan9($string,$buffer,$length,$i,0)) { $i++; }
        $j = $length-2;
        while (DateCalc_scan9($string,$buffer,$length,$j,0)) { $j--; }
        if ($j < $i)  ## only numerical chars without delimiters ##
        {
            if    ($length == 3)
            {
                $$_day   = substr($string,$buffer,  1);
                $$_month = substr($string,$buffer+1,1);
                $$_year  = substr($string,$buffer+2,1);
            }
            elsif ($length == 4)
            {
                $$_day   = substr($string,$buffer,  1);
                $$_month = substr($string,$buffer+1,1);
                $$_year  = substr($string,$buffer+2,2);
            }
            elsif ($length == 5)
            {
                $$_day   = substr($string,$buffer,  1);
                $$_month = substr($string,$buffer+1,2);
                $$_year  = substr($string,$buffer+3,2);
            }
            elsif ($length == 6)
            {
                $$_day   = substr($string,$buffer,  2);
                $$_month = substr($string,$buffer+2,2);
                $$_year  = substr($string,$buffer+4,2);
            }
            elsif ($length == 7)
            {
                $$_day   = substr($string,$buffer,  1);
                $$_month = substr($string,$buffer+1,2);
                $$_year  = substr($string,$buffer+3,4);
            }
            elsif ($length == 8)
            {
                $$_day   = substr($string,$buffer,  2);
                $$_month = substr($string,$buffer+2,2);
                $$_year  = substr($string,$buffer+4,4);
            }
            else { return 0; }
        }
        else        ## at least one non-numerical char (i <= j) ##
        {
            $$_day  = substr($string,$buffer,$i);
            $$_year = substr($string,$buffer+($j+1),$length-($j+1));
            while (DateCalc_scanx($string,$buffer,$length,$i,1)) { $i++; }
            while (DateCalc_scanx($string,$buffer,$length,$j,1)) { $j--; }
            if ($i <= $j)       ## at least one char left for month ##
            {
                $buffer += $i;
                $length = $j-$i+1;
                $i = 1;
                while (DateCalc_scanx($string,$buffer,$length,$i,0)) { $i++; }
                if ($i >= $length)  ## ok, no more delimiters ##
                {
                    $i = 0;
                    while (DateCalc_scan9($string,$buffer,$length,$i,0)) { $i++; }
                    if ($i >= $length) ## only digits for month ##
                    {
                        $$_month = substr($string,$buffer,$length);
                    }
                    else             ## match with month names ##
                    {
                        $$_month = DateCalc_Decode_Month(substr($string,$buffer,$length),$lang);
                    }
                }
                else { return 0; } ## delimiters inside month string ##
            }
            else { return 0; } ## no chars left for month ##
        }           ## at least one non-numerical char (i <= j) ##
    }
    else { return 0; } ## less than 3 chars in buffer ##
    $$_year = DateCalc_Moving_Window($$_year);
    return DateCalc_check_date($$_year,$$_month,$$_day);
}

sub DateCalc_decode_date_us
{
    my($string,$_year,$_month,$_day,$lang) = @_;
    my($length,$buffer,$i,$j,$k);
    $lang = $DateCalc_Language if (($lang < 1) or ($lang > $DateCalc_LANGUAGES));

    $$_year = $$_month = $$_day = 0;
    return 0 unless ($length = length($string));
    {
        $buffer = 0;
        $i = 0;
        while (DateCalc_scanx($string,$buffer,$length,$i,1)) { $i++; }
        $j = $length-1;
        while (DateCalc_scan9($string,$buffer,$length,$j,1)) { $j--; }
        if ($i+1 < $j)      ## at least 3 chars, else error! ##
        {
            $buffer += $i;
            $length = $j-$i+1;
            $i = 1;
            while (DateCalc_scanx($string,$buffer,$length,$i,0)) { $i++; }
            $j = $length-2;
            while (DateCalc_scan9($string,$buffer,$length,$j,0)) { $j--; }
            if ($i >= $length)  ## only alphanumeric chars left ##
            {
                if ($j < 0) ## case 0 : xxxx999999xxxx ##
                {           ##             j0     i    ##
                    if    ($length == 3)
                    {
                        $$_month = substr($string,$buffer,  1);
                        $$_day   = substr($string,$buffer+1,1);
                        $$_year  = substr($string,$buffer+2,1);
                    }
                    elsif ($length == 4)
                    {
                        $$_month = substr($string,$buffer,  1);
                        $$_day   = substr($string,$buffer+1,1);
                        $$_year  = substr($string,$buffer+2,2);
                    }
                    elsif ($length == 5)
                    {
                        $$_month = substr($string,$buffer,  1);
                        $$_day   = substr($string,$buffer+1,2);
                        $$_year  = substr($string,$buffer+3,2);
                    }
                    elsif ($length == 6)
                    {
                        $$_month = substr($string,$buffer,  2);
                        $$_day   = substr($string,$buffer+2,2);
                        $$_year  = substr($string,$buffer+4,2);
                    }
                    elsif ($length == 7)
                    {
                        $$_month = substr($string,$buffer,  1);
                        $$_day   = substr($string,$buffer+1,2);
                        $$_year  = substr($string,$buffer+3,4);
                    }
                    elsif ($length == 8)
                    {
                        $$_month = substr($string,$buffer,  2);
                        $$_day   = substr($string,$buffer+2,2);
                        $$_year  = substr($string,$buffer+4,4);
                    }
                    else { return 0; }
                }
                else        ## case 1 : xxxxAAA999999xxxx ##
                {           ##              0 j      i    ##
                    $$_month = DateCalc_Decode_Month(substr($string,$buffer,$j+1),$lang);
                    $buffer += $j+1;
                    $length -= $j+1;
                    if    ($length == 2)
                    {
                        $$_day  = substr($string,$buffer,  1);
                        $$_year = substr($string,$buffer+1,1);
                    }
                    elsif ($length == 3)
                    {
                        $$_day  = substr($string,$buffer,  1);
                        $$_year = substr($string,$buffer+1,2);
                    }
                    elsif ($length == 4)
                    {
                        $$_day  = substr($string,$buffer,  2);
                        $$_year = substr($string,$buffer+2,2);
                    }
                    elsif ($length == 5)
                    {
                        $$_day  = substr($string,$buffer,  1);
                        $$_year = substr($string,$buffer+1,4);
                    }
                    elsif ($length == 6)
                    {
                        $$_day  = substr($string,$buffer,  2);
                        $$_year = substr($string,$buffer+2,4);
                    }
                    else { return 0; }
                }
            }              ##              0  i  j    l         ##
            else           ## case 2 : xxxxAAAxxxx9999xxxx _OR_ ##
            {              ## case 3 : xxxxAAAxx99xx9999xx      ##
                $k = 0;    ##              0  i    j    l       ##
                while (DateCalc_scan9($string,$buffer,$length,$k,0)) { $k++; }
                if ($k >= $i) ## ok, only digits ##
                {
                    $$_month = substr($string,$buffer,$i);
                }
                else          ## no, some non-digits ##
                {
                    $$_month = DateCalc_Decode_Month(substr($string,$buffer,$i),$lang);
                    if ($$_month == 0) { return 0; }
                }
                $buffer += $i;
                $length -= $i;
                $j -= $i;
                $k = $j+1; ## remember start position of day+year(2)/year(3) ##
                $i = 1;
                while (DateCalc_scanx($string,$buffer,$length,$i,1)) { $i++; }
                $j--;
                while (DateCalc_scan9($string,$buffer,$length,$j,1)) { $j--; }
                if ($j < $i) ## case 2 : xxxxAAAxxxx9999xxxx ##
                {            ##                j0   i   l    ##
                    $buffer += $k;    ##            k        ##
                    $length -= $k;
                    if    ($length == 2)
                    {
                        $$_day  = substr($string,$buffer,  1);
                        $$_year = substr($string,$buffer+1,1);
                    }
                    elsif ($length == 3)
                    {
                        $$_day  = substr($string,$buffer,  1);
                        $$_year = substr($string,$buffer+1,2);
                    }
                    elsif ($length == 4)
                    {
                        $$_day  = substr($string,$buffer,  2);
                        $$_year = substr($string,$buffer+2,2);
                    }
                    elsif ($length == 5)
                    {
                        $$_day  = substr($string,$buffer,  1);
                        $$_year = substr($string,$buffer+1,4);
                    }
                    elsif ($length == 6)
                    {
                        $$_day  = substr($string,$buffer,  2);
                        $$_year = substr($string,$buffer+2,4);
                    }
                    else { return 0; }
                }
                else       ## case 3 : xxxxAAAxx99xx9999xx ##
                {          ##                 0 ij  k   l  ##
                    $$_year = substr($string,$buffer+$k,$length-$k);
                    $k = $i;
                    while (DateCalc_scan9($string,$buffer,$length,$k,0)) { $k++; }
                    if ($k > $j)       ## ok, only digits ##
                    {
                        $$_day = substr($string,$buffer+$i,$j-$i+1);
                    }
                    else { return 0; } ## non-digits inside day ##
                }
            }                 ## i < length ##
        }
        else { return 0; } ## less than 3 chars in buffer ##
    }
    $$_year = DateCalc_Moving_Window($$_year);
    return DateCalc_check_date($$_year,$$_month,$$_day);
}

sub DateCalc_Fixed_Window
{
    my($year) = $_[0];
    return 0 if ($year < 0);
    if ($year < 100)
    {
        $year += 100 if ($year < $DateCalc_YEAR_OF_EPOCH);
        $year += $DateCalc_CENTURY_OF_EPOCH;
    }
    return $year;
}

sub DateCalc_Moving_Window
{
    my($year) = $_[0];
    my($seconds,$current,$century);
    return 0 if ($year < 0);
    if ($year < 100)
    {
        if (($seconds = time()) >= 0)
        {
            $current = (gmtime($seconds))[5] + 1900;
            $century = int($current / 100);
            $year += $century * 100;
            if    ($year <  $current - 50) { $year += 100; }
            elsif ($year >= $current + 50) { $year -= 100; }
        }
        else { $year = DateCalc_Fixed_Window($year); }
    }
    return $year;
}

sub DateCalc_Compress
{
    my($year,$month,$day) = @_;
    my($yy);
    if (($year >= $DateCalc_EPOCH) and ($year < ($DateCalc_EPOCH + 100)))
    {
        $yy = $year;
        $year -= $DateCalc_EPOCH;
    }
    else
    {
        return 0 if (($year < 0) or ($year > 99));
        if ($year < $DateCalc_YEAR_OF_EPOCH)
        {
            $yy = $DateCalc_CENTURY_OF_EPOCH + 100 + $year;
            $year += 100 - $DateCalc_YEAR_OF_EPOCH;
        }
        else
        {
            $yy = $DateCalc_CENTURY_OF_EPOCH + $year;
            $year -= $DateCalc_YEAR_OF_EPOCH;
        }
    }
    return 0 if (($month < 1) or ($month > 12));
    return 0 if
        (($day < 1) or
         ($day > $DateCalc_Days_in_Month_[DateCalc_leap_year($yy)][$month]));
    return ($year << 9) | ($month << 5) | $day;
}

sub DateCalc_uncompress
{
    my($date,$_century,$_year,$_month,$_day) = @_;
    if ($date > 0)
    {
        $$_year  =  $date >> 9;
        $$_month = ($date & 0x01FF) >> 5;
        $$_day   =  $date & 0x001F;
        if ($$_year < 100)
        {
            if ($$_year < 100-$DateCalc_YEAR_OF_EPOCH)
            {
                $$_century = $DateCalc_CENTURY_OF_EPOCH;
                $$_year += $DateCalc_YEAR_OF_EPOCH;
            }
            else
            {
                $$_century = $DateCalc_CENTURY_OF_EPOCH+100;
                $$_year -= 100-$DateCalc_YEAR_OF_EPOCH;
            }
            return DateCalc_check_date($$_century+$$_year,$$_month,$$_day);
        }
    }
    return 0;
}

sub DateCalc_check_compressed
{
    my($century,$year,$month,$day);
    return DateCalc_uncompress($_[0],\$century,\$year,\$month,\$day);
}

sub DateCalc_Compressed_to_Text
{
    my($date,$lang) = @_;
    my($century,$year,$month,$day,$string);
    $lang = $DateCalc_Language if (($lang < 1) or ($lang > $DateCalc_LANGUAGES));
    if (DateCalc_uncompress($date,\$century,\$year,\$month,\$day))
    {
        $string = sprintf("%02d-%.3s-%02d",$day,$DateCalc_Month_to_Text_[$lang][$month],$year);
    }
    else { $string = '??-???-??'; }
    return $string;
}

sub DateCalc_Date_to_Text
{
    my($year,$month,$day,$lang) = @_;
    $lang = $DateCalc_Language if (($lang < 1) or ($lang > $DateCalc_LANGUAGES));
    if (DateCalc_check_date($year,$month,$day))
    {
        if ($DateCalc_Day_of_Week_Abbreviation_[$lang][0] ne '')
        {
            return sprintf("%.3s %d-%.3s-%d",
                $DateCalc_Day_of_Week_Abbreviation_[$lang][DateCalc_Day_of_Week($year,$month,$day)],
                $day,$DateCalc_Month_to_Text_[$lang][$month],$year);
        }
        else
        {
            return sprintf("%.3s %d-%.3s-%d",
                $DateCalc_Day_of_Week_to_Text_[$lang][DateCalc_Day_of_Week($year,$month,$day)],
                $day,$DateCalc_Month_to_Text_[$lang][$month],$year);
        }
    }
    return undef;
}

sub DateCalc_English_Ordinal
{
    my($result) = "$_[0]";
    my($length,$digit);
    if (($length = length($result)) > 0)
    {
        $digit = 0 unless
        (
            ( (($length > 1) and (substr($result,$length-2,1) ne '1')) or ($length == 1) )
            and
            ( ($digit = substr($result,$length-1,1)) <= 3 )
        );
        $result .= $DateCalc_English_Ordinals_[$digit];
    }
    return $result;
}

sub DateCalc_Date_to_Text_Long
{
    my($year,$month,$day,$lang) = @_;
    my($string,$buffer);
    $lang = $DateCalc_Language if (($lang < 1) or ($lang > $DateCalc_LANGUAGES));
    if (DateCalc_check_date($year,$month,$day))
    {
        if    ($lang == 1)
        {
            return sprintf
            (
                $DateCalc_Date_Long_Format_[$lang],
                $DateCalc_Day_of_Week_to_Text_[$lang]
                    [DateCalc_Day_of_Week($year,$month,$day)],
                $DateCalc_Month_to_Text_[$lang][$month],
                DateCalc_English_Ordinal($day),
                $year
            );
        }
        elsif ($lang == 12)
        {
            return sprintf
            (
                $DateCalc_Date_Long_Format_[$lang],
                $year,
                $DateCalc_Month_to_Text_[$lang][$month],
                $day,
                $DateCalc_Day_of_Week_to_Text_[$lang]
                    [DateCalc_Day_of_Week($year,$month,$day)]
            );
        }
        else
        {
            return sprintf
            (
                $DateCalc_Date_Long_Format_[$lang],
                $DateCalc_Day_of_Week_to_Text_[$lang]
                    [DateCalc_Day_of_Week($year,$month,$day)],
                $day,
                $DateCalc_Month_to_Text_[$lang][$month],
                $year
            );
        }
    }
    return undef;
}

sub DateCalc_Calendar
{
    my($year,$month,$orthodox,$lang) = @_;
    my($string,$cursor,$buffer,$first,$last,$day);
    if (($lang < 1) or ($lang > $DateCalc_LANGUAGES)) { $lang = $DateCalc_Language; }
    $string = '';
    $cursor = \$string;
    DateCalc_Newline($cursor,1);
    $buffer = sprintf("%s %d", DateCalc_ISO_UC_First($DateCalc_Month_to_Text_[$lang][$month]), $year);
    DateCalc_Center($cursor,$buffer,27);
    if ($DateCalc_Day_of_Week_Abbreviation_[$lang][0] ne '')
    {
        if ($orthodox)
        {
            $string .= sprintf("%3.3s %3.3s %3.3s %3.3s %3.3s %3.3s %3.3s\n",
                $DateCalc_Day_of_Week_Abbreviation_[$lang][7],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][1],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][2],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][3],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][4],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][5],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][6]);
        }
        else ## conform to ISO standard ##
        {
            $string .= sprintf("%3.3s %3.3s %3.3s %3.3s %3.3s %3.3s %3.3s\n",
                $DateCalc_Day_of_Week_Abbreviation_[$lang][1],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][2],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][3],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][4],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][5],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][6],
                $DateCalc_Day_of_Week_Abbreviation_[$lang][7]);
        }
    }
    else
    {
        if ($orthodox)
        {
            $string .= sprintf("%3.3s %3.3s %3.3s %3.3s %3.3s %3.3s %3.3s\n",
                $DateCalc_Day_of_Week_to_Text_[$lang][7],
                $DateCalc_Day_of_Week_to_Text_[$lang][1],
                $DateCalc_Day_of_Week_to_Text_[$lang][2],
                $DateCalc_Day_of_Week_to_Text_[$lang][3],
                $DateCalc_Day_of_Week_to_Text_[$lang][4],
                $DateCalc_Day_of_Week_to_Text_[$lang][5],
                $DateCalc_Day_of_Week_to_Text_[$lang][6]);
        }
        else ## conform to ISO standard ##
        {
            $string .= sprintf("%3.3s %3.3s %3.3s %3.3s %3.3s %3.3s %3.3s\n",
                $DateCalc_Day_of_Week_to_Text_[$lang][1],
                $DateCalc_Day_of_Week_to_Text_[$lang][2],
                $DateCalc_Day_of_Week_to_Text_[$lang][3],
                $DateCalc_Day_of_Week_to_Text_[$lang][4],
                $DateCalc_Day_of_Week_to_Text_[$lang][5],
                $DateCalc_Day_of_Week_to_Text_[$lang][6],
                $DateCalc_Day_of_Week_to_Text_[$lang][7]);
        }
    }
    $first = DateCalc_Day_of_Week($year,$month,1);
    $last = $DateCalc_Days_in_Month_[DateCalc_leap_year($year)][$month];
    if ($orthodox) { $first = 0 if ($first == 7); }
    else           { $first--; }
    if ($first) { DateCalc_Blank($cursor,($first<<2)-1); }
    for ( $day = 1; $day <= $last; $day++, $first++ )
    {
        if ($first > 0)
        {
            if ($first > 6)
            {
                $first = 0;
                DateCalc_Newline($cursor,1);
            }
            else { DateCalc_Blank($cursor,1); }
        }
        $string .= sprintf(" %2d",$day);
    }
    DateCalc_Newline($cursor,2);
    return $string;
}

###############
##           ##
##  Calc.pm  ##
##           ##
###############

sub Decode_Date_EU2
{
    die "Usage: (\$year,\$month,\$day) = Decode_Date_EU2(\$date[,\$lang]);\n"
      unless ((@_ == 1) or (@_ == 2));

    my($buffer) = shift;
    my($lang)   = shift || 0;
    my($year,$month,$day,$length);

    $lang = Language() unless (($lang >= 1) and ($lang <= Languages()));
    if ($buffer =~ /^\D*  (\d+)  [^A-Za-z0-9\xC0-\xD6\xD8-\xF6\xF8-\xFF]*  ([A-Za-z\xC0-\xD6\xD8-\xF6\xF8-\xFF]+)  [^A-Za-z0-9\xC0-\xD6\xD8-\xF6\xF8-\xFF]*  (\d+)  \D*$/x)
    {
        ($day,$month,$year) = ($1,$2,$3);
        $month = Decode_Month($month,$lang);
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
    $year = Moving_Window($year);
    if (check_date($year,$month,$day))
    {
        return($year,$month,$day);
    }
    else { return(); } # not a valid date!
}

sub Decode_Date_US2
{
    die "Usage: (\$year,\$month,\$day) = Decode_Date_US2(\$date[,\$lang]);\n"
      unless ((@_ == 1) or (@_ == 2));

    my($buffer) = shift;
    my($lang)   = shift || 0;
    my($year,$month,$day,$length);

    $lang = Language() unless (($lang >= 1) and ($lang <= Languages()));
    if ($buffer =~ /^[^A-Za-z0-9\xC0-\xD6\xD8-\xF6\xF8-\xFF]*  ([A-Za-z\xC0-\xD6\xD8-\xF6\xF8-\xFF]+)  [^A-Za-z0-9\xC0-\xD6\xD8-\xF6\xF8-\xFF]*  0*(\d+)  \D*$/x)
    {
        ($month,$buffer) = ($1,$2);
        $month = Decode_Month($month,$lang);
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
    elsif ($buffer =~ /^[^A-Za-z0-9\xC0-\xD6\xD8-\xF6\xF8-\xFF]*  ([A-Za-z\xC0-\xD6\xD8-\xF6\xF8-\xFF]+)  [^A-Za-z0-9\xC0-\xD6\xD8-\xF6\xF8-\xFF]*  (\d+)  \D+  (\d+)  \D*$/x)
    {
        ($month,$day,$year) = ($1,$2,$3);
        $month = Decode_Month($month,$lang);
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
    $year = Moving_Window($year);
    if (check_date($year,$month,$day))
    {
        return($year,$month,$day);
    }
    else { return(); } # not a valid date!
}

sub Parse_Date
{
    die "Usage: (\$year,\$month,\$day) = Parse_Date(\$date[,\$lang]);\n"
      unless ((@_ == 1) or (@_ == 2));

    my($date) = shift;
    my($lang) = shift || 0;
    my($year,$month,$day);

    $lang = Language() unless (($lang >= 1) and ($lang <= Languages()));
    unless ($date =~ /\b([\x41-\x5A\x61-\x7A\xC0-\xD6\xD8-\xF6\xF8-\xFF]{3})\s+([0123]??\d)\b/)
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
    $month = Decode_Month($month,$lang);
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

1;

__END__

