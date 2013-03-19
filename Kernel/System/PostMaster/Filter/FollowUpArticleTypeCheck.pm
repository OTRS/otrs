# --
# Kernel/System/PostMaster/Filter/FollowUpArticleTypeCheck.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::FollowUpArticleTypeCheck;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed objects
    for (qw(ConfigObject LogObject DBObject MainObject TicketObject ParserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID JobConfig GetParam)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get all article
    my @ArticleIndex = $Self->{TicketObject}->ArticleGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );
    return if !@ArticleIndex;

    # check if current sender is customer (do nothing)
    if ( $ArticleIndex[0]->{CustomerUserID} && $Param{GetParam}->{'X-Sender'} ) {
        return 1 if lc $ArticleIndex[0]->{CustomerUserID} eq lc $Param{GetParam}->{'X-Sender'};
    }

    # check if current sender got an internal forward
    my $InternalForward;
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
            if ( lc $Recipient eq lc $Param{GetParam}->{'X-Sender'} ) {
                $InternalForward = 1;
                last;
            }
        }
    }
    return 1 if !$InternalForward;

    # get latest customer article (current arrival)
    my $ArticleID;
    for my $Article ( reverse @ArticleIndex ) {
        next if $Article->{SenderType} ne 'customer';
        $ArticleID = $Article->{ArticleID};
        last;
    }
    return 1 if !$ArticleID;

    # set article type to email-internal
    my $ArticleType = $Param{JobConfig}->{ArticleType} || 'email-internal';
    $Self->{TicketObject}->ArticleUpdate(
        ArticleID => $ArticleID,
        Key       => 'ArticleType',
        Value     => $ArticleType,
        UserID    => 1,
        TicketID  => $Param{TicketID},
    );

    # set sender type to agent/customer
    my $SenderType = $Param{JobConfig}->{SenderType} || 'customer';
    $Self->{TicketObject}->ArticleUpdate(
        ArticleID => $ArticleID,
        Key       => 'SenderType',
        Value     => $SenderType,
        UserID    => 1,
        TicketID  => $Param{TicketID},
    );

    return 1;
}

1;
