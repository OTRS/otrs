# --
# Kernel/Modules/PictureUpload.pm - get picture uploads
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: PictureUpload.pm,v 1.8 2010-02-26 18:36:20 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::PictureUpload;

use strict;
use warnings;

use Kernel::System::Web::UploadCache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

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
    my $Output  = "Content-Type: text/html; charset=$Charset;\n\n";
    $Output .= "
<script type=\"text/javascript\">
(function(){var d=document.domain;while (true){try{var A=window.parent.document.domain;break;}catch(e
) {};d=d.replace(/.*?(?:\.|\$)/,'');if (d.length==0) break;try{document.domain=d;}catch (e){break;}}}
)();

";

    # get params
    my $FormID          = $Self->{ParamObject}->GetParam( Param => 'FormID' );
    my $CKEditorFuncNum = $Self->{ParamObject}->GetParam( Param => 'CKEditorFuncNum' );

    # return if no form id exists
    if ( !$FormID ) {
        $Output .= "window.parent.OnUploadCompleted(404,\"\",\"\",\"\") ;</script>";
        return $Output;
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
        Param  => 'upload',
        Source => 'string',
    );

    # return error if no file is there
    if ( !%File ) {
        $Output
            .= "window.parent.CKEDITOR.tools.callFunction($CKEditorFuncNum, ''); </script>";
        return $Output;
    }

    # return error if file is not possible to show inline
    if ( $File{Filename} !~ /\.(png|gif|jpg|jpeg)$/i ) {
        $Output
            .= "window.parent.CKEDITOR.tools.callFunction($CKEditorFuncNum, ''); </script>";
        return $Output;
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
        $Session = '&' . $Self->{SessionName} . '=' . $Self->{SessionID};
    }
    my $URL = $Self->{LayoutObject}->{Baselink}
        . "Action=PictureUpload;FormID=$FormID;ContentID=$ContentIDNew$Session";
    $Output
        .= "window.parent.CKEDITOR.tools.callFunction($CKEditorFuncNum, '$URL'); </script>";
    return $Output;
}

1;
