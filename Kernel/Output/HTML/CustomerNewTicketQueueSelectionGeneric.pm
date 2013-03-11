# --
# Kernel/Output/HTML/CustomerNewTicketQueueSelectionGeneric.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::CustomerNewTicketQueueSelectionGeneric;

use strict;
use warnings;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject ParamObject QueueObject SystemAddress)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check if own selection is configured
    my %NewTos;
    if ( $Self->{ConfigObject}->{CustomerPanelOwnSelection} ) {
        for my $Queue ( sort keys %{ $Self->{ConfigObject}->{CustomerPanelOwnSelection} } ) {
            my $Value = $Self->{ConfigObject}->{CustomerPanelOwnSelection}->{$Queue};
            if ( $Queue =~ /^\d+$/ ) {
                $NewTos{$Queue} = $Value;
            }
            else {
                if ( $Self->{QueueObject}->QueueLookup( Queue => $Queue ) ) {
                    $NewTos{ $Self->{QueueObject}->QueueLookup( Queue => $Queue ) } = $Value;
                }
                else {
                    $NewTos{$Queue} = $Value;
                }
            }
        }

        # check create permissions
        my %Queues = $Self->{TicketObject}->MoveList(
            %{ $Param{ACLParams} },
            CustomerUserID => $Param{Env}->{UserID},
            Type           => 'create',
            Action         => $Param{Env}->{Action},
        );
        for my $QueueID ( sort keys %NewTos ) {
            if ( !$Queues{$QueueID} ) {
                delete $NewTos{$QueueID};
            }
        }
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Tos;
        if ( $Self->{ConfigObject}->Get('CustomerPanelSelectionType') eq 'Queue' ) {
            %Tos = $Self->{TicketObject}->MoveList(
                %{ $Param{ACLParams} },
                CustomerUserID => $Param{Env}->{UserID},
                Type           => 'create',
                Action         => $Param{Env}->{Action},
            );
        }
        else {
            my %Queues = $Self->{TicketObject}->MoveList(
                %{ $Param{ACLParams} },
                CustomerUserID => $Param{Env}->{UserID},
                Type           => 'create',
                Action         => $Param{Env}->{Action},
            );
            my %SystemTos = $Self->{DBObject}->GetTableData(
                Table => 'system_address',
                What  => 'queue_id, id',
                Valid => 1,
                Clamp => 1,
            );
            for my $QueueID ( sort keys %Queues ) {
                if ( $SystemTos{$QueueID} ) {
                    $Tos{$QueueID} = $Queues{$QueueID};
                }
            }
        }
        %NewTos = %Tos;

        # build selection string
        for my $QueueID ( sort keys %NewTos ) {
            my %QueueData = $Self->{QueueObject}->QueueGet( ID => $QueueID );
            my $String = $Self->{ConfigObject}->Get('CustomerPanelSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $String =~ s/<Queue>/$QueueData{Name}/g;
            $String =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ( $Self->{ConfigObject}->Get('CustomerPanelSelectionType') ne 'Queue' ) {
                my %SystemAddressData
                    = $Self->{SystemAddress}->SystemAddressGet( ID => $QueueData{SystemAddressID} );
                $String =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $String =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewTos{$QueueID} = $String;
        }
    }
    return %NewTos;
}

1;
