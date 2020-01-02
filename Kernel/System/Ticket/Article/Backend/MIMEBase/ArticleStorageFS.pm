# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS;

use strict;
use warnings;

use File::Path qw();
use MIME::Base64 qw();
use Time::HiRes qw();
use Unicode::Normalize qw();

use parent qw(Kernel::System::Ticket::Article::Backend::MIMEBase::Base);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB',
);

=head1 NAME

Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS - FS based ticket article storage interface

=head1 DESCRIPTION

This class provides functions to manipulate ticket articles on the file system.
The methods are currently documented in L<Kernel::System::Ticket::Article::Backend::MIMEBase>.

Inherits from L<Kernel::System::Ticket::Article::Backend::MIMEBase::Base>.

See also L<Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB>.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Call new() on Base.pm to execute the common code.
    my $Self = $Type->SUPER::new(%Param);

    my $ArticleContentPath = $Self->BuildArticleContentPath();
    my $ArticleDir         = "$Self->{ArticleDataDir}/$ArticleContentPath/";

    File::Path::mkpath( $ArticleDir, 0, 0770 );    ## no critic

    # Check write permissions.
    if ( !-w $ArticleDir ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Can't write $ArticleDir! try: \$OTRS_HOME/bin/otrs.SetPermissions.pl!",
        );
        die "Can't write $ArticleDir! try: \$OTRS_HOME/bin/otrs.SetPermissions.pl!";
    }

    # Get activated cache backend configuration.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    return $Self if !$ConfigObject->Get('Cache::ArticleStorageCache');

    my $CacheModule = $ConfigObject->Get('Cache::Module') || '';
    return $Self if $CacheModule ne 'Kernel::System::Cache::MemcachedFast';

    # Turn on special cache used for speeding up article storage methods in huge systems with many
    #   nodes and slow FS access. It will be used only in environments with configured Memcached
    #   backend (see config above).
    $Self->{ArticleStorageCache}    = 1;
    $Self->{ArticleStorageCacheTTL} = $ConfigObject->Get('Cache::ArticleStorageCache::TTL') || 60 * 60 * 24;

    return $Self;
}

sub ArticleDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
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

    # delete storage directory
    $Self->_ArticleDeleteDirectory(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    # Delete special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'ArticleStorageFS_' . $Param{ArticleID},
        );
    }

    return 1;
}

sub ArticleDeletePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }

    # delete from fs
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
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

    # Delete special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'ArticleStorageFS_' . $Param{ArticleID},
            Key  => 'ArticlePlain',
        );
    }

    # return if only delete in my backend
    return 1 if $Param{OnlyMyBackend};

    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB')->ArticleDeletePlain(
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
                Message  => "Need $Item!",
            );
            return;
        }
    }

    # delete from fs
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my $Path = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}";

    if ( -e $Path ) {

        my @List = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $Path,
            Filter    => "*",
        );

        for my $File (@List) {

            if ( $File !~ /(\/|\\)plain.txt$/ ) {

                if ( !unlink "$File" ) {

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Can't remove: $File: $!!",
                    );
                }
            }
        }
    }

    # Delete special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'ArticleStorageFS_' . $Param{ArticleID},
        );
    }

    # return if only delete in my backend
    return 1 if $Param{OnlyMyBackend};

    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB')
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
                Message  => "Need $Item!",
            );
            return;
        }
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # define path
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my $Path = $Self->{ArticleDataDir} . '/' . $ContentPath . '/' . $Param{ArticleID};

    # debug
    if ( defined $Self->{Debug} && $Self->{Debug} > 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log( Message => "->WriteArticle: $Path" );
    }

    # write article to fs 1:1
    File::Path::mkpath( [$Path], 0, 0770 );    ## no critic

    # write article to fs
    my $Success = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location   => "$Path/plain.txt",
        Mode       => 'binmode',
        Content    => \$Param{Email},
        Permission => '660',
    );

    # Write to special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            TTL            => $Self->{ArticleStorageCacheTTL},
            Key            => 'ArticlePlain',
            Value          => $Param{Email},
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
    }

    return if !$Success;

    return 1;
}

