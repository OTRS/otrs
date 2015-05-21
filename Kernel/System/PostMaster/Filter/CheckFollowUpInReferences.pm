# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::CheckFollowUpInReferences;

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

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !$Kernel::OM->Get('Kernel::Config')->Get('PostmasterFollowUpSearchInReferences') ) {
        return;
    }

    my @References = $Self->{ParserObject}->GetReferences();

    return if !@References;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    for my $Reference (@References) {

        # get ticket id of message id
        my $TicketID = $TicketObject->ArticleGetTicketIDOfMessageID(
            MessageID => "<$Reference>",
        );

        if ($TicketID) {
            return $TicketID;
        }
    }

    return;
}

1;
