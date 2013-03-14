# --
# Kernel/System/Ticket/ArticleStorageDB.pm - article storage module for OTRS kernel
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

use vars qw($VERSION);

sub ArticleStorageInit {
    my ( $Self, %Param ) = @_;

    # ArticleDataDir
    $Self->{ArticleDataDir} = $Self->{ConfigObject}->Get('ArticleDir')
        || die 'Got no ArticleDir!';

    # create ArticleContentPath
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    $Self->{ArticleContentPath} = $Year . '/' . $Month . '/' . $Day;

    return 1;
}

sub ArticleDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $DynamicFieldListArticle = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        ObjectType => 'Article',
        Valid      => 0,
    );

    # delete dynamicfield values for this article
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicFieldListArticle} ) {

        next DYNAMICFIELD if !$DynamicFieldConfig;
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
        next DYNAMICFIELD if !IsHashRefWithData( $DynamicFieldConfig->{Config} );

        $Self->{DynamicFieldBackendObject}->ValueDelete(
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

    # delete article flags
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM article_flag WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # delete article history entries
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ticket_history WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # delete storage directory
    $Self->_ArticleDeleteDirectory(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    # delete articles
    return if !$Self->{DBObject}->Do(
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete attachments
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM article_plain WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # return of only delete in my backend
    return 1 if $Param{OnlyMyBackend};

    # delete from fs
    my $ContentPath = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} );
    my $File = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt";
    if ( -f $File ) {
        if ( !unlink $File ) {
            $Self->{LogObject}->Log(
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete attachments
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM article_attachment WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # return if only delete in my backend
    return 1 if $Param{OnlyMyBackend};

    # delete from fs
    my $ContentPath = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} );
    my $Path = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}";
    if ( -e $Path ) {
        my @List = $Self->{MainObject}->DirectoryRead(
            Directory => $Path,
            Filter    => "*",
        );
        for my $File (@List) {
            if ( $File !~ /(\/|\\)plain.txt$/ ) {
                if ( !unlink $File ) {
                    $Self->{LogObject}->Log(
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # encode attachment if it's a postgresql backend!!!
    if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Email} );
        $Param{Email} = encode_base64( $Param{Email} );
    }

    # write article to db 1:1
    return if !$Self->{DBObject}->Do(
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
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

    # encode attachment if it's a postgresql backend!!!
    if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Content} );
        $Param{Content} = encode_base64( $Param{Content} );
    }

    # set content id in angle brackets
    if ( $Param{ContentID} ) {
        $Param{ContentID} =~ s/^([^<].*[^>])$/<$1>/;
    }

    # write attachment to db
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO article_attachment '
            . ' (article_id, filename, content_type, content_size, content, '
            . ' content_id, content_alternative, create_time, create_by, change_time, change_by) '
            . ' VALUES (?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{ArticleID}, \$Param{Filename}, \$Param{ContentType}, \$Param{Filesize},
            \$Param{Content}, \$Param{ContentID}, \$Param{ContentAlternative},
            \$Param{UserID}, \$Param{UserID},
        ],
    );
    return 1;
}

sub ArticlePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ArticleID!" );
        return;
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # can't open article, try database
    return if !$Self->{DBObject}->Prepare(
        SQL    => 'SELECT body FROM article_plain WHERE article_id = ?',
        Bind   => [ \$Param{ArticleID} ],
        Encode => [0],
    );
    my $Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # decode attachment if it's e. g. a postgresql backend!!!
        if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') && $Row[0] !~ / / ) {
            $Data = decode_base64( $Row[0] );
        }
        else {
            $Data = $Row[0];
        }
    }
    return $Data if defined $Data;

    # return of only delete in my backend
    return if $Param{OnlyMyBackend};

    # try fs backend
    my $ContentPath = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} );
    if ( -f "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt" ) {

        # read whole article
        my $Data = $Self->{MainObject}->FileRead(
            Directory => "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/",
            Filename  => 'plain.txt',
            Mode      => 'binmode',
        );
        if ( !$Data ) {
            return;
        }
        return ${$Data};
    }

    # log info
    $Self->{LogObject}->Log(
        Priority => 'error',
        Message  => "No plain article (article id $Param{ArticleID}) in database!",
    );
    return;
}

