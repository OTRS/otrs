# --
# Kernel/Modules/AgentTicketFreeText.pm - to set the ticket free text
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketFreeText.pm,v 1.1 2005-02-17 07:05:56 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketFreeText;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject
      ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "No TicketID is given!",
            Comment => 'Please contact the admin.',
        );
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'freetext',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    else {
        my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Self->{TicketID},
        );
        if ($OwnerID != $Self->{UserID}) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Sorry, the current owner is $OwnerLogin",
                Comment => 'Please change the owner first.',
            );
        }
    }

    if ($Self->{Subaction} eq 'Update') {
        # update ticket free text
        foreach (1..8) {
            my $FreeKey = $Self->{ParamObject}->GetParam(Param => "TicketFreeKey$_");
            my $FreeValue = $Self->{ParamObject}->GetParam(Param => "TicketFreeText$_");
            if (defined($FreeKey) && defined($FreeValue)) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    Key => $FreeKey,
                    Value => $FreeValue,
                    Counter => $_,
                    TicketID => $Self->{TicketID},
                    UserID => $Self->{UserID},
                );
            }
        }
        # print redirect
        return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
    }
    else {
        # print form
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
        # get free text config options
        my %TicketFreeText = ();
        foreach (1..8) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type => "TicketFreeKey$_",
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type => "TicketFreeText$_",
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
        $Output .= $Self->{LayoutObject}->Header(Area => 'Ticket', Title => 'Free Fields');
        $Output .= $Self->{LayoutObject}->NavigationBar();
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Ticket => \%Ticket,
            Config => \%TicketFreeText,
        );
        # print change form
	$Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketFreeText',
            Data => {
                %TicketFreeTextHTML,
                %Ticket,
                QueueID => $Self->{QueueID},
            },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
