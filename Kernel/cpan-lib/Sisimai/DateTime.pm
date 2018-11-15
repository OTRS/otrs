package Sisimai::DateTime;
use feature ':5.10';
use strict;
use warnings;
use Time::Piece;

sub BASE_D()    { 86400 }           # 1 day = 86400 sec
sub BASE_Y()    { 365.2425 }        # 1 year = 365.2425 days
sub BASE_L()    { 29.53059 }        # 1 lunar month = 29.53059 days
sub CONST_P()   { 4 * atan2(1,1) }  # PI, 3.1415926535
sub CONST_E()   { exp(1) }          # e, Napier's constant
sub TZ_OFFSET() { 54000 }           # Max time zone offset, 54000 seconds

my $TimeUnit = {
    'o' => ( BASE_D * BASE_Y * 4 ), # Olympiad, 4 years
    'y' => ( BASE_D * BASE_Y ),     # Year, Gregorian Calendar
    'q' => ( BASE_D * BASE_Y / 4 ), # Quarter, year/4
    'l' => ( BASE_D * BASE_L ),     # Lunar month
    'f' => ( BASE_D * 14 ),         # Fortnight, 2 weeks
    'w' => ( BASE_D * 7 ),          # Week, 604800 seconds
    'd' => BASE_D,                  # Day
    'h' => 3600,                    # Hour
    'b' => 86.4,                    # Beat, Swatch internet time: 1000b = 1d
    'm' => 60,                      # Minute,
    's' => 1,                       # Second
};
my $MathematicalConstant = {
    'e' => CONST_E,
    'p' => CONST_P,
    'g' => CONST_E ** CONST_P,
};

my $MonthName = {
    'full' => [qw|January February March April May June July August September October November December|],
    'abbr' => [qw|Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec|],
};

my $DayOfWeek = {
    'full' => [qw|Sunday Monday Tuesday Wednesday Thursday Friday Saturday|],
    'abbr' => [qw|Sun Mon Tue Wed Thu Fri Sat|],
};

my $HourName = {
    'full' => [qw|Midnight 1 2 3 4 5 Morning 7 8 9 10 11 Noon 13 14 15 16 17 Evening 19 20 21 22 23|],
    'abbr' => [0..23],
};

