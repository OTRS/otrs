# --
# Kernel/Modules/AdminResponseAttachment.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminResponseAttachment;

use strict;
use warnings;

use Kernel::System::StdAttachment;
use Kernel::System::StandardResponse;

use vars qw($VERSION);

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

    # lib object
    $Self->{StandardResponseObject} = Kernel::System::StandardResponse->new(%Param);
    $Self->{StdAttachmentObject}    = Kernel::System::StdAttachment->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # response <-> attachment 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Response' ) {

        # get response data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %StandardResponseData = $Self->{StandardResponseObject}->StandardResponseGet(
            ID => $ID,
        );

        # get attachment data
        my %StdAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentList( Valid => 1 );

        # get role member
        my %Member = $Self->{DBObject}->GetTableData(
            Table => 'standard_response_attachment',
            What  => 'standard_attachment_id, standard_response_id',
            Where => "standard_response_id = $ID",
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StdAttachmentData,
            ID       => $StandardResponseData{ID},
            Name     => $StandardResponseData{Name},
            Type     => 'Response',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # attachment <-> response n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Attachment' ) {

        # get group data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %StdAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentGet( ID => $ID );

        # get user list
        my %StandardResponseData
            = $Self->{StandardResponseObject}->StandardResponseList( Valid => 1 );

        # get role member
        my %Member = $Self->{DBObject}->GetTableData(
            Table => 'standard_response_attachment',
            What  => 'standard_response_id, standard_attachment_id',
            Where => "standard_attachment_id = $ID"
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StandardResponseData,
            ID       => $StdAttachmentData{ID},
            Name     => $StdAttachmentData{Name},
            Type     => 'Attachment',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add user to groups
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAttachment' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get new role member
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'Attachment' );

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get user list
        my %StandardResponseData
            = $Self->{StandardResponseObject}->StandardResponseList( Valid => 1 );
        for my $StandardResponseID ( sort keys %StandardResponseData ) {
            my $Active = 0;
            for my $StdAttachmentID (@IDs) {
                next if $StdAttachmentID ne $StandardResponseID;
                $Active = 1;
                last;
            }

            $Self->{DBObject}->Do(
                SQL  => 'DELETE FROM standard_response_attachment WHERE standard_attachment_id = ?',
                Bind => [ \$ID ],
            );
            for my $NewID (@IDs) {
                $Self->{DBObject}->Do(
                    SQL => 'INSERT INTO standard_response_attachment (standard_attachment_id, '
                        . 'standard_response_id, create_time, create_by, change_time, change_by)'
                        . ' VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
                    Bind => [ \$ID, \$NewID, \$Self->{UserID}, \$Self->{UserID} ],
                );
            }
        }

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # groups to user
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeResponse' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get new role member
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'Response' );

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        $Self->{StdAttachmentObject}->StdAttachmentSetResponses(
            AttachmentIDsRef => \@IDs,
            ID               => $ID,
            UserID           => $Self->{UserID},
        );

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
    my $NeType = $Type eq 'Attachment' ? 'Response' : 'Attachment';

    my %VisibleType = ( Response => 'Response', Attachment => 'Attachment', );

    $Self->{LayoutObject}->Block( Name => 'Overview' );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    $Self->{LayoutObject}->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome    => 'Admin' . $Type,
            NeType        => $NeType,
            VisibleType   => $VisibleType{$Type},
            VisibleNeType => $VisibleType{$NeType},
        },
    );

    $Self->{LayoutObject}->Block( Name => "ChangeHeader$VisibleType{$NeType}" );

    $Self->{LayoutObject}->Block(
        Name => 'ChangeHeader',
        Data => {
            %Param,
            Type => $Type,
        },
    );

    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        my $Selected = $Param{Selected}->{$ID} ? ' checked="checked"' : '';

        $Self->{LayoutObject}->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                Name     => $Param{Data}->{$ID},
                NeType   => $NeType,
                Type     => $Type,
                ID       => $ID,
                Selected => $Selected,
            },
        );
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminResponseAttachment',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {},
    );

    $Self->{LayoutObject}->Block( Name => 'Filters' );

    # no actions in action list
    #    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

    # get StandardResponse data
    my %StandardResponseData = $Self->{StandardResponseObject}->StandardResponseList( Valid => 1 );

    # if there are any responses, they are shown
    if (%StandardResponseData) {
        for my $StandardResponseID (
            sort { uc( $StandardResponseData{$a} ) cmp uc( $StandardResponseData{$b} ) }
            keys %StandardResponseData
            )
        {
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

    # otherwise a no data message is displayed
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoResponsesFoundMsg',
            Data => {},
        );
    }

    # get queue data
    my %StdAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentList( Valid => 1 );

    # if there are any attachments, they are shown
    if (%StdAttachmentData) {
        for my $StdAttachmentID (
            sort { uc( $StdAttachmentData{$a} ) cmp uc( $StdAttachmentData{$b} ) }
            keys %StdAttachmentData
            )
        {
            $Self->{LayoutObject}->Block(
                Name => 'Listn1',
                Data => {
                    Name      => $StdAttachmentData{$StdAttachmentID},
                    Subaction => 'Attachment',
                    ID        => $StdAttachmentID,
                },
            );
        }
    }

    # otherwise a no data message is displayed
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoAttachmentsFoundMsg',
            Data => {},
        );
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminResponseAttachment',
        Data         => \%Param,
    );
}

1;
