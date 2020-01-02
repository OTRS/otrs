# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::SystemConfigurationInvalidCheck;

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Group = $Param{Config}->{Group} || 'admin';

    my $HasPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
        UserID    => $Self->{UserID},
        GroupName => $Group,
        Type      => 'rw',
    );

    return '' if !$HasPermission;

    my @InvalidSettings = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationInvalidList(
        CachedOnly => 1,
    );

    if ( scalar @InvalidSettings ) {

        return $LayoutObject->Notify(
            Priority => 'Error',
            Link     => $LayoutObject->{Baselink} . 'Action=AdminSystemConfiguration;Subaction=Invalid',
            Data     => $LayoutObject->{LanguageObject}->Translate(
                "You have %s invalid setting(s) deployed. Click here to show invalid settings.",
                scalar @InvalidSettings,
            ),
        );
    }

    return '';
}

1;
