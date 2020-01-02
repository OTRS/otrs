# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::PictureUpload;

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $Charset      = $LayoutObject->{UserCharset};

    # get params
    my $ParamObject     = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $FormID          = $ParamObject->GetParam( Param => 'FormID' );
    my $CKEditorFuncNum = $ParamObject->GetParam( Param => 'CKEditorFuncNum' ) || 0;
    my $ResponseType    = $ParamObject->GetParam( Param => 'responseType' ) || '';

    # return if no form id exists
    if ( !$FormID ) {
        $LayoutObject->Block(
            Name => 'ErrorNoFormID',
            Data => {
                CKEditorFuncNum => $CKEditorFuncNum,
            },
        );
        return $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $Charset,
            Content     => $LayoutObject->Output( TemplateFile => 'PictureUpload' ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    # deliver file form for display inline content
    my $ContentID = $ParamObject->GetParam( Param => 'ContentID' );
    if ($ContentID) {

        # return image inline
        my @AttachmentData = $UploadCacheObject->FormIDGetAllFilesData(
            FormID => $FormID,
        );
        ATTACHMENT:
        for my $Attachment (@AttachmentData) {
            next ATTACHMENT if !$Attachment->{ContentID};
            next ATTACHMENT if $Attachment->{ContentID} ne $ContentID;

            if (
                $Attachment->{Filename} !~ /\.(png|gif|jpg|jpeg|bmp)$/i
                || substr( $Attachment->{ContentType}, 0, 6 ) ne 'image/'
                )
            {
                $LayoutObject->Block(
                    Name => 'ErrorNoImageFile',
                    Data => {
                        CKEditorFuncNum => $CKEditorFuncNum,
                    },
                );
                return $LayoutObject->Attachment(
                    ContentType => 'text/html; charset=' . $Charset,
                    Content     => $LayoutObject->Output( TemplateFile => 'PictureUpload' ),
                    Type        => 'inline',
                    NoCache     => 1,
                );
            }

            if ( $Attachment->{ContentType} =~ /xml/i ) {

                # Strip out file content first, escaping script tag.
                my %SafetyCheckResult = $Kernel::OM->Get('Kernel::System::HTMLUtils')->Safety(
                    String       => $Attachment->{Content},
                    NoApplet     => 1,
                    NoObject     => 1,
                    NoEmbed      => 1,
                    NoSVG        => 0,
                    NoIntSrcLoad => 0,
                    NoExtSrcLoad => 0,
                    NoJavaScript => 1,
                    Debug        => $Self->{Debug},
                );

                $Attachment->{Content} = $SafetyCheckResult{String};
            }

            return $LayoutObject->Attachment(
                Type => 'inline',
                %{$Attachment},
            );
        }
    }

    # get uploaded file
    my %File = $ParamObject->GetUploadAll(
        Param => 'upload',
    );

    # return error if no file is there
    if ( !%File ) {
        $LayoutObject->Block(
            Name => 'ErrorNoFileFound',
            Data => {
                CKEditorFuncNum => $CKEditorFuncNum,
            },
        );
        return $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $Charset,
            Content     => $LayoutObject->Output( TemplateFile => 'PictureUpload' ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # return error if file is not possible to show inline
    if ( $File{Filename} !~ /\.(png|gif|jpg|jpeg|bmp)$/i || substr( $File{ContentType}, 0, 6 ) ne 'image/' ) {
        $LayoutObject->Block(
            Name => 'ErrorNoImageFile',
            Data => {
                CKEditorFuncNum => $CKEditorFuncNum,
            },
        );
        return $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $Charset,
            Content     => $LayoutObject->Output( TemplateFile => 'PictureUpload' ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    if ( $File{ContentType} =~ /xml/i ) {

        # Strip out file content first, escaping script tag.
        my %SafetyCheckResult = $Kernel::OM->Get('Kernel::System::HTMLUtils')->Safety(
            String       => $File{Content},
            NoApplet     => 1,
            NoObject     => 1,
            NoEmbed      => 1,
            NoSVG        => 0,
            NoIntSrcLoad => 0,
            NoExtSrcLoad => 0,
            NoJavaScript => 1,
            Debug        => $Self->{Debug},
        );

        $File{Content} = $SafetyCheckResult{String};
    }

    # check if name already exists
    my @AttachmentMeta = $UploadCacheObject->FormIDGetAllFilesMeta(
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
    $UploadCacheObject->FormIDAddFile(
        FormID      => $FormID,
        Filename    => $FilenameTmp,
        Content     => $File{Content},
        ContentType => $File{ContentType} . '; name="' . $FilenameTmp . '"',
        Disposition => 'inline',
    );

    # get new content id
    my $ContentIDNew = '';
    @AttachmentMeta = $UploadCacheObject->FormIDGetAllFilesMeta(
        FormID => $FormID
    );
    ATTACHMENT:
    for my $Attachment (@AttachmentMeta) {
        next ATTACHMENT if $FilenameTmp ne $Attachment->{Filename};
        $ContentIDNew = $Attachment->{ContentID};
        last ATTACHMENT;
    }

    # serve new content id and url to rte
    my $Session = '';
    if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
        $Session = ';' . $Self->{SessionName} . '=' . $Self->{SessionID};
    }
    my $URL = $LayoutObject->{Baselink}
        . "Action=PictureUpload;FormID=$FormID;ContentID=$ContentIDNew$Session";

    # if ResponseType is JSON, do not return template content but a JSON structure
    if ( $ResponseType eq 'json' ) {
        my %Result = (
            fileName => $FilenameTmp,
            uploaded => 1,
            url      => $URL,
        );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $Charset,
            Content     => $LayoutObject->JSONEncode( Data => \%Result ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    $LayoutObject->Block(
        Name => 'Success',
        Data => {
            CKEditorFuncNum => $CKEditorFuncNum,
            URL             => $URL,
        },
    );
    return $LayoutObject->Attachment(
        ContentType => 'text/html; charset=' . $Charset,
        Content     => $LayoutObject->Output( TemplateFile => 'PictureUpload' ),
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
