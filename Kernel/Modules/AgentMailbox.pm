# --
# Kernel/Modules/AgentMailbox.pm - to view all locked tickets
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentMailbox.pm,v 1.11 2002-12-25 09:33:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentMailbox;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject
      UserObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $QueueID = $Self->{QueueID};

    # --
    # store last screen
    # --
    if (!$Self->{SessionObject}->UpdateSessionID(
      SessionID => $Self->{SessionID},
      Key => 'LastScreen',
      Value => $Self->{RequestedURL},
    )) {
      $Output = $Self->{LayoutObject}->Header(Title => 'Error');
      $Output .= $Self->{LayoutObject}->Error();
      $Output .= $Self->{LayoutObject}->Footer();
      return $Output;
    }  

    # --
    # starting with page ...
    # --
    $Output .= $Self->{LayoutObject}->Header(
      Refresh => $Self->{Refresh},
      Title => 'Locked Tickets',
    );
    my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

    # --
    # get locked  viewable tickets...
    # --
    my @ViewableTickets = $Self->{TicketObject}->GetLockedTicketIDs(UserID => $Self->{UserID});

    # get last sender type of article "LastSenderType"
    my %LastSenderType;
    my %LastSenderID;
    foreach  (@ViewableTickets) {
        my $SQL = "SELECT sdt.name, sa.create_by, st.until_time " .
          " FROM " .
          " article_sender_type sdt, article sa, ticket st " .
          " WHERE " .
          " st.id = $_ " .
          " AND " .
          " sa.ticket_id = st.id " .
          " AND " .
          " sdt.id = sa.article_sender_type_id" .
          " ORDER BY " .
          " sa.create_time";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
             $LastSenderType{$_} = $RowTmp[0];
             $LastSenderID{$_} = $RowTmp[1];
        }
    }

    # get article data
    foreach my $TicketID (@ViewableTickets) {
        my %Article = $Self->{TicketObject}->GetLastCustomerArticle(TicketID => $TicketID); 
        $Output .= $Self->{LayoutObject}->AgentMailboxTicket(
          %Article,
          TicketNumber => $Self->{TicketObject}->GetTNOfId(ID => $TicketID), 
          LastSenderType => $LastSenderType{$Article{TicketID}},
          LastSenderID => $LastSenderID{$Article{TicketID}},
          UserID => $Self->{UserID},
          ViewType => $Self->{Subaction},
        );
    }

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --

1;

