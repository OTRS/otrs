# --
# AgentMailbox.pm - to view all locked tickets
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentMailbox.pm,v 1.2 2002-02-03 20:05:04 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentMailbox;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
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
    foreach ('ParamObject', 'DBObject', 'QueueObject', 'LayoutObject', 'ConfigObject', 'LogObject') {
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

    # starting with page ...
    $Output .= $Self->{LayoutObject}->Header(
      Refresh => $Self->{Refresh},
      Title => 'Locked Tickets',
    );
    my %LockedData = $Self->{DBObject}->GetLockedCount(UserID => $Self->{UserID});
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    # fetch all queues ...
    my %MoveQueues = $Self->{QueueObject}->GetAllQueues(QueueID => $QueueID);

    # get data viewable tickets...
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

    # get ViewableArticle
    my %ViewableArticle;
    foreach (@ViewableTickets) {
        my $SQL = "SELECT sa.id, st.tn " .
	" FROM " .
	" article sa, ticket st " .
	" WHERE " .
	" sa.ticket_id = $_ " .
	" AND " .
	" sa.ticket_id = st.id " .
	" GROUP BY st.tn " .
	" ORDER BY sa.create_time DESC"; 

        $Self->{DBObject}->Prepare(SQL => $SQL);

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
    my $SQL = "SELECT sa.ticket_id, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, sa.a_body, " .
        " st.create_time_unix as age, sp.name, sd.name as state, sq.name as queue " .
        " FROM " .
        " article sa, ticket st, ticket_priority sp, ticket_state sd, queue sq" .
        " where " .
        " sa.id = $AID " .
        " and " .
        " sa.ticket_id = st.id " .
        " and " .
        " sq.id = st.queue_id " .
        " and " .
        " sp.id = st.ticket_priority_id " .
        " and " .
        " st.ticket_state_id = sd.id";

    $Self->{DBObject}->Prepare(SQL => $SQL);

    while (my $Data = $Self->{DBObject}->FetchrowHashref() ) {
      $$Data{age} = time() - $$Data{age}; 
      $Output .= $Self->{LayoutObject}->AgentMailboxTicket(
		TicketNumber => $ViewableArticle{$AID},
 		Priority => $$Data{name}, 
 		State => $$Data{state},
		TicketID => $$Data{ticket_id},
	   	From => $$Data{a_from}, 
		To => $$Data{a_to}, 
		Cc => $$Data{a_cc}, 
		Subject => $$Data{a_subject}, 
		Text => $$Data{a_body},
		Age => $$Data{age},
		QueueID => $QueueID,
		Queue => $$Data{queue},
		LastSenderType => $LastSenderType{$$Data{ticket_id}},
        LastSenderID => $LastSenderID{$$Data{ticket_id}},
		MoveQueues => \%MoveQueues,
        UserID => $Self->{UserID},
        ViewType => $Self->{Subaction},
         );
        } 
    }

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --

1;

