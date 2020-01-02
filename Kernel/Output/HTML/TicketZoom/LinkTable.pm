# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::TicketZoom::LinkTable;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    # get linked objects
    my $LinkListWithData = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkListWithData(
        Object           => 'Ticket',
        Key              => $Param{Ticket}->{TicketID},
        State            => 'Valid',
        UserID           => $Self->{UserID},
        ObjectParameters => {
            Ticket => {
                IgnoreLinkedTicketStateTypes => 1,
            },
        },
    );

    # get link table view mode
    my $LinkTableViewMode =
        $Kernel::OM->Get('Kernel::Config')->Get('LinkObject::ViewMode');

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # create the link table
    my $LinkTableStrg = $LayoutObject->LinkObjectTableCreate(
        LinkListWithData => $LinkListWithData,
        ViewMode         => $LinkTableViewMode,
        Object           => 'Ticket',
        Key              => $Param{Ticket}->{TicketID},
    );
    return if !$LinkTableStrg;

    my $Location = '';

    # output the simple link table
    if ( $LinkTableViewMode eq 'Simple' ) {
        $LayoutObject->Block(
            Name => 'LinkTableSimple',
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );
        $Location = 'Sidebar';
    }

    # output the complex link table
    if ( $LinkTableViewMode eq 'Complex' ) {
        $LayoutObject->Block(
            Name => 'LinkTableComplex',
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );
        $Location = 'Main';
    }

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom/LinkTable',
        Data         => {},
    );
    return {
        Location => $Location,
        Output   => $Output,
        Rank     => '0300',
    };
}

1;
