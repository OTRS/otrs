# --
# Kernel/Modules/AdminAttachment.pm - provides admin std response module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminAttachment.pm,v 1.19 2008-05-08 09:36:36 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminAttachment;

use strict;
use warnings;

use Kernel::System::StdAttachment;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.19 $) [1];

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
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);
    $Self->{ValidObject}         = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    $Param{Subaction} = $Self->{Subaction} || '';
    $Param{NextScreen} = 'AdminAttachment';

    my %AttachmentIndex = $Self->{StdAttachmentObject}->GetAllStdAttachments( Valid => 0 );
    my @Params = ( 'ID', 'Name', 'Comment', 'ValidID', 'Response' );

    # get data 2 form
    if ( $Param{Subaction} eq 'Change' ) {
        $Param{ID} = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        my %ResponseData = $Self->{StdAttachmentObject}->StdAttachmentGet( ID => $Param{ID} );
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask( %ResponseData, %Param, AttachmentIndex => \%AttachmentIndex, );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # update action
    elsif ( $Param{Subaction} eq 'ChangeAction' ) {
        my %GetParam;
        for (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # get attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'string',
        );

        if (
            $Self->{StdAttachmentObject}->StdAttachmentUpdate(
                %GetParam, %UploadStuff, UserID => $Self->{UserID}
            )
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Param{NextScreen}" );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # add new response
    elsif ( $Param{Subaction} eq 'AddAction' ) {
        my %GetParam;
        for (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # get attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'string',
        );

        if (
            my $Id
            = $Self->{StdAttachmentObject}->StdAttachmentAdd(
                %GetParam, %UploadStuff, UserID => $Self->{UserID}
            )
            )
        {
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminResponseAttachment&Subaction=Attachment&ID=$Id",
            );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # delete response
    elsif ( $Param{Subaction} eq 'Delete' ) {
        my %GetParam;
        for (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }
        if ( $Self->{StdAttachmentObject}->StdAttachmentDelete( ID => $GetParam{ID} ) ) {
            return $Self->{LayoutObject}->Redirect( OP => "Action=AdminAttachment" );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # else ! print form
    else {
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask( AttachmentIndex => \%AttachmentIndex, );
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
        Data       => $Param{AttachmentIndex},
        Name       => 'ID',
        Size       => 15,
        SelectedID => $Param{ID},
    );
    $Param{'Subaction'} = "Add" if ( !$Param{'Subaction'} );

    return $Self->{LayoutObject}->Output( TemplateFile => 'AdminAttachmentForm', Data => \%Param );
}

1;
