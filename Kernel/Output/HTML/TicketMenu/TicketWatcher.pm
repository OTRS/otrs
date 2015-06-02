# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketMenu::TicketWatcher;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Config',
    'Kernel::System::Ticket',
    'Kernel::Output::HTML::Layout',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Ticket} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Ticket!'
        );
        return;
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if feature is active
    return if !$ConfigObject->Get('Ticket::Watcher');

    # check if frontend module registered, if not, do not show action
    if ( $Param{Config}->{Action} ) {
        my $Module = $ConfigObject->Get('Frontend::Module')->{ $Param{Config}->{Action} };
        return if !$Module;
    }

    # check acl
    my %ACLLookup = reverse( %{ $Param{ACL} || {} } );
    return if ( !$ACLLookup{ $Param{Config}->{Action} } );

    # check access
    my @Groups;
    if ( $ConfigObject->Get('Ticket::WatcherGroup') ) {
        @Groups = @{ $ConfigObject->Get('Ticket::WatcherGroup') };
    }

    my $Access = 1;
    if (@Groups) {
        $Access = 0;
        GROUP:
        for my $Group (@Groups) {

            # get layout object
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            next GROUP if !$LayoutObject->{"UserIsGroup[$Group]"};
            if ( $LayoutObject->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                $Access = 1;
                last GROUP;
            }
        }
    }
    return if !$Access;

    # check if ticket get's watched right now
    my %Watch = $Kernel::OM->Get('Kernel::System::Ticket')->TicketWatchGet(
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
                'Action=AgentTicketWatcher;Subaction=Unsubscribe;TicketID=[% Data.TicketID | uri %];[% Env("ChallengeTokenParam") | html %]',
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
            'Action=AgentTicketWatcher;Subaction=Subscribe;TicketID=[% Data.TicketID | uri %];[% Env("ChallengeTokenParam") | html %]',
    };
}

1;
