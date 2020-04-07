# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DateTime;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)
## nofilter(TidyAll::Plugin::OTRS::Perl::Translatable)

use strict;
use warnings;

use Exporter qw(import);
our %EXPORT_TAGS = (    ## no critic
    all => [
        'OTRSTimeZoneGet',
        'SystemTimeZoneGet',
        'TimeZoneList',
        'UserDefaultTimeZoneGet',
    ],
);
Exporter::export_ok_tags('all');

use DateTime;
use DateTime::TimeZone;
use Scalar::Util qw( looks_like_number );
use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

our %ObjectManagerFlags = (
    NonSingleton            => 1,
    AllowConstructorFailure => 1,
);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::Log',
);

our $Locale = DateTime::Locale->load('en_US');

use overload
    '>'        => \&_OpIsNewerThan,
    '<'        => \&_OpIsOlderThan,
    '>='       => \&_OpIsNewerThanOrEquals,
    '<='       => \&_OpIsOlderThanOrEquals,
    '=='       => \&_OpEquals,
    '!='       => \&_OpNotEquals,
    'fallback' => 1;

=head1 NAME

Kernel::System::DateTime - Handles date and time calculations.

=head1 DESCRIPTION

Handles date and time calculations.

=head1 PUBLIC INTERFACE

=head2 new()

Creates a DateTime object. Do not use new() directly, instead use the object manager:

    # Create an object with current date and time
    # within time zone set in SysConfig OTRSTimeZone:
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime'
    );

    # Create an object with current date and time
    # within a certain time zone:
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            TimeZone => 'Europe/Berlin',        # optional, TimeZone name.
        }
    );

    # Create an object with a specific date and time:
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year     => 2016,
            Month    => 1,
            Day      => 22,
            Hour     => 12,                     # optional, defaults to 0
            Minute   => 35,                     # optional, defaults to 0
            Second   => 59,                     # optional, defaults to 0
            TimeZone => 'Europe/Berlin',        # optional, defaults to setting of SysConfig OTRSTimeZone
        }
    );

    # Create an object from an epoch timestamp. These timestamps are always UTC/GMT,
    # hence time zone will automatically be set to UTC.
    #
    # If parameter Epoch is present, all other parameters will be ignored.
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Epoch => 1453911685,
        }
    );

    # Create an object from a date/time string.
    #
    # If parameter String is given, Year, Month, Day, Hour, Minute and Second will be ignored
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => '2016-08-14 22:45:00',
            TimeZone => 'Europe/Berlin',        # optional, defaults to setting of SysConfig OTRSTimeZone
        }
    );

    # Following formats for parameter String are supported:
    #
    #   yyyy-mm-dd hh:mm:ss
    #   yyyy-mm-dd hh:mm                # sets second to 0
    #   yyyy-mm-dd                      # sets hour, minute and second to 0
    #   yyyy-mm-ddThh:mm:ss+tt:zz
    #   yyyy-mm-ddThh:mm:ss+ttzz
    #   yyyy-mm-ddThh:mm:ss-tt:zz
    #   yyyy-mm-ddThh:mm:ss-ttzz
    #   yyyy-mm-ddThh:mm:ss [timezone]  # time zone will be deduced from an optional string
    #   yyyy-mm-ddThh:mm:ss[timezone]   # i.e. 2018-04-20T07:37:10UTC

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # CPAN DateTime: only use English descriptions and abbreviations internally.
    #   This has nothing to do with the user's locale settings in OTRS.
    $Self->{Locale} = $Locale;

    # Use private parameter to pass in an already created CPANDateTimeObject (used)
    #   by the Clone() method).
    if ( $Param{_CPANDateTimeObject} ) {
        $Self->{CPANDateTimeObject} = $Param{_CPANDateTimeObject};
        return $Self;
    }

    # Create the CPAN/Perl DateTime object.
    my $CPANDateTimeObject = $Self->_CPANDateTimeObjectCreate(%Param);

    if ( ref $CPANDateTimeObject ne 'DateTime' ) {

        # Add debugging information.
        my $Parameters = $Kernel::OM->Get('Kernel::System::Main')->Dump(
            \%Param,
        );

        # Remove $VAR1 =
        $Parameters =~ s{ \s* \$VAR1 \s* = \s* \{}{}xms;

        # Remove closing brackets.
        $Parameters =~ s{\}\s+\{}{\{}xms;
        $Parameters =~ s{\};\s*$}{}xms;

        # Replace new lines with spaces.
        $Parameters =~ s{\n}{ }gsmx;

        # Replace multiple spaces with one.
        $Parameters =~ s{\s+}{ }gsmx;

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'Error',
            'Message'  => "Error creating DateTime object ($Parameters).",
        );

        return;
    }

    $Self->{CPANDateTimeObject} = $CPANDateTimeObject;
    return $Self;
}

=head2 Get()

Returns hash ref with the date, time and time zone values of this object.

    my $DateTimeSettings = $DateTimeObject->Get();

Returns:

    my $DateTimeSettings = {
        Year      => 2016,
        Month     => 1,         # starting at 1
        Day       => 22,
        Hour      => 16,
        Minute    => 35,
        Second    => 59,
        DayOfWeek => 5,         # starting with 1 for Monday, ending with 7 for Sunday
        TimeZone  => 'Europe/Berlin',
    };

=cut

sub Get {
    my ( $Self, %Param ) = @_;

    my $Values = {
        Year      => $Self->{CPANDateTimeObject}->year(),
        Month     => $Self->{CPANDateTimeObject}->month(),
        MonthAbbr => $Self->{CPANDateTimeObject}->month_abbr(),
        Day       => $Self->{CPANDateTimeObject}->day(),
        Hour      => $Self->{CPANDateTimeObject}->hour(),
        Minute    => $Self->{CPANDateTimeObject}->minute(),
        Second    => $Self->{CPANDateTimeObject}->second(),
        DayOfWeek => $Self->{CPANDateTimeObject}->day_of_week(),
        DayAbbr   => $Self->{CPANDateTimeObject}->day_abbr(),
        TimeZone  => $Self->{CPANDateTimeObject}->time_zone_long_name(),
    };

    return $Values;
}

=head2 Set()

Sets date and time values of this object. You have to give at least one parameter. Only given values will be changed.
Note that the resulting date and time have to be valid. On validation error, the current date and time of the object
won't be changed.

Note that in order to change the time zone, you have to use method C<L</ToTimeZone()>>.

    # Setting values by hash:
    my $Success = $DateTimeObject->Set(
        Year     => 2016,
        Month    => 1,
        Day      => 22,
        Hour     => 16,
        Minute   => 35,
        Second   => 59,
    );

    # Settings values by date/time string:
    my $Success = $DateTimeObject->Set( String => '2016-02-25 20:34:01' );

If parameter C<String> is present, all other parameters will be ignored. Please see C<L</new()>> for the list of
supported string formats.

Returns:

   $Success = 1;    # On success, or false otherwise.

=cut

