# --
# Kernel/Modules/AgentTicketFreeText.pm - to set the ticket free text
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketFreeText.pm,v 1.6 2006-03-04 11:34:53 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketFreeText;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

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
        Type => 'freetext',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    else {
        my $AccessOk = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Self->{TicketID},
            OwnerID => $Self->{UserID},
        );
        if (!$AccessOk) {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Sorry, you need to be the owner to do this action!",
                Comment => 'Please change the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    if ($Self->{Subaction} eq 'Update') {
        # update ticket title
        my $Title = $Self->{ParamObject}->GetParam(Param => "Title");
        if (defined($Title)) {
            $Self->{TicketObject}->TicketTitleUpdate(
                Title => $Title,
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
            );
        }
        # update ticket free text
        foreach (1..16) {
            my $FreeKey = $Self->{ParamObject}->GetParam(Param => "TicketFreeKey$_");
            my $FreeValue = $Self->{ParamObject}->GetParam(Param => "TicketFreeText$_");
            if (defined($FreeKey) && defined($FreeValue)) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    Key => $FreeKey,
                    Value => $FreeValue,
                    Counter => $_,
                    TicketID => $Self->{TicketID},
                    UserID => $Self->{UserID},
                );
            }
        }
        # get free text params
        my %TicketFreeTime = ();
        foreach (1..2) {
            foreach my $Type (qw(Year Month Day Hour Minute)) {
                $TicketFreeTime{"TicketFreeTime".$_.$Type} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeTime".$_.$Type);
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
                        TicketID => $Self->{TicketID},
                        Counter => $_,
                        UserID => $Self->{UserID},
                   );
                }
            }
        }
        # print redirect
        return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
    }
    else {
        # print form
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
        # get free text config options
        my %TicketFreeText = ();
        foreach (1..16) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type => "TicketFreeKey$_",
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type => "TicketFreeText$_",
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Ticket => \%Ticket,
            Config => \%TicketFreeText,
        );
        # get free text params
        my %TicketFreeTime = ();
        foreach (1..2) {
            if ($Ticket{"TicketFreeTime".$_}) {
                ($TicketFreeTime{"TicketFreeTime".$_.'Secunde'}, $TicketFreeTime{"TicketFreeTime".$_.'Minute'}, $TicketFreeTime{"TicketFreeTime".$_.'Hour'}, $TicketFreeTime{"TicketFreeTime".$_.'Day'}, $TicketFreeTime{"TicketFreeTime".$_.'Month'},  $TicketFreeTime{"TicketFreeTime".$_.'Year'}) = $Self->{TimeObject}->SystemTime2Date(
                    SystemTime => $Self->{TimeObject}->TimeStamp2SystemTime(
                        String => $Ticket{"TicketFreeTime".$_},
                    ),
                );
            }
        }
        # free time
        my %FreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
            Ticket => \%TicketFreeTime,
        );
    # ticket free text
    my $Count = 0;
    foreach (1..16) {
        $Count++;
        if ($Self->{Config}->{'TicketFreeText'}->{$Count}) {
            $Self->{LayoutObject}->Block(
                Name => 'FreeText',
                Data => {
                    TicketFreeKeyField => $TicketFreeTextHTML{'TicketFreeKeyField'.$Count},
                    TicketFreeTextField => $TicketFreeTextHTML{'TicketFreeTextField'.$Count},
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
                    TicketFreeTime => $FreeTimeHTML{'TicketFreeTime'.$Count},
                    Count => $Count,
                },
            );
        }
    }

        # print change form
        my $Output = $Self->{LayoutObject}->Header(Value => $Ticket{TicketNumber});
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketFreeText',
            Data => {
                %Ticket,
                %TicketFreeTextHTML,
                %FreeTimeHTML,
                QueueID => $Self->{QueueID},
            },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
