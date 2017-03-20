# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::ArticleStorage::Base;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::Ticket::ArticleStorage::Base - base class for article storage modules

=head1 DESCRIPTION

This is a base class for article storage backends and should not be instantiated directly.

=head1 PUBLIC INTERFACE

=head2 BuildArticleContentPath()

generate a base article content path for article storage in the file system.

    my $ArticleContentPath = $ArticleObject->BuildArticleContentPath();

=cut

sub BuildArticleContentPath {
    my ( $Self, %Param ) = @_;

    return $Self->{ArticleContentPath} if $Self->{ArticleContentPath};

    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );
    $Self->{ArticleContentPath} = $Year . '/' . $Month . '/' . $Day;

    return $Self->{ArticleContentPath};
}

=head2 ArticleAttachmentIndex()

get article attachment index as hash

 (ID => hashref (Filename, Filesize, ContentID (if exists), ContentAlternative(if exists) ))

    my %Index = $ArticleObject->ArticleAttachmentIndex(
        ArticleID => 123,
        UserID    => 123,
    );

or with "StripPlainBodyAsAttachment => 1" feature to not include first
attachment (not include text body, html body as attachment and inline attachments)

    my %Index = $ArticleObject->ArticleAttachmentIndex(
        ArticleID                  => 123,
        UserID                     => 123,
        Article                    => \%Article,
        StripPlainBodyAsAttachment => 1,
    );

or with "StripPlainBodyAsAttachment => 2" feature to not include first
attachment (not include text body as attachment)

    my %Index = $ArticleObject->ArticleAttachmentIndex(
        ArticleID                  => 123,
        UserID                     => 123,
        Article                    => \%Article,
        StripPlainBodyAsAttachment => 2,
    );

or with "StripPlainBodyAsAttachment => 3" feature to not include first
attachment (not include text body and html body as attachment)

    my %Index = $ArticleObject->ArticleAttachmentIndex(
        ArticleID                  => 123,
        UserID                     => 123,
        Article                    => \%Article,
        StripPlainBodyAsAttachment => 3,
    );

returns:

    my %Index = {
        '1' => {
            ContentAlternative => '',
            ContentID          => '',
            Filesize           => '4.6 KBytes',
            ContentType        => 'application/pdf',
            Filename           => 'StdAttachment-Test1.pdf',
            FilesizeRaw        => 4722,
            Disposition        => attachment,
        },
        '2' => {
            ContentAlternative => '',
            ContentID          => '',
            Filesize           => '183 Bytes',
            ContentType        => 'text/html; charset="utf-8"',
            Filename           => 'file-2',
            FilesizeRaw        => 183,
            Disposition        => attachment,
        },
    };

=cut

sub ArticleAttachmentIndex {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ArticleID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # get attachment index from backend
    my %Attachments = $Self->ArticleAttachmentIndexRaw(%Param);

    # stript plain attachments and e. g. html attachments
    if ( $Param{StripPlainBodyAsAttachment} && $Param{Article} ) {

        # plain attachment mime type vs. html attachment mime type check
        # remove plain body, rename html attachment
        my $AttachmentIDPlain = 0;
        my $AttachmentIDHTML  = 0;
        for my $AttachmentID ( sort keys %Attachments ) {
            my %File = %{ $Attachments{$AttachmentID} };

            # find plain attachment
            if (
                !$AttachmentIDPlain
                &&
                $File{Filename} eq 'file-1'
                && $File{ContentType} =~ /text\/plain/i
                && $File{Disposition} eq 'inline'
                )
            {
                $AttachmentIDPlain = $AttachmentID;
            }

            # find html attachment
            #  o file-[12], is plain+html attachment
            #  o file-1.html, is only html attachment
            if (
                !$AttachmentIDHTML
                &&
                ( $File{Filename} =~ /^file-[12]$/ || $File{Filename} eq 'file-1.html' )
                && $File{ContentType} =~ /text\/html/i
                && $File{Disposition} eq 'inline'
                )
            {
                $AttachmentIDHTML = $AttachmentID;
            }
        }
        if ($AttachmentIDHTML) {
            delete $Attachments{$AttachmentIDPlain};

            # remove any files with content-id from attachment list and listed in html body
            if ( $Param{StripPlainBodyAsAttachment} eq 1 ) {

                # get html body
                my %Attachment = $Self->ArticleAttachment(
                    ArticleID => $Param{ArticleID},
                    FileID    => $AttachmentIDHTML,
                    UserID    => $Param{UserID},
                );

                ATTACHMENT:
                for my $AttachmentID ( sort keys %Attachments ) {
                    my %File = %{ $Attachments{$AttachmentID} };
                    next ATTACHMENT if !$File{ContentID};

                    # content id cleanup
                    $File{ContentID} =~ s/^<//;
                    $File{ContentID} =~ s/>$//;
                    if (
                        $File{ContentID}
                        && $Attachment{Content} =~ /\Q$File{ContentID}\E/i
                        && $File{Disposition} eq 'inline'
                        )
                    {
                        delete $Attachments{$AttachmentID};
                    }
                }
            }

            # only strip html body attachment by "1" or "3"
            if (
                $Param{StripPlainBodyAsAttachment} eq 1
                || $Param{StripPlainBodyAsAttachment} eq 3
                )
            {
                delete $Attachments{$AttachmentIDHTML};
            }
            $Param{Article}->{AttachmentIDOfHTMLBody} = $AttachmentIDHTML;
        }

        # plain body size vs. attched body size check
        # and remove attachment if it's email body
        if ( !$AttachmentIDHTML ) {
            my $AttachmentIDPlain = 0;
            my %AttachmentFilePlain;
            ATTACHMENT_ID:
            for my $AttachmentID ( sort keys %Attachments ) {
                my %File = %{ $Attachments{$AttachmentID} };

                # remember, file-1 got defined by parsing if no filename was given
                if (
                    $File{Filename} eq 'file-1'
                    && $File{ContentType} =~ /text\/plain/i
                    )
                {
                    $AttachmentIDPlain   = $AttachmentID;
                    %AttachmentFilePlain = %File;
                    last ATTACHMENT_ID;
                }
            }

            # plain attachment detected and remove it from attachment index
            if (%AttachmentFilePlain) {

                # check body size vs. attachment size to be sure
                my $BodySize = bytes::length( $Param{Article}->{Body} );

                # check size by tolerance of 1.1 factor (because of charset difs)
                if (
                    $BodySize / 1.1 < $AttachmentFilePlain{FilesizeRaw}
                    && $BodySize * 1.1 > $AttachmentFilePlain{FilesizeRaw}
                    )
                {
                    delete $Attachments{$AttachmentIDPlain};
                }
            }
        }
    }

    return %Attachments;
}

sub _ArticleDeleteDirectory {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ArticleID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # delete directory from fs
    my $ContentPath
        = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleGetContentPath( ArticleID => $Param{ArticleID} );
    my $Path = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}";
    if ( -d $Path ) {
        if ( !rmdir $Path ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't remove: $Path: $!!",
            );
            return;
        }
    }
    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
