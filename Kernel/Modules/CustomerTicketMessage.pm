# --
# Kernel/Modules/CustomerTicketMessage.pm - to handle customer messages
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerTicketMessage.pm,v 1.3.2.3 2006-02-06 01:41:30 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerTicketMessage;

use strict;
use Kernel::System::SystemAddress;
use Kernel::System::Queue;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3.2.3 $';
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
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
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
    my $NextScreen = $Self->{NextScreen} || $Self->{ConfigObject}->Get('CustomerNextScreenAfterNewTicket');

    if ($Self->{Subaction} eq '' || !$Self->{Subaction}) {
        # header
        $Output .= $Self->{LayoutObject}->CustomerHeader();

        # if there is no ticket id!
        if (!$Self->{TicketID}) {
            $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
            # check own selection
            my %NewTos = ();
            my $Module = $Self->{ConfigObject}->Get('CustomerPanel::NewTicketQueueSelectionModule') || 'Kernel::Output::HTML::CustomerNewTicketQueueSelectionGeneric';
            if ($Self->{MainObject}->Require($Module)) {
                my $Object = $Module->new(
                    %{$Self},
                    Debug => $Self->{Debug},
                );
                # log loaded module
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "Module: $Module loaded!",
                    );
                }
                %NewTos = $Object->Run(Env => $Self);
            }
            else {
                return $Self->{LayoutObject}->ErrorScreen();
            }
            # get priority
            my %Priorities = $Self->{TicketObject}->PriorityList(
                CustomerUserID => $Self->{UserID},
                Action => $Self->{Action},
                QueueID => $Self->{QueueID},
            );
            # get default selections
            my %TicketFreeDefault = ();
            foreach (1..8) {
                $TicketFreeDefault{'TicketFreeKey'.$_} = $Self->{ConfigObject}->Get('TicketFreeKey'.$_.'::DefaultSelection');
                $TicketFreeDefault{'TicketFreeText'.$_} = $Self->{ConfigObject}->Get('TicketFreeText'.$_.'::DefaultSelection');
            }
            # get free text config options
            my %TicketFreeText = ();
            foreach (1..8) {
                $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Action => $Self->{Action},
                    Type => "TicketFreeKey$_",
                    CustomerUserID => $Self->{UserID},
                );
                $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Action => $Self->{Action},
                    Type => "TicketFreeText$_",
                    CustomerUserID => $Self->{UserID},
                );
            }
            my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
                Config => \%TicketFreeText,
                Ticket => { %TicketFreeDefault },
            );
            # get free text params
            my %TicketFreeTime = ();
            foreach (1..2) {
                foreach my $Type (qw(Year Month Day Hour Minute)) {
                    $TicketFreeTime{"TicketFreeTime".$_.$Type} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeTime".$_.$Type);
                }
            }
            # free time
            my %FreeTime = $Self->{LayoutObject}->CustomerFreeDate(
                %Param,
                Ticket => \%TicketFreeTime,
            );
            my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject');
            my $Body = $Self->{ParamObject}->GetParam(Param => 'Body');
            # html output
            $Output .= $Self->_MaskNew(
                To => \%NewTos,
                Priorities => \%Priorities,
                %TicketFreeTextHTML,
                %FreeTime,
                Body => $Body,
                Subject => $Subject,
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }
        else {
            # check permissions
            if (!$Self->{TicketObject}->CustomerPermission(
                Type => 'update',
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID})) {
                # error screen, don't show ticket
                return $Self->{LayoutObject}->CustomerNoPermission(WithHeader => 'yes');
            }
            # get ticket number
            my $Tn = $Self->{TicketObject}->TicketNumberLookup(TicketID => $Self->{TicketID});
            # print form ...
            $Output .= $Self->_Mask(
                TicketID => $Self->{TicketID},
                QueueID => $Self->{QueueID},
                TicketNumber => $Tn,
                NextStates => $Self->_GetNextStates(),
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }
    }
    elsif ($Self->{Subaction} eq 'Store') {
        # check permissions
        if (!$Self->{TicketObject}->CustomerPermission(
            Type => 'update',
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID})) {
            # error screen, don't show ticket
            return $Self->{LayoutObject}->CustomerNoPermission(WithHeader => 'yes');
        }
        # get ticket data
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $Self->{TicketID},
        );
        # get follow up option (possible or not)
        my $FollowUpPossible = $Self->{QueueObject}->GetFollowUpOption(
            QueueID => $Ticket{QueueID},
        );
        # get lock option (should be the ticket locked - if closed - after the follow up)
        my $Lock = $Self->{QueueObject}->GetFollowUpLockOption(
            QueueID => $Ticket{QueueID},
        );
        # get ticket state details
        my %State = $Self->{StateObject}->StateGet(
            ID => $Ticket{StateID},
            Cache => 1,
        );
        if ($FollowUpPossible =~ /(new ticket|reject)/i && $State{TypeName} =~ /^close/i) {
            $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
            $Output .= $Self->{LayoutObject}->CustomerWarning(
                Message => 'Can\'t reopen ticket, not possible in this queue!',
                Comment => 'Create a new ticket!',
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }
        # set lock if ticket was cloased
        if ($Lock && $State{TypeName} =~ /^close/i && $Ticket{OwnerID} ne '1') {
            $Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock => 'lock',
                UserID => => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Follow up!';
        my $Body = $Self->{ParamObject}->GetParam(Param => 'Body');
        my $StateID = $Self->{ParamObject}->GetParam(Param => 'ComposeStateID');
        my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";
        if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID => $Self->{TicketID},
            ArticleType => $Self->{ConfigObject}->Get('CustomerPanelArticleType'),
            SenderType => $Self->{ConfigObject}->Get('CustomerPanelSenderType'),
            From => $From,
            Subject => $Subject,
            Body => $Body,
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            OrigHeader => {
                From => $From,
                To => 'System',
                Subject => $Subject,
                Body => $Body,
            },
            HistoryType => $Self->{ConfigObject}->Get('CustomerPanelHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('CustomerPanelHistoryComment') || '%%',
            AutoResponseType => 'auto follow up',
        )) {
          # set state
          my %NextStateData = $Self->{StateObject}->StateGet(
              ID => $StateID,
          );
          my $NextState = $NextStateData{Name} ||
            $Self->{ConfigObject}->Get('CustomerPanelDefaultNextComposeType') || 'open';
          $Self->{TicketObject}->StateSet(
              TicketID => $Self->{TicketID},
              ArticleID => $ArticleID,
              State => $NextState,
              UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
          );

          # get attachment
          my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
              Param => 'file_upload',
              Source => 'String',
          );
          if (%UploadStuff) {
              $Self->{TicketObject}->ArticleWriteAttachment(
                  %UploadStuff,
                  ArticleID => $ArticleID,
                  UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
              );
          }
         # redirect to zoom view
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
    elsif ($Self->{Subaction} eq 'StoreNew') {
        # get dest queue
        my $Dest = $Self->{ParamObject}->GetParam(Param => 'Dest') || '';
        my ($NewQueueID, $To) = split(/\|\|/, $Dest);
        if (!$To) {
          $NewQueueID = $Self->{ParamObject}->GetParam(Param => 'NewQueueID') || '';
          $To = 'System';
        }
        # fallback, if no dest is given
        if (!$NewQueueID) {
            my $Queue = $Self->{ParamObject}->GetParam(Param => 'Queue') || '';
            if ($Queue) {
                my $QueueID = $Self->{QueueObject}->QueueLookup(Queue => $Queue);
                $NewQueueID = $QueueID;
                $To = $Queue;
            }
        }
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'New!';
        my $Body = $Self->{ParamObject}->GetParam(Param => 'Body');
        my %TicketFree = ();
        foreach (1..8) {
            $TicketFree{"TicketFreeKey$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeKey$_");
            $TicketFree{"TicketFreeText$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeText$_");
        }
        my $PriorityID = $Self->{ParamObject}->GetParam(Param => 'PriorityID');
        my $Priority = '';
        # if customer is not alown to set priority, set it to default
        if (!$Self->{ConfigObject}->Get('CustomerPriority')) {
            $PriorityID = '';
            $Priority = $Self->{ConfigObject}->Get('CustomerDefaultPriority');
        }
        my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";
        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->TicketCreate(
            QueueID => $NewQueueID,
            Title => $Subject,
            Lock => 'unlock',
            State => $Self->{ConfigObject}->Get('CustomerDefaultState'),
            Priority => $Priority,
            PriorityID => $PriorityID,
            CustomerNo => $Self->{UserCustomerID},
            CustomerUser => $Self->{UserLogin},
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            CreateUserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
        );
        # set ticket free text
        foreach (1..8) {
            if (defined($TicketFree{"TicketFreeKey$_"})) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $TicketID,
                    Key => $TicketFree{"TicketFreeKey$_"},
                    Value => $TicketFree{"TicketFreeText$_"},
                    Counter => $_,
                    UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                );
            }
        }
        # get free text params
        my %TicketFreeTime = ();
        foreach (1..2) {
              foreach my $Type (qw(Year Month Day Hour Minute)) {
                  $TicketFreeTime{"TicketFreeTime".$_.$Type} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeTime".$_.$Type);
              }
        }
        # set ticket free time
        foreach (1..2) {
              if (defined($TicketFreeTime{"TicketFreeTime".$_."Year"}) &&
                  defined($TicketFreeTime{"TicketFreeTime".$_."Month"}) &&
                  defined($TicketFreeTime{"TicketFreeTime".$_."Day"}) &&
                  defined($TicketFreeTime{"TicketFreeTime".$_."Hour"}) &&
                  defined($TicketFreeTime{"TicketFreeTime".$_."Minute"})) {
                  $Self->{TicketObject}->TicketFreeTimeSet(
                      %TicketFreeTime,
                      TicketID => $TicketID,
                      Counter => $_,
                      UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                  );
              }
        }
        # create article
        if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID => $TicketID,
            ArticleType => $Self->{ConfigObject}->Get('CustomerPanelNewArticleType'),
            SenderType => $Self->{ConfigObject}->Get('CustomerPanelNewSenderType'),
            From => $From,
            To => $To,
            Subject => $Subject,
            Body => $Body,
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            HistoryType => $Self->{ConfigObject}->Get('CustomerPanelNewHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('CustomerPanelNewHistoryComment') || '%%',
            AutoResponseType => 'auto reply',
            OrigHeader => {
                From => $From,
                To => $Self->{UserLogin},
                Subject => $Subject,
                Body => $Body,
            },
            Queue => $Self->{QueueObject}->QueueLookup(QueueID => $NewQueueID),
        )) {
          # get attachment
          my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
              Param => 'file_upload',
              Source => 'String',
          );
          if (%UploadStuff) {
              $Self->{TicketObject}->ArticleWriteAttachment(
                  %UploadStuff,
                  ArticleID => $ArticleID,
                  UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
              );
          }
          # redirect
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
    # get next states
    my %NextStates = $Self->{TicketObject}->StateList(
        Type => 'CustomerPanelDefaultNextCompose',
        TicketID => $Self->{TicketID},
        Action => $Self->{Action},
        CustomerUserID => $Self->{UserID},
    );
    return \%NextStates;
}
# --
sub _MaskNew {
    my $Self = shift;
    my %Param = @_;
    # build to string
    my %NewTo = ();
    if ($Param{To}) {
        foreach (keys %{$Param{To}}) {
             $NewTo{"$_||$Param{To}->{$_}"} = $Param{To}->{$_};
        }
    }
    $Param{'ToStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => \%NewTo,
        Multiple => 0,
        Size => 0,
        Name => 'Dest',
        SelectedID => $Param{ToSelected},
        OnChangeSubmit => 0,
    );
    # build priority string
    $Param{'PriorityStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{Priorities},
        Name => 'PriorityID',
        Selected => $Self->{ConfigObject}->Get('CustomerDefaultPriority') || '3 normal',
    );
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'CustomerTicketMessageNew', Data => \%Param);
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'ComposeStateID',
        Selected => $Self->{ConfigObject}->Get('CustomerPanelDefaultNextComposeType')
    );
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'CustomerTicketMessage', Data => \%Param);
}
# --
1;
