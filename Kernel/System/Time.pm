# --
# Kernel/System/Time.pm - time functions
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Time.pm,v 1.5 2004-08-19 11:22:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Time;

use strict;
use Time::Local;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.5 $';
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

  my $TimeObject = Kernel::System::Time->new(
      ConfigObject => $ConfigObject,
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
    foreach (qw(ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    # 0=off; 1=on;
    $Self->{Debug} = 0;

    $Self->{TimeZone} = $Self->{ConfigObject}->Get('TimeZone') || 0;
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

returns a time stamp in "yyyy-mm-dd 24:60:60" format.

    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $SystenTime,
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
    return "$Year-$Month-$Day $Hour:$Min:$Sec";
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
    # match europ time format
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
1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.5 $ $Date: 2004-08-19 11:22:55 $

=cut