sub Set {
    my ( $Self, %Param ) = @_;

    if ( defined $Param{String} ) {
        my $DateTimeHash = $Self->_StringToHash( String => $Param{String} );
        return if !$DateTimeHash;

        %Param = %{$DateTimeHash};
    }

    my @DateTimeParams = qw ( Year Month Day Hour Minute Second );

    # Check given parameters
    my $ParamGiven;
    DATETIMEPARAM:
    for my $DateTimeParam (@DateTimeParams) {
        next DATETIMEPARAM if !defined $Param{$DateTimeParam};

        $ParamGiven = 1;
        last DATETIMEPARAM;
    }

    if ( !$ParamGiven ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'Error',
            'Message'  => 'Missing at least one parameter.',
        );
        return;
    }

    # Validate given values by using the current settings + the given ones.
    my $CurrentValues = $Self->Get();
    DATETIMEPARAM:
    for my $DateTimeParam (@DateTimeParams) {
        next DATETIMEPARAM if !defined $Param{$DateTimeParam};

        $CurrentValues->{$DateTimeParam} = $Param{$DateTimeParam};
    }

    # Create a new DateTime object with the new/added values
    my $CPANDateTimeParams = $Self->_ToCPANDateTimeParamNames( %{$CurrentValues} );

    # Delete parameters that are not allowed for set method
    delete $CPANDateTimeParams->{time_zone};

    my $Result;
    eval {
        $Result = $Self->{CPANDateTimeObject}->set( %{$CPANDateTimeParams} );
    };

    return $Result;
}

=head2 Add()

Adds duration or working time to date and time of this object. You have to give at least one of the valid parameters.
On error, the current date and time of this object won't be changed.

    my $Success = $DateTimeObject->Add(
        Years         => 1,
        Months        => 2,
        Weeks         => 4,
        Days          => 34,
        Hours         => 2,
        Minutes       => 5,
        Seconds       => 459,

        # Calculate "destination date" by adding given time values as
        # working time. Note that for adding working time,
        # only parameters Seconds, Minutes, Hours and Days are allowed.
        AsWorkingTime => 0, # set to 1 to add given values as working time

        # Calendar to use for working time calculations, optional
        Calendar => 9,
    );

Returns:

    $Success = 1;    # On success, or false otherwise.

=cut

sub Add {
    my ( $Self, %Param ) = @_;

    #
    # Check parameters
    #
    my @DateTimeParams = qw ( Years Months Weeks Days Hours Minutes Seconds );
    @DateTimeParams = qw( Days Hours Minutes Seconds ) if $Param{AsWorkingTime};

    # Check for needed parameters
    my $ParamsGiven = 0;
    my $ParamsValid = 1;
    DATETIMEPARAM:
    for my $DateTimeParam (@DateTimeParams) {
        next DATETIMEPARAM if !defined $Param{$DateTimeParam};

        if ( !looks_like_number( $Param{$DateTimeParam} ) ) {
            $ParamsValid = 0;
            last DATETIMEPARAM;
        }

        # negative values are not allowed when calculating working time
        if ( int $Param{$DateTimeParam} < 0 && $Param{AsWorkingTime} ) {
            $ParamsValid = 0;
            last DATETIMEPARAM;
        }

        $ParamsGiven = 1;
    }

    if ( !$ParamsGiven || !$ParamsValid ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'Error',
            'Message'  => 'Missing or invalid date/time parameter(s).',
        );
        return;
    }

    # Check for not allowed parameters
    my %AllowedParams = map { $_ => 1 } @DateTimeParams;
    $AllowedParams{AsWorkingTime} = 1;
    if ( $Param{AsWorkingTime} ) {
        $AllowedParams{Calendar} = 1;
    }

    for my $Param ( sort keys %Param ) {
        if ( !$AllowedParams{$Param} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                'Priority' => 'Error',
                'Message'  => "Parameter $Param is not allowed.",
            );
            return;
        }
    }

    # NOTE: For performance reasons, the following code for calculating date and time
    # works directly with the CPAN DateTime object instead of methods of Kernel::System::DateTime.

    #
    # Working time calculation
    #
    if ( $Param{AsWorkingTime} ) {

        # Combine time parameters to seconds
        my $RemainingSeconds = 0;
        if ( defined $Param{Seconds} ) {
            $RemainingSeconds += int $Param{Seconds};
        }
        if ( defined $Param{Minutes} ) {
            $RemainingSeconds += int $Param{Minutes} * 60;
        }
        if ( defined $Param{Hours} ) {
            $RemainingSeconds += int $Param{Hours} * 60 * 60;
        }
        if ( defined $Param{Days} ) {
            $RemainingSeconds += int $Param{Days} * 60 * 60 * 24;
        }

        return if !$RemainingSeconds;

        # Backup current date/time to be able to revert to it in case of failure
        my $OriginalDateTimeObject = $Self->{CPANDateTimeObject}->clone();

        my $TimeZone = $OriginalDateTimeObject->time_zone();

        # Get working and vacation times, use calendar if given
        my $ConfigObject            = $Kernel::OM->Get('Kernel::Config');
        my $TimeWorkingHours        = $ConfigObject->Get('TimeWorkingHours');
        my $TimeVacationDays        = $ConfigObject->Get('TimeVacationDays');
        my $TimeVacationDaysOneTime = $ConfigObject->Get('TimeVacationDaysOneTime');
        if (
            $Param{Calendar}
            && $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} . "Name" )
            )
        {
            $TimeWorkingHours        = $ConfigObject->Get( "TimeWorkingHours::Calendar" . $Param{Calendar} );
            $TimeVacationDays        = $ConfigObject->Get( "TimeVacationDays::Calendar" . $Param{Calendar} );
            $TimeVacationDaysOneTime = $ConfigObject->Get(
                "TimeVacationDaysOneTime::Calendar" . $Param{Calendar}
            );

            # Switch to time zone of calendar
            $TimeZone = $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} )
                || $Self->OTRSTimeZoneGet();

            # Use Kernel::System::DateTime's ToTimeZone() here because of error handling
            # and because performance is irrelevant at this point.
            if ( !$Self->ToTimeZone( TimeZone => $TimeZone ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Error setting time zone $TimeZone.",
                );

                return;
            }
        }

        # If there are for some reason no working hours configured, stop here
        # to prevent failing via loop protection below.
        my $WorkingHoursConfigured;
        WORKINGHOURCONFIGDAY:
        for my $WorkingHourConfigDay ( sort keys %{$TimeWorkingHours} ) {
            if ( IsArrayRefWithData( $TimeWorkingHours->{$WorkingHourConfigDay} ) ) {
                $WorkingHoursConfigured = 1;
                last WORKINGHOURCONFIGDAY;
            }
        }
        return 1 if !$WorkingHoursConfigured;

        # Convert $TimeWorkingHours into Hash
        my %TimeWorkingHours;
        for my $DayName ( sort keys %{$TimeWorkingHours} ) {
            $TimeWorkingHours{$DayName} = { map { $_ => 1 } @{ $TimeWorkingHours->{$DayName} } };
        }

        # Protection for endless loop
        my $LoopStartTime = time();
        LOOP:
        while ( $RemainingSeconds > 0 ) {

            # Fail if this loop takes longer than 5 seconds
            if ( time() - $LoopStartTime > 5 ) {

                # Reset this object to original date/time.
                $Self->{CPANDateTimeObject} = $OriginalDateTimeObject->clone();

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'Adding working time took too long, aborting.',
                );

                return;
            }

            my $Year    = $Self->{CPANDateTimeObject}->year();
            my $Month   = $Self->{CPANDateTimeObject}->month();
            my $Day     = $Self->{CPANDateTimeObject}->day();
            my $DayName = $Self->{CPANDateTimeObject}->day_abbr();
            my $Hour    = $Self->{CPANDateTimeObject}->hour();
            my $Minute  = $Self->{CPANDateTimeObject}->minute();
            my $Second  = $Self->{CPANDateTimeObject}->second();

            # Check working times and vacation days
            my $IsWorkingDay = !$TimeVacationDays->{$Month}->{$Day}
                && !$TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day}
                && exists $TimeWorkingHours->{$DayName}
                && keys %{ $TimeWorkingHours{$DayName} };

            # On start of day check if whole day can be processed in one chunk
            # instead of hour by hour (performance reasons).
            if ( !$Hour && !$Minute && !$Second ) {

                # The following code is slightly faster than using CPAN DateTime's add(),
                # presumably because add() always creates a DateTime::Duration object.
                my $Epoch = $Self->{CPANDateTimeObject}->epoch();
                $Epoch += 60 * 60 * 24;

                my $NextDayDateTimeObject = DateTime->from_epoch(
                    epoch     => $Epoch,
                    time_zone => $TimeZone,
                    locale    => $Self->{Locale},
                );

                # Only handle days with exactly 24 hours here
                if (
                    !$NextDayDateTimeObject->hour()
                    && !$NextDayDateTimeObject->minute()
                    && !$NextDayDateTimeObject->second()
                    && $NextDayDateTimeObject->day() != $Day
                    )
                {
                    my $FullDayProcessed = 1;

                    if ($IsWorkingDay) {
                        my $WorkingHours   = keys %{ $TimeWorkingHours{$DayName} };
                        my $WorkingSeconds = $WorkingHours * 60 * 60;

                        if ( $RemainingSeconds > $WorkingSeconds ) {
                            $RemainingSeconds -= $WorkingSeconds;
                        }
                        else {
                            $FullDayProcessed = 0;
                        }
                    }

                    # Move forward 24 hours if full day has been processed
                    if ($FullDayProcessed) {

                        # Time implicitly set to 0
                        $Self->{CPANDateTimeObject}->set(
                            year  => $NextDayDateTimeObject->year(),
                            month => $NextDayDateTimeObject->month(),
                            day   => $NextDayDateTimeObject->day(),
                        );

                        next LOOP;
                    }
                }
            }

            # Calculate remaining seconds of the current hour
            my $SecondsOfCurrentHour = ( $Minute * 60 ) + $Second;
            my $SecondsToAdd         = ( 60 * 60 ) - $SecondsOfCurrentHour;

            if ( $IsWorkingDay && $TimeWorkingHours{$DayName}->{$Hour} ) {
                $SecondsToAdd = $RemainingSeconds if $SecondsToAdd > $RemainingSeconds;
                $RemainingSeconds -= $SecondsToAdd;
            }

            # The following code is slightly faster than using CPAN DateTime's add(),
            # presumably because add() always creates a DateTime::Duration object.
            my $Epoch = $Self->{CPANDateTimeObject}->epoch();
            $Epoch += $SecondsToAdd;

            $Self->{CPANDateTimeObject} = DateTime->from_epoch(
                epoch     => $Epoch,
                time_zone => $TimeZone,
                locale    => $Self->{Locale},
            );
        }

        # Return to original time zone, might have been changed by calendar
        $Self->{CPANDateTimeObject}->set_time_zone( $OriginalDateTimeObject->time_zone() );

        return 1;
    }

    #
    # "Normal" date/time calculation
    #

    # Calculations are only made in UTC/floating time zone to prevent errors with times that
    # would not exist in the given time zone (e. g. on/around daylight saving time switch).
    # CPAN DateTime fails if adding days, months or years which would result in a non-existing
    # time in the given time zone. Converting it to UTC and back has the desired effect.
    #
    # Also see http://stackoverflow.com/questions/18489927/a-day-without-midnight
    my $TimeZone = $Self->{CPANDateTimeObject}->time_zone();
    $Self->{CPANDateTimeObject}->set_time_zone('UTC');

    # Convert to floating time zone to get rid of leap seconds which can lead to times like 23:59:61
    $Self->{CPANDateTimeObject}->set_time_zone('floating');

    # Add duration
    my $DurationParameters = $Self->_ToCPANDateTimeParamNames(%Param);
    eval {
        $Self->{CPANDateTimeObject}->add( %{$DurationParameters} );
    };

    # Store possible error before it might get lost by call to ToTimeZone
    my $Error = $@;

    # First convert floating time zone back to UTC and from there to the original time zone
    $Self->{CPANDateTimeObject}->set_time_zone('UTC');
    $Self->{CPANDateTimeObject}->set_time_zone($TimeZone);

    return if $Error;

    return 1;
}

