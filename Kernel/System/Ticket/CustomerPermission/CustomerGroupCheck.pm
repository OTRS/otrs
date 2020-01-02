# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::CustomerPermission::CustomerGroupCheck;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerGroup',
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
    for my $Needed (qw(TicketID UserID Type)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
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

    # only active if customer group support is enabled
    return if !$Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupSupport');

    # only active if extra permission context is enabled
    my $CustomerGroupObject    = $Kernel::OM->Get('Kernel::System::CustomerGroup');
    my $ExtraPermissionContext = $CustomerGroupObject->GroupContextNameGet(
        SysConfigName => '100-CustomerID-other',
    );
    return if !$ExtraPermissionContext;

    # get customer user object
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # get all customer ids
    my @CustomerIDs = $CustomerUserObject->CustomerIDs(
        User => $Param{UserID},
    );

    # check all CustomerIDs for access to other CustomerIDs via group assignment
    for my $CustomerID (@CustomerIDs) {
        my %GroupList = $CustomerGroupObject->GroupCustomerList(
            CustomerID => $CustomerID,
            Type       => $Param{Type},
            Context    => $ExtraPermissionContext,
            Result     => 'HASH',
        );
        return 1 if $GroupList{ $Ticket{GroupID} };
    }

    # return no access
    return;
}

1;
