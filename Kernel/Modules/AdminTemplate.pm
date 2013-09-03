# --
# Kernel/Modules/AdminTemplate.pm - provides admin std template module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminTemplate;

use strict;
use warnings;

use Kernel::System::StandardTemplate;
use Kernel::System::StdAttachment;
use Kernel::System::Valid;
use Kernel::System::HTMLUtils;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{StandardTemplateObject} = Kernel::System::StandardTemplate->new(%Param);
    $Self->{StdAttachmentObject}    = Kernel::System::StdAttachment->new(%Param);
    $Self->{ValidObject}            = Kernel::System::Valid->new(%Param);
    $Self->{HTMLUtilsObject}        = Kernel::System::HTMLUtils->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        my %Data = $Self->{StandardTemplateObject}->StandardTemplateGet( ID => $ID, );

        my @SelectedAttachment;
        my %SelectedAttachmentData
            = $Self->{StdAttachmentObject}->StdAttachmentStandardTemplateMemberList(
            StandardTemplateID => $ID,
            );
        for my $Key ( sort keys %SelectedAttachmentData ) {
            push @SelectedAttachment, $Key;
        }

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
            SelectedAttachments => \@SelectedAttachment,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminTemplate',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my @NewIDs = $Self->{ParamObject}->GetArray( Param => 'IDs' );
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Comment ValidID Template TemplateType)) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # get composed content type
        $GetParam{ContentType} = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $GetParam{ContentType} = 'text/html';
        }

        # check needed data
        for my $Needed (qw(Name ValidID TemplateType)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update group
            if (
                $Self->{StandardTemplateObject}->StandardTemplateUpdate(
                    %GetParam,
                    UserID => $Self->{UserID},
                )
                )
            {
                my %AttachmentsAll = $Self->{StdAttachmentObject}->StdAttachmentList();

                # create hash with selected queues
                my %AttachmentsSelected = map { $_ => 1 } @NewIDs;

                # check all used attachments
                for my $AttachmentID ( sort keys %AttachmentsAll ) {
                    my $Active = $AttachmentsSelected{$AttachmentID} ? 1 : 0;

                    # set attachment to standard template relation
                    my $Success
                        = $Self->{StdAttachmentObject}->StdAttachmentStandardTemplateMemberAdd(
                        AttachmentID       => $AttachmentID,
                        StandardTemplateID => $GetParam{ID},
                        Active             => $Active,
                        UserID             => $Self->{UserID},
                        );
                }

                $Self->_Overview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Template updated!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminTemplate',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action              => 'Change',
            Errors              => \%Errors,
            SelectedAttachments => \@NewIDs,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminTemplate',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam;
        $GetParam{Name} = $Self->{ParamObject}->GetParam( Param => 'Name' );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminTemplate',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my @NewIDs = $Self->{ParamObject}->GetArray( Param => 'IDs' );
        my ( %GetParam, %Errors );

        for my $Parameter (qw(ID Name Comment ValidID Template TemplateType)) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # get composed content type
        $GetParam{ContentType} = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $GetParam{ContentType} = 'text/html';
        }

        # check needed data
        for my $Needed (qw(Name ValidID TemplateType)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add template
            my $StandardTemplateID
                = $Self->{StandardTemplateObject}->StandardTemplateAdd(
                %GetParam,
                UserID => $Self->{UserID},
                );
            if ($StandardTemplateID) {

                my %AttachmentsAll = $Self->{StdAttachmentObject}->StdAttachmentList();

                # create hash with selected queues
                my %AttachmentsSelected = map { $_ => 1 } @NewIDs;

                # check all used attachments
                for my $AttachmentID ( sort keys %AttachmentsAll ) {
                    my $Active = $AttachmentsSelected{$AttachmentID} ? 1 : 0;

                    # set attachment to standard template relation
                    my $Success
                        = $Self->{StdAttachmentObject}->StdAttachmentStandardTemplateMemberAdd(
                        AttachmentID       => $AttachmentID,
                        StandardTemplateID => $StandardTemplateID,
                        Active             => $Active,
                        UserID             => $Self->{UserID},
                        );
                }

                $Self->_Overview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Template added!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminTemplate',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action              => 'Add',
            Errors              => \%Errors,
            SelectedAttachments => \@NewIDs,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminTemplate',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # delete action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        my $Delete = $Self->{StandardTemplateObject}->StandardTemplateDelete(
            ID => $ID,
        );
        if ( !$Delete ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminTemplate',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    my $TemplateTypeList = $Self->{ConfigObject}->Get('StandardTemplate::Types');

    $Param{TemplateTypeString} = $Self->{LayoutObject}->BuildSelection(
        Data       => $TemplateTypeList,
        Name       => 'TemplateType',
        SelectedID => $Param{TemplateType},
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'TemplateTypeInvalid'} || '' ),
    );

    my %AttachmentData = $Self->{StdAttachmentObject}->StdAttachmentList( Valid => 1 );
    $Param{AttachmentOption} = $Self->{LayoutObject}->BuildSelection(
        Data         => \%AttachmentData,
        Name         => 'IDs',
        Multiple     => 1,
        Size         => 6,
        Translation  => 0,
        PossibleNone => 1,
        SelectedID   => $Param{SelectedAttachments},
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEdit' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAdd' );
    }

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );

        # reformat from plain to html
        if ( $Param{ContentType} && $Param{ContentType} =~ /text\/plain/i ) {
            $Param{Template} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $Param{Template},
            );
        }
    }
    else {

        # reformat from html to plain
        if ( $Param{ContentType} && $Param{ContentType} =~ /text\/html/i ) {
            $Param{Template} = $Self->{HTMLUtilsObject}->ToAscii(
                String => $Param{Template},
            );
        }
    }
    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd' );
    $Self->{LayoutObject}->Block( Name => 'Filter' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    my %List = $Self->{StandardTemplateObject}->StandardTemplateList(
        UserID => 1,
        Valid  => 0,
    );

    # if there are any results, they are shown
    if (%List) {

        my %ListGet;
        for my $ID ( sort keys %List ) {
            %{ $ListGet{$ID} } = $Self->{StandardTemplateObject}->StandardTemplateGet( ID => $ID, );
            $ListGet{$ID}->{SortName} = $ListGet{$ID}->{TemplateType} . $ListGet{$ID}->{Name};
        }

        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();
        for my $ID ( sort { $ListGet{$a}->{SortName} cmp $ListGet{$b}->{SortName} } keys %ListGet )
        {

            my %Data = %{ $ListGet{$ID} };
            my @SelectedAttachment;
            my %SelectedAttachmentData
                = $Self->{StdAttachmentObject}->StdAttachmentStandardTemplateMemberList(
                StandardTemplateID => $ID,
                );
            for my $Key ( sort keys %SelectedAttachmentData ) {
                push @SelectedAttachment, $Key;
            }
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Valid => $ValidList{ $Data{ValidID} },
                    %Data,
                    Attachments => scalar @SelectedAttachment,
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    return 1;
}

1;
