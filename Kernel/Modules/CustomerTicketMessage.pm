# --
# Kernel/Modules/CustomerTicketMessage.pm - to handle customer messages
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerTicketMessage.pm,v 1.9 2006-03-20 01:22:54 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerTicketMessage;

use strict;
use Kernel::System::Web::UploadCache;
use Kernel::System::SystemAddress;
use Kernel::System::Queue;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
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
    $Self->{UploadCachObject} = Kernel::System::Web::UploadCache->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam(Param => 'FormID');
    # create form id
    if (!$Self->{FormID}) {
        $Self->{FormID} = $Self->{UploadCachObject}->FormIDCreate();
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # get params
    my %GetParam = ();
    foreach (qw(
        Subject Body PriorityID
        AttachmentUpload
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10 )) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
    }

    if (!$Self->{Subaction}) {
        # get default selections
        my %TicketFreeDefault = ();
        foreach (1..16) {
            $TicketFreeDefault{'TicketFreeKey'.$_} = $Self->{ConfigObject}->Get('TicketFreeKey'.$_.'::DefaultSelection');
            $TicketFreeDefault{'TicketFreeText'.$_} = $Self->{ConfigObject}->Get('TicketFreeText'.$_.'::DefaultSelection');
        }
        # get free text config options
        my %TicketFreeText = ();
        foreach (1..16) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Action => $Self->{Action},
                Type => "TicketFreeKey$_",
                UserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Action => $Self->{Action},
                Type => "TicketFreeText$_",
                UserID => $Self->{UserID},
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
        my %FreeTime = $Self->{LayoutObject}->AgentFreeDate(
            %Param,
            Ticket => \%TicketFreeTime,
        );

        # print form ...
        my $Output .= $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
        $Output .= $Self->_MaskNew(
              %TicketFreeTextHTML,
              %FreeTime,
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    elsif ($Self->{Subaction} eq 'StoreNew') {
        my $NextScreen = $Self->{Config}->{NextScreenAfterNewTicket};
        my %Error = ();
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
        my %TicketFree = ();
        foreach (1..16) {
            $TicketFree{"TicketFreeKey$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeKey$_");
            $TicketFree{"TicketFreeText$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeText$_");
        }
        # get free text config options
        my %TicketFreeText = ();
        foreach (1..16) {
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
            Ticket => { %TicketFree },
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
        # rewrap body if exists
        if ($GetParam{Body}) {
            $GetParam{Body} =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
        }
        # attachment delete
        foreach (1..10) {
            if ($GetParam{"AttachmentDelete$_"}) {
                $Error{AttachmentDelete} = 1;
                $Self->{UploadCachObject}->FormIDRemoveFile(
                    FormID => $Self->{FormID},
                    FileID => $_,
                );
            }
        }
        # attachment upload
        if ($GetParam{AttachmentUpload}) {
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param => "file_upload",
                Source => 'string',
            );
            $Self->{UploadCachObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }
        # get all attachments meta data
        my @Attachments = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );
        # check subject
        if (!$GetParam{Subject}) {
            $Error{"Subject invalid"} = '* invalid';
        }
        # check body
        if (!$GetParam{Body}) {
            $Error{"Body invalid"} = '* invalid';
        }
        if (%Error) {
            # html output
            my $Output .= $Self->{LayoutObject}->CustomerHeader();
            $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
            $Output .= $Self->_MaskNew(
                Attachments => \@Attachments,
                %GetParam,
                ToSelected => $Dest,
                %TicketFreeTextHTML,
                %FreeTime,
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }
        # if customer is not alown to set priority, set it to default
        if (!$Self->{Config}->{Priority}) {
            $GetParam{PriorityID} = '';
            $GetParam{Priority} = $Self->{Config}->{PriorityDefault};
        }
        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->TicketCreate(
            QueueID => $NewQueueID,
            Title => $GetParam{Subject},
            PriorityID => $GetParam{PriorityID} || '',
            Priority => $GetParam{Priority} || '',
            Lock => 'unlock',
            State => $Self->{Config}->{StateDefault},
            CustomerNo => $Self->{UserCustomerID},
            CustomerUser => $Self->{UserLogin},
            OwnerID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
        );
        # set ticket free text
        foreach (1..16) {
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
        %TicketFreeTime = ();
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
        my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";
        if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID => $TicketID,
            ArticleType => $Self->{Config}->{ArticleType},
            SenderType => $Self->{Config}->{SenderType},
            From => $From,
            To => $To,
            Subject => $GetParam{Subject},
            Body => $GetParam{Body},
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            HistoryType => $Self->{Config}->{HistoryType},
            HistoryComment => $Self->{Config}->{HistoryComment} || '%%',
            AutoResponseType => 'auto reply',
            OrigHeader => {
                From => $From,
                To => $Self->{UserLogin},
                Subject => $GetParam{Subject},
                Body => $GetParam{Body},
            },
            Queue => $Self->{QueueObject}->QueueLookup(QueueID => $NewQueueID),
        )) {
          # get pre loaded attachment
          my @AttachmentData = $Self->{UploadCachObject}->FormIDGetAllFilesData(
              FormID => $Self->{FormID},
          );
          foreach my $Ref (@AttachmentData) {
              $Self->{TicketObject}->ArticleWriteAttachment(
                  %{$Ref},
                  ArticleID => $ArticleID,
                  UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
              );
          }
          # get submit attachment
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
          # remove pre submited attachments
          $Self->{UploadCachObject}->FormIDRemove(FormID => $Self->{FormID});
          # redirect
          return $Self->{LayoutObject}->Redirect(
              OP => "Action=$NextScreen&TicketID=$TicketID",
          );
      }
      else {
          my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
          $Output .= $Self->{LayoutObject}->CustomerError();
          $Output .= $Self->{LayoutObject}->CustomerFooter();
          return $Output;
      }
    }
    else {
        my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
}
# --
sub _MaskNew {
    my $Self = shift;
    my %Param = @_;
    $Param{FormID} = $Self->{FormID};
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
        return $Self->{LayoutObject}->FatalError();
    }
    # build to string
    if (%NewTos) {
        foreach (keys %NewTos) {
             $NewTos{"$_||$NewTos{$_}"} = $NewTos{$_};
             delete $NewTos{$_};
        }
    }
    $Param{'ToStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => \%NewTos,
        Multiple => 0,
        Size => 0,
        Name => 'Dest',
        SelectedID => $Param{ToSelected},
        OnChangeSubmit => 0,
    );
    # get priority
    if ($Self->{Config}->{Priority}) {
        my %Priorities = $Self->{TicketObject}->PriorityList(
            CustomerUserID => $Self->{UserID},
            Action => $Self->{Action},
        );
        # build priority string
        my %PrioritySelected = ();
        if ($Param{PriorityID}) {
            $PrioritySelected{SelectedID} = $Param{PriorityID};
        }
        else {
            $PrioritySelected{Selected} = $Self->{Config}->{PriorityDefault} || '3 normal',
        }
        $Param{'PriorityStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%Priorities,
            Name => 'PriorityID',
            %PrioritySelected,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => {
                %Param,
            },
        );
    }

    # ticket free text
    my $Count = 0;
    foreach (1..16) {
        $Count++;
        if ($Self->{Config}->{'TicketFreeText'}->{$Count}) {
            $Self->{LayoutObject}->Block(
                Name => 'FreeText',
                Data => {
                    TicketFreeKeyField => $Param{'TicketFreeKeyField'.$Count},
                    TicketFreeTextField => $Param{'TicketFreeTextField'.$Count},
                },
            );
        }
    }
    $Count = 0;
    foreach (1..2) {
        $Count++;
        if ($Self->{Config}->{'TicketFreeTime'}->{$Count}) {
            $Self->{LayoutObject}->Block(
                Name => 'FreeTime',
                Data => {
                    TicketFreeTimeKey => $Self->{ConfigObject}->Get('TicketFreeTimeKey'.$Count),
                    TicketFreeTime => $Param{'TicketFreeTime'.$Count},
                    Count => $Count,
                },
            );
        }
    }
    # show attachments
    foreach my $DataRef (@{$Param{Attachments}}) {
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $DataRef,
        );
    }
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'CustomerTicketMessage', Data => \%Param);
}
# --
1;
