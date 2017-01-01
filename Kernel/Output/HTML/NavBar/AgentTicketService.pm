# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBar::AgentTicketService;

use base 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if frontend module is registered (otherwise return)
    my $Config = $ConfigObject->Get('Frontend::Module')->{AgentTicketService};
    return if !$Config;

    # check if ticket service feature is enabled, in such case there is nothing to do
    return if $ConfigObject->Get('Ticket::Service');

    # frontend module is enabled but not ticket service, then remove the menu entry
    my $NavBarName = $Config->{NavBarName};
    my $Priority = sprintf( "%07d", $Config->{NavBar}->[0]->{Prio} );

    my %Return = %{ $Param{NavBar}->{Sub} };

    # remove AgentTicketService from the TicketMenu
    delete $Return{$NavBarName}->{$Priority};

    return ( Sub => \%Return );
}

1;