my $TimeZoneAbbr = {
    # http://en.wikipedia.org/wiki/List_of_time_zone_abbreviations
    #'ACDT' => '+1030', # Australian Central Daylight Time  UTC+10:30
    #'ACST' => '+0930', # Australian Central Standard Time  UTC+09:30
    #'ACT'  => '+0800', # ASEAN Common Time                 UTC+08:00
    'ADT'   => '-0300', # Atlantic Daylight Time            UTC-03:00
    #'AEDT' => '+1100', # Australian Eastern Daylight Time  UTC+11:00
    #'AEST' => '+1000', # Australian Eastern Standard Time  UTC+10:00
    #'AFT'  => '+0430', # Afghanistan Time                  UTC+04:30
    'AKDT'  => '-0800', # Alaska Daylight Time              UTC-08:00
    'AKST'  => '-0900', # Alaska Standard Time              UTC-09:00
    #'AMST' => '+0500', # Armenia Summer Time               UTC+05:00
    #'AMT'  => '+0400', # Armenia Time                      UTC+04:00
    #'ART'  => '-0300', # Argentina Time                    UTC+03:00
    #'AST'  => '+0300', # Arab Standard Time (Kuwait, Riyadh)       UTC+03:00
    #'AST'  => '+0400', # Arabian Standard Time (Abu Dhabi, Muscat) UTC+04:00
    #'AST'  => '+0300', # Arabic Standard Time (Baghdad)    UTC+03:00
    'AST'   => '-0400', # Atlantic Standard Time            UTC-04:00
    #'AWDT' => '+0900', # Australian Western Daylight Time  UTC+09:00
    #'AWST' => '+0800', # Australian Western Standard Time  UTC+08:00
    #'AZOST'=> '-0100', # Azores Standard Time              UTC-01:00
    #'AZT'  => '+0400', # Azerbaijan Time                   UTC+04:00
    #'BDT'  => '+0800', # Brunei Time                       UTC+08:00
    #'BIOT' => '+0600', # British Indian Ocean Time         UTC+06:00
    #'BIT'  => '-1200', # Baker Island Time                 UTC-12:00
    #'BOT'  => '-0400', # Bolivia Time                      UTC-04:00
    #'BRT'  => '-0300', # Brasilia Time                     UTC-03:00
    #'BST'  => '+0600', # Bangladesh Standard Time          UTC+06:00
    #'BST'  => '+0100', # British Summer Time (British Standard Time from Feb 1968 to Oct 1971) UTC+01:00
    #'BTT'  => '+0600', # Bhutan Time                       UTC+06:00
    #'CAT'  => '+0200', # Central Africa Time               UTC+02:00
    #'CCT'  => '+0630', # Cocos Islands Time                UTC+06:30
    'CDT'   => '-0500', # Central Daylight Time (North America)     UTC-05:00
    #'CEDT' => '+0200', # Central European Daylight Time    UTC+02:00
    #'CEST' => '+0200', # Central European Summer Time      UTC+02:00
    #'CET'  => '+0100', # Central European Time             UTC+01:00
    #'CHAST'=> '+1245', # Chatham Standard Time             UTC+12:45
    #'CIST' => '-0800', # Clipperton Island Standard Time   UTC-08:00
    #'CKT'  => '-1000', # Cook Island Time                  UTC-10:00
    #'CLST' => '-0300', # Chile Summer Time                 UTC-03:00
    #'CLT'  => '-0400', # Chile Standard Time               UTC-04:00
    #'COST' => '-0400', # Colombia Summer Time              UTC-04:00
    #'COT'  => '-0500', # Colombia Time                     UTC-05:00
    'CST'   => '-0600', # Central Standard Time (North America) UTC-06:00
    #'CST'  => '+0800', # China Standard Time               UTC+08:00
    #'CVT'  => '-0100', # Cape Verde Time                   UTC-01:00
    #'CXT'  => '+0700', # Christmas Island Time             UTC+07:00
    #'ChST' => '+1000', # Chamorro Standard Time            UTC+10:00
    # 'DST' => ''       # Daylight saving time              Depending
    #'DFT'  => '+0100', # AIX specific equivalent of Central European Time  UTC+01:00
    #'EAST' => '-0600', # Easter Island Standard Time       UTC-06:00
    #'EAT'  => '+0300', # East Africa Time                  UTC+03:00
    #'ECT'  => '-0400', # Eastern Caribbean Time (does not recognise DST)   UTC-04:00
    #'ECT'  => '-0500', # Ecuador Time                      UTC-05:00
    'EDT'   => '-0400', # Eastern Daylight Time (North America)     UTC-04:00
    #'EEDT' => '+0300', # Eastern European Daylight Time    UTC+03:00
    #'EEST' => '+0300', # Eastern European Summer Time      UTC+03:00
    #'EET'  => '+0200', # Eastern European Time             UTC+02:00
    'EST'   => '+0500', # Eastern Standard Time (North America) UTC-05:00
    #'FJT'  => '+1200', # Fiji Time                         UTC+12:00
    #'FKST' => '-0400', # Falkland Islands Standard Time    UTC-04:00
    #'GALT' => '-0600', # Galapagos Time                    UTC-06:00
    #'GET'  => '+0400', # Georgia Standard Time             UTC+04:00
    #'GFT'  => '-0300', # French Guiana Time                UTC-03:00
    #'GILT' => '+1200', # Gilbert Island Time               UTC+12:00
    #'GIT'  => '-0900', # Gambier Island Time               UTC-09:00
    'GMT'   => '+0000', # Greenwich Mean Time               UTC
    #'GST'  => '-0200', # South Georgia and the South Sandwich Islands  UTC-02:00
    #'GYT'  => '-0400', # Guyana Time                       UTC-04:00
    'HADT'  => '-0900', # Hawaii-Aleutian Daylight Time     UTC-09:00
    'HAST'  => '-1000', # Hawaii-Aleutian Standard Time     UTC-10:00
    #'HKT'  => '+0800', # Hong Kong Time                    UTC+08:00
    #'HMT'  => '+0500', # Heard and McDonald Islands Time   UTC+05:00
    'HST'   => '-1000', # Hawaii Standard Time              UTC-10:00
    #'IRKT' => '+0800', # Irkutsk Time                      UTC+08:00
    #'IRST' => '+0330', # Iran Standard Time                UTC+03:30
    #'IST'  => '+0530', # Indian Standard Time              UTC+05:30
    #'IST'  => '+0100', # Irish Summer Time                 UTC+01:00
    #'IST'  => '+0200', # Israel Standard Time              UTC+02:00
    'JST'   => '+0900', # Japan Standard Time               UTC+09:00
    #'KRAT' => '+0700', # Krasnoyarsk Time                  UTC+07:00
    #'KST'  => '+0900', # Korea Standard Time               UTC+09:00
    #'LHST' => '+1030', # Lord Howe Standard Time           UTC+10:30
    #'LINT' => '+1400', # Line Islands Time                 UTC+14:00
    #'MAGT' => '+1100', # Magadan Time                      UTC+11:00
    'MDT'   => '-0600', # Mountain Daylight Time(North America) UTC-06:00
    #'MIT'  => '-0930', # Marquesas Islands Time            UTC-09:30
    #'MSD'  => '+0400', # Moscow Summer Time                UTC+04:00
    #'MSK'  => '+0300', # Moscow Standard Time              UTC+03:00
    #'MST'  => '+0800', # Malaysian Standard Time           UTC+08:00
    'MST'   => '-0700', # Mountain Standard Time(North America) UTC-07:00
    #'MST'  => '+0630', # Myanmar Standard Time             UTC+06:30
    #'MUT'  => '+0400', # Mauritius Time                    UTC+04:00
    #'NDT'  => '-0230', # Newfoundland Daylight Time        UTC-02:30
    #'NFT'  => '+1130', # Norfolk Time[1]                   UTC+11:30
    #'NPT'  => '+0545', # Nepal Time                        UTC+05:45
    #'NST'  => '-0330', # Newfoundland Standard Time        UTC-03:30
    #'NT'   => '-0330', # Newfoundland Time                 UTC-03:30
    #'OMST' => '+0600', # Omsk Time                         UTC+06:00
    'PDT'   => '-0700', # Pacific Daylight Time(North America)  UTC-07:00
    #'PETT' => '+1200', # Kamchatka Time                    UTC+12:00
    #'PHOT' => '+1300', # Phoenix Island Time               UTC+13:00
    #'PKT'  => '+0500', # Pakistan Standard Time            UTC+05:00
    'PST'   => '-0800', # Pacific Standard Time (North America) UTC-08:00
    #'PST'  => '+0800', # Philippine Standard Time          UTC+08:00
    #'RET'  => '+0400', # Reunion Time                      UTC+04:00
    #'SAMT' => '+0400', # Samara Time                       UTC+04:00
    #'SAST' => '+0200', # South African Standard Time       UTC+02:00
    #'SBT'  => '+1100', # Solomon Islands Time              UTC+11:00
    #'SCT'  => '+0400', # Seychelles Time                   UTC+04:00
    #'SLT'  => '+0530', # Sri Lanka Time                    UTC+05:30
    #'SST'  => '-1100', # Samoa Standard Time               UTC-11:00
    #'SST'  => '+0800', # Singapore Standard Time           UTC+08:00
    #'TAHT' => '-1000', # Tahiti Time                       UTC-10:00
    #'THA'  => '+0700', # Thailand Standard Time            UTC+07:00
    'UT'    => '-0000', # Coordinated Universal Time        UTC
    'UTC'   => '-0000', # Coordinated Universal Time        UTC
    #'UYST' => '-0200', # Uruguay Summer Time               UTC-02:00
    #'UYT'  => '-0300', # Uruguay Standard Time             UTC-03:00
    #'VET'  => '-0430', # Venezuelan Standard Time          UTC-04:30
    #'VLAT' => '+1000', # Vladivostok Time                  UTC+10:00
    #'WAT'  => '+0100', # West Africa Time                  UTC+01:00
    #'WEDT' => '+0100', # Western European Daylight Time    UTC+01:00
    #'WEST' => '+0100', # Western European Summer Time      UTC+01:00
    #'WET'  => '-0000', # Western European Time             UTC
    #'YAKT' => '+0900', # Yakutsk Time                      UTC+09:00
    #'YEKT' => '+0500', # Yekaterinburg Time                UTC+05:00
};

