# --
# AgentPhone.pm - to handle phone calls
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPhone.pm,v 1.2 2002-05-26 10:16:44 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPhone;

use strict;
use Kernel::System::Article;

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
    my $NextScreen = $Self->{NextScreen} || 'AgentZoom';
    my $BackScreen = $Self->{BackScreen};
    my $UserID = $Self->{UserID};
    my $UserLogin = $Self->{UserLogin};
    
    my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
    
    if ($Subaction eq '' || !$Subaction) {
        # --
        # header
        # --
        $Output .= $Self->{LayoutObject}->Header(Title => 'Phone call');

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
        # get next states
        my %NextStates;
        my $NextComposeTypePossibleTmp =
           $Self->{ConfigObject}->Get('DefaultPhoneNextStatePossible')
             || die 'No Config entry "DefaultPhoneNextStatePossible"!';
        my @NextComposeTypePossible = @$NextComposeTypePossibleTmp;
        foreach (@NextComposeTypePossible) {
            $NextStates{$Self->{TicketObject}->StateLookup(State => $_)} = $_;
        }

        # --
        # if there is no ticket id!
        # --
        if (!$TicketID) {
            my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $UserID);
            $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    
            my %Tos = $Self->{DBObject}->GetTableData(
                Table => 'system_address',
                What => 'queue_id, value1, value0',
                Valid => 1,
                Clamp => 1,
            );

            $Output .= $Self->{LayoutObject}->AgentPhoneNew(
              QueueID => $QueueID,
              BackScreen => $BackScreen,
              NextScreen => $NextScreen,
              NoteTypes => \%NoteTypes,
              NextStates => \%NextStates,
              To => \%Tos,
           );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # get lock state && permissions
        my $LockState = $Self->{TicketObject}->GetLockState(TicketID => $TicketID) || 0;
        if (!$LockState) {
          # set owner
          $Self->{TicketObject}->SetOwner(
            TicketID => $TicketID,
            UserID => $UserID,
            UserLogin => $UserLogin,
          );
          # set lock
          if ($Self->{TicketObject}->SetLock(
            TicketID => $TicketID,
            Lock => 'lock',
            UserID => $UserID
          )) {
            # show lock state
            $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $TicketID);
          }
        }
        else {
          my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->CheckOwner(
            TicketID => $TicketID,
          );

          if ($OwnerID != $UserID) {
            $Output .= $Self->{LayoutObject}->Error(
                Message => "Sorry, the current owner is $OwnerLogin",
                Comment => 'Please change the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
          }
        }

        # print form ...
        $Output .= $Self->{LayoutObject}->AgentPhone(
            TicketID => $TicketID,
            QueueID => $QueueID,
            BackScreen => $BackScreen,
            NextScreen => $NextScreen,
            TicketNumber => $Tn,
            NoteTypes => \%NoteTypes,
            NextStates => \%NextStates,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    elsif ($Subaction eq 'Store') {
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Note!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Note');
        my $NextStateID = $Self->{ParamObject}->GetParam(Param => 'NextStateID') || '';
        my $NextState = $Self->{TicketObject}->StateIDLookup(StateID => $NextStateID);
        my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'NoteID');
        my $Answered = $Self->{ParamObject}->GetParam(Param => 'Answered') || '';
        my $ArticleObject = Kernel::System::Article->new(
            DBObject => $Self->{DBObject},
            ConfigObject => $Self->{ConfigObject},
        );
        my $ArticleID = $ArticleObject->CreateArticleDB(
            TicketID => $TicketID,
#            ArticleTypeID => $ArticleTypeID,
            ArticleType => $Self->{ConfigObject}->Get('DefaultPhoneArticleType'),
            SenderType => $Self->{ConfigObject}->Get('DefaultPhoneSenderType'),
            From => $UserLogin,
            To => $UserLogin,
            Subject => $Subject,
            Body => $Text,
            CreateUserID => $UserID
        );
        $Self->{TicketObject}->AddHistoryRow(
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            HistoryType => $Self->{ConfigObject}->Get('DefaultPhoneHistoryType'),
            Name => $Self->{ConfigObject}->Get('DefaultPhoneHistoryComment'),
            CreateUserID => $UserID,
        );

        # --
        # set state
        # --
        if ($Self->{TicketObject}->GetState(TicketID => $TicketID)  ne $NextState) {
          $Self->{TicketObject}->SetState(
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            State => $NextState,
            UserID => $UserID,
          );
        }

        # --
        # set answerd
        # --
        $Self->{TicketObject}->SetAnswered(
            TicketID => $TicketID,
            UserID => $UserID,
            Answered => $Answered,
        );

        # --
        # should i set an unlock?
        # --
        if ($NextState =~ /^close/i) {
          $Self->{TicketObject}->SetLock(
            TicketID => $TicketID,
            Lock => 'unlock',
            UserID => $UserID,
          );
        }

        # --
        # redirect to zoom view
        # --        
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=$NextScreen&QueueID=$QueueID&TicketID=$TicketID",
        );
    }
    elsif ($Subaction eq 'StoreNew') {
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Note!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Note');
        my $NextStateID = $Self->{ParamObject}->GetParam(Param => 'NextStateID') || '';
        my $NextState = $Self->{TicketObject}->StateIDLookup(StateID => $NextStateID);
        my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'NoteID');
        my $NewQueueID = $Self->{ParamObject}->GetParam(Param => 'NewQueueID') || 4;
        my $From = $Self->{ParamObject}->GetParam(Param => 'From') || '??';
        my $ArticleObject = Kernel::System::Article->new(
            DBObject => $Self->{DBObject},
            ConfigObject => $Self->{ConfigObject},
        );

        # create new ticket
        my $NewTn = $Self->{TicketObject}->CreateTicketNr();

        # do db insert
        my $TicketID = $Self->{TicketObject}->CreateTicketDB(
            TN => $NewTn,
            QueueID => $NewQueueID,
            Lock => 'unlock',
            # FIXME !!!
            GroupID => 1,
            StateID => $NextStateID,
            Priority => 'normal',
            UserID => $Self->{UserID},
            CreateUserID => $Self->{UserID},
        );

        my $ArticleID = $ArticleObject->CreateArticleDB(
            TicketID => $TicketID,
#            ArticleTypeID => $ArticleTypeID,
            ArticleType => $Self->{ConfigObject}->Get('DefaultPhoneNewArticleType'),
            SenderType => $Self->{ConfigObject}->Get('DefaultPhoneNewSenderType'),
            From => $From,
            To => $UserLogin,
            Subject => $Subject,
            Body => $Text,
            CreateUserID => $UserID
        );

        $Self->{TicketObject}->AddHistoryRow(
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            HistoryType => $Self->{ConfigObject}->Get('DefaultPhoneNewHistoryType'),
            Name => $Self->{ConfigObject}->Get('DefaultPhoneNewHistoryComment'),
            CreateUserID => $UserID,
        );

        # should i set an unlock?
        if ($NextState =~ /^close/i) {
          $Self->{TicketObject}->SetLock(
            TicketID => $TicketID,
            Lock => 'unlock',
            UserID => $UserID,
          );
        }
        
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=$NextScreen&QueueID=$QueueID&TicketID=$TicketID",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
