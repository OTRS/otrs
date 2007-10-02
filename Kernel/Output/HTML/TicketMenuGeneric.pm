# --
# Kernel/Output/HTML/TicketMenuGeneric.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: TicketMenuGeneric.pm,v 1.6 2007-10-02 10:41:13 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::TicketMenuGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Ticket!" );
        return;
    }

    # check permission
    if ( $Self->{ConfigObject}->Get("Ticket::Frontend::$Param{Config}->{Action}") ) {
        my $Config = $Self->{ConfigObject}->Get("Ticket::Frontend::$Param{Config}->{Action}");
        if ( $Config->{Permission} ) {
            if (!$Self->{TicketObject}->Permission(
                    Type     => $Config->{Permission},
                    TicketID => $Param{TicketID},
                    UserID   => $Self->{UserID},
                    LogNo    => 1,
                )
                )
            {
                return $Param{Counter};
            }
        }
        if ( $Config->{RequiredLock} ) {
            if ( $Self->{TicketObject}->LockIsTicketLocked( TicketID => $Param{TicketID} ) ) {
                my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                    TicketID => $Param{TicketID},
                    OwnerID  => $Self->{UserID},
                );
                if ( !$AccessOk ) {
                    return $Param{Counter};
                }
            }
        }
    }

    # check acl
    if ( !defined( $Param{ACL}->{ $Param{Config}->{Action} } )
        || $Param{ACL}->{ $Param{Config}->{Action} } )
    {
        $Self->{LayoutObject}->Block(
            Name => 'Menu',
            Data => {},
        );
        if ( $Param{Counter} ) {
            $Self->{LayoutObject}->Block(
                Name => 'MenuItemSplit',
                Data => {},
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
