# --
# Kernel/Modules/AgentTicketPriority.pm - to set the ticket priority
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketPriority.pm,v 1.3 2005-05-04 08:04:02 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketPriority;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject UserObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    # get  PriorityID
    $Self->{PriorityID} = $Self->{ParamObject}->GetParam(Param => 'PriorityID') || '';

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # check needed stuff
    if (!$Self->{TicketID}) {
        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "No TicketID is given!",
            Comment => 'Please contact the admin.',
        );
    }
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => 'priority',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    else {
        my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Self->{TicketID},
        );
        if ($OwnerID != $Self->{UserID}) {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Sorry, the current owner is $OwnerLogin!",
                Comment => 'Please change the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    if ($Self->{Subaction} eq 'Update') {
        # set id
        if ($Self->{TicketObject}->PrioritySet(
            TicketID => $Self->{TicketID},
            PriorityID => $Self->{PriorityID},
            UserID => $Self->{UserID},
        )) {
            # print redirect
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Warning');
            $Output .= $Self->{LayoutObject}->Warning();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    else {
        # print form
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
        $Output .= $Self->{LayoutObject}->Header(Value => $Ticket{TicketNumber});
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get and priority priority states
        $Param{'OptionStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                $Self->{TicketObject}->PriorityList(
                    UserID => $Self->{UserID},
                    TicketID => $Ticket{TicketID},
                ),
            },
            Name => 'PriorityID',
            SelectedID => $Ticket{PriorityID},
        );
        # create & return output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketPriority',
            Data => { %Param, %Ticket, },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
1;
