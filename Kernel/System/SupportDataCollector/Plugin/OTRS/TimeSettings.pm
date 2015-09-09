# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::TimeSettings;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

use strict;
use warnings;

use POSIX;
use Time::Local;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('OTRS/Time Settings');
}

sub Run {
    my $Self = shift;

    my $Dummy          = localtime();       ## no critic
    my $ServerTimeZone = POSIX::tzname();

    $Self->AddResultInformation(
        Identifier => 'ServerTimeZone',
        Label      => Translatable('Server time zone'),
        Value      => $ServerTimeZone,
    );

    my $ServerTime      = time();
    my $ServerLocalTime = Time::Local::timegm_nocheck( localtime($ServerTime) );

    # Check if local time and UTC time are different
    my $ServerTimeDiff = $ServerLocalTime - $ServerTime;

    # calculate offset - should be '+0200', '-0600', '+0545' or '+0000'
    my $Direction   = $ServerTimeDiff < 0 ? '-' : '+';
    my $DiffHours   = abs int( $ServerTimeDiff / 3600 );
    my $DiffMinutes = abs int( ( $ServerTimeDiff % 3600 ) / 60 );

    $Self->AddResultInformation(
        Identifier => 'ServerTimeOffset',
        Label      => Translatable('Computed server time offset'),
        Value      => sprintf( '%s%02d%02d', $Direction, $DiffHours, $DiffMinutes ),
    );

    my $OTRSTimeZone = $Kernel::OM->Get('Kernel::Config')->Get('TimeZone');

    if ( $ServerTimeDiff && $OTRSTimeZone && $OTRSTimeZone ne '+0' ) {
        $Self->AddResultProblem(
            Identifier => 'OTRSTimeZone',
            Label      => Translatable('OTRS TimeZone setting (global time offset)'),
            Value      => $OTRSTimeZone,
            Message    => Translatable('TimeZone may only be activated for systems running in UTC.'),
        );
    }
    else {
        $Self->AddResultOk(
            Identifier => 'OTRSTimeZone',
            Label      => Translatable('OTRS TimeZone setting (global time offset)'),
            Value      => $OTRSTimeZone,
        );
    }

    my $OTRSTimeZoneUser = $Kernel::OM->Get('Kernel::Config')->Get('TimeZoneUser');

    if ( $OTRSTimeZoneUser && ( $ServerTimeDiff || ( $OTRSTimeZone && $OTRSTimeZone ne '+0' ) ) ) {
        $Self->AddResultProblem(
            Identifier => 'OTRSTimeZoneUser',
            Label      => Translatable('OTRS TimeZoneUser setting (per-user time zone support)'),
            Value      => $OTRSTimeZoneUser,
            Message    => Translatable(
                'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.'),
        );
    }
    else {
        $Self->AddResultOk(
            Identifier => 'OTRSTimeZoneUser',
            Label      => Translatable('OTRS TimeZoneUser setting (per-user time zone support)'),
            Value      => $OTRSTimeZoneUser,
        );
    }

    for my $Counter ( 1 .. 9 ) {
        my $CalendarTimeZone = $Kernel::OM->Get('Kernel::Config')->Get( 'TimeZone::Calendar' . $Counter );
        if ( $ServerTimeDiff && $CalendarTimeZone && $CalendarTimeZone ne '+0' ) {
            $Self->AddResultProblem(
                Identifier => "OTRSTimeZone::Calendar$Counter",
                Label      => Translatable('OTRS TimeZone setting for calendar ') . $Counter,
                Value      => $CalendarTimeZone,
                Message    => Translatable('TimeZone may only be activated for systems running in UTC.'),
            );
        }
        else {
            $Self->AddResultOk(
                Identifier => "OTRSTimeZone::Calendar$Counter",
                Label      => Translatable('OTRS TimeZone setting for calendar ') . $Counter,
                Value      => $CalendarTimeZone,
            );
        }
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
