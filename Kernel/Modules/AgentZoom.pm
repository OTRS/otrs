# --
# AgentZoom.pm - to get a closer view
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentZoom.pm,v 1.3 2002-04-13 11:16:03 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentZoom;

use strict;
use Kernel::System::Article;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach ('ParamObject', 
      'DBObject', 
      'TicketObject', 
      'LayoutObject', 
      'LogObject', 
      'QueueObject', 
      'ConfigObject',
      'UserObject',
    ) {
        die "Got no $_!" if (!$Self->{$_});
    }

    # get ArticleID
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID');
    
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $TicketID = $Self->{TicketID};
    my $QueueID = $Self->{TicketObject}->GetQueueIDOfTicketID(TicketID => $TicketID);
    my $UserID = $Self->{UserID};
    # fetch all queues
    my %MoveQueues = $Self->{QueueObject}->GetAllQueues(QUEUEID => $QueueID);
    # fetch all std. responses
    my %StdResponses = $Self->{QueueObject}->GetStdResponses(QueueID => $QueueID);
    # create article object
    my $ArticleObject = Kernel::System::Article->new(
        DBObject => $Self->{DBObject}, 
        ConfigObject => $Self->{ConfigObject},
    );
    
    my %Ticket;
    $Ticket{TicketID} = $TicketID;
    $Ticket{Age} = '?';
    $Ticket{TmpCounter} = 0;
    $Ticket{FreeKey1} = '';
    $Ticket{FreeValue1} = '';
    $Ticket{FreeKey2} = '';
    $Ticket{FreeValue2} = '';
    my @ArticleBox;
    
    my $SQL = "SELECT sa.id, st.tn, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, sa.a_body, ".
    " st.create_time_unix, st.tn, st.user_id, st.ticket_state_id, st.ticket_priority_id, ". 
    " sa.create_time, stt.name as sender_type, at.name as article_type, su.login, ".
    " sl.name as lock_type, sp.name as priority, tsd.name as state, sa.content_path, ".
    " sq.name as queue, st.create_time as ticket_create_time, ".
    " sa.a_freekey1, sa.a_freetext1, sa.a_freekey2, sa.a_freetext2, ".
    " sa.a_freekey3, sa.a_freetext3, st.freekey1, st.freekey2, st.freetext1, ".
    " st.freetext2, st.customer_id, sq.group_id ".
    " FROM ".
    " article sa, ticket st, article_sender_type stt, article_type at, user su, " .
    " ticket_lock_type sl, " .
    " ticket_priority sp, ticket_state tsd, queue sq " .
    " WHERE " .
    " sa.ticket_id = $TicketID " .
    " AND " .
    " sa.ticket_id = st.id " .
    " AND " .
    " sq.id = st.queue_id " .
    " AND " .
    " stt.id = sa.article_sender_type_id " .
    " AND " .
    " at.id = sa.article_type_id " .
    " AND " .
    " su.id = st.user_id " .
    " AND " .
    " sp.id = st.ticket_priority_id " .
    " AND " .
    " sl.id = st.ticket_lock_id " .
    " AND " .
    " tsd.id = st.ticket_state_id " .
    " GROUP BY sa.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my $Data = $Self->{DBObject}->FetchrowHashref() ) {
        if (!$Ticket{TmpCounter}) {
            $Ticket{TicketNumber} = $$Data{tn};
            $Ticket{State} = $$Data{state};
            $Ticket{CustomerID} = $$Data{customer_id};
            $Ticket{Queue} = $$Data{queue};
            $Ticket{QueueID} = $QueueID;
            $Ticket{Lock} = $$Data{lock_type};
            $Ticket{Owner} = $$Data{login};
            $Ticket{Priority} = $$Data{priority};
            $Ticket{FreeKey1} = $$Data{freekey1};
            $Ticket{FreeValue1} = $$Data{freetext1};
            $Ticket{FreeKey2} = $$Data{freekey2};
            $Ticket{FreeValue2} = $$Data{freetext2};
            $Ticket{Created} = $$Data{ticket_create_time};
            $Ticket{GroupID} = $$Data{group_id};
            $Ticket{TmpCounter}++;
            $Ticket{Age} = time() - $$Data{create_time_unix};
        }
        my @AtmIndex = $ArticleObject->GetAtmIndex(
            ContentPath => $$Data{content_path},
            ArticleID => $$Data{id},
        );
        my %Article;
        $Article{ArticleType} = $$Data{article_type};
        $Article{SenderType} = $$Data{sender_type};
        $Article{ArticleID} = $$Data{id};
        $Article{From} = $$Data{a_from} || ' ';
        $Article{To} = $$Data{a_to} || ' ';
        $Article{Cc} = $$Data{a_cc} || ' ';
        $Article{Subject} = $$Data{a_subject} || ' ';
        $Article{Text} = $$Data{a_body};
        $Article{Atms} = \@AtmIndex;
        $Article{CreateTime} = $$Data{create_time};
        $Article{FreeKey1} = $$Data{a_freekey1};
        $Article{FreeValue1} = $$Data{a_freetext1};
        $Article{FreeKey2} = $$Data{a_freekey2};
        $Article{FreeValue2} = $$Data{a_freetext2};
        $Article{FreeKey3} = $$Data{a_freekey3};
        $Article{FreeValue3} = $$Data{a_freetext3};
        push (@ArticleBox, \%Article);
    }
   
   # genterate output
    $Output .= $Self->{LayoutObject}->Header(Title => "Zoom Ticket $Ticket{TicketNumber}");
    my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $UserID);
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

    # checl permissions
    my %Groups = $Self->{UserObject}->GetGroups(UserID => $UserID);
    my $OK = 0;
    foreach (keys %Groups) {
        if ($Ticket{GroupID} eq $_) { 
            $OK = 1;
        }
    }

    # show or don't show ticket
    if ($OK) {
        $Output .= $Self->{LayoutObject}->TicketZoom(
            TicketID => $TicketID,
            QueueID => $QueueID,
            MoveQueues => \%MoveQueues,
            StdResponses => \%StdResponses,
            ArticleBox => \@ArticleBox,
            ArticleID => $Self->{ArticleID},
            %Ticket
        );
    } 
    else {
        $Output .= $Self->{LayoutObject}->NoPermission(WithHeader => 'no');
    }
   
    # add footer 
    $Output .= $Self->{LayoutObject}->Footer();

    # return outpu
    return $Output;
}
# --

1;
