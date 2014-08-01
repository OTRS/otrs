# --
# Kernel/System/Ticket/ArticleStorageDB.pm - article storage module for OTRS kernel
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::ArticleStorageDB;

use strict;
use warnings;

use MIME::Base64;
use MIME::Words qw(:all);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Time',
);
our $ObjectManagerAware = 1;

sub ArticleStorageInit {
    my ( $Self, %Param ) = @_;

    # ArticleDataDir
    $Self->{ArticleDataDir} = $Kernel::OM->Get('Kernel::Config')->Get('ArticleDir')
        || die 'Got no ArticleDir!';

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # create ArticleContentPath
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );
    $Self->{ArticleContentPath} = $Year . '/' . $Month . '/' . $Day;

    return 1;
}

sub ArticleDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $DynamicFieldListArticle = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'Article',
        Valid      => 0,
    );

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # delete dynamicfield values for this article
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicFieldListArticle} ) {

        next DYNAMICFIELD if !$DynamicFieldConfig;
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
        next DYNAMICFIELD if !IsHashRefWithData( $DynamicFieldConfig->{Config} );

        $DynamicFieldBackendObject->ValueDelete(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Param{ArticleID},
            UserID             => $Param{UserID},
        );
    }

    # delete index
    $Self->ArticleIndexDelete(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    # delete time accounting
    $Self->ArticleAccountedTimeDelete(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

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

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # delete article flags
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM article_flag WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # delete article history entries
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM ticket_history WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # delete storage directory
    $Self->_ArticleDeleteDirectory(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    # delete articles
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM article WHERE id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    return 1;
}

sub ArticleDeletePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete attachments
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM article_plain WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # return if we only need to check one backend
    return 1 if !$Self->{CheckAllBackends};

    # return of only delete in my backend
    return 1 if $Param{OnlyMyBackend};

    # delete from fs
    my $ContentPath = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} );
    my $File = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt";
    if ( -f $File ) {
        if ( !unlink $File ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't remove: $File: $!!",
            );
            return;
        }
    }
    return 1;
}

sub ArticleDeleteAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete attachments
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM article_attachment WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # return if we only need to check one backend
    return 1 if !$Self->{CheckAllBackends};

    # return if only delete in my backend
    return 1 if $Param{OnlyMyBackend};

    # delete from fs
    my $ContentPath = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} );
    my $Path = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}";

    if ( -e $Path ) {

        my @List = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $Path,
            Filter    => "*",
        );

        for my $File (@List) {

            if ( $File !~ /(\/|\\)plain.txt$/ ) {

                if ( !unlink $File ) {

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Can't remove: $File: $!!",
                    );
                }
            }
        }
    }

    return 1;
}

sub ArticleWritePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID Email UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_!" );
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
        SQL => 'INSERT INTO article_plain '
            . ' (article_id, body, create_time, create_by, change_time, change_by) '
            . ' VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [ \$Param{ArticleID}, \$Param{Email}, \$Param{UserID}, \$Param{UserID} ],
    );

    return 1;
}

sub ArticleWriteAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Content Filename ContentType ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $NewFileName = $Param{Filename};
    my %UsedFile;
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    if ( !$Param{Force} ) {
        for ( sort keys %Index ) {
            $UsedFile{ $Index{$_}->{Filename} } = 1;
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
            INSERT INTO article_attachment (article_id, filename, content_type, content_size,
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
        $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need ArticleID!" );
        return;
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # can't open article, try database
    return if !$DBObject->Prepare(
        SQL    => 'SELECT body FROM article_plain WHERE article_id = ?',
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

    # try fs backend
    my $ContentPath = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} );
    if ( -f "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt" ) {

        # read whole article
        my $Data = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Directory => "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/",
            Filename  => 'plain.txt',
            Mode      => 'binmode',
        );

        return if !$Data;

        return ${$Data};
    }

    # log info
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "No plain article (article id $Param{ArticleID}) in database!",
    );
    return;
}

