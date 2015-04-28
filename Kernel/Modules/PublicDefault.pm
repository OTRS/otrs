# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::PublicDefault;

use strict;
use warnings;

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # build header
    my $Output = $LayoutObject->CustomerHeader(
        Type  => '',
        Title => '',
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'PublicDefault',
    );

    # build footer
    $Output .= $LayoutObject->CustomerFooter(
        Type => '',
    );

    return $Output;
}

1;
