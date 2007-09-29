# --
# Kernel/Modules/AgentZoom.pm - to get a closer view
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentZoom.pm,v 1.89 2007-09-29 10:44:28 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentZoom;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.89 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
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
    $Redirect =~ s/AgentZoom/AgentTicketZoom/;
    return $Self->{LayoutObject}->Redirect( OP => $Redirect );
}

1;
