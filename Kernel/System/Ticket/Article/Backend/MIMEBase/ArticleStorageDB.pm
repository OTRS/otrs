# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB;

use strict;
use warnings;

use MIME::Base64;
use MIME::Words qw(:all);

use parent qw(Kernel::System::Ticket::Article::Backend::MIMEBase::Base);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS',
);

=head1 NAME

Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB - DB based ticket article storage interface

=head1 DESCRIPTION

This class provides functions to manipulate ticket articles in the database.
The methods are currently documented in L<Kernel::System::Ticket::Article::Backend::MIMEBase>.

Inherits from L<Kernel::System::Ticket::Article::Backend::MIMEBase::Base>.

See also L<Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS>.

=cut

sub ArticleDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!"
            );
            return;
        }
    }

    # delete attachments
    $Self->ArticleDeleteAttachment(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    # delete plain message
    $Self->ArticleDeletePlain(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    # Delete storage directory in case there are leftovers in the FS.
    $Self->_ArticleDeleteDirectory(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    return 1;
}

sub ArticleDeletePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!"
            );
            return;
        }
    }

    # delete attachments
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM article_data_mime_plain WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # return if we only need to check one backend
    return 1 if !$Self->{CheckAllBackends};

    # return of only delete in my backend
    return 1 if $Param{OnlyMyBackend};

    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS')->ArticleDeletePlain(
        %Param,
        OnlyMyBackend => 1,
    );
}

sub ArticleDeleteAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!"
            );
            return;
        }
    }

    # delete attachments
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM article_data_mime_attachment WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # return if we only need to check one backend
    return 1 if !$Self->{CheckAllBackends};

    # return if only delete in my backend
    return 1 if $Param{OnlyMyBackend};

    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS')
        ->ArticleDeleteAttachment(
        %Param,
        OnlyMyBackend => 1,
        );
}

sub ArticleWritePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID Email UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # encode attachment if it's a postgresql backend!!!
    if ( !$DBObject->GetDatabaseFunction('DirectBlob') ) {

        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Param{Email} );

        $Param{Email} = encode_base64( $Param{Email} );
    }

    # write article to db 1:1
    return if !$DBObject->Do(
        SQL => 'INSERT INTO article_data_mime_plain '
            . ' (article_id, body, create_time, create_by, change_time, change_by) '
            . ' VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [ \$Param{ArticleID}, \$Param{Email}, \$Param{UserID}, \$Param{UserID} ],
    );

    return 1;
}

sub ArticleWriteAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(Filename ContentType ArticleID UserID)) {
        if ( !IsStringWithData( $Param{$Item} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!"
            );
            return;
        }
    }

    $Param{Filename} = $Kernel::OM->Get('Kernel::System::Main')->FilenameCleanUp(
        Filename  => $Param{Filename},
        Type      => 'Local',
        NoReplace => 1,
    );

    my $NewFileName = $Param{Filename};
    my %UsedFile;
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
    );

    for my $IndexFile ( sort keys %Index ) {
        $UsedFile{ $Index{$IndexFile}->{Filename} } = 1;
    }
    for ( my $i = 1; $i <= 50; $i++ ) {
        if ( exists $UsedFile{$NewFileName} ) {
            if ( $Param{Filename} =~ /^(.*)\.(.+?)$/ ) {
                $NewFileName = "$1-$i.$2";
            }
            else {
                $NewFileName = "$Param{Filename}-$i";
            }
        }
    }

    # get file name
    $Param{Filename} = $NewFileName;

    # get attachment size
    $Param{Filesize} = bytes::length( $Param{Content} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # encode attachment if it's a postgresql backend!!!
    if ( !$DBObject->GetDatabaseFunction('DirectBlob') ) {

        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Param{Content} );

        $Param{Content} = encode_base64( $Param{Content} );
    }

    # set content id in angle brackets
    if ( $Param{ContentID} ) {
        $Param{ContentID} =~ s/^([^<].*[^>])$/<$1>/;
    }

    my $Disposition;
    my $Filename;
    if ( $Param{Disposition} ) {
        ( $Disposition, $Filename ) = split ';', $Param{Disposition};
    }
    $Disposition //= '';

    # write attachment to db
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO article_data_mime_attachment (article_id, filename, content_type, content_size,
                content, content_id, content_alternative, disposition, create_time, create_by,
                change_time, change_by)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{ArticleID}, \$Param{Filename}, \$Param{ContentType}, \$Param{Filesize},
            \$Param{Content}, \$Param{ContentID}, \$Param{ContentAlternative},
            \$Disposition, \$Param{UserID}, \$Param{UserID},
        ],
    );
    return 1;
}

