# $Rev: 678 $
package Date::ICal;
use strict;

use vars qw($VERSION $localzone $localoffset @months @leapmonths %add_units);
$VERSION = '2.'.(qw'$Rev: 678 $')[1];
use Carp;
use Time::Local;
use Date::Leapyear qw();
use Date::ICal::Duration;
use overload '<=>' => 'compare',
             'fallback' => 1,
             '-' => \&subtract,
             '+' => \&add_overload;

$localzone   = $ENV{TZ} || 0;
$localoffset = _calc_local_offset();

# Documentation {{{

=head1 NAME

Date::ICal - Perl extension for ICalendar date objects.

=head1 VERSION

$Revision: 678 $

=head1 SYNOPSIS

    use Date::ICal;

    $ical = Date::ICal->new( ical => '19971024T120000' );
    $ical = Date::ICal->new( epoch => time );
    $ical = Date::ICal->new( year => 1964,
        month => 10, day => 16, hour => 16,
        min => 12, sec => 47 );

    $hour = $ical->hour;
    $year = $ical->year;

    $ical_string = $ical->ical;
    $epoch_time = $ical->epoch;

    $ical2 = $ical + $duration;

(Where $duration is either a duration string, like 'P2W3DT7H9M', or a
Date::ICal::Duration (qv) object.

    $ical += 'P6DT12H';

    $duration = $ical - $ical2;
    $ical3 = $ical - $duration;

=head1 DESCRIPTION

Date::ICal talks the ICal date format, and is intended to be a base class for
other date/calendar modules that know about ICal time format also.

=head1 AUTHOR

Rich Bowen, and the Reefknot team. Alas, Reefknot is no more. See
http://datetime.perl.org/ for more modern and accurate modules.

Last touched by $Author: rbowen $

=head1 METHODS

Date::ICal has the following methods available:

=head2 new

A new Date::ICal object can be created with any valid ICal string:

    my $ical = Date::ICal->new( ical => '19971024T120000' );
    # will default to the timezone specified in $TZ, see below

Or with any epoch time:

    my $ical = Date::ICal->new( epoch => time );

Or, better still, create it with components

    my $date = Date::ICal->new( 
                           day => 25, 
                           month => 10, 
                           year => 1066,
                           hour => 7,
                           min => 15,
                           sec => 47
                           );

If you call new without any arguments, you'll get a Date::ICal object that is
set to the time right now.

    my $ical = Date::ICal->new();

If you already have an object in Date::ICal, or some other subclass
thereof, you can create a new Date::ICal (or subclass) object using
that object to start with. This is particularly useful for converting
from one calendar to another:

   # Direct conversion from Discordian to ISO dates
   my $disco = Date::Discordian->new( disco => '12 Chaos, YOLD 3177' );
   my $iso = Date::ISO->new( $disco );
   print $iso->iso;

new() handles timezones. It defaults times to UTC (Greenwich
Mean Time, also called Zulu). If you want to set up a time
that's in the US "Pacific" timezone, which is GMT-8, use something
like:
    
    my $ical = Date::ICal->new( ical => '19971024T120000',
                                offset => "-0800");
   
Note that as of version 1.44, new() tries to be intelligent
about figuring out your local time zone. If you enter
a time that's not *explicitly* in UTC, it looks at
the environment variable $TZ, if it exists, to determine
your local offset. If $TZ isn't set, new() will complain.

=cut

#}}}

#{{{ sub new

sub new {
    my $class = shift;
    my ( $self, %args, $sec, $min, $hour, $day, $month, $year, $tz );

    # $zflag indicates whether or not this time is natively in UTC    
    my $zflag = 0;

    # First argument can be a Date::ICal (or subclass thereof) object
    if ( ref $_[0] ) {
        $args{ical} = $_[0]->ical;
      } else {
        %args = @_;
    }

    $self = {};

    # Date is specified as epoch#{{{
    if ( defined( $args{epoch} ) ) {

        ( $sec, $min, $hour, $day, $month, $year ) =
          ( gmtime( $args{epoch} ) )[ 0, 1, 2, 3, 4, 5 ];
        $year += 1900;
        $month++;

        $zflag = 1;    # epoch times are by definition in GMT
    }    #}}}

    # Date is specified as ical string#{{{
    elsif ( defined( $args{ical} ) ) {

        # Timezone, if any
        $args{ical} =~ s/^(?:TZID=([^:]+):)?//;
        $tz = $1;

        # Split up ical string
        ( $year, $month, $day, $hour, $min, $sec, $zflag ) =
          $args{ical} =~ /^(?:(\d{4})(\d\d)(\d\d))
               (?:T(\d\d)?(\d\d)?(\d\d)?)?
                         (Z)?$/x;

        # TODO: figure out what to do if we get a TZID. 
        # I'd suggest we store it for use by modules that care
        # about TZID names. But we don't want this module
        # to deal with timezone names, only offsets, I think.
        # --srl

    }    #}}}

    # Time specified as components#{{{
    elsif ( defined( $args{day} ) ) {

        # Choke if missing arguments
        foreach my $attrib(qw(day month year )) {
            warn "Attribute $attrib required" unless defined $args{$attrib};
        }
        foreach my $attrib(qw( hour min sec )) {
            $args{$attrib} = 0 unless defined $args{$attrib};
        }

        # And then just use what was passed in
        ( $sec, $min, $hour, $day, $month, $year ) =
          @args{ 'sec', 'min', 'hour', 'day', 'month', 'year' };

    }    #}}}

    else {    # Just use current gmtime#{{{

        # Since we are defaulting, this qualifies as UTC
        $zflag = 1;

        ( $sec, $min, $hour, $day, $month, $year ) = ( gmtime(time) )[ 0 .. 5 ];
        $year += 1900;
        $month++;
    }    #}}}

    $self->{julian} = greg2jd( $year, $month, $day );
    $self->{julsec} = time_as_seconds( $hour, $min, $sec );
    bless $self, $class;

    if ( exists( $args{offset} ) ) {
        # We should complain if they're trying to set a non-UTC
        # offset on a time that's inherently UTC.  -jv
        if ($zflag && ($args{offset} != 0)) {
            carp "Time had conflicting offset and UTC info. Using UTC"
              unless $ENV{HARNESS_ACTIVE};
          } else {

            # Set up the offset for this datetime.
            $self->offset( $args{offset} || 0 );
        }
      } elsif ( !$zflag ) {

        # Check if the timezone has changed since the last time we checked.
        # Apparently this happens on some systems. Patch from Mike
        # Heins. Ask him.
        my $tz  = $ENV{TZ} || '0';
        my $loc = $tz eq $localzone ? $localoffset : _calc_local_offset();
        $self->offset($loc) if defined $self;
    }

    return $self;
}

#}}}

#{{{ sub ical

=head2 ical

    $ical_string = $ical->ical;

Retrieves, or sets, the date on the object, using any valid ICal date/time
string. Output is in UTC (ends with a "Z") by default. To get
output in localtime relative to the current machine, do:
    
    $ical_string = $ical->ical( localtime => 1 );

To get output relative to an arbitrary offset, do:

    $ical_string = $ical->ical( offset => '+0545' );

=cut

sub ical {
    my $self = shift;
    if ( 1 & @_ ) {     # odd number of parameters?
        carp "Bad args: expected named parameter list";
        shift;    # avoid warning from %args=@_ assignment
    }
    my %args = @_;
    my $ical;

    if ( exists $args{localtime} ) {
        carp "can't have localtime and offset together, using localtime offset"
          if exists $args{offset};

        # make output in localtime format by setting $args{offset}
        $args{offset} = $self->offset;
    }

    if ( exists $args{offset} ) {

        # make output based on an arbitrary offset
        # No Z on the end!
        my $julian = $self->{julian};
        my $julsec = $self->{julsec};
        my $adjust = offset_to_seconds( $args{offset} );
        $self->add( seconds => $adjust );
        $ical =
          sprintf( '%04d%02d%02dT%02d%02d%02d', $self->year, $self->month,
          $self->day, $self->hour, $self->minute, $self->second, );
        $self->{julian} = $julian;
        $self->{julsec} = $julsec;
      } else {

        # make output in UTC by default
        # if we were originally given this time in offset
        # form, we'll need to adjust it for output
        if ( $self->hour || $self->min || $self->sec ) {
            $ical =
              sprintf( '%04d%02d%02dT%02d%02d%02dZ', $self->year, $self->month,
              $self->day, $self->hour, $self->minute, $self->second );
          } else {
            $ical =
              sprintf( '%04d%02d%02dZ', $self->year, $self->month, $self->day );
        }
    }

    return $ical;
}    #}}}

#{{{ sub epoch

=head2 epoch

    $epoch_time = $ical->epoch;
    
    $ical->epoch( 98687431 );

Sets, or retrieves, the epoch time represented by the object, if it is
representable as such. (Dates before 1971 or after 2038 will not have an epoch
representation.)

Internals note: The ICal representation of the date is considered the only
authoritative one. This means that we may need to reconstruct the epoch time
from the ICal representation if we are not sure that they are in synch. We'll
need to do clever things to keep track of when the two may not be in synch.
And, of course, the same will go for any subclasses of this class.

=cut

sub epoch {
    my $self  = shift;
    my $class = ref($self);

    my $epoch;

    if ( $epoch = shift ) {    # Passed in a new value

        my $newepoch = $class->new( epoch => $epoch );
        $self->{julian} = $newepoch->{julian};
        $self->{julsec} = $newepoch->{julsec};

    }

    else {    # Calculate epoch from components, if possible

        $epoch =
          timegm( $self->sec, $self->min, $self->hour, $self->day,
          ( $self->month ) - 1, ( $self->year ) - 1900 );
    }

    return $epoch;
}

#}}}

#{{{ sub offset_to_seconds

=head2 offset_to_seconds

    $seconds_plus_or_minus = offset_to_seconds($offset);
   
Changes -0600 to -21600. Not object method, no side-effects.

=cut

sub offset_to_seconds {
    my $offset = shift;

    # Relocated from offset for re-use
    my $newoffset;

    if ( $offset eq '0' ) {
        $newoffset = 0;
      } elsif ( $offset =~ /^([+-])(\d\d)(\d\d)\z/ )
    {
        my ( $sign, $hours, $minutes ) = ( $1, $2, $3 );

        # convert to seconds, ignoring the possibility of leap seconds
        # or daylight-savings-time shifts
        $newoffset = $hours * 60 * 60 + $minutes * 60;
        $newoffset *= -1 if $sign eq '-';
      } else {
        carp("You gave an offset, $offset, that makes no sense");
        return undef;
    }
    return $newoffset;
}

#}}}

#{{{ sub offset_from_seconds

=head2 offset_from_seconds

    $seconds_plus_or_minus = offset_from_seconds($offset_in_seconds);
   
Changes -18000 (seconds) to -0600 (hours, minutes). 
Not object method, no side-effects.

=cut

sub offset_from_seconds {
    my $secoffset  = shift;
    my $hhmmoffset = 0;

    if ( $secoffset ne '0' ) {
        my ( $sign, $secs ) = ( "", "" );
        ( $sign, $secs ) = $secoffset =~ /([+-])?(\d+)/;

        # throw in a + to make this look like an offset if positive
        $sign = "+" unless $sign;

        # NOTE: the following code will return "+0000" if you give it a number
        # of seconds that are a multiple of a day. However, for speed reasons
        # I'm not going to write in a comparison to reformat that back to 0.
        # 
        my $hours = $secs / ( 60 * 60 );
        $hours = $hours % 24;
        my $mins = ( $secs % ( 60 * 60 ) ) / 60;
        $hhmmoffset = sprintf( '%s%02d%02d', $sign, $hours, $mins );

    }

    return $hhmmoffset;
}

#}}}

#{{{ sub offset

=head2 offset 

    $offset = $ical->offset;
   
    # We need tests for these.  
    $ical->offset( '+1100' ); # a number of hours and minutes: UTC+11
    $ical->offset( 0 );       # reset to UTC

Sets or retrieves the offset from UTC for this time. This allows
timezone support, assuming you know what your local (or non-local)
UTC offset is. Defaults to 0. 

Internals note: all times are internally stored in UTC, even though they
may have some offset information. Offsets are internally stored in
signed integer seconds. 

BE CAREFUL about using this function on objects that were initialized
with an offset. If you started an object with:
    
    my $d = new(ical=>'19700101120000', offset=>'+0100'); 

and you then call: 

    $d->offset('+0200'); 
    
you'll be saying "Yeah, I know I *said* it was in +0100, but really I
want it to be in +0200 now and forever." Which may be your intention,
if you're trying to transpose a whole set of dates to another timezone---
but you can also do that at the presentation level, with
the ical() method. Either way will work.

=cut

sub offset {
    my ( $self, $offset ) = @_;
    my $newoffset = undef;

    if ( defined($offset) ) {    # Passed in a new value
        $newoffset = offset_to_seconds($offset);

        unless ( defined $newoffset ) { return undef; }

        # since we're internally storing in GMT, we need to
        # adjust the time we were given by the offset so that
        # the internal date/time will be right.

        if ( $self->{offset} ) {

            # figure out whether there's a difference between
            # the existing offset and the offset we were given.
            # If so, adjust appropriately.
            my $offsetdiff = $self->{offset} - $newoffset;

            if ($offsetdiff) {
                $self->{offset} = $newoffset;
                $self->add( seconds => $offsetdiff );
              } else {

                # leave the offset the way it is
            }
          } else {
            $self->add( seconds => -$newoffset );
            $self->{offset} = $newoffset;
        }

      } else {
        if ( $self->{offset} ) {
            $offset = offset_from_seconds( $self->{offset} );
          } else {
            $offset = 0;
        }
    }

    return $offset;
}

#}}}

# sub add {{{

=head2 add

    $self->add( year => 3, month => 2, week => 1, day => 12,
                hour => 1, minute => 34, sec => 59 );
    $date->add( duration => 'P1WT1H1M1S' ); # add 1 wk, 1 hr, 1 min, and 1 sec

Adds a duration to a Date::ICal object.

Supported paraters are: duration, eom_mode, year, month, week, day,
hour, min, sec or seconds.

'duration' is a ICalendar duration string (see duration_value).

If a value is undefined or omitted, 1 is assumed:

    $ical->add( 'minute' ); # add a minute

The result will be normalized. That is, the output time will have
meaningful values, rather than being 48:73 pm on the 34th of 
hexadecember.

Adding months or years can be done via three different methods,
specified by the eom_mode parameter, which then applies to all
additions (or subtractions) of months or years following it in the
parameter list.

The default, eom_mode => 'wrap', means adding months or years that
result in days beyond the end of the new month will roll over into the
following month.  For instance, adding one year to Feb 29 will result
in Mar 1.

If you specify eom_mode => 'limit', the end of the month is never
crossed.  Thus, adding one year to Feb 29, 2000 will result in Feb 28,
2001.  However, adding three more years will result in Feb 28, 2004,
not Feb 29.

If you specify eom_mode => 'preserve', the same calculation is done as
for 'limit' except that if the original date is at the end of the
month the new date will also be.  For instance, adding one month to
Feb 29, 2000 will result in Mar 31, 2000.

All additions are performed in the order specified.  For instance,
with the default setting of eom_mode => 'wrap', adding one day and one
month to Feb 29 will result in Apr 1, while adding one month and one
day will result in Mar 30.

=cut

sub add {
    my $self = shift;
    carp "Date::ICal::add was called without an attribute arg" unless @_;
    ( $self->{julian}, $self->{julsec}) =
        _add($self->{julian}, $self->{julsec}, @_);
    return $self;
}

#}}}

# sub _add {{{

=begin internal

    Add (or subtract) to a date/time.  First two parameters are
    the jd and secs of the day.  For the rest, see the add method.
    Returns the adjusted jd and secs.

=end internal

=cut

# for each unit, specify what it changes by (0=day, 1=second, 2=month)
# and by what factor

%add_units = (year=>[2,12], month=>[2,1], week=>[0,7], day=>[0,1],
              hour=>[1,3600], min=>[1,60], sec=>[1,1], seconds=>[1,1]);

sub _add {
    my ($jd, $secs) = splice(@_, 0, 2);
    my $eom_mode = 0;
    my ($add, $unit, $count);

    # loop through unit=>count parameters
    while (($unit, $count) = splice(@_, 0, 2)) {

        if ($unit eq 'duration') { # add a duration string
            my %dur;
            @dur{'day','sec','month'} = duration_value($count);

            # pretend these were passed to us as e.g. month=>1, day=>1, sec=>1.
            # since months/years come first in the duration string, we
            # put them first.
            unshift @_, map $dur{$_} ? ($_,$dur{$_}) : (),
                            'month', 'day', 'sec';
            next;
        } elsif ($unit eq 'eom_mode') {
            if ($count eq 'wrap') { $eom_mode = 0 }
            elsif ($count eq 'limit') { $eom_mode = 1 }
            elsif ($count eq 'preserve') { $eom_mode = 2 }
            else { carp "Unrecognized eom_mode, $count, ignored" }
        } else {
            unless ($add = $add_units{$unit}) {
                carp "Unrecognized time unit, $unit, skipped";
                next;
            }

            $count = 1 if !defined $count; # count defaults to 1
            $count *= $add->[1]; # multiply by the factor for this unit

            if ($add->[0] == 0) { # add to days
                $jd += $count;
            } elsif ($add->[0] == 1) { # add to seconds
                $secs += $count;
            } else {            # add to months
                my ($y, $mo, $d);

                _normalize_seconds( $jd, $secs );
                if ($eom_mode == 2) { # sticky eom mode
                    # if it is the last day of the month, make it the 0th
                    # day of the following month (which then will normalize
                    # back to the last day of the new month).
                    ($y, $mo, $d) = jd2greg( $jd+1 );
                    --$d;
                } else {
                    ($y, $mo, $d) = jd2greg( $jd );
                }

                if ($eom_mode && $d > 28) { # limit day to last of new month
                    # find the jd of the last day of our target month
                    $jd = greg2jd( $y, $mo+$count+1, 0 );

                    # what day of the month is it? (discard year and month)
                    my $lastday = scalar jd2greg( $jd );

                    # if our original day was less than the last day,
                    # use that instead
                    $jd -= $lastday - $d if $lastday > $d;
                } else {
                    $jd = greg2jd( $y, $mo+$count, $d );
                }
            }
        }
    }

    _normalize_seconds( $jd, $secs );
}

#}}}

# sub add_overload {{{

=head2 add_overload

    $date = $date1 + $duration;

Where $duration is either a duration string, or a Date::ICal::Duration
object.

    $date += 'P2DT4H7M';

Adds a duration to a date object. Returns a new object, or, in the case
of +=, modifies the existing object.

=cut

sub add_overload {
    my $one = shift;
    my $two = shift;

    my $ret = $one->clone;

    if ( ref $two ) {
        $ret->add( duration => $two->as_ical );
    } else {
        $ret->add( duration => $two );
    }

    return $ret;
} # }}}

# sub _normalize_seconds {{{

=begin internal

    ($jd, $secs) = _normalize_seconds( $jd, $secs );

    Corrects seconds that have gone into following or previous day(s).
    Adjusts the passed days and seconds as well as returning them.

=end internal

=cut

sub _normalize_seconds {
    my $adj;

    if ($_[1] < 0) {
        $adj = int( ($_[1]-86399)/86400 );
    } else {
        $adj = int( $_[1]/86400 );
    }
    ($_[0] += $adj), ($_[1] -= $adj*86400);
}

#}}}

# sub duration_value {{{

=head2 duration_value

Given a duration string, this function returns the number of days,
seconds, and months represented by that duration. In that order. Seems
odd to me. This should be considered an internal function, and you
should expect the API to change in the very near future.

=cut

sub duration_value {
    my $str = shift;

    my @temp = $str =~ m{
            ([\+\-])?   (?# Sign)
            (P)     (?# 'P' for period? This is our magic character)
            (?:
                (?:(\d+)Y)? (?# Years)
                (?:(\d+)M)? (?# Months)
                (?:(\d+)W)? (?# Weeks)
                (?:(\d+)D)? (?# Days)
            )?
            (?:T        (?# Time prefix)
                (?:(\d+)H)? (?# Hours)
                (?:(\d+)M)? (?# Minutes)
                (?:(\d+)S)? (?# Seconds)
            )?
                }x;
    my ( $sign, $magic ) = @temp[ 0 .. 1 ];
    my ( $years, $months, $weeks, $days, $hours, $mins, $secs ) =
      map { defined($_) ? $_ : 0 } @temp[ 2 .. $#temp ];

    unless ( defined($magic) ) {
        carp "Invalid duration: $str";
        return undef;
    }
    $sign = ( ( defined($sign) && $sign eq '-' ) ? -1 : 1 );

    my $s = $sign * ( $secs + ( $mins * 60 ) + ( $hours * 3600 ) );
    my $d = $sign * ( $days + ( $weeks * 7 ) );
    my $m = $sign * ( $months + ( $years * 12 ) );
    return ( $d, $s, $m );
}

#}}}

# sub subtract {{{

=head2 subtract

  $duration = $date1 - $date2;

Subtract one Date::ICal object from another to give a duration - the
length of the interval between the two dates. The return value is a
Date::ICal::Duration object (qv) and allows you to get at each of the
individual components, or the entire duration string:

    $d = $date1 - $X;

Note that $X can be any of the following:

If $X is another Date::ICal object (or subclass thereof) then $d will be
a Date::ICal::Duration object.

    $week = $d->weeks; # how many weeks apart?
    $days = $d->as_days; # How many days apart?

If $X is a duration string, or a Date::ICal::Diration object, then $d
will be an object in the same class as $date1;

    $newdate = $date - $duration; 

=cut

sub subtract {
    my ( $date1, $date2, $reversed ) = @_;
    my $dur;

    # If the order of the arguments was reversed, overload tells us
    # about it in the third argument.
    if ($reversed) {
        ( $date2, $date1 ) = ( $date1, $date2 );
    }

    if (ref $date1 && ref $date2) {
    # If $date1 is a Date::ICal object, and $date2 is a Duration object,
    # then we should subtract and get a date.
        if ((ref $date2) eq 'Date::ICal::Duration') {
            my $seconds = $date2->as_seconds;
            my $ret = $date1->clone;
            $ret->add( seconds => -1 * $seconds );
            return $ret;

        } else {
    # If $date2 is a Date::ICal object, or some class thereof, we should
    # subtract and get a duration

            my $days = $date1->{julian} - $date2->{julian};
            my $secs = $date1->{julsec} - $date2->{julsec};

            return Date::ICal::Duration->new(
              days    => $days,
              seconds => $secs
            );
        } 
    } elsif ( ref $date1 && 
              ( $dur = Date::ICal::Duration->new( ical => $date2 ) )
            ) {
    # If $date1 is a Date::ICal object, and $date2 is a duration string,
    # we should subtract and get a date
        return $date1 - $dur; # Is that cheating?

    # Otherwise, return undef
    } else {
        warn "Invalid arguments. You can subtract a date from a date, or a duration from a date";
        return;
    }

} # }}}

# sub clone {{{

=head2 clone

    $copy = $date->clone;

Returns a replica of the date object, including all attributes.

=cut

sub clone {
    my $self = shift;
    my $class = ref $self;
    my %hash = %$self;
    my $new = \%hash;
    bless $new, $class;
    return $new;
} # }}}

# sub compare {{{

=head2 compare

    $cmp = $date1->compare($date2);

    @dates = sort {$a->compare($b)} @dates;

Compare two Date::ICal objects. Semantics are compatible with
sort; returns -1 if $a < $b, 0 if $a == $b, 1 if $a > $b. 

=cut

sub compare {
    my ( $self, $otherdate ) = (@_);

    unless ( defined($otherdate) ) { return undef }

    # One or more days different

    if ( $self->{julian} < $otherdate->{julian} ) {
        return -1;
      } elsif ( $self->{julian} > $otherdate->{julian} )
    {
        return 1;

        # They are the same day
      } elsif ( $self->{julsec} < $otherdate->{julsec} )
    {
        return -1;
      } elsif ( $self->{julsec} > $otherdate->{julsec} )
    {
        return 1;
    }

    #    # if we got all this way and haven't yet returned, the units are equal.
    return 0;
}

#}}}

# internal stuff {{{

=begin internal

 @months = months($year);

Returns the Julian day at the end of a month, correct for that year.

=end internal 

=cut

# precalculate these values at module load time so that we don't
# have to do it repeatedly during runtime. 
# 
BEGIN {

    #           +  31, 28, 31, 30,  31,  30,  31,  31,  30,  31,  30,  31
    @months = ( 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 );
    @leapmonths = @months;

    for ( 2 .. 12 ) {
        $leapmonths[$_] = $months[$_] + 1;
    }
}

sub months {
    return Date::Leapyear::isleap(shift) ? @leapmonths : @months;
}

=begin internal

    time_as_seconds( $args{hour}, $args{min}, $args{sec} );

Returns the time of day as the number of seconds in the day.

=end internal

=cut

# }}}

# sub time_as_seconds {{{

sub time_as_seconds {
    my ( $hour, $min, $sec ) = @_;

    $hour ||= 0;
    $min ||= 0;
    $sec ||= 0;

    my $secs = $hour * 3600 + $min * 60 + $sec;
    return $secs;
} #}}}

# sub day {{{

=head2 day

    my $day = $date->day;

Returns the day of the month.

Day is in the range 1..31

=cut

sub day {
    my $self = shift;
    return ( jd2greg( $self->{julian} ) )[2];
} # }}}

# sub month {{{

=head2 month

    my $month = $date->month;

Returns the month of the year.

Month is returned as a number in the range 1..12

=cut

sub month {
    my $self = shift;
    return ( jd2greg( $self->{julian} ) )[1];
} # }}}

# sub mon {{{

sub mon { return month(@_); }

#}}}

# sub year {{{

=head2 year

    my $year = $date->year;

Returns the year.  

=cut

sub year {
    my $self = shift;
    return ( jd2greg( $self->{julian} ) )[0];
} # }}}

# sub jd2greg {{{

=head2 jd2greg

    ($year, $month, $day) = jd2greg( $jd );

    Convert number of days on or after Jan 1, 1 CE (Gregorian) to
    gregorian year,month,day.

=cut

sub jd2greg {
    use integer;
    my $d = shift;
    my $yadj = 0;
    my ( $c, $y, $m );

    # add 306 days to make relative to Mar 1, 0; also adjust $d to be within
    # a range (1..2**28-1) where our calculations will work with 32bit ints
    if ( $d > 2**28 - 307 ) {

        # avoid overflow if $d close to maxint
        $yadj = ( $d - 146097 + 306 ) / 146097 + 1;
        $d -= $yadj * 146097 - 306;
      } elsif ( ( $d += 306 ) <= 0 )
    {
        $yadj =
          -( -$d / 146097 + 1 );    # avoid ambiguity in C division of negatives
        $d -= $yadj * 146097;
    }

    $c =
      ( $d * 4 - 1 ) / 146097;    # calc # of centuries $d is after 29 Feb of yr 0
    $d -= $c * 146097 / 4;    #     (4 centuries = 146097 days)
    $y = ( $d * 4 - 1 ) / 1461;    # calc number of years into the century,
    $d -= $y * 1461 / 4;    #     again March-based (4 yrs =~ 146[01] days)
    $m =
      ( $d * 12 + 1093 ) / 367;    # get the month (3..14 represent March through
    $d -= ( $m * 367 - 1094 ) / 12;    #     February of following year)
    $y += $c * 100 + $yadj * 400;    # get the real year, which is off by
    ++$y, $m -= 12 if $m > 12;         #     one if month is January or February
    return ( $y, $m, $d );
}    #}}}

# sub greg2jd {{{

=head2 greg2jd

    $jd = greg2jd( $year, $month, $day );

    Convert gregorian year,month,day to days on or after Jan 1, 1 CE
    (Gregorian).  Normalization is performed (e.g. month of 28 means
    April two years after given year) for month < 1 or > 12 or day < 1
    or > last day of month.

=cut

sub greg2jd {
    use integer;
    my ( $y, $m, $d ) = @_;
    my $adj;

    # make month in range 3..14 (treat Jan & Feb as months 13..14 of prev year)
    if ( $m <= 2 ) {
        $y -= ( $adj = ( 14 - $m ) / 12 );
        $m += 12 * $adj;
      } elsif ( $m > 14 )
    {
        $y += ( $adj = ( $m - 3 ) / 12 );
        $m -= 12 * $adj;
    }

    # make year positive (oh, for a use integer 'sane_div'!)
    if ( $y < 0 ) {
        $d -= 146097 * ( $adj = ( 399 - $y ) / 400 );
        $y += 400 * $adj;
    }

    # add: day of month, days of previous 0-11 month period that began w/March,
    # days of previous 0-399 year period that began w/March of a 400-multiple
    # year), days of any 400-year periods before that, and 306 days to adjust
    # from Mar 1, year 0-relative to Jan 1, year 1-relative (whew)

    $d += ( $m * 367 - 1094 ) / 12 + $y % 100 * 1461 / 4 +
      ( $y / 100 * 36524 + $y / 400 ) - 306;
}    # }}}

# sub days_this_year {{{

=head2 days_this_year

  $yday = Date::ICal::days_this_year($day, $month, $year);

Returns the number of days so far this year. Analogous to the yday
attribute of gmtime (or localtime) except that it works outside of the
epoch.

=cut

sub days_this_year {
    my ( $d, $m, $y ) = @_;
    my @mlist = &months($y);
    return $mlist[$m - 1] + $d - 1;
}    #}}}

# sub day_of_week {{{

=head2 day_of_week

    my $day_of_week = $date->day_of_week

Returns the day of week as 0..6 (0 is Sunday, 6 is Saturday).

=cut

sub day_of_week {
    my $self = shift;
    return $self->{julian} % 7;
}    #}}}

# sub hour {{{

=head2 hour

    my $hour = $date->hour

Returns the hour of the day.

Hour is in the range 0..23

=cut

sub hour {
    my $self = shift;
    return ( $self->parsetime )[2];
} # }}}

# sub min {{{

=head2 min

    my $min = $date->min;

Returns the minute.

Minute is in the range 0..59

=cut

sub min {
    my $self = shift;
    return ( $self->parsetime )[1];
}

sub minute { return min(@_); }

# }}}

# sub sec {{{

=head2 sec

    my $sec = $date->sec;

Returns the second.

Second is in the range 0..60. The value of 60 is (maybe) needed for
leap seconds. But I'm not sure if we're going to go there.

=cut

sub sec {
    my $self = shift;
    return ( $self->parsetime )[0];
}

sub second { return sec(@_); }

# }}}

# sub parsetime {{{

=begin internal

 ( $sec, $min, $hour ) = parsetime( $seconds );

Given the number of seconds so far today, returns the seconds,
minutes, and hours of the current time.

=end internal

=cut

sub parsetime {
    my $self = shift;
    my $time = $self->{julsec};

    my $hour = int( $time / 3600 );
    $time -= $hour * 3600;

    my $min = int( $time / 60 );
    $time -= $min * 60;

    return ( int($time), $min, $hour );
} # }}}

# sub julian/jd #{{{

=head2 julian

  my $jd = $date->jd;

Returns a listref, containing two elements. The date as a julian day,
and the time as the number of seconds since midnight. This should not 
be thought of as a real julian day, because it's not. The module is
internally consistent, and that's enough.

This method really only is here for compatibility with previous
versions, as the jd method is now thrown over for plain hash references.

See the file INTERNALS for more information about this internal
format.

=cut

sub jd {
    my $self = shift;

    if ( my $jd = shift ) {
        ( $self->{julian}, $self->{julsec} ) = @$jd;
    }

    return [ $self->{julian}, $self->{julsec} ];
}

sub julian { return jd(@_) }

# INTERNAL ONLY: figures out what the UTC offset (in HHMM) is
# is for the current machine.
sub _calc_local_offset {

    use Time::Local;
    my @t = gmtime;

    my $local = timelocal(@t);
    my $gm    = timegm(@t);

    my $secdiff = $gm - $local;
    return offset_from_seconds($secdiff);
}

#}}}

1;

# More docs {{{

=head1 TODO

=over 4 

=item - add gmtime and localtime methods, perhaps?

=item - Fix the INTERNALS file so that it actually reflects reality

=back

=head1 INTERNALS

Please see the file INTERNALS for discussion on the internals.

=head1 AUTHOR

Rich Bowen (DrBacchus) rbowen@rcbowen.com

And the rest of the Reefknot team. See the source for a full
list of patch contributors and version-by-version notes.

=head1 SEE ALSO

datetime@perl.org mailing list

http://datetime.perl.org/

Time::Local

Net::ICal

=cut

#}}}