=head2 Subtract()

Subtracts duration from date and time of this object. You have to give at least one of the valid parameters. On
validation error, the current date and time of this object won't be changed.

    my $Success = $DateTimeObject->Subtract(
        Years     => 1,
        Months    => 2,
        Weeks     => 4,
        Days      => 34,
        Hours     => 2,
        Minutes   => 5,
        Seconds   => 459,
    );

Returns:

    $Success =  1;  # On success, or false otherwise.

=cut

sub Subtract {
    my ( $Self, %Param ) = @_;

    my @DateTimeParams = qw ( Years Months Weeks Days Hours Minutes Seconds );

    # Check for needed parameters
    my $ParamsGiven = 0;
    my $ParamsValid = 1;
    DATETIMEPARAM:
    for my $DateTimeParam (@DateTimeParams) {
        next DATETIMEPARAM if !defined $Param{$DateTimeParam};

        if ( !looks_like_number( $Param{$DateTimeParam} ) ) {
            $ParamsValid = 0;
            last DATETIMEPARAM;
        }

        # negative values are not allowed when calculating working time
        if ( int $Param{$DateTimeParam} < 0 && $Param{AsWorkingTime} ) {
            $ParamsValid = 0;
            last DATETIMEPARAM;
        }

        $ParamsGiven = 1;
    }

    if ( !$ParamsGiven || !$ParamsValid ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'Error',
            'Message'  => 'Missing or invalid date/time parameter(s).',
        );
        return;
    }

    # Check for not allowed parameters
    my %AllowedParams = map { $_ => 1 } @DateTimeParams;
    $AllowedParams{AsWorkingTime} = 1;
    if ( $Param{AsWorkingTime} ) {
        $AllowedParams{Calendar} = 1;
    }

    for my $Param ( sort keys %Param ) {
        if ( !$AllowedParams{$Param} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                'Priority' => 'Error',
                'Message'  => "Parameter $Param is not allowed.",
            );
            return;
        }
    }

    # Calculations are only made in UTC/floating time zone to prevent errors with times that
    # would not exist in the given time zone (e. g. on/around daylight saving time switch).
    my $DateTimeValues = $Self->Get();
    $Self->ToTimeZone( TimeZone => 'UTC' );

    # Convert to floating time zone to get rid of leap seconds which can lead to times like 23:59:61
    $Self->{CPANDateTimeObject}->set_time_zone('floating');

    # Subtract duration
    my $DurationParameters = $Self->_ToCPANDateTimeParamNames(%Param);
    eval {
        $Self->{CPANDateTimeObject}->subtract( %{$DurationParameters} );
    };

    # Store possible error before it might get lost by call to ToTimeZone
    my $Error = $@;

    # First convert floating time zone back to UTC and from there to the original time zone
    $Self->{CPANDateTimeObject}->set_time_zone('UTC');
    $Self->ToTimeZone( TimeZone => $DateTimeValues->{TimeZone} );

    return if $@;

    return 1;
}

=head2 Delta()

