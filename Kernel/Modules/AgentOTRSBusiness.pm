# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentOTRSBusiness;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Subaction} eq 'BlockScreen' ) {
        return $Self->BlockScreen();
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    return $LayoutObject->ErrorScreen(
        Message => 'Need Subaction.',
    );
}

sub BlockScreen {
    my ( $Self, %Param ) = @_;

    # Verify that current user has right permission for downgrade action.
    # See bug#14842 (https://bugs.otrs.org/show_bug.cgi?id=14842).
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
    my $Groups      = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')->{AdminOTRSBusiness}->{Group};
    if ( !IsArrayRefWithData($Groups) ) {
        push @{$Groups}, 'admin';
    }

    my $HasPermission;
    GROUPS:
    for my $Group ( @{$Groups} ) {

        $HasPermission = $GroupObject->PermissionCheck(
            UserID    => $Self->{UserID},
            GroupName => $Group,
            Type      => 'rw',
        );
        last GROUPS if $HasPermission;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentOTRSBusinessBlockScreen',
        Data         => {
            OTRSSTORMIsInstalled   => $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSSTORMIsInstalled(),
            OTRSCONTROLIsInstalled => $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSCONTROLIsInstalled(),
            HasPermission          => $HasPermission,
        },
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
