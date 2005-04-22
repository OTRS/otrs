# --
# Kernel/Modules/AgentTicketMerge.pm - to merge tickets 
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketMerge.pm,v 1.1 2005-04-22 08:44:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketMerge;

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
                 QueueObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

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
            Message => "Need TicketID is given!",
            Comment => 'Please contact the admin.',
        );
        return $Output;
    }
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => 'rw',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }

    # merge action
    if ($Self->{Subaction} eq 'Merge') {
        my $Tn = $Self->{TicketObject}->TicketNumberLookup(TicketID => $Self->{TicketID});
        my $MainTicketNumber = $Self->{ParamObject}->GetParam(Param => 'MainTicketNumber');
        my $MainTicketID = $Self->{TicketObject}->TicketIDLookup(TicketNumber => $MainTicketNumber);
        # check permissions
        if (!$Self->{TicketObject}->Permission(
            Type => 'rw',
            TicketID => $MainTicketID,
            UserID => $Self->{UserID})) {
            # error screen, don't show ticket
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }
        # check errors
        if ($Self->{TicketID} == $MainTicketID || !$Self->{TicketObject}->TicketMerge(MainTicketID => $MainTicketID, MergeTicketID => $Self->{TicketID}, UserID => $Self->{UserID})) {
            my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketMerge', Data => {%Param,%Ticket});

            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            # redirect
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
        }
    }
    else {
        # merge box
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
        my $Output = $Self->{LayoutObject}->Header(Value => $Ticket{TicketNumber});
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get lock state && write (lock) permissions
        if (!$Self->{TicketObject}->LockIsTicketLocked(TicketID => $Self->{TicketID})) {
            # set owner
            $Self->{TicketObject}->OwnerSet(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );
            # set lock
            if ($Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock => 'lock',
                UserID => $Self->{UserID}
            )) {
                # show lock state
                $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $Self->{TicketID});
            }
        }
        else {
            my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
            );
            if ($OwnerID != $Self->{UserID}) {
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, the current owner is $OwnerLogin!",
                    Comment => 'Please change the owner first.',
                );
               $Output .= $Self->{LayoutObject}->Footer();
               return $Output;
            }
        }
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketMerge', Data => {%Param,%Ticket});
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
1;
