# --
# Kernel/System/Ticket/CustomerPermission/CustomerIDCheck.pm - the sub
# module of the global ticket handle
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::CustomerPermission::CustomerIDCheck;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # disable output of customer company tickets if configured
    return
        if $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::CustomerDisableCompanyTicketAccess');

    # get ticket data
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # get customer user object
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # check customer id
    my %CustomerData = $CustomerUserObject->CustomerUserDataGet( User => $Param{UserID} );

    # get customer ids
    my @CustomerIDs = $CustomerUserObject->CustomerIDs( User => $Param{UserID} );

    # add own customer id
    if ( $CustomerData{UserCustomerID} ) {
        push @CustomerIDs, $CustomerData{UserCustomerID};
    }

    # check customer ids, return access if customer id is the same
    CUSTOMERID:
    for my $CustomerID (@CustomerIDs) {
        next CUSTOMERID if !$Ticket{CustomerID};
        return 1 if ( lc $Ticket{CustomerID} eq lc $CustomerID );
    }

    # return no access
    return;
}

1;