sub ArticleWriteAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(Filename ContentType ArticleID UserID)) {
        if ( !IsStringWithData( $Param{$Item} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );

    # define path
    $Param{Path} = $Self->{ArticleDataDir} . '/' . $ContentPath . '/' . $Param{ArticleID};

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Perform FilenameCleanup here already to check for
    #   conflicting existing attachment files correctly
    $Param{Filename} = $MainObject->FilenameCleanUp(
        Filename => $Param{Filename},
        Type     => 'Local',
    );

    my $NewFileName = $Param{Filename};
    my %UsedFile;
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
    );

    # Normalize filenames to find file names which are identical but in a different unicode form.
    #   This is needed because Mac OS (HFS+) converts all filenames to NFD internally.
    #   Without this, the same file might be overwritten because the strings are not equal.
    for my $Position ( sort keys %Index ) {
        $UsedFile{ Unicode::Normalize::NFC( $Index{$Position}->{Filename} ) } = 1;
    }
    for ( my $i = 1; $i <= 50; $i++ ) {
        if ( exists $UsedFile{ Unicode::Normalize::NFC($NewFileName) } ) {
            if ( $Param{Filename} =~ /^(.*)\.(.+?)$/ ) {
                $NewFileName = "$1-$i.$2";
            }
            else {
                $NewFileName = "$Param{Filename}-$i";
            }
        }
    }

    $Param{Filename} = $NewFileName;

    # write attachment to backend
    if ( !-d $Param{Path} ) {
        if ( !File::Path::mkpath( [ $Param{Path} ], 0, 0770 ) ) {    ## no critic
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't create $Param{Path}: $!",
            );
            return;
        }
    }

    # write attachment content type to fs
    my $SuccessContentType = $MainObject->FileWrite(
        Directory       => $Param{Path},
        Filename        => "$Param{Filename}.content_type",
        Mode            => 'binmode',
        Content         => \$Param{ContentType},
        Permission      => 660,
        NoFilenameClean => 1,
    );
    return if !$SuccessContentType;

    # set content id in angle brackets
    if ( $Param{ContentID} ) {
        $Param{ContentID} =~ s/^([^<].*[^>])$/<$1>/;
    }

    # write attachment content id to fs
    if ( $Param{ContentID} ) {
        $MainObject->FileWrite(
            Directory       => $Param{Path},
            Filename        => "$Param{Filename}.content_id",
            Mode            => 'binmode',
            Content         => \$Param{ContentID},
            Permission      => 660,
            NoFilenameClean => 1,
        );
    }

    # write attachment content alternative to fs
    if ( $Param{ContentAlternative} ) {
        $MainObject->FileWrite(
            Directory       => $Param{Path},
            Filename        => "$Param{Filename}.content_alternative",
            Mode            => 'binmode',
            Content         => \$Param{ContentAlternative},
            Permission      => 660,
            NoFilenameClean => 1,
        );
    }

    # write attachment disposition to fs
    if ( $Param{Disposition} ) {

        my ( $Disposition, $FileName ) = split ';', $Param{Disposition};

        $MainObject->FileWrite(
            Directory       => $Param{Path},
            Filename        => "$Param{Filename}.disposition",
            Mode            => 'binmode',
            Content         => \$Disposition || '',
            Permission      => 660,
            NoFilenameClean => 1,
        );
    }

    # write attachment content to fs
    my $SuccessContent = $MainObject->FileWrite(
        Directory  => $Param{Path},
        Filename   => $Param{Filename},
        Mode       => 'binmode',
        Content    => \$Param{Content},
        Permission => 660,
    );

    return if !$SuccessContent;

    # Delete special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'ArticleStorageFS_' . $Param{ArticleID},
        );
    }

    return 1;
}

sub ArticlePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!',
        );
        return;
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Read from special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        my $Cache = $CacheObject->Get(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            Key            => 'ArticlePlain',
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );

        return $Cache if $Cache;
    }

    # get content path
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );

    # open plain article
    if ( -f "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt" ) {

        # read whole article
        my $Data = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Directory => "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/",
            Filename  => 'plain.txt',
            Mode      => 'binmode',
        );

        return if !$Data;

        # Write to special article storage cache.
        if ( $Self->{ArticleStorageCache} ) {
            $CacheObject->Set(
                Type           => 'ArticleStorageFS_' . $Param{ArticleID},
                TTL            => $Self->{ArticleStorageCacheTTL},
                Key            => 'ArticlePlain',
                Value          => ${$Data},
                CacheInMemory  => 0,
                CacheInBackend => 1,
            );
        }

        return ${$Data};
    }

    # return if we only need to check one backend
    return if !$Self->{CheckAllBackends};

    # return if only delete in my backend
    return if $Param{OnlyMyBackend};

    my $Data = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB')->ArticlePlain(
        %Param,
        OnlyMyBackend => 1,
    );

    # Write to special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $CacheObject->Set(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            TTL            => $Self->{ArticleStorageCacheTTL},
            Key            => 'ArticlePlain',
            Value          => $Data,
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
    }

    return $Data;
}

