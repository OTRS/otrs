# --
# Kernel/Output/HTML/TicketMenuLock.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: TicketMenuLock.pm,v 1.11 2008-05-08 09:36:57 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::TicketMenuLock;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

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

    # check permission
    if (
        !$Self->{TicketObject}->Permission(
            Type     => 'rw',
            TicketID => $Param{TicketID},
            UserID   => $Self->{UserID},
            LogNo    => 1,
        )
        )
    {
        return $Param{Counter};
    }

    # check permission
    if ( $Self->{TicketObject}->LockIsTicketLocked( TicketID => $Param{TicketID} ) ) {
        my $AccessOk = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Param{TicketID},
            OwnerID  => $Self->{UserID},
        );

        return $Param{Counter} if !$AccessOk;
    }

    # check acl
    if (
        !defined( $Param{ACL}->{ $Param{Config}->{Action} } )
        || $Param{ACL}->{ $Param{Config}->{Action} }
        )
    {
        if ( $Param{Ticket}->{Lock} eq 'lock' ) {
            if ( $Param{Ticket}->{OwnerID} eq $Self->{UserID} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Menu',
                );
                if ( $Param{Counter} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'MenuItemSplit',
                    );
                }
                $Self->{LayoutObject}->Block(
                    Name => 'MenuItem',
                    Data => {
                        %{ $Param{Config} },
                        %{ $Param{Ticket} },
                        %Param,
                        Name        => 'Unlock',
                        Description => 'Unlock to give it back to the queue!',
                        Link =>
                            'Action=AgentTicketLock&Subaction=Unlock&TicketID=$QData{"TicketID"}',
                    },
                );
                $Param{Counter}++;
            }
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'Menu',
            );
            if ( $Param{Counter} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'MenuItemSplit',
                );
            }
            $Self->{LayoutObject}->Block(
                Name => 'MenuItem',
                Data => {
                    %{ $Param{Config} },
                    %Param,
                    Name        => 'Lock',
                    Description => 'Lock it to work on it!',
                    Link => 'Action=AgentTicketLock&Subaction=Lock&TicketID=$QData{"TicketID"}',
                },
            );
            $Param{Counter}++;
        }
    }
    return $Param{Counter};
}

1;
