# --
# Kernel/System/Ticket/CustomerPermission/CustomerIDCheck.pm - the sub
# module of the global ticket handle
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: CustomerIDCheck.pm,v 1.7 2006-08-29 17:26:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::CustomerPermission::CustomerIDCheck;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject TicketObject CustomerUserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Param{TicketID});
    # check customer id
    my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $Param{UserID});
    # get customer ids
    my @CustomerIDs = $Self->{CustomerUserObject}->CustomerIDs(User => $Param{UserID});
    # add own customer id
    if ($CustomerData{UserCustomerID}) {
        push (@CustomerIDs, $CustomerData{UserCustomerID});
    }
    # check customer id s
    foreach my $CustomerID (@CustomerIDs) {
        if ($Ticket{CustomerID} && $Ticket{CustomerID} =~ /^\Q$CustomerID\E$/i) {
            return 1;
        }
    }
    return;
}
# --

1;
