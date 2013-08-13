# --
# Kernel/System/Loader.pm - CSS/JavaScript loader backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Loader;

use strict;
use warnings;

use vars qw(@ISA);

use Kernel::System::CacheInternal;

use CSS::Minifier qw();
use JavaScript::Minifier qw();

=head1 NAME

Kernel::System::Loader - CSS/JavaScript loader backend

=head1 SYNOPSIS

All valid functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Loader;
    use Kernel::System::Main;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $LoaderObject = Kernel::System::Loader->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject EncodeObject LogObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'Loader',
        TTL  => 60 * 60 * 24 * 3,
    );

    return $Self;
}

=item MinifyFiles()

takes a list of files and returns a filename in the target directory
which holds the minified and concatenated content of the files.
Uses caching internally.

    my $TargetFilename = $LoaderObject->MinifyFiles(
        List  => [
            $Filename,
            $Filename2,
        ],
        Type                 => 'CSS',      # CSS | JavaScript
        TargetDirectory      => $TargetDirectory,
        TargetFilenamePrefix => 'CommonCSS',    # optional, prefix for the target filename
    );

=cut

sub MinifyFiles {
    my ( $Self, %Param ) = @_;

    # check needed params
    my $List = $Param{List};
    if ( ref $List ne 'ARRAY' || !@{$List} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need List!',
        );
        return;
    }

    my $TargetDirectory = $Param{TargetDirectory};
    if ( !-e $TargetDirectory ) {
        if ( !mkdir( $TargetDirectory, 0775 ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't create directory '$TargetDirectory': $!",
            );
            return;
        }
    }

    if ( !$TargetDirectory || !-d $TargetDirectory ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need valid TargetDirectory, got '$TargetDirectory'!",
        );
        return;
    }

    my $TargetFilenamePrefix = $Param{TargetFilenamePrefix} ? "$Param{TargetFilenamePrefix}_" : '';

    my %ValidTypeParams = (
        CSS        => 1,
        JavaScript => 1,
    );

    if ( !$Param{Type} || !$ValidTypeParams{ $Param{Type} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need Type! Must be one of '" . join( ', ', keys %ValidTypeParams ) . "'."
        );
        return;
    }

    my $FileString;
    for my $Location ( @{$List} ) {
        if ( !-e $Location ) {
            next;
        }
        my $FileMTime = $Self->{MainObject}->FileGetMTime(
            Location => $Location
        );

        # For the caching, use both filename and mtime to make sure that
        #   caches are correctly regenerated on changes.
        $FileString .= "$Location:$FileMTime:";
    }

    # also include the config timestamp in the caching to reload the data on config changes
    my $ConfigTimestamp = $Self->{ConfigObject}->ConfigChecksum();

    $FileString .= $ConfigTimestamp;

    my $Filename = $TargetFilenamePrefix . $Self->{MainObject}->MD5sum(
        String => \$FileString,
    );

    if ( $Param{Type} eq 'CSS' ) {
        $Filename .= '.css';
    }
    elsif ( $Param{Type} eq 'JavaScript' ) {
        $Filename .= '.js';

    }

    if ( !-r "$TargetDirectory/$Filename" ) {

        my $Content;

        # no cache available, so loop through all files, get minified version and concatenate
        LOCATION: for my $Location ( @{$List} ) {

            next LOCATION if ( !-r $Location );

            # cut out the system specific parts for the comments (for easier testing)
            # for now, only keep filename
            my $Label = $Location;
            $Label =~ s{^.*/}{}smx;

            if ( $Param{Type} eq 'CSS' ) {
                $Content .= "/* begin $Label */\n";

                eval {
                    $Content .= $Self->GetMinifiedFile(
                        Location => $Location,
                        Type     => $Param{Type},
                    );
                };

                if ($@) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "Error during file minification: $@",
                    );
                }

                $Content .= "\n/* end $Label */\n";
            }
            elsif ( $Param{Type} eq 'JavaScript' ) {
                $Content .= "// begin $Label\n";

                eval {
                    $Content .= $Self->GetMinifiedFile(
                        Location => $Location,
                        Type     => $Param{Type},
                    );
                };

                if ($@) {
                    my $JSError = "Error during minification of file $Location: $@";
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => $JSError,
                    );
                    $JSError =~ s/'/\\'/gsmx;
                    $JSError =~ s/\r?\n/ /gsmx;
                    $Content .= "alert('$JSError');";
                }

                $Content .= "\n// end $Label\n";
            }
        }

        my $FileLocation = $Self->{MainObject}->FileWrite(
            Directory => $TargetDirectory,
            Filename  => $Filename,
            Content   => \$Content,
        );
    }

    return $Filename;
}

=item GetMinifiedFile()

returns the minified contents of a given CSS or JavaScript file.
Uses caching internally.

    my $MinifiedCSS = $LoaderObject->GetMinifiedFile(
        Location => $Filename,
        Type     => 'CSS',      # CSS | JavaScript
    );

Warning: this function may cause a die() if there are errors in the file,
protect against that with eval().

=cut