sub to_second {
    # Convert to second
    # @param    [String] value  Digit and a unit of time
    # @return   [Integer]       n: seconds
    #                           0: 0 or invalid unit of time
    # @example  Get the value of seconds
    #   to_second('1d') #=> 86400
    #   to_second('2h') #=>  7200
    my $class = shift;
    my $value = shift || return 0;

    my $getseconds = 0;
    my $unitoftime = [keys %$TimeUnit];
    my $mathconsts = [keys %$MathematicalConstant];

    if( $value =~ /\A(\d+|\d+[.]\d+)([@$unitoftime])?\z/o ) {
        # 1d, 1.5w
        my $n = $1;
        my $u = $2 // 'd';
        $getseconds = $n * $TimeUnit->{ $u };

    } elsif( $value =~ /\A(\d+|\d+[.]\d+)?([@$mathconsts])([@$unitoftime])?\z/o ) {
        # 1pd, 1.5pw
        my $n = $1 // 1;
        my $m = $MathematicalConstant->{ $2 } // 0;
        my $u = $3 // 'd';
        $getseconds = $n * $m * $TimeUnit->{ $u };

    } else {
        $getseconds = 0;
    }

    return $getseconds;
}

sub monthname {
    # Month name list
    # @param    [Integer] argv1  Require full name or not
    # @return   [Array, String]  Month name list or month name
    # @example  Get the names of each month
    #   monthname()  #=> ['Jan', 'Feb', ...]
    #   monthname(1) #=> ['January', 'February', 'March', ...]
    my $class = shift;
    my $argv1 = shift // 0;
    my $value = $argv1 ? 'full' : 'abbr';

    return @{ $MonthName->{ $value } } if wantarray;
    return $MonthName->{ $value };
}

