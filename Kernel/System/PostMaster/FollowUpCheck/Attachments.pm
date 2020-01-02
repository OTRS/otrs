# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::FollowUpCheck::Attachments;

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

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # Ignore all inline parts as these are actually part of the email body.
    my @Attachments = $Self->{ParserObject}->GetAttachments();
    @Attachments = grep { defined $_->{ContentDisposition} && $_->{ContentDisposition} ne 'inline' } @Attachments;

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::FollowUpCheck::Attachments',
        Value         => 'Searching for TicketNumber in email attachments.',
    );

    ATTACHMENT:
    for my $Attachment (@Attachments) {

        my $Tn = $TicketObject->GetTNByString( $Attachment->{Content} );
        next ATTACHMENT if !$Tn;

        my $TicketID = $TicketObject->TicketCheckNumber( Tn => $Tn );

        if ($TicketID) {

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::FollowUpCheck::Attachments',
                Value =>
                    "Found valid TicketNumber '$Tn' (TicketID '$TicketID') in email attachment '$Attachment->{Filename}'.",
            );

            return $TicketID;
        }
    }

    return;
}

1;
