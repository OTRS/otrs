# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketMenu::TeaserAttachmentView;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::OTRSBusiness',
);

sub Run {
    my ( $Self, %Param ) = @_;

    if ( $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled() ) {
        return;
    }

    # return item
    return { %{ $Param{Config} }, %{ $Param{Ticket} }, %Param };
}

1;
