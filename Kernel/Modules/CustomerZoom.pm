# --
# Kernel/Modules/CustomerZoom.pm - to get a closer view
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerZoom.pm,v 1.11 2003-04-16 21:13:21 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerZoom;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    # get common objects 
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject 
        ConfigObject UserObject SessionObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }
    # needed objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    # get ArticleID
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID');
    
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $QueueID = $Self->{TicketObject}->GetQueueIDOfTicketID(TicketID => $Self->{TicketID});
    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID} || !$QueueID) {
      $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
      $Output .= $Self->{LayoutObject}->CustomerError();
      $Output .= $Self->{LayoutObject}->CustomerFooter();
      return $Output;
    }
    # --
    # store last screen
    # --
    if ($Self->{Subaction} ne 'ShowHTMLeMail') {
      if (!$Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreen',
        Value => $Self->{RequestedURL},
      )) {
        $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError();
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
      }  
    }
    # --
    # fetch all std. responses
    # --
    
    my %Ticket;
    $Ticket{TicketID} = $Self->{TicketID};
    $Ticket{Age} = '?';
    $Ticket{TmpCounter} = 0;
    $Ticket{FreeKey1} = '';
    $Ticket{FreeValue1} = '';
    $Ticket{FreeKey2} = '';
    $Ticket{FreeValue2} = '';
    $Ticket{TicketTimeUnits} = $Self->{TicketObject}->GetAccountedTime(
        TicketID => $Ticket{TicketID},
    );
    # --
    # grep all atricle of this ticket
    # --
    my @ArticleBox;
    my $SQL = "SELECT sa.id, st.tn, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, sa.a_body, ".
    " st.create_time_unix, st.tn, st.user_id, st.ticket_state_id, st.ticket_priority_id, ". 
    " sa.create_time, stt.name as sender_type, at.name as article_type, ".
    " su.$Self->{ConfigObject}->{DatabaseUserTableUser}, ".
    " sl.name as lock_type, sp.name as priority, tsd.name as state, sa.content_path, ".
    " sq.name as queue, st.create_time as ticket_create_time, ".
    " sa.a_freekey1, sa.a_freetext1, sa.a_freekey2, sa.a_freetext2, ".
    " sa.a_freekey3, sa.a_freetext3, st.freekey1, st.freekey2, st.freetext1, ".
    " st.freetext2, st.customer_id, sq.group_id, st.ticket_answered, sq.escalation_time, ".
    " sa.a_content_type, sa.incoming_time ".
    " FROM ".
    " article sa, ticket st, article_sender_type stt, article_type at, ".
    " $Self->{ConfigObject}->{DatabaseUserTable} su, ticket_lock_type sl, " .
    " ticket_priority sp, ticket_state tsd, queue sq " .
    " WHERE " .
    " sa.ticket_id = st.id " .
    " AND " .
    " sq.id = st.queue_id " .
    " AND " .
    " stt.id = sa.article_sender_type_id " .
    " AND " .
    " at.id = sa.article_type_id " .
    " AND " .
    " sp.id = st.ticket_priority_id " .
    " AND " .
    " sl.id = st.ticket_lock_id " .
    " AND " .
    " tsd.id = st.ticket_state_id " .
    " AND " .
    " sa.ticket_id = $Self->{TicketID} " .
    " AND " .
    " su.$Self->{ConfigObject}->{DatabaseUserTableUserID} = st.user_id " .
    " GROUP BY sa.id, st.tn, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, sa.a_body, ".
    " st.create_time_unix, st.tn, st.user_id, st.ticket_state_id, st.ticket_priority_id, ".
    " sa.create_time, stt.name, at.name, ".
    " su.$Self->{ConfigObject}->{DatabaseUserTableUser}, ".
    " sl.name, sp.name, tsd.name, sa.content_path, ".
    " sq.name, st.create_time, ".
    " sa.a_freekey1, sa.a_freetext1, sa.a_freekey2, sa.a_freetext2, ".
    " sa.a_freekey3, sa.a_freetext3, st.freekey1, st.freekey2, st.freetext1, ".
    " st.freetext2, st.customer_id, sq.group_id, st.ticket_answered, sq.escalation_time, ".
    " sa.a_content_type, sa.incoming_time ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my $Data = $Self->{DBObject}->FetchrowHashref() ) {
        # get escalation_time
        if ($$Data{escalation_time} && $$Data{sender_type} eq 'customer') {
            $Ticket{TicketOverTime} = (time() - ($$Data{incoming_time} + ($$Data{escalation_time}*60)));
        }
        # ticket data
        $Ticket{TicketNumber} = $$Data{tn};
        $Ticket{State} = $$Data{state};
        $Ticket{CustomerID} = $$Data{customer_id};
        $Ticket{Queue} = $$Data{queue};
        $Ticket{QueueID} = $QueueID;
        $Ticket{Lock} = $$Data{lock_type};
        $Ticket{Owner} = $$Data{login};
        $Ticket{Priority} = $$Data{priority};
        $Ticket{TicketFreeKey1} = $$Data{freekey1};
        $Ticket{TicketFreeValue1} = $$Data{freetext1};
        $Ticket{TicketFreeKey2} = $$Data{freekey2};
        $Ticket{TicketFreeValue2} = $$Data{freetext2};
        $Ticket{Created} = $$Data{ticket_create_time};
        $Ticket{GroupID} = $$Data{group_id};
        $Ticket{Age} = time() - $$Data{create_time_unix};
        $Ticket{Answered} = $$Data{ticket_answered};
        # article data
        my %Article;
        $Article{ArticleType} = $$Data{article_type};
        $Article{SenderType} = $$Data{sender_type};
        $Article{ArticleID} = $$Data{id};
        $Article{From} = $$Data{a_from} || ' ';
        $Article{To} = $$Data{a_to} || ' ';
        $Article{Cc} = $$Data{a_cc} || ' ';
        $Article{Subject} = $$Data{a_subject} || ' ';
        $Article{Body} = $$Data{a_body};
        $Article{CreateTime} = $$Data{create_time};
        $Article{FreeKey1} = $$Data{a_freekey1};
        $Article{FreeValue1} = $$Data{a_freetext1};
        $Article{FreeKey2} = $$Data{a_freekey2};
        $Article{FreeValue2} = $$Data{a_freetext2};
        $Article{FreeKey3} = $$Data{a_freekey3};
        $Article{FreeValue3} = $$Data{a_freetext3};
        if ($$Data{a_content_type} && $$Data{a_content_type} =~ /charset=(.*)(| |\n)/i) {
            $Article{ContentCharset} = $1;
        }
        if ($$Data{a_content_type} && $$Data{a_content_type} =~ /^(.+?\/.+?)( |;)/i) {
            $Article{MimeType} = $1;
        }
        push (@ArticleBox, \%Article);
    }
    # --
    # article attachments
    # --
    foreach my $Article (@ArticleBox) {
        my %AtmIndex = $Self->{TicketObject}->GetArticleAtmIndex(
            ContentPath => $Article->{ContentPath},
            ArticleID => $Article->{ArticleID},
        );
        $Article->{Atms} = \%AtmIndex;
    }
    # --
    # check permission
    # --
    my $CustomerID = $Ticket{CustomerID};
    $CustomerID =~ s/\+/\\+/g;
    if ($Self->{UserCustomerID} !~ /^$CustomerID$/i) {
        $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError(Message => 'No permission!');
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    # --
    # genterate output
    # --
    $Output .= $Self->{LayoutObject}->CustomerHeader(Title => "Zoom Ticket $Ticket{TicketNumber}");
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
    # --
    # show ticket
    # --
    if ($Self->{Subaction} eq 'ShowHTMLeMail') {
        # if it is a html email, drop normal header
        $Ticket{ShowHTMLeMail} = 1;
        $Output = '';
    }
    $Output .= $Self->{LayoutObject}->CustomerTicketZoom(
        NextStates => $Self->_GetNextStates(),
        TicketID => $Self->{TicketID},
        QueueID => $QueueID,
        ArticleBox => \@ArticleBox,
        ArticleID => $Self->{ArticleID},
        %Ticket
    );
    # --
    # return if HTML email
    # --
    if ($Self->{Subaction} eq 'ShowHTMLeMail') {
        # if it is a html email, return here
        $Ticket{ShowHTMLeMail} = 1;
        return $Output;
    }
    # add footer 
    $Output .= $Self->{LayoutObject}->CustomerFooter();

    # return output
    return $Output;
}
# --
sub _GetNextStates {
    my $Self = shift;
    my %Param = @_;
    # --
    # get next states
    # --
    my %NextStates = $Self->{StateObject}->StateGetStatesByType(
        Type => 'CustomerPanelDefaultNextCompose',
        Result => 'HASH',
    );
    return \%NextStates;
}
# --

1;
