# --
# Kernel/Modules/AgentUtilities.pm - Utilities for tickets
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentUtilities.pm,v 1.25.2.1 2003-05-29 16:09:19 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentUtilities;

use strict;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.25.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    # get params
    $Self->{Want} = $Self->{ParamObject}->GetParam(Param => 'Want') || '';
    $Self->{StartHit} = $Self->{ParamObject}->GetParam(Param => 'StartHit') || 1;
    # get confid data
    $Self->{SearchLimit} = $Self->{ConfigObject}->Get('SearchLimit') || 200;
    $Self->{SearchPageShown} = $Self->{ConfigObject}->Get('SearchPageShown') || 15;
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    
    if ($Self->{Subaction} eq 'Search') {
        $Output = $Self->Search();
    }
    else {
        $Output = $Self->Form();
    }
    return $Output;
}
# --
sub Form {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $UserID = $Self->{UserID};

    # --
    # get user of own groups
    # --
    my %ShownUsers = ();
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type => 'Long',
        Valid => 1,
    );
    if ($Self->{ConfigObject}->Get('ChangeOwnerToEveryone')) {
        %ShownUsers = %AllGroupsMembers;
    }
    else {
        my %Groups = $Self->{GroupObject}->GroupUserList(
            UserID => $Self->{UserID},
            Type => 'rw',
            Result => 'HASH',
        );
        foreach (keys %Groups) {
            my %MemberList = $Self->{GroupObject}->GroupMemberList(
                GroupID => $_,
                Type => 'rw',
                Result => 'HASH',
            );
            foreach (keys %MemberList) {
                $ShownUsers{$_} = $AllGroupsMembers{$_};
            }
        }
    }
    
    $Output .= $Self->{LayoutObject}->Header(Title => 'Utilities');
    my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $UserID);
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    $Output .= $Self->{LayoutObject}->AgentUtilForm(
        Users => \%ShownUsers,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    
    return $Output;
}
# --
sub Search {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $Want = $Self->{Want};
    my $UserID = $Self->{UserID};
    my @WhatFields = $Self->{ParamObject}->GetArray(Param => 'What');
    my @States = $Self->{ParamObject}->GetArray(Param => 'State');
    my @QueueIDs = $Self->{ParamObject}->GetArray(Param => 'QueueID');
    my @PriorityIDs = $Self->{ParamObject}->GetArray(Param => 'PriorityID');
    my @UserIDs = $Self->{ParamObject}->GetArray(Param => 'UserID');
    my $TicketNumber = $Self->{ParamObject}->GetParam(Param => 'TicketNumber') || '';
    $Output .= $Self->{LayoutObject}->Header(Title => 'Utilities');
    my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $UserID);
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    # --
    # add states to where statement
    # --
    my $SqlTicketNumberExt = '';
    if ($TicketNumber) {
        # modifier search string!!!
        my $TicketNumberTmp = $TicketNumber;
        $TicketNumberTmp =~ s/\*/%/g;
        $SqlTicketNumberExt .= " st.tn LIKE '$TicketNumberTmp' ";
    }
    my $SqlUserExt = '';
    foreach (@UserIDs) {
        $SqlUserExt = " st.user_id IN ( ${\(join ', ', @UserIDs)} )";
    }
    my $SqlStateExt = '';
    my $CounterTmp = 0;
    foreach (@States) {
        if ($CounterTmp != 0) {
            $SqlStateExt .= " or ";
        }
        $CounterTmp++;
        if (my $StateID = $Self->{TicketObject}->StateLookup(State => $_)) {
            $SqlStateExt .= " st.ticket_state_id = $StateID ";
        }
    }
    my $SqlQueueExt = '';
    $CounterTmp = 0;
    foreach (@QueueIDs) {
        if ($CounterTmp != 0) {
            $SqlQueueExt .= " or ";
        }
        $CounterTmp++;
        $SqlQueueExt .= " sq.id = $_ ";
    }
    my $SqlPriorityExt = '';
    $CounterTmp = 0;
    foreach (@PriorityIDs) {
        if ($CounterTmp != 0) {
            $SqlPriorityExt .= " or ";
        }
        $CounterTmp++;
        $SqlPriorityExt .= " st.ticket_priority_id = $_ ";
    }
    # --
    # modifier search string
    # --
    $Want =~ s/\+/%/gi;
    $Want =~ s/\*//gi;
    my @SParts = split('%', $Want);
    # --
    # show search again table
    # --
    # --
    # get user of own groups
    # --
    my %ShownUsers = ();
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type => 'Long',
        Valid => 1,
    );
    if ($Self->{ConfigObject}->Get('ChangeOwnerToEveryone')) {
        %ShownUsers = %AllGroupsMembers;
    }
    else {
        my %Groups = $Self->{GroupObject}->GroupUserList(
            UserID => $Self->{UserID},
            Type => 'rw',
            Result => 'HASH',
        );
        foreach (keys %Groups) {
            my %MemberList = $Self->{GroupObject}->GroupMemberList(
                GroupID => $_,
                Type => 'rw',
                Result => 'HASH',
            ); 
            foreach (keys %MemberList) {
                $ShownUsers{$_} = $AllGroupsMembers{$_};
            }
        }
    }
    $Output .= $Self->{LayoutObject}->AgentUtilSearchAgain(
        TicketNumber => $TicketNumber,
        What => $Want,
        Kind => 'SearchByText',
        Limit => $Self->{SearchLimit},
        WhatFields => \@WhatFields,
        SelectedStates => \@States,
        SelectedQueueIDs => \@QueueIDs,
        SelectedPriorityIDs => \@PriorityIDs,
        Users => \%ShownUsers,
        SelectedUserIDs => \@UserIDs,
    );

    # --
    # build a spez. sql ext.
    # --
    my $SqlExt = '';
    my %FieldSQLMap = (
        From => 'sa.a_from',
        To => 'sa.a_to',
        Cc => 'sa.a_cc',
        Subject => 'sa.a_subject',
        Body => 'sa.a_body',
        CustomerID => 'st.customer_id',
        TicketFreeText => 'st.freetext',
        ArticleFreeText => 'sa.a_freetext',
    );
    my @SearchFields = ();
    foreach my $Field (@WhatFields) {
        if ($FieldSQLMap{$Field}) {
          if ($Field eq 'TicketFreeText') {
            foreach (1..2) {
              push (@SearchFields, "$FieldSQLMap{$Field}$_");
            }
          }
          elsif ($Field eq 'ArticleFreeText') {
            foreach (1..3) {
              push (@SearchFields, "$FieldSQLMap{$Field}$_");
            }
          }
          else {
              push (@SearchFields, $FieldSQLMap{$Field});
          }
        }
    }
    # --
    # create tricky sql part
    # --
    $CounterTmp = 0;
    if (@SParts) {
        foreach my $Field (@SearchFields) {
            if ($CounterTmp != 0) {
                $SqlExt .= " or ";
            }
            $CounterTmp++;
            my $CounterTmp1 = 0;
            foreach (@SParts) {
                if ($CounterTmp1 != 0) {
                    $SqlExt .= " and ";
                }
                $CounterTmp1++;
                $SqlExt .= " $Field LIKE '%$_%' ";
            }
        }
    }
    # --
    # if there is no search field selected!
    # --
    if (!@SearchFields) {
        # --
        # error page
        # --
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => "Can't search! Select min. one search field!",
            Comment => 'Please Select min. one search field.',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # get users groups
    # --
    my @GroupIDs = $Self->{GroupObject}->GroupUserList(
        UserID => $Self->{UserID},
        Type => 'ro',
        Result => 'ID',
    );
    # --
    # db query
    # --
    my $OutputTables = '';
    my $Age = '?';
    my $SQL = "";
    if ($SqlExt) {
        $SQL = "SELECT sa.id ".
          " FROM ".
          " article sa, ticket st, queue sq ".
          " WHERE ".
          " sa.ticket_id = st.id ".
          " AND ";
    }
    else {
        $SQL = "SELECT st.id ".
          " FROM ".
          " ticket st, queue sq ".
          " WHERE ";
    }
    $SQL .= " sq.id = st.queue_id ".
      " AND ".
      " sq.group_id IN ( ${\(join ', ', @GroupIDs)} )";
    if ($SqlTicketNumberExt) {
        $SQL .= " AND $SqlTicketNumberExt";
    }
    if ($SqlUserExt) {
        $SQL .= " AND $SqlUserExt";
    } 
    if ($SqlQueueExt) { 
        $SQL .= " AND ($SqlQueueExt)"; 
    }
    if ($SqlStateExt) {
        $SQL .= " AND ($SqlStateExt)";
    }
    if ($SqlPriorityExt) {
        $SQL .= " AND ($SqlPriorityExt)";
    }
    if ($SqlExt) {
        $SQL .= " AND ($SqlExt) ";
    }
    $SQL .= ""; 
    $SQL .= " ORDER BY st.id DESC";
#    $SQL .= " GROUP BY st.id, sa.id ORDER BY st.id DESC";
#    " ORDER BY sa.incoming_time DESC";

    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Self->{SearchLimit});
    my @ViewableIDs = ();
    my $Counter = 0;
    while (my @Row = $Self->{DBObject}->FetchrowArray() ) {
         push (@ViewableIDs, $Row[0]);
    }
    foreach (@ViewableIDs) {
      $Counter++;
      # --
      # build search result
      # --
      if ($Counter >= $Self->{StartHit} && $Counter < ($Self->{SearchPageShown}+$Self->{StartHit}) ) {
        my %Data = ();
        my %Article = ();
        if ($SqlExt) {
            %Article = $Self->{TicketObject}->GetArticle(ArticleID => $_);
            %Data = $Self->{TicketObject}->GetTicket(TicketID => $Article{TicketID});
        }
        else {
            %Article = $Self->{TicketObject}->GetLastCustomerArticle(TicketID => $_);
            %Data = $Self->{TicketObject}->GetTicket(TicketID => $Article{TicketID});
        }
        # --
        # customer info
        # --
        my %CustomerData = ();
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
        $OutputTables .= $Self->{LayoutObject}->AgentUtilSearchResult(
            %Data,
            ArticleID => $_,
            From => $Article{From},
            To => $Article{To},
            Subject => $Article{Subject},
            Body => $Article{Body},
            Age => $Article{Age},
            Priority => $Article{Priority},
            Queue => $Article{Queue},
            ContentCharset => $Article{ContentCharset},
            MimeType => $Article{MimeType},
            What => $Want,
            Highlight => 1,
            CustomerData => \%CustomerData,
        );
      } 
    }
    # --
    # build search navigation bar
    # --
    my $SearchNavBar = $Self->{LayoutObject}->AgentUtilSearchCouter(
        TicketNumber => $TicketNumber,
        Limit => $Self->{SearchLimit}, 
        StartHit => $Self->{StartHit}, 
        SearchPageShown => $Self->{SearchPageShown},
        AllHits => $Counter,
        WhatFields => \@WhatFields,
        Want => $Self->{Want},
        SelectedStates => \@States,
        SelectedQueueIDs => \@QueueIDs,
        SelectedPriorityIDs => \@PriorityIDs,
        SelectedUserIDs => \@UserIDs,
    );
    $Output .= $SearchNavBar.$OutputTables;
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --

1;
