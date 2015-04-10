# --
# Kernel/Modules/AdminTemplateAttachment.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminTemplateAttachment;

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

    my $ParamObject            = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject           = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
    my $StdAttachmentObject    = $Kernel::OM->Get('Kernel::System::StdAttachment');

    # ------------------------------------------------------------ #
    # template <-> attachment 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Template' ) {

        # get template data
        my $ID = $ParamObject->GetParam( Param => 'ID' );
        my %StandardTemplateData = $StandardTemplateObject->StandardTemplateGet(
            ID => $ID,
        );

        # get attachment data
        my %StdAttachmentData = $StdAttachmentObject->StdAttachmentList( Valid => 1 );

        my %Member = $StdAttachmentObject->StdAttachmentStandardTemplateMemberList(
            StandardTemplateID => $ID,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StdAttachmentData,
            ID       => $StandardTemplateData{ID},
            Name     => $StandardTemplateData{TemplateType} . ' - ' . $StandardTemplateData{Name},
            Type     => 'Template',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # attachment <-> template n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Attachment' ) {

        # get group data
        my $ID = $ParamObject->GetParam( Param => 'ID' );
        my %StdAttachmentData = $StdAttachmentObject->StdAttachmentGet( ID => $ID );

        # get user list
        my %StandardTemplateData = $StandardTemplateObject->StandardTemplateList(
            Valid => 1,
        );

        if (%StandardTemplateData) {
            for my $StandardTemplateID ( sort keys %StandardTemplateData ) {
                my %Data = $StandardTemplateObject->StandardTemplateGet(
                    ID => $StandardTemplateID
                );
                $StandardTemplateData{$StandardTemplateID}
                    = $LayoutObject->{LanguageObject}->Translate( $Data{TemplateType} )
                    . ' - '
                    . $Data{Name};
            }
        }

        my %Member = $StdAttachmentObject->StdAttachmentStandardTemplateMemberList(
            AttachmentID => $ID,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StandardTemplateData,
            ID       => $StdAttachmentData{ID},
            Name     => $StdAttachmentData{Name},
            Type     => 'Attachment',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add user to groups
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAttachment' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get new templates
        my @TemplatesSelected = $ParamObject->GetArray( Param => 'ItemsSelected' );
        my @TemplatesAll      = $ParamObject->GetArray( Param => 'ItemsAll' );

        my $AttachmentID = $ParamObject->GetParam( Param => 'ID' );

        # create hash with selected templates
        my %TemplatesSelected = map { $_ => 1 } @TemplatesSelected;

        # check all used templates
        for my $TemplateID (@TemplatesAll) {
            my $Active = $TemplatesSelected{$TemplateID} ? 1 : 0;

            # set attachment to standard template relation
            my $Success = $StdAttachmentObject->StdAttachmentStandardTemplateMemberAdd(
                AttachmentID       => $AttachmentID,
                StandardTemplateID => $TemplateID,
                Active             => $Active,
                UserID             => $Self->{UserID},
            );
        }

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # groups to user
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeTemplate' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get new attachments
        my @AttachmentsSelected = $ParamObject->GetArray( Param => 'ItemsSelected' );
        my @AttachmentsAll      = $ParamObject->GetArray( Param => 'ItemsAll' );

        my $TemplateID = $ParamObject->GetParam( Param => 'ID' );

        # create hash with selected queues
        my %AttachmentsSelected = map { $_ => 1 } @AttachmentsSelected;

        # check all used attachments
        for my $AttachmentID (@AttachmentsAll) {
            my $Active = $AttachmentsSelected{$AttachmentID} ? 1 : 0;

            # set attachment to standard template relation
            my $Success = $StdAttachmentObject->StdAttachmentStandardTemplateMemberAdd(
                AttachmentID       => $AttachmentID,
                StandardTemplateID => $TemplateID,
                Active             => $Active,
                UserID             => $Self->{UserID},
            );
        }

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $Self->_Overview();
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my %Data   = %{ $Param{Data} };
    my $Type   = $Param{Type} || 'Template';
    my $NeType = $Type eq 'Attachment' ? 'Template' : 'Attachment';

    my %VisibleType = (
        Template   => 'Template',
        Attachment => 'Attachment',
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $LayoutObject->Block( Name => 'Overview' );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );
    $LayoutObject->Block( Name => 'Filter' );

    $LayoutObject->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome    => 'Admin' . $Type,
            NeType        => $NeType,
            VisibleType   => $VisibleType{$Type},
            VisibleNeType => $VisibleType{$NeType},
        },
    );

    $LayoutObject->Block( Name => "ChangeHeader$VisibleType{$NeType}" );

    # check if there are attachments/templates
    if ( !%Data ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsgList',
            Data => {
                ColSpan => 2,
            },
        );
    }

    $LayoutObject->Block(
        Name => 'ChangeHeader',
        Data => {
            %Param,
            Type => $Type,
        },
    );

    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        my $Selected = $Param{Selected}->{$ID} ? ' checked="checked"' : '';

        $LayoutObject->Block(
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

    return $LayoutObject->Output(
        TemplateFile => 'AdminTemplateAttachment',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {},
    );

    $LayoutObject->Block( Name => 'Filters' );

    # no actions in action list
    #    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'OverviewResult' );

    my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

    # get StandardTemplate data
    my %StandardTemplateData = $StandardTemplateObject->StandardTemplateList(
        Valid => 1,
    );

    # if there are any templates, they are shown
    if (%StandardTemplateData) {
        for my $StandardTemplateID ( sort keys %StandardTemplateData ) {
            my %Data = $StandardTemplateObject->StandardTemplateGet(
                ID => $StandardTemplateID
            );
            $StandardTemplateData{$StandardTemplateID}
                = $LayoutObject->{LanguageObject}->Translate( $Data{TemplateType} )
                . ' - '
                . $Data{Name};
        }

        for my $StandardTemplateID (
            sort { uc( $StandardTemplateData{$a} ) cmp uc( $StandardTemplateData{$b} ) }
            keys %StandardTemplateData
            )
        {
            $LayoutObject->Block(
                Name => 'List1n',
                Data => {
                    Name      => $StandardTemplateData{$StandardTemplateID},
                    Subaction => 'Template',
                    ID        => $StandardTemplateID,
                },
            );
        }
    }

    # otherwise a no data message is displayed
    else {
        $LayoutObject->Block(
            Name => 'NoTemplatesFoundMsg',
            Data => {},
        );
    }

    # get queue data
    my %StdAttachmentData = $Kernel::OM->Get('Kernel::System::StdAttachment')->StdAttachmentList( Valid => 1 );

    # if there are any attachments, they are shown
    if (%StdAttachmentData) {
        for my $StdAttachmentID (
            sort { uc( $StdAttachmentData{$a} ) cmp uc( $StdAttachmentData{$b} ) }
            keys %StdAttachmentData
            )
        {
            $LayoutObject->Block(
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
        $LayoutObject->Block(
            Name => 'NoAttachmentsFoundMsg',
            Data => {},
        );
    }

    # return output
    return $LayoutObject->Output(
        TemplateFile => 'AdminTemplateAttachment',
        Data         => \%Param,
    );
}

1;