Calculates delta between this and another DateTime object. Optionally calculates the working time between the two.

    my $Delta = $DateTimeObject->Delta( DateTimeObject => $AnotherDateTimeObject );

Note that the returned values are always positive. Use the comparison methods to see if a date is newer/older/equal.

    # Calculate "working time"
    ForWorkingTime => 0, # set to 1 to calculate working time between the two DateTime objects

    # Calendar to use for working time calculations, optional
    Calendar => 9,

Returns:

    my $Delta = {
        Years           => 1,           # Set to 0 if working time was calculated
        Months          => 2,           # Set to 0 if working time was calculated
        Weeks           => 4,           # Set to 0 if working time was calculated
        Days            => 34,          # Set to 0 if working time was calculated
        Hours           => 2,
        Minutes         => 5,
        Seconds         => 459,
        AbsoluteSeconds => 42084759,    # complete delta in seconds
    };

=cut

sub Delta {
    my ( $Self, %Param ) = @_;

    if (
        !defined $Param{DateTimeObject}
        || ref $Param{DateTimeObject} ne ref $Self
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'Error',
            'Message'  => "Missing or invalid parameter DateTimeObject.",
        );
        return;
    }

    my $Delta = {
        Years           => 0,
        Months          => 0,
        Weeks           => 0,
        Days            => 0,
        Hours           => 0,
        Minutes         => 0,
        Seconds         => 0,
        AbsoluteSeconds => 0,
    };

    #
    # Calculate delta for working time
    #
    if ( $Param{ForWorkingTime} ) {

        # NOTE: For performance reasons, the following code for calculating the working time
        # works directly with the CPAN DateTime object instead of Kernel::System::DateTime.

        # Clone StartDateTime object because it will be changed while calculating
        # but the original object must not be changed.
        my $StartDateTimeObject = $Self->{CPANDateTimeObject}->clone();
        my $TimeZone            = $StartDateTimeObject->time_zone();

        # Get working and vacation times, use calendar if given
        my $ConfigObject            = $Kernel::OM->Get('Kernel::Config');
        my $TimeWorkingHours        = $ConfigObject->Get('TimeWorkingHours');
        my $TimeVacationDays        = $ConfigObject->Get('TimeVacationDays');
        my $TimeVacationDaysOneTime = $ConfigObject->Get('TimeVacationDaysOneTime');
        if (
            $Param{Calendar}
            && $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} . "Name" )
            )
        {
            $TimeWorkingHours        = $ConfigObject->Get( "TimeWorkingHours::Calendar" . $Param{Calendar} );
            $TimeVacationDays        = $ConfigObject->Get( "TimeVacationDays::Calendar" . $Param{Calendar} );
            $TimeVacationDaysOneTime = $ConfigObject->Get(
                "TimeVacationDaysOneTime::Calendar" . $Param{Calendar}
            );

            # switch to time zone of calendar
            $TimeZone = $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} )
                || $Self->OTRSTimeZoneGet();

            eval {
                $StartDateTimeObject->set_time_zone($TimeZone);
            };

            if ($@) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Error setting time zone $TimeZone for start DateTime object.",
                );

                return;
            }
        }

        # If there are for some reason no working hours configured, stop here
        # to prevent failing via loop protection below.
        my $WorkingHoursConfigured;
        WORKINGHOURCONFIGDAY:
        for my $WorkingHourConfigDay ( sort keys %{$TimeWorkingHours} ) {
            if ( IsArrayRefWithData( $TimeWorkingHours->{$WorkingHourConfigDay} ) ) {
                $WorkingHoursConfigured = 1;
                last WORKINGHOURCONFIGDAY;
            }
        }
        return $Delta if !$WorkingHoursConfigured;

        # Convert $TimeWorkingHours into Hash
        my %TimeWorkingHours;
        for my $DayName ( sort keys %{$TimeWorkingHours} ) {
            $TimeWorkingHours{$DayName} = { map { $_ => 1 } @{ $TimeWorkingHours->{$DayName} } };
        }

        my $StartTime   = $StartDateTimeObject->epoch();
        my $StopTime    = $Param{DateTimeObject}->{CPANDateTimeObject}->epoch();
        my $WorkingTime = 0;

        # Protection for endless loop
        my $LoopStartTime = time();
        LOOP:
        while ( $StartTime < $StopTime ) {

            # Fail if this loop takes longer than 5 seconds
            if ( time() - $LoopStartTime > 5 ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'Delta calculation of working time took too long, aborting.',
                );

                return;
            }

            my $RemainingSeconds = $StopTime - $StartTime;

            my $Year    = $StartDateTimeObject->year();
            my $Month   = $StartDateTimeObject->month();
            my $Day     = $StartDateTimeObject->day();
            my $DayName = $StartDateTimeObject->day_abbr();
            my $Hour    = $StartDateTimeObject->hour();
            my $Minute  = $StartDateTimeObject->minute();
            my $Second  = $StartDateTimeObject->second();

            # Check working times and vacation days
            my $IsWorkingDay = !$TimeVacationDays->{$Month}->{$Day}
                && !$TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day}
                && exists $TimeWorkingHours->{$DayName}
                && keys %{ $TimeWorkingHours{$DayName} };

            # On start of day check if whole day can be processed in one chunk
            # instead of hour by hour (performance reasons).
            if ( !$Hour && !$Minute && !$Second ) {

                # The following code is slightly faster than using CPAN DateTime's add(),
                # presumably because add() always creates a DateTime::Duration object.
                my $Epoch = $StartDateTimeObject->epoch();
                $Epoch += 60 * 60 * 24;

                my $NextDayDateTimeObject = DateTime->from_epoch(
                    epoch     => $Epoch,
                    time_zone => $TimeZone,
                    locale    => $Self->{Locale},
                );

                # Only handle days with exactly 24 hours here
                if (
                    !$NextDayDateTimeObject->hour()
                    && !$NextDayDateTimeObject->minute()
                    && !$NextDayDateTimeObject->second()
                    && $NextDayDateTimeObject->day() != $Day
                    && $RemainingSeconds > 60 * 60 * 24
                    )
                {
                    my $FullDayProcessed = 1;

                    if ($IsWorkingDay) {
                        my $WorkingHours   = keys %{ $TimeWorkingHours{$DayName} };
                        my $WorkingSeconds = $WorkingHours * 60 * 60;

                        if ( $RemainingSeconds > $WorkingSeconds ) {
                            $WorkingTime += $WorkingSeconds;
                        }
                        else {
                            $FullDayProcessed = 0;
                        }
                    }

                    # Move forward 24 hours if full day has been processed
                    if ($FullDayProcessed) {

                        # Time implicitly set to 0
                        $StartDateTimeObject->set(
                            year  => $NextDayDateTimeObject->year(),
                            month => $NextDayDateTimeObject->month(),
                            day   => $NextDayDateTimeObject->day(),
                        );

                        $StartTime = $Epoch;

                        next LOOP;
                    }
                }
            }

            # Calculate remaining seconds of the current hour
            my $SecondsOfCurrentHour = ( $Minute * 60 ) + $Second;
            my $SecondsToAdd         = ( 60 * 60 ) - $SecondsOfCurrentHour;

            if ( $IsWorkingDay && $TimeWorkingHours{$DayName}->{$Hour} ) {
                $SecondsToAdd = $RemainingSeconds if $SecondsToAdd > $RemainingSeconds;
                $WorkingTime += $SecondsToAdd;
            }

            # The following code is slightly faster than using CPAN DateTime's add(),
            # presumably because add() always creates a DateTime::Duration object.
            my $Epoch = $StartDateTimeObject->epoch();
            $Epoch += $SecondsToAdd;

            $StartDateTimeObject = DateTime->from_epoch(
                epoch     => $Epoch,
                time_zone => $TimeZone,
                locale    => $Self->{Locale},
            );

            $StartTime = $Epoch;
        }

        # Set values for delta
        my $RemainingWorkingTime = $WorkingTime;

        $Delta->{Hours} = int $RemainingWorkingTime / ( 60 * 60 );
        $RemainingWorkingTime -= $Delta->{Hours} * 60 * 60;

        $Delta->{Minutes} = int $RemainingWorkingTime / 60;
        $RemainingWorkingTime -= $Delta->{Minutes} * 60;

        $Delta->{Seconds} = $RemainingWorkingTime;
        $RemainingWorkingTime = 0;

        $Delta->{AbsoluteSeconds} = $WorkingTime;

        return $Delta;
    }

    #
    # Calculate delta for "normal" date/time
    #
    my $DeltaDuration = $Self->{CPANDateTimeObject}->subtract_datetime(
        $Param{DateTimeObject}->{CPANDateTimeObject}
    );

    $Delta->{Years}   = $DeltaDuration->years();
    $Delta->{Months}  = $DeltaDuration->months();
    $Delta->{Weeks}   = $DeltaDuration->weeks();
    $Delta->{Days}    = $DeltaDuration->days();
    $Delta->{Hours}   = $DeltaDuration->hours();
    $Delta->{Minutes} = $DeltaDuration->minutes();
    $Delta->{Seconds} = $DeltaDuration->seconds();

    # Absolute seconds
    $DeltaDuration = $Self->{CPANDateTimeObject}->subtract_datetime_absolute(
        $Param{DateTimeObject}->{CPANDateTimeObject}
    );

    $Delta->{AbsoluteSeconds} = $DeltaDuration->seconds();

    return $Delta;
}

