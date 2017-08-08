# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::FollowUpCheck::RawEmail;

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

    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject";

    # get communication log object and MessageID
    $Self->{CommunicationLogObject}    = $Param{CommunicationLogObject}    || die "Got no CommunicationLogObject!";
    $Self->{CommunicationLogMessageID} = $Param{CommunicationLogMessageID} || die "Got no CommunicationLogMessageID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectType => 'Message',
        ObjectID   => $Self->{CommunicationLogMessageID},
        Priority   => 'Debug',
        Key        => 'Kernel::System::PostMaster::FollowUpCheck::RawEmail',
        Value      => 'Searching for TicketNumber in raw email.',
    );

    my $Tn = $TicketObject->GetTNByString( $Self->{ParserObject}->GetPlainEmail() );
    return if !$Tn;

    my $TicketID = $TicketObject->TicketCheckNumber( Tn => $Tn );

    if ($TicketID) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectType => 'Message',
            ObjectID   => $Self->{CommunicationLogMessageID},
            Priority   => 'Debug',
            Key        => 'Kernel::System::PostMaster::FollowUpCheck::RawEmail',
            Value      => "Found valid TicketNumber '$Tn' (TicketID '$TicketID') in raw email.",
        );

        return $TicketID;
    }

    return;
}

1;
