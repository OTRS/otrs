# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentHTMLReference;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $Subaction    = $ParamObject->GetParam( Param => 'Subaction' ) || 'Overview';
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # security: cleanup input data to prevent directory traversal
    $Subaction =~ s{[./]}{}smxg;

    my $HeaderType = $ParamObject->GetParam( Param => 'Header' ) || '';

    # build output
    $Output .= $LayoutObject->Header(
        Title => 'AgentHTMLReference - ' . $Subaction,
        Type  => $HeaderType,
    );
    if ( !$HeaderType ) {
        $Output .= $LayoutObject->NavigationBar();
    }
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentHTMLReference' . $Subaction,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
