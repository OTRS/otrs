# --
# Kernel/System/Ticket/Owner.pm - the sub module of the global ticket handle
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Owner.pm,v 1.3 2002-09-10 23:21:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Owner;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.3 $';
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
         # get login user data
         my %PreferencesCurrentUser = $Self->{UserObject}->GetUserData(UserID => $Param{UserID});
         # get user data of new owner
         my %Preferences = $Self->{UserObject}->GetUserData(UserID => $Param{NewUserID});
         # create notify stuff
         my $TicketHook = $Self->{ConfigObject}->Get('TicketHook') || '';
         my $Tn = $Self->GetTNOfId(ID => $Param{TicketID});
         my $Subject = $Self->{ConfigObject}->Get('NotificationSubjectOwnerUpdate')
              || 'No subject found in Config.pm!';
         $Subject = "[$TicketHook: $Tn] $Subject";
         my $Body = $Self->{ConfigObject}->Get('NotificationBodyOwnerUpdate')
          || 'No body found in Config.pm!';
         $Body =~ s/<OTRS_TICKET_ID>/$Param{TicketID}/g;
         $Body =~ s/<OTRS_TICKET_NUMBER>/$Tn/g;
         $Body =~ s/<OTRS_COMMENT>/$Param{Comment}/g;
         $Body =~ s/<OTRS_USER_FIRSTNAME>/$Preferences{UserFirstname}/g;
         $Body =~ s/<OTRS_CURRENT_USER_FIRSTNAME>/$PreferencesCurrentUser{UserFirstname}/g;
         $Body =~ s/<OTRS_CURRENT_USER_LASTNAME>/$PreferencesCurrentUser{UserLastname}/g;
         # --
         # send notification
         # --
         $Self->{EmailObject} = Kernel::System::EmailSend->new(
             ConfigObject => $Self->{ConfigObject},
             LogObject => $Self->{LogObject},
             DBObject => $Self->{DBObject},
         );
         $Self->{EmailObject}->Send(
            ArticleObject => $Self->{ArticleObject},
            ArticleType => 'email-notification-int',
            SenderType => 'system',
            TicketID => $Param{TicketID},
            HistoryType => 'SendAgentNotification',
            HistoryComment => "Sent notification to '$Preferences{UserEmail}'.",
            From => $Self->{ConfigObject}->Get('NotificationSenderName').
              ' <'.$Self->{ConfigObject}->Get('NotificationSenderEmail').'>',
            Email => $Self->{ConfigObject}->Get('NotificationSenderEmail'),
            To => $Preferences{UserEmail},
            Subject => $Subject,
            UserID => $Self->{ConfigObject}->Get('PostmasterUserID'),
            Body => $Body,
            Loop => 1,
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


