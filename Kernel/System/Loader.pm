# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Loader;

use strict;
use warnings;

use CSS::Minifier qw();
use JavaScript::Minifier qw();

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::Loader - CSS/JavaScript loader backend

=head1 DESCRIPTION

All valid functions.

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    my $LoaderObject = $Kernel::OM->Get('Kernel::System::Loader');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'Loader';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=head2 MinifyFiles()

takes a list of files and returns a filename in the target directory
which holds the minified and concatenated content of the files.
Uses caching internally.

    my $TargetFilename = $LoaderObject->MinifyFiles(
        List  => [                          # optional,  minify list of files
            $Filename,
            $Filename2,
        ],
        Checksum             => '...'       # optional, pass a checksum for the minified file
        Content              => '...'       # optional, pass direct (already minified) content instead of a file list
        Type                 => 'CSS',      # CSS | JavaScript
        TargetDirectory      => $TargetDirectory,
        TargetFilenamePrefix => 'CommonCSS',    # optional, prefix for the target filename
    );

=cut

sub MinifyFiles {
    my ( $Self, %Param ) = @_;

    # check needed params
    my $List    = $Param{List};
    my $Content = $Param{Content};

    if ( !$Content && ( ref $List ne 'ARRAY' || !@{$List} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need List or Content!',
        );
        return;
    }

    my $TargetDirectory = $Param{TargetDirectory};
    if ( !-e $TargetDirectory ) {
        if ( !mkdir( $TargetDirectory, 0775 ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't create directory '$TargetDirectory': $!",
            );
            return;
        }
    }

    if ( !$TargetDirectory || !-d $TargetDirectory ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Type! Must be one of '" . join( ', ', keys %ValidTypeParams ) . "'."
        );
        return;
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $Filename;
    if ( $Param{Checksum} ) {
        $Filename = $TargetFilenamePrefix . $Param{Checksum};
    }
    else {
        my $FileString;

        if ( $Param{List} ) {
            LOCATION:
            for my $Location ( @{$List} ) {
                if ( !-e $Location ) {
                    next LOCATION;
                }
                my $FileMTime = $MainObject->FileGetMTime(
                    Location => $Location
                );

                # For the caching, use both filename and mtime to make sure that
                #   caches are correctly regenerated on changes.
                $FileString .= "$Location:$FileMTime:";
            }
        }

        $Filename = $TargetFilenamePrefix . $MainObject->MD5sum(
            String => \$FileString,
        );
    }

    if ( $Param{Type} eq 'CSS' ) {
        $Filename .= '.css';
    }
    elsif ( $Param{Type} eq 'JavaScript' ) {
        $Filename .= '.js';

    }

    if ( !-r "$TargetDirectory/$Filename" ) {

        # no cache available, so loop through all files, get minified version and concatenate
        LOCATION: for my $Location ( @{$List} ) {

            next LOCATION if ( !-r $Location );

            # cut out the system specific parts for the comments (for easier testing)
            # for now, only keep filename
            my $Label = $Location;
            $Label =~ s{^.*/}{}smx;

            if ( $Param{Type} eq 'CSS' ) {

                eval {
                    $Content .= $Self->GetMinifiedFile(
                        Location => $Location,
                        Type     => $Param{Type},
                    );
                };

                if ($@) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Error during file minification: $@",
                    );
                }

                $Content .= "\n";
            }
            elsif ( $Param{Type} eq 'JavaScript' ) {

                eval {
                    $Content .= $Self->GetMinifiedFile(
                        Location => $Location,
                        Type     => $Param{Type},
                    );
                };

                if ($@) {
                    my $JSError = "Error during minification of file $Location: $@";
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => $JSError,
                    );
                    $JSError =~ s/'/\\'/gsmx;
                    $JSError =~ s/\r?\n/ /gsmx;
                    $Content .= "alert('$JSError');";
                }
                $Content .= "\n";
            }
        }

        my $FileLocation = $MainObject->FileWrite(
            Directory => $TargetDirectory,
            Filename  => $Filename,
            Content   => \$Content,
        );
    }

    return $Filename;
}

