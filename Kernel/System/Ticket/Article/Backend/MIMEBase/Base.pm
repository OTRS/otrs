# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Article::Backend::MIMEBase::Base;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::Ticket::Article::Backend::MIMEBase::Base - base class for article storage modules

=head1 DESCRIPTION

This is a base class for article storage backends and should not be instantiated directly.

=head1 PUBLIC INTERFACE

=cut

=head2 new()

Don't instantiate this class directly, get instances of the real storage backends instead:

    my $BackendObject = $Kernel::OM->Get('Kernel::System::Article::Backend::MIMEBase::ArticleStorageDB');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'ArticleStorageBase';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    $Self->{ArticleDataDir}
        = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Article::Backend::MIMEBase::ArticleDataDir')
        || die 'Got no ArticleDataDir!';

    # do we need to check all backends, or just one?
    $Self->{CheckAllBackends}
        = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Article::Backend::MIMEBase::CheckAllStorageBackends')
        // 0;

    return $Self;
}

=head2 BuildArticleContentPath()

Generate a base article content path for article storage in the file system.

    my $ArticleContentPath = $BackendObject->BuildArticleContentPath();

=cut

sub BuildArticleContentPath {
    my ( $Self, %Param ) = @_;

    return $Self->{ArticleContentPath} if $Self->{ArticleContentPath};

    $Self->{ArticleContentPath} = $Kernel::OM->Create('Kernel::System::DateTime')->Format(
        Format => '%Y/%m/%d',
    );

    return $Self->{ArticleContentPath};
}

=head2 ArticleAttachmentIndex()

Get article attachment index as hash.

    my %Index = $BackendObject->ArticleAttachmentIndex(
        ArticleID        => 123,
        ExcludePlainText => 1,       # (optional) Exclude plain text attachment
        ExcludeHTMLBody  => 1,       # (optional) Exclude HTML body attachment
        ExcludeInline    => 1,       # (optional) Exclude inline attachments
        OnlyHTMLBody     => 1,       # (optional) Return only HTML body attachment, return nothing if not found
    );

Returns:

    my %Index = {
        '1' => {                                                # Attachment ID
            ContentAlternative => '',                           # (optional)
            ContentID          => '',                           # (optional)
            ContentType        => 'application/pdf',
            Filename           => 'StdAttachment-Test1.pdf',
            FilesizeRaw        => 4722,
            Disposition        => 'attachment',
        },
        '2' => {
            ContentAlternative => '',
            ContentID          => '',
            ContentType        => 'text/html; charset="utf-8"',
            Filename           => 'file-2',
            FilesizeRaw        => 183,
            Disposition        => 'attachment',
        },
        ...
    };

=cut