=head2 Compare()

Compares dates and returns a value suitable for using Perl's sort function (-1, 0, 1).

    my $Result = $DateTimeObject->Compare( DateTimeObject => $AnotherDateTimeObject );

You can also use this as a function for Perl's sort:

    my @SortedDateTimeObjects = sort { $a->Compare( DateTimeObject => $b ); } @UnsortedDateTimeObjects:

Returns:

    $Result = -1;       # if date/time of this object < date/time of given object
    $Result = 0;        # if date/time are equal
    $Result = 1:        # if date/time of this object > date/time of given object

=cut

sub Compare {
    my ( $Self, %Param ) = @_;

    if (
        !defined $Param{DateTimeObject}
        || ref $Param{DateTimeObject} ne ref $Self
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'Error',
            'Message'  => "Missing or invalid parameter DateTimeObject.",
        );
        return;
    }

    my $Result;
    eval {
        $Result = DateTime->compare(
            $Self->{CPANDateTimeObject},
            $Param{DateTimeObject}->{CPANDateTimeObject}
        );
    };

    return $Result;
}

=head2 ToTimeZone()

Converts the date and time of this object to the given time zone.

    my $Success = $DateTimeObject->ToTimeZone(
        TimeZone => 'Europe/Berlin',
    );

Returns:

    $Success = 1;   # success, or false otherwise.

=cut

sub ToTimeZone {
    my ( $Self, %Param ) = @_;

    for my $RequiredParam (qw( TimeZone )) {
        if ( !defined $Param{$RequiredParam} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                'Priority' => 'Error',
                'Message'  => "Missing parameter $RequiredParam.",
            );
            return;
        }
    }

    eval {
        $Self->{CPANDateTimeObject}->set_time_zone( $Param{TimeZone} );
    };

    return if $@;

    return 1;
}

=head2 ToOTRSTimeZone()

Converts the date and time of this object to the data storage time zone.

    my $Success = $DateTimeObject->ToOTRSTimeZone();

Returns:

    $Success = 1;   # success, or false otherwise.

=cut

sub ToOTRSTimeZone {
    my ( $Self, %Param ) = @_;

    return $Self->ToTimeZone( TimeZone => $Self->OTRSTimeZoneGet() );
}

=head2 Validate()

Checks if given date, time and time zone would result in a valid date.

    my $IsValid = $DateTimeObject->Validate(
        Year     => 2016,
        Month    => 1,
        Day      => 22,
        Hour     => 16,
        Minute   => 35,
        Second   => 59,
        TimeZone => 'Europe/Berlin',
    );

Returns:

    $IsValid = 1;   # if date/time is valid, or false otherwise.

=cut

sub Validate {
    my ( $Self, %Param ) = @_;

    my @DateTimeParams = qw ( Year Month Day Hour Minute Second TimeZone );
    for my $RequiredDateTimeParam (@DateTimeParams) {
        if ( !defined $Param{$RequiredDateTimeParam} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                'Priority' => 'Error',
                'Message'  => "Missing parameter $RequiredDateTimeParam.",
            );
            return;
        }
    }

    my $DateTimeObject = $Self->_CPANDateTimeObjectCreate(%Param);
    return if !$DateTimeObject;

    return 1;
}

=head2 Format()

Returns the date/time as string formatted according to format given.

See L<http://search.cpan.org/~drolsky/DateTime-1.21/lib/DateTime.pm#strftime_Patterns> for supported formats.

Short overview of essential formatting options:

    %Y or %{year}: four digit year

    %m: month with leading zero
    %{month}: month without leading zero

    %d: day of month with leading zero
    %{day}: day of month without leading zero

    %H: 24 hour with leading zero
    %{hour}: 24 hour without leading zero

    %l: 12 hour with leading zero
    %{hour_12}: 12 hour without leading zero

    %M: minute with leading zero
    %{minute}: minute without leading zero

    %S: second with leading zero
    %{second}: second without leading zero

    %{time_zone_long_name}: Time zone, e. g. 'Europe/Berlin'

    %{epoch}: Seconds since the epoch (OS specific)
    %{offset}: Offset in seconds to GMT/UTC

    my $DateTimeString = $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S' );

Returns:

    my $String = '2016-01-22 18:07:23';

=cut

sub Format {
    my ( $Self, %Param ) = @_;

    for my $RequiredParam (qw( Format )) {
        if ( !defined $Param{$RequiredParam} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                'Priority' => 'Error',
                'Message'  => "Missing parameter $RequiredParam.",
            );

            return;
        }
    }

    return $Self->{CPANDateTimeObject}->strftime( $Param{Format} );
}

=head2 ToEpoch()

Returns date/time as seconds since the epoch.

    my $Epoch = $DateTimeObject->ToEpoch();

Returns e. g.:

    my $Epoch = 1454420017;

=cut

sub ToEpoch {
    my ( $Self, %Param ) = @_;

    return $Self->{CPANDateTimeObject}->epoch();
}

=head2 ToString()

Returns date/time as string.

    my $DateTimeString = $DateTimeObject->ToString();

Returns e. g.:

    $DateTimeString = '2016-01-31 14:05:45'

=cut

sub ToString {
    my ( $Self, %Param ) = @_;

    return $Self->Format( Format => '%Y-%m-%d %H:%M:%S' );
}

=head2 ToEmailTimeStamp()

