# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::FollowUpCheck::References;

use strict;
use warnings;

use Kernel::System::ObjectManager;    # prevent used once warning

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Ticket::Article',
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

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectType => 'Message',
        ObjectID   => $Self->{CommunicationLogMessageID},
        Priority   => 'Debug',
        Key        => 'Kernel::System::PostMaster::FollowUpCheck::References',
        Value      => 'Searching for TicketID in email references.',
    );

    my @References = $Self->{ParserObject}->GetReferences();
    return if !@References;

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
        ChannelName => 'Email',
    );

    for my $Reference (@References) {

        my %Article = $ArticleBackendObject->ArticleGetByMessageID(
            MessageID => "<$Reference>",
        );

        if (%Article) {

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectType => 'Message',
                ObjectID   => $Self->{CommunicationLogMessageID},
                Priority   => 'Debug',
                Key        => 'Kernel::System::PostMaster::FollowUpCheck::References',
                Value      => "Found valid TicketID '$Article{TicketID}' in email references.",
            );

            return $Article{TicketID};
        }
    }

    return;
}

1;
