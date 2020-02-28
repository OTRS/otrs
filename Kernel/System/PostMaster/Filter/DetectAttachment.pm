# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::Filter::DetectAttachment;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject";

    # Get communication log object and MessageID.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(JobConfig GetParam)) {
        if ( !$Param{$Needed} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::DetectAttachment',
                Value         => "Need $Needed!",
            );
            return;
        }
    }

    # Get attachments.
    my @Attachments = $Self->{ParserObject}->GetAttachments();

    my $AttachmentCount = 0;
    for my $Attachment (@Attachments) {

        # Do not flag inline images as attachments, see bug#14949 for more information.
        my $AttachmentInline = 0;
        if (
            defined $Attachment->{ContentID}
            && length $Attachment->{ContentID}
            )
        {
            my ($ImageID) = ( $Attachment->{ContentID} =~ m{^<(.*)>$}ixms );
            if ( grep { $_->{Content} =~ m{<img.*src=.*['|"]cid:\Q$ImageID\E['|"].*>}ixms } @Attachments ) {
                $AttachmentInline = 1;
            }
        }

        if (
            defined $Attachment->{ContentDisposition}
            && length $Attachment->{ContentDisposition}
            && !$AttachmentInline
            )
        {
            $AttachmentCount++;
        }
    }

    $Param{GetParam}->{'X-OTRS-AttachmentExists'} = ( $AttachmentCount ? 'yes' : 'no' );
    $Param{GetParam}->{'X-OTRS-AttachmentCount'}  = $AttachmentCount;

    return 1;
}

1;
