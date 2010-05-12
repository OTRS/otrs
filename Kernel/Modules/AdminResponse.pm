# --
# Kernel/Modules/AdminResponse.pm - provides admin std response module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AdminResponse.pm,v 1.47 2010-05-12 18:32:10 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminResponse;

use strict;
use warnings;

use Kernel::System::StandardResponse;
use Kernel::System::StdAttachment;
use Kernel::System::Valid;
use Kernel::System::HTMLUtils;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.47 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{StandardResponseObject} = Kernel::System::StandardResponse->new(%Param);
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
        my %Data = $Self->{StandardResponseObject}->StandardResponseGet( ID => $ID, );

        my @SelectedAttachment;
        my %SelectedAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentsByResponseID(
            ID => $ID,
        );
        for my $Key ( keys %SelectedAttachmentData ) {
            push @SelectedAttachment, $Key;
        }

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            Header => 'Edit Response',
            %Data,
            SelectedAttachments => \@SelectedAttachment,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminResponse',
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
        my %GetParam;
        for (qw(ID Name Comment ValidID Response)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # get composed content type
        $GetParam{ContentType} = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $GetParam{ContentType} = 'text/html';
        }

        # update group
        if (
            !$Self->{StandardResponseObject}
            ->StandardResponseUpdate( %GetParam, UserID => $Self->{UserID} )
            )
        {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => 'Change',
                Header => 'Edit Response',
                %GetParam,
                SelectedAttachments => \@NewIDs,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminResponse',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # update attachments to response
        $Self->{StdAttachmentObject}->StdAttachmentSetResponses(
            AttachmentIDsRef => \@NewIDs,
            ID               => $GetParam{ID},
            UserID           => $Self->{UserID},
        );

        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Info => 'Response updated!' );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminResponse',
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
        for (qw(Name)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            Header => 'Add Response',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminResponse',
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
        my %GetParam;
        for (qw(ID Name Comment ValidID Response)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # get composed content type
        $GetParam{ContentType} = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $GetParam{ContentType} = 'text/html';
        }

        # add state
        my $StandardResponseID
            = $Self->{StandardResponseObject}
            ->StandardResponseAdd( %GetParam, UserID => $Self->{UserID} );
        if ( !$StandardResponseID ) {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => 'Add',
                Header => 'Add Response',
                %GetParam,
                SelectedAttachments => \@NewIDs,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminResponse',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Info => 'Response added!' );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminResponse',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # delete action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        my $Delete = $Self->{StandardResponseObject}->StandardResponseDelete(
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
            TemplateFile => 'AdminResponse',
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
        Data => \%Param,
    );

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );

        # reformat from plain to html
        if ( $Param{ContentType} && $Param{ContentType} =~ /text\/plain/i ) {
            $Param{Response} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $Param{Response},
            );
        }
    }
    else {

        # reformat from html to plain
        if ( $Param{ContentType} && $Param{ContentType} =~ /text\/html/i ) {
            $Param{Response} = $Self->{HTMLUtilsObject}->ToAscii(
                String => $Param{Response},
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

    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    my %List = $Self->{StandardResponseObject}->StandardResponseList(
        UserID => 1,
        Valid  => 0,
    );

    # if there are any results, they are shown
    if (%List) {

        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();
        for my $ID ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %Data = $Self->{StandardResponseObject}->StandardResponseGet( ID => $ID, );
            my @SelectedAttachment;
            my %SelectedAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentsByResponseID(
                ID => $ID,
            );
            for my $Key ( keys %SelectedAttachmentData ) {
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
