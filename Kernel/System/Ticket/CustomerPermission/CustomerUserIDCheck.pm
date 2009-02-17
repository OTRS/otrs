# --
# Kernel/System/Ticket/CustomerPermission/CustomerUserIDCheck.pm - the sub
# module of the global ticket handle
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: CustomerUserIDCheck.pm,v 1.8 2009-02-17 00:07:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::CustomerPermission::CustomerUserIDCheck;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

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
    my ( $Self, %Param ) = @_;

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

    # check user login, return access if customer user id is the same
    return if !$Ticket{CustomerUserID};
    return 1 if ( lc $Ticket{CustomerUserID} eq lc $CustomerData{UserLogin} );

    # return no access
    return;
}

1;
