# --
# Kernel/Modules/CustomerMessage.pm - to handle customer messages
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerMessage.pm,v 1.16 2003-05-13 22:53:09 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerMessage;

use strict;
use Kernel::System::SystemAddress;
use Kernel::System::Queue;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16 $';
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
       ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }
    # needed objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{SystemAddress} = Kernel::System::SystemAddress->new(%Param);
    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $QueueID = $Self->{QueueID};
    my $Subaction = $Self->{Subaction};
    my $NextScreen = $Self->{NextScreen} || $Self->{ConfigObject}->Get('CustomerNextScreenAfterNewTicket');
    my $BackScreen = $Self->{BackScreen};
    my $UserID = $Self->{UserID};
    my $UserLogin = $Self->{UserLogin};
    
    if ($Subaction eq '' || !$Subaction) {
        # --
        # header
        # --
        $Output .= $Self->{LayoutObject}->CustomerHeader(Title => 'Message');

        # --
        # if there is no ticket id!
        # --
        if (!$Self->{TicketID}) {
            $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
            # --
            # check own selection
            # --
            my %NewTos = ();
            if ($Self->{ConfigObject}->{CustomerPanelOwnSelection}) {
                %NewTos = %{$Self->{ConfigObject}->{CustomerPanelOwnSelection}};
            }
            else {
                # --
                # SelectionType Queue or SystemAddress?    
                # --
                my %Tos = ();
                if ($Self->{ConfigObject}->Get('CustomerPanelSelectionType') eq 'Queue') {
                    %Tos = $Self->{QueueObject}->GetAllQueues();
                }
                else {
                    %Tos = $Self->{DBObject}->GetTableData(
                        Table => 'system_address',
                        What => 'queue_id, id',
                        Valid => 1,
                        Clamp => 1,
                    );
                }
                %NewTos = %Tos;
                # --
                # build selection string
                # --
                foreach (keys %NewTos) {
                    my %QueueData = $Self->{QueueObject}->QueueGet(ID => $_);
                    my $Srting = $Self->{ConfigObject}->Get('CustomerPanelSelectionString') || '<Realname> <<Email>> - Queue: <Queue>';
                    $Srting =~ s/<Queue>/$QueueData{Name}/g;
                    $Srting =~ s/<QueueComment>/$QueueData{Comment}/g;
                    if ($Self->{ConfigObject}->Get('CustomerPanelSelectionType') ne 'Queue') {
                        my %SystemAddressData = $Self->{SystemAddress}->SystemAddressGet(ID => $NewTos{$_});
                        $Srting =~ s/<Realname>/$SystemAddressData{Realname}/g;
                        $Srting =~ s/<Email>/$SystemAddressData{Name}/g;
                    }
                    $NewTos{$_} = $Srting;
                }
            }
            # -- 
            # get priority
            # --
            my %Priorities = $Self->{DBObject}->GetTableData(
                What => 'id, name',
                Table => 'ticket_priority',
            );
            # --
            # html output
            # --
            $Output .= $Self->{LayoutObject}->CustomerMessageNew(
                To => \%NewTos,
                Priorities => \%Priorities,
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }
        else {
            my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $Self->{TicketID});
            # --
            # print form ...
            # --
            $Output .= $Self->{LayoutObject}->CustomerMessage(
                TicketID => $Self->{TicketID},
                QueueID => $QueueID,
                TicketNumber => $Tn,
                NextStates => $Self->_GetNextStates(),
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }
    }
    elsif ($Subaction eq 'Store') {
        # check if it is possible to do the follow up
        my $QueueID = $Self->{TicketObject}->GetQueueIDOfTicketID(
            TicketID => $Self->{TicketID},
        );
        # get follow up option (possible or not)
        my $FollowUpPossible = $Self->{QueueObject}->GetFollowUpOption(
            QueueID => $QueueID,
        );
        # get ticket state 
        my $State = $Self->{TicketObject}->GetState(
            TicketID => $Self->{TicketID},
        );
        if ($FollowUpPossible =~ /(new ticket|reject)/i && $State =~ /^close/i) {
            $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
            $Output .= $Self->{LayoutObject}->CustomerWarning(
                Message => 'Can\'t reopen ticket, not possible in this queue!',
                Comment => 'Create a new ticket!',
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Follow up!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Note');
        my $StateID = $Self->{ParamObject}->GetParam(Param => 'ComposeStateID');
        my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>"; 
        if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            TicketID => $Self->{TicketID},
            ArticleType => $Self->{ConfigObject}->Get('CustomerPanelArticleType'),
            SenderType => $Self->{ConfigObject}->Get('CustomerPanelSenderType'),
            From => $From,
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{'UserCharset'}",
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'), 
            OrigHeader => {
                From => $From,
                To => 'System',
                Subject => $Subject,
                Body => $Text,
            },
            HistoryType => $Self->{ConfigObject}->Get('CustomerPanelHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('CustomerPanelHistoryComment'),
        )) {
          # --
          # set state
          # --
          my $State = $Self->{TicketObject}->StateIDLookup(StateID => $StateID) || 
            $Self->{ConfigObject}->Get('CustomerPanelDefaultNextComposeType') || 'open';
          $Self->{TicketObject}->SetState(
            TicketID => $Self->{TicketID},
            ArticleID => $ArticleID,
            State => $State,
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
          );
          # --
          # set answerd
          # --
          $Self->{TicketObject}->SetAnswered(
            TicketID => $Self->{TicketID},
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            Answered => 0,
          );
          # --
          # get attachment
          # -- 
          my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
              Param => 'file_upload', 
              Source => 'String',
          );
          if (%UploadStuff) {
              $Self->{TicketObject}->WriteArticlePart(
                  %UploadStuff,
                  ArticleID => $ArticleID, 
                  UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
              );
          }
         # --
         # redirect to zoom view
         # --        
         return $Self->{LayoutObject}->Redirect(
              OP => "Action=$NextScreen&TicketID=$Self->{TicketID}",
         );
      }
      else {
        $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError();
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
      }
    }
    elsif ($Subaction eq 'StoreNew') {
        my $Dest = $Self->{ParamObject}->GetParam(Param => 'Dest') || '';
        my ($NewQueueID, $To) = split(/\|\|/, $Dest);
        if (!$To) {
          $NewQueueID = $Self->{ParamObject}->GetParam(Param => 'NewQueueID') || '';
          $To = 'System';
        }
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'New!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Note');
        my $PriorityID = $Self->{ParamObject}->GetParam(Param => 'PriorityID');
        my $Priority = '';
        if (!$Self->{ConfigObject}->Get('CustomerPriority')) {
            $PriorityID = '';
            $Priority = 'normal';
        }
        if (!$PriorityID) {
            $Priority = 'normal';
        }
        my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>"; 
        # create new ticket
        my $NewTn = $Self->{TicketObject}->CreateTicketNr();

        # do db insert
        my $TicketID = $Self->{TicketObject}->CreateTicketDB(
            TN => $NewTn,
            QueueID => $NewQueueID,
            Lock => 'unlock',
            # FIXME !!!
            GroupID => 1,
            State => 'new',
            Priority => $Priority,
            PriorityID => $PriorityID, 
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            CreateUserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
        );

      if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            TicketID => $TicketID,
            ArticleType => $Self->{ConfigObject}->Get('CustomerPanelNewArticleType'),
            SenderType => $Self->{ConfigObject}->Get('CustomerPanelNewSenderType'),
            From => $From,
            To => $To,
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{'UserCharset'}",
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            HistoryType => $Self->{ConfigObject}->Get('CustomerPanelNewHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('CustomerPanelNewHistoryComment'),
            AutoResponseType => 'auto reply',
            OrigHeader => {
                From => $From,
                To => $UserLogin,
                Subject => $Subject,
                Body => $Text,
            },
            Queue => $Self->{QueueObject}->QueueLookup(QueueID => $NewQueueID),
        )) {
          # --
          # set Customer ID
          # --
          if ($Self->{UserCustomerID} || $Self->{UserLogin}) {
              $Self->{TicketObject}->SetCustomerData(
                  TicketID => $TicketID,
                  No => $Self->{UserCustomerID}, 
                  User => $Self->{UserLogin},
                  UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
               );
          }
          # --
          # get attachment
          # -- 
          my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
              Param => 'file_upload', 
              Source => 'String',
          );
          if (%UploadStuff) {
              $Self->{TicketObject}->WriteArticlePart(
                  %UploadStuff,
                  ArticleID => $ArticleID, 
                  UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
              );
          }
          # --
          # redirect
          # --
          return $Self->{LayoutObject}->Redirect(
              OP => "Action=$NextScreen&TicketID=$TicketID",
          );
      }
      else {
        $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError();
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
      }
    }
    else {
        $Output .= $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
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
