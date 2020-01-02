# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::PackageManagerCheckNotVerifiedPackages;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Group',
    'Kernel::System::SysConfig',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # Check if setting is activated.
    my $PackageAllowNotVerifiedPackages = $Kernel::OM->Get('Kernel::Config')->Get('Package::AllowNotVerifiedPackages');
    return '' if !$PackageAllowNotVerifiedPackages;

    # Check permissions.
    my $Group         = $Param{Config}->{Group} || 'admin';
    my $HasPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
        UserID    => $Self->{UserID},
        GroupName => $Group,
        Type      => 'rw',
    );

    return '' if !$HasPermission;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    return $LayoutObject->Notify(
        Priority => 'Error',
        Data     => $LayoutObject->{LanguageObject}->Translate(
            'The installation of packages which are not verified by the OTRS Group is activated. These packages could threaten your whole system! It is recommended not to use unverified packages.'
        ),
        Link =>
            $LayoutObject->{Baselink}
            . 'Action=AdminSystemConfiguration;Subaction=View;Setting=Package%3A%3AAllowNotVerifiedPackages;',
    );
}

1;