=head2 GetMinifiedFile()

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Type! Must be one of '" . join( ', ', keys %ValidTypeParams ) . "'."
        );
        return;
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $FileMTime = $MainObject->FileGetMTime(
        Location => $Location,
    );

    # For the caching, use both filename and mtime to make sure that
    #   caches are correctly regenerated on changes.
    my $CacheKey = "$Location:$FileMTime";

    # check if a cached version exists
    my $CacheContent = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    if ( ref $CacheContent eq 'SCALAR' ) {
        return ${$CacheContent};
    }

    # no cache available, read and minify file
    my $FileContents = $MainObject->FileRead(
        Location => $Location,

        # It would be more correct to use UTF8 mode, but then the JavaScript::Minifier
        #   will cause timeouts due to extreme slowness on some UT servers. Disable for now.
        #   Unicode in the files still works correctly.
        #Mode     => 'utf8',
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
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \$Result,
    );

    return $Result;
}

=head2 MinifyCSS()

returns a minified version of the given CSS Code

    my $MinifiedCSS = $LoaderObject->MinifyCSS( Code => $CSS );

Warning: this function may cause a die() if there are errors in the file,
protect against that with eval().

=cut

sub MinifyCSS {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{Code} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

=head2 MinifyJavaScript()

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Code Param!',
        );
        return;
    }

    return JavaScript::Minifier::minify( input => $Param{Code} );
}

=head2 CacheGenerate()

generates the loader cache files for all frontend modules.

    my %GeneratedFiles = $LoaderObject->CacheGenerate();

=cut

sub CacheGenerate {
    my ( $Self, %Param ) = @_;

    my @Result;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    ## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %AgentFrontends = %{ $ConfigObject->Get('Frontend::Module') // {} };

    for my $FrontendModule ( sort { $a cmp $b } keys %AgentFrontends ) {
        $LayoutObject->{Action} = $FrontendModule;
        $LayoutObject->LoaderCreateAgentCSSCalls();
        $LayoutObject->LoaderCreateAgentJSCalls();
        push @Result, $FrontendModule;
    }

    my %CustomerFrontends = (
        %{ $ConfigObject->Get('CustomerFrontend::Module') // {} },
        %{ $ConfigObject->Get('PublicFrontend::Module')   // {} },
    );

    for my $FrontendModule ( sort { $a cmp $b } keys %CustomerFrontends ) {
        $LayoutObject->{Action} = $FrontendModule;
        $LayoutObject->LoaderCreateCustomerCSSCalls();
        $LayoutObject->LoaderCreateCustomerJSCalls();
        push @Result, $FrontendModule;
    }

    # Now generate JavaScript translation content
    for my $UserLanguage ( sort keys %{ $ConfigObject->Get('DefaultUsedLanguages') // {} } ) {
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Language'] );
        my $LocalLayoutObject = Kernel::Output::HTML::Layout->new(
            Lang => $UserLanguage,
        );
        $LocalLayoutObject->LoaderCreateJavaScriptTranslationData();
    }

    # generate JS template cache
    $LayoutObject->LoaderCreateJavaScriptTemplateData();

    return @Result;
}

=head2 CacheDelete()

deletes all the loader cache files.

Returns a list of deleted files.

    my @DeletedFiles = $LoaderObject->CacheDelete();

=cut

sub CacheDelete {
    my ( $Self, %Param ) = @_;

    my @Result;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $JSCacheFolder       = "$Home/var/httpd/htdocs/js/js-cache";
    my @SkinTypeDirectories = (
        "$Home/var/httpd/htdocs/skins/Agent",
        "$Home/var/httpd/htdocs/skins/Customer",
    );

    my @CacheFoldersList = ($JSCacheFolder);

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Looking for all skin folders that may contain a cache folder
    for my $Folder (@SkinTypeDirectories) {
        my @List = $MainObject->DirectoryRead(
            Directory => $Folder,
            Filter    => '*',
        );

        FOLDER:
        for my $Folder (@List) {
            next FOLDER if ( !-d $Folder );
            my @CacheFolder = $MainObject->DirectoryRead(
                Directory => $Folder,
                Filter    => 'css-cache',
            );
            if ( @CacheFolder && -d $CacheFolder[0] ) {
                push @CacheFoldersList, $CacheFolder[0];
            }
        }
    }

    # now go through the cache folders and delete all .js and .css files
    my @FileTypes    = ( "*.js", "*.css" );
    my $TotalCounter = 0;
    FOLDERTODELETE:
    for my $FolderToDelete (@CacheFoldersList) {
        next FOLDERTODELETE if ( !-d $FolderToDelete );

        my @FilesList = $MainObject->DirectoryRead(
            Directory => $FolderToDelete,
            Filter    => \@FileTypes,
        );
        for my $File (@FilesList) {
            if ( $MainObject->FileDelete( Location => $File ) ) {
                push @Result, $File;
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't remove: $File"
                );
            }
        }
    }

    # finally, also clean up the internal perl cache files
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return @Result;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
