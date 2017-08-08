# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::FollowUpCheck::Subject;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get communication log object and MessageID
    $Self->{CommunicationLogObject}    = $Param{CommunicationLogObject}    || die "Got no CommunicationLogObject!";
    $Self->{CommunicationLogMessageID} = $Param{CommunicationLogMessageID} || die "Got no CommunicationLogMessageID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectType => 'Message',
        ObjectID   => $Self->{CommunicationLogMessageID},
        Priority   => 'Debug',
        Key        => 'Kernel::System::PostMaster::FollowUpCheck::Subject',
        Value      => 'Searching for TicketNumber in email subject.',
    );

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $Subject = $Param{GetParam}->{Subject} || '';

    my $Tn = $TicketObject->GetTNByString($Subject);
    return if !$Tn;

    my $TicketID = $TicketObject->TicketCheckNumber( Tn => $Tn );

    if ($TicketID) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectType => 'Message',
            ObjectID   => $Self->{CommunicationLogMessageID},
            Priority   => 'Debug',
            Key        => 'Kernel::System::PostMaster::FollowUpCheck::Subject',
            Value      => "Found valid TicketNumber '$Tn' (TicketID '$TicketID') in email subject.",
        );

        return $TicketID;
    }

    return;
}

1;