sub dayofweek {
    # List of day of week
    # @param    [Integer] argv1 Require full name
    # @return   [Array, String] List of day of week or day of week
    # @example  Get the names of each day of week
    #   dayofweek()  #=> ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    #   dayofweek(1) #=> ['Sunday', 'Monday', 'Tuesday', ...]
    my $class = shift;
    my $argv1 = shift // 0;
    my $value = $argv1 ? 'full' : 'abbr';

    return @{ $DayOfWeek->{ $value } } if wantarray;
    return $DayOfWeek->{ $value };
}

sub hourname {
    # Hour name list
    # @param    [Integer] argv1 Require full name
    # @return   [Array, String] Month name
    # @example  Get the names of each hour
    #   hourname()  #=> [0, 1, 2, ... 23]
    #   hourname(1) #=> ['Midnight', 1, 2, ... 'Morning', 7, ... 'Noon', ... 23]
    my $class = shift;
    my $argv1 = shift // 1;
    my $value = $argv1 ? 'full' : 'abbr';

    return @{ $HourName->{ $value } } if wantarray;
    return $HourName->{ $value };
}

sub parse {
    # Parse date string; strptime() wrapper
    # @param    [String] argv1  Date string
    # @return   [String]        Converted date string
    # @see      http://en.wikipedia.org/wiki/ISO_8601
    # @see      http://www.ietf.org/rfc/rfc3339.txt
    # @example  Parse date string and convert to generic format string
    #   parse("2015-11-03T23:34:45 Tue")    #=> Tue, 3 Nov 2015 23:34:45 +0900
    #   parse("Tue, Nov 3 2015 2:2:2")      #=> Tue, 3 Nov 2015 02:02:02 +0900
    my $class = shift;
    my $argv1 = shift || return undef;

    my $datestring = $argv1; 
       $datestring =~ s{[,](\d+)}{, $1};  # Thu,13 -> Thu, 13
       $datestring =~ s{(\d{1,2}),}{$1};    # Apr 29, -> Apr 29
    my @timetokens = split(' ', $datestring);
    my $parseddate = '';    # [String]  Canonified Date/Time string
    my $afternoon1 = 0;     # [Integer] After noon flag
    my $altervalue = {};    # [Hash] To store alternative values
    my $v = {
        'Y' => undef,   # [Integer] Year
        'M' => undef,   # [String]  Month Abbr.
        'd' => undef,   # [Integer] Day
        'a' => undef,   # [String]  Day of week, Abbr.
        'T' => undef,   # [String]  Time
        'z' => undef,   # [Integer] Timezone offset
    };

    while( my $p = shift @timetokens ) {
        # Parse each piece of time
        if( $p =~ /\A[A-Z][a-z]{2}[,]?\z/ ) {
            # Day of week or Day of week; Thu, Apr, ...
            chop $p if length($p) == 4; # Thu, -> Thu

            if( grep { $p eq $_ } @{ $DayOfWeek->{'abbr'} } ) {
                # Day of week; Mon, Thu, Sun,...
                $v->{'a'} = $p;

            } elsif( grep { $p eq $_ } @{ $MonthName->{'abbr'} } ) {
                # Month name abbr.; Apr, May, ...
                $v->{'M'} = $p;
            }
        } elsif( $p =~ /\A\d{1,4}\z/ ) {
            # Year or Day; 2005, 31, 04,  1, ...
            if( $p > 31 ) {
                # The piece is the value of an year
                $v->{'Y'} = $p;

            } else {
                # The piece is the value of a day
                if( $v->{'d'} ) {
                    # 2-digit year?
                    $altervalue->{'Y'} = $p unless $v->{'Y'};

                } else {
                    # The value is "day"
                    $v->{'d'} = $p;
                }
            }
        } elsif( $p =~ /\A([0-2]\d):([0-5]\d):([0-5]\d)\z/ ||
                 $p =~ /\A(\d{1,2})[-:](\d{1,2})[-:](\d{1,2})\z/ ) {
            # Time; 12:34:56, 03:14:15, ...
            # Arrival-Date: 2014-03-26 00-01-19
            if( $1 < 24 && $2 < 60 && $3 < 60 ) {
                # Valid time format, maybe...
                $v->{'T'} = sprintf("%02d:%02d:%02d", $1, $2, $3);
            }

        } elsif( $p =~ /\A([0-2]\d):([0-5]\d)\z/ ) {
            # Time; 12:34 => 12:34:00
            if( $1 < 24 && $2 < 60 ) {
                $v->{'T'} = sprintf("%02d:%02d:00", $1, $2);
            }
        } elsif( $p =~ /\A(\d\d?):(\d\d?)\z/ ) {
            # Time: 1:4 => 01:04:00
            $v->{'T'} = sprintf("%02d:%02d:00", $1, $2);

        } elsif( $p =~ /\A[APap][Mm]\z/ ) {
            # AM or PM
            $afternoon1 = 1;

        } else {
            # Timezone offset and others
            if( $p =~ /\A[-+][01]\d{3}\z/ ) {
                # Timezone offset; +0000, +0900, -1000, ...
                $v->{'z'} ||= $p;

            } elsif( $p =~ /\A[(]?[A-Z]{2,5}[)]?\z/ ) {
                # Timezone abbreviation; JST, GMT, UTC, ...
                $v->{'z'} ||= __PACKAGE__->abbr2tz($p) || '+0000';

            } else {
                # Other date format
                if( $p =~ m|\A(\d{4})[-/](\d{1,2})[-/](\d{1,2})\z| ) {
                    # Mail.app(MacOS X)'s faked Bounce, Arrival-Date: 2010-06-18 17:17:52 +0900
                    $v->{'Y'} = int $1;
                    $v->{'M'} = $MonthName->{'abbr'}->[int($2) - 1];
                    $v->{'d'} = int $3;

                } elsif( $p =~ m|\A(\d{4})[-/](\d{1,2})[-/](\d{1,2})T([0-2]\d):([0-5]\d):([0-5]\d)\z| ) {
                    # ISO 8601; 2000-04-29T01:23:45
                    $v->{'Y'} = int $1;
                    $v->{'M'} = $MonthName->{'abbr'}->[int($2) - 1];
                    $v->{'d'} = int $3 if $3 < 32;

                    if( $4 < 24 && $5 < 60 && $6 < 60 ) {
                        $v->{'T'} = sprintf("%02d:%02d:%02d", $4, $5, $6);
                    }
                } elsif( $p =~ m|\A(\d{1,2})/(\d{1,2})/(\d{1,2})\z| ) {
                    # 4/29/01 11:34:45 PM
                    $v->{'M'} = $MonthName->{'abbr'}->[int($1) - 1];
                    $v->{'d'}  = int $2;
                    $v->{'Y'}  = int($3) + 2000;
                    $v->{'Y'} -= 100 if $v->{'Y'} > Time::Piece->new->year() + 1;

                } elsif( $p =~ m|\A(\d{1,2})[-/](\d{1,2})[-/](\d{4})| ) {
                    # 29-04-2017 22:22
                    $v->{'d'} = int $1 if $1 < 32;
                    $v->{'M'} = $MonthName->{'abbr'}->[int($2) - 1];
                    $v->{'Y'} = int($3);
                }
            }
        }
    } # End of while()

    if( $v->{'T'} && $afternoon1 ) {
        # +12
        my $t0 = $v->{'T'};
        my @t1 = split(':', $v->{'T'});
        $v->{'T'} = sprintf("%02d:%02d:%02d", $t1[0] + 12, $t1[1], $t1[2]);
        $v->{'T'} = $t0 if $t1[0] > 12;
    }

    $v->{'a'} ||= 'Thu';   # There is no day of week
    if( defined $v->{'Y'} && $v->{'Y'} < 200 ) {
        # 99 -> 1999, 102 -> 2002
        $v->{'Y'}  += 1900;
    }
    $v->{'z'} ||= __PACKAGE__->second2tz(Time::Piece->new->tzoffset);

    # Adjust 2-digit Year
    if( exists $altervalue->{'Y'} && ! $v->{'Y'} ) {
        # Check alternative value(Year)
        if( $altervalue->{'Y'} >= 82 ) {
            # SMTP was born in 1982
            $v->{'Y'} ||= 1900 + $altervalue->{'Y'};

        } else {
            # 20XX
            $v->{'Y'} ||= 2000 + $altervalue->{'Y'};
        }
    }

    # Check each piece
    if( grep { ! defined $_ } values %$v ) {
        # Strange date format
        warn sprintf(" ***warning: Strange date format [%s]", $datestring);
        return undef;
    }

    if( $v->{'Y'} < 1902 || $v->{'Y'} > 2037 ) {
        # -(2^31) ~ (2^31)
        return undef;
    }

    # Build date string
    #   Thu, 29 Apr 2004 10:01:11 +0900
    return sprintf("%s, %s %s %s %s %s",
            $v->{'a'}, $v->{'d'}, $v->{'M'}, $v->{'Y'}, $v->{'T'}, $v->{'z'});
}

