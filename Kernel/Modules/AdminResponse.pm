# --
# Kernel/Modules/AdminResponse.pm - provides admin std response module
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AdminResponse.pm,v 1.30 2009-03-16 23:59:34 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminResponse;

use strict;
use warnings;

use Kernel::System::StdResponse;
use Kernel::System::StdAttachment;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.30 $) [1];

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
    $Self->{StdResponseObject}   = Kernel::System::StdResponse->new(%Param);
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);
    $Self->{ValidObject}         = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Param{Subaction} = $Self->{Subaction} || '';
    $Param{NextScreen} = 'AdminResponse';

    my @Params = ( 'ID', 'Name', 'Comment', 'ValidID', 'Response' );
    my %GetParam;
    for (@Params) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
    }

    # get composed charset
    $GetParam{Charset} = $Self->{LayoutObject}->{UserCharset};

    # get composed content type
    my $TextType = 'plain';
    if ( $Self->{ConfigObject}->{'Frontend::RichText'} ) {
        $TextType = 'html';
    }
    $GetParam{ContentType} = 'text/' . $TextType . '; charset=' . $GetParam{Charset};

    # get response attachment data
    my %AttachmentData = $Self->{StdAttachmentObject}->GetAllStdAttachments( Valid => 1 );
    my %SelectedAttachmentData = ();
    if ( $GetParam{ID} ) {
        %SelectedAttachmentData
            = $Self->{StdAttachmentObject}->StdAttachmentsByResponseID( ID => $GetParam{ID}, );
    }

    # ------------------------------------------------------------ #
    # get data 2 form
    # ------------------------------------------------------------ #
    if ( $Param{Subaction} eq 'Change' ) {
        $Param{ID} = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        my %ResponseData = $Self->{StdResponseObject}->StdResponseGet( ID => $Param{ID} );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(
            %ResponseData,
            %Param,
            Attachments         => \%AttachmentData,
            SelectedAttachments => \%SelectedAttachmentData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # update action
    # ------------------------------------------------------------ #
    elsif ( $Param{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Update = $Self->{StdResponseObject}->StdResponseUpdate(
            %GetParam,
            UserID => $Self->{UserID},
        );
        if ( !$Update ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # update attachments to response
        my @NewIDs = $Self->{ParamObject}->GetArray( Param => 'IDs' );
        $Self->{StdAttachmentObject}->SetStdAttachmentsOfResponseID(
            AttachmentIDsRef => \@NewIDs,
            ID               => $GetParam{ID},
            UserID           => $Self->{UserID},
        );
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Param{NextScreen}" );
    }

    # ------------------------------------------------------------ #
    # add new response
    # ------------------------------------------------------------ #
    elsif ( $Param{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Id = $Self->{StdResponseObject}->StdResponseAdd(
            %GetParam,
            UserID => $Self->{UserID},
        );
        if ( !$Id ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # add attachments to response
        my @NewIDs = $Self->{ParamObject}->GetArray( Param => 'IDs' );
        $Self->{StdAttachmentObject}->SetStdAttachmentsOfResponseID(
            AttachmentIDsRef => \@NewIDs,
            ID               => $Id,
            UserID           => $Self->{UserID},
        );

        # show next page
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AdminQueueResponses&Subaction=Response&ID=$Id",
        );
    }

    # ------------------------------------------------------------ #
    # delete response
    # ------------------------------------------------------------ #
    elsif ( $Param{Subaction} eq 'Delete' ) {

        my $Delete = $Self->{StdResponseObject}->StdResponseDelete(
            ID => $GetParam{ID},
        );
        if ( !$Delete ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # show next page
        return $Self->{LayoutObject}->Redirect( OP => "Action=AdminResponse" );
    }

    # ------------------------------------------------------------ #
    # else ! print form
    # ------------------------------------------------------------ #
    else {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(
            Subaction           => 'Add',
            Attachments         => \%AttachmentData,
            SelectedAttachments => \%SelectedAttachmentData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => { $Self->{ValidObject}->ValidList(), },
        Name       => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    # build ResponseOption string
    $Param{'ResponseOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{DBObject}->GetTableData(
                What  => 'id, name, id',
                Valid => 0,
                Clamp => 1,
                Table => 'standard_response',
                )
        },
        Name       => 'ID',
        Size       => 15,
        SelectedID => $Param{ID},
    );

    my %SecondDataTmp = %{ $Param{Attachments} };
    my %DataTmp       = %{ $Param{SelectedAttachments} };
    $Param{AttachmentOption} .= "<SELECT NAME=\"IDs\" SIZE=3 multiple>\n";
    for my $ID ( sort keys %SecondDataTmp ) {
        $Param{AttachmentOption} .= "<OPTION ";
        for ( sort keys %DataTmp ) {
            if ( $_ eq $ID ) {
                $Param{AttachmentOption} .= 'selected';
            }
        }
        $Param{AttachmentOption} .= " VALUE=\"$ID\">$SecondDataTmp{$ID}</OPTION>\n";
    }
    $Param{AttachmentOption} .= "</SELECT>\n";

    # add YUI editor
    if ( $Self->{ConfigObject}->{'Frontend::RichText'} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );

        # reformat response if necessary
        if ( $Param{ContentType} && $Param{ContentType} =~ /^text\/plain/ ) {
            $Param{Response} = $Self->{LayoutObject}->Ascii2Html(
                Text           => $Param{Response},
                NewLine        => $Self->{ConfigObject}->Get('DefaultViewNewLine'),
                HTMLResultMode => 1,
            );
        }
    }

    return $Self->{LayoutObject}->Output( TemplateFile => 'AdminResponseForm', Data => \%Param );
}

1;
