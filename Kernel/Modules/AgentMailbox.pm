# --
# Kernel/Modules/AgentMailbox.pm - to view all locked tickets
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentMailbox.pm,v 1.8 2002-08-06 19:15:16 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentMailbox;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
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
    foreach (
      'ParamObject', 
      'DBObject', 
      'QueueObject', 
      'LayoutObject', 
      'ConfigObject', 
      'LogObject',
      'UserObject',
      'ArticleObject',
    ) {
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
    my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $Self->{UserID});
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

    # --
    # get locked  viewable tickets...
    # --
    my @ViewableTickets;
    my @ViewableLockIDs = (2);
    my $SQL = "SELECT id, tn " .
      " FROM " .
      " ticket " .
      " WHERE " .
      " user_id = $Self->{UserID} " .
      " AND ".
      " ticket_lock_id in ( ${\(join ', ', @ViewableLockIDs)} ) " .
      " ORDER BY create_time";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        push (@ViewableTickets, $RowTmp[0]);
    }

    # --
    # get ViewableArticle
    # --
    my %ViewableArticle;
    foreach (@ViewableTickets) {
        my $SQL = "SELECT sa.id, st.tn " .
          " FROM " .
          " article sa, ticket st " .
          " WHERE " .
          " sa.ticket_id = $_ " .
          " AND " .
          " sa.ticket_id = st.id " .
          " GROUP BY st.tn, sa.id, sa.id, sa.create_time " .
          " ORDER BY sa.create_time ASC"; 

        $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 1);

        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
            $ViewableArticle{$RowTmp[0]} = $RowTmp[1];
    	}
    }

    # get last sender type of article "LastSenderType"
    my %LastSenderType;
    my %LastSenderID;
    foreach  (@ViewableTickets) {
        my $SQL = "SELECT sdt.name, sa.create_by " .
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
    foreach my $AID (keys %ViewableArticle) {
        my %Article = $Self->{ArticleObject}->GetArticle(ArticleID => $AID); 
        $Output .= $Self->{LayoutObject}->AgentMailboxTicket(
          %Article,
          TicketNumber => $ViewableArticle{$AID},
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