Returns the date/time of this object as time stamp in RFC 2822 format to be used in email headers.

    my $MailTimeStamp = $DateTimeObject->ToEmailTimeStamp();

    # Typical usage:
    # You want to have the date/time of OTRS + its UTC offset, so:
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $MailTimeStamp = $DateTimeObject->ToEmailTimeStamp();

    # If you already have a DateTime object, possibly in another time zone:
    $DateTimeObject->ToOTRSTimeZone();
    my $MailTimeStamp = $DateTimeObject->ToEmailTimeStamp();

Returns:

    my $String = 'Wed, 2 Sep 2014 16:30:57 +0200';

=cut

sub ToEmailTimeStamp {
    my ( $Self, %Param ) = @_;

    # According to RFC 2822, section 3.3

    # The date and time-of-day SHOULD express local time.
    #
    # The zone specifies the offset from Coordinated Universal Time (UTC,
    # formerly referred to as "Greenwich Mean Time") that the date and
    # time-of-day represent.  The "+" or "-" indicates whether the
    # time-of-day is ahead of (i.e., east of) or behind (i.e., west of)
    # Universal Time.  The first two digits indicate the number of hours
    # difference from Universal Time, and the last two digits indicate the
    # number of minutes difference from Universal Time.  (Hence, +hhmm
    # means +(hh * 60 + mm) minutes, and -hhmm means -(hh * 60 + mm)
    # minutes).  The form "+0000" SHOULD be used to indicate a time zone at
    # Universal Time.  Though "-0000" also indicates Universal Time, it is
    # used to indicate that the time was generated on a system that may be
    # in a local time zone other than Universal Time and therefore
    # indicates that the date-time contains no information about the local
    # time zone.

    my $EmailTimeStamp = $Self->Format(
        Format => '%a, %{day} %b %Y %H:%M:%S %z',
    );

    return $EmailTimeStamp;
}

=head2 ToCTimeString()

Returns date and time as ctime string, as for example returned by Perl's C<localtime> and C<gmtime> in scalar context.

    my $CTimeString = $DateTimeObject->ToCTimeString();

Returns:

    my $String = 'Fri Feb 19 16:07:31 2016';

=cut

sub ToCTimeString {
    my ( $Self, %Param ) = @_;

    my $LocalTimeString = $Self->Format(
        Format => '%a %b %{day} %H:%M:%S %Y',
    );

    return $LocalTimeString;
}

=head2 IsVacationDay()

Checks if date/time of this object is a vacation day.

    my $IsVacationDay = $DateTimeObject->IsVacationDay(
        Calendar => 9, # optional, OTRS vacation days otherwise
    );

Returns:

    my $IsVacationDay = 'some vacation day',    # description of vacation day or 0 if no vacation day.

=cut

sub IsVacationDay {
    my ( $Self, %Param ) = @_;

    my $OriginalDateTimeValues = $Self->Get();

    # Get configured vacation days
    my $ConfigObject            = $Kernel::OM->Get('Kernel::Config');
    my $TimeVacationDays        = $ConfigObject->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $ConfigObject->Get('TimeVacationDaysOneTime');
    if ( $Param{Calendar} ) {
        if ( $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} . "Name" ) ) {
            $TimeVacationDays        = $ConfigObject->Get( "TimeVacationDays::Calendar" . $Param{Calendar} );
            $TimeVacationDaysOneTime = $ConfigObject->Get(
                "TimeVacationDaysOneTime::Calendar" . $Param{Calendar}
            );

            # Switch to time zone of calendar
            my $TimeZone = $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} )
                || $Self->OTRSTimeZoneGet();

            if ( defined $TimeZone ) {
                $Self->ToTimeZone( TimeZone => $TimeZone );
            }
        }
    }

    my $DateTimeValues = $Self->Get();

    my $VacationDay        = $TimeVacationDays->{ $DateTimeValues->{Month} }->{ $DateTimeValues->{Day} };
    my $VacationDayOneTime = $TimeVacationDaysOneTime->{ $DateTimeValues->{Year} }->{ $DateTimeValues->{Month} }
        ->{ $DateTimeValues->{Day} };

    # Switch back to original time zone
    $Self->ToTimeZone( TimeZone => $OriginalDateTimeValues->{TimeZone} );

    return $VacationDay        if defined $VacationDay;
    return $VacationDayOneTime if defined $VacationDayOneTime;

    return 0;
}

=head2 LastDayOfMonthGet()

Returns the last day of the month.

    $LastDayOfMonth = $DateTimeObject->LastDayOfMonthGet();

Returns:

    my $LastDayOfMonth = {
        Day       => 31,
        DayOfWeek => 5,
        DayAbbr   => 'Fri',
    };

=cut

sub LastDayOfMonthGet {
    my ( $Self, %Param ) = @_;

    my $DateTimeValues = $Self->Get();

    my $TempCPANDateTimeObject;
    eval {
        $TempCPANDateTimeObject = DateTime->last_day_of_month(
            year  => $DateTimeValues->{Year},
            month => $DateTimeValues->{Month},
        );
    };

    return if !$TempCPANDateTimeObject;

    my $Result = {
        Day       => $TempCPANDateTimeObject->day(),
        DayOfWeek => $TempCPANDateTimeObject->day_of_week(),
        DayAbbr   => $TempCPANDateTimeObject->day_abbr(),
    };

    return $Result;
}

=head2 Clone()

Clones the DateTime object.

    my $ClonedDateTimeObject = $DateTimeObject->Clone();

=cut

sub Clone {
    my ( $Self, %Param ) = @_;

    return __PACKAGE__->new(
        _CPANDateTimeObject => $Self->{CPANDateTimeObject}->clone()
    );
}

=head2 TimeZoneList()

Returns an array ref of available time zones.

    my $TimeZones = $DateTimeObject->TimeZoneList();

You can also call this method without an object:

    my $TimeZones = Kernel::System::DateTime->TimeZoneList();

Returns:

    my $TimeZoneList = [
        # ...
        'Europe/Amsterdam',
        'Europe/Andorra',
        'Europe/Athens',
        # ...
    ];

=cut

sub TimeZoneList {
    my @TimeZones = @{ DateTime::TimeZone->all_names() };

    # add missing UTC time zone for certain DateTime versions
    my %TimeZones = map { $_ => 1 } @TimeZones;
    if ( !exists $TimeZones{UTC} ) {
        push @TimeZones, 'UTC';
    }

    return \@TimeZones;
}

=head2 TimeZoneByOffsetList()

Returns a list of time zones by offset in hours. Of course, the resulting list depends on the date/time set within this
DateTime object.

    my %TimeZoneByOffset = $DateTimeObject->TimeZoneByOffsetList();

Returns:

    my $TimeZoneByOffsetList = {
        # ...
        -9 => [ 'America/Adak', 'Pacific/Gambier', ],
        # ...
        2  => [
            # ...
            'Europe/Berlin',
            # ...
        ],
        # ...
        8.75 => [ 'Australia/Eucla', ],
        # ...
    };

=cut

sub TimeZoneByOffsetList {
    my ( $Self, %Param ) = @_;

    my $DateTimeObject = $Self->Clone();

    my $TimeZones = $Self->TimeZoneList();

    my %TimeZoneByOffset;
    for my $TimeZone ( sort @{$TimeZones} ) {
        $DateTimeObject->ToTimeZone( TimeZone => $TimeZone );
        my $TimeZoneOffset = $DateTimeObject->Format( Format => '%{offset}' ) / 60 / 60;

        if ( exists $TimeZoneByOffset{$TimeZoneOffset} ) {
            push @{ $TimeZoneByOffset{$TimeZoneOffset} }, $TimeZone;
        }
        else {
            $TimeZoneByOffset{$TimeZoneOffset} = [ $TimeZone, ];
        }
    }

    return \%TimeZoneByOffset;
}

