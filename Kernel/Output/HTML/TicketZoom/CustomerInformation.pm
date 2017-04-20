# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketZoom::CustomerInformation;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    return if !$ConfigObject->Get('Ticket::Frontend::CustomerInfoZoom');

    my %CustomerData;
    if ( $Param{Ticket}->{CustomerUserID} ) {
        %CustomerData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Param{Ticket}->{CustomerUserID},
        );
    }
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomerTable = $LayoutObject->AgentCustomerViewTable(
        Data   => \%CustomerData,
        Ticket => $Param{Ticket},
        Max    => $ConfigObject->Get('Ticket::Frontend::CustomerInfoZoomMaxSize'),
    );
    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom/CustomerInformation',
        Data         => {
            CustomerTable => $CustomerTable,
        },
    );

    return {
        Output => $Output,
    };
}

1;
