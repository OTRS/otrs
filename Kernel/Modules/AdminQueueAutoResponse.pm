# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminQueueAutoResponse;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $DBObject    = $Kernel::OM->Get('Kernel::System::DB');
    my $Output      = '';
    $Param{ID} = $ParamObject->GetParam( Param => 'ID' ) || '';
    $Param{ID} = $DBObject->Quote( $Param{ID}, 'Integer' ) if ( $Param{ID} );
    $Param{Action} = $ParamObject->GetParam( Param => 'Action' )
        || 'AdminQueueAutoResponse';

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $QueueObject        = $Kernel::OM->Get('Kernel::System::Queue');
    my $AutoResponseObject = $Kernel::OM->Get('Kernel::System::AutoResponse');

    if ( $Self->{Subaction} eq 'Change' ) {
        $Output .= $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # get Type Auto Responses data
        my %TypeResponsesData = $AutoResponseObject->AutoResponseTypeList();

        # get queue data
        my %QueueData = $QueueObject->QueueGet(
            ID => $Param{ID},
        );

        $LayoutObject->Block( Name => 'Overview' );
        $LayoutObject->Block( Name => 'ActionList' );
        $LayoutObject->Block( Name => 'ActionOverview' );

        $LayoutObject->Block(
            Name => 'Selection',
            Data => {
                Queue => $QueueData{Name},
                %QueueData,
                %Param,
                ActionHome => 'AdminQueue',
            },
        );
        for my $TypeID ( sort keys %TypeResponsesData ) {
            my %Data = $DBObject->GetTableData(
                Table => 'auto_response ar, auto_response_type art',
                What  => 'ar.id, ar.name',
                Where => " art.id = $TypeID AND ar.type_id = art.id "
                    . "AND ar.valid_id IN ( ${\(join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet())} )",
            );
            my ( $SelectedID, $Name ) = $DBObject->GetTableData(
                Table => 'auto_response ar, auto_response_type art, queue_auto_response qar',
                What  => 'ar.id, ar.name',
                Where => " art.id = $TypeID AND ar.type_id = art.id AND qar.queue_id = $Param{ID} "
                    . "AND qar.auto_response_id = ar.id",
            );
            $Param{DataStrg} = $LayoutObject->BuildSelection(
                Name         => "IDs_$TypeID",
                SelectedID   => $SelectedID || '',
                Data         => \%Data,
                Size         => 1,
                PossibleNone => 1,
                Class        => 'Modernize W50pc',
            );
            $LayoutObject->Block(
                Name => 'ChangeItemList',
                Data => {
                    Type   => $TypeResponsesData{$TypeID},
                    TypeID => $TypeID,
                    %Param,
                },
            );
        }
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminQueueAutoResponse',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
    }

    # queues to queue_auto_responses
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my @NewIDs = ();

        # get Type Auto Responses data
        my %TypeResponsesData = $AutoResponseObject->AutoResponseTypeList();

        # Set Autoresponses IDs for this queue.
        for my $TypeID ( sort keys %TypeResponsesData ) {
            push( @NewIDs, $ParamObject->GetParam( Param => "IDs_$TypeID" ) );
        }

        $AutoResponseObject->AutoResponseQueue(
            QueueID         => $Param{ID},
            AutoResponseIDs => \@NewIDs,
            UserID          => $Self->{UserID},
        );
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # else ! print form
    else {
        $Output .= $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # get queue data
        my %QueueData = $QueueObject->QueueList( Valid => 1 );

        $LayoutObject->Block(
            Name => 'Overview',
            Data => { %QueueData, %Param, }
        );

        $LayoutObject->Block( Name => 'FilterQueues' );
        $LayoutObject->Block( Name => 'FilterAutoResponses' );
        $LayoutObject->Block( Name => 'OverviewResult' );

        # if there are any queues, they are shown
        if (%QueueData) {
            for ( sort { $QueueData{$a} cmp $QueueData{$b} } keys %QueueData ) {

                $LayoutObject->Block(
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
            $LayoutObject->Block(
                Name => 'NoQueuesFoundMsg',
                Data => {},
            );
        }

        # Get Auto Response data.
        my @ResponseData;
        my $SQL = "SELECT ar.name, art.name, ar.id FROM "
            . " auto_response ar, auto_response_type art, valid "
            . " WHERE ar.type_id = art.id "
            . " AND ar.valid_id = valid.id AND valid.name = 'valid'"
            . " ORDER BY ar.name ASC"
            ;
        $DBObject->Prepare( SQL => $SQL );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            my %AutoResponseData;
            $AutoResponseData{Name} = $Row[0];
            $AutoResponseData{Type} = $Row[1];
            $AutoResponseData{ID}   = $Row[2];
            push( @ResponseData, \%AutoResponseData );
        }

        # if there are any auto responses, they are shown
        if (@ResponseData) {
            for my $ResponseDataItem (@ResponseData) {
                $LayoutObject->Block(
                    Name => 'ItemList',
                    Data => $ResponseDataItem,
                );
            }
        }

        # otherwise a no data found msg is displayed
        else {
            $LayoutObject->Block(
                Name => 'NoAutoResponsesFoundMsg',
                Data => {},
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminQueueAutoResponse',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
    }
    return $Output;
}

1;
