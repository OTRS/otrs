package Schedule::Cron::Events;

use strict;
use Carp 'confess';
use Set::Crontab;
use Time::Local;
use vars qw($VERSION @monthlens);

($VERSION) = ('$Revision: 1.95 $' =~ /([\d\.]+)/ );
@monthlens = ( 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );

## PUBLIC INTERFACE

sub new {
  my $class = shift;
  my $cronline = shift || confess "You must supply a line from a crontab";
  if ($cronline =~ /^\s*#/) { return undef; }
  if ($cronline =~ /^\w+=\S+/) { return undef; }
  if ($cronline !~ /^\s*\S+\s+\S+\s+\S+\s+\S+\s+\S+/) { return undef; }

  # https://rt.cpan.org/Ticket/Display.html?id=53899
  $cronline =~ s/^\s+//g;
  
  my %opts = @_;

  #  0    1    2     3     4    5     6     7     8
  # ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  #
  #                  $mday is the day of the month
  #
  #                        $mon the month in the range 0..11, with 0 indicating
  #                        January and 11 indicating December.
  #
  #                             $year contains the number of years since 1900. 
  #
  my @date;
  if (exists $opts{'Seconds'}) {
    @date = ( localtime($opts{'Seconds'}) )[0..5];
  } elsif (exists $opts{'Date'}) {
    @date = @{ $opts{'Date'} };

    # input validation
    # https://rt.cpan.org/Ticket/Display.html?id=68393
    if ($date[0] < 0 || $date[0] > 59) {
      confess("Invalid value for seconds [" . $date[0] . "]");
    }
    if ($date[1] < 0 || $date[1] > 59) {
      confess("Invalid value for minutes [" . $date[1] . "]");
    }
    if ($date[2] < 0 || $date[2] > 23) {
      confess("Invalid value for hours [" . $date[2] . "]");
    }
    if ($date[3] < 1 || $date[2] > 31) {
      confess("Invalid value for day of month [" . $date[3] . "]");
    }
    if ($date[4] < 0 || $date[4] > 11) {
      confess("Month must be between 0 (January) and 11 (December), got [" . $date[4] . "]");
    }
    if (time() < 2**31 && $date[5] > 137) {
      confess("Year must be less than 137 (for example, if you need 2013 year, pass 113)");
    }
  } else {
    @date = ( localtime(time()) )[0..5];
  }

  chomp($cronline);
  my %ranges = cronLineToRanges($cronline);

  my $self = {
    'ranges' => \%ranges,
    'e' => [],  # the set of possible months
    'f' => [],  # the set of possible days of the month, which varies (e.g. to omit day 31 in June, or to specify days by weekday)
    'g' => [],  # the set of possible hours
    'h' => [],  # the set of possible minutes
    'pa' => 0,  # pointer to which month we are 'currently' on, as far as the counter is concerned 
    'pb' => 0,  # pointer to the day (actually the index of the current element)
    'pc' => 0,  # pointer to the hour
    'pd' => 0,  # pointer to the minute
    'pyear' => 0, # the 'current' year
    'initdate' => \@date,
    'initline' => $cronline,
    'set_e_checked_years' => [],
  };
  
  # now fill the static sets with the sets from Set::Crontab
  @{ $self->{'e'} } = @{ $ranges{'months'} };
  @{ $self->{'g'} } = @{ $ranges{'hours'} };
  @{ $self->{'h'} } = @{ $ranges{'minutes'} };
  bless $self, $class;
  
  $self->resetCounter;
  return $self;
}

sub resetCounter {
  my $self = shift;
  $self->setCounterToDate( @{$self->{'initdate'}} );
}

sub nextEvent {
  my $self = shift || confess "Must be called as a method";
  my @rv = $self->getdate();
  $self->inc_h();
  return @rv;
}

sub previousEvent {
  my $self = shift || confess "Must be called as a method";
  $self->dec_h();
  return $self->getdate();
}

sub setCounterToNow {
  my $self = shift || confess "Must be called as a method";
  $self->setCounterToDate( (localtime(time()))[0..5] );
}

sub setCounterToDate {
  my $self = shift || confess "Must be called as a method";
  unless (@_ == 6) { confess "Must supply a 6-element date list"; }
  
  # add a fudge factor of 60 seconds because cron events happen at the beginning of every minute, at the start of exactly seconds 00
  my ($theMon, $theMday, $theHour, $theMin);
  (undef, $theMin, $theHour, $theMday, $theMon, $self->{'pyear'}) = (localtime(timelocal(@_) + 60))[0..5];
  $theMon++;
  $self->{'pyear'} += 1900;

  # nested ifs... to set the next occurrence time
  my ($exact, $pos) = contains($theMon, @{ $self->{'e'} });
  $self->{'pa'} = $pos;
  if ($exact) {
    $self->set_f();
    ($exact, $pos) = contains($theMday, @{ $self->{'f'} });
    $self->{'pb'} = $pos;
    if ($exact) {
        ($exact, $pos) = contains($theHour, @{ $self->{'g'} });
        $self->{'pc'} = $pos;
        if ($exact) {
          ($exact, $pos) = contains($theMin, @{ $self->{'h'} });
          $self->{'pd'} = $pos;
          if ($pos == -1) { # search wrapped around
            $self->inc_h();
          }
        } else {
          $self->{'pd'} = 0;
          if ($pos == -1) { # search wrapped around
            $self->inc_g();
          }
        }
    } else {
      $self->{'pc'} = 0;
      $self->{'pd'} = 0;
      if ($pos == -1) { # search wrapped around, maybe no valid days this month
        $self->inc_f();
      }
    }
  } else {
    $self->{'pb'} = 0;
    $self->{'pc'} = 0;
    $self->{'pd'} = 0;
    my $rv = $self->set_f();
    if ((! $rv) || ($pos == -1)) {  # search wrapped around or no valid days this month, clock to the next month
      $self->inc_e();
    }
  }

}

sub commandLine {
  my $self = shift || confess "Must be called as a method";
  return $self->{'ranges'}->{'execute'};
}

## Internals only beyond this point

sub cronLineToRanges {
  my $line = shift || confess "Must supply a crontab line";

  my %ranges;
  my @crondate = split(/\s+/, $line, 6);
  if (@crondate < 5) { confess "Could not split the crontab line into enough fields"; }
  
  my $s = new Set::Crontab( $crondate[0], [0..59] );
  $ranges{'minutes'} = [ $s->list() ];
  
  $s = new Set::Crontab( $crondate[1], [0..23] );
  $ranges{'hours'} = [ $s->list() ];
  
  $s = new Set::Crontab( $crondate[2], [0..31] );
  $ranges{'daynums'} = [ $s->list() ];
  if (@{ $ranges{'daynums'} } && ($ranges{'daynums'}->[0] == 0)) {
    shift @{ $ranges{'daynums'} };
  }
  
  $s = new Set::Crontab( $crondate[3], [0..12] );
  $ranges{'months'} = [ $s->list() ];
  if (@{ $ranges{'months'} } && ($ranges{'months'}->[0] == 0)) {
    shift @{ $ranges{'months'} };
  }
  
  $s = new Set::Crontab( $crondate[4], [0..7] );
  $ranges{'weekdays'} = [ $s->list() ];
  if (@{$ranges{'weekdays'}} && $ranges{'weekdays'}->[-1] == 7) {
    pop @{ $ranges{'weekdays'} };
    if ((! @{ $ranges{'weekdays'} }) || $ranges{'weekdays'}->[0] != 0) {
      unshift @{ $ranges{'weekdays'} }, 0;
    }
  }
  
  # emulate cron's logic in determining which days to use
  if ($crondate[2] ne '*' && $crondate[4] ne '*') {
    # leave weekday and daynumber ranges alone, and superimpose
  } elsif ($crondate[2] eq '*' && $crondate[4] ne '*') {
    $ranges{'daynums'} = [];  # restricted by weekday, not daynumber, so only use weekday range
  } elsif ($crondate[4] eq '*' && $crondate[2] ne '*') {
    $ranges{'weekdays'} = []; # restricted by daynumber, so only use daynumber range
  } else {
    $ranges{'weekdays'} = []; # both are '*' so simply use every daynumber
  }
  
  # check that ranges contain things
  foreach (qw(minutes hours months)) {
      unless (@{ $ranges{$_} }) { confess "The $_ range must contain at least one valid value" }
  }
  unless (@{ $ranges{'weekdays'} } || @{ $ranges{'daynums'} }) { confess "The ranges of days (weekdays and monthdays) must contain at least one valid value" }
  
  # sanity checking of ranges here, ensuring they only contain acceptable numbers
  if ($ranges{'minutes'}[-1] > 59) { confess 'minutes only go up to 59'; }
  if ($ranges{'hours'}[-1] > 23) { confess 'hours only go up to 23'; }
  if ($ranges{'months'}[-1] > 12) { confess 'months only go up to 12'; }
  if (@{$ranges{'daynums'}} && $ranges{'daynums'}[-1] > 31) { confess 'daynumber must be 31 or less'; }
  if (@{$ranges{'weekdays'}} && $ranges{'weekdays'}[-1] > 6) { confess 'weekday too large - use 0 to 7'; }

  $ranges{'execute'} = $crondate[5] || '#nothing';
  return %ranges;
}

sub contains {
  my ($val, @set) = @_;
  my $flag = 0;
  while ($flag <= $#set) {
    if ($set[$flag] == $val) {
      TRACE("contains: 1: $set[$flag] == $val");
      return 1, $flag;    
    } elsif ($set[$flag] > $val) {
      TRACE("contains: 0: $set[$flag] > $val");
      return 0, $flag;
    }
    $flag++;
  }
  TRACE("contains: $val not found in <" . join(':', @set) . '>');
  return 0, -1;
}

# return current date on the counter as seconds since epoch
sub getdate {
  my $self = shift || confess "Must be called as a method";
  return (0, $self->{'h'}[$self->{'pd'}], $self->{'g'}[$self->{'pc'}], $self->{'f'}[$self->{'pb'}], $self->{'e'}[$self->{'pa'}]-1, $self->{'pyear'}-1900);
}

# returns a list of days during which next event is possible
sub set_f {
  my $self = shift || confess "Must be called as a method";

  my $flag = _isLeapYear($self->{'pyear'});
  my $monthnum = $self->{'e'}[$self->{'pa'}];
  my $maxday = $monthlens[$monthnum];
  if ($monthnum == 2) { $maxday += $flag; }
  
  my %days = map { $_ => 1 } @{ $self->{'ranges'}{'daynums'} };
  foreach (29, 30, 31) {
    if ($_ > $maxday) { delete $days{$_}; }
  }
  
  # get which weekday is the first of the month
  my $startday = _DayOfWeek($monthnum, 1, $self->{'pyear'});
  # add in, if needed, the selected weekdays
  foreach my $daynum (@{ $self->{'ranges'}{'weekdays'} }) {
    my $offset = $daynum - $startday; # 0 - 6 = -6; start on Saturday, want a Sunday 
    for my $week (1, 8, 15, 22, 29, 36) {
      my $monthday = $week + $offset;
      next if $monthday < 1;
      next if $monthday > $maxday;
      $days{$monthday} = 1;
    }
  }

  @{ $self->{'f'} } = sort { $a <=> $b } keys %days;
  return scalar @{ $self->{'f'} };
}

# routines to increment the counter
sub inc_h {
  my $self = shift || confess "Must be called as a method";
  $self->{'pd'}++;
  if ($self->{'pd'} == 0 || $self->{'pd'} > $#{$self->{'h'}}) {
    $self->{'pd'} = 0;
    $self->inc_g();
  }
}

sub inc_g {
  my $self = shift || confess "Must be called as a method";
  $self->{'pc'}++;
  if ($self->{'pc'} == 0 || $self->{'pc'} > $#{$self->{'g'}}) {
    $self->{'pc'} = 0;
    $self->inc_f();
  }
}

sub inc_f {
  my $self = shift || confess "Must be called as a method";
  $self->{'pb'}++;
  if ($self->{'pb'} == 0 || $self->{'pb'} > $#{$self->{'f'}}) {
    $self->{'pb'} = 0;
    $self->inc_e();
  }
}

# increments currents month, skips to the next year
# when no months left during the current year
#
# if there're no possible months during 5 years in a row, bails out:
# https://rt.cpan.org/Public/Bug/Display.html?id=109246
#
sub inc_e {
  my $self = shift || confess "Must be called as a method";
  $self->{'pa'}++;
  if ($self->{'pa'} == 0 || $self->{'pa'} > $#{$self->{'e'}}) {
    $self->{'pa'} = 0;
    $self->{'pyear'}++;

    # https://rt.cpan.org/Public/Bug/Display.html?id=109246
    push (@{$self->{'set_e_checked_years'}}, $self->{'pyear'});
    if (scalar(@{$self->{'set_e_checked_years'}} > 5)) {
      confess("Cron line [" . $self->{'initline'} . "] does not define any valid point in time, checked years: [" .
          join(",", @{$self->{'set_e_checked_years'}}) .
          "] (ex, 31th of February) ");
    }
  }
  my $rv = $self->set_f();
  unless ($rv) { ###
    $self->inc_e;
  }

  $self->{'set_e_checked_years'} = [];
}


# and to decrement it
sub dec_h {
  my $self = shift || confess "Must be called as a method";
  $self->{'pd'}--;
  if ($self->{'pd'} == -1) {
    $self->{'pd'} = $#{$self->{'h'}};
    $self->dec_g();
  }
}

sub dec_g {
  my $self = shift || confess "Must be called as a method";
  $self->{'pc'}--;
  if ($self->{'pc'} == -1) {
    $self->{'pc'} = $#{$self->{'g'}};
    $self->dec_f();
  }
}

sub dec_f {
  my $self = shift || confess "Must be called as a method";
  $self->{'pb'}--;
  if ($self->{'pb'} == -1) {
    $self->{'pb'} = $#{$self->{'f'}};
    $self->dec_e();
  }
}

sub dec_e {
  my $self = shift || confess "Must be called as a method";
  $self->{'pa'}--;
  if ($self->{'pa'} == -1) {
    $self->{'pa'} = $#{$self->{'e'}};
    $self->{'pyear'}--;
  }
  my $rv = $self->set_f();
  unless ($rv) { ###
    $self->dec_e;
  }
  $self->{'pb'} = $#{$self->{'f'}};
}

# These two routines courtesy of B Paulsen
sub _isLeapYear {
  my $year = shift;
  return  !($year % 400) || ( !( $year % 4 ) && ( $year % 100 ) ) ? 1 : 0;
}

sub _DayOfWeek {
  my ( $month, $day, $year ) = @_;
  
  my $flag = _isLeapYear( $year );
  my @months = (
    $flag ? 0 : 1,
    $flag ? 3 : 4,
    4, 0, 2, 5, 0, 3, 6, 1, 4, 6 );
  my @century = ( 4, 2, 0, 6 );
  
  my $dow = $year % 100;
  $dow += int( $dow / 4 );
  $dow += $day + $months[$month-1];
  $dow += $century[ ( int($year/100) - 1 ) % 4 ];
  
  return ($dow-1) % 7;
}

sub TRACE {}

1;

__END__

=pod

=head1 NAME

Schedule::Cron::Events - take a line from a crontab and find out when events will occur

=head1 SYNOPSIS

  use Schedule::Cron::Events;
  my @mon = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

  # a crontab line which triggers an event every 5 minutes
  # initialize the counter with the current time
  my $cron1 = new Schedule::Cron::Events( '*/5 * * * * /bin/foo', Seconds => time() );

  # or initialize it with a date, for example 09:51:13 on 21st June, 2002
  my $cron2 = new Schedule::Cron::Events( '*/5 * * * * /bin/foo', Date => [ 13, 51, 9, 21, 5, 102 ] );

  # you could say this too, to use the current time:
  my $cron = new Schedule::Cron::Events( '*/5 * * * * /bin/foo',  Date => [ ( localtime(time()) )[0..5] ] );

  # find the next execution time
  my ($sec, $min, $hour, $day, $month, $year) = $cron->nextEvent;
  printf("Event will start next at %2d:%02d:%02d on %d %s, %d\n", $hour, $min, $sec, $day, $mon[$month], ($year+1900));

  # find the following occurrence of the job
  ($sec, $min, $hour, $day, $month, $year) = $cron->nextEvent;
  printf("Following event will start at %2d:%02d:%02d on %d %s, %d\n", $hour, $min, $sec, $day, $mon[$month], ($year+1900));

  # reset the counter back to the original date given to new()
  $cron->resetCounter;

  # find out when the job would have last run
  ($sec, $min, $hour, $day, $month, $year) = $cron->previousEvent;
  printf("Last event started at %2d:%02d:%02d on %d %s, %d\n", $hour, $min, $sec, $day, $mon[$month], ($year+1900));

  # see when the job would have next run at a point in time
  $cron->setCounterToDate(0, 18, 1, 26, 9, 85); # that's 26th October, 1985
  ($sec, $min, $hour, $day, $month, $year) = $cron->nextEvent;
  printf("Event did start at %2d:%02d:%02d on %d %s, %d\n", $hour, $min, $sec, $day, $mon[$month], ($year+1900));

  # turn a local date into a Unix time
  use Time::Local;
  my $epochSecs = timelocal($sec, $min, $hour, $day, $month, $year);
  print "...or that can be expressed as " . $epochSecs . " seconds which is " . localtime($epochSecs) . "\n";

Here is a sample of the output produced by that code:

  Event will start next at  0:45:00 on 28 Aug, 2002
  Following event will start at  0:50:00 on 28 Aug, 2002
  Last event started at  0:40:00 on 28 Aug, 2002
  Event did start at  1:20:00 on 26 Oct, 1985
  ...or that can be expressed as 499134000 seconds which is Sat Oct 26 01:20:00 1985

Note that results will vary according to your local time and timezone.

=head1 DESCRIPTION

Given a line from a crontab, tells you the time at which cron will next run the line, or when the last event
occurred, relative to any date you choose. The object keeps that reference date internally, 
and updates it when you call nextEvent() or previousEvent() - such that successive calls will
give you a sequence of events going forward, or backwards, in time.

Use setCounterToNow() to reset this reference time to the current date on your system,
or use setCounterToDate() to set the reference to any arbitrary time, or resetCounter()
to take the object back to the date you constructed it with.

This module uses Set::Crontab to understand the date specification, so we should be able to handle all
forms of cron entries.

=head1 METHODS

In the following, DATE_LIST is a list of 6 values suitable for passing to Time::Local::timelocal()
which are the same as the first 6 values returned by the builtin localtime(), namely 
these 6 numbers in this order

=over 4

=item * seconds

a number 0 .. 59

=item * minutes

a number 0 .. 59

=item * hours

a number 0 .. 23

=item * dayOfMonth

a number 0 .. 31

=item * month

a number 0 .. 11 - January is *0*, December is *11*

=item * year

the desired year number *minus 1900*

=back

=over 4

=item new( CRONTAB_ENTRY, Seconds => REFERENCE_TIME, Date => [ DATE_LIST ] )

Returns a new object for the specified line from the crontab. The first 5 fields of the line
are actually parsed by Set::Crontab, which should be able to handle the original crontab(5) ranges
as well as Vixie cron ranges and the like. It's up to you to supply a valid line - if you supply
a comment line, an environment variable setting line, or a line which does not seem to begin with
5 fields (e.g. a blank line), this method returns undef.

Give either the Seconds option or the Date option, not both.
Supply a six-element array (as described above) to specify the date at which you want to start.
Alternatively, the reference time is the number of seconds since the epoch for the time you want to 
start looking from.

If neither of the 'Seconds' and 'Date' options are given we use the current time().

=item resetCounter()

Resets the object to the state when created (specifically resetting the internal counter to the 
initial date provided)

=item nextEvent()

Returns a DATE_LIST for the next event following the current reference time.
Updates the reference time to the time of the event.

=item previousEvent()

Returns a DATE_LIST for the last event preceding the current reference time.
Updates the reference time to the time of the event.

=item setCounterToNow()

Sets the reference time to the current time.

=item setCounterToDate( DATE_LIST )

Sets the reference time to the time given, specified in seconds since the epoch.

=item commandLine()

Returns the string that is the command to be executed as specified in the crontab - i.e. without the leading
date specification.

=back

=head1 ERROR HANDLING

If something goes wrong the general approach is to raise a fatal error with confess() so use
eval {} to trap these errors. If you supply a comment line to the constructor then you'll simply get back
undef, not a fatal error. If you supply a line like 'foo bar */15 baz qux /bin/false' you'll get a confess().

=head1 DEPENDENCIES

Set::Crontab, Time::Local, Carp. Date::Manip is no longer required thanks to B Paulsen.

=head1 MAINTENANCE

Since January 2012 maintained by Petya Kohts (petya.kohts at gmail.com)

=head1 COPYRIGHT

Copyright 2002 P Kent

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself. 

=cut
