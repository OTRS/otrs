# --
# Kernel/Modules/AgentTicketQueue.pm - the queue view of all tickets
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketQueue.pm,v 1.10 2006-01-29 23:51:01 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketQueue;

use strict;
use Kernel::System::State;
use Kernel::System::Lock;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10 $';
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
    # set debug
    $Self->{Debug} = 0;
    # check all needed objects
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject UserObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
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
    $Self->{ViewableSenderTypes} = $Self->{ConfigObject}->Get('Ticket::ViewableSenderTypes')
           || die 'No Config entry "Ticket::ViewableSenderTypes"!';
    $Self->{CustomQueue} = $Self->{ConfigObject}->Get('Ticket::CustomQueue') || '???';
    # default viewable tickets a page
    $Self->{ViewableTickets} = $Self->{UserQueueViewShowTickets} || $Self->{ConfigObject}->Get('PreferencesGroups')->{QueueViewShownTickets}->{DataSelected} || 15;

    # --
    # get params
    # --
    $Self->{ViewAll} = $Self->{ParamObject}->GetParam(Param => 'ViewAll') || 0;
    $Self->{Start} = $Self->{ParamObject}->GetParam(Param => 'Start') || 1;
    # viewable tickets a page
    $Self->{Limit} =  $Self->{ViewableTickets} + $Self->{Start} - 1;
    # sure is sure!
    $Self->{MaxLimit} = $Self->{ConfigObject}->Get('Ticket::Frontend::QueueMaxShown') || 1200;
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
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreenOverview',
        Value => $Self->{RequestedURL},
    );
    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreenView',
        Value => $Self->{RequestedURL},
    );
    # starting with page ...
    my $Refresh = '';
    if ($Self->{UserRefreshTime}) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $Self->{LayoutObject}->Header(
        Refresh => $Refresh,
    );
    # build NavigationBar
    $Output .= $Self->{LayoutObject}->NavigationBar();
    # to get the output faster!
    print $Output; $Output = '';
    # --
    # check old tickets, show it and return if needed
    # --
    my $NoEscalationGroup = $Self->{ConfigObject}->Get('Ticket::Frontend::NoEscalationGroup') || '';
    if ($Self->{UserID} eq '1' ||
        ($Self->{"UserIsGroup[$NoEscalationGroup]"} && $Self->{"UserIsGroup[$NoEscalationGroup]"} eq 'Yes')) {
        # do not show escalated tickets
    }
    else {
        if (my @ViewableTickets = $Self->{TicketObject}->GetOverTimeTickets(UserID=> $Self->{UserID})) {
            # show over time ticket's
            $Self->{LayoutObject}->Block(
                Name => 'EscalationNav',
                Data => {
                    Message => 'Please answer this ticket(s) to get back to the normal queue view!',
                },
            );
            print $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentTicketQueue',
                Data => { %Param },
            );
            my $Counter = 0;
            foreach (@ViewableTickets) {
                $Counter++;
                print $Self->ShowTicket(TicketID => $_, Counter => $Counter);
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
    $Self->BuildQueueView(QueueIDs => \@ViewableQueueIDs);
    print $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketQueue',
        Data => { %Param },
    );
    # get user groups
    my $Type = 'rw';
    if ($Self->{ConfigObject}->Get('Ticket::QueueViewAllPossibleTickets')) {
        $Type = 'ro';
    }
    my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
        UserID => $Self->{UserID},
        Type => $Type,
        Result => 'ID',
        Cached => 1,
    );
    # --
    # get data (viewable tickets...)
    # --
    my @ViewableTickets = ();
    my $SortBy = $Self->{ConfigObject}->Get('Ticket::Frontend::QueueSortBy::Default') || 'Age';
    my %SortOptions = (
        Owner => 'st.user_id',
        CustomerID => 'st.customer_id',
        State => 'st.ticket_state_id',
        Ticket => 'st.tn',
        Title => 'st.title',
        Queue => 'sq.name',
        Priority => 'st.ticket_priority_id',
        Age => 'st.create_time_unix',
        TicketFreeTime1 => 'st.freetime1',
        TicketFreeTime2 => 'st.freetime2',
        TicketFreeKey1 => 'st.freekey1',
        TicketFreeText1 => 'st.freetext1',
        TicketFreeKey2 => 'st.freekey2',
        TicketFreeText2 => 'st.freetext2',
        TicketFreeKey3 => 'st.freekey3',
        TicketFreeText3 => 'st.freetext3',
        TicketFreeKey4 => 'st.freekey4',
        TicketFreeText4 => 'st.freetext4',
        TicketFreeKey5 => 'st.freekey5',
        TicketFreeText5 => 'st.freetext5',
        TicketFreeKey6 => 'st.freekey6',
        TicketFreeText6 => 'st.freetext6',
        TicketFreeKey7 => 'st.freekey7',
        TicketFreeText7 => 'st.freetext7',
        TicketFreeKey8 => 'st.freekey8',
        TicketFreeText8 => 'st.freetext8',
    );

    my $Order = $Self->{ConfigObject}->Get('Ticket::Frontend::QueueOrder::Default') || 'Down';
    if (@ViewableQueueIDs && @GroupIDs) {
        # if we have only one queue, check if there
        # is a setting in Config.pm for sorting
        if ($#ViewableQueueIDs == 0) {
            my $QueueID = $ViewableQueueIDs[0];
            if ($Self->{ConfigObject}->Get('Ticket::Frontend::QueueSort') && $Self->{ConfigObject}->Get('Ticket::Frontend::QueueSort')->{$QueueID}) {
                $Order = 'Down';
            }
        }
        if ($Order eq 'Up') {
            $Order = 'ASC';
        }
        else {
            $Order = 'DESC';
        }
        # build query
        my $SQL = "SELECT st.id, st.queue_id FROM ".
          " ticket st, queue sq ".
          " WHERE ".
          " sq.id = st.queue_id ".
          " AND ".
          " st.ticket_state_id in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) ".
          " AND ";
        if (!$Self->{ViewAll}) {
          $SQL .= " st.ticket_lock_id in ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) ".
          " AND ";
        }
        $SQL .= " st.queue_id in ( ";
        foreach (0..$#ViewableQueueIDs) {
            if ($_ > 0) {
                $SQL .= ",";
            }
            $SQL .= $Self->{DBObject}->Quote($ViewableQueueIDs[$_]);
        }
        $SQL .= " ) AND ".
          " sq.group_id IN ( ${\(join ', ', @GroupIDs)} ) ".
          " ORDER BY st.ticket_priority_id DESC, $SortOptions{$SortBy} $Order";
#          " ORDER BY st.ticket_priority_id DESC, st.freetime1 ASC";
#          " ORDER BY st.ticket_priority_id DESC, st.create_time_unix $Order";
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
    my $Counter = 0;
    foreach (@ViewableTickets) {
        $Counter++;
        print $Self->ShowTicket(TicketID => $_, Counter => $Counter);
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
    my %MoveQueues = $Self->{TicketObject}->MoveList(
        TicketID => $TicketID,
        UserID => $Self->{UserID},
        Action => $Self->{Action},
        Type => 'move_into',
    );
    # get last article
    my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(TicketID => $TicketID);
    # run article modules
    if (ref($Self->{ConfigObject}->Get('Ticket::Frontend::ArticlePreViewModule')) eq 'HASH') {
        my %Jobs = %{$Self->{ConfigObject}->Get('Ticket::Frontend::ArticlePreViewModule')};
        foreach my $Job (sort keys %Jobs) {
            # load module
            if ($Self->{MainObject}->Require($Jobs{$Job}->{Module})) {
                my $Object = $Jobs{$Job}->{Module}->new(
                    ConfigObject => $Self->{ConfigObject},
                    LogObject => $Self->{LogObject},
                    DBObject => $Self->{DBObject},
                    LayoutObject => $Self->{LayoutObject},
                    TicketObject => $Self->{TicketObject},
                    ArticleID => $Article{ArticleID},
                    UserID => $Self->{UserID},
                    Debug => $Self->{Debug},
                );
                # run module
                my @Data = $Object->Check(Article=> \%Article, %Param, Config => $Jobs{$Job});
                foreach my $DataRef (@Data) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ArticleOption',
                        Data => $DataRef,
                    );
                }
                # filter option
                $Object->Filter(Article=> \%Article, %Param, Config => $Jobs{$Job});
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }
    # fetch all std. responses ...
    my %StdResponses = $Self->{QueueObject}->GetStdResponses(QueueID => $Article{QueueID});
    # --
    # customer info
    # --
    my %CustomerData = ();
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoQueue')) {
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
    foreach (qw(From To Cc Subject)) {
        if ($Article{$_}) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    Key => $_,
                    Value => $Article{$_},
                },
            );
        }
    }
    foreach (qw(1 2 3 4 5)) {
        if ($Article{"FreeText$_"}) {
            $Self->{LayoutObject}->Block(
                Name => 'ArticleFreeText',
                Data => {
                    Key => $Article{"FreeKey$_"},
                    Value => $Article{"FreeText$_"},
                },
            );
        }
    }
    # create human age
    $Article{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Article{Age}, Space => ' ');
    # --
    # prepare escalation time
    # --
    if ($Article{TicketOverTime}) {
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
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoQueue')) {
        $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
            Data => {
                %Article,
                %CustomerData,
            },
            Type => 'Lite',
            Max => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoQueueMaxSize'),
        );
        $Self->{LayoutObject}->Block(
            Name => 'CustomerTable',
            Data => \%Param,
        );
    }
    # get StdResponsesStrg
    $Param{StdResponsesStrg} = $Self->{LayoutObject}->TicketStdResponseString(
        StdResponsesRef => \%StdResponses,
        TicketID => $Article{TicketID},
        ArticleID => $Article{ArticleID},
    );
    # --
    # check if just a only html email
    # --
    if (my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType(%Article, Action => 'AgentTicketZoom')) {
        $Article{BodyNote} = $MimeTypeText;
        $Article{Body} = '';
    }
    else {
         # html quoting
        $Article{Body} = $Self->{LayoutObject}->Ascii2Html(
            NewLine => $Self->{ConfigObject}->Get('DefaultViewNewLine') || 85,
            Text => $Article{Body},
            VMax => $Self->{ConfigObject}->Get('DefaultPreViewLines') || 25,
            HTMLResultMode => 1,
        );
        # do link quoting
        $Article{Body} = $Self->{LayoutObject}->LinkQuote(Text => $Article{Body});
        # do charset check
        if (my $CharsetText = $Self->{LayoutObject}->CheckCharset(
            Action => 'AgentTicketZoom',
            ContentCharset => $Article{ContentCharset},
            TicketID => $Article{TicketID},
            ArticleID => $Article{ArticleID} )) {
            $Article{BodyNote} = $CharsetText;
        }
    }
    # get MoveQueuesStrg
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') =~ /^form$/i) {
        $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Name => 'DestQueueID',
            Data => \%MoveQueues,
            SelectedID => $Article{QueueID},
        );
    }
    # get acl actions
    $Self->{TicketObject}->TicketAcl(
        Data => '-',
        Action => $Self->{Action},
        TicketID => $Article{TicketID},
        ReturnType => 'Action',
        ReturnSubType => '-',
        UserID => $Self->{UserID},
    );
    my %AclAction = $Self->{TicketObject}->TicketAclActionData();
    # run ticket pre menu modules
    if (ref($Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule')) eq 'HASH') {
        my %Menus = %{$Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule')};
        my $Counter = 0;
        foreach my $Menu (sort keys %Menus) {
            # load module
            if ($Self->{MainObject}->Require($Menus{$Menu}->{Module})) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    TicketID => $Self->{TicketID},
                );
                # run module
                $Counter = $Object->Run(
                    %Param,
                    Ticket => \%Article,
                    Counter => $Counter,
                    ACL => \%AclAction,
                    Config => $Menus{$Menu},
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }
    # create output
    if ($Self->{ConfigObject}->Get('Ticket::AgentCanBeCustomer') && $Article{CustomerUserID} && $Article{CustomerUserID} =~ /^$Self->{UserLogin}$/i) {
        $Self->{LayoutObject}->Block(
            Name => 'AgentIsCustomer',
            Data => {%Param, %Article, %AclAction},
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'AgentAnswer',
            Data => {%Param, %Article, %AclAction},
        );
    }
    # ticket bulk block
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::BulkFeature')) {
        $Self->{LayoutObject}->Block(
            Name => "Bulk",
            Data => { %Param, %Article },
        );
    }
    # create & return output
    my $TicketView = $Self->{UserQueueView} || $Self->{ConfigObject}->Get('PreferencesGroups')->{QueueView}->{DataSelected};
    if ($TicketView ne 'AgentTicketQueueTicketViewLite') {
        return $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketQueueTicketView',
            Data => { %Param, %Article, %AclAction},
        );
    }
    else {
        return $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketQueueTicketViewLite',
            Data => { %Param, %Article, %AclAction},
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
    # show available tickets
    if ($Self->{ViewAll}) {
        $Data{TicketsAvailAll} = $Data{AllTickets};
    }
    else {
        $Data{TicketsAvailAll} = $Data{TicketsAvail};
    }
    # check start option, if higher then tickets available, set
    # it to the last ticket page (Thanks to Stefan Schmidt!)
    if ($Self->{Start} > $Data{TicketsAvailAll}) {
           my $PageShown = $Self->{ViewableTickets};
           my $Pages = int(($Data{TicketsAvailAll} / $PageShown) + 0.99999);
           $Self->{Start} = (($Pages - 1) * $PageShown) + 1;
    }
    # build output ...
    my %AllQueues = $Self->{QueueObject}->GetAllQueues();
    $Self->_MaskQueueView(
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
    my $CustomQueue = $Self->{ConfigObject}->Get('Ticket::CustomQueue');
    $CustomQueue = $Self->{LayoutObject}->{LanguageObject}->Get($CustomQueue);

    $Param{SelectedQueue} = $AllQueues{$QueueID} || $CustomQueue;
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
        # replace name of CustomQueue
        if ($Queue{Queue} eq 'CustomQueue') {
            $Counter{$CustomQueue} = $Counter{$Queue{Queue}};
            $Queue{Queue} = $CustomQueue;
        }
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
           # build Page Navigator for AgentTicketQueue
           # --
           $Param{PageShown} = $Param{'ViewableTickets'};
           if ($Param{TicketsAvailAll} == 1 || $Param{TicketsAvailAll} == 0) {
               $Param{Result} = $Param{TicketsAvailAll};
           }
           elsif ($Param{TicketsAvailAll} >= ($Param{Start}+$Param{PageShown})) {
               $Param{Result} = $Param{Start}."-".($Param{Start}+$Param{PageShown}-1);
           }
           else {
               $Param{Result} = "$Param{Start}-$Param{TicketsAvailAll}";
           }
           my $Pages = int(($Param{TicketsAvailAll} / $Param{PageShown}) + 0.99999);
           my $Page = int(($Param{Start} / $Param{PageShown}) + 0.99999);
           for (my $i = 1; $i <= $Pages; $i++) {
               $Param{PageNavBar} .= " <a href=\"$Self->{LayoutObject}->{Baselink}Action=\$Env{\"Action\"}".
                '&QueueID=$Data{"QueueID"}&ViewAll='.$Self->{ViewAll}.'&Start='. (($i-1)*$Param{PageShown}+1) .= '">';
               if ($Page == $i) {
                   $Param{PageNavBar} .= '<b>'.($i).'</b>';
               }
               else {
                   $Param{PageNavBar} .= ($i);
               }
               $Param{PageNavBar} .= '</a> ';
           }
        }
        $QueueStrg .= "<a href=\"$Self->{LayoutObject}->{Baselink}Action=AgentTicketQueue&QueueID=$Queue{QueueID}\"";
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
        $QueueStrg .= $Self->{LayoutObject}->Ascii2Html(Text => $ShortQueueName)." ($Counter{$Queue{Queue}})";
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
    $Self->{LayoutObject}->Block(
        Name => 'QueueNav',
        Data => \%Param,
    );
    return 1;
}
# --
1;
