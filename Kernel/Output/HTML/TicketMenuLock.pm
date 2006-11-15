# --
# Kernel/Output/HTML/TicketMenuLock.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: TicketMenuLock.pm,v 1.6 2006-11-15 06:58:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::TicketMenuLock;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Ticket}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Ticket!");
        return;
    }
    # check permission
    if (!$Self->{TicketObject}->Permission(
        Type => 'rw',
        TicketID => $Param{TicketID},
        UserID => $Self->{UserID},
        LogNo => 1,
        )) {
        return $Param{Counter};
    }
    # check permission
    if ($Self->{TicketObject}->LockIsTicketLocked(TicketID => $Param{TicketID})) {
        my $AccessOk = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Param{TicketID},
            OwnerID => $Self->{UserID},
        );
        if (!$AccessOk) {
            return $Param{Counter};
        }
    }

    # check acl
    if (!defined($Param{ACL}->{$Param{Config}->{Action}}) || $Param{ACL}->{$Param{Config}->{Action}}) {
        $Self->{LayoutObject}->Block(
            Name => 'Menu',
            Data => { },
        );
        if ($Param{Counter}) {
            $Self->{LayoutObject}->Block(
                Name => 'MenuItemSplit',
                Data => { },
            );
        }
        if ($Param{Ticket}->{Lock} eq 'lock') {
            $Self->{LayoutObject}->Block(
                Name => 'MenuItem',
                Data => {
                    %{$Param{Config}},
                    %{$Param{Ticket}},
                    %Param,
                    Name => 'Unlock',
                    Description => 'Unlock to give it back to the queue!',
                    Link => 'Action=AgentTicketLock&Subaction=Unlock&TicketID=$QData{"TicketID"}',
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'MenuItem',
                Data => {
                    %{$Param{Config}},
                    %Param,
                    Name => 'Lock',
                    Description => 'Lock it to work on it!',
                    Link => 'Action=AgentTicketLock&Subaction=Lock&TicketID=$QData{"TicketID"}',
                },
            );
        }
        $Param{Counter}++;
    }
    return $Param{Counter};
}

1;
