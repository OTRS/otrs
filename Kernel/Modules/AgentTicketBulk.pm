# --
# Kernel/Modules/AgentTicketBulk.pm - to do bulk actions on tickets
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentTicketBulk.pm,v 1.10 2006-09-27 16:50:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketBulk;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    $Self->{StateObject} = Kernel::System::State->new(%Param);

    return $Self;
}

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
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "No TicketID is given!",
            Comment => 'You need min. one selected Ticket!',
        );
    }
    $Output = $Self->{LayoutObject}->Header();
    # process tickets
    foreach my $TicketID (@TicketIDs) {
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $TicketID);
        # check permissions
        if (!$Self->{TicketObject}->Permission(
            Type => 'rw',
            TicketID => $TicketID,
            UserID => $Self->{UserID})) {
            # error screen, don't show ticket
            $Output .= $Self->{LayoutObject}->Notify(
                Info => 'No access to %s!", "$Quote{"'.$Ticket{TicketNumber}.'"}',
            );
        }
        else {
            $Param{TicketIDHidden} .= "<input type='hidden' name='TicketIDs' value='$TicketID'>\n";
            # show locked tickets
            my $LockIt = 1;
            if ($Self->{TicketObject}->LockIsTicketLocked(TicketID => $TicketID)) {
                my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                    TicketID => $TicketID,
                    OwnerID => $Self->{UserID},
                );
                if (!$AccessOk) {
                    $LockIt = 0;
                    $Output .= $Self->{LayoutObject}->Notify(
                        Info => 'Ticket %s is locked for an other agent!", "$Quote{"'.$Ticket{TicketNumber}.'"}',
                    );
                }
            }
            if ($LockIt) {
                # set lock
                $Self->{TicketObject}->LockSet(
                    TicketID => $TicketID,
                    Lock => 'lock',
                    UserID => $Self->{UserID},
                );
                # set user id
                $Self->{TicketObject}->OwnerSet(
                    TicketID => $TicketID,
                    UserID => $Self->{UserID},
                    NewUserID => $Self->{UserID},
                );
                $Output .= $Self->{LayoutObject}->Notify(
                    Data => $Ticket{TicketNumber}.': $Text{"Ticket locked!"}',
                );
                # do some actions on tickets
                if ($Self->{Subaction} eq 'Do') {
                    # set queue
                    my $QueueID = $Self->{ParamObject}->GetParam(Param => 'QueueID') || '';
                    my $Queue = $Self->{ParamObject}->GetParam(Param => 'Queue') || '';
                    if ($QueueID || $Queue) {
                        $Self->{TicketObject}->MoveTicket(
                            QueueID => $QueueID,
                            Queue => $Queue,
                            TicketID => $TicketID,
                            UserID => $Self->{UserID},
                        );
                    }
                    # add note
                    my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || '';
                    my $Body = $Self->{ParamObject}->GetParam(Param => 'Body') || '';
                    my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'ArticleTypeID') || '';
                    my $ArticleType = $Self->{ParamObject}->GetParam(Param => 'ArticleType') || '';

                    if ($Subject && $Body && ($ArticleTypeID||$ArticleType)) {
                        my $ArticleID = $Self->{TicketObject}->ArticleCreate(
                            TicketID => $TicketID,
                            ArticleTypeID => $ArticleTypeID,
                            ArticleType => $ArticleType,
                            SenderType => 'agent',
                            From => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
                            Subject => $Subject,
                            Body => $Body,
                            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
                            UserID => $Self->{UserID},
                            HistoryType => 'AddNote',
                            HistoryComment => '%%Bulk',
                        );
                    }
                    # set state
                    my $StateID = $Self->{ParamObject}->GetParam(Param => 'StateID') || '';
                    my $State = $Self->{ParamObject}->GetParam(Param => 'State') || '';
                    if ($StateID || $State) {
                        $Self->{TicketObject}->StateSet(
                            TicketID => $TicketID,
                            StateID => $StateID,
                            State => $State,
                            UserID => $Self->{UserID},
                        );
                        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $TicketID);
                        my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                            ID => $Ticket{StateID},
                        );
                        # should I set an unlock?
                        if ($Ticket{StateType} =~ /^close/i) {
                            $Self->{TicketObject}->LockSet(
                                TicketID => $TicketID,
                                Lock => 'unlock',
                                UserID => $Self->{UserID},
                            );
                        }
                    }
                    # Should I unlock tickets at user request?
                    if ($Self->{ParamObject}->GetParam(Param => 'Unlock')) {
                        $Self->{TicketObject}->LockSet(
                            TicketID => $TicketID,
                            Lock => 'unlock',
                            UserID => $Self->{UserID},
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

sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # build ArticleTypeID string
    my %DefaultNoteTypes = %{$Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketNote')->{ArticleTypes}};
    my %NoteTypes = $Self->{DBObject}->GetTableData(
        Table => 'article_type',
        Valid => 1,
        What => 'id, name',
    );
    foreach (keys %NoteTypes) {
        if (!$DefaultNoteTypes{$NoteTypes{$_}}) {
            delete $NoteTypes{$_};
        }
    }
    $Param{'NoteStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%NoteTypes,
        Name => 'ArticleTypeID',
        Selected => $Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketNote')->{ArticleTypeDefault},
    );
    # build next states string
    my %NextStates = $Self->{StateObject}->StateList(
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
    $Param{'UnlockYesNoOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'Unlock',
        SelectedID => 1,
    );
    # show spell check
    if ($Self->{ConfigObject}->Get('SpellChecker') && $Self->{LayoutObject}->{BrowserJavaScriptSupport}) {
        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketBulk', Data => \%Param);
}

1;
