# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AjaxAttachment;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
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

    # get params
    my %GetParam;

    # get param object
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get form id
    $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormID' );

    if ( !$Self->{FormID} ) {
        return $LayoutObject->FatalError(
            Message => Translatable('Got no FormID.'),
        );
    }

    # challenge token check for write action
    $LayoutObject->ChallengeTokenCheck();

    if ( $Self->{Subaction} eq 'Upload' ) {

        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'Files',
        );

        $UploadCacheObject->FormIDAddFile(
            FormID      => $Self->{FormID},
            Disposition => 'attachment',
            %UploadStuff,
        );

        # get all attachments meta data
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # add human readable data size
        for my $Attachment (@Attachments) {
            $Attachment->{HumanReadableDataSize} = $LayoutObject->HumanReadableDataSize(
                Size => $Attachment->{Filesize},
            );
        }

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data => \@Attachments,
            ),
            Type    => 'inline',
            NoCache => 1,
        );
    }
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        my $AttachmentFileID = $ParamObject->GetParam( Param => 'FileID' ) || '';
        $UploadCacheObject->FormIDRemoveFile(
            FormID => $Self->{FormID},
            FileID => $AttachmentFileID,
        );

        # get all remaining attachments
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data => 'Success',
            ),
            Type    => 'inline',
            NoCache => 1,
        );
    }
}

1;