sub ArticleAttachmentIndex {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!',
        );
        return;
    }

    if ( $Param{ExcludeHTMLBody} && $Param{OnlyHTMLBody} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'ExcludeHTMLBody and OnlyHTMLBody cannot be used together!',
        );
        return;
    }

    # Get complete attachment index from backend.
    my %Attachments = $Self->ArticleAttachmentIndexRaw(%Param);

    # Iterate over attachments only if any of optional parameters is active.
    if ( $Param{ExcludePlainText} || $Param{ExcludeHTMLBody} || $Param{ExcludeInline} || $Param{OnlyHTMLBody} ) {

        my $AttachmentIDPlain = 0;
        my $AttachmentIDHTML  = 0;

        ATTACHMENT_ID:
        for my $AttachmentID ( sort keys %Attachments ) {
            my %File = %{ $Attachments{$AttachmentID} };

            # Identify plain text attachment.
            if (
                !$AttachmentIDPlain
                &&
                $File{Filename} eq 'file-1'
                && $File{ContentType} =~ /text\/plain/i
                && $File{Disposition} eq 'inline'
                )
            {
                $AttachmentIDPlain = $AttachmentID;
                next ATTACHMENT_ID;
            }

            # Identify html body attachment:
            #   - file-[12] is plain+html attachment
            #   - file-1.html is html attachment only
            if (
                !$AttachmentIDHTML
                &&
                ( $File{Filename} =~ /^file-[12]$/ || $File{Filename} eq 'file-1.html' )
                && $File{ContentType} =~ /text\/html/i
                && $File{Disposition} eq 'inline'
                )
            {
                $AttachmentIDHTML = $AttachmentID;
                next ATTACHMENT_ID;
            }
        }

        # If neither plain text or html body were found, iterate again to try to identify plain text among regular
        #   non-inline attachments.
        if ( !$AttachmentIDPlain && !$AttachmentIDHTML ) {
            ATTACHMENT_ID:
            for my $AttachmentID ( sort keys %Attachments ) {
                my %File = %{ $Attachments{$AttachmentID} };

                # Remember, file-1 got defined by parsing if no filename was given.
                if (
                    $File{Filename} eq 'file-1'
                    && $File{ContentType} =~ /text\/plain/i
                    )
                {
                    $AttachmentIDPlain = $AttachmentID;
                    last ATTACHMENT_ID;
                }
            }
        }

        # Identify inline (image) attachments which are referenced in HTML body. Do not strip attachments based on their
        #   disposition, since this method of detection is unreliable. Please see bug#13353 for more information.
        my @AttachmentIDsInline;

        if ($AttachmentIDHTML) {

            # Get HTML article body.
            my %HTMLBody = $Self->ArticleAttachment(
                ArticleID => $Param{ArticleID},
                FileID    => $AttachmentIDHTML,
            );

            if ( %HTMLBody && $HTMLBody{Content} ) {

                ATTACHMENT_ID:
                for my $AttachmentID ( sort keys %Attachments ) {
                    my %File = %{ $Attachments{$AttachmentID} };

                    next ATTACHMENT_ID if $File{ContentType} !~ m{image}ixms;
                    next ATTACHMENT_ID if !$File{ContentID};

                    my ($ImageID) = ( $File{ContentID} =~ m{^<(.*)>$}ixms );

                    # Search in the article body if there is any reference to it.
                    if ( $HTMLBody{Content} =~ m{<img.+src=['|"]cid:\Q$ImageID\E['|"].*>}ixms ) {
                        push @AttachmentIDsInline, $AttachmentID;
                    }
                }
            }
        }

        if ( $AttachmentIDPlain && $Param{ExcludePlainText} ) {
            delete $Attachments{$AttachmentIDPlain};
        }

        if ( $AttachmentIDHTML && $Param{ExcludeHTMLBody} ) {
            delete $Attachments{$AttachmentIDHTML};
        }

        if ( $Param{ExcludeInline} ) {
            for my $AttachmentID (@AttachmentIDsInline) {
                delete $Attachments{$AttachmentID};
            }
        }

        if ( $Param{OnlyHTMLBody} ) {
            if ($AttachmentIDHTML) {
                %Attachments = (
                    $AttachmentIDHTML => $Attachments{$AttachmentIDHTML}
                );
            }
            else {
                %Attachments = ();
            }
        }
    }

    return %Attachments;
}

=head1 PRIVATE FUNCTIONS

=cut

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
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my $Path = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}";
    if ( -d $Path ) {
        if ( !rmdir $Path ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't remove '$Path': $!.",
            );
            return;
        }
    }
    return 1;
}

=head2 _ArticleContentPathGet()

Get the stored content path of an article.

    my $Path = $BackendObject->_ArticleContentPatGeth(
        ArticleID => 123,
    );

=cut

sub _ArticleContentPathGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!',
        );
        return;
    }

    # check key
    my $CacheKey = '_ArticleContentPathGet::' . $Param{ArticleID};

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $Cache = $CacheObject->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql query
    return if !$DBObject->Prepare(
        SQL  => 'SELECT content_path FROM article_data_mime WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    my $Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result = $Row[0];
    }

    # set cache
    $CacheObject->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => $Result,
    );

    # return
    return $Result;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
