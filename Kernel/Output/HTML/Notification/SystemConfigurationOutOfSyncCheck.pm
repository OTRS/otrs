# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::SystemConfigurationOutOfSyncCheck;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Group',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::SysConfig'
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $Group = $Param{Config}->{Group} || 'admin';

    my $HasPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
        UserID    => $Self->{UserID},
        GroupName => $Group,
        Type      => 'rw',
    );

    return '' if !$HasPermission;

    my $CurrentDeploymentID = $Kernel::OM->Get('Kernel::Config')->Get('CurrentDeploymentID') || 0;

    my %LastDeployment = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationDeployGetLast();

    # Quit silently if the DeploymentID from configuration match the latest from DB.
    return '' if !%LastDeployment;
    return '' if $CurrentDeploymentID == $LastDeployment{DeploymentID};

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $CurrentDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime'
    );

    my $DeploymentDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $LastDeployment{CreateTime},
        },
    );

    my $AllowedDelayMinutes = $Param{Config}->{AllowedDelayMinutes} || 5;
    my $Success             = $DeploymentDateTimeObject->Add(
        Minutes => $AllowedDelayMinutes,
    );

    # Check if deployment delay is within the limits (return a warning).
    if ( $DeploymentDateTimeObject >= $CurrentDateTimeObject ) {
        return $LayoutObject->Notify(
            Priority => 'Warning',
            Data =>
                $LayoutObject->{LanguageObject}->Translate("The configuration is being updated, please be patient..."),
        );
    }

    return $LayoutObject->Notify(
        Priority => 'Error',
        Data     => $LayoutObject->{LanguageObject}->Translate("There is an error updating the system configuration!"),
    );
}

1;
