# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::GenericAgent::AutoPriorityIncrease;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DateTime',
    'Kernel::System::Log',
    'Kernel::System::Priority',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Update             = 0;
    my $LatestAutoIncrease = 0;

    # check needed param
    if ( !$Param{New}->{'TimeInterval'} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TimeInterval param for GenericAgent module!',
        );
        return;
    }

    $Param{New}->{TimeInterval} = $Param{New}->{TimeInterval} * 60;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket data
    my %Ticket = $TicketObject->TicketGet(
        %Param,
        DynamicFields => 0,
    );
    my @HistoryLines = $TicketObject->HistoryGet( %Param, UserID => 1 );

    # find latest auto priority update
    for my $History (@HistoryLines) {
        if ( $History->{Name} =~ /^AutoPriorityIncrease/ ) {
            $LatestAutoIncrease = $History->{CreateTime};
        }
    }
    if ( !$LatestAutoIncrease ) {
        $LatestAutoIncrease = $Ticket{Created};
    }

    # get time object
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $SystemTime     = $DateTimeObject->ToEpoch();

    $LatestAutoIncrease = $DateTimeObject->Set(
        String => $LatestAutoIncrease,
    );

    $LatestAutoIncrease = $LatestAutoIncrease ? $DateTimeObject->ToEpoch() : undef;

    if (
        ( $SystemTime - $LatestAutoIncrease )
        > $Param{New}->{TimeInterval}
        )
    {
        $Update = 1;
    }

    # check if priority needs to be increased
    if ( !$Update ) {

        # do nothing
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message =>
                    "Nothing to do on (Ticket=$Ticket{TicketNumber}/TicketID=$Ticket{TicketID})!",
            );
        }
        return 1;
    }

    # increase priority
    my $Priority = $Kernel::OM->Get('Kernel::System::Priority')->PriorityLookup(
        PriorityID => ( $Ticket{PriorityID} + 1 ),
    );

    # do nothing if already highest priority
    if ( !$Priority ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message =>
                "Ticket=$Ticket{TicketNumber}/TicketID=$Ticket{TicketID} already set to higest priority! Can't increase priority!",
        );
        return 1;
    }

    # increase priority
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'notice',
        Message =>
            "Increase priority of (Ticket=$Ticket{TicketNumber}/TicketID=$Ticket{TicketID}) to $Priority!",
    );

    $TicketObject->TicketPrioritySet(
        TicketID   => $Param{TicketID},
        PriorityID => ( $Ticket{PriorityID} + 1 ),
        UserID     => 1,
    );

    $TicketObject->HistoryAdd(
        Name => "AutoPriorityIncrease (Priority=$Priority/PriorityID="
            . ( $Ticket{PriorityID} + 1 ) . ")",
        HistoryType  => 'Misc',
        TicketID     => $Param{TicketID},
        UserID       => 1,
        CreateUserID => 1,
    );

    return 1;
}

1;
