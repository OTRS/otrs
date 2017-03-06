package Date::ICal::Duration;

use strict;
use Carp;

use vars qw($VERSION );
$VERSION = (qw'$Revision: 1.61 $')[1];

# Documentation {{{

=head1 NAME

Date::ICal::Duration - durations in iCalendar format, for math purposes.

=head1 VERSION

$Revision: 1.61 $

=head1 SYNOPSIS

    use Date::ICal::Duration;

    $d = Date::ICal::Duration->new( ical => '-P1W3DT2H3M45S' );

    $d = Date::ICal::Duration->new( weeks => 1, 
                                    days => 1,
                                    hours => 6,
                                    minutes => 15,
                                    seconds => 45); 

    # a one hour duration, without other components
    $d = Date::ICal::Duration->new( seconds => "3600"); 

    # Read-only accessors:
    $d->weeks;
    $d->days;
    $d->hours;
    $d->minutes;
    $d->seconds;
    $d->sign;

    # TODO: Resolve sign() discussion from rk-devel and update synopsis.
    
    $d->as_seconds ();   # returns just seconds
    $d->as_elements ();  # returns a hash of elements, like the accessors above
    $d->as_ical();       # returns an iCalendar duration string
    
=head1 DESCRIPTION

This is a trivial class for representing duration objects, for doing math
in Date::ICal

=head1 AUTHOR

Rich Bowen, and the Reefknot team. Alas, Reefknot is no more. See
http://datetime.perl.org/ for more modern modules.

Last touched by $Author: rbowen $

=head1 METHODS

Date::ICal::Duration has the following methods available:

=head2 new

A new Date::ICal::Duration object can be created with an iCalendar string :

    my $ical = Date::ICal::Duration->new ( ical => 'P3W2D' );
    # 3 weeks, 2 days, positive direction
    my $ical = Date::ICal::Duration->new ( ical => '-P6H3M30S' );
    # 6 hours, 3 minutes, 30 seconds, negative direction
    
Or with a number of seconds:

    my $ical = Date::ICal::Duration->new ( seconds => "3600" );
    # one hour positive

Or, better still, create it with components

    my $date = Date::ICal::Duration->new ( 
                           weeks => 6, 
                           days => 2, 
                           hours => 7,
                           minutes => 15,
                           seconds => 47,
                           sign => "+"
                           );

The sign defaults to "+", but "+" and "-" are legal values. 
                           
=cut

#}}}

#{{{ sub new

sub new {
    my ($class, %args) = @_;
    my $verified = {};
    my $self = {};
    bless $self, $class;

    my $seconds_only = 1;    # keep track of whether we were given length in seconds only
    $seconds_only = 0 unless (defined $args{'seconds'}); 

    # If one of the attributes is negative, then they all must be
    # negative. Otherwise, we're not sure what this means.
    foreach (qw(hours minutes seconds days weeks)) {
        if (defined($args{$_}) )   {
            # make sure this argument is all digits, optional - sign
            if ($args{$_} =~ m/-?[0-9]+$/) { 
                if ($args{$_} < 0) {
                    $args{sign} = '-';
                    $args{$_} = abs($args{$_});
                }
                $verified->{$_} = $args{$_};
                unless ($_ eq 'seconds') {
                    $seconds_only = 0;
                }
            } else {
                carp ("Parameter $_ contains non-numeric value " . $args{$_} . "\n");
            }
        }
    }

    if (defined ($args{sign}) ) {

        # make sure this argument + or -
        if ($args{sign} =~ m/[+-]/) {
            # if so, assign it
            $self->{sign} = ($args{sign} eq "+") ? 1 : -1;
            $verified->{sign} = ($args{sign} eq "+") ? '+' : '-';
        } else {
            carp ("Parameter sign contains a value other than + or - : "
                . $args{sign} . "\n");
        }
        
    }

    # If a number is given, convert it to hours, minutes, and seconds,
    # but *don't* extract days -- we want it to represent an absolute
    # amount of time, regardless of timezone
    if ($seconds_only) { # if we were given an integer time_t
        $self->_set_from_seconds($args{'seconds'});
    } elsif (defined ($args{'ical'}) ) {   
        # A standard duration string
        #warn "setting from ical\n";
        $self->_set_from_ical($args{'ical'});
    } elsif (not $seconds_only) {
        #warn "setting from components";
        #use Data::Dumper; warn Dumper $verified;
        $self->_set_from_components($verified);
    }
    
    return undef unless %args;
   
    return $self;
}

#}}}

# Accessors {{{

=head2 sign, weeks, days, hours, minutes, seconds

Read-only accessors for the elements of the object. 

=cut 

#}}}

# {{{ sub sign 

sub sign {
    my ($self) = @_;
    return $self->{sign};
}

#}}}

# {{{ sub weeks 

sub weeks {
    my ($self) = @_;
    my $w = ${$self->_wd}[0];
    return unless $w;
    return $self->{sign} * $w;
}

#}}}

# {{{ sub days 

