# --
# Kernel/Output/HTML/TicketMenuGeneric.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: TicketMenuGeneric.pm,v 1.11 2009-02-16 11:16:22 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketMenuGeneric;

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

    # group check
    if ( $Param{Config}->{Group} ) {
        my @Items = split /;/, $Param{Config}->{Group};
        my $AccessOk;
        for my $Item (@Items) {
            my ( $Permission, $Name ) = split /:/, $Item;
            if ( !$Permission || !$Name ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Invalid config for Key Group: '$Item'! "
                        . "Need something like '\$Permission:\$Group;'",
                );
            }
            my @Groups = $Self->{GroupObject}->GroupMemberList(
                UserID => $Self->{UserID},
                Type   => $Permission,
                Result => 'Name',
            );
            next if !@Groups;

            for my $Group (@Groups) {
                if ( $Group eq $Name ) {
                    $AccessOk = 1;
                    last;
                }
            }
        }
        return $Param{Counter} if !$AccessOk;
    }

    # check acl
    if (
        !defined( $Param{ACL}->{ $Param{Config}->{Action} } )
        || $Param{ACL}->{ $Param{Config}->{Action} }
        )
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
