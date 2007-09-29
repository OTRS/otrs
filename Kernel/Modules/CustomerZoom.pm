# --
# Kernel/Modules/CustomerZoom.pm - to get a closer view
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CustomerZoom.pm,v 1.35 2007-09-29 10:41:48 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerZoom;

use strict;
use warnings;

use Kernel::System::State;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.35 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject )) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my $Self  = shift;
    my %Param = @_;

    # compat link
    my $Redirect = $ENV{REQUEST_URI};
    $Redirect =~ s/CustomerZoom/CustomerTicketZoom/;
    return $Self->{LayoutObject}->Redirect( OP => $Redirect );
}

1;
