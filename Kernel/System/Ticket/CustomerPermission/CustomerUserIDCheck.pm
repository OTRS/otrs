# --
# Kernel/System/Ticket/CustomerPermission/CustomerUserIDCheck.pm - the sub
# module of the global ticket handle
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CustomerUserIDCheck.pm,v 1.4 2007-09-29 10:53:34 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::CustomerPermission::CustomerUserIDCheck;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject TicketObject CustomerUserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my $Self  = shift;
    my %Param = @_;

    # check needed stuff
    for (qw(TicketID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    # get user data
    my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $Param{UserID} );

    # check user login
    if ( $Ticket{CustomerUserID} && $Ticket{CustomerUserID} =~ /^\Q$CustomerData{UserLogin}\E$/i ) {
        return 1;
    }
    return;
}

1;