sub days {
    my ($self) = @_;
    my $d = ${$self->_wd}[1];
    return unless $d;
    return  $self->{sign} * $d;

} #}}}

#{{{ sub hours 

sub hours {
    my ($self) = @_;
    my $h = ${$self->_hms}[0];
    return unless $h;
    return $self->{sign} * $h;
}

#}}}

# {{{ sub minutes 

sub minutes {
    my ($self) = @_;
    my $m = ${$self->_hms}[1];
    return unless $m;
    return $self->{sign} * $m;
}

#}}}

# {{{ sub seconds 

sub seconds {
    my ($self) = @_;
    my $s = ${$self->_hms}[2];
    return unless $s;
    return $self->{sign} * $s;
}

#}}}

# sub as_seconds {{{

=head2 as_seconds

Returns the duration in raw seconds. 

WARNING -- this folds in the number of days, assuming that they are always 86400
seconds long (which is not true twice a year in areas that honor daylight
savings time).  If you're using this for date arithmetic, consider using the
I<add()> method from a L<Date::ICal> object, as this will behave better.
Otherwise, you might experience some error when working with times that are
specified in a time zone that observes daylight savings time.


=cut 

sub as_seconds {
    my ($self) = @_;

    my $nsecs = $self->{nsecs} || 0;
    my $ndays = $self->{ndays} || 0;
    my $sign  = $self->{sign}  || 1;
    return $sign*($nsecs+($ndays*24*60*60));
}

#}}}

# sub as_days {{{

=head2 as_days

    $days = $duration->as_days;

Returns the duration as a number of days. Not to be confused with the
C<days> method, this method returns the total number of days, rather
than mod'ing out the complete weeks. Thus, if we have a duration of 33
days, C<weeks> will return 4, C<days> will return 5, but C<as_days> will
return 33.

Note that this is a lazy convenience function which is just weeks*7 +
days.

=cut

sub as_days {
    my ($self) = @_;
    my $wd = $self->_wd;
    return $self->{sign} * ( $wd->[0]*7 + $wd->[1] );
}# }}}

#{{{ sub as_ical 

=head2 as_ical

Return the duration in an iCalendar format value string (e.g., "PT2H0M0S")

=cut 

sub as_ical {
    my ($self) = @_;

    my $tpart = '';

    if (my $ar_hms = $self->_hms) {
        $tpart = sprintf('T%dH%dM%dS', @$ar_hms);
    }

    my $ar_wd = $self->_wd();
    
    my $dpart = '';
    if (defined $ar_wd) {
        my ($weeks, $days) = @$ar_wd;
        if ($weeks && $days) {
            $dpart = sprintf('%dW%dD', $weeks, $days);
        } elsif ($weeks) {   # (if days = 0)
            $dpart = sprintf('%dW', $weeks);
        } else {
            $dpart = sprintf('%dD', $days);
        }
    }

    # put a sign in the return value if necessary
    my $value = join('', (($self->{sign} < 0) ? '-' : ''),
                     'P', $dpart, $tpart);

    # remove any zero components from the time string (-P10D0H -> -P10D)
    $value =~ s/(?<=[^\d])0[WDHMS]//g;

    # return either the time value or PT0S (if the time value is zero).
    return (($value !~ /PT?$/) ? $value : 'PT0S');
}

#}}}

#{{{ sub as_elements

=head2 as_elements

Returns the duration as a hashref of elements. 

=cut 

sub as_elements {
    my ($self) = @_;
   
    # get values for all the elements
    my $wd = $self->_wd;
    my $hms = $self->_hms;
   
    my $return = {
        sign => $self->{sign}, 
        weeks => ${$wd}[0],
        days => ${$wd}[1],
        hours => ${$hms}[0],
        minutes => ${$hms}[1],
        seconds => ${$hms}[2],
    };
    return $return;
}

#}}}

# INTERNALS {{{

=head1 INTERNALS

head2 GENERAL MODEL

Internally, we store 3 data values: a number of days, a number of seconds (anything
shorter than a day), and a sign (1 or -1). We are assuming that a day is 24 hours for
purposes of this module; yes, we know that's not completely accurate because of
daylight-savings-time switchovers, but it's mostly correct. Suggestions are welcome.

NOTE: The methods below SHOULD NOT be relied on to stay the same in future versions.

=head2 _set_from_ical ($self, $duration_string)

Converts a RFC2445 DURATION format string to the internal storage format.

=cut

#}}}

# sub _set_from_ical (internal) {{{

sub _set_from_ical {
    my ($self, $str) = @_;

    my $parsed_values = _parse_ical_string($str);
    
    return $self->_set_from_components($parsed_values);
} # }}}

# sub _parse_ical_string (internal) {{{

=head2 _parse_ical_string ($string)

Regular expression for parsing iCalendar into usable values. 

=cut

