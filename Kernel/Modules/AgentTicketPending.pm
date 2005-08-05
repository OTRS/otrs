# --
# Kernel/Modules/AgentTicketPending.pm - to set ticket in pending state
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketPending.pm,v 1.7 2005-08-05 18:05:02 cs Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketPending;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
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
    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    # needed objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Self->{TicketID}) {
        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "No TicketID is given!",
            Comment => 'Please contact the admin.',
        );
    }
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => 'pending',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    else {
        my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Self->{TicketID},
        );
        if ($OwnerID != $Self->{UserID}) {
            my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Sorry, the current owner is $OwnerLogin!",
                Comment => 'Please change the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    my $Tn = $Self->{TicketObject}->TicketNumberLookup(TicketID => $Self->{TicketID});
    my %GetParam = ();
    foreach (qw(Year Month Day Hour Minute Body Subject StateID NoteID TimeUnits)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
    }
    # rewrap body if exists
    if ($GetParam{Body}) {
        $GetParam{Body} =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
    }

    if ($Self->{Subaction} eq 'Store') {
        # store action
        my %Error = ();
        # check needed stuff
        foreach (qw(Year Month Day Hour Minute)) {
            if (!defined($GetParam{$_})) {
                $Error{"Date invalid"} = '* invalid';
            }
        }
        # check date
        if (!$Self->{TimeObject}->Date2SystemTime(%GetParam, Second => 0)) {
            $Error{"Date invalid"} = '* invalid';
        }
        if ($Self->{TimeObject}->Date2SystemTime(%GetParam, Second => 0) < $Self->{TimeObject}->SystemTime()) {
            $Error{"Date invalid"} = '* invalid';
        }
        # check subject
        if (!$GetParam{Subject}) {
            $Error{"Subject invalid"} = '* invalid';
        }
        # check body
        if (!$GetParam{Body}) {
            $Error{"Body invalid"} = '* invalid';
        }
        # check errors
        if (%Error) {
            # html header
            my $Output = $Self->{LayoutObject}->Header(Value => $Tn);
            # print form ...
            $Output .= $Self->_Mask(
                TicketID => $Self->{TicketID},
                TicketNumber => $Tn,
                %GetParam,
                %Error,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # add note
        if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID => $Self->{TicketID},
            ArticleTypeID => $GetParam{NoteID},
            SenderType => 'agent',
            From => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
            Subject => $GetParam{Subject},
            Body => $GetParam{Body},
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => 'AddNote',
            HistoryComment => '%%Pending',
        )) {
            # time accounting
            if ($GetParam{TimeUnits}) {
                $Self->{TicketObject}->TicketAccountTime(
                    TicketID => $Self->{TicketID},
                    ArticleID => $ArticleID,
                    TimeUnit => $GetParam{TimeUnits},
                    UserID => $Self->{UserID},
                );
            }
            # set state
            $Self->{TicketObject}->StateSet(
                UserID => $Self->{UserID},
                TicketID => $Self->{TicketID},
                ArticleID => $ArticleID,
                StateID => $GetParam{StateID},
            );
            # set pending time
            $Self->{TicketObject}->TicketPendingTimeSet(
                UserID => $Self->{UserID},
                TicketID => $Self->{TicketID},
                %GetParam,
            );
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
        }
        else {
            # error screen
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    else {
        # html header
        my $Output = $Self->{LayoutObject}->Header(Value => $Tn);
        # get lock state
        if (!$Self->{TicketObject}->LockIsTicketLocked(TicketID => $Self->{TicketID})) {
            $Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock => 'lock',
                UserID => $Self->{UserID}
            );
            if ($Self->{TicketObject}->OwnerSet(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
                NewUserID => $Self->{UserID},
            )) {
                # show lock state
                $Self->{LayoutObject}->Block(
                    Name => 'TicketLocked',
                    Data => {
                        %Param,
                        TicketID => $Self->{TicketID},
                    },
                );
            }
        }
        else {
            my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
            );
            if ($OwnerID != $Self->{UserID}) {
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, the current owner is $OwnerLogin!",
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'TicketBack',
                    Data => {
                        %Param,
                        TicketID => $Self->{TicketID},
                    },
                );
            }
        }

        # fillup vars
        if (!defined($GetParam{Body}) && $Self->{ConfigObject}->Get('Ticket::Frontend::PendingText')) {
            $GetParam{Body} = $Self->{LayoutObject}->Output(Template => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingText'));
        }
        if (!defined($GetParam{Subject}) && $Self->{ConfigObject}->Get('Ticket::Frontend::PendingSubject')) {
            $GetParam{Subject} = $Self->{LayoutObject}->Output(Template => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingSubject'));
        }
        # print form ...
        $Output .= $Self->_Mask(
            TicketID => $Self->{TicketID},
            TicketNumber => $Tn,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;

    # get next states
    my %NextStates = $Self->{TicketObject}->StateList(
        Type => 'DefaultPendingNext',
        Action => $Self->{Action},
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID},
    );
    my %SelectedState = ();
    if ($Param{StateID}) {
        $SelectedState{SelectedID} = $Param{StateID};
    }
    else {
        $SelectedState{Selected} = $Self->{ConfigObject}->Get('Ticket::Frontend::PendingState');
    }
    # get possible notes
    my %DefaultNoteTypes = %{$Self->{ConfigObject}->Get('Ticket::Frontend::NoteTypes')};
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
    # build string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%NextStates,
        Name => 'StateID',
        %SelectedState,
    );
    # build string
    $Param{'NoteTypesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%NoteTypes,
        Name => 'NoteID',
        SelectedID => $Param{NoteID},
    );
    $Param{DateString} = $Self->{LayoutObject}->BuildDateSelection(
        Format => 'DateInputFormatLong',
        DiffTime => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
        %Param,
    );
    # show time accounting box
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')) {
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnitsJs',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }
    # show spell check
    if ($Self->{ConfigObject}->Get('SpellChecker')) {
        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }
    # prepare errors!
    if ($Param{Errors}) {
        foreach (keys %{$Param{Errors}}) {
            $Param{$_} = "* ".$Self->{LayoutObject}->Ascii2Html(Text => $Param{Errors}->{$_});
        }
    }
    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketPending', Data => \%Param);
}
# --
1;
