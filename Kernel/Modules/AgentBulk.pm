# --
# Kernel/Modules/AgentBulk.pm - to do bulk actions on tickets
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentBulk.pm,v 1.5 2004-04-22 13:17:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentBulk;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
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

    # check all needed objects
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{StateObject} = Kernel::System::State->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # get involved tickets
    my @TicketIDs = $Self->{ParamObject}->GetArray(Param => 'TicketIDs');
    foreach (1..30) {
      if ($Self->{ParamObject}->GetParam(Param => "TicketID$_")) {
        push (@TicketIDs, $Self->{ParamObject}->GetParam(Param => "TicketID$_"));
      }
    }
    # check needed stuff
    if (!@TicketIDs) {
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => "No TicketID is given!",
            Comment => 'You need min. one selected Ticket.',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    $Output = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Bulk Action');
    # process tickets
    foreach (@TicketIDs) {
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $_);
        # check permissions
        if (!$Self->{TicketObject}->Permission(
            Type => 'rw',
            TicketID => $_,
            UserID => $Self->{UserID})) {
            # error screen, don't show ticket
            $Output .= $Self->{LayoutObject}->Notify(
                Info => 'No access to %s!", "$Quote{"'.$Ticket{TicketNumber}.'"}',
            );
        }
        else {
            $Param{TicketIDHidden} .= "<input type='hidden' name='TicketIDs' value='$_'>\n";
            # show locked tickets
            my $LockIt = 1;
            if ($Self->{TicketObject}->LockIsTicketLocked(TicketID => $_)) {
                my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
                    TicketID => $_,
                );
                if ($OwnerID ne $Self->{UserID}) {
                    $LockIt = 0;
                    $Output .= $Self->{LayoutObject}->Notify(
                        Info => 'Ticket %s is locked for an other agent!", "$Quote{"'.$OwnerLogin.'"}',
                    );
                }
            }
            if ($LockIt) {
                # set lock
                $Self->{TicketObject}->LockSet(
                    TicketID => $_,
                    Lock => 'lock',
                    UserID => $Self->{UserID},
                );
                # set user id
                $Self->{TicketObject}->OwnerSet(
                    TicketID => $_,
                    UserID => $Self->{UserID},
	            NewUserID => $Self->{UserID},
                );
                $Output .= $Self->{LayoutObject}->Notify(
                    Info => 'Ticket %s locked.", "$Quote{"'.$Ticket{TicketNumber}.'"}',
                );
                # do some actions on tickets
                if ($Self->{Subaction} eq 'Do') {
                    # set state
                    my $StateID = $Self->{ParamObject}->GetParam(Param => 'StateID') || '';
                    if ($StateID) {
                        $Self->{TicketObject}->StateSet(
                            TicketID => $_,
                            StateID => $StateID,
                            UserID => $Self->{UserID},
                        );
                        my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                            ID => $StateID,
                        );
                        # should I set an unlock?
                        if ($StateData{TypeName} =~ /^close/i) {
                            $Self->{TicketObject}->LockSet(
                                TicketID => $_,
                                Lock => 'unlock',
                                UserID => $Self->{UserID},
                            );
                        }
                    } 
                    # set queue
                    my $QueueID = $Self->{ParamObject}->GetParam(Param => 'QueueID') || '';
                    if ($QueueID) {
                        $Self->{TicketObject}->MoveTicket(
                            QueueID => $QueueID,
                            TicketID => $_,
                            UserID => $Self->{UserID},
                        );
                    }
                    # add note
                    my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || '';
                    my $Body = $Self->{ParamObject}->GetParam(Param => 'Body') || '';
                    my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'ArticleTypeID');

                    if (($Subject || $Body) && $ArticleTypeID) {
                      my $ArticleID = $Self->{TicketObject}->ArticleCreate(
                        TicketID => $_,
                        ArticleTypeID => $ArticleTypeID,
                        SenderType => 'agent',
                        From => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
                        Subject => $Subject,
                        Body => $Body,
                        ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
                        UserID => $Self->{UserID},
                        HistoryType => 'AddNote',
                        HistoryComment => '$$Bulk',
                      );
                    }
                }
            }
        } 
    }
    if ($Self->{Subaction} eq 'Do') {
        # redirect 
        return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
    }
    else {
        $Output .= $Self->_Mask(%Param);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # build ArticleTypeID string
    my %DefaultNoteTypes = %{$Self->{ConfigObject}->Get('DefaultNoteTypes')};
    my %NoteTypes = $Self->{DBObject}->GetTableData(
        Table => 'article_type',
        Valid => 1,
        What => 'id, name'
    );
    foreach (keys %NoteTypes) {
        if (!$DefaultNoteTypes{$NoteTypes{$_}}) {
            delete $NoteTypes{$_};
        }
    }
    $Param{'NoteStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%NoteTypes, 
        Name => 'ArticleTypeID',
    );
    # build next states string
    my %NextStates = $Self->{TicketObject}->StateList(
        Type => 'DefaultNextNote',
        Action => $Self->{Action},
        UserID => $Self->{UserID},
    );
    $NextStates{''} = '-';
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%NextStates,
        Name => 'StateID',
    );
    # build move queue string
    my %MoveQueues = $Self->{TicketObject}->MoveList(
        UserID => $Self->{UserID},
        Action => $Self->{Action},
        Type => 'move_into',
    );
    $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { %MoveQueues, '' => '-' },
        Multiple => 0,
        Size => 0,
        Name => 'QueueID',
#       SelectedID => $Self->{DestQueueID},
        OnChangeSubmit => 0,
    );
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentBulk', Data => \%Param);
}   
# --
1;

1;