sub GetMinifiedFile {
    my ( $Self, %Param ) = @_;

    # check needed params
    my $Location = $Param{Location};
    if ( !$Location ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Location!',
        );
        return;
    }

    my %ValidTypeParams = (
        CSS        => 1,
        JavaScript => 1,
    );

    if ( !$Param{Type} || !$ValidTypeParams{ $Param{Type} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need Type! Must be one of '" . join( ', ', keys %ValidTypeParams ) . "'."
        );
        return;
    }

    my $FileMTime = $Self->{MainObject}->FileGetMTime(
        Location => $Location,
    );

    # For the caching, use both filename and mtime to make sure that
    #   caches are correctly regenerated on changes.
    my $CacheKey = "$Location:$FileMTime";

    # check if a cached version exists
    my $CacheContent = $Self->{CacheInternalObject}->Get(
        Key => $CacheKey,
    );

    if ( ref $CacheContent eq 'SCALAR' ) {
        return ${$CacheContent};
    }

    # no cache available, read and minify file
    my $FileContents = $Self->{MainObject}->FileRead(
        Location => $Location,
    );

    if ( ref $FileContents ne 'SCALAR' ) {
        return;
    }

    my $Result;
    if ( $Param{Type} eq 'CSS' ) {
        $Result = $Self->MinifyCSS( Code => $$FileContents );
    }
    elsif ( $Param{Type} eq 'JavaScript' ) {
        $Result = $Self->MinifyJavaScript( Code => $$FileContents );
    }

    # and put it in the cache
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \$Result,
    );

    return $Result;
}

=item MinifyCSS()

returns a minified version of the given CSS Code

    my $MinifiedCSS = $LoaderObject->MinifyCSS( Code => $CSS );

Warning: this function may cause a die() if there are errors in the file,
protect against that with eval().

=cut

sub MinifyCSS {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{Code} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Code Param!',
        );
        return;
    }

    my $Result = CSS::Minifier::minify( input => $Param{Code} );

    # a few optimizations can be made for the minified CSS that CSS::Minifier doesn't yet do

    # remove remaining linebreaks
    $Result =~ s/\r?\n\s*//smxg;

    # remove superfluous whitespace after commas in chained selectors
    $Result =~ s/,\s*/,/smxg;

    return $Result;
}

=item MinifyJavaScript()

returns a minified version of the given JavaScript Code.

    my $MinifiedJS = $LoaderObject->MinifyJavaScript( Code => $JavaScript );

Warning: this function may cause a die() if there are errors in the file,
protect against that with eval().

This function internally uses the CPAN module JavaScript::Minifier.
As of version 1.05 of that module, there is an issue with regular expressions:

This will cause a die:

    function test(s) { return /\d{1,2}/.test(s); }

A workaround is to enclose the regular expression in parentheses:

    function test(s) { return (/\d{1,2}/).test(s); }

=cut

sub MinifyJavaScript {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{Code} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Code Param!',
        );
        return;
    }

    return JavaScript::Minifier::minify( input => $Param{Code} );
}

=item CacheDelete()

deletes all the loader cache files.

Returns a list of deleted files.

    my @DeletedFiles = $LoaderObject->CacheDelete();

=cut

sub CacheDelete {
    my ( $Self, %Param ) = @_;

    my @Result;

    my $Home = $Self->{ConfigObject}->Get('Home');

    my $JSCacheFolder       = "$Home/var/httpd/htdocs/js/js-cache";
    my @SkinTypeDirectories = (
        "$Home/var/httpd/htdocs/skins/Agent",
        "$Home/var/httpd/htdocs/skins/Customer",
    );

    my @CacheFoldersList = ($JSCacheFolder);

    # Looking for all skin folders that may contain a cache folder
    for my $Folder (@SkinTypeDirectories) {
        my @List = $Self->{MainObject}->DirectoryRead(
            Directory => $Folder,
            Filter    => '*',
        );

        FOLDER:
        for my $Folder (@List) {
            next FOLDER if ( !-d $Folder );
            my @CacheFolder = $Self->{MainObject}->DirectoryRead(
                Directory => $Folder,
                Filter    => 'css-cache',
            );
            if (@CacheFolder) {
                push @CacheFoldersList, $CacheFolder[0] if -d $CacheFolder[0];
            }
        }
    }

    # now go through the cache folders and delete all .js and .css files
    my @FileTypes = ( "*.js", "*.css" );
    my $TotalCounter = 0;
    FOLDERTODELETE:
    for my $FolderToDelete (@CacheFoldersList) {
        next FOLDERTODELETE if ( !-d $FolderToDelete );

        my @FilesList = $Self->{MainObject}->DirectoryRead(
            Directory => $FolderToDelete,
            Filter    => \@FileTypes,
        );
        for my $File (@FilesList) {
            if ( $Self->{MainObject}->FileDelete( Location => $File ) ) {
                push @Result, $File;
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Can't remove: $File"
                );
            }
        }
    }

    # finally, also clean up the internal perl cache files
    $Self->{CacheInternalObject}->CleanUp();

    return @Result;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