sub _parse_ical_string {
    my ($str) = @_;
    
    # RFC 2445 section 4.3.6
    #
    # dur-value  = (["+"] / "-") "P" (dur-date / dur-time / dur-week)
    # dur-date   = dur-day [dur-time]
    # dur-time   = "T" (dur-hour / dur-minute / dur-second)
    # dur-week   = 1*DIGIT "W"
    # dur-hour   = 1*DIGIT "H" [dur-minute]
    # dur-minute = 1*DIGIT "M" [dur-second]
    # dur-second = 1*DIGIT "S"
    # dur-day    = 1*DIGIT "D"

    my ($sign_str, $magic, $weeks, $days, $hours, $minutes, $seconds) =
        $str =~ m{
            ([\+\-])?   (?# Sign)
            (P)     (?# 'P' for period? This is our magic character)
            (?:
                (?:(\d+)W)? (?# Weeks)
                (?:(\d+)D)? (?# Days)
            )?
            (?:T        (?# Time prefix)
                (?:(\d+)H)? (?# Hours)
                (?:(\d+)M)? (?# Minutes)
                (?:(\d+)S)? (?# Seconds)
            )?
        }x;

    if (!defined($magic)) {
        carp "Invalid duration: $str";
        return undef;
    }

    # make sure the sign gets set, and turn it into an integer multiplier
    $sign_str ||= "+";
    my $sign = ($sign_str eq "-") ? -1 : 1;
    
    my $return = {};
    $return->{'weeks'} = $weeks;
    $return->{'days'} = $days;
    $return->{'hours'} = $hours;
    $return->{'minutes'} = $minutes;
    $return->{'seconds'} = $seconds;
    $return->{'sign'} = $sign;

    return $return;
} # }}}

# sub _set_from_components (internal) {{{

=head2 _set_from_components ($self, $hashref)

Converts from a hashref to the internal storage format.
The hashref can contain elements "sign", "weeks", "days", "hours", "minutes", "seconds".

=cut

sub _set_from_components {
    my ($self, $args) = @_;

    # Set up some easier-to-read variables
    my ($sign, $weeks, $days, $hours, $minutes, $seconds);
    $sign = $args->{'sign'};
    $weeks = $args->{'weeks'};
    $days = $args->{'days'};
    $hours = $args->{'hours'};
    $minutes = $args->{'minutes'};
    $seconds = $args->{'seconds'};
    
    $self->{sign} = (defined($sign) && $sign eq '-') ? -1 : 1;

    if (defined($weeks) or defined($days)) {
        $self->_wd([$weeks || 0, $days || 0]);
    }

    if (defined($hours) || defined($minutes) || defined($seconds)) {
        $self->_hms([$hours || 0, $minutes || 0, $seconds || 0]);
    }

    return $self;
} # }}}

# sub _set_from_ical (internal) {{{

=head2 _set_from_ical ($self, $num_seconds)

Sets internal data storage properly if we were only given seconds as a parameter.

=cut

sub _set_from_seconds {
    my ($self, $seconds) = @_;
            
    $self->{sign} = (($seconds < 0) ? -1 : 1);
    # find the number of days, if any
    my $ndays = int ($seconds / (24*60*60));
    # now, how many hours/minutes/seconds are there, after
    # days are taken out?
    my $nsecs = $seconds % (24*60*60);
    $self->{ndays} = abs($ndays);
    $self->{nsecs} = abs($nsecs);


    return $self;
} # }}}

# sub _hms (internal) {{{

=head2 $self->_hms();

Return an arrayref to hours, minutes, and second components, or undef
if nsecs is undefined.  If given an arrayref, computes the new nsecs value 
for the duration.  

=cut 

sub _hms {
    my ($self, $hms_arrayref) = @_;

    if (defined($hms_arrayref)) {
        my $new_sec_value = $hms_arrayref->[0]*3600 +
                            $hms_arrayref->[1]*60   + $hms_arrayref->[2];
        $self->{nsecs} = ($new_sec_value);
    } 

    my $nsecs = $self->{nsecs};
    if (defined($nsecs)) {
        my $hours = int($nsecs/3600);
        my $minutes  = int(($nsecs-$hours*3600)/60);
        my $seconds  = $nsecs % 60;
        return [ $hours, $minutes, $seconds ];
    } else {
        print "returning undef\n";
        return undef;
    }
} # }}}

# sub _wd (internal) {{{

=head2 $self->_wd() 

Return an arrayref to weeks and day components, or undef if ndays
is undefined.  If Given an arrayref, computs the new ndays value
for the duration.  

=cut 

sub _wd  {
    my ($self, $wd_arrayref) = @_;

    #print "entering _wd\n";
    
    if (defined($wd_arrayref)) {
        
        my $new_ndays = $wd_arrayref->[0]*7 + $wd_arrayref->[1];
        $self->{ndays} = $new_ndays;
    }
    
    #use Data::Dumper; print Dumper $self->{ndays};
    
    if (defined(my $ndays= $self->{ndays})) {
        my $weeks = int($ndays/7);
        my $days  = $ndays % 7;
        return [ $weeks, $days ];
    } else {
        return undef;
    }
} # }}}

1;
