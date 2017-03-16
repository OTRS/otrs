# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)
package scripts::DBUpdateTo6::MigrateTimeZoneConfiguration;

use strict;
use warnings;

use IO::Interactive qw(is_interactive);

use base qw(scripts::DBUpdateTo6);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateTimeZoneConfiguration - Migrate timezone configuration.

=head1 DESCRIPTION

Migrate timezone configuration.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $DBUpdateTo6Object = $Kernel::OM->Get('scripts::DBUpdateTo6::MigrateTimeZoneConfiguration');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Opts} = $Param{Opts};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    #
    # Remove agent and customer UserTimeZone preferences because they contain
    # offsets instead of time zones
    #
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM user_preferences WHERE preferences_key = ?',
        Bind => [
            \'UserTimeZone',
        ],
    );
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM customer_preferences WHERE preferences_key = ?',
        Bind => [
            \'UserTimeZone',
        ],
    );

    #
    # Check for interactive mode
    #
    if ( $Self->{Opts}->{NonInteractive} || !is_interactive() ) {
        print
            "\n\tMigration of time zone settings is being skipped because this script is being executed in non-interactive mode.\n";
        print "\tPlease make sure to set the following SysConfig options after this script has been executed:\n";
        print "\tOTRSTimeZone\n";
        print "\tUserDefaultTimeZone\n";
        print "\tTimeZone::Calendar1 to TimeZone::Calendar9 (depending on the calendars in use)\n";
        return 1;
    }

    #
    # OTRSTimeZone
    #

    # Get system time zone
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            TimeZone => 'UTC',
        },
    );
    my $SystemTimeZone = $DateTimeObject->SystemTimeZoneGet() || 'UTC';
    $DateTimeObject->ToTimeZone( TimeZone => $SystemTimeZone );

    # Get configured deprecated time zone offset
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $TimeOffset = int( $ConfigObject->Get('TimeZone') || 0 );

    # Calculate complete time offset (server time zone + OTRS time offset)
    my $SuggestedTimeZone = $TimeOffset ? '' : $SystemTimeZone;
    $TimeOffset += $DateTimeObject->Format( Format => '%{offset}' ) / 60 / 60;

    # Show suggestions for time zone
    my %TimeZones = map { $_ => 1 } @{ $DateTimeObject->TimeZoneList() };
    my $TimeZoneByOffset = $DateTimeObject->TimeZoneByOffsetList();
    if ( exists $TimeZoneByOffset->{$TimeOffset} ) {
        print
            "\nThe currently configured time offset is $TimeOffset hours, these are the suggestions for a corresponding OTRS time zone:\n\n";

        print join( "\n", sort @{ $TimeZoneByOffset->{$TimeOffset} } ) . "\n";
    }

    if ( $SuggestedTimeZone && $TimeZones{$SuggestedTimeZone} ) {
        print "\nIt seems that $SuggestedTimeZone should be the correct time zone to set for your OTRS.\n";
    }

    my $Success = $Self->_ConfigureTimeZone(
        ConfigKey => 'OTRSTimeZone',
        TimeZones => \%TimeZones,
    );

    return if !$Success;

    #
    # UserDefaultTimeZone
    #
    $Success = $Self->_ConfigureTimeZone(
        ConfigKey => 'UserDefaultTimeZone',
        TimeZones => \%TimeZones,
    );

    return if !$Success;

    #
    # TimeZone::Calendar[1..9] (but only those that have already a time offset set)
    #
    CALENDAR:
    for my $Calendar ( 1 .. 9 ) {
        my $ConfigKey        = "TimeZone::Calendar$Calendar";
        my $CalendarTimeZone = $ConfigObject->Get($ConfigKey);
        next CALENDAR if !defined $CalendarTimeZone;

        $Success = $Self->_ConfigureTimeZone(
            ConfigKey => $ConfigKey,
            TimeZones => \%TimeZones,
        );

        return if !$Success;
    }

    return 1;
}

sub _ConfigureTimeZone {
    my ( $Self, %Param ) = @_;

    my $TimeZone = $Self->_AskForTimeZone(
        ConfigKey => $Param{ConfigKey},
        TimeZones => $Param{TimeZones},
    );

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => $Param{ConfigKey},
        Force  => 1,
        UserID => 1,
    );

    my %Result = $SysConfigObject->SettingUpdate(
        Name              => $Param{ConfigKey},
        IsValid           => 1,
        EffectiveValue    => $TimeZone,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    return $Result{Success};
}

sub _AskForTimeZone {
    my ( $Self, %Param ) = @_;

    my $TimeZone;
    print "\n";
    while ( !defined $TimeZone || !$Param{TimeZones}->{$TimeZone} ) {
        print
            "Enter the time zone to use for $Param{ConfigKey} (leave empty to show a list of all available time zones): ";
        $TimeZone = <>;

        # Remove white space
        $TimeZone =~ s{\s}{}smx;

        if ( length $TimeZone ) {
            if ( !$Param{TimeZones}->{$TimeZone} ) {
                print "Invalid time zone.\n";
            }
        }
        else {
            # Show list of all available time zones
            print join( "\n", sort keys %{ $Param{TimeZones} } ) . "\n";
        }
    }

    return $TimeZone;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