sub ArticlePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need ArticleID!"
        );
        return;
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # can't open article, try database
    return if !$DBObject->Prepare(
        SQL    => 'SELECT body FROM article_data_mime_plain WHERE article_id = ?',
        Bind   => [ \$Param{ArticleID} ],
        Encode => [0],
    );

    my $Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # decode attachment if it's e. g. a postgresql backend!!!
        if ( !$DBObject->GetDatabaseFunction('DirectBlob') && $Row[0] !~ m/ / ) {
            $Data = decode_base64( $Row[0] );
        }
        else {
            $Data = $Row[0];
        }
    }
    return $Data if defined $Data;

    # return if we only need to check one backend
    return if !$Self->{CheckAllBackends};

    # return of only delete in my backend
    return if $Param{OnlyMyBackend};

    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS')->ArticlePlain(
        %Param,
        OnlyMyBackend => 1,
    );
}

sub ArticleAttachmentIndexRaw {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!'
        );
        return;
    }

    my %Index;
    my $Counter = 0;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # try database
    return if !$DBObject->Prepare(
        SQL => '
            SELECT filename, content_type, content_size, content_id, content_alternative,
                disposition
            FROM article_data_mime_attachment
            WHERE article_id = ?
            ORDER BY filename, id',
        Bind => [ \$Param{ArticleID} ],
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {

        my $Disposition = $Row[5];
        if ( !$Disposition ) {

            # if no content disposition is set images with content id should be inline
            if ( $Row[3] && $Row[1] =~ m{image}i ) {
                $Disposition = 'inline';
            }

            # converted article body should be inline
            elsif ( $Row[0] =~ m{file-[12]} ) {
                $Disposition = 'inline';
            }

            # all others including attachments with content id that are not images
            #   should NOT be inline
            else {
                $Disposition = 'attachment';
            }
        }

        # add the info the the hash
        $Counter++;
        $Index{$Counter} = {
            Filename           => $Row[0],
            FilesizeRaw        => $Row[2] || 0,
            ContentType        => $Row[1],
            ContentID          => $Row[3] || '',
            ContentAlternative => $Row[4] || '',
            Disposition        => $Disposition,
        };
    }

    # return existing index
    return %Index if %Index;

    # return if we only need to check one backend
    return if !$Self->{CheckAllBackends};

    # return if only delete in my backend
    return if $Param{OnlyMyBackend};

    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS')
        ->ArticleAttachmentIndexRaw(
        %Param,
        OnlyMyBackend => 1,
        );
}

sub ArticleAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID FileID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!"
            );
            return;
        }
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # get attachment index
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
    );

    return if !$Index{ $Param{FileID} };
    my %Data = %{ $Index{ $Param{FileID} } };

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # try database
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id
            FROM article_data_mime_attachment
            WHERE article_id = ?
            ORDER BY filename, id',
        Bind  => [ \$Param{ArticleID} ],
        Limit => $Param{FileID},
    );

    my $AttachmentID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $AttachmentID = $Row[0];
    }

    return if !$DBObject->Prepare(
        SQL => '
            SELECT content_type, content, content_id, content_alternative, disposition, filename
            FROM article_data_mime_attachment
            WHERE id = ?',
        Bind   => [ \$AttachmentID ],
        Encode => [ 1, 0, 0, 0, 1, 1 ],
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {

        $Data{ContentType} = $Row[0];

        # decode attachment if it's e. g. a postgresql backend!!!
        if ( !$DBObject->GetDatabaseFunction('DirectBlob') ) {
            $Data{Content} = decode_base64( $Row[1] );
        }
        else {
            $Data{Content} = $Row[1];
        }
        $Data{ContentID}          = $Row[2] || '';
        $Data{ContentAlternative} = $Row[3] || '';
        $Data{Disposition}        = $Row[4];
        $Data{Filename}           = $Row[5];
    }

    if ( !$Data{Disposition} ) {

        # if no content disposition is set images with content id should be inline
        if ( $Data{ContentID} && $Data{ContentType} =~ m{image}i ) {
            $Data{Disposition} = 'inline';
        }

        # converted article body should be inline
        elsif ( $Data{Filename} =~ m{file-[12]} ) {
            $Data{Disposition} = 'inline';
        }

        # all others including attachments with content id that are not images
        #   should NOT be inline
        else {
            $Data{Disposition} = 'attachment';
        }
    }

    return %Data if defined $Data{Content};

    # return if we only need to check one backend
    return if !$Self->{CheckAllBackends};

    # return if only delete in my backend
    return if $Param{OnlyMyBackend};

    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS')->ArticleAttachment(
        %Param,
        OnlyMyBackend => 1,
    );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
