# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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

    my %CustomerData;
    if ( $Param{Ticket}->{CustomerUserID} ) {
        %CustomerData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Param{Ticket}->{CustomerUserID},
        );
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( $CustomerData{UserTitle} ) {
        $CustomerData{UserTitle} = $LayoutObject->{LanguageObject}->Translate( $CustomerData{UserTitle} );
    }

    my $CustomerTable = $LayoutObject->AgentCustomerViewTable(
        Data   => \%CustomerData,
        Ticket => $Param{Ticket},
        Max    => $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::CustomerInfoZoomMaxSize'),
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
