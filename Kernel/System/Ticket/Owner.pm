# --
# Kernel/System/Ticket/Owner.pm - the sub module of the global ticket handle
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Owner.pm,v 1.4 2002-10-03 17:44:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Owner;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
      # send notify
      # --
      if ($Param{UserID} ne $Param{NewUserID} && 
           $Param{NewUserID} ne $Self->{ConfigObject}->Get('PostmasterUserID')) {
        if (!$Param{Comment}) {
            $Param{Comment} = '';
        }
        # get user data
        my %Preferences = $Self->{UserObject}->GetUserData(UserID => $Param{NewUserID});
        # --
        # send notification
        # --
        $Self->{SendNotification}->Send(
            Type => 'OwnerUpdate',
            To => $Preferences{UserEmail},
            CustomerMessageParams => \%Param,
            TicketNumber => $Self->GetTNOfId(ID => $Param{TicketID}),
            TicketID => $Param{TicketID},
            UserID => $Param{UserID},
        );
      }
      return 1;
    }
    else {
      return;
    }
}
# --

1;


