# --
# Kernel/Modules/AdminQueueResponses.pm - to manage queue <-> responses assignments
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminQueueResponses;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::StandardResponse;

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

    $Self->{QueueObject}            = Kernel::System::Queue->new(%Param);
    $Self->{StandardResponseObject} = Kernel::System::StandardResponse->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # response <-> queues 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Response' ) {

        # get response data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %StandardResponseData
            = $Self->{StandardResponseObject}->StandardResponseGet( ID => $ID );

        # get queues
        my %QueueData = $Self->{QueueObject}->QueueList( Valid => 1 );

        # get assigned queues
        my %Member = $Self->{QueueObject}->GetStandardResponses(
            StandardResponseID => $ID,
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%QueueData,
            ID       => $StandardResponseData{ID},
            Name     => $StandardResponseData{Name},
            Type     => 'Response',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # responses <-> Queue n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Queue' ) {

        # get queue data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %QueueData = $Self->{QueueObject}->QueueGet( ID => $ID );

        # get responses
        my %StandardResponseData
            = $Self->{StandardResponseObject}->StandardResponseList( Valid => 1 );

        # get assigned responses
        my %Member = $Self->{QueueObject}->GetStandardResponses(
            QueueID => $ID,
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StandardResponseData,
            ID       => $QueueData{QueueID},
            Name     => $QueueData{Name},
            Type     => 'Queue',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add responses to queue
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeQueue' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get new queues
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'Queue' );

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # update db
        $Self->{DBObject}->Do(
            SQL  => 'DELETE FROM queue_standard_response WHERE queue_id = ?',
            Bind => [ \$ID ],
        );
        for my $NewID (@IDs) {
            next if !$NewID;
            $Self->{DBObject}->Do(
                SQL => 'INSERT INTO queue_standard_response (queue_id, standard_response_id, '
                    . 'create_time, create_by, change_time, change_by) VALUES '
                    . ' (?, ?, current_timestamp, ?, current_timestamp, ?)',
                Bind => [ \$ID, \$NewID, \$Self->{UserID}, \$Self->{UserID} ],
            );
        }
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # add queues to response
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeResponse' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get new queues
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'Response' );

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # update db
        $Self->{DBObject}->Do(
            SQL  => 'DELETE FROM queue_standard_response WHERE standard_response_id = ?',
            Bind => [ \$ID ],
        );
        for my $NewID (@IDs) {
            next if !$NewID;
            $Self->{DBObject}->Do(
                SQL => 'INSERT INTO queue_standard_response (queue_id, standard_response_id, '
                    . 'create_time, create_by, change_time, change_by) VALUES '
                    . ' (?, ?, current_timestamp, ?, current_timestamp, ?)',
                Bind => [ \$NewID, \$ID, \$Self->{UserID}, \$Self->{UserID} ],
            );
        }

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->_Overview();
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my %Data   = %{ $Param{Data} };
    my $Type   = $Param{Type} || 'Response';
    my $NeType = $Type eq 'Queue' ? 'Response' : 'Queue';

    my %VisibleType = ( Response => 'Response', Queue => 'Queue', );

    my $MyType = $VisibleType{$Type};

    $Self->{LayoutObject}->Block( Name => 'Overview' );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );
    $Self->{LayoutObject}->Block( Name => 'Filter' );

    #fixed link
    my $QueueTag;

    $QueueTag = $Type eq 'Queue' ? 'Queue' : '';

    $Self->{LayoutObject}->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome    => 'Admin' . $Type,
            NeType        => $NeType,
            VisibleType   => $VisibleType{$Type},
            VisibleNeType => $VisibleType{$NeType},
            Queue         => $QueueTag,

        },
    );

    $Self->{LayoutObject}->Block( Name => "ChangeHeader$VisibleType{$NeType}" );

    $Self->{LayoutObject}->Block(
        Name => 'ChangeHeader',
        Data => {
            %Param,
            Type          => $Type,
            NeType        => $NeType,
            VisibleType   => $VisibleType{$Type},
            VisibleNeType => $VisibleType{$NeType},
        },
    );

    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        my $Selected = $Param{Selected}->{$ID} ? ' checked="checked"' : '';

        $QueueTag = $Type ne 'Queue' ? 'Queue' : '';

        $Self->{LayoutObject}->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                Name          => $Param{Data}->{$ID},
                NeType        => $NeType,
                Type          => $Type,
                ID            => $ID,
                Selected      => $Selected,
                VisibleType   => $VisibleType{$Type},
                VisibleNeType => $VisibleType{$NeType},
                Queue         => $QueueTag,
            },
        );
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminQueueResponses',
        Data         => \%Param,
        VisibleType  => $MyType,

    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {},
    );

    # no actions in action list
    #    $Self->{LayoutObject}->Block(Name=>'ActionList');
    $Self->{LayoutObject}->Block( Name => 'FilterResponse' );
    $Self->{LayoutObject}->Block( Name => 'FilterQueue' );
    $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

    # get std response list
    my %StandardResponseData = $Self->{StandardResponseObject}->StandardResponseList( Valid => 1 );

    # if there are results to show
    if (%StandardResponseData) {
        for my $StandardResponseID (
            sort { uc( $StandardResponseData{$a} ) cmp uc( $StandardResponseData{$b} ) }
            keys %StandardResponseData
            )
        {

            # set output class
            $Self->{LayoutObject}->Block(
                Name => 'List1n',
                Data => {
                    Name      => $StandardResponseData{$StandardResponseID},
                    Subaction => 'Response',
                    ID        => $StandardResponseID,
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoResponsesFoundMsg',
            Data => {},
        );
    }

    # get queue data
    my %QueueData = $Self->{QueueObject}->QueueList( Valid => 1 );

    # if there are results to show
    if (%QueueData) {
        for my $QueueID ( sort { uc( $QueueData{$a} ) cmp uc( $QueueData{$b} ) } keys %QueueData ) {

            # set output class
            $Self->{LayoutObject}->Block(
                Name => 'Listn1',
                Data => {
                    Name      => $QueueData{$QueueID},
                    Subaction => 'Queue',
                    ID        => $QueueID,
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoQueuesFoundMsg',
            Data => {},
        );
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminQueueResponses',
        Data         => \%Param,
    );
}

1;
