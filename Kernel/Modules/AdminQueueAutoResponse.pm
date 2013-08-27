# --
# Kernel/Modules/AdminQueueAutoResponse.pm - to add/update/delete QueueAutoResponses
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminQueueAutoResponse;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

use Kernel::System::AutoResponse;
use Kernel::System::Queue;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create extra needed objects
    $Self->{ValidObject}        = Kernel::System::Valid->new(%Param);
    $Self->{AutoResponseObject} = Kernel::System::AutoResponse->new(%Param);
    $Self->{QueueObject}        = Kernel::System::Queue->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    $Param{ID} = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
    $Param{ID} = $Self->{DBObject}->Quote( $Param{ID}, 'Integer' ) if ( $Param{ID} );
    $Param{Action} = $Self->{ParamObject}->GetParam( Param => 'Action' )
        || 'AdminQueueAutoResponse';

    if ( $Self->{Subaction} eq 'Change' ) {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get Type Auto Responses data
        my %TypeResponsesData = $Self->{AutoResponseObject}->AutoResponseTypeList();

        # get queue data
        my %QueueData = $Self->{QueueObject}->QueueGet(
            ID => $Param{ID},
        );

        $Self->{LayoutObject}->Block( Name => 'Overview' );
        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

        $Self->{LayoutObject}->Block(
            Name => 'Selection',
            Data => {
                Queue => $QueueData{Name},
                %QueueData,
                %Param,
                ActionHome => 'AdminQueue',
            },
        );
        for my $TypeID ( sort keys %TypeResponsesData ) {
            my %Data = $Self->{DBObject}->GetTableData(
                Table => 'auto_response ar, auto_response_type art',
                What  => 'ar.id, ar.name',
                Where => " art.id = $TypeID AND ar.type_id = art.id "
                    . "AND ar.valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )",
            );
            my ( $SelectedID, $Name ) = $Self->{DBObject}->GetTableData(
                Table => 'auto_response ar, auto_response_type art, queue_auto_response qar',
                What  => 'ar.id, ar.name',
                Where => " art.id = $TypeID AND ar.type_id = art.id AND qar.queue_id = $Param{ID} "
                    . "AND qar.auto_response_id = ar.id",
            );
            $Param{DataStrg} = $Self->{LayoutObject}->BuildSelection(
                Name         => "IDs_$TypeID",
                SelectedID   => $SelectedID || '',
                Data         => \%Data,
                Size         => 1,
                PossibleNone => 1,
                Class        => 'W50pc',
            );
            $Self->{LayoutObject}->Block(
                Name => 'ChangeItemList',
                Data => {
                    Type   => $TypeResponsesData{$TypeID},
                    TypeID => $TypeID,
                    %Param,
                },
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminQueueAutoResponse',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }

    # queues to queue_auto_responses
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my @NewIDs = ();

        # get Type Auto Responses data
        my %TypeResponsesData = $Self->{AutoResponseObject}->AutoResponseTypeList();

        # Set Autoresponses IDs for this queue.
        for my $TypeID ( sort keys %TypeResponsesData ) {
            push( @NewIDs, $Self->{ParamObject}->GetParam( Param => "IDs_$TypeID" ) );
        }

        $Self->{AutoResponseObject}->AutoResponseQueue(
            QueueID         => $Param{ID},
            AutoResponseIDs => \@NewIDs,
            UserID          => $Self->{UserID},
        );
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # else ! print form
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get queue data
        my %QueueData = $Self->{QueueObject}->QueueList( Valid => 1 );

        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => { %QueueData, %Param, }
        );

        $Self->{LayoutObject}->Block( Name => 'FilterQueues' );
        $Self->{LayoutObject}->Block( Name => 'FilterAutoResponses' );
        $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

        # if there are any queues, they are shown
        if (%QueueData) {
            for ( sort { $QueueData{$a} cmp $QueueData{$b} } keys %QueueData ) {

                $Self->{LayoutObject}->Block(
                    Name => 'Item',
                    Data => {
                        Queue   => $QueueData{$_},
                        QueueID => $_,
                        %QueueData,
                        %Param,
                    },
                );
            }
        }

        # otherwise a no data found msg is displayed
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoQueuesFoundMsg',
                Data => {},
            );
        }

        # Get Auto Response data.
        my @ResponseData;
        my $SQL
            = "SELECT ar.name, art.name, ar.id FROM "
            . " auto_response ar, auto_response_type art, valid "
            . " WHERE ar.type_id = art.id "
            . " AND ar.valid_id = valid.id AND valid.name = 'valid'"
            . " ORDER BY ar.name ASC"
            ;
        $Self->{DBObject}->Prepare( SQL => $SQL );

        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            my %AutoResponseData;
            $AutoResponseData{Name} = $Row[0];
            $AutoResponseData{Type} = $Row[1];
            $AutoResponseData{ID}   = $Row[2];
            push( @ResponseData, \%AutoResponseData );
        }

        # if there are any auto responses, they are shown
        if (@ResponseData) {
            for my $ResponseDataItem (@ResponseData) {
                $Self->{LayoutObject}->Block(
                    Name => 'ItemList',
                    Data => $ResponseDataItem,
                );
            }
        }

        # otherwise a no data found msg is displayed
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoAutoResponsesFoundMsg',
                Data => {},
            );
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminQueueAutoResponse',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}

1;
