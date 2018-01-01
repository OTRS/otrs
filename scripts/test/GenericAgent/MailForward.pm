# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

    # check needed param
    if ( !$Param{New}->{'TargetAddress'} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TargetAddress param for GenericAgent module!',
        );
        return;
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        %Param,
        UserID => 1,
    );

    my %Article = $TicketObject->ArticleFirstArticle(
        %Param,
        UserID => 1,
    );

    return if !(%Article);

    my %AttachmentIndex = $TicketObject->ArticleAttachmentIndex(
        %Article,
        UserID => 1,
    );

    my @Attachments;

    for my $FileID ( sort { $a <=> $b } keys %AttachmentIndex ) {
        my %Attachment = $TicketObject->ArticleAttachment(
            %Article,
            UserID => 1,
            FileID => $FileID,
        );
        if (%Attachment) {
            push @Attachments, \%Attachment;
        }
    }

    my %FromQueue = $Kernel::OM->Get('Kernel::System::Queue')->GetSystemAddress( QueueID => $Ticket{QueueID} );

    $TicketObject->ArticleSend(
        %Article,
        Attachment     => \@Attachments,
        To             => scalar $Param{New}->{'TargetAddress'},
        From           => "$FromQueue{RealName} <$FromQueue{Email}>",
        ArticleType    => 'email-internal',
        ArticleTypeID  => undef,                                        # overwrite from %Article
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