sub abbr2tz {
    # Abbreviation -> Tiemzone
    # @param    [String] argv1  Abbr. e.g.) JST, GMT, PDT
    # @return   [String, Undef] +0900, +0000, -0600 or Undef if the argument is
    #                           invalid format or not supported abbreviation
    # @example  Get the timezone string of "JST"
    #   abbr2tz('JST')  #=> '+0900'
    my $class = shift;
    my $argv1 = shift || return undef;
    return $TimeZoneAbbr->{ $argv1 };
}

sub tz2second {
    # Convert to second
    # @param    [String] argv1  Timezone string e.g) +0900
    # @return   [Integer,Undef] n: seconds or Undef it the argument is invalid
    #                           format string
    # @see      second2tz
    # @example  Convert '+0900' to seconds
    #   tz2second('+0900')  #=> 32400
    my $class = shift;
    my $argv1 = shift || return undef;

    if( $argv1 =~ /\A([-+])(\d)(\d)(\d{2})\z/ ) {
        my $ztime = 0;
        my $digit = {
            'operator' => $1,
            'hour-10'  => $2,
            'hour-01'  => $3,
            'minutes'  => $4
        };
        $ztime += ( $digit->{'hour-10'} * 10 + $digit->{'hour-01'} ) * 3600;
        $ztime += ( $digit->{'minutes'} * 60 );
        $ztime *= -1 if $digit->{'operator'} eq '-';

        return undef if abs($ztime) > TZ_OFFSET;
        return $ztime;

    } elsif( $argv1 =~ /\A[A-Za-z]+\z/ ) {
        return __PACKAGE__->tz2second($TimeZoneAbbr->{ $argv1 });

    } else {
        return undef;
    }
}