=head2 IsTimeZoneValid()

Checks if the given time zone is valid.

    my $Valid = $DateTimeObject->IsTimeZoneValid( TimeZone => 'Europe/Berlin' );

Returns:
    $ValidID = 1;    # if given time zone is valid, 0 otherwise.

=cut

my %ValidTimeZones;    # Cache for all instances.

sub IsTimeZoneValid {
    my ( $Self, %Param ) = @_;

    for my $RequiredParam (qw( TimeZone )) {
        if ( !defined $Param{$RequiredParam} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                'Priority' => 'Error',
                'Message'  => "Missing parameter $RequiredParam.",
            );
            return;
        }
    }

    # allow DateTime internal time zone in 'floating'
    return 1 if $Param{TimeZone} eq 'floating';

    if ( !%ValidTimeZones ) {
        %ValidTimeZones = map { $_ => 1 } @{ $Self->TimeZoneList() };
    }

    return $ValidTimeZones{ $Param{TimeZone} } ? 1 : 0;
}

=head2 OTRSTimeZoneGet()

Returns the time zone set for OTRS.

    my $OTRSTimeZone = $DateTimeObject->OTRSTimeZoneGet();

    # You can also call this method without an object:
    #my $OTRSTimeZone = Kernel::System::DateTime->OTRSTimeZoneGet();

Returns:

    my $OTRSTimeZone = 'Europe/Berlin';

=cut

sub OTRSTimeZoneGet {
    return $Kernel::OM->Get('Kernel::Config')->Get('OTRSTimeZone') || 'UTC';
}

=head2 UserDefaultTimeZoneGet()

Returns the time zone set as default in SysConfig UserDefaultTimeZone for newly created users or existing users without
time zone setting.

    my $UserDefaultTimeZoneGet = $DateTimeObject->UserDefaultTimeZoneGet();

You can also call this method without an object:

    my $UserDefaultTimeZoneGet = Kernel::System::DateTime->UserDefaultTimeZoneGet();

Returns:

    my $UserDefaultTimeZone = 'Europe/Berlin';

=cut

sub UserDefaultTimeZoneGet {
    return $Kernel::OM->Get('Kernel::Config')->Get('UserDefaultTimeZone') || 'UTC';
}

=head2 SystemTimeZoneGet()

Returns the time zone of the system.

    my $SystemTimeZone = $DateTimeObject->SystemTimeZoneGet();

You can also call this method without an object:

    my $SystemTimeZone = Kernel::System::DateTime->SystemTimeZoneGet();

Returns:

    my $SystemTimeZone = 'Europe/Berlin';

=cut

sub SystemTimeZoneGet {
    return DateTime::TimeZone->new( name => 'local' )->name();
}

=begin Internal:

=head2 _ToCPANDateTimeParamNames()

Maps date/time parameter names expected by the methods of this package to the ones expected by CPAN/Perl DateTime
package.

    my $DateTimeParams = $DateTimeObject->_ToCPANDateTimeParamNames(
        Year     => 2016,
        Month    => 1,
        Day      => 22,
        Hour     => 17,
        Minute   => 20,
        Second   => 2,
        TimeZone => 'Europe/Berlin',
    );

Returns:

    my $CPANDateTimeParamNames = {
        year      => 2016,
        month     => 1,
        day       => 22,
        hour      => 17,
        minute    => 20,
        second    => 2,
        time_zone => 'Europe/Berlin',
    };

=cut

sub _ToCPANDateTimeParamNames {
    my ( $Self, %Param ) = @_;

    my %ParamNameMapping = (
        Year     => 'year',
        Month    => 'month',
        Day      => 'day',
        Hour     => 'hour',
        Minute   => 'minute',
        Second   => 'second',
        TimeZone => 'time_zone',

        Years   => 'years',
        Months  => 'months',
        Weeks   => 'weeks',
        Days    => 'days',
        Hours   => 'hours',
        Minutes => 'minutes',
        Seconds => 'seconds',
    );

    my $DateTimeParams;

    PARAMNAME:
    for my $ParamName ( sort keys %ParamNameMapping ) {
        next PARAMNAME if !exists $Param{$ParamName};

        $DateTimeParams->{ $ParamNameMapping{$ParamName} } = $Param{$ParamName};
    }

    return $DateTimeParams;
}

=head2 _StringToHash()

Parses a date/time string and returns a hash ref.

    my $DateTimeHash = $DateTimeObject->_StringToHash( String => '2016-08-14 22:45:00' );

    # Sets second to 0:
    my $DateTimeHash = $DateTimeObject->_StringToHash( String => '2016-08-14 22:45' );

    # Sets hour, minute and second to 0:
    my $DateTimeHash = $DateTimeObject->_StringToHash( String => '2016-08-14' );

Please see C<L</new()>> for the list of supported string formats.

Returns:

    my $DateTimeHash = {
        Year   => 2016,
        Month  => 8,
        Day    => 14,
        Hour   => 22,
        Minute => 45,
        Second => 0,
    };

=cut

sub _StringToHash {
    my ( $Self, %Param ) = @_;

    for my $RequiredParam (qw( String )) {
        if ( !defined $Param{$RequiredParam} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                'Priority' => 'Error',
                'Message'  => "Missing parameter $RequiredParam.",
            );

            return;
        }
    }

    if ( $Param{String} =~ m{\A(\d{4})-(\d{1,2})-(\d{1,2})(\s(\d{1,2}):(\d{1,2})(:(\d{1,2}))?)?\z} ) {

        my $DateTimeHash = {
            Year   => int $1,
            Month  => int $2,
            Day    => int $3,
            Hour   => defined $5 ? int $5 : 0,
            Minute => defined $6 ? int $6 : 0,
            Second => defined $8 ? int $8 : 0,
        };

        return $DateTimeHash;
    }

    # Match the following formats:
    #   - yyyy-mm-ddThh:mm:ss+tt:zz
    #   - yyyy-mm-ddThh:mm:ss+ttzz
    #   - yyyy-mm-ddThh:mm:ss-tt:zz
    #   - yyyy-mm-ddThh:mm:ss-ttzz
    #   - yyyy-mm-ddThh:mm:ss [timezone]
    #   - yyyy-mm-ddThh:mm:ss[timezone]
    if ( $Param{String} =~ /^\d{4}-\d{1,2}-\d{1,2}T\d{1,2}:\d{1,2}:\d{1,2}(.+)$/i ) {
        my ( $Year, $Month, $Day, $Hour, $Minute, $Second, $OffsetOrTZ ) =
            ( $Param{String} =~ m/^(\d{4})-(\d{2})-(\d{2})T(\d{1,2}):(\d{1,2}):(\d{1,2})\s*(.+)$/i );

        my $DateTimeHash = {
            Year   => int $Year,
            Month  => int $Month,
            Day    => int $Day,
            Hour   => int $Hour,
            Minute => int $Minute,
            Second => int $Second,
        };

        # Check if the rest 'OffsetOrTZ' is an offset or timezone.
        #   If isn't an offset consider it a timezone
        if ( $OffsetOrTZ !~ m/(\+|\-)\d{2}:?\d{2}/i ) {

            # Make sure the time zone is valid. Otherwise, assume UTC.
            if ( !$Self->IsTimeZoneValid( TimeZone => $OffsetOrTZ ) ) {
                $OffsetOrTZ = 'UTC';
            }

            return {
                %{$DateTimeHash},
                TimeZone => $OffsetOrTZ,
            };
        }

        # It's an offset, get the time in GMT/UTC.
        $OffsetOrTZ =~ s/://i;    # Remove the ':'
        my $DT = DateTime->new(
            ( map { lcfirst $_ => $DateTimeHash->{$_} } keys %{$DateTimeHash} ),
            time_zone => $OffsetOrTZ,
        );
        $DT->set_time_zone('UTC');
        $DT->set_time_zone( $Self->OTRSTimeZoneGet() );

        return {
            ( map { ucfirst $_ => $DT->$_() } qw(year month day hour minute second) )
        };
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        'Priority' => 'Error',
        'Message'  => "Invalid date/time string $Param{String}.",
    );

    return;
}

