# --
# Kernel/Output/HTML/NavBarAgentTicketService.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBarAgentTicketService;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check if frontend module is registered (otherwise return)
    my $Config = $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketService};
    return if !$Config;

    # check if ticket service feature is enabled, in such case there is nothing to do
    return if $Self->{ConfigObject}->Get('Ticket::Service');

    # frontend module is enabled but not ticket service, then remove the menu entry
    my $NavBarName = $Config->{NavBarName};
    my $Priotiry = sprintf( "%07d", $Config->{NavBar}->[0]->{Prio} );

    my %Return = %{ $Param{NavBar}->{Sub} };

    # remove AgentTicketService from the TicketMenu
    delete $Return{$NavBarName}->{$Priotiry};

    return ( Sub => \%Return );
}

1;
