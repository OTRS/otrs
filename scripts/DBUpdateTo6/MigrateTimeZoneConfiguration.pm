# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::MigrateTimeZoneConfiguration;    ## no critic

use strict;
use warnings;

use IO::Interactive qw(is_interactive);

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    # Check if following table already exists. In this case, time zone configuration is already done.
    my $TableExists = $Self->TableExists(
        Table => 'ticket_number_counter',
    );

    return 1 if $TableExists;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if configuration was already made.
    my $OTRSTimeZone        = $ConfigObject->Get('OTRSTimeZone')        // '';
    my $UserDefaultTimeZone = $ConfigObject->Get('UserDefaultTimeZone') // '';
    if ( $OTRSTimeZone && $UserDefaultTimeZone ) {
        return 1;
    }

    # Get system time zone
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            TimeZone => 'UTC',
        },
    );
    my $SystemTimeZone = $DateTimeObject->SystemTimeZoneGet() || 'UTC';
    $DateTimeObject->ToTimeZone( TimeZone => $SystemTimeZone );

    # Get configured deprecated time zone offset.
    my $TimeOffset = int( $ConfigObject->Get('TimeZone') || 0 );

    # Calculate complete time offset (server time zone + OTRS time offset).
    my $SuggestedTimeZone = $TimeOffset ? '' : $SystemTimeZone;
    $TimeOffset += $DateTimeObject->Format( Format => '%{offset}' ) / 60 / 60;

    if ( ( $Param{CommandlineOptions}->{NonInteractive} || !is_interactive() ) && $TimeOffset != 0 ) {

        # Check for a file containing target time zones and read it. If it doesn't exist, create it.
        return $Self->_CheckForTimeZones(
            DateTimeObject => $DateTimeObject,
        );
    }

    if ( $Param{CommandlineOptions}->{NonInteractive} || !is_interactive() ) {
        return 1;
    }

    #
    # OTRSTimeZone
    #

    # Show suggestions for time zone
    my %TimeZones        = map { $_ => 1 } @{ $DateTimeObject->TimeZoneList() };
    my $TimeZoneByOffset = $DateTimeObject->TimeZoneByOffsetList();
    if ( exists $TimeZoneByOffset->{$TimeOffset} ) {
        print
            "\n\n        The currently configured time offset is $TimeOffset hours, these are the suggestions for a corresponding OTRS time zone: \n\n";

        print "        " . join( "\n        ", sort @{ $TimeZoneByOffset->{$TimeOffset} } ) . "\n";
    }

    if ( $SuggestedTimeZone && $TimeZones{$SuggestedTimeZone} ) {
        print "\n\n        It seems that $SuggestedTimeZone should be the correct time zone to set for your OTRS. \n";
    }

    $Self->{TargetTimeZones}->{OTRSTimeZone} = $Self->_AskForTimeZone(
        ConfigKey => 'OTRSTimeZone',
        TimeZones => \%TimeZones,
    );

    #
    # UserDefaultTimeZone
    #
    $Self->{TargetTimeZones}->{UserDefaultTimeZone} = $Self->_AskForTimeZone(
        ConfigKey => 'UserDefaultTimeZone',
        TimeZones => \%TimeZones,
    );

    #
    # TimeZone::Calendar[1..9] (but only those that have already a time offset set)
    #
    CALENDAR:
    for my $Calendar ( 1 .. 9 ) {
        my $ConfigKey        = "TimeZone::Calendar$Calendar";
        my $CalendarTimeZone = $ConfigObject->Get($ConfigKey);
        next CALENDAR if !defined $CalendarTimeZone;

        $Self->{TargetTimeZones}->{$ConfigKey} = $Self->_AskForTimeZone(
            ConfigKey => $ConfigKey,
            TimeZones => \%TimeZones,
        );
    }

    print "\n";

    return 1;
}

=head1 NAME

scripts::DBUpdateTo6::MigrateTimeZoneConfiguration - Migrate timezone configuration.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    # Check if following table already exists. In this case, time zone configuration is already done.
    my $TableExists = $Self->TableExists(
        Table => 'ticket_number_counter',
    );

    return 1 if $TableExists;

    #
    # Check for interactive mode
    #
    if ( !$Self->{TargetTimeZones} && ( $Param{CommandlineOptions}->{NonInteractive} || !is_interactive() ) ) {

        if ($Verbose) {
            print
                "\n        - Migration of time zone settings is being skipped because this script is being executed in non-interactive mode. \n"
                . "        Please make sure to set the following SysConfig options after this script has been executed: \n"
                . "        OTRSTimeZone \n"
                . "        UserDefaultTimeZone \n"
                . "        TimeZone::Calendar1 to TimeZone::Calendar9 (depending on the calendars in use) \n\n";
        }
        return 1;
    }

    for my $ConfigKey ( sort keys %{ $Self->{TargetTimeZones} // {} } ) {

        my $Result = $Self->SettingUpdate(
            Name           => $ConfigKey,
            IsValid        => 1,
            EffectiveValue => $Self->{TargetTimeZones}->{$ConfigKey},
            UserID         => 1,
        );

        return if !$Result;
    }

    return 1;
}

