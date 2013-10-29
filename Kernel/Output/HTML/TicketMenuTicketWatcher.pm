# --
# Kernel/Output/HTML/TicketMenuTicketWatcher.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketMenuTicketWatcher;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Ticket} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Ticket!' );
        return;
    }

    # check if feature is active
    return if !$Self->{ConfigObject}->Get('Ticket::Watcher');

    # check if frontend module registered, if not, do not show action
    if ( $Param{Config}->{Action} ) {
        my $Module = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Param{Config}->{Action} };
        return if !$Module;
    }

    # check acl
    return
        if defined $Param{ACL}->{ $Param{Config}->{Action} }
            && !$Param{ACL}->{ $Param{Config}->{Action} };

    # check access
    my @Groups;
    if ( $Self->{ConfigObject}->Get('Ticket::WatcherGroup') ) {
        @Groups = @{ $Self->{ConfigObject}->Get('Ticket::WatcherGroup') };
    }

    my $Access = 1;
    if (@Groups) {
        $Access = 0;
        for my $Group (@Groups) {
            next if !$Self->{LayoutObject}->{"UserIsGroup[$Group]"};
            if ( $Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                $Access = 1;
                last;
            }
        }
    }
    return if !$Access;

    # check if ticket get's watched right now
    my %Watch = $Self->{TicketObject}->TicketWatchGet(
        TicketID => $Param{Ticket}->{TicketID},
    );

    # show subscribe action
    if ( $Watch{ $Self->{UserID} } ) {
        return {
            %{ $Param{Config} },
            %{ $Param{Ticket} },
            %Param,
            Name        => 'Unwatch',
            Description => 'Remove from list of watched tickets',
            Link =>
                'Action=AgentTicketWatcher;Subaction=Unsubscribe;TicketID=$QData{"TicketID"};$QEnv{"ChallengeTokenParam"}',
        };
    }

    # show unsubscribe action
    return {
        %{ $Param{Config} },
        %{ $Param{Ticket} },
        %Param,
        Name        => 'Watch',
        Description => 'Add to list of watched tickets',
        Link =>
            'Action=AgentTicketWatcher;Subaction=Subscribe;TicketID=$QData{"TicketID"};$QEnv{"ChallengeTokenParam"}',
    };
}

1;
