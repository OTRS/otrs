# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::FollowUpCheck::BounceEmail;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject";

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    # Get Article backend object.
    $Self->{ArticleBackendObject} =
        $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel( ChannelName => 'Email' );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->_AddCommunicationLog( Message => 'Searching for header X-OTRS-Bounce.' );

    return if !$Param{GetParam}->{'X-OTRS-Bounce'};

    my $BounceMessageID = $Param{GetParam}->{'X-OTRS-Bounce-OriginalMessageID'};

    $Self->_AddCommunicationLog(
        Message => sprintf(
            'Searching for article with message id "%s".',
            $BounceMessageID,
        ),
    );

    # Look for the article that is associated with the BounceMessageID
    my %Article = $Self->{ArticleBackendObject}->ArticleGetByMessageID(
        MessageID => $BounceMessageID,
    );

    return if !%Article;

    $Self->_AddCommunicationLog(
        Message => sprintf(
            'Found corresponding article ID "%s".',
            $Article{ArticleID},
        ),
    );

    $Self->_SetArticleTransmissionSendError(
        %Param,
        ArticleID => $Article{ArticleID},
    );

    return $Article{TicketID};
}

sub _SetArticleTransmissionSendError {
    my ( $Self, %Param ) = @_;

    my $ArticleID            = $Param{ArticleID};
    my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForChannel(
        ChannelName => 'Email',
    );

    my $BounceError     = $Param{GetParam}->{'X-OTRS-Bounce-ErrorMessage'};
    my $BounceMessageID = $Param{GetParam}->{'X-OTRS-Bounce-OriginalMessageID'};

    my $CurrentStatus = $ArticleBackendObject->ArticleGetTransmissionError(
        ArticleID => $ArticleID,
    );

    if ($CurrentStatus) {

        my $Result = $ArticleBackendObject->ArticleUpdateTransmissionError(
            ArticleID => $ArticleID,
            Message   => $BounceError,
        );

        if ( !$Result ) {

            my $ErrorMessage = sprintf(
                'Error while updating transmission error for article "%s"!',
                $ArticleID,
            );

            $Self->_AddCommunicationLog(
                Message  => $ErrorMessage,
                Priority => 'Error',
            );
        }

        return;
    }

    my $Result = $ArticleBackendObject->ArticleCreateTransmissionError(
        ArticleID => $ArticleID,
        MessageID => $BounceMessageID,
        Message   => $BounceError,
    );

    if ( !$Result ) {

        my $ErrorMessage = sprintf(
            'Error while creating transmission error for article "%s"!',
            $ArticleID,
        );

        $Self->_AddCommunicationLog(
            Message  => $ErrorMessage,
            Priority => 'Error',
        );

        return;
    }

    return;
}

sub _AddCommunicationLog {
    my ( $Self, %Param ) = @_;

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => $Param{Priority} || 'Debug',
        Key           => ref($Self),
        Value         => $Param{Message},
    );

    return;
}

1;
