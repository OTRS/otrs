# --
# Kernel/Modules/PublicDefault.pm - provides a default public module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: PublicDefault.pm,v 1.2 2008-10-29 14:47:49 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::PublicDefault;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject LayoutObject LogObject ConfigObject MainObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # build header
    my $Output = $Self->{LayoutObject}->CustomerHeader(
        Type  => '',
        Title => '',
    );

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'PublicDefault',
    );

    # build footer
    $Output .= $Self->{LayoutObject}->CustomerFooter(
        Type => '',
    );

    return $Output;
}

1;
