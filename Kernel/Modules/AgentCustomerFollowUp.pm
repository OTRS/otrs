# --
# Kernel/Modules/AgentCustomerFollowUp.pm - to handle customer messages
# if the agent is customer
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentCustomerFollowUp.pm,v 1.2 2003-04-08 21:36:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentCustomerFollowUp;

use strict;
use Kernel::System::SystemAddress;
use Kernel::System::Queue;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
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
    
    if ($Self->{Subaction} eq '' || !$Self->{Subaction}) {
        # --
        # if there is no ticket id!
        # --
        if (!$Self->{TicketID}) {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'No TicketID!',
                Comment => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            # --
            # header
            # --
            $Output .= $Self->{LayoutObject}->Header(Title => 'Compose Follow up');
            # get user lock data
            my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
            # build NavigationBar 
            $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

            my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $Self->{TicketID});
            # --
            # print form ...
            # --
            $Output .= $Self->{LayoutObject}->AgentCustomerMessage(
                TicketID => $Self->{TicketID},
                QueueID => $Self->{QueueID},
                TicketNumber => $Tn,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    elsif ($Self->{Subaction} eq 'Store') {
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
#$Self->{StateObject}->StateGetStatesByType
        if ($FollowUpPossible =~ /(new ticket|reject)/i && $State =~ /^close/i) {
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Warning(
                Message => 'Can\'t reopen ticket, not possible in this queue!',
                Comment => 'Create a new ticket!',
            );
            $Output .= $Self->{LayoutObject}->Footer();
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
            To => $Self->{UserLogin},
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{'UserCharset'}",
            UserID => $Self->{UserID}, 
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
            UserID => $Self->{UserID},
          );
          # --
          # set answerd
          # --
          $Self->{TicketObject}->SetAnswered(
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
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
                  UserID => $Self->{UserID},
              );
          }
         # --
         # redirect to zoom view
         # --        
         return $Self->{LayoutObject}->Redirect(
              OP => "Action=AgentZoom&TicketID=$Self->{TicketID}",
         );
      }
      else {
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
      }
    }
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
