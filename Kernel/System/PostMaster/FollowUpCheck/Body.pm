# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::FollowUpCheck::Body;

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

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # do body ticket number lookup
    return if !$Kernel::OM->Get('Kernel::Config')->Get('PostmasterFollowUpSearchInBody');

    my $Tn = $TicketObject->GetTNByString( $Self->{ParserObject}->GetMessageBody() );
    return if !$Tn;

    my $TicketID = $TicketObject->TicketCheckNumber( Tn => $Tn );

    if ($TicketID) {
        return $TicketID;
    }

    return;
}

1;
