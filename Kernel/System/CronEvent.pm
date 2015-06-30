# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CronEvent;

use strict;
use warnings;

use Schedule::Cron::Events;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Time',
);

=head1 NAME

Kernel::System::CronEvent - Cron Events wrapper functions

=head1 SYNOPSIS

Functions to calculate cron events time.

=over 4

=cut

=item new()

create a CronEvent object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CronEventObject = $Kernel::OM->Get('Kernel::System::CronEvent');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item NextEventGet()

gets the time when the next cron event should occur, from a given time.

    my $EventSystemTime = $CronEventObject->NextEventGet(
        Schedule  => '*/2 * * * *',    # recurrence parameters based in cron notation
        StartTime => '1423165100',     # optional, defaults to current time
    );

Returns:

    my $EventSystemTime = 1423165220;  # or false in case of an error

=cut

sub NextEventGet {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{Schedule} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Schedule!",
        );

        return;
    }

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $StartTime = $Param{StartTime} || $TimeObject->SystemTime();

    return if !$StartTime;

    # init cron object
    my $CronObject = $Self->_Init(
        Schedule  => $Param{Schedule},
        StartTime => $StartTime,
    );

    return if !$CronObject;

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $CronObject->nextEvent();

    # it is needed to add 1 to the month for correct calculation
    my $SystemTime = $TimeObject->Date2SystemTime(
        Year   => $Year + 1900,
        Month  => $Month + 1,
        Day    => $Day,
        Hour   => $Hour,
        Minute => $Min,
        Second => $Sec,
    );

    return $SystemTime;
}

=item NextEventList()

gets the time when the next cron events should occur, from a given time on a defined range.

    my @NextEvents = $CronEventObject->NextEventList(
        Schedule  => '*/2 * * * *',           # recurrence parameters based in cron notation
        StartTime => '1423165100',            # optional, defaults to current time
        StopTime  => '1423165300',
    );

Returns:

    my @NextEvents = [ '1423165220', ...  ];  # or false in case of an error

=cut

sub NextEventList {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Schedule StopTime)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $StartTime = $Param{StartTime} || $TimeObject->SystemTime();

    return if !$StartTime;

    if ( $StartTime > $Param{StopTime} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "StartTime must be lower than or equals to StopTime",
        );

        return;
    }

    # init cron object
    my $CronObject = $Self->_Init(
        Schedule  => $Param{Schedule},
        StartTime => $StartTime,
    );

    return if !$CronObject;

    my $SystemTime = $StartTime;

    my @Result;

    LOOP:
    while (1) {

        my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $CronObject->nextEvent();

        # it is needed to add 1 to the month for correct calculation
        $SystemTime = $TimeObject->Date2SystemTime(
            Year   => $Year + 1900,
            Month  => $Month + 1,
            Day    => $Day,
            Hour   => $Hour,
            Minute => $Min,
            Second => $Sec,
        );

        last LOOP if !$SystemTime;
        last LOOP if $SystemTime > $Param{StopTime};

        push @Result, $SystemTime;
    }

    return @Result;
}

=item PreviousEventGet()

gets the time when the last Cron event had occurred, from a given time.

    my $PreviousSystemTime = $CronEventObject->PreviousEventGet(
        Schedule  => '*/2 * * * *',          # recurrence parameters based in Cron notation
        StartTime => '2015-08-21 14:01:00',  # optional, defaults to current time
    );

Returns:

    my $EventSystemTime = 1423165200;        # or false in case of an error

=cut

sub PreviousEventGet {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{Schedule} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Schedule!",
        );

        return;
    }

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $StartTime = $Param{StartTime} || $TimeObject->SystemTime();

    return if !$StartTime;

    # init cron object
    my $CronObject = $Self->_Init(
        Schedule  => $Param{Schedule},
        StartTime => $StartTime,
    );

    return if !$CronObject;

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $CronObject->previousEvent();

    # it is needed to add 1 to the month for correct calculation
    my $SystemTime = $TimeObject->Date2SystemTime(
        Year   => $Year + 1900,
        Month  => $Month + 1,
        Day    => $Day,
        Hour   => $Hour,
        Minute => $Min,
        Second => $Sec,
    );

    return $SystemTime;
}

=item GenericAgentSchedule2CronTab()

converts a GenericAgent schedule to a CRON tab format string

    my $Schedule = $CronEventObject->GenericAgentSchedule2CronTab(
        ScheduleMinutes [1,2,3],
        ScheduleHours   [1,2,3],
        ScheduleDays    [1,2,3],
    );

    my $Schedule = '1,2,3 1,2,3 * * 1,2,3 *'  # or false in case of an error

=cut

sub GenericAgentSchedule2CronTab {
    my ( $Self, %Param ) = @_;

    # CRON Format
    # * * * * *     Field             Allowed values
    # | | | | |
    # | | | | +---- Day of the Week   (range: 1-7, 1 standing for Monday)
    # | | | +------ Month of the Year (range: 1-12)
    # | | +-------- Day of the Month  (range: 1-31)
    # | +---------- Hour              (range: 0-23)
    # +------------ Minute            (range: 0-59)

    # check needed params
    for my $Needed (qw(ScheduleMinutes ScheduleHours ScheduleDays)) {

        if ( !IsArrayRefWithData( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed is invalid!",
            );

            return;
        }

        # copy parameter to prevent changes
        my @Schedule = @{ $Param{$Needed} };

        # check ranges
        if ( $Needed eq 'ScheduleMinutes' ) {
            if ( grep { !IsNumber($_) || $_ < 0 || $_ > 59 } @Schedule ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "$Needed is invalid!",
                );

                return;
            }
        }
        elsif ( $Needed eq 'ScheduleHours' ) {
            if ( grep { !IsNumber($_) || $_ < 0 || $_ > 23 } @Schedule ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "$Needed is invalid!",
                );

                return;
            }
        }
        else {
            if ( grep { !IsNumber($_) || $_ < 0 || $_ > 6 } @Schedule ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "$Needed is invalid!",
                );

                return;
            }
        }
    }

    # set the minutes and hours components
    my $Schedule;
    for my $Component (qw(ScheduleMinutes ScheduleHours)) {

        $Schedule .= join ',', sort { $a <=> $b } @{ $Param{$Component} };

        # add a space
        $Schedule .= ' ';
    }

    # add the day and month components
    $Schedule .= '* * ';

    # convert week days (Sunday needs to be changed from 0 to 7)
    my @ScheduleDays = map {
        if   ( $_ == 0 ) {7}
        else             {$_}
    } @{ $Param{ScheduleDays} };

    $Schedule .= join ',', sort { $a <=> $b } @ScheduleDays;

    return $Schedule;
}

=begin Internal:

=cut

=item _Init()

creates a Schedule::Cron::Events object.

    my $CronObject = $CronEventObject->_Init(
        Schedule  => '*/2 * * * *',  # recurrence parameters based in Cron notation
        StartTime => '1423165100',
    }

=cut

sub _Init {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Schedule StartTime)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # create new internal cron object
    my $CronObject;
    eval {
        $CronObject = Schedule::Cron::Events->new(    ## no critic
            $Param{Schedule},
            Seconds => $Param{StartTime},
        );
    };

    # error handling
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Schedule: $Param{Schedule} is invalid:",
        );
        return;
    }

    # check cron object
    if ( !$CronObject ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not create new Schedule::Cron::Events object!",
        );
        return;
    }

    return $CronObject;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