sub ArticleAttachmentIndexRaw {
    my ( $Self, %Param ) = @_;

    # check ArticleContentPath
    if ( !$Self->{ArticleContentPath} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ArticleContentPath!' );
        return;
    }

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ArticleID!' );
        return;
    }

    # get ContentPath if not given
    if ( !$Param{ContentPath} ) {
        $Param{ContentPath} = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} ) || '';
    }
    my %Index;
    my $Counter = 0;

    # try database
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT filename, content_type, content_size, content_id, content_alternative'
            . ' FROM article_attachment WHERE article_id = ? ORDER BY filename, id',
        Bind => [ \$Param{ArticleID} ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

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

        # add the info the the hash
        $Counter++;
        $Index{$Counter} = {
            Filename           => $Row[0],
            Filesize           => $Row[2] || '',
            FilesizeRaw        => $FileSizeRaw || 0,
            ContentType        => $Row[1],
            ContentID          => $Row[3] || '',
            ContentAlternative => $Row[4] || '',
        };
    }

    # return existing index
    return %Index if %Index;

    # return of only delete in my backend
    return if $Param{OnlyMyBackend};

    # try fs (if there is no index in fs)
    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => "$Self->{ArticleDataDir}/$Param{ContentPath}/$Param{ArticleID}",
        Filter    => "*",
        Silent    => 1,
    );

    for my $Filename ( sort @List ) {
        my $FileSize    = -s $Filename;
        my $FileSizeRaw = $FileSize;

        # do not use control file
        next if $Filename =~ /\.content_alternative$/;
        next if $Filename =~ /\.content_id$/;
        next if $Filename =~ /\.content_type$/;
        next if $Filename =~ /\/plain.txt$/;

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
        if ( -e "$Filename.content_type" ) {
            my $Content = $Self->{MainObject}->FileRead(
                Location => "$Filename.content_type",
            );
            return if !$Content;
            $ContentType = ${$Content};

            # content id (optional)
            if ( -e "$Filename.content_id" ) {
                my $Content = $Self->{MainObject}->FileRead(
                    Location => "$Filename.content_id",
                );
                if ($Content) {
                    $ContentID = ${$Content};
                }
            }

            # alternativ (optional)
            if ( -e "$Filename.content_alternative" ) {
                my $Content = $Self->{MainObject}->FileRead(
                    Location => "$Filename.content_alternative",
                );
                if ($Content) {
                    $Alternative = ${$Content};
                }
            }
        }

        # read content type (old style)
        else {
            my $Content = $Self->{MainObject}->FileRead(
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
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

    # try database
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT content_type, content, content_id, content_alternative'
            . ' FROM article_attachment WHERE article_id = ? ORDER BY filename, id',
        Bind   => [ \$Param{ArticleID} ],
        Limit  => $Param{FileID},
        Encode => [ 1, 0, 0, 0 ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ContentType} = $Row[0];

        # decode attachment if it's e. g. a postgresql backend!!!
        if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
            $Data{Content} = decode_base64( $Row[1] );
        }
        else {
            $Data{Content} = $Row[1];
        }
        $Data{ContentID}          = $Row[2];
        $Data{ContentAlternative} = $Row[3];
    }
    return %Data if defined $Data{Content};

    # return of only delete in my backend
    return if $Param{OnlyMyBackend};

    # try fileystem, if no content is found
    my $ContentPath = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} );
    my $Counter = 0;

    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}",
        Filter    => "*",
        Silent    => 1,
    );

    if (@List) {
        for my $Filename (@List) {
            next if $Filename =~ /\.content_alternative$/;
            next if $Filename =~ /\.content_id$/;
            next if $Filename =~ /\.content_type$/;
            next if $Filename =~ /\/plain.txt$/;

            # add the info the the hash
            $Counter++;
            if ( $Counter == $Param{FileID} ) {

                if ( -e "$Filename.content_type" ) {

                    # read content type
                    my $Content = $Self->{MainObject}->FileRead(
                        Location => "$Filename.content_type",
                    );
                    return if !$Content;
                    $Data{ContentType} = ${$Content};

                    # read content
                    $Content = $Self->{MainObject}->FileRead(
                        Location => $Filename,
                        Mode     => 'binmode',
                    );
                    return if !$Content;
                    $Data{Content} = ${$Content};

                    # content id (optional)
                    if ( -e "$Filename.content_id" ) {
                        my $Content = $Self->{MainObject}->FileRead(
                            Location => "$Filename.content_id",
                        );
                        if ($Content) {
                            $Data{ContentID} = ${$Content};
                        }
                    }

                    # alternativ (optional)
                    if ( -e "$Filename.content_alternative" ) {
                        my $Content = $Self->{MainObject}->FileRead(
                            Location => "$Filename.content_alternative",
                        );
                        if ($Content) {
                            $Data{Alternative} = ${$Content};
                        }
                    }
                }
                else {

                    # read content
                    my $Content = $Self->{MainObject}->FileRead(
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
                    $Self->{EncodeObject}->EncodeInput( \$Data{Content} );
                }
                chomp $Data{ContentType};
                return %Data;
            }
        }
    }

    if ( !$Data{Content} ) {
        $Self->{LogObject}->Log(
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete directory from fs
    my $ContentPath = $Self->ArticleGetContentPath( ArticleID => $Param{ArticleID} );
    my $Path = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}";
    if ( -d $Path ) {
        if ( !rmdir $Path ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't remove: $Path: $!!",
            );
            return;
        }
    }
    return 1;
}

1;
