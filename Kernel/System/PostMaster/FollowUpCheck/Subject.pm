# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::FollowUpCheck::Subject;

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
    return bless( $Self, $Type );
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $Subject = $Param{GetParam}->{Subject} || '';

    my $Tn = $TicketObject->GetTNByString($Subject);
    return if !$Tn;

    my $TicketID = $TicketObject->TicketCheckNumber( Tn => $Tn );
    return $TicketID;
}

1;
