# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::SystemConfigurationIsDirtyCheck;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Group',
    'Kernel::System::SysConfig',
);

sub Run {
    my ( $Self, %Param ) = @_;

    if ( $Param{Type} eq 'Admin' ) {
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        my $Group = $Param{Config}->{Group} || 'admin';

        my $HasPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
            UserID    => $Self->{UserID},
            GroupName => $Group,
            Type      => 'rw',
        );

        return '' if !$HasPermission;

        my $Result = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationIsDirtyCheck(
            UserID => $Self->{UserID},
        );

        if ($Result) {

            return $LayoutObject->Notify(
                Priority => 'Notice',
                Link => $LayoutObject->{Baselink} . 'Action=AdminSystemConfigurationDeployment;Subaction=Deployment',
                Data => $LayoutObject->{LanguageObject}->Translate(
                    "You have undeployed settings, would you like to deploy them?"
                ),
            );
        }
    }

    return '';
}

1;
