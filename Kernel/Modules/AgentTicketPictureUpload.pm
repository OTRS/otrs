# --
# Kernel/Modules/AgentTicketPictureUpload.pm - get picture uploads
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketPictureUpload.pm,v 1.2 2009-03-27 17:35:11 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketPictureUpload;

use strict;
use warnings;

use Kernel::System::Web::UploadCache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
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

    if ( !$Self->{FormID} ) {
        $Output .= "{status:'Got no FormID!'}";
        return $Output;
    }

    if ( $Self->{ParamObject}->GetParam( Param => 'ContentID' ) ) {
        my $ContentID = $Self->{ParamObject}->GetParam( Param => 'ContentID' ) || '';

        # return image inline
        my @AttachmentData
            = $Self->{UploadCachObject}->FormIDGetAllFilesData( FormID => $Self->{FormID} );
        ATTACHMENTDATA:
        for my $TmpAttachment (@AttachmentData) {
            next ATTACHMENTDATA if $TmpAttachment->{ContentID} ne $ContentID;
            return $Self->{LayoutObject}->Attachment(
                Type => 'inline',
                %{$TmpAttachment},
            );
        }
    }

    # upload new picture
    my %File = $Self->{ParamObject}->GetUploadAll(
        Param  => 'param_name',
        Source => 'string',
    );

    if ( !%File ) {
        $Output .= "{status:'Got no File!'}";
        return $Output;
    }

    if ( $File{Filename} !~ /\.(png|gif|jpg|jpeg)$/i ) {
        $Output .= "{status:'Only gif, jp(e)g and png images allowed!'}";
        return $Output;
    }

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
    $Self->{UploadCachObject}->FormIDAddFile(
        FormID      => $Self->{FormID},
        Filename    => $TmpFilename,
        Content     => $File{Content},
        ContentType => $File{ContentType} . '; name="' . $TmpFilename . '"',
        Disposition => 'inline',
    );
    my $ContentID = '';
    @AttachmentMeta = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID}
    );
    CONTENTID:
    for my $TmpAttachment (@AttachmentMeta) {
        next CONTENTID if $TmpFilename ne $TmpAttachment->{Filename};
        $ContentID = $TmpAttachment->{ContentID};
        last CONTENTID;
    }

    $Output .= "{status:'UPLOADED', image_url:'"
        . $Self->{LayoutObject}->{Baselink}
        . "Action=AgentTicketPictureUpload"
        . "&FormID="
        . $Self->{FormID}
        . "&ContentID="
        . $ContentID
        . "'}";
    return $Output;
}

1;
