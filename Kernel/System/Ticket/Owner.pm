# --
# Kernel/System/Ticket/Owner.pm - the sub module of the global ticket handle
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Owner.pm,v 1.9 2003-07-14 12:22:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Owner;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub CheckOwner {
    my $Self = shift;
    my %Param = @_;
    my $SQL = '';
    # --
    # check needed stuff
    # --
    if (!$Param{TicketID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
      return;
    }
    # --
    # db query
    # --
    if ($Param{UserID}) {
        $SQL = "SELECT user_id, user_id " .
        " FROM " .
        " ticket " .
        " WHERE " .
        " id = $Param{TicketID} " .
        " AND " .
        " user_id = $Param{UserID}";
    }
    else {
        $SQL = "SELECT st.user_id, su.$Self->{ConfigObject}->{DatabaseUserTableUser} " .
        " FROM " .
        " ticket st, $Self->{ConfigObject}->{DatabaseUserTable} su " .
        " WHERE " .
        " st.id = $Param{TicketID} " .
        " AND " .
        " st.user_id = su.$Self->{ConfigObject}->{DatabaseUserTableUserID}";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Param{SearchUserID} = $Row[0];
        $Param{SearchUser} = $Row[1];
    }
    if ($Param{SearchUserID}) {
      return $Param{SearchUserID}, $Param{SearchUser};
    } 
    else {
      return;
    }
}
# --
sub SetOwner {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    if (!$Param{NewUserID} && !$Param{NewUser}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need NewUserID or NewUser!");
        return;
    }
    # --
    # lookup if no NewUserID is given
    # --
    if (!$Param{NewUserID}) {
      $Param{NewUserID} = $Self->{UserObject}->GetUserIdByName(User => $Param{NewUser})||return;
    }
    # --
    # lookup if no NewUser is given
    # --
    if (!$Param{NewUser}) {
      $Param{NewUser} = $Self->{UserObject}->GetUserByID(UserID => $Param{NewUserID})||return;
    }
    # --
    # check if update is needed!
    # --
    if ($Self->CheckOwner(TicketID => $Param{TicketID}, UserID => $Param{NewUserID})) {
        # update is "not" needed!
        return 1;
    }
    # --     
    # db update
    # --
    my $SQL = "UPDATE ticket SET user_id = $Param{NewUserID}, " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # --
      # add history
      # --
      $Self->AddHistoryRow(
        TicketID => $Param{TicketID},
        CreateUserID => $Param{UserID},
        HistoryType => 'OwnerUpdate',
        Name => "New Owner is '$Param{NewUser}' (ID=$Param{NewUserID}).",
      );
      # --
      # send agent notify
      # --
      if ($Param{UserID} ne $Param{NewUserID} && 
           $Param{NewUserID} ne $Self->{ConfigObject}->Get('PostmasterUserID')) {
        if (!$Param{Comment}) {
            $Param{Comment} = '';
        }
        # get user data
        my %Preferences = $Self->{UserObject}->GetUserData(UserID => $Param{NewUserID});
        # --
        # send agent notification
        # --
        $Self->SendNotification(
            Type => 'OwnerUpdate',
            To => $Preferences{UserEmail},
            CustomerMessageParams => \%Param,
            TicketNumber => $Self->GetTNOfId(ID => $Param{TicketID}),
            TicketID => $Param{TicketID},
            UserID => $Param{UserID},
        );
      }
      # --
      # send customer notification email
      # --
      my %Preferences = $Self->{UserObject}->GetUserData(UserID => $Param{NewUserID});
      $Self->SendCustomerNotification(
          Type => 'OwnerUpdate',
          CustomerMessageParams => \%Preferences,
          TicketID => $Param{TicketID},
          UserID => $Param{UserID},
      );
      return 1;
    }
    else {
      return;
    }
}
# --
sub GetOwnerList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db query
    my @User = ();
    my $SQL = "SELECT sh.name, ht.name, sh.create_by ".
        " FROM ".
        " ticket_history sh, ticket_history_type ht ".
        " WHERE ".
        " sh.ticket_id = $Param{TicketID} ".
        " AND ".
        " ht.name IN ('OwnerUpdate', 'NewTicket')  ".
        " AND ".
        " ht.id = sh.history_type_id".
        " ORDER BY sh.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        if ($Row[1] eq 'NewTicket') {
            if ($Row[2] ne '1') {
                push (@User, $Row[2]);
            }
        }
        elsif ($Row[1] eq 'OwnerUpdate') {
            if ($Row[0] =~ /^New Owner is '.+?' \(ID=(.+?)\)/) {
                push (@User, $1);
            }
        }
    }
    my @UserInfo = ();
    foreach (@User) {
        my %User = $Self->{UserObject}->GetUserData(UserID => $_, Cache => 1);
        push (@UserInfo, \%User);
    }
    return @UserInfo;
}
# --

1;
