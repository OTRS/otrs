# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::TimeSettings;

use strict;
use warnings;

use POSIX;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);
use Kernel::System::DateTime;

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('OTRS') . '/' . Translatable('Time Settings');
}

sub Run {
    my $Self = shift;

    # Server time zone
    my $ServerTimeZone = POSIX::tzname();

    $Self->AddResultOk(
        Identifier => 'ServerTimeZone',
        Label      => Translatable('Server time zone'),
        Value      => $ServerTimeZone,
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # OTRS time zone
    my $OTRSTimeZone = $ConfigObject->Get('OTRSTimeZone');
    if ( defined $OTRSTimeZone ) {
        $Self->AddResultOk(
            Identifier => 'OTRSTimeZone',
            Label      => Translatable('OTRS time zone'),
            Value      => $OTRSTimeZone,
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'OTRSTimeZone',
            Label      => Translatable('OTRS time zone'),
            Value      => '',
            Message    => Translatable('OTRS time zone is not set.'),
        );
    }

    # User default time zone
    my $UserDefaultTimeZone = $ConfigObject->Get('UserDefaultTimeZone');
    if ( defined $UserDefaultTimeZone ) {
        $Self->AddResultOk(
            Identifier => 'UserDefaultTimeZone',
            Label      => Translatable('User default time zone'),
            Value      => $UserDefaultTimeZone,
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'UserDefaultTimeZone',
            Label      => Translatable('User default time zone'),
            Value      => '',
            Message    => Translatable('User default time zone is not set.'),
        );
    }

    # Calendar time zones
    for my $Counter ( 1 .. 9 ) {
        my $CalendarTimeZone = $ConfigObject->Get( 'TimeZone::Calendar' . $Counter );

        if ( defined $CalendarTimeZone ) {
            $Self->AddResultOk(
                Identifier => "OTRSTimeZone::Calendar$Counter",

             # Use of $LanguageObject->Translate() is not possible to avoid translated strings to be sent to OTRS Group.
                Label => "OTRS time zone setting for calendar $Counter",
                Value => $CalendarTimeZone,
            );
        }
        else {
            $Self->AddResultInformation(
                Identifier => "OTRSTimeZone::Calendar$Counter",

             # Use of $LanguageObject->Translate() is not possible to avoid translated strings to be sent to OTRS Group.
                Label   => "OTRS time zone setting for calendar $Counter",
                Value   => '',
                Message => Translatable('Calendar time zone is not set.'),
            );
        }
    }

    return $Self->GetResults();
}

1;
