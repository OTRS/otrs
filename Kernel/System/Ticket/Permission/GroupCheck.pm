# --
# Kernel/System/Ticket/Permission/GroupCheck.pm - the sub module of 
# the global ticket handle
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: GroupCheck.pm,v 1.1 2003-11-26 00:41:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Permission::GroupCheck;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject TicketObject QueueObject UserObject GroupObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    
    return $Self;
}   
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID UserID Type)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # get ticket data
    my %Ticket = $Self->{TicketObject}->GetTicket(TicketID => $Param{TicketID}, Cached => 1);
    # get ticket group
    my $GID = $Self->{QueueObject}->GetQueueGroupID(QueueID => $Ticket{QueueID});
    # get user groups 
    my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
        UserID => $Param{UserID},
        Type => $Param{Type},
        Result => 'ID',
    );
    foreach (@GroupIDs) {
        if ($_ eq $GID) {
            return 1;
        }
    }
    return;
}
# --

1;
