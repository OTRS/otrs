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

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my @References = $Self->{ParserObject}->GetReferences();
    return if !@References;

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    for my $Reference (@References) {

        # get ticket id of message id
        my $TicketID = $ArticleObject->ArticleGetTicketIDOfMessageID(
            MessageID => "<$Reference>",
        );

        if ($TicketID) {
            return $TicketID;
        }
    }

    return;
}

1;
