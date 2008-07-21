# --
# Kernel/Output/HTML/TicketMenuResponsible.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: TicketMenuResponsible.pm,v 1.10 2008-07-21 11:28:26 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::TicketMenuResponsible;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

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

    # check if feature is enabled
    if ( !$Self->{ConfigObject}->Get('Ticket::Responsible') ) {
        return $Param{Counter};
    }

    # check permission
    if ( $Self->{ConfigObject}->Get("Ticket::Frontend::$Param{Config}->{Action}") ) {
        my $Config = $Self->{ConfigObject}->Get("Ticket::Frontend::$Param{Config}->{Action}");
        if ( $Config->{Permission} ) {
            my $AccessOk = $Self->{TicketObject}->Permission(
                Type     => $Config->{Permission},
                TicketID => $Param{TicketID},
                UserID   => $Self->{UserID},
                LogNo    => 1,
            );
            return $Param{Counter} if !$AccessOk;
        }
        if ( $Config->{RequiredLock} ) {
            if ( $Self->{TicketObject}->LockIsTicketLocked( TicketID => $Param{TicketID} ) ) {
                my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                    TicketID => $Param{TicketID},
                    OwnerID  => $Self->{UserID},
                );
                return $Param{Counter} if !$AccessOk;
            }
        }
    }
    if (
        !defined( $Param{ACL}->{ $Param{Config}->{Action} } )
        || $Param{ACL}->{ $Param{Config}->{Action} }
        )
    {
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
            Data => { %{ $Param{Config} }, %{ $Param{Ticket} }, %Param, },
        );
        $Param{Counter}++;
    }

    return $Param{Counter};
}

1;