sub ArticleAttachmentIndexRaw {
    my ( $Self, %Param ) = @_;

    # check ArticleContentPath
    if ( !$Self->{ArticleContentPath} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => 'Need ArticleContentPath!' );
        return;
    }

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => 'Need ArticleID!' );
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
            FROM article_attachment
            WHERE article_id = ?
            ORDER BY filename, id',
        Bind => [ \$Param{ArticleID} ],
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {

        # human readable file size
        my $FileSizeRaw = $Row[2];
        if ( $Row[2] ) {
            if ( $Row[2] > ( 1024 * 1024 ) ) {
                $Row[2] = sprintf "%.1f MBytes", ( $Row[2] / ( 1024 * 1024 ) );
            }
            elsif ( $Row[2] > 1024 ) {
                $Row[2] = sprintf "%.1f KBytes", ( ( $Row[2] / 1024 ) );
            }
            else {
                $Row[2] = $Row[2] . ' Bytes';
            }
        }

        my $Disposition = $Row[5];
        if ( !$Disposition ) {

            # if no content disposition is set images with content id should be inline
            if ( $Row[3] && $Row[1] =~ m{image}i ) {
                $Disposition = 'inline';
            }

            # converted article body should be inline
            elsif ( $Row[0] =~ m{file-[12]} ) {
                $Disposition = 'inline'
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
            Filesize           => $Row[2] || '',
            FilesizeRaw        => $FileSizeRaw || 0,
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

    # get ContentPath if not given
    if ( !$Param{ContentPath} ) {
        $Param{ContentPath} = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} ) || '';
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # try fs (if there is no index in fs)
    my @List = $MainObject->DirectoryRead(
        Directory => "$Self->{ArticleDataDir}/$Param{ContentPath}/$Param{ArticleID}",
        Filter    => "*",
        Silent    => 1,
    );

    FILENAME:
    for my $Filename ( sort @List ) {
        my $FileSize    = -s $Filename;
        my $FileSizeRaw = $FileSize;

        # do not use control file
        next FILENAME if $Filename =~ /\.content_alternative$/;
        next FILENAME if $Filename =~ /\.content_id$/;
        next FILENAME if $Filename =~ /\.content_type$/;
        next FILENAME if $Filename =~ /\.disposition$/;
        next FILENAME if $Filename =~ /\/plain.txt$/;

        # human readable file size
        if ($FileSize) {
            if ( $FileSize > ( 1024 * 1024 ) ) {
                $FileSize = sprintf "%.1f MBytes", ( $FileSize / ( 1024 * 1024 ) );
            }
            elsif ( $FileSize > 1024 ) {
                $FileSize = sprintf "%.1f KBytes", ( ( $FileSize / 1024 ) );
            }
            else {
                $FileSize = $FileSize . ' Bytes';
            }
        }

        # read content type
        my $ContentType = '';
        my $ContentID   = '';
        my $Alternative = '';
        my $Disposition = '';
        if ( -e "$Filename.content_type" ) {
            my $Content = $MainObject->FileRead(
                Location => "$Filename.content_type",
            );
            return if !$Content;
            $ContentType = ${$Content};

            # content id (optional)
            if ( -e "$Filename.content_id" ) {
                my $Content = $MainObject->FileRead(
                    Location => "$Filename.content_id",
                );
                if ($Content) {
                    $ContentID = ${$Content};
                }
            }

            # alternativ (optional)
            if ( -e "$Filename.content_alternative" ) {
                my $Content = $MainObject->FileRead(
                    Location => "$Filename.content_alternative",
                );
                if ($Content) {
                    $Alternative = ${$Content};
                }
            }

            # disposition
            if ( -e "$Filename.disposition" ) {
                my $Content = $MainObject->FileRead(
                    Location => "$Filename.disposition",
                );
                if ($Content) {
                    $Disposition = ${$Content};
                }
            }

            # if no content disposition is set images with content id should be inline
            elsif ( $ContentID && $ContentType =~ m{image}i ) {
                $Disposition = 'inline';
            }

            # converted article body should be inline
            elsif ( $Filename =~ m{file-[12]} ) {
                $Disposition = 'inline'
            }

            # all others including attachments with content id that are not images
            #   should NOT be inline
            else {
                $Disposition = 'attachment';
            }
        }

        # read content type (old style)
        else {
            my $Content = $MainObject->FileRead(
                Location => $Filename,
                Result   => 'ARRAY',
            );
            return if !$Content;
            $ContentType = $Content->[0];
        }

        # strip filename
        $Filename =~ s!^.*/!!;

        # add the info the the hash
        $Counter++;
        $Index{$Counter} = {
            Filename           => $Filename,
            Filesize           => $FileSize,
            FilesizeRaw        => $FileSizeRaw,
            ContentType        => $ContentType,
            ContentID          => $ContentID,
            ContentAlternative => $Alternative,
        };
    }
    return %Index;
}

sub ArticleAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID FileID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # get attachment index
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    return if !$Index{ $Param{FileID} };
    my %Data = %{ $Index{ $Param{FileID} } };

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # try database
    return if !$DBObject->Prepare(
        SQL => '
            SELECT content_type, content, content_id, content_alternative, disposition, filename
            FROM article_attachment
            WHERE article_id = ?
            ORDER BY filename, id',
        Bind   => [ \$Param{ArticleID} ],
        Limit  => $Param{FileID},
        Encode => [ 1, 0, 0, 0 ],
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
            $Data{Disposition} = 'inline'
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

    # try fileystem, if no content is found
    my $ContentPath = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} );
    my $Counter = 0;

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @List = $MainObject->DirectoryRead(
        Directory => "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}",
        Filter    => "*",
        Silent    => 1,
    );

    if (@List) {

        # get encode object
        my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

        FILENAME:
        for my $Filename (@List) {
            next FILENAME if $Filename =~ /\.content_alternative$/;
            next FILENAME if $Filename =~ /\.content_id$/;
            next FILENAME if $Filename =~ /\.content_type$/;
            next FILENAME if $Filename =~ /\.disposition$/;
            next FILENAME if $Filename =~ /\/plain.txt$/;

            # add the info the the hash
            $Counter++;
            if ( $Counter == $Param{FileID} ) {

                if ( -e "$Filename.content_type" ) {

                    # read content type
                    my $Content = $MainObject->FileRead(
                        Location => "$Filename.content_type",
                    );
                    return if !$Content;
                    $Data{ContentType} = ${$Content};

                    # read content
                    $Content = $MainObject->FileRead(
                        Location => $Filename,
                        Mode     => 'binmode',
                    );
                    return if !$Content;
                    $Data{Content} = ${$Content};

                    # content id (optional)
                    if ( -e "$Filename.content_id" ) {
                        my $Content = $MainObject->FileRead(
                            Location => "$Filename.content_id",
                        );
                        if ($Content) {
                            $Data{ContentID} = ${$Content};
                        }
                    }

                    # alternativ (optional)
                    if ( -e "$Filename.content_alternative" ) {
                        my $Content = $MainObject->FileRead(
                            Location => "$Filename.content_alternative",
                        );
                        if ($Content) {
                            $Data{Alternative} = ${$Content};
                        }
                    }

                    # disposition
                    if ( -e "$Filename.disposition" ) {
                        my $Content = $MainObject->FileRead(
                            Location => "$Filename.disposition",
                        );
                        if ($Content) {
                            $Data{Disposition} = ${$Content};
                        }
                    }

                    # if no content disposition is set images with content id should be inline
                    elsif ( $Data{ContentID} && $Data{ContentType} =~ m{image}i ) {
                        $Data{Disposition} = 'inline';
                    }

                    # converted article body should be inline
                    elsif ( $Filename =~ m{file-[12]} ) {
                        $Data{Disposition} = 'inline'
                    }

                    # all others including attachments with content id that are not images
                    #   should NOT be inline
                    else {
                        $Data{Disposition} = 'attachment';
                    }
                }
                else {

                    # read content
                    my $Content = $MainObject->FileRead(
                        Location => $Filename,
                        Mode     => 'binmode',
                        Result   => 'ARRAY',
                    );
                    return if !$Content;
                    $Data{ContentType} = $Content->[0];
                    my $Counter = 0;
                    for my $Line ( @{$Content} ) {
                        if ($Counter) {
                            $Data{Content} .= $Line;
                        }
                        $Counter++;
                    }
                }
                if (
                    $Data{ContentType} =~ /plain\/text/i
                    && $Data{ContentType} =~ /(utf\-8|utf8)/i
                    )
                {
                    $EncodeObject->EncodeInput( \$Data{Content} );
                }

                chomp $Data{ContentType};

                return %Data;
            }
        }
    }

    if ( !$Data{Content} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "No article attachment (article id $Param{ArticleID}, file id $Param{FileID}) in database!",
        );
        return;
    }

    return %Data;
}

sub _ArticleDeleteDirectory {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete directory from fs
    my $ContentPath = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} );
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
