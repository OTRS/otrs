# --
# Kernel/Output/HTML/CustomerNewTicketQueueSelectionGeneric.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CustomerNewTicketQueueSelectionGeneric.pm,v 1.5 2007-10-02 10:43:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::CustomerNewTicketQueueSelectionGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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

    my %NewTos = ();
    if ( $Self->{ConfigObject}->{CustomerPanelOwnSelection} ) {
        for ( keys %{ $Self->{ConfigObject}->{CustomerPanelOwnSelection} } ) {
            my $Value = $Self->{ConfigObject}->{CustomerPanelOwnSelection}->{$_};
            if ( $_ =~ /^\d+$/ ) {
                $NewTos{$_} = $Value;
            }
            else {
                if ( $Self->{QueueObject}->QueueLookup( Queue => $_ ) ) {
                    $NewTos{ $Self->{QueueObject}->QueueLookup( Queue => $_ ) } = $Value;
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
        if ( $Self->{ConfigObject}->Get('CustomerPanelSelectionType') eq 'Queue' ) {
            %Tos = $Self->{TicketObject}->MoveList(
                CustomerUserID => $Param{Env}->{UserID},
                Type           => 'rw',
                Action         => $Param{Env}->{Action},
            );
        }
        else {
            my %Queues = $Self->{TicketObject}->MoveList(
                CustomerUserID => $Param{Env}->{UserID},
                Type           => 'rw',
                Action         => $Param{Env}->{Action},
            );
            my %SystemTos = $Self->{DBObject}->GetTableData(
                Table => 'system_address',
                What  => 'queue_id, id',
                Valid => 1,
                Clamp => 1,
            );
            for ( keys %Queues ) {
                if ( $SystemTos{$_} ) {
                    $Tos{$_} = $Queues{$_};
                }
            }
        }
        %NewTos = %Tos;

        # build selection string
        for ( keys %NewTos ) {
            my %QueueData = $Self->{QueueObject}->QueueGet( ID => $_ );
            my $Srting = $Self->{ConfigObject}->Get('CustomerPanelSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $Srting =~ s/<Queue>/$QueueData{Name}/g;
            $Srting =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ( $Self->{ConfigObject}->Get('CustomerPanelSelectionType') ne 'Queue' ) {
                my %SystemAddressData
                    = $Self->{SystemAddress}->SystemAddressGet( ID => $QueueData{SystemAddressID} );
                $Srting =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $Srting =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewTos{$_} = $Srting;
        }
    }
    return (%NewTos);
}

1;
