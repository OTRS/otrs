# --
# Kernel/System/GenericAgent.pm - generic agent system module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: GenericAgent.pm,v 1.2 2004-07-18 00:53:14 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::GenericAgent;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    my %Map = (
      TicketNumber => 'SCALAR',
      From => 'SCALAR',
      To => 'SCALAR',
      Cc  => 'SCALAR',
      Subject  => 'SCALAR',
      Body  => 'SCALAR',
      CustomerID  => 'SCALAR',
      CustomerUserLogin  => 'SCALAR',
      Agent  => 'SCALAR',
      TimeSearchType => 'SCALAR',
      TicketCreateTimePointFormat  => 'SCALAR',
      TicketCreateTimePoint  => 'SCALAR',
      TicketCreateTimePointStart  => 'SCALAR',
      TicketCreateTimeStart => 'SCALAR',
      TicketCreateTimeStartDay => 'SCALAR',
      TicketCreateTimeStartMonth => 'SCALAR',
      TicketCreateTimeStartYear => 'SCALAR',
      TicketCreateTimeStop => 'SCALAR',
      TicketCreateTimeStopDay => 'SCALAR',
      TicketCreateTimeStopMonth => 'SCALAR',
      TicketCreateTimeStopYear => 'SCALAR',
      TicketCreateTimeStop  => 'SCALAR',
      TicketCreateTimeStopDay  => 'SCALAR',
      TicketCreateTimeStopMonth  => 'SCALAR',
      TicketCreateTimeStopYear  => 'SCALAR',
      NewCustomerID => 'SCALAR',
      NewCustomerUserLogin => 'SCALAR',
      StateIDs => 'ARRAY',
      StateTypeIDs => 'ARRAY',
      QueueIDs => 'ARRAY',
      PriorityIDs => 'ARRAY',
      UserIDs => 'ARRAY',
      LockIDs => 'ARRAY',
      NewStateID => 'SCALAR',
      NewQueueID => 'SCALAR',
      NewPriorityID => 'SCALAR',
      NewUserID => 'SCALAR',
      NewLockID => 'SCALAR',
      TicketFreeKey1 => 'ARRAY',
      TicketFreeText1 => 'ARRAY',
      TicketFreeKey2 => 'ARRAY',
      TicketFreeText2 => 'ARRAY',
      TicketFreeKey3 => 'ARRAY',
      TicketFreeText3 => 'ARRAY',
      TicketFreeKey4 => 'ARRAY',
      TicketFreeText4 => 'ARRAY',
      TicketFreeKey5 => 'ARRAY',
      TicketFreeText5 => 'ARRAY',
      TicketFreeKey6 => 'ARRAY',
      TicketFreeText6 => 'ARRAY',
      TicketFreeKey7 => 'ARRAY',
      TicketFreeText7 => 'ARRAY',
      TicketFreeKey8 => 'ARRAY',
      TicketFreeText8 => 'ARRAY',
      'TimeSearchType::None' => 'SCALAR',
      TicketCreateTimeStopDay => 'SCALAR',
      TicketCreateTimeStartYear => 'SCALAR',
      TicketCreateTimePoint => 'SCALAR',
      TicketCreateTimeStopYear => 'SCALAR',
      TicketCreateTimeStartDay => 'SCALAR',
      TicketCreateTimeStartMonth => 'SCALAR',
      TicketCreateTimeStopMonth => 'SCALAR',
      ScheduleLastRun => 'SCALAR',
      ScheduleLastRunUnixTime => 'SCALAR',
      ScheduleDays => 'ARRAY',
      ScheduleMinutes => 'ARRAY',
      ScheduleHours => 'ARRAY',
    );

    $Self->{Map} = \%Map;

    return $Self;
}
# --
sub JobList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my $SQL = "SELECT job_name FROM generic_agent_jobs";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    my %Data = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{$Row[0]} = $Row[0];
    }
    return %Data;
}
# --
sub JobGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my $SQL = "SELECT job_key, job_value FROM generic_agent_jobs".
       " WHERE ".
       " job_name = '".$Self->{DBObject}->Quote($Param{Name})."'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    my %Data = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Self->{Map}->{$Row[0]} && $Self->{Map}->{$Row[0]} eq 'ARRAY') {
            push(@{$Data{$Row[0]}}, $Row[1]);
        }
        else {
            $Data{$Row[0]} = $Row[1];
        }
    }
    foreach my $Key (keys %Data) {
        if ($Key =~ /(NewParam)Key(\d)/) {
            $Data{"New$Data{$Key}"} = $Data{"$1Value$2"} if ($Data{"$1Value$2"});
print STDERR "New$Data{$Key}: ".$Data{"$1Value$2"}."\n";
        }
    }
    # get time settings
    if ($Data{'TimeSearchType::None'}) {
         # do noting ont time stuff
         foreach (qw(TicketCreateTimeStartMonth TicketCreateTimeStopMonth TicketCreateTimeStopDay TicketCreateTimeStartDay TicketCreateTimeStopYear TicketCreateTimePoint TicketCreateTimeStartYear TicketCreateTimePointFormat TicketCreateTimePointStart)) {
             delete ($Data{$_});
         }
    }
    if ($Data{'TimeSearchType::TimeSlot'}) {
        foreach (qw(TicketCreateTimePoint TicketCreateTimePointFormat TicketCreateTimePointStart)) {
             delete ($Data{$_});
        }
        foreach (qw(Month Day)) {
           if ($Data{"TicketCreateTimeStart$_"} <= 9) {
               $Data{"TicketCreateTimeStart$_"} = '0'.$Data{"TicketCreateTimeStart$_"};
           }
        }
        foreach (qw(Month Day)) {
            if ($Data{"TicketCreateTimeStop$_"} <= 9) {
               $Data{"TicketCreateTimeStop$_"} = '0'.$Data{"TicketCreateTimeStop$_"};
            }
        }
        if ($Data{TicketCreateTimeStartDay} && $Data{TicketCreateTimeStartMonth} && $Data{TicketCreateTimeStartYear}) {
            $Data{TicketCreateTimeNewerDate} = $Data{TicketCreateTimeStartYear}.
              '-'.$Data{TicketCreateTimeStartMonth}.
              '-'.$Data{TicketCreateTimeStartDay}.
              ' 00:00:01';
        }
        if ($Data{TicketCreateTimeStopDay} && $Data{TicketCreateTimeStopMonth} && $Data{TicketCreateTimeStopYear}) {
            $Data{TicketCreateTimeOlderDate} = $Data{TicketCreateTimeStopYear}.
              '-'.$Data{TicketCreateTimeStopMonth}.
              '-'.$Data{TicketCreateTimeStopDay}.
              ' 23:59:59';
        }
    }
    if ($Data{'TimeSearchType::TimePoint'}) {
        foreach (qw(TicketCreateTimeStartMonth TicketCreateTimeStopMonth TicketCreateTimeStopDay TicketCreateTimeStartDay TicketCreateTimeStopYear TicketCreateTimeStartYear)) {
            delete ($Data{$_});
        }
        if ($Data{TicketCreateTimePoint} && $Data{TicketCreateTimePointStart} && $Data{TicketCreateTimePointFormat}) {
            my $Time = 0;
            if ($Data{TicketCreateTimePointFormat} eq 'day') {
                $Time = $Data{TicketCreateTimePoint} * 60 * 24;
            }
            elsif ($Data{TicketCreateTimePointFormat} eq 'week') {
                $Time = $Data{TicketCreateTimePoint} * 60 * 24 * 7;
            }
            elsif ($Data{TicketCreateTimePointFormat} eq 'month') {
                $Time = $Data{TicketCreateTimePoint} * 60 * 24 * 30;
            }
            elsif ($Data{TicketCreateTimePointFormat} eq 'year') {
                $Time = $Data{TicketCreateTimePoint} * 60 * 24 * 356;
            }
            if ($Data{TicketCreateTimePointStart} eq 'Before') {
                $Data{TicketCreateTimeOlderMinutes} = $Time;
            }
            else {
                $Data{TicketCreateTimeNewerMinutes} = $Time;
            }
        }
    }
    return %Data;
}
# --
sub JobAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name Data)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    foreach my $Key (keys %{$Param{Data}}) {
        if (ref($Param{Data}->{$Key}) eq 'ARRAY') {
          foreach (@{$Param{Data}->{$Key}}) {
          if (defined($_)) {
            my $SQL = "INSERT INTO generic_agent_jobs (job_name, ".
              "job_key, job_value) VALUES ".
              " ('".$Self->{DBObject}->Quote($Param{Name})."', '$Key', '".
              $Self->{DBObject}->Quote($_)."')";
            $Self->{DBObject}->Do(SQL => $SQL);
          }
          }
        }
        else {
            if ($Param{Data}->{$Key}) {
            my $SQL = "INSERT INTO generic_agent_jobs (job_name, ".
              "job_key, job_value) VALUES ".
              " ('".$Self->{DBObject}->Quote($Param{Name})."', '$Key', '".
              $Self->{DBObject}->Quote($Param{Data}->{$Key})."')";
            $Self->{DBObject}->Do(SQL => $SQL);
            }
        }
    }
    return 1;
}
# --
sub JobDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # delete job
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM generic_agent_jobs WHERE ".
            "job_name = '".$Self->{DBObject}->Quote($Param{Name})."'",
    );
    return 1;
}
# --

1;
