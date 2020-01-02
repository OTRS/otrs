# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::Filter::FollowUpArticleVisibilityCheck;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::CustomerUser',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get parser object
    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject!";

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # This filter is not needed if there is no TicketID.
    return 1 if !$Param{TicketID};

    # check needed stuff
    for (qw(JobConfig GetParam UserID)) {
        if ( !$Param{$_} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::FollowUpArticleVisibilityCheck',
                Value         => "Need $_!",
            );
            return;
        }
    }

    # Only run if we have a follow-up article with SenderType 'customer'.
    #   It could be that follow-ups have a different SenderType like 'system' for
    #   automatic notifications. In these cases there is no need to hide them.
    #   See also bug#10182 for details.
    if (
        !$Param{GetParam}->{'X-OTRS-FollowUp-SenderType'}
        || $Param{GetParam}->{'X-OTRS-FollowUp-SenderType'} ne 'customer'
        )
    {
        return 1;
    }

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID => $Param{TicketID},
        UserID   => $Param{UserID},
    );

    # Check if it is a known customer, otherwise use email address from CustomerUserID field of the ticket.
    my %CustomerData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
        User => $Ticket{CustomerUserID},
    );
    my $CustomerEmailAddress = $CustomerData{UserEmail} || $Ticket{CustomerUserID};

    # Email sender address
    my $SenderAddress = $Param{GetParam}->{'X-Sender'};

    # Email Reply-To address for forwarded emails
    my $ReplyToAddress;
    if ( $Param{GetParam}->{ReplyTo} ) {
        $ReplyToAddress = $Self->{ParserObject}->GetEmailAddress(
            Email => $Param{GetParam}->{ReplyTo},
        );
    }

    # check if current sender is customer (do nothing)
    if ( $CustomerEmailAddress && $SenderAddress ) {
        return 1 if lc $CustomerEmailAddress eq lc $SenderAddress;
    }

    my @References = $Self->{ParserObject}->GetReferences();

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # Get all internal email articles sent by agents.
    my @MetaArticleIndex = $ArticleObject->ArticleList(
        TicketID             => $Param{TicketID},
        CommunicationChannel => 'Email',
        SenderType           => 'agent',
        IsVisibleForCustomer => 0,
    );
    return 1 if !@MetaArticleIndex;

    my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

    # check if current sender got an internal forward
    my $IsInternalForward;
    ARTICLE:
    for my $MetaArticle ( reverse @MetaArticleIndex ) {

        my $Article = {
            $ArticleBackendObject->ArticleGet( %{$MetaArticle} )
        };

        # check recipients
        next ARTICLE if !$Article->{To};

        # check based on recipient addresses of the article
        my @ToEmailAddresses = $Self->{ParserObject}->SplitAddressLine(
            Line => $Article->{To},
        );
        my @CcEmailAddresses = $Self->{ParserObject}->SplitAddressLine(
            Line => $Article->{Cc},
        );
        my @EmailAdresses = ( @ToEmailAddresses, @CcEmailAddresses );

        EMAIL:
        for my $Email (@EmailAdresses) {
            my $Recipient = $Self->{ParserObject}->GetEmailAddress(
                Email => $Email,
            );
            if ( lc $Recipient eq lc $SenderAddress ) {
                $IsInternalForward = 1;
                last ARTICLE;
            }
            if ( $ReplyToAddress && lc $Recipient eq lc $ReplyToAddress ) {
                $IsInternalForward = 1;
                last ARTICLE;
            }
        }

        # check based on Message-ID of the article
        for my $Reference (@References) {
            if ( $Article->{MessageID} && $Article->{MessageID} eq $Reference ) {
                $IsInternalForward = 1;
                last ARTICLE;
            }
        }
    }

    return 1 if !$IsInternalForward;

    $Param{GetParam}->{'X-OTRS-FollowUp-IsVisibleForCustomer'} = $Param{JobConfig}->{IsVisibleForCustomer} // 0;
    $Param{GetParam}->{'X-OTRS-FollowUp-SenderType'}           = $Param{JobConfig}->{SenderType} || 'customer';

    return 1;
}

1;
