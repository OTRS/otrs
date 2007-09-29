# --
# Kernel/Modules/AdminQueueAutoResponse.pm - to add/update/delete QueueAutoResponses
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminQueueAutoResponse.pm,v 1.22 2007-09-29 10:39:11 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminQueueAutoResponse;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common opjects
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my $Self   = shift;
    my %Param  = @_;
    my $Output = '';
    $Param{ID} = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
    $Param{ID} = $Self->{DBObject}->Quote( $Param{ID}, 'Integer' ) if ( $Param{ID} );

    if ( $Self->{Subaction} eq 'Change' ) {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get Type Auto Responses data
        my %TypeResponsesData = $Self->{DBObject}->GetTableData(
            Table => 'auto_response_type',
            What  => 'id, name',
        );

        # get queue data
        my %QueueData = $Self->{DBObject}->GetTableData(
            Table => 'queue',
            What  => 'id, name',
            Where => "id = $Param{ID}",
        );
        $Self->{LayoutObject}->Block(
            Name => 'Selection',
            Data => {
                Queue => $QueueData{ $Param{ID} },
                %QueueData,
                %Param,
            }
        );
        for ( keys %TypeResponsesData ) {
            my %Data = $Self->{DBObject}->GetTableData(
                Table => 'auto_response ar, auto_response_type art',
                What  => 'ar.id, ar.name',
                Where => " art.id = $_ AND ar.type_id = art.id",
            );
            my ( $SelectedID, $Name ) = $Self->{DBObject}->GetTableData(
                Table => 'auto_response ar, auto_response_type art, queue_auto_response qar',
                What  => 'ar.id, ar.name',
                Where => " art.id = $_ AND ar.type_id = art.id AND qar.queue_id = $Param{ID} "
                    . "AND qar.auto_response_id = ar.id",
            );
            $Param{DataStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
                Name         => 'IDs',
                SelectedID   => $SelectedID || '',
                Data         => \%Data,
                Size         => 3,
                PossibleNone => 1,
            );
            $Self->{LayoutObject}->Block(
                Name => 'ItemList',
                Data => {
                    Type   => $TypeResponsesData{$_},
                    TypeID => $_,
                    %Param,
                }
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminQueueAutoResponseForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }

    # queues to queue_auto_responses
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {
        $Self->{DBObject}
            ->Do( SQL => "DELETE FROM queue_auto_response WHERE queue_id = $Param{ID}", );
        my @NewIDs = $Self->{ParamObject}->GetArray( Param => 'IDs' );
        for my $NewID (@NewIDs) {
            if ($NewID) {

                # db quote
                $NewID = $Self->{DBObject}->Quote( $NewID, 'Integer' );
                my $SQL
                    = "INSERT INTO queue_auto_response (queue_id, auto_response_id, "
                    . " create_time, create_by, change_time, change_by)"
                    . " VALUES "
                    . " ($Param{ID}, $NewID, current_timestamp, $Self->{UserID}, "
                    . " current_timestamp, $Self->{UserID})";
                $Self->{DBObject}->Do( SQL => $SQL );
            }
        }
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # else ! print form
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get queue data
        my %QueueData = $Self->{DBObject}->GetTableData(
            Table => 'queue',
            What  => 'id, name',
            Valid => 1,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => { %QueueData, %Param, }
        );
        for ( sort { $QueueData{$a} cmp $QueueData{$b} } keys %QueueData ) {
            my @Data;
            my $SQL
                = "SELECT ar.name, art.name, ar.id FROM "
                . " auto_response ar, auto_response_type art, queue_auto_response qar "
                . " WHERE "
                . " ar.type_id = art.id " . " AND "
                . " ar.id = qar.auto_response_id " . " AND "
                . " qar.queue_id = $_ ";
            $Self->{DBObject}->Prepare( SQL => $SQL );
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                my %AutoResponseData;
                $AutoResponseData{Name} = $Row[0];
                $AutoResponseData{Type} = $Row[1];
                $AutoResponseData{ID}   = $Row[2];
                push( @Data, \%AutoResponseData );
            }
            $Self->{LayoutObject}->Block(
                Name => 'Item',
                Data => {
                    Queue   => $QueueData{$_},
                    QueueID => $_,
                    %QueueData,
                    %Param,
                }
            );
            for my $ResponseData (@Data) {
                $Self->{LayoutObject}->Block(
                    Name => 'ItemList',
                    Data => $ResponseData,
                );
            }
            if ( @Data == 0 ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ItemNo',
                    Data => { %Param, }
                );
            }
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminQueueAutoResponseForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}

1;
