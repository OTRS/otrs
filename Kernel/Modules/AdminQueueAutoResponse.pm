# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminQueueAutoResponse;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

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
    my $Output      = '';
    $Param{ID}     = $ParamObject->GetParam( Param => 'ID' ) || '';
    $Param{Action} = $ParamObject->GetParam( Param => 'Action' )
        || 'AdminQueueAutoResponse';
    $Param{Filter} = $ParamObject->GetParam( Param => 'Filter' ) || '';

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

        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                Subaction => $Self->{Subaction},
                QueueName => $QueueData{Name},
            },
        );
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

            # get all valid Auto Responses data for appropriate Auto Responses type
            my %AutoResponseListByType = $AutoResponseObject->AutoResponseList(
                TypeID => $TypeID,
            );

            # get selected Auto Responses for appropriate Auto Responses type and Queue
            my %AutoResponseData = $AutoResponseObject->AutoResponseGetByTypeQueueID(
                QueueID => $Param{ID},
                Type    => $TypeResponsesData{$TypeID},
            );

            $Param{DataStrg} = $LayoutObject->BuildSelection(
                Name         => "IDs_$TypeID",
                SelectedID   => $AutoResponseData{AutoResponseID} || '',
                Data         => \%AutoResponseListByType,
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

        # set Auto Responses IDs for this queue.
        for my $TypeID ( sort keys %TypeResponsesData ) {
            push( @NewIDs, $ParamObject->GetParam( Param => "IDs_$TypeID" ) );
        }

        $AutoResponseObject->AutoResponseQueue(
            QueueID         => $Param{ID},
            AutoResponseIDs => \@NewIDs,
            UserID          => $Self->{UserID},
        );

       # if the user would like to continue editing the queue - auto response relation, just redirect to the edit screen
       # otherwise return to overview
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Subaction=Change;ID=$Param{ID}" );
        }
        else {
            return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
        }
    }

    # else ! print form
    else {
        $Output .= $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # get queue data
        my %QueueData;
        my $QueueHeader;

        # filter queues without auto responses
        if ( $Param{Filter} eq 'QueuesWithoutAutoResponses' ) {

            %QueueData = $AutoResponseObject->AutoResponseWithoutQueue();

            # use appropriate header
            $QueueHeader = Translatable('Queues ( without auto responses )');

        }
        else {
            %QueueData   = $QueueObject->QueueList( Valid => 1 );
            $QueueHeader = Translatable('Queues');
        }

        $LayoutObject->Block(
            Name => 'Overview',
            Data => { %QueueData, %Param, }
        );

        $LayoutObject->Block( Name => 'FilterQueues' );
        $LayoutObject->Block( Name => 'FilterAutoResponses' );
        $LayoutObject->Block( Name => 'ActionList' );

        if ( $Param{Filter} eq 'QueuesWithoutAutoResponses' ) {
            $LayoutObject->Block( Name => 'ShowAllQueues' );
        }
        else {
            $LayoutObject->Block( Name => 'QueuesWithoutAutoResponses' );
        }

        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => {
                QueueHeader => $QueueHeader,
            },
        );

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

        # otherwise a no data found message is displayed
        else {
            $LayoutObject->Block(
                Name => 'NoQueuesFoundMsg',
                Data => {},
            );
        }

        # get valid Auto Response IDs
        my %AutoResponseList = $AutoResponseObject->AutoResponseList();

        # if there are any auto responses, they are shown
        if ( keys %AutoResponseList ) {
            for my $AutoResponseID ( sort keys %AutoResponseList ) {

                my %Data = $AutoResponseObject->AutoResponseGet(
                    ID => $AutoResponseID,
                );

                my %ResponseDataItem = (
                    ID   => $Data{ID},
                    Type => $Data{Type},
                    Name => $Data{Name},
                );

                $LayoutObject->Block(
                    Name => 'ItemList',
                    Data => \%ResponseDataItem,
                );
            }
        }

        # otherwise a no data found message is displayed
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
