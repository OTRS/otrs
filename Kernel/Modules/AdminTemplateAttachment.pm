# --
# Kernel/Modules/AdminTemplateAttachment.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminTemplateAttachment;

use strict;
use warnings;

use Kernel::System::StdAttachment;
use Kernel::System::StandardTemplate;

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
    $Self->{StandardTemplateObject} = Kernel::System::StandardTemplate->new(%Param);
    $Self->{StdAttachmentObject}    = Kernel::System::StdAttachment->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # template <-> attachment 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Template' ) {

        # get template data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %StandardTemplateData = $Self->{StandardTemplateObject}->StandardTemplateGet(
            ID => $ID,
        );

        # get attachment data
        my %StdAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentList( Valid => 1 );

        my %Member = $Self->{StdAttachmentObject}->StdAttachmentStandardTemplateMemberList(
            StandardTemplateID => $ID,
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StdAttachmentData,
            ID       => $StandardTemplateData{ID},
            Name     => $StandardTemplateData{TemplateType} . ' - ' . $StandardTemplateData{Name},
            Type     => 'Template',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # attachment <-> template n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Attachment' ) {

        # get group data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %StdAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentGet( ID => $ID );

        # get user list
        my %StandardTemplateData = $Self->{StandardTemplateObject}->StandardTemplateList(
            Valid => 1,
        );

        if (%StandardTemplateData) {
            for my $StandardTemplateID ( sort keys %StandardTemplateData ) {
                my %Data = $Self->{StandardTemplateObject}->StandardTemplateGet(
                    ID => $StandardTemplateID
                );
                $StandardTemplateData{$StandardTemplateID}
                    = $Self->{LayoutObject}->{LanguageObject}->Get( $Data{TemplateType} )
                    . ' - '
                    . $Data{Name};
            }
        }

        my %Member = $Self->{StdAttachmentObject}->StdAttachmentStandardTemplateMemberList(
            AttachmentID => $ID,
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StandardTemplateData,
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

        # get new templates
        my @TemplatesSelected
            = $Self->{ParamObject}->GetArray( Param => 'ItemsSelected' );
        my @TemplatesAll
            = $Self->{ParamObject}->GetArray( Param => 'ItemsAll' );

        my $AttachmentID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # create hash with selected templates
        my %TemplatesSelected = map { $_ => 1 } @TemplatesSelected;

        # check all used templates
        for my $TemplateID (@TemplatesAll) {
            my $Active = $TemplatesSelected{$TemplateID} ? 1 : 0;

            # set attachment to standard template relation
            my $Success = $Self->{StdAttachmentObject}->StdAttachmentStandardTemplateMemberAdd(
                AttachmentID       => $AttachmentID,
                StandardTemplateID => $TemplateID,
                Active             => $Active,
                UserID             => $Self->{UserID},
            );
        }

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # groups to user
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeTemplate' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get new attachments
        my @AttachmentsSelected
            = $Self->{ParamObject}->GetArray( Param => 'ItemsSelected' );
        my @AttachmentsAll
            = $Self->{ParamObject}->GetArray( Param => 'ItemsAll' );

        my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # create hash with selected queues
        my %AttachmentsSelected = map { $_ => 1 } @AttachmentsSelected;

        # check all used attachments
        for my $AttachmentID (@AttachmentsAll) {
            my $Active = $AttachmentsSelected{$AttachmentID} ? 1 : 0;

            # set attachment to standard template relation
            my $Success = $Self->{StdAttachmentObject}->StdAttachmentStandardTemplateMemberAdd(
                AttachmentID       => $AttachmentID,
                StandardTemplateID => $TemplateID,
                Active             => $Active,
                UserID             => $Self->{UserID},
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
    my $Type   = $Param{Type} || 'Template';
    my $NeType = $Type eq 'Attachment' ? 'Template' : 'Attachment';

    my %VisibleType = ( Template => 'Template', Attachment => 'Attachment', );

    $Self->{LayoutObject}->Block( Name => 'Overview' );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );
    $Self->{LayoutObject}->Block( Name => 'Filter' );

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
        TemplateFile => 'AdminTemplateAttachment',
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

    # get StandardTemplate data
    my %StandardTemplateData = $Self->{StandardTemplateObject}->StandardTemplateList(
        Valid => 1,
    );

    # if there are any templates, they are shown
    if (%StandardTemplateData) {
        for my $StandardTemplateID ( sort keys %StandardTemplateData ) {
            my %Data = $Self->{StandardTemplateObject}->StandardTemplateGet(
                ID => $StandardTemplateID
            );
            $StandardTemplateData{$StandardTemplateID}
                = $Self->{LayoutObject}->{LanguageObject}->Get( $Data{TemplateType} )
                . ' - '
                . $Data{Name};
        }

        for my $StandardTemplateID (
            sort { uc( $StandardTemplateData{$a} ) cmp uc( $StandardTemplateData{$b} ) }
            keys %StandardTemplateData
            )
        {
            $Self->{LayoutObject}->Block(
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
        $Self->{LayoutObject}->Block(
            Name => 'NoTemplatesFoundMsg',
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
        TemplateFile => 'AdminTemplateAttachment',
        Data         => \%Param,
    );
}

1;
