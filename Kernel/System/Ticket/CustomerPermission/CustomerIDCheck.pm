# --
# Kernel/System/Ticket/CustomerPermission/CustomerIDCheck.pm - the sub
# module of the global ticket handle
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CustomerIDCheck.pm,v 1.11 2008-04-25 09:04:24 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Ticket::CustomerPermission::CustomerIDCheck;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

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

    # check customer id
    my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $Param{UserID} );

    # get customer ids
    my @CustomerIDs = $Self->{CustomerUserObject}->CustomerIDs( User => $Param{UserID} );

    # add own customer id
    if ( $CustomerData{UserCustomerID} ) {
        push( @CustomerIDs, $CustomerData{UserCustomerID} );
    }

    # check customer id s
    for my $CustomerID (@CustomerIDs) {
        if ( $Ticket{CustomerID} && $Ticket{CustomerID} =~ /^\Q$CustomerID\E$/i ) {
            return 1;
        }
    }
    return;
}

1;
