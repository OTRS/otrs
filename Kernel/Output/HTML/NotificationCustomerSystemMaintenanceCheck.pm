# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationCustomerSystemMaintenanceCheck;

use strict;
use warnings;

use Kernel::System::SystemMaintenance;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject LogObject DBObject LayoutObject TimeObject UserObject UserID)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # create additional objects
    $Self->{SystemMaintenanceObject} = Kernel::System::SystemMaintenance->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ActiveMaintenance = $Self->{SystemMaintenanceObject}->SystemMaintenanceIsActive();

    # check if system maintenance is active
    if ($ActiveMaintenance) {

        my $SystemMaintenanceData = $Self->{SystemMaintenanceObject}->SystemMaintenanceGet(
            ID     => $ActiveMaintenance,
            UserID => $Self->{UserID},
        );

        my $NotifyMessage =
            $SystemMaintenanceData->{NotifyMessage}
            || $Self->{ConfigObject}->Get('SystemMaintenance::IsActiveDefaultNotification')
            || "System maintenance is active!";

        return $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Data =>
                $Self->{LayoutObject}->{LanguageObject}->Translate(
                $NotifyMessage,
                ),
        );
    }

    my $SystemMaintenanceIsComming = $Self->{SystemMaintenanceObject}->SystemMaintenanceIsComming();

    if ($SystemMaintenanceIsComming) {

        my $MaintenanceTime = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $SystemMaintenanceIsComming,
        );
        return $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Data =>
                $Self->{LayoutObject}->{LanguageObject}->Translate(
                "A system maintenance period will start at: "
                )
                . $MaintenanceTime,
        );

    }

    return '';
}

1;
