# --
# Kernel/Output/HTML/CustomerNewTicketQueueSelectionGeneric.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CustomerNewTicketQueueSelectionGeneric.pm,v 1.3 2007-07-31 14:03:32 bb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::CustomerNewTicketQueueSelectionGeneric;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject ParamObject QueueObject SystemAddress)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;

    my %NewTos = ();
    if ($Self->{ConfigObject}->{CustomerPanelOwnSelection}) {
        foreach (keys %{$Self->{ConfigObject}->{CustomerPanelOwnSelection}}) {
            my $Value = $Self->{ConfigObject}->{CustomerPanelOwnSelection}->{$_};
            if ($_ =~ /^\d+$/) {
                $NewTos{$_} = $Value;
            }
            else {
                if ($Self->{QueueObject}->QueueLookup(Queue => $_)) {
                    $NewTos{$Self->{QueueObject}->QueueLookup(Queue => $_)} = $Value;
                }
                else {
                    $NewTos{$_} = $Value;
                }
            }
        }
    }
    else {
        # SelectionType Queue or SystemAddress?
        my %Tos = ();
        if ($Self->{ConfigObject}->Get('CustomerPanelSelectionType') eq 'Queue') {
            %Tos = $Self->{TicketObject}->MoveList(
                CustomerUserID => $Param{Env}->{UserID},
                Type => 'rw',
                Action => $Param{Env}->{Action},
            );
        }
        else {
            my %Queues = $Self->{TicketObject}->MoveList(
                CustomerUserID => $Param{Env}->{UserID},
                Type => 'rw',
                Action => $Param{Env}->{Action},
            );
            my %SystemTos = $Self->{DBObject}->GetTableData(
                Table => 'system_address',
                What => 'queue_id, id',
                Valid => 1,
                Clamp => 1,
            );
            foreach (keys %Queues) {
                if ($SystemTos{$_}) {
                    $Tos{$_} = $Queues{$_};
                }
            }
        }
        %NewTos = %Tos;
        # build selection string
        foreach (keys %NewTos) {
            my %QueueData = $Self->{QueueObject}->QueueGet(ID => $_);
            my $Srting = $Self->{ConfigObject}->Get('CustomerPanelSelectionString') || '<Realname> <<Email>> - Queue: <Queue>';
            $Srting =~ s/<Queue>/$QueueData{Name}/g;
            $Srting =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ($Self->{ConfigObject}->Get('CustomerPanelSelectionType') ne 'Queue') {
                my %SystemAddressData = $Self->{SystemAddress}->SystemAddressGet(ID => $QueueData{SystemAddressID});
                $Srting =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $Srting =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewTos{$_} = $Srting;
        }
    }
    return (%NewTos);
}

1;
