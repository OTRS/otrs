# --
# Kernel/Modules/AgentQueueView.pm - the queue view of all tickets
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentQueueView.pm,v 1.49 2003-12-29 17:25:10 martin Exp $
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
$VERSION = '$Revision: 1.49 $';
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
    $Self->{ViewableTickets} = $Self->{UserQueueViewShowTickets} || $Self->{ConfigObject}->Get('PreferencesGroups')->{QueueViewShownTickets}->{DataSelected} || 15;

    # --
    # get params
    # --
    $Self->{Start} = $Self->{ParamObject}->GetParam(Param => 'Start') || 1;
    # viewable tickets a page
    $Self->{Limit} =  $Self->{ViewableTickets} + $Self->{Start} - 1;
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
    # store last queue screen
    if (!$Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreenQueue',
        Value => $Self->{RequestedURL},
    )) {
        my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # store last screen
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
        Area => 'Agent',
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
    if ($Self->{UserID} ne '1') {
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
    my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
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
    my %MoveQueues = $Self->{QueueObject}->GetAllQueues(
        UserID => $Self->{UserID},
        Type => 'move_into',
    );
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
           my $PageShown = $Self->{ViewableTickets}; 
           my $Pages = int(($Data{TicketsAvail} / $PageShown) + 0.99999);
           $Self->{Start} = (($Pages - 1) * $PageShown) + 1;
    }
    # build output ...
    my %AllQueues = $Self->{QueueObject}->GetAllQueues();
    return $Self->_MaskQueueView(
        %Data,
        QueueID => $Self->{QueueID},
        AllQueues => \%AllQueues,
        Start => $Self->{Start},
        ViewableTickets => $Self->{ViewableTickets},
    );
}
# --
sub _MaskQueueView {
    my $Self = shift;
    my %Param = @_; 
    my $QueueID = $Param{QueueID} || 0;
    my @QueuesNew = @{$Param{Queues}};
    my $QueueIDOfMaxAge = $Param{QueueIDOfMaxAge} || -1;
    my %AllQueues = %{$Param{AllQueues}};
    my %Counter = ();
    my %UsedQueue = (); 
    my @ListedQueues = ();
    my $Level = 0;
    $Self->{HighlightAge1} = $Self->{ConfigObject}->Get('HighlightAge1');
    $Self->{HighlightAge2} = $Self->{ConfigObject}->Get('HighlightAge2');
    $Self->{HighlightColor1} = $Self->{ConfigObject}->Get('HighlightColor1');
    $Self->{HighlightColor2} = $Self->{ConfigObject}->Get('HighlightColor2');
    $Param{SelectedQueue} = $AllQueues{$QueueID} || $Self->{ConfigObject}->Get('CustomQueue'); 
    my @MetaQueue = split(/::/, $Param{SelectedQueue});
    $Level = $#MetaQueue+2;
    # --
    # prepare shown queues (short names)
    # - get queue total count -
    # --
    foreach my $QueueRef (@QueuesNew) {
        push (@ListedQueues, $QueueRef);
        my %Queue = %$QueueRef;
        my @Queue = split(/::/, $Queue{Queue});
        # --
        # remember counted/used queues
        # --
        $UsedQueue{$Queue{Queue}} = 1;
        # --
        # move to short queue names
        # --
        my $QueueName = '';
        foreach (0..$#Queue) {
            if (!$QueueName) {
                $QueueName .= $Queue[$_];
            }
            else {
                $QueueName .= '::'.$Queue[$_];
            }
            if (!$Counter{$QueueName}) {
                $Counter{$QueueName} = 0;
            }
            $Counter{$QueueName} = $Counter{$QueueName}+$Queue{Count};
            if ($Counter{$QueueName} && !$Queue{$QueueName} && !$UsedQueue{$QueueName}) {
                my %Hash = ();
                $Hash{Queue} = $QueueName;
                $Hash{Count} = $Counter{$QueueName};
                foreach (keys %AllQueues) {
                    if ($AllQueues{$_} eq $QueueName) {
                        $Hash{QueueID} = $_;
                    }
                }
                $Hash{MaxAge} = 0;
                push (@ListedQueues, \%Hash);
                $UsedQueue{$QueueName} = 1;
            }
        }
    }
    # build queue string
    foreach my $QueueRef (@ListedQueues) {
        my $QueueStrg = '';
        my %Queue = %$QueueRef;
        my @QueueName = split(/::/, $Queue{Queue});
        my $ShortQueueName = $QueueName[$#QueueName];
        $Queue{MaxAge} = $Queue{MaxAge} / 60;
        $Queue{QueueID} = 0 if (!$Queue{QueueID});
        # should i highlight this queue
        if ($Param{SelectedQueue} =~ /^$QueueName[0]/ && $Level-1 >= $#QueueName) {
            if ($#QueueName == 0 && $#MetaQueue >= 0 && $Queue{Queue} =~ /^$MetaQueue[0]$/) {
                $QueueStrg .= '<b>';
            }
            if ($#QueueName == 1 && $#MetaQueue >= 1 && $Queue{Queue} =~ /^$MetaQueue[0]::$MetaQueue[1]$/) {
               $QueueStrg .= '<b>';
            }
            if ($#QueueName == 2 && $#MetaQueue >= 2 && $Queue{Queue} =~ /^$MetaQueue[0]::$MetaQueue[1]::$MetaQueue[2]$/) {
               $QueueStrg .= '<b>';
            }
        }
        # --
        # remember to selected queue info
        # --
        if ($QueueID eq $Queue{QueueID}) {
           $Param{SelectedQueue} = $Queue{Queue};
           $Param{AllSubTickets} = $Counter{$Queue{Queue}};
           # --
           # build Page Navigator for AgentQueueView
           # --
           $Param{PageShown} = $Param{'ViewableTickets'};
           if ($Param{TicketsAvail} == 1 || $Param{TicketsAvail} == 0) {
               $Param{Result} = $Param{TicketsAvail};
           }
           elsif ($Param{TicketsAvail} >= ($Param{Start}+$Param{PageShown})) {
               $Param{Result} = $Param{Start}."-".($Param{Start}+$Param{PageShown}-1);
           }
           else {
               $Param{Result} = "$Param{Start}-$Param{TicketsAvail}";
           }
           my $Pages = int(($Param{TicketsAvail} / $Param{PageShown}) + 0.99999);
           my $Page = int(($Param{Start} / $Param{PageShown}) + 0.99999);
           for (my $i = 1; $i <= $Pages; $i++) {
               $Param{PageNavBar} .= " <a href=\"$Self->{LayoutObject}->{Baselink}Action=\$Env{\"Action\"}".
                '&QueueID=$Data{"QueueID"}&Start='. (($i-1)*$Param{PageShown}+1) .= '">';
               if ($Page == $i) {
                   $Param{PageNavBar} .= '<b>'.($i).'</b>';
               }
               else {
                   $Param{PageNavBar} .= ($i);
               }
               $Param{PageNavBar} .= '</a> ';
           }
        }
        $QueueStrg .= "<a href=\"$Self->{LayoutObject}->{Baselink}Action=AgentQueueView&QueueID=$Queue{QueueID}\"";
        $QueueStrg .= ' onmouseover="window.status=\'$Text{"Queue"}: '.$Queue{Queue}.'\'; return true;" onmouseout="window.status=\'\';">';
        # should i highlight this queue
        if ($Queue{MaxAge} >= $Self->{HighlightAge2}) {
            $QueueStrg .= "<font color='$Self->{HighlightColor2}'>";
        }
        elsif ($Queue{MaxAge} >= $Self->{HighlightAge1}) {
            $QueueStrg .= "<font color='$Self->{HighlightColor1}'>";
        }
        # the oldest queue
        if ($Queue{QueueID} == $QueueIDOfMaxAge) {
            $QueueStrg .= "<blink>";
        }
        # QueueStrg
        $QueueStrg .= "$ShortQueueName ($Counter{$Queue{Queue}})";
        # the oldest queue
        if ($Queue{QueueID} == $QueueIDOfMaxAge) {
            $QueueStrg .= "</blink>";
        }
        # should i highlight this queue
        if ($Queue{MaxAge} >= $Self->{HighlightAge1}
              || $Queue{MaxAge} >= $Self->{HighlightAge2}) {
            $QueueStrg .= "</font>";
        }
        $QueueStrg .= "</a>";
        # should i highlight this queue
        if ($Param{SelectedQueue} =~ /^$QueueName[0]/ && $Level >= $#QueueName) {
            if ($#QueueName == 0 && $#MetaQueue >= 0 && $Queue{Queue} =~ /^$MetaQueue[0]$/) {
                $QueueStrg .= '</b>';
            }
            if ($#QueueName == 1 && $#MetaQueue >= 1 && $Queue{Queue} =~ /^$MetaQueue[0]::$MetaQueue[1]$/) {
               $QueueStrg .= '</b>';
            }
            if ($#QueueName == 2 && $#MetaQueue >= 2 && $Queue{Queue} =~ /^$MetaQueue[0]::$MetaQueue[1]::$MetaQueue[2]$/) {
               $QueueStrg .= '</b>';
            }
        }

        if ($#QueueName == 0) {
            if ($Param{QueueStrg}) {
                $QueueStrg = ' - '.$QueueStrg;
            }
            $Param{QueueStrg} .= $QueueStrg;
        }
        elsif ($#QueueName == 1 && $Level >= 2 && $Queue{Queue} =~ /^$MetaQueue[0]::/) {
            if ($Param{QueueStrg1}) {
                $QueueStrg = ' - '.$QueueStrg;
            }
            $Param{QueueStrg1} .= $QueueStrg;
        }
        elsif ($#QueueName == 2 && $Level >= 3 && $Queue{Queue} =~ /^$MetaQueue[0]::$MetaQueue[1]::/) {
            if ($Param{QueueStrg2}) {
                $QueueStrg = ' - '.$QueueStrg;
            }
            $Param{QueueStrg2} .= $QueueStrg;
        }
    }
    if ($Param{QueueStrg1}) {
        $Param{QueueStrg} .= '<br>'.$Param{QueueStrg1};
    }
    if ($Param{QueueStrg2}) {
        $Param{QueueStrg} .= '<br>'.$Param{QueueStrg2};
    }
    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'QueueView', Data => \%Param);
}
# --
1;
