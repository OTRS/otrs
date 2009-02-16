# --
# Kernel/System/PostMaster/Filter/FollowUpArticleTypeCheck.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: FollowUpArticleTypeCheck.pm,v 1.3 2009-02-16 11:47:35 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::FollowUpArticleTypeCheck;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    for (qw(ConfigObject LogObject DBObject MainObject TicketObject ParserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need TicketID!' );
        return;
    }

    # get all article
    my @ArticleIndex = $Self->{TicketObject}->ArticleGet(
        TicketID => $Param{TicketID},
    );
    return if !@ArticleIndex;

    # check if current sender is not customer (do nothing)
    if ( lc( $ArticleIndex[0]->{CustomerUserID} ) eq lc( $Param{GetParam}->{'X-Sender'} ) ) {
        return 1;
    }

    # check if current sender got an internal forward
    my $ArticleType;
    for my $Article ( reverse @ArticleIndex ) {

        # just check agent sent article
        next if $Article->{SenderType} ne 'agent';

        # just check email-internal
        next if $Article->{ArticleType} ne 'email-internal';

        # check recipients
        next if !$Article->{To};
        my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine(
            Line => $Article->{To},
        );
        for my $Email (@EmailAddresses) {
            my $Recipient = $Self->{ParserObject}->GetEmailAddress(
                Email => $Email,
            );
            if ( lc($Recipient) eq lc( $Param{GetParam}->{'X-Sender'} ) ) {
                $ArticleType = 'email-internal';
                last;
            }
        }
    }
    return 1 if !$ArticleType;

    # get latest customer article (current arrival)
    my $ArticleID;
    for my $Article ( reverse @ArticleIndex ) {
        next if $Article->{SenderType} ne 'customer';
        $ArticleID = $Article->{ArticleID};
        last;
    }
    return 1 if !$ArticleID;

    # set article type to email-internal
    $Self->{TicketObject}->ArticleUpdate(
        ArticleID => $ArticleID,
        Key       => 'ArticleType',
        Value     => $ArticleType,
        UserID    => 1,
        TicketID  => $Param{TicketID},
    );

    return 1;
}

1;
