# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Notification::CustomerSystemMaintenanceCheck;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::SystemMaintenance',
    'Kernel::Output::HTML::Layout',
    'Kernel::Config',
    'Kernel::System::Time',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $SystemMaintenanceObject = $Kernel::OM->Get('Kernel::System::SystemMaintenance');
    my $LayoutObject            = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ActiveMaintenance = $SystemMaintenanceObject->SystemMaintenanceIsActive();

    # check if system maintenance is active
    if ($ActiveMaintenance) {

        my $SystemMaintenanceData = $SystemMaintenanceObject->SystemMaintenanceGet(
            ID     => $ActiveMaintenance,
            UserID => $Self->{UserID},
        );

        my $NotifyMessage =
            $SystemMaintenanceData->{NotifyMessage}
            || $Kernel::OM->Get('Kernel::Config')->Get('SystemMaintenance::IsActiveDefaultNotification')
            || "System maintenance is active!";

        return $LayoutObject->Notify(
            Priority => 'Notice',
            Data =>
                $LayoutObject->{LanguageObject}->Translate(
                $NotifyMessage,
                ),
        );
    }

    my $SystemMaintenanceIsComing = $SystemMaintenanceObject->SystemMaintenanceIsComing();

    if ($SystemMaintenanceIsComing) {

        my $MaintenanceTime = $Kernel::OM->Get('Kernel::System::Time')->SystemTime2TimeStamp(
            SystemTime => $SystemMaintenanceIsComing,
        );
        return $LayoutObject->Notify(
            Priority => 'Notice',
            Data =>
                $LayoutObject->{LanguageObject}->Translate(
                "A system maintenance period will start at: "
                )
                . $MaintenanceTime,
        );

    }

    return '';
}

1;
