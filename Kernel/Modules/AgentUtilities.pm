# --
# Kernel/Modules/AgentUtilities.pm - Utilities for tickets
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentUtilities.pm,v 1.9 2002-09-01 20:24:04 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentUtilities;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
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
    foreach (
      'ParamObject', 
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

    # get params
    $Self->{Want} = $Self->{ParamObject}->GetParam(Param => 'Want') || '';
    $Self->{StartHit} = $Self->{ParamObject}->GetParam(Param => 'StartHit') || 0;
    # get confid data
    $Self->{SearchLimitTn} = $Self->{ConfigObject}->Get('SearchLimitTn') || 200;
    $Self->{SearchLimitTxt} = $Self->{ConfigObject}->Get('SearchLimitTxt') || 200;
    $Self->{SearchPageShown} = $Self->{ConfigObject}->Get('SearchPageShown') || 15;
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    
    if ($Self->{Subaction} eq 'SearchByTn') {
        $Output = $Self->SearchByTn();
    }
    elsif ($Self->{Subaction} eq 'SearchByText') {
        $Output = $Self->SearchByText();
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
    
    $Output .= $Self->{LayoutObject}->Header(Title => 'Utilities');
    my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $UserID);
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    $Output .= $Self->{LayoutObject}->AgentUtilForm();
    $Output .= $Self->{LayoutObject}->Footer();
    
    return $Output;
}
# --
sub SearchByTn {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $Want = $Self->{Want};
    my $UserID = $Self->{UserID};
    
    $Output .= $Self->{LayoutObject}->Header(Title => 'Utilities');
    my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $UserID);
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    $Output .= $Self->{LayoutObject}->AgentUtilSearchAgain(
        What => $Want,
        Kind => 'SearchByTn',
        Limit => $Self->{SearchLimitTn},
    );
    my $Age = '?';
    # modifier search string!!!
    $Want =~ s/\*/%/g;
    my $OutputTables = '';
    my $SQL = "SELECT st.id, st.tn, " .
    " st.create_time_unix, su.$Self->{ConfigObject}->{DatabaseUserTableUser} " .
    " FROM " .
    " ticket st, $Self->{ConfigObject}->{DatabaseUserTable} su, ". 
    " queue sq, group_user sug  ".
    " WHERE " .
    " sq.id = st.queue_id " .
    " AND " .
    " su.$Self->{ConfigObject}->{DatabaseUserTableUserID} = st.user_id " .
    " AND " .
    " sq.group_id = sug.group_id" .
    " AND " .
    " sug.user_id = $UserID ".
    " AND " .
    " st.tn LIKE '$Want' ";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Self->{SearchLimitTn});
    my @ViewableTicketIDs = ();
    my $Counter = 0;
    while (my $Data = $Self->{DBObject}->FetchrowHashref() ) {
      push (@ViewableTicketIDs, $$Data{id});
    }
    foreach (@ViewableTicketIDs) {
      $Counter++;
      # --
      # build search result
      # --
      if ($Counter > $Self->{StartHit} && $Counter <= ($Self->{SearchPageShown}+$Self->{StartHit}) ) {
        my %Ticket = $Self->{TicketObject}->GetTicket(TicketID => $_);
        my %LastArticle = $Self->{TicketObject}->GetLastCustomerArticle(TicketID => $_);
        my %Article = $Self->{ArticleObject}->GetArticle(ArticleID => $LastArticle{ArticleID});
        $OutputTables .= $Self->{LayoutObject}->AgentUtilSearchResult(
            %Ticket,
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
        );
      } 
    }
    # --
    # build search navigation bar
    # --
    my $SearchNavBar = $Self->{LayoutObject}->AgentUtilSearchCouter(
        Limit => $Self->{SearchLimitTxt}, 
        StartHit => $Self->{StartHit}, 
        SearchPageShown => $Self->{SearchPageShown},
        AllHits => $Counter,
        Want => $Self->{Want},
    );
    $Output .= $SearchNavBar.$OutputTables;
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --
sub SearchByText {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $Want = $Self->{Want};
    my $UserID = $Self->{UserID};
    my @WhatFields = $Self->{ParamObject}->GetArray(Param => 'What');
    $Output .= $Self->{LayoutObject}->Header(Title => 'Utilities');
    my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $UserID);
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    $Output .= $Self->{LayoutObject}->AgentUtilSearchAgain(
        What => $Want,
        Kind => 'SearchByText',
        Limit => $Self->{SearchLimitTxt},
        WhatFields => \@WhatFields,
    );
    # --
    # modifier search string
    # --
    $Want =~ s/\+/%/gi;
    $Want =~ s/\*//gi;
    my @SParts = split('%', $Want);
    # --
    # building a spez. sql ext.
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
    my $CounterTmp = 0;
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
    # db query
    # --
    my $OutputTables = '';
    my $Age = '?';
    my $SQL = "SELECT sa.id as article_id, st.id, st.tn, sa.a_from, sa.a_to, sa.a_cc, ".
    " sa.a_subject, sa.a_body, st.create_time_unix, st.tn, st.user_id, st.ticket_state_id, ".
    " sa.create_time, stt.name as sender_type, at.name as article_type, ".
    " su.$Self->{ConfigObject}->{DatabaseUserTableUser}, sl.name as lock_type, " .
    " tsd.name as state, sa.content_path, sq.name as queue " .
    " FROM " .
    " article sa, ticket st, article_sender_type stt, article_type at, ".
    " $Self->{ConfigObject}->{DatabaseUserTable} su, ticket_lock_type sl, " .
    " ticket_state tsd, queue sq, group_user sug " .
    " WHERE  " .
    " sa.ticket_id = st.id " .
    " AND " .
    " sq.id = st.queue_id " .
    " AND " .
    " stt.id = sa.article_sender_type_id " .
    " AND " .
    " at.id = sa.article_type_id " .
    " AND " .
    " su.$Self->{ConfigObject}->{DatabaseUserTableUserID} = st.user_id " .
    " AND " .
    " sl.id = st.ticket_lock_id " .
    " AND " .
    " tsd.id = st.ticket_state_id " .
    " AND " .
    " sq.group_id = sug.group_id" .
    " AND " .
    " sug.user_id = $UserID " .
    " AND " .
    " ($SqlExt) " .
    " ORDER BY sa.incoming_time DESC";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Self->{SearchLimitTxt});
    my @ViewableArticleIDs = ();
    my $Counter = 0;
    while (my $Data = $Self->{DBObject}->FetchrowHashref() ) {
      push (@ViewableArticleIDs, $$Data{article_id});
    }
    foreach (@ViewableArticleIDs) {
      $Counter++;
      # --
      # build search result
      # --
      if ($Counter > $Self->{StartHit} && $Counter <= ($Self->{SearchPageShown}+$Self->{StartHit}) ) {
        my %Article = $Self->{ArticleObject}->GetArticle(ArticleID => $_);
        my %Ticket = $Self->{TicketObject}->GetTicket(TicketID => $Article{TicketID});
        $OutputTables .= $Self->{LayoutObject}->AgentUtilSearchResult(
            %Ticket,
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
        );
      } 
    }
    # --
    # build search navigation bar
    # --
    my $SearchNavBar = $Self->{LayoutObject}->AgentUtilSearchCouter(
        Limit => $Self->{SearchLimitTxt}, 
        StartHit => $Self->{StartHit}, 
        SearchPageShown => $Self->{SearchPageShown},
        AllHits => $Counter,
        WhatFields => \@WhatFields,
        Want => $Self->{Want},
    );
    $Output .= $SearchNavBar.$OutputTables;
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --

1;
