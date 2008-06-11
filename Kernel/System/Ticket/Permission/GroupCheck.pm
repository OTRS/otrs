# --
# Kernel/System/Ticket/Permission/GroupCheck.pm - the sub module of
# the global ticket handle
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: GroupCheck.pm,v 1.12 2008-06-11 00:24:53 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Ticket::Permission::GroupCheck;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject TicketObject QueueObject UserObject GroupObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID UserID Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    # get ticket group
    my $QueueGroupID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Ticket{QueueID} );

    # get user groups
    my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
        UserID => $Param{UserID},
        Type   => $Param{Type},
        Result => 'ID',
        Cached => 1,
    );

    # search the group id
    for my $GroupID (@GroupIDs) {
        return 1 if $GroupID eq $QueueGroupID;
    }

    return;
}

1;