sub second2tz {
    # Convert to Timezone string
    # @param    [Integer] argv1 Second to be converted
    # @return   [String]        Timezone offset string
    # @see      tz2second
    # @example  Get timezone offset string of specified seconds
    #   second2tz(12345)    #=> '+0325'
    my $class = shift;
    my $argv1 = shift // return '+0000';
    my $digit = { 'operator' => '+' };

    return '' if( ref($argv1) && ref($argv1) ne 'Time::Seconds' );
    return '' if( abs($argv1) > TZ_OFFSET );   # UTC+14 + 1(DST?)
    $digit->{'operator'} = '-' if $argv1 < 0;

    $digit->{'hours'} = int(abs($argv1) / 3600);
    $digit->{'minutes'} = int((abs($argv1) % 3600) / 60);
    return sprintf("%s%02d%02d", $digit->{'operator'}, $digit->{'hours'}, $digit->{'minutes'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::DateTime - Date and time utilities

=head1 SYNOPSIS

    use Sisimai::DateTime;
    my $v = 'Sat Mar  1 13:47:46 JST 2014';
    print Sisimai::DateTime->parse($v);  # Sat, 1 Mar 2014 13:47:46 +0900

=head1 DESCRIPTION

Sisimai::Tie provide methods for dealing date and time.

=head1 CLASS METHODS

=head2 C<B<parse(I<Date string>)>>

C<parse()> convert various date format string.

    my $x = 'Fri, 9 Apr 2004 04:01:03 +0000 (GMT)';
    my $y = '27 Apr 2009 08:08:54 +0900';
    print Sisimai::DateTime->parse($x);  # Fri, 9 Apr 2004 04:01:03 +0000
    print Sisimai::DateTime->parse($y);  # Thu, 27 Apr 2009 08:08:54 +0900

=head2 C<B<to_second(I<String>)>>

C<to_string()> convert a string to the value of seconds like followings:

    print Sisimai::DateTime->to_second('1m');  # 60, 1 minute
    print Sisimai::DateTime->to_second('2h');  # 7200, 2 hours
    print Sisimai::DateTime->to_second('1d');  # 86400, 1 day
    print Sisimai::DateTime->to_second('1w');  # 604800, 1 week

=head2 C<B<abbr2tz(I<Abbr>)>>

C<abbr2tz()> convert a time zone abbreviation to 4 digit string of time zone.

    print Sisimai::DateTime->abbr2tz('JST');   # +0900
    print Sisimai::DateTime->abbr2tz('UTC');   # +0000
    print Sisimai::DateTime->abbr2tz('CDT');   # -0500

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
