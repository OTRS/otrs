# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentOTRSBusinessBlockScreen',
        Data         => {
            OTRSSTORMIsInstalled => $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSSTORMIsInstalled(),
        },
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
