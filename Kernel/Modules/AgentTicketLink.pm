# --
# Kernel/Modules/AgentTicketLink.pm - to set the ticket free text
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketLink.pm,v 1.3.2.1 2004-11-26 12:55:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketLink;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3.2.1 $';
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
    my $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Link');
    my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
        # --
        # error page
        # --
        my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => "No TicketID is given!",
            Comment => 'Please contact the admin.',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'link',
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
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Error(
                Message => "Sorry, the current owner is $OwnerLogin",
                Comment => 'Please change the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    if ($Self->{Subaction} eq 'Update') {
        # get current link
        my %TicketLink = $Self->{TicketObject}->TicketLinkGet(
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
        );
        # get add links
        my %OldTicketLink = ();
        my %NewTicketLink = ();
        my %AddLink = ();
        foreach (1..8) {
            my $Tn = $Self->{ParamObject}->GetParam(Param => "TicketLink$_") || '';
            if ($Tn) {
                $Tn =~ s/(^ | $)//ig;
                my $TicketID = $Self->{TicketObject}->TicketIDLookup(
                    TicketNumber => $Tn,
                    UserID => $Self->{UserID},
                );
                if ($TicketID) {
                    $NewTicketLink{$TicketID} = 1;
                    my $LinkExists = 0;
                    foreach (keys %TicketLink) {
                        if ($_ =~ /^TicketLinkID/) {
                            # check if link exists
                            if ($TicketLink{$_} eq $TicketID) {
                                $LinkExists = 1;
                            }
                        }
                    }
                    if (!$LinkExists) {
                        $AddLink{$TicketID} = 1;
                    }
                }
                else {
                    $Output .= $Self->{LayoutObject}->Notify(Info => 'No such Ticket Number "%s"! Can\'t link it!", "'.$Tn);
                }
            }
        }
        # get remove able links
        foreach (keys %TicketLink) {
            if ($_ =~ /^TicketLinkID/) {
                # remember old ticket links
                $OldTicketLink{$TicketLink{$_}} = 1;
            }
        }
        # add links
        foreach (keys %AddLink) {
            $Self->{TicketObject}->TicketLinkAdd(
                SlaveTicketID => $_,
                MasterTicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
            );
        }
        # delete links
        foreach (keys %OldTicketLink) {
            if (!$NewTicketLink{$_}) {
                $Self->{TicketObject}->TicketLinkDelete(
                    MasterTicketID => $Self->{TicketID},
                    SlaveTicketID => $_,
                    UserID => $Self->{UserID},
                );
            }
        }
        # print result
        $Output .= $Self->_Mask();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    else {
        $Output .= $Self->_Mask();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # print form
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    my %TicketLink = $Self->{TicketObject}->TicketLinkGet(
        %Ticket, 
        UserID => $Self->{UserID},
    );
    # print change form
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketLink', 
        Data => {
            %TicketLink,
            %Ticket,
            QueueID => $Self->{QueueID},
        },
    );
    return $Output;
}
# --
1;
