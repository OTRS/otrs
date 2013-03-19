# --
# Kernel/Modules/AgentTicketWatcher.pm - a ticketwatcher module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketWatcher;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # check if feature is active
    # ------------------------------------------------------------ #
    if ( !$Self->{ConfigObject}->Get('Ticket::Watcher') ) {
        return $Self->{LayoutObject}->ErrorScreen( Message => 'Feature is not active', );
    }

    # ------------------------------------------------------------ #
    # check access
    # ------------------------------------------------------------ #
    my @Groups;
    if ( $Self->{ConfigObject}->Get('Ticket::WatcherGroup') ) {
        @Groups = @{ $Self->{ConfigObject}->Get('Ticket::WatcherGroup') };
    }
    my $Access = 1;
    if (@Groups) {
        $Access = 0;
        for my $Group (@Groups) {
            if ( $Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                $Access = 1;
            }
        }
    }
    if ( !$Access ) {
        return $Self->{Layout}->NoPermission();
    }

    # get ACL restrictions
    $Self->{TicketObject}->TicketAcl(
        Data          => '-',
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $Self->{TicketObject}->TicketAclActionData();

    # check if ACL resctictions if exist
    if ( IsHashRefWithData( \%AclAction ) ) {

        # show error screen if ACL prohibits this action
        if ( defined $AclAction{ $Self->{Action} } && $AclAction{ $Self->{Action} } eq '0' ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }
    }

    # ------------------------------------------------------------ #
    # subscribe a ticket
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Subscribe' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # set subscribe
        my $Subscribe = $Self->{TicketObject}->TicketWatchSubscribe(
            TicketID    => $Self->{TicketID},
            WatchUserID => $Self->{UserID},
            UserID      => $Self->{UserID},
        );

        if ( !$Subscribe ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # redirect
        return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenView} );
    }

    # ------------------------------------------------------------ #
    # unsubscribe a ticket
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Unsubscribe' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Unsubscribe = $Self->{TicketObject}->TicketWatchUnsubscribe(
            TicketID    => $Self->{TicketID},
            WatchUserID => $Self->{UserID},
            UserID      => $Self->{UserID},
        );

        if ( !$Unsubscribe ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # redirect
        if ( $Self->{LastScreenView} =~ m/^Action=AgentTicketZoom/ ) {

            # checks if the user has permissions to see the ticket
            my $Access = $Self->{TicketObject}->TicketPermission(
                Type     => 'ro',
                TicketID => $Self->{TicketID},
                UserID   => $Self->{UserID},
            );
            if ( !$Access ) {

                # generate output
                return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenOverview} );
            }
        }
        return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenView} );
    }
}

1;
