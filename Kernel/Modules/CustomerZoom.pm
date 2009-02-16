# --
# Kernel/Modules/CustomerZoom.pm - to get a closer view
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: CustomerZoom.pm,v 1.39 2009-02-16 11:20:53 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerZoom;

use strict;
use warnings;

use Kernel::System::State;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.39 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject )) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # compat link
    my $Redirect = $ENV{REQUEST_URI};
    $Redirect =~ s/CustomerZoom/CustomerTicketZoom/;
    return $Self->{LayoutObject}->Redirect( OP => $Redirect );
}

1;