sub _AskForTimeZone {
    my ( $Self, %Param ) = @_;

    my $TimeZone;
    print "\n";
    while ( !defined $TimeZone || !$Param{TimeZones}->{$TimeZone} ) {
        print
            "        Enter the time zone to use for $Param{ConfigKey} (leave empty to show a list of all available time zones): ";
        $TimeZone = <>;

        # Remove white space
        $TimeZone =~ s{\s}{}smx;

        if ( length $TimeZone ) {
            if ( !$Param{TimeZones}->{$TimeZone} ) {
                print "        Invalid time zone. \n";
            }
        }
        else {
            # Show list of all available time zones
            print "        " . join( "\n        ", sort keys %{ $Param{TimeZones} } ) . " \n";
        }
    }

    return $TimeZone;
}

sub _CheckForTimeZones {
    my ( $Self, %Param ) = @_;

    # Gather list of to-be-set time zones.
    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $SystemOffset    = $Param{DateTimeObject}->Format( Format => '%{offset}' ) / 60 / 60;
    my $OTRSTimeOffset  = int( $ConfigObject->Get('TimeZone') // 0 ) + $SystemOffset;
    my %TimeZone2Offset = (
        OTRSTimeZone        => $OTRSTimeOffset,
        UserDefaultTimeZone => $OTRSTimeOffset,
    );

    CALENDAR:
    for my $Calendar ( 1 .. 9 ) {
        my $ConfigKey        = "TimeZone::Calendar$Calendar";
        my $CalendarTimeZone = int( $ConfigObject->Get($ConfigKey) // 0 ) + $OTRSTimeOffset;
        next CALENDAR if !$CalendarTimeZone || $CalendarTimeZone == 0;

        $TimeZone2Offset{$ConfigKey} = $CalendarTimeZone;
    }

    # If we already have a file for time zone configurations, check if it contains a setting for each needed time zone.
    my $TaskConfig  = $Self->GetTaskConfig( Module => 'MigrateTimeZoneConfiguration' );
    my $ConfigFound = $TaskConfig ? 1 : 0;
    my $ConfigValid;
    if ($ConfigFound) {
        $ConfigValid = 1;

        TIMEZONE:
        for my $TimeZone ( sort keys %TimeZone2Offset ) {
            if ( !$TaskConfig->{$TimeZone} ) {
                $ConfigValid = 0;
                last TIMEZONE;
            }

            $Self->{TargetTimeZones}->{$TimeZone} = $TaskConfig->{$TimeZone};
        }
    }

    # We have a file containing all necessary settings.
    return 1 if $ConfigValid;

    # We have no valid file - create one as template (even if a template already exists).

    # Gather list of possible time zones per config option.
    my $OutputYAML       = "---\n";
    my $TimeZones        = $Param{DateTimeObject}->TimeZoneList();
    my $TimeZoneByOffset = $Param{DateTimeObject}->TimeZoneByOffsetList();
    for my $TimeZone ( sort keys %TimeZone2Offset ) {
        my $TimeZoneList = $TimeZoneByOffset->{ $TimeZone2Offset{$TimeZone} } // $TimeZones;

        $OutputYAML .= "# Please uncomment the desired time zone for '$TimeZone' out of the following entries.\n";
        $OutputYAML .= join "\n", map { "#$TimeZone: " . $_ } @{$TimeZoneList};
        $OutputYAML .= "\n\n";
    }

    # Write template to a file.
    my $Location = $ConfigObject->Get('Home') . '/scripts/DBUpdateTo6/TaskConfig/MigrateTimeZoneConfiguration.yml.dist';
    my $FileLocation = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $Location,
        Content  => \$OutputYAML,
        Mode     => 'utf8',
    );

    print
        "\n\n      Error: There is a time offset configured which currently prevents this script from running in non-interactive mode.\n"
        . "        A config file with proposed time zones has been written to '$Location'.\n"
        . "        Please either uncomment the relevant time zone(s) in the file or execute the script in interactive mode and select the time zone(s) manually.\n\n";
    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
