# --
# AgentUtilities.pm - Utilities for tickets
# Copyright (C) 2001,2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentUtilities.pm,v 1.4 2002-04-08 20:40:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentUtilities;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
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
    foreach ('ParamObject', 'DBObject', 'TicketObject', 'LayoutObject', 'LogObject', 'QueueObject', 'ConfigObject') {
        die "Got no $_!" if (!$Self->{$_});
    }

    # get params
    $Self->{Want} = $Self->{ParamObject}->GetParam(Param => 'Want') || '';
    # get confid data
    $Self->{SearchLimitTn} = $Self->{ConfigObject}->Get('SearchLimitTn');
    $Self->{SearchLimitTxt} = $Self->{ConfigObject}->Get('SearchLimitTxt');
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
    my %LockedData = $Self->{DBObject}->GetLockedCount(UserID => $UserID);
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
    my %LockedData = $Self->{DBObject}->GetLockedCount(UserID => $UserID);
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
    my $SQL = "SELECT st.id, st.tn, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, sa.a_body, " .
    " st.create_time_unix, st.tn, st.user_id, st.ticket_state_id, st.ticket_priority_id, sa.create_time, " .
    " stt.name as sender_type, at.name as article_type, su.login, sl.name as lock_type, " .
    " sp.name as priority, tsd.name as state, sa.content_path, sq.name as queue " .
    " FROM " .
    " article sa, ticket st, article_sender_type stt, article_type at, user su, ticket_lock_type sl, " .
    " ticket_priority sp, ticket_state tsd, queue sq, group_user sug  " .
    " WHERE " .
    " st.tn LIKE '$Want' " .
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
    " AND " .
    " sq.group_id = sug.group_id" .
    " AND " .
    " sug.user_id = $UserID ";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Self->{SearchLimitTn});
    while (my $Data = $Self->{DBObject}->FetchrowHashref() ) {
        my $Age = time() - $$Data{create_time_unix};
        $OutputTables .= $Self->{LayoutObject}->AgentUtilSearchResult(
            TicketNumber => $$Data{tn},
            From => $$Data{a_from},
            To => $$Data{a_to},
            Subject => $$Data{a_subject},
            State => $$Data{state},
            Text => $$Data{a_body},
            Lock => $$Data{lock_type},
            Queue => $$Data{queue},
            TicketID => $$Data{id},
            Owner => $$Data{login},
            What => $Want,
			Age => $Age,
        );
    }
#    $Output .= $Self->{LayoutObject}->UtilSearchCouter(Limit => $Self->{SearchLimitTn});
    $Output .= $OutputTables;
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
    $Output .= $Self->{LayoutObject}->Header(Title => 'Utilities');
    my %LockedData = $Self->{DBObject}->GetLockedCount(UserID => $UserID);
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    $Output .= $Self->{LayoutObject}->AgentUtilSearchAgain(
        What => $Want,
        Kind => 'SearchByText',
        Limit => $Self->{SearchLimitTxt},
    );
    # modifier search string
    $Want =~ s/\+/%/gi;
    $Want =~ s/\*//gi;
    my @SParts = split('%', $Want);
    # building a spez. sql ext.
    my $SqlExt = '';
    my @SearchFields = ('sa.a_body', 'sa.a_subject', 'sa.a_from');
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
    my $OutputTables = '';
    my $Age = '?';
    my $SQL = "SELECT st.id, st.tn, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, sa.a_body, " .
    " st.create_time_unix, st.tn, st.user_id, st.ticket_state_id, st.ticket_priority_id, sa.create_time, " .
    " stt.name as sender_type, at.name as article_type, su.login, sl.name as lock_type, " .
    " sp.name as priority, tsd.name as state, sa.content_path, sq.name as queue " .
    " FROM " .
    " article sa, ticket st, article_sender_type stt, article_type at, user su, ticket_lock_type sl, " .
    " ticket_priority sp, ticket_state tsd, queue sq, group_user sug " .
    " WHERE  " .
    " ($SqlExt) " .
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
    " AND " .
    " sq.group_id = sug.group_id" .
    " AND " .
    " sug.user_id = $UserID " .
    "ORDER BY st.tn DESC";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Self->{SearchLimitTxt});
    while (my $Data = $Self->{DBObject}->FetchrowHashref() ) {
        my $Age = time() - $$Data{create_time_unix};
        $OutputTables .= $Self->{LayoutObject}->AgentUtilSearchResult(
            TicketNumber => $$Data{tn},
            From => $$Data{a_from},
            To => $$Data{a_to},
            Subject => $$Data{a_subject},
            State => $$Data{state},
            Text => $$Data{a_body},
            Lock => $$Data{lock_type},
            Queue => $$Data{queue},
            TicketID => $$Data{id},
            Owner => $$Data{login},
            What => $Want,
            Highlight => 1,
            Age => $Age,
        );
    }
    $Output .= $Self->{LayoutObject}->AgentUtilSearchCouter(Limit => $Self->{SearchLimitTxt});
    $Output .= $OutputTables;
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --

1;
