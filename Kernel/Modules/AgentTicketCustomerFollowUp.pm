# --
# Kernel/Modules/AgentTicketCustomerFollowUp.pm - to handle customer messages
# if the agent is customer
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketCustomerFollowUp.pm,v 1.10.2.1 2008-07-24 10:09:13 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketCustomerFollowUp;

use strict;
use Kernel::System::SystemAddress;
use Kernel::System::Queue;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    # check needed Objects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    # needed objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{SystemAddress} = Kernel::System::SystemAddress->new(%Param);
    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;

    if ($Self->{Subaction} eq '' || !$Self->{Subaction}) {

        # if there is no ticket id!
        if (!$Self->{TicketID}) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'No TicketID!',
                Comment => 'Please contact your admin',
            );
        }
        else {
            # header
            $Output .= $Self->{LayoutObject}->Header();
            # get user lock data
            $Output .= $Self->{LayoutObject}->NavigationBar();

            my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
            # next stats
            my %Selected = ();
            my %NextStates = $Self->{TicketObject}->StateList(
                TicketID => $Self->{TicketID},
                Action => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
            if ($Param{NextStateID}) {
                $Selected{SelectedID} = $Param{NextStateID};
            }
            elsif ($Self->{Config}->{StateDefault}) {
                $Selected{Selected} = $Self->{Config}->{StateDefault};
            }
            else {
                $NextStates{''} = '-';
            }
            $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data => \%NextStates,
                Name => 'StateID',
                %Selected,
            );

            # get output back
            $Output .= $Self->{LayoutObject}->Notify(
                Info => $Self->{LayoutObject}->{LanguageObject}->Get('You are the customer user of this message - customer modus!'),
            );
            # show spell check
            if ($Self->{ConfigObject}->Get('SpellChecker') && $Self->{LayoutObject}->{BrowserJavaScriptSupport}) {
                $Self->{LayoutObject}->Block(
                    Name => 'SpellCheck',
                    Data => {},
                );
            }
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentTicketCustomerMessage',
                Data => { %Param, %Ticket },
            );

            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    elsif ($Self->{Subaction} eq 'Store') {
        # get ticket data
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $Self->{TicketID},
        );
        # get follow up option (possible or not)
        my $FollowUpPossible = $Self->{QueueObject}->GetFollowUpOption(
            QueueID => $Ticket{QueueID},
        );
        if ($FollowUpPossible =~ /(new ticket|reject)/i && $Ticket{StateType} =~ /^close/i) {
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Warning(
                Message => 'Can\'t reopen ticket, not possible in this queue!',
                Comment => 'Create a new ticket!',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Follow up!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Body');
        my $StateID = $Self->{ParamObject}->GetParam(Param => 'StateID');
        my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";
        if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID => $Self->{TicketID},
            ArticleType => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketMessage')->{ArticleType},
            SenderType => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketMessage')->{SenderType},
            From => $From,
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{UserID},
            OrigHeader => {
                From => $From,
                To => 'System',
                Subject => $Subject,
                Body => $Text,
            },
            HistoryType => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketMessage')->{HistoryType},
            HistoryComment => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketMessage')->{HistoryComment} || '%%',
        )) {
            # set state
            my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $StateID,
            );
            my $NextState = $StateData{Name} || $Self->{Config}->{StateDefault} || 'open';;
            $Self->{TicketObject}->StateSet(
                TicketID => $Self->{TicketID},
                ArticleID => $ArticleID,
                State => $NextState,
                UserID => $Self->{UserID},
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
                    UserID => $Self->{UserID},
                );
            }
            # redirect to zoom view
            return $Self->{LayoutObject}->Redirect(OP => "Action=AgentTicketZoom&TicketID=$Self->{TicketID}&ArticleID=$ArticleID");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    else {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
    }
}

1;
