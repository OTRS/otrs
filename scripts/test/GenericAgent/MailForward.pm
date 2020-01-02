# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

#
# Forwards the first ticket article to the configured TargetAddress.
#

package scripts::test::GenericAgent::MailForward;    ## no critic

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Queue',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !$Param{New}->{'TargetAddress'} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TargetAddress param for GenericAgent module!',
        );
        return;
    }

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        %Param,
        UserID => 1,
    );

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject;

    my @Articles = $ArticleObject->ArticleList(
        %Param,
        OnlyFirst => 1,
    );
    my %Article;
    for my $Article (@Articles) {
        $ArticleBackendObject = $ArticleObject->BackendForArticle(
            %Param,
            ArticleID => $Article->{ArticleID},
        );
        %Article = $ArticleBackendObject->ArticleGet(
            %Param,
            ArticleID => $Article->{ArticleID},
        );
    }
    return if !(%Article);

    my %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(%Article);

    my @Attachments;

    for my $FileID ( sort { $a <=> $b } keys %AttachmentIndex ) {
        my %Attachment = $ArticleBackendObject->ArticleAttachment(
            %Article,
            FileID => $FileID,
        );
        if (%Attachment) {
            push @Attachments, \%Attachment;
        }
    }

    my %FromQueue = $Kernel::OM->Get('Kernel::System::Queue')->GetSystemAddress( QueueID => $Ticket{QueueID} );

    my $EmailArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

    $EmailArticleBackendObject->ArticleSend(
        %Article,
        Attachment     => \@Attachments,
        To             => scalar $Param{New}->{'TargetAddress'},
        From           => "$FromQueue{RealName} <$FromQueue{Email}>",
        SenderType     => 'system',
        SenderTypeID   => undef,                                        # overwrite from %Article
        HistoryType    => 'Forward',
        HistoryComment => 'Email was forwarded.',
        NoAgentNotify  => 1,
        UserID         => 1,
    );

    return 1;
}

1;