sub ArticleAttachmentIndexRaw {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!',
        );
        return;
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Read from special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        my $Cache = $CacheObject->Get(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            Key            => 'ArticleAttachmentIndexRaw',
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );

        return %{$Cache} if $Cache;
    }

    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my %Index;
    my $Counter = 0;

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # try fs
    my @List = $MainObject->DirectoryRead(
        Directory => "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}",
        Filter    => "*",
        Silent    => 1,
    );

    FILENAME:
    for my $Filename ( sort @List ) {
        my $FileSizeRaw = -s $Filename;

        # do not use control file
        next FILENAME if $Filename =~ /\.content_alternative$/;
        next FILENAME if $Filename =~ /\.content_id$/;
        next FILENAME if $Filename =~ /\.content_type$/;
        next FILENAME if $Filename =~ /\.disposition$/;
        next FILENAME if $Filename =~ /\/plain.txt$/;

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

            # alternative (optional)
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
                $Disposition = 'inline';
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
            if ( !$Content ) {
                return;
            }
            $ContentType = $Content->[0];
        }

        # strip filename
        $Filename =~ s!^.*/!!;

        # add the info the the hash
        $Counter++;
        $Index{$Counter} = {
            Filename           => $Filename,
            FilesizeRaw        => $FileSizeRaw,
            ContentType        => $ContentType,
            ContentID          => $ContentID,
            ContentAlternative => $Alternative,
            Disposition        => $Disposition,
        };
    }

    # Write to special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $CacheObject->Set(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            TTL            => $Self->{ArticleStorageCacheTTL},
            Key            => 'ArticleAttachmentIndexRaw',
            Value          => \%Index,
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
    }

    return %Index if %Index;

    # return if we only need to check one backend
    return if !$Self->{CheckAllBackends};

    # return if only delete in my backend
    return %Index if $Param{OnlyMyBackend};

    %Index = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB')
        ->ArticleAttachmentIndexRaw(
        %Param,
        OnlyMyBackend => 1,
        );

    # Write to special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $CacheObject->Set(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            TTL            => $Self->{ArticleStorageCacheTTL},
            Key            => 'ArticleAttachmentIndexRaw',
            Value          => \%Index,
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
    }

    return %Index;
}

sub ArticleAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID FileID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Read from special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        my $Cache = $CacheObject->Get(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            Key            => 'ArticleAttachment' . $Param{FileID},
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );

        return %{$Cache} if $Cache;
    }

    # get attachment index
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
    );

    # get content path
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my %Data    = %{ $Index{ $Param{FileID} } // {} };
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
            next FILENAME if $Filename =~ /\/plain.txt$/;
            next FILENAME if $Filename =~ /\.disposition$/;

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

                    # alternative (optional)
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
                        $Data{Disposition} = 'inline';
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

                # Write to special article storage cache.
                if ( $Self->{ArticleStorageCache} ) {
                    $CacheObject->Set(
                        Type           => 'ArticleStorageFS_' . $Param{ArticleID},
                        TTL            => $Self->{ArticleStorageCacheTTL},
                        Key            => 'ArticleAttachment' . $Param{FileID},
                        Value          => \%Data,
                        CacheInMemory  => 0,
                        CacheInBackend => 1,
                    );
                }

                return %Data;
            }
        }
    }

    # return if we only need to check one backend
    return if !$Self->{CheckAllBackends};

    # return if only delete in my backend
    return if $Param{OnlyMyBackend};

    %Data = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB')->ArticleAttachment(
        %Param,
        OnlyMyBackend => 1,
    );

    # Write to special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $CacheObject->Set(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            TTL            => $Self->{ArticleStorageCacheTTL},
            Key            => 'ArticleAttachment' . $Param{FileID},
            Value          => \%Data,
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
    }

    return %Data;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
