# --
# Kernel/Modules/AgentQueueView.pm - the queue view of all tickets
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentQueueView.pm,v 1.42 2003-08-22 15:19:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentQueueView;

use strict;
use Kernel::System::State;
use Kernel::System::Lock;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.42 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject UserObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    # --
    # some new objects
    # --
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{LockObject} = Kernel::System::Lock->new(%Param);

    # --
    # get config data
    # --
    $Self->{ViewableSenderTypes} = $Self->{ConfigObject}->Get('ViewableSenderTypes')
           || die 'No Config entry "ViewableSenderTypes"!';
    $Self->{CustomQueue} = $Self->{ConfigObject}->Get('CustomQueue') || '???';
    # default viewable tickets a page
    $Self->{ViewableTickets} = $Self->{ConfigObject}->Get('ViewableTickets');

    # --
    # get params
    # --
    $Self->{Start} = $Self->{ParamObject}->GetParam(Param => 'Start') || 1;
    # viewable tickets a page
    $Self->{Limit} =  $Self->{ViewableTickets} + $Self->{Start};
    # sure is sure!
    $Self->{MaxLimit} = $Self->{ConfigObject}->Get('MaxLimit') || 1200;
    if ($Self->{Limit} > $Self->{MaxLimit}) {
        $Self->{Limit} = $Self->{MaxLimit};
    }
    # --
    # all static variables
    # --
    my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
        Type => 'Viewable',
        Result => 'ID',
    );
    $Self->{ViewableStateIDs} = \@ViewableStateIDs;
    my @ViewableLockIDs = $Self->{LockObject}->LockViewableLock(Type => 'ID');
    $Self->{ViewableLockIDs} = \@ViewableLockIDs;

    $Self->{HighlightColor1} = $Self->{ConfigObject}->Get('HighlightColor1');
    $Self->{HighlightColor2} = $Self->{ConfigObject}->Get('HighlightColor2');

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # --
    # store last screen
    # --
    if (!$Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreen',
        Value => $Self->{RequestedURL},
    )) {
        my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # starting with page ...
    my $Refresh = '';
    if ($Self->{UserRefreshTime}) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'QueueView',
        Refresh => $Refresh,
    );
    # get user lock data
    my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
    # build NavigationBar 
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    # to get the output faster!
    print $Output; $Output = '';
    # --
    # check old tickets, show it and return if needed
    # --
    if (my @ViewableTickets = $Self->{TicketObject}->GetOverTimeTickets(UserID=> $Self->{UserID})) {
        # show over time ticket's
        print $Self->{LayoutObject}->TicketEscalation(
            Message => 'Please answer this ticket(s) to get back to the normal queue view!',
        );
        foreach (@ViewableTickets) {
            print $Self->ShowTicket(TicketID => $_);
        }
        # get page footer
        return $Self->{LayoutObject}->Footer();
    }
    # --
    # build queue view ...
    # --
    my @ViewableQueueIDs = ();
    if ($Self->{QueueID} == 0) {
        @ViewableQueueIDs = $Self->{QueueObject}->GetAllCustomQueues(
            UserID => $Self->{UserID}
        );
    }
    else {
        @ViewableQueueIDs = ($Self->{QueueID});
    }
    print $Self->BuildQueueView(QueueIDs => \@ViewableQueueIDs);
    # get user groups
    my $Type = 'rw';
    if ($Self->{ConfigObject}->Get('QueueViewAllPossibleTickets')) {
        $Type = 'ro';
    }
    my @GroupIDs = $Self->{GroupObject}->GroupUserList(
        UserID => $Self->{UserID},
        Type => $Type,
        Result => 'ID',
    );
    # --
    # get data (viewable tickets...)
    # --
    my @ViewableTickets = ();
    if (@ViewableQueueIDs && @GroupIDs) {
        my $SQL = "SELECT st.id, st.queue_id FROM ".
          " ticket st, queue sq ".
          " WHERE ".
          " sq.id = st.queue_id ".
          " AND ".
          " st.ticket_state_id in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) ".
          " AND ".
          " st.ticket_lock_id in ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) ".
          " AND ".
          " st.queue_id in ( ${\(join ', ', @ViewableQueueIDs)} ) ".
          " AND ".
          " sq.group_id IN ( ${\(join ', ', @GroupIDs)} ) ".
          " ORDER BY st.ticket_priority_id DESC, st.create_time_unix ASC ";

          $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Self->{Limit});
          my $Counter = 0;
          while (my @Row = $Self->{DBObject}->FetchrowArray()) {
              if ($Counter >= ($Self->{Start}-1)) {
                  push (@ViewableTickets, $Row[0]);
              }
              $Counter++;
          }
    }
    # --
    # show ticket's
    # --
    foreach (@ViewableTickets) {
        print $Self->ShowTicket(TicketID => $_);
    }
    # get page footer
    $Output .= $Self->{LayoutObject}->Footer();
    # return page
    return $Output;
}
# --
# ShowTicket
# --
sub ShowTicket {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID} || return;
    my $Output = '';
    $Param{QueueViewQueueID} = $Self->{QueueID};
    my %MoveQueues = ();
    if ($Self->{ConfigObject}->Get('MoveInToAllQueues')) {
        %MoveQueues = $Self->{QueueObject}->GetAllQueues();
    }
    else {
        %MoveQueues = $Self->{QueueObject}->GetAllQueues(
            UserID => $Self->{UserID},
            Type => 'rw',
        );
    }
    # get last article
    my %Article = $Self->{TicketObject}->GetLastCustomerArticle(TicketID => $TicketID); 
    # fetch all std. responses ...
    my %StdResponses = $Self->{QueueObject}->GetStdResponses(QueueID => $Article{QueueID});
    # --
    # customer info
    # --
    my %CustomerData = (); 
    if ($Self->{ConfigObject}->Get('ShowCustomerInfoQueue')) {
        if ($Article{CustomerUserID}) { 
            %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Article{CustomerUserID},
            );
        }
        elsif ($Article{CustomerID}) { 
            %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                CustomerID => $Article{CustomerID},
            );
        }
    }
    # --
    # build ticket view
    # --
    # do some strips && quoting
    foreach (qw(From To Cc Subject Body)) {
        $Article{$_} = $Self->{LayoutObject}->{LanguageObject}->CharsetConvert(
            Text => $Article{$_},
            From => $Article{ContentCharset},
        );
    }
    $Article{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Article{Age}, Space => ' ');
    # --
    # prepare escalation time
    # --
    if ($Article{Answered}) {
        $Article{TicketOverTime} = '$Text{"none - answered"}';
    }
    elsif ($Article{TicketOverTime}) {
      if ($Article{TicketOverTime} <= -60*20) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor2}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }
      elsif ($Article{TicketOverTime} <= -60*40) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor1}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }
      # create string
      $Article{TicketOverTime} = $Self->{LayoutObject}->CustomerAge(
          Age => $Article{TicketOverTime},
          Space => '<br>',
      );
      if ($Param{TicketOverTimeFont} && $Param{TicketOverTimeFontEnd}) {
        $Article{TicketOverTime} = $Param{TicketOverTimeFont}.
            $Article{TicketOverTime}.$Param{TicketOverTimeFontEnd};
      } 
    }
    else {
        $Article{TicketOverTime} = '$Text{"none"}';
    }
    # customer info string 
    $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
        Data => \%CustomerData,
        Max => $Self->{ConfigObject}->Get('ShowCustomerInfoQueueMaxSize'),
    );
    # get StdResponsesStrg
    $Param{StdResponsesStrg} = $Self->{LayoutObject}->TicketStdResponseString(
        StdResponsesRef => \%StdResponses,
        TicketID => $Article{TicketID},
        ArticleID => $Article{ArticleID},
    );
    # --
    # check if just a only html email
    # --
    if (my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType(%Article, Action => 'AgentZoom')) {
        $Article{BodyNote} = $MimeTypeText;
        $Article{Body} = '';
    }
    else {
         # html quoting
        $Article{Body} = $Self->{LayoutObject}->Ascii2Html(
            NewLine => $Self->{ConfigObject}->Get('ViewableTicketNewLine') || 85,
            Text => $Article{Body},
            VMax => $Self->{ConfigObject}->Get('ViewableTicketLines') || 25,
            HTMLResultMode => 1,
        );
        # do link quoting
        $Article{Body} = $Self->{LayoutObject}->LinkQuote(Text => $Article{Body});
        # do charset check
        if (my $CharsetText = $Self->{LayoutObject}->CheckCharset(
            Action => 'AgentZoom',
            ContentCharset => $Article{ContentCharset},
            TicketID => $Article{TicketID},
            ArticleID => $Article{ArticleID} )) {
            $Article{BodyNote} = $CharsetText;
        }
    }
    # get MoveQueuesStrg
    if ($Self->{ConfigObject}->Get('MoveType') =~ /^form$/i) {
        $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Name => 'DestQueueID',
            Data => \%MoveQueues,
            SelectedID => $Param{QueueID},
        );
    }
    if ($Self->{ConfigObject}->Get('AgentCanBeCustomer') && $Article{CustomerUserID} =~ /^$Self->{UserLogin}$/i) {
        $Param{TicketAnswer} = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentZoomAgentIsCustomer',
            Data => \%Param,
        );
    }
    else {
        $Param{TicketAnswer} = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentZoomAnswer',
            Data => \%Param,
        );
    }
    # create & return output
    if (!$Self->{UserQueueView} || $Self->{UserQueueView} ne 'TicketViewLite') {
        return $Self->{LayoutObject}->Output(
            TemplateFile => 'TicketView', 
            Data => {%Param, %Article},
        );
    }
    else {
        return $Self->{LayoutObject}->Output(
            TemplateFile => 'TicketViewLite', 
            Data => {%Param, %Article},
        );
    }
}
# --
sub BuildQueueView {
    my $Self = shift;
    my %Param = @_;
    my %Data = $Self->{TicketObject}->TicketAcceleratorIndex(
        UserID => $Self->{UserID},
        QueueID => $Self->{QueueID},
        ShownQueueIDs => $Param{QueueIDs},
    ); 
    # check shown tickets
    if ($Self->{MaxLimit} < $Data{TicketsAvail}) {
        # set max shown
        $Data{TicketsAvail} = $Self->{MaxLimit};
    }
    # check start option, if higher then tickets available, set 
    # it to the last ticket page (Thanks to Stefan Schmidt!)
    if ($Self->{Start} > $Data{TicketsAvail}) { 
           my $PageShown = $Self->{ConfigObject}->Get('ViewableTickets');
           my $Pages = int(($Data{TicketsAvail} / $PageShown) + 0.99999);
           $Self->{Start} = (($Pages - 1) * $PageShown) + 1;
    }
    # build output ...
    my %AllQueues = $Self->{QueueObject}->GetAllQueues();
    return $Self->{LayoutObject}->QueueView(
        %Data,
        QueueID => $Self->{QueueID},
        AllQueues => \%AllQueues,
        Start => $Self->{Start},
    );
}
# --

1;
