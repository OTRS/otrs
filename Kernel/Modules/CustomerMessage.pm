# --
# Kernel/Modules/CustomerMessage.pm - to handle customer messages
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerMessage.pm,v 1.1 2002-10-20 15:40:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerMessage;

use strict;
use Kernel::System::SystemAddress;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject 
       ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{SystemAddress} = Kernel::System::SystemAddress->new(%Param);

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
    my $NextScreen = $Self->{NextScreen} || 'CustomerZoom';
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
        if (!$TicketID) {
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
            # html output
            # --
            $Output .= $Self->{LayoutObject}->CustomerMessageNew(
              To => \%NewTos,
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }
        else {
            my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
            # --
            # print form ...
            # --
            $Output .= $Self->{LayoutObject}->CustomerMessage(
                TicketID => $TicketID,
                QueueID => $QueueID,
                TicketNumber => $Tn,
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }
    }
    elsif ($Subaction eq 'Store') {
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Follow up!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Note');
        my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>"; 
        if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            TicketID => $TicketID,
            ArticleType => $Self->{ConfigObject}->Get('CustomerPanelArticleType'),
            SenderType => $Self->{ConfigObject}->Get('CustomerPanelSenderType'),
            From => $From,
            To => $UserLogin,
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
          $Self->{TicketObject}->SetState(
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            State => 'open',
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
          );
          # --
          # set answerd
          # --
          $Self->{TicketObject}->SetAnswered(
            TicketID => $TicketID,
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            Answered => 0,
         );
         # --
         # redirect to zoom view
         # --        
         return $Self->{LayoutObject}->Redirect(
              OP => "&Action=$NextScreen&TicketID=$TicketID",
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
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'New!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Note');
        my $NewQueueID = $Self->{ParamObject}->GetParam(Param => 'NewQueueID') || '';
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
            Priority => 'normal',
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            CreateUserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
        );

      if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            TicketID => $TicketID,
            ArticleType => $Self->{ConfigObject}->Get('CustomerPanelNewArticleType'),
            SenderType => $Self->{ConfigObject}->Get('CustomerPanelNewSenderType'),
            From => $From,
            To => 'System', 
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
          if ($Self->{UserCustomerID}) {
              $Self->{TicketObject}->SetCustomerNo(
                  TicketID => $TicketID,
                  No => $Self->{UserCustomerID}, 
                  UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
               );
          }
          # --
          # redirect
          # --
          return $Self->{LayoutObject}->Redirect(
              OP => "&Action=$NextScreen&TicketID=$TicketID",
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

1;
