# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
                Message  => "Need $_!",
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

    return if !%Ticket;
    return if !$Ticket{CustomerID};

    # get customer user object
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # get customer ids
    my @CustomerIDs = $CustomerUserObject->CustomerIDs(
        User => $Param{UserID},
    );

    # check customer ids, return access if customer id is the same
    CUSTOMERID:
    for my $CustomerID (@CustomerIDs) {

        next CUSTOMERID if !$CustomerID;

        return 1 if lc $Ticket{CustomerID} eq lc $CustomerID;
    }

    # return no access
    return;
}

1;
