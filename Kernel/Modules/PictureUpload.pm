# --
# Kernel/Modules/PictureUpload.pm - get picture uploads
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: PictureUpload.pm,v 1.3.2.1 2010-01-26 20:39:50 martin Exp $
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
$VERSION = qw($Revision: 1.3.2.1 $) [1];

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

    $Self->{UploadCachObject} = Kernel::System::Web::UploadCache->new(%Param);

    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = "Content-Type: text/html; charset="
        . $Self->{ConfigObject}->Get('DefaultCharset') . ";\n\n";
    $Output .= "
<script type=\"text/javascript\">
(function(){var d=document.domain;while (true){try{var A=window.parent.document.domain;break;}catch(e
) {};d=d.replace(/.*?(?:\.|\$)/,'');if (d.length==0) break;try{document.domain=d;}catch (e){break;}}}
)();

";

    # return if no form id exists
    if ( !$Self->{FormID} ) {
        $Output .= "window.parent.OnUploadCompleted(404,\"\",\"\",\"\") ;</script>";
        return $Output;
    }

    # deliver file form for display inline content
    my $ContentID = $Self->{ParamObject}->GetParam( Param => 'ContentID' );
    if ($ContentID) {

        # return image inline
        my @AttachmentData = $Self->{UploadCachObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
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
        Param  => 'NewFile',
        Source => 'string',
    );

    # return error if no file is there
    if ( !%File ) {
        $Output .= "window.parent.OnUploadCompleted(404,\"-\",\"-\",\"\") ;</script>";
        return $Output;
    }

    # return error if file is not possible to show inline
    if ( $File{Filename} !~ /\.(png|gif|jpg|jpeg)$/i ) {
        $Output .= "window.parent.OnUploadCompleted(202,\"-\",\"-\",\"\") ;</script>";
        return $Output;
    }

    # check if name already exists
    my @AttachmentMeta = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID}
    );
    my $TmpFilename    = $File{Filename};
    my $TmpSuffix      = 0;
    my $UniqueFilename = '';
    while ( !$UniqueFilename ) {
        $UniqueFilename = $TmpFilename;
        NEWNAME:
        for my $TmpAttachment ( reverse @AttachmentMeta ) {
            next NEWNAME if $TmpFilename ne $TmpAttachment->{Filename};

            # name exists -> change
            ++$TmpSuffix;
            if ( $File{Filename} =~ /^(.*)\.(.+?)$/ ) {
                $TmpFilename = "$1-$TmpSuffix.$2";
            }
            else {
                $TmpFilename = "$File{Filename}-$TmpSuffix";
            }
            $UniqueFilename = '';
            last NEWNAME;
        }
    }

    # add uploaded file to upload cache
    $Self->{UploadCachObject}->FormIDAddFile(
        FormID      => $Self->{FormID},
        Filename    => $TmpFilename,
        Content     => $File{Content},
        ContentType => $File{ContentType} . '; name="' . $TmpFilename . '"',
        Disposition => 'inline',
    );

    # get new content id
    my $ContentIDNew = '';
    @AttachmentMeta = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID}
    );
    CONTENTID:
    for my $TmpAttachment (@AttachmentMeta) {
        next CONTENTID if $TmpFilename ne $TmpAttachment->{Filename};
        $ContentIDNew = $TmpAttachment->{ContentID};
        last CONTENTID;
    }

    # serve new content id to rte
    my $Session = '';
    if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
        $Session = "&" . $Self->{SessionName} . "=" . $Self->{SessionID};
    }
    my $URL = $Self->{LayoutObject}->{Baselink}
        . "Action=PictureUpload"
        . "&FormID="
        . $Self->{FormID}
        . "&ContentID="
        . $ContentIDNew
        . $Session;
    $Output .= "window.parent.OnUploadCompleted(0,\"$URL\",\"$URL\",\"\") ;</script>";

    return $Output;
}

1;
