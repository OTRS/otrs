# --
# Kernel/Output/HTML/TicketMenuMove.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketMenuMove;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID GroupObject TicketObject)) {
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

    # check if frontend module registered, if not, do not show action
    if ( $Param{Config}->{Action} ) {
        my $Module = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Param{Config}->{Action} };
        return if !$Module;
    }

    # check permission
    my $Config = $Self->{ConfigObject}->Get("Ticket::Frontend::$Param{Config}->{Action}");
    if ($Config) {
        if ( $Config->{Permission} ) {
            my $AccessOk = $Self->{TicketObject}->Permission(
                Type     => $Config->{Permission},
                TicketID => $Param{Ticket}->{TicketID},
                UserID   => $Self->{UserID},
                LogNo    => 1,
            );
            return if !$AccessOk;
        }
    }

    # check acl
    return
        if defined $Param{ACL}->{ $Param{Config}->{Action} }
            && !$Param{ACL}->{ $Param{Config}->{Action} };

    $Param{Link} = 'Action=AgentTicketMove;TicketID=$QData{"TicketID"}';

    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') =~ /^form$/i ) {
        $Param{Target} = '';
        $Param{Block}  = 'DocumentMenuItemMoveForm';

        # get move queues
        my %MoveQueues = $Self->{TicketObject}->MoveList(
            TicketID => $Param{Ticket}->{TicketID},
            UserID   => $Self->{UserID},
            Action   => $Self->{LayoutObject}->{Action},
            Type     => 'move_into',
        );
        $MoveQueues{0}
            = '- ' . $Self->{LayoutObject}->{LanguageObject}->Get('Move') . ' -';
        $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Name => 'DestQueueID',
            Data => \%MoveQueues,
        );
    }
    else {
        $Param{PopupType} = 'TicketAction';
    }

    # return item
    return { %{ $Param{Config} }, %{ $Param{Ticket} }, %Param };
}

1;