=head2 _CPANDateTimeObjectCreate()

Creates a CPAN DateTime object which will be stored within this object and used for date/time calculations.

    # Create an object with current date and time
    # within time zone set in SysConfig OTRSTimeZone:
    my $CPANDateTimeObject = $DateTimeObject->_CPANDateTimeObjectCreate();

    # Create an object with current date and time
    # within a certain time zone:
    my $CPANDateTimeObject = $DateTimeObject->_CPANDateTimeObjectCreate(
        TimeZone => 'Europe/Berlin',
    );

    # Create an object with a specific date and time:
    my $CPANDateTimeObject = $DateTimeObject->_CPANDateTimeObjectCreate(
        Year     => 2016,
        Month    => 1,
        Day      => 22,
        Hour     => 12,                 # optional, defaults to 0
        Minute   => 35,                 # optional, defaults to 0
        Second   => 59,                 # optional, defaults to 0
        TimeZone => 'Europe/Berlin',    # optional, defaults to setting of SysConfig OTRSTimeZone
    );

    # Create an object from an epoch timestamp. These timestamps are always UTC/GMT,
    # hence time zone will automatically be set to UTC.
    #
    # If parameter Epoch is present, all other parameters except TimeZone will be ignored.
    my $CPANDateTimeObject = $DateTimeObject->_CPANDateTimeObjectCreate(
        Epoch => 1453911685,
    );

    # Create an object from a date/time string.
    #
    # If parameter String is given, Year, Month, Day, Hour, Minute and Second will be ignored. Please see C<L</new()>>
    # for the list of supported string formats.
    my $CPANDateTimeObject = $DateTimeObject->_CPANDateTimeObjectCreate(
        String   => '2016-08-14 22:45:00',
        TimeZone => 'Europe/Berlin',        # optional, defaults to setting of SysConfig OTRSTimeZone
    );

=cut

sub _CPANDateTimeObjectCreate {
    my ( $Self, %Param ) = @_;

    # Create object from string
    if ( defined $Param{String} ) {
        my $DateTimeHash = $Self->_StringToHash( String => $Param{String} );
        if ( !IsHashRefWithData($DateTimeHash) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                'Priority' => 'Error',
                'Message'  => "Invalid value for String: $Param{String}.",
            );

            return;
        }

        %Param = (
            TimeZone => $Param{TimeZone},
            %{$DateTimeHash},
        );
    }

    my $CPANDateTimeObject;
    my $TimeZone = $Param{TimeZone} || $Self->OTRSTimeZoneGet();

    if ( !$Self->IsTimeZoneValid( TimeZone => $TimeZone ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'Error',
            'Message'  => "Invalid value for TimeZone: $TimeZone.",
        );

        return;
    }

    # Create object from epoch
    if ( defined $Param{Epoch} ) {

        if ( $Param{Epoch} !~ m{\A[+-]?\d+\z}sm ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                'Priority' => 'Error',
                'Message'  => "Invalid value for Epoch: $Param{Epoch}.",
            );

            return;
        }

        eval {
            $CPANDateTimeObject = DateTime->from_epoch(
                epoch     => $Param{Epoch},
                time_zone => $TimeZone,
                locale    => $Self->{Locale},
            );
        };

        return $CPANDateTimeObject;
    }

    $Param{TimeZone} = $TimeZone;

    # Check if date/time params were given, excluding time zone
    my $DateTimeParamsGiven = %Param && ( !defined $Param{TimeZone} || keys %Param > 1 );

    # Create object from date/time parameters
    if ($DateTimeParamsGiven) {

        # Check existence of required params
        for my $RequiredParam (qw( Year Month Day )) {
            if ( !$Param{$RequiredParam} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    'Priority' => 'Error',
                    'Message'  => "Missing parameter $RequiredParam.",
                );
                return;
            }
        }

        # Create DateTime object
        my $DateTimeParams = $Self->_ToCPANDateTimeParamNames(%Param);

        eval {
            $CPANDateTimeObject = DateTime->new(
                %{$DateTimeParams},
                locale => $Self->{Locale},
            );
        };

        return $CPANDateTimeObject;
    }

    # Create object with current date/time.
    eval {
        $CPANDateTimeObject = DateTime->now(
            time_zone => $TimeZone,
            locale    => $Self->{Locale},
        );
    };

    return $CPANDateTimeObject;
}

=head2 _OpIsNewerThan()

Operator overloading for >

=cut

sub _OpIsNewerThan {
    my ( $Self, $OtherDateTimeObject ) = @_;

    my $Result = $Self->Compare( DateTimeObject => $OtherDateTimeObject );
    return if !defined $Result;

    $Result = $Result == 1 ? 1 : 0;

    return $Result;
}

=head2 _OpIsOlderThan()

Operator overloading for <

=cut

sub _OpIsOlderThan {
    my ( $Self, $OtherDateTimeObject ) = @_;

    my $Result = $Self->Compare( DateTimeObject => $OtherDateTimeObject );
    return if !defined $Result;

    $Result = $Result == -1 ? 1 : 0;

    return $Result;
}

=head2 _OpIsNewerThanOrEquals()

Operator overloading for >=

=cut

sub _OpIsNewerThanOrEquals {
    my ( $Self, $OtherDateTimeObject ) = @_;

    my $Result = $Self->Compare( DateTimeObject => $OtherDateTimeObject );
    return if !defined $Result;

    $Result = $Result >= 0 ? 1 : 0;

    return $Result;
}

=head2 _OpIsOlderThanOrEquals()

Operator overloading for <=

=cut

sub _OpIsOlderThanOrEquals {
    my ( $Self, $OtherDateTimeObject ) = @_;

    my $Result = $Self->Compare( DateTimeObject => $OtherDateTimeObject );
    return if !defined $Result;

    $Result = $Result <= 0 ? 1 : 0;

    return $Result;
}

=head2 _OpEquals()

Operator overloading for ==

=cut

sub _OpEquals {
    my ( $Self, $OtherDateTimeObject ) = @_;

    my $Result = $Self->Compare( DateTimeObject => $OtherDateTimeObject );
    return if !defined $Result;

    $Result = !$Result ? 1 : 0;

    return $Result;
}

=head2 _OpNotEquals()

Operator overloading for !=

=cut

sub _OpNotEquals {
    my ( $Self, $OtherDateTimeObject ) = @_;

    my $Result = $Self->Compare( DateTimeObject => $OtherDateTimeObject );
    return if !defined $Result;

    $Result = $Result != 0 ? 1 : 0;

    return $Result;
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
