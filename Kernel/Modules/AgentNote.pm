# --
# AgentNote.pm - to add notes to a ticket 
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentNote.pm,v 1.6 2002-06-16 20:44:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentNote;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
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
      'ArticleObject',
    ) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $TicketID = $Self->{TicketID};
    my $QueueID = $Self->{QueueID};
    my $Subaction = $Self->{Subaction};
    my $NextScreen = $Self->{NextScreen} || '';
    my $BackScreen = $Self->{BackScreen};
    my $UserID = $Self->{UserID};
    my $UserLogin = $Self->{UserLogin};
    
    my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
    
    if ($Subaction eq '' || !$Subaction) {
        # get possible notes
        my %NoteTypes = $Self->{DBObject}->GetTableData(
            Table => 'article_type',
            Valid => 1,
            What => 'id, name'
        );
        foreach (keys %NoteTypes) {
            if ($NoteTypes{$_} !~ /^note/i) {
                delete $NoteTypes{$_};
            }
        }
        # print form ...
        $Output .= $Self->{LayoutObject}->Header(Title => 'Add Note');
        $Output .= $Self->{LayoutObject}->AgentNote(
            TicketID => $TicketID,
            QueueID => $QueueID,
            BackScreen => $BackScreen,
            NextScreen => $NextScreen,
            TicketNumber => $Tn,
            NoteSubject => $Self->{ConfigObject}->Get('DefaultNoteSubject'),
            NoteTypes => \%NoteTypes,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    elsif ($Subaction eq 'Store') {
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Note!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Note');
        my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'NoteID');
        my $ArticleID = $Self->{ArticleObject}->CreateArticleDB(
            TicketID => $TicketID,
            ArticleTypeID => $ArticleTypeID,
            SenderType => 'agent',
            From => $UserLogin,
            To => $UserLogin,
            Subject => $Subject,
            Body => $Text,
            CreateUserID => $UserID
        );
        $Self->{TicketObject}->AddHistoryRow(
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            HistoryType => 'AddNote',
            Name => "Note added.",
            CreateUserID => $UserID,
        );
        
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=$NextScreen&QueueID=$QueueID&TicketID=$TicketID",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            MSG => 'No Subaction!!',
            REASON => 'Please contact your admin',
        );
#        $Self->{LogObject}->ErrorLog(
#            MSG => 'No Subaction!!',
#            REASON => 'Please contact your admin',
#        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
