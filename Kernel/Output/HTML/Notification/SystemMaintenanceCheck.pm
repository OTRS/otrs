# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::SystemMaintenanceCheck;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DateTime',
    'Kernel::System::SystemMaintenance',
    'Kernel::Output::HTML::Layout',
    'Kernel::Config',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get system maintenance object
    my $SystemMaintenanceObject = $Kernel::OM->Get('Kernel::System::SystemMaintenance');

    my $ActiveMaintenance = $SystemMaintenanceObject->SystemMaintenanceIsActive();

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check if system maintenance is active
    if ($ActiveMaintenance) {

        my $SystemMaintenanceData = $SystemMaintenanceObject->SystemMaintenanceGet(
            ID     => $ActiveMaintenance,
            UserID => $Self->{UserID},
        );

        my $NotifyMessage =
            $SystemMaintenanceData->{NotifyMessage}
            || $Kernel::OM->Get('Kernel::Config')->Get('SystemMaintenance::IsActiveDefaultNotification')
            || $LayoutObject->{LanguageObject}->Translate("System maintenance is active!");

        return $LayoutObject->Notify(
            Priority => 'Notice',
            Data =>
                $LayoutObject->{LanguageObject}->Translate(
                $NotifyMessage,
                ),
        );
    }

    my %SystemMaintenanceIsComing = $SystemMaintenanceObject->SystemMaintenanceIsComing();

    if (%SystemMaintenanceIsComing) {

        my $MaintenanceStartDateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $SystemMaintenanceIsComing{StartDate},
            },
        );
        my $MaintenanceStartDateTime = $LayoutObject->{LanguageObject}->FormatTimeString(
            $MaintenanceStartDateTimeObject->ToString(),
            'DateFormat',
            1,
        );

        my $MaintenanceStopDateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $SystemMaintenanceIsComing{StopDate},
            },
        );
        my $MaintenanceStopDateTime = $LayoutObject->{LanguageObject}->FormatTimeString(
            $MaintenanceStopDateTimeObject->ToString(),
            'DateFormat',
            1,
        );

        return $LayoutObject->Notify(
            Priority => 'Notice',
            Data =>
                $LayoutObject->{LanguageObject}->Translate(
                "A system maintenance period will start at: %s and is expected to stop at: %s",
                $MaintenanceStartDateTime, $MaintenanceStopDateTime
                ),
        );

    }

    return '';
}

1;
