# --
# Kernel/Modules/Admin.pm - provides admin main page
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Admin.pm,v 1.16 2008-01-31 06:22:11 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::Admin;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.16 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # build output
    my $Output = $Self->{LayoutObject}->Header();
    $Output   .= $Self->{LayoutObject}->NavigationBar();
    $Output   .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
