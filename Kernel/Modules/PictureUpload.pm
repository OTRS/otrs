# --
# Kernel/Modules/PictureUpload.pm - get picture uploads
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::PictureUpload;

use strict;
use warnings;

use Kernel::System::Web::UploadCache;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{UploadCacheObject} = Kernel::System::Web::UploadCache->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Charset = $Self->{LayoutObject}->{UserCharset};

    # get params
    my $FormID = $Self->{ParamObject}->GetParam( Param => 'FormID' );
    my $CKEditorFuncNum = $Self->{ParamObject}->GetParam( Param => 'CKEditorFuncNum' ) || 0;

    # return if no form id exists
    if ( !$FormID ) {
        $Self->{LayoutObject}->Block(
            Name => 'ErrorNoFormID',
            Data => {
                CKEditorFuncNum => $CKEditorFuncNum,
            },
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html; charset=' . $Charset,
            Content     => $Self->{LayoutObject}->Output( TemplateFile => 'PictureUpload' ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # deliver file form for display inline content
    my $ContentID = $Self->{ParamObject}->GetParam( Param => 'ContentID' );
    if ($ContentID) {

        # return image inline
        my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $FormID,
        );
        for my $Attachment (@AttachmentData) {
            next if !$Attachment->{ContentID};
            next if $Attachment->{ContentID} ne $ContentID;
            return $Self->{LayoutObject}->Attachment(
                Type => 'inline',
                %{$Attachment},
            );
        }
    }

    # get uploaded file
    my %File = $Self->{ParamObject}->GetUploadAll(
        Param => 'upload',
    );

    # return error if no file is there
    if ( !%File ) {
        $Self->{LayoutObject}->Block(
            Name => 'ErrorNoFileFound',
            Data => {
                CKEditorFuncNum => $CKEditorFuncNum,
            },
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html; charset=' . $Charset,
            Content     => $Self->{LayoutObject}->Output( TemplateFile => 'PictureUpload' ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # return error if file is not possible to show inline
    if ( $File{Filename} !~ /\.(png|gif|jpg|jpeg)$/i ) {
        $Self->{LayoutObject}->Block(
            Name => 'ErrorNoImageFile',
            Data => {
                CKEditorFuncNum => $CKEditorFuncNum,
            },
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html; charset=' . $Charset,
            Content     => $Self->{LayoutObject}->Output( TemplateFile => 'PictureUpload' ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # check if name already exists
    my @AttachmentMeta = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $FormID,
    );
    my $FilenameTmp    = $File{Filename};
    my $SuffixTmp      = 0;
    my $UniqueFilename = '';
    while ( !$UniqueFilename ) {
        $UniqueFilename = $FilenameTmp;
        NEWNAME:
        for my $Attachment ( reverse @AttachmentMeta ) {
            next NEWNAME if $FilenameTmp ne $Attachment->{Filename};

            # name exists -> change
            ++$SuffixTmp;
            if ( $File{Filename} =~ /^(.*)\.(.+?)$/ ) {
                $FilenameTmp = "$1-$SuffixTmp.$2";
            }
            else {
                $FilenameTmp = "$File{Filename}-$SuffixTmp";
            }
            $UniqueFilename = '';
            last NEWNAME;
        }
    }

    # add uploaded file to upload cache
    $Self->{UploadCacheObject}->FormIDAddFile(
        FormID      => $FormID,
        Filename    => $FilenameTmp,
        Content     => $File{Content},
        ContentType => $File{ContentType} . '; name="' . $FilenameTmp . '"',
        Disposition => 'inline',
    );

    # get new content id
    my $ContentIDNew = '';
    @AttachmentMeta = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $FormID
    );
    for my $Attachment (@AttachmentMeta) {
        next if $FilenameTmp ne $Attachment->{Filename};
        $ContentIDNew = $Attachment->{ContentID};
        last;
    }

    # serve new content id and url to rte
    my $Session = '';
    if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
        $Session = ';' . $Self->{SessionName} . '=' . $Self->{SessionID};
    }
    my $URL = $Self->{LayoutObject}->{Baselink}
        . "Action=PictureUpload;FormID=$FormID;ContentID=$ContentIDNew$Session";

    $Self->{LayoutObject}->Block(
        Name => 'Success',
        Data => {
            CKEditorFuncNum => $CKEditorFuncNum,
            URL             => $URL,
        },
    );
    return $Self->{LayoutObject}->Attachment(
        ContentType => 'text/html; charset=' . $Charset,
        Content     => $Self->{LayoutObject}->Output( TemplateFile => 'PictureUpload' ),
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
