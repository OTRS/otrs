# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::FollowUpCheck::ExternalTicketNumberRecognition;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::FollowUpCheck::ExternalTicketNumberRecognition',
        Value         => 'Checking if ticket number has been found already by ExternalTicketNumberRecognition filter.',
    );

    my $Tn = $Param{GetParam}->{'X-OTRS-FollowUp-RecognizedTicketNumber'} || '';
    return if !$Tn;

    my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCheckNumber( Tn => $Tn );

    if ($TicketID) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::FollowUpCheck::ExternalTicketNumberRecognition',
            Value         => "Found valid TicketNumber '$Tn' (TicketID '$TicketID') in email.",
        );

        return $TicketID;
    }

    return;
}

1;
