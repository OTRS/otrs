# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Notification::AgentTimeZoneCheck;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::DateTime;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::User',
    'Kernel::Output::HTML::Layout',
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $ShowUserTimeZoneSelectionNotification
        = $Kernel::OM->Get('Kernel::Config')->Get('ShowUserTimeZoneSelectionNotification');
    return '' if !$ShowUserTimeZoneSelectionNotification;

    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );
    return '' if !%UserPreferences;
    return '' if defined $UserPreferences{UserTimeZone} && length $UserPreferences{UserTimeZone};

    # If OTRSTimeZone and UserDefaultTimeZone match and are not set to UTC, don't show a notification,
    # because in this case it almost certainly means that only this time zone is relevant.
    my $OTRSTimeZone        = Kernel::System::DateTime->OTRSTimeZoneGet();
    my $UserDefaultTimeZone = Kernel::System::DateTime->UserDefaultTimeZoneGet();
    return '' if $OTRSTimeZone eq $UserDefaultTimeZone && $OTRSTimeZone ne 'UTC';

    # show notification to set time zone
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    return $LayoutObject->Notify(
        Priority => 'Notice',
        Link     => $LayoutObject->{Baselink} . 'Action=AgentPreferences;Subaction=Group;Group=UserProfile',
        Info =>
            Translatable('Please select a time zone in your preferences and confirm it by clicking the save button.'),
    );
}

1;
