# --
# Kernel/System/GenericAgent/AutoPriorityIncrease.pm - generic agent auto priority increase
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AutoPriorityIncrease.pm,v 1.8 2008-05-08 09:36:21 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::GenericAgent::AutoPriorityIncrease;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject TicketObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need TimeInterval param for GenericAgent module!',
        );
        return;
    }

    $Param{New}->{TimeInterval} = $Param{New}->{TimeInterval} * 60;

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(%Param);
    my @HistoryLines = $Self->{TicketObject}->HistoryGet( %Param, UserID => 1 );

    # find latest auto priority update
    for my $History (@HistoryLines) {
        if ( $History->{Name} =~ /^AutoPriorityIncrease/ ) {
            $LatestAutoIncrease = $History->{CreateTime};
        }
    }
    if ( !$LatestAutoIncrease ) {
        $LatestAutoIncrease = $Ticket{Created};
    }
    $LatestAutoIncrease
        = $Self->{TimeObject}->TimeStamp2SystemTime( String => $LatestAutoIncrease, );
    if (
        ( $Self->{TimeObject}->SystemTime() - $LatestAutoIncrease )
        > $Param{New}->{TimeInterval}
        )
    {
        $Update = 1;
    }

    # check if priority needs to be increased
    if ( !$Update ) {

        # do nothing
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message =>
                    "Nothing to do on (Ticket=$Ticket{TicketNumber}/TicketID=$Ticket{TicketID})!",
            );
        }
        return 1;
    }

    # increase priority
    my $Priority
        = $Self->{PriorityObject}->PriorityLookup( PriorityID => ( $Ticket{PriorityID} + 1 ) );

    # do nothing if already highest priority
    if ( !$Priority ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "Ticket=$Ticket{TicketNumber}/TicketID=$Ticket{TicketID} already set to higest priority! Can't increase priority!",
        );
        return 1;
    }

    # increase priority
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message =>
            "Increase priority of (Ticket=$Ticket{TicketNumber}/TicketID=$Ticket{TicketID}) to $Priority!",
    );

    $Self->{TicketObject}->PrioritySet(
        TicketID   => $Param{TicketID},
        PriorityID => ( $Ticket{PriorityID} + 1 ),
        UserID     => 1,
    );

    $Self->{TicketObject}->HistoryAdd(
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
