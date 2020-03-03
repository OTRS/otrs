# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Main;
## nofilter(TidyAll::Plugin::OTRS::Perl::Dumper)
## nofilter(TidyAll::Plugin::OTRS::Perl::Require)

use strict;
use warnings;

use Digest::MD5 qw(md5_hex);
use Data::Dumper;
use File::stat;
use Unicode::Normalize;
use List::Util qw();
use Fcntl qw(:flock);
use Encode;
use Math::Random::Secure qw(rand);

use Kernel::System::VariableCheck qw(IsStringWithData);

our @ObjectDependencies = (
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Storable',
);

=head1 NAME

Kernel::System::Main - main object

=head1 DESCRIPTION

All main functions to load modules, die, and handle files.

=head1 PUBLIC INTERFACE

=head2 new()

create new object. Do not use it directly, instead use:

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Require()

require/load a module

    my $Loaded = $MainObject->Require(
        'Kernel::System::Example',
        Silent => 1,                # optional, no log entry if module was not found
    );

=cut

sub Require {
    my ( $Self, $Module, %Param ) = @_;

    if ( !$Module ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need module!',
        );
        return;
    }

    eval {
        my $FileName = $Module =~ s{::}{/}smxgr;
        require $FileName . '.pm';
    };

    # Handle errors.
    if ($@) {

        if ( !$Param{Silent} ) {
            my $Message = $@;
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => $Message,
            );
        }

        return;
    }

    return 1;
}

=head2 RequireBaseClass()

require/load a module and add it as a base class to the
calling package, if not already present (this check is needed
for persistent environments).

    my $Loaded = $MainObject->RequireBaseClass(
        'Kernel::System::Example',
    );

=cut

sub RequireBaseClass {
    my ( $Self, $Module ) = @_;

    # Load the module, if not already loaded.
    return if !$Self->Require($Module);

    no strict 'refs';    ## no critic
    my $CallingClass = caller(0);

    # Check if the base class was already loaded.
    # This can happen in persistent environments as mod_perl (see bug#9686).
    if ( List::Util::first { $_ eq $Module } @{"${CallingClass}::ISA"} ) {
        return 1;    # nothing to do now
    }

    push @{"${CallingClass}::ISA"}, $Module;

    return 1;
}

=head2 Die()

to die

    $MainObject->Die('some message to die');

=cut

sub Die {
    my ( $Self, $Message ) = @_;

    $Message = $Message || 'Died!';

    # log message
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Caller   => 1,
        Priority => 'error',
        Message  => $Message,
    );

    exit;
}

=head2 FilenameCleanUp()

to clean up filenames which can be used in any case (also quoting is done)

    my $Filename = $MainObject->FilenameCleanUp(
        Filename => 'me_to/alal.xml',
        Type     => 'Local', # Local|Attachment|MD5
    );

    my $Filename = $MainObject->FilenameCleanUp(
        Filename => 'some:file.xml',
        Type     => 'MD5', # Local|Attachment|MD5
    );

=cut

sub FilenameCleanUp {
    my ( $Self, %Param ) = @_;

    if ( !IsStringWithData( $Param{Filename} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename!',
        );
        return;
    }

    # escape if cleanup is not needed
    if ( $Param{NoFilenameClean} ) {
        return $Param{Filename};
    }

    my $Type = lc( $Param{Type} || 'local' );

    if ( $Type eq 'md5' ) {
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Param{Filename} );
        $Param{Filename} = md5_hex( $Param{Filename} );
    }

    # replace invalid token for attachment file names
    elsif ( $Type eq 'attachment' ) {

        # trim whitespace
        $Param{Filename} =~ s/^\s+|\r|\n|\s+$//g;

        # strip leading dots
        $Param{Filename} =~ s/^\.+//;

        # only whitelisted characters allowed in filename for security
        $Param{Filename} =~ s/[^\w\-+.#_]/_/g;

        # Enclosed alphanumerics are kept on older Perl versions, make sure to replace them too.
        $Param{Filename} =~ s/[\x{2460}-\x{24FF}]/_/g;

        # replace utf8 and iso
        $Param{Filename} =~ s/(\x{00C3}\x{00A4}|\x{00A4})/ae/g;
        $Param{Filename} =~ s/(\x{00C3}\x{00B6}|\x{00B6})/oe/g;
        $Param{Filename} =~ s/(\x{00C3}\x{00BC}|\x{00FC})/ue/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009F}|\x{00C4})/Ae/g;
        $Param{Filename} =~ s/(\x{00C3}\x{0096}|\x{0096})/Oe/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009C}|\x{009C})/Ue/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009F}|\x{00DF})/ss/g;
        $Param{Filename} =~ s/-+/-/g;

        # separate filename and extension
        my $FileName = $Param{Filename};
        my $FileExt  = '';
        if ( $Param{Filename} =~ /(.*)\.+([^.]+)$/ ) {
            $FileName = $1;
            $FileExt  = '.' . $2;
        }

        if ( length $FileName ) {
            my $ModifiedName = $FileName . $FileExt;

            while ( length encode( 'UTF-8', $ModifiedName ) > 220 ) {

                # Remove character by character starting from the end of the filename string
                #   until we get acceptable 220 byte long filename size including extension.
                if ( length $FileName > 1 ) {
                    chop $FileName;
                }

                # If we reached minimum filename length, remove characters from the end of the extension string.
                else {
                    chop $FileExt;
                }

                $ModifiedName = $FileName . $FileExt;
            }
            $Param{Filename} = $ModifiedName;
        }
    }
    else {

        # trim whitespace
        $Param{Filename} =~ s/^\s+|\r|\n|\s+$//g;

        # strip leading dots
        $Param{Filename} =~ s/^\.+//;

        # only whitelisted characters allowed in filename for security
        if ( !$Param{NoReplace} ) {
            $Param{Filename} =~ s/[^\w\-+.#_]/_/g;

            # Enclosed alphanumerics are kept on older Perl versions, make sure to replace them too.
            $Param{Filename} =~ s/[\x{2460}-\x{24FF}]/_/g;
        }

        # separate filename and extension
        my $FileName = $Param{Filename};
        my $FileExt  = '';
        if ( $Param{Filename} =~ /(.*)\.+([^.]+)$/ ) {
            $FileName = $1;
            $FileExt  = '.' . $2;
        }

        if ( length $FileName ) {
            my $ModifiedName = $FileName . $FileExt;

            while ( length encode( 'UTF-8', $ModifiedName ) > 220 ) {

                # Remove character by character starting from the end of the filename string
                #   until we get acceptable 220 byte long filename size including extension.
                if ( length $FileName > 1 ) {
                    chop $FileName;
                }

                # If we reached minimum filename length, remove characters from the end of the extension string.
                else {
                    chop $FileExt;
                }

                $ModifiedName = $FileName . $FileExt;
            }

            $Param{Filename} = $ModifiedName;
        }
    }

    return $Param{Filename};
}

=head2 FileRead()

to read files from file system

    my $ContentSCALARRef = $MainObject->FileRead(
        Directory => 'c:\some\location',
        Filename  => 'file2read.txt',
        # or Location
        Location  => 'c:\some\location\file2read.txt',
    );

    my $ContentARRAYRef = $MainObject->FileRead(
        Directory => 'c:\some\location',
        Filename  => 'file2read.txt',
        # or Location
        Location  => 'c:\some\location\file2read.txt',

        Result    => 'ARRAY', # optional - SCALAR|ARRAY
    );

    my $ContentSCALARRef = $MainObject->FileRead(
        Directory       => 'c:\some\location',
        Filename        => 'file2read.txt',
        # or Location
        Location        => 'c:\some\location\file2read.txt',

        Mode            => 'binmode', # optional - binmode|utf8
        Type            => 'Local',   # optional - Local|Attachment|MD5
        Result          => 'SCALAR',  # optional - SCALAR|ARRAY
        DisableWarnings => 1,         # optional
    );

=cut

sub FileRead {
    my ( $Self, %Param ) = @_;

    my $FH;
    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename => $Param{Filename},
            Type     => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s{//}{/}xmsg;
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );

    }

    # set open mode
    my $Mode = '<';
    if ( $Param{Mode} && $Param{Mode} =~ m{ \A utf-?8 \z }xmsi ) {
        $Mode = '<:utf8';
    }

    # return if file can not open
    if ( !open $FH, $Mode, $Param{Location} ) {    ## no critic
        my $Error = $!;

        if ( !$Param{DisableWarnings} ) {

            # Check if file exists only if system was not able to open it (to get better error message).
            if ( !-e $Param{Location} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "File '$Param{Location}' doesn't exist!",
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't open '$Param{Location}': $Error",
                );
            }
        }
        return;
    }

    # lock file (Shared Lock)
    if ( !flock $FH, LOCK_SH ) {
        if ( !$Param{DisableWarnings} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't lock '$Param{Location}': $!",
            );
        }
    }

    # enable binmode
    if ( !$Param{Mode} || $Param{Mode} =~ m{ \A binmode }xmsi ) {
        binmode $FH;
    }

    # read file as array
    if ( $Param{Result} && $Param{Result} eq 'ARRAY' ) {

        # read file content at once
        my @Array = <$FH>;
        close $FH;

        return \@Array;
    }

    # read file as string
    my $String = do { local $/; <$FH> };
    close $FH;

    return \$String;
}

=head2 FileWrite()

to write data to file system

    my $FileLocation = $MainObject->FileWrite(
        Directory => 'c:\some\location',
        Filename  => 'file2write.txt',
        # or Location
        Location  => 'c:\some\location\file2write.txt',

        Content   => \$Content,
    );

    my $FileLocation = $MainObject->FileWrite(
        Directory  => 'c:\some\location',
        Filename   => 'file2write.txt',
        # or Location
        Location   => 'c:\some\location\file2write.txt',

        Content    => \$Content,
        Mode       => 'binmode', # binmode|utf8
        Type       => 'Local',   # optional - Local|Attachment|MD5
        Permission => '644',     # optional - unix file permissions
    );

Platform note: MacOS (HFS+) stores filenames as Unicode C<NFD> internally,
and DirectoryRead() will also report them as C<NFD>.

=cut

sub FileWrite {
    my ( $Self, %Param ) = @_;

    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename        => $Param{Filename},
            Type            => $Param{Type} || 'Local',    # Local|Attachment|MD5
            NoFilenameClean => $Param{NoFilenameClean},
            NoReplace       => $Param{NoReplace},
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s/\/\//\//g;
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );
    }

    # set open mode (if file exists, lock it on open, done by '+<')
    my $Exists;
    if ( -f $Param{Location} ) {
        $Exists = 1;
    }
    my $Mode = '>';
    if ($Exists) {
        $Mode = '+<';
    }
    if ( $Param{Mode} && $Param{Mode} =~ /^(utf8|utf\-8)/i ) {
        $Mode = '>:utf8';
        if ($Exists) {
            $Mode = '+<:utf8';
        }
    }

    # return if file can not open
    my $FH;
    if ( !open $FH, $Mode, $Param{Location} ) {    ## no critic
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't write '$Param{Location}': $!",
        );
        return;
    }

    # lock file (Exclusive Lock)
    if ( !flock $FH, LOCK_EX ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't lock '$Param{Location}': $!",
        );
    }

    # empty file first (needed if file is open by '+<')
    truncate $FH, 0;

    # enable binmode
    if ( !$Param{Mode} || lc $Param{Mode} eq 'binmode' ) {

        # make sure, that no utf8 stamp exists (otherway perl will do auto convert to iso)
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( $Param{Content} );

        # set file handle to binmode
        binmode $FH;
    }

    # write file if content is not undef
    if ( defined ${ $Param{Content} } ) {
        print $FH ${ $Param{Content} };
    }

    # write empty file if content is undef
    else {
        print $FH '';
    }

    # close the filehandle
    close $FH;

    # set permission
    if ( $Param{Permission} ) {
        if ( length $Param{Permission} == 3 ) {
            $Param{Permission} = "0$Param{Permission}";
        }
        chmod( oct( $Param{Permission} ), $Param{Location} );
    }

    return $Param{Filename} if $Param{Filename};
    return $Param{Location};
}

=head2 FileDelete()

to delete a file from file system

    my $Success = $MainObject->FileDelete(
        Directory       => 'c:\some\location',
        Filename        => 'me_to/alal.xml',
        # or Location
        Location        => 'c:\some\location\me_to\alal.xml'

        Type            => 'Local',   # optional - Local|Attachment|MD5
        DisableWarnings => 1, # optional
    );

=cut

sub FileDelete {
    my ( $Self, %Param ) = @_;

    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename  => $Param{Filename},
            Type      => $Param{Type} || 'Local',    # Local|Attachment|MD5
            NoReplace => $Param{NoReplace},
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s/\/\//\//g;
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );
    }

    # try to delete file
    if ( !unlink( $Param{Location} ) ) {
        my $Error = $!;

        if ( !$Param{DisableWarnings} ) {

            # Check if file exists only in case that delete failed.
            if ( !-e $Param{Location} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "File '$Param{Location}' doesn't exist!",
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't delete '$Param{Location}': $Error",
                );
            }
        }

        return;
    }

    return 1;
}

=head2 FileGetMTime()

get timestamp of file change time

    my $FileMTime = $MainObject->FileGetMTime(
        Directory => 'c:\some\location',
        Filename  => 'me_to/alal.xml',
        # or Location
        Location  => 'c:\some\location\me_to\alal.xml'
    );

=cut

sub FileGetMTime {
    my ( $Self, %Param ) = @_;

    my $FH;
    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename => $Param{Filename},
            Type     => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s{//}{/}xmsg;
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );

    }

    # get file metadata
    my $Stat = stat( $Param{Location} );

    if ( !$Stat ) {
        my $Error = $!;

        if ( !$Param{DisableWarnings} ) {

            # Check if file exists only if system was not able to open it (to get better error message).
            if ( !-e $Param{Location} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "File '$Param{Location}' doesn't exist!"
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Cannot stat file '$Param{Location}': $Error",
                );
            }
        }
        return;
    }

    return $Stat->mtime();
}

=head2 MD5sum()

get an C<MD5> sum of a file or a string

    my $MD5Sum = $MainObject->MD5sum(
        Filename => '/path/to/me_to_alal.xml',
    );

    my $MD5Sum = $MainObject->MD5sum(
        String => \$SomeString,
    );

    # note: needs more memory!
    my $MD5Sum = $MainObject->MD5sum(
        String => $SomeString,
    );

=cut

sub MD5sum {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Filename} && !defined( $Param{String} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename or String!',
        );
        return;
    }

    # md5sum file
    if ( $Param{Filename} ) {

        # open file
        my $FH;
        if ( !open $FH, '<', $Param{Filename} ) {    ## no critic
            my $Error = $!;

            # Check if file exists only if system was not able to open it (to get better error message).
            if ( !-e $Param{Filename} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "File '$Param{Filename}' doesn't exist!",
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't read '$Param{Filename}': $Error",
                );
            }
            return;
        }

        binmode $FH;
        my $MD5sum = Digest::MD5->new()->addfile($FH)->hexdigest();
        close $FH;

        return $MD5sum;
    }

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # md5sum string
    if ( !ref $Param{String} ) {
        $EncodeObject->EncodeOutput( \$Param{String} );
        return md5_hex( $Param{String} );
    }

    # md5sum scalar reference
    if ( ref $Param{String} eq 'SCALAR' ) {
        $EncodeObject->EncodeOutput( $Param{String} );
        return md5_hex( ${ $Param{String} } );
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "Need a SCALAR reference like 'String => \$Content' in String param.",
    );

    return;
}

=head2 Dump()

dump variable to an string

    my $Dump = $MainObject->Dump(
        $SomeVariable,
    );

    my $Dump = $MainObject->Dump(
        {
            Key1 => $SomeVariable,
        },
    );

    dump only in ascii characters (> 128 will be marked as \x{..})

    my $Dump = $MainObject->Dump(
        $SomeVariable,
        'ascii', # ascii|binary - default is binary
    );

=cut

sub Dump {
    my ( $Self, $Data, $Type ) = @_;

    # check needed data
    if ( !defined $Data ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need \$String in Dump()!"
        );
        return;
    }

    # check type
    if ( !$Type ) {
        $Type = 'binary';
    }
    if ( $Type ne 'ascii' && $Type ne 'binary' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid Type '$Type'!"
        );
        return;
    }

    # mild pretty print
    $Data::Dumper::Indent = 1;

    # sort hash keys
    $Data::Dumper::Sortkeys = 1;

    # This Dump() is using Data::Dumper with a utf8 workarounds to handle
    # the bug [rt.cpan.org #28607] Data::Dumper::Dumper is dumping utf8
    # strings as latin1/8bit instead of utf8. Use Storable module used for
    # workaround.
    # -> http://rt.cpan.org/Ticket/Display.html?id=28607
    if ( $Type eq 'binary' ) {

        # Clone the data because we need to disable the utf8 flag in all
        # reference variables and do not to want to do this in the orig.
        # variables because they will still used in the system.
        my $DataNew = $Kernel::OM->Get('Kernel::System::Storable')->Clone( Data => \$Data );

        # Disable utf8 flag.
        $Self->_Dump($DataNew);

        # Dump it as binary strings.
        my $String = Data::Dumper::Dumper( ${$DataNew} );    ## no critic

        # Enable utf8 flag.
        Encode::_utf8_on($String);

        return $String;
    }

    # fallback if Storable can not be loaded
    return Data::Dumper::Dumper($Data);                      ## no critic

}

=head2 DirectoryRead()

reads a directory and returns an array with results.

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => '/tmp',
        Filter    => 'Filenam*',
    );

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => $Path,
        Filter    => '*',
    );

read all files in subdirectories as well (recursive):

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => $Path,
        Filter    => '*',
        Recursive => 1,
    );

You can pass several additional filters at once:

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => '/tmp',
        Filter    => \@MyFilters,
    );

The result strings are absolute paths, and they are converted to utf8.

Use the 'Silent' parameter to suppress log messages when a directory
does not have to exist:

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => '/special/optional/directory/',
        Filter    => '*',
        Silent    => 1,     # will not log errors if the directory does not exist
    );

Platform note: MacOS (HFS+) stores filenames as Unicode C<NFD> internally,
and DirectoryRead() will also report them as C<NFD>.

=cut

sub DirectoryRead {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Directory Filter)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "Needed $Needed: $!",
                Priority => 'error',
            );
            return;
        }
    }

    # if directory doesn't exists stop
    if ( !-d $Param{Directory} && !$Param{Silent} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Message  => "Directory doesn't exist: $Param{Directory}: $!",
            Priority => 'error',
        );
        return;
    }

    # check Filter param
    if ( ref $Param{Filter} ne '' && ref $Param{Filter} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Message  => 'Filter param need to be scalar or array ref!',
            Priority => 'error',
        );
        return;
    }

    # prepare non array filter
    if ( ref $Param{Filter} ne 'ARRAY' ) {
        $Param{Filter} = [ $Param{Filter} ];
    }

    # executes glob for every filter
    my @GlobResults;
    my %Seen;

    for my $Filter ( @{ $Param{Filter} } ) {
        my @Glob = glob "$Param{Directory}/$Filter";

        # look for repeated values
        NAME:
        for my $GlobName (@Glob) {

            next NAME if !-e $GlobName;
            if ( !$Seen{$GlobName} ) {
                push @GlobResults, $GlobName;
                $Seen{$GlobName} = 1;
            }
        }
    }

    if ( $Param{Recursive} ) {

        # loop protection to prevent symlinks causing lockups
        $Param{LoopProtection}++;
        return if $Param{LoopProtection} > 100;

        # check all files in current directory
        my @Directories = glob "$Param{Directory}/*";

        DIRECTORY:
        for my $Directory (@Directories) {

            # return if file is not a directory
            next DIRECTORY if !-d $Directory;

            # repeat same glob for directory
            my @SubResult = $Self->DirectoryRead(
                %Param,
                Directory => $Directory,
            );

            # add result to hash
            for my $Result (@SubResult) {
                if ( !$Seen{$Result} ) {
                    push @GlobResults, $Result;
                    $Seen{$Result} = 1;
                }
            }
        }
    }

    # if no results
    return if !@GlobResults;

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # compose normalize every name in the file list
    my @Results;
    for my $Filename (@GlobResults) {

        # First convert filename to utf-8, with additional Check parameter
        # to replace possible malformed characters and prevent further errors.
        $Filename = $EncodeObject->Convert2CharsetInternal(
            Text  => $Filename,
            From  => 'utf-8',
            Check => 1,
        );

        push @Results, $Filename;
    }

    # always sort the result
    @Results = sort @Results;

    return @Results;
}

=head2 GenerateRandomString()

generate a random string of defined length, and of a defined alphabet.
defaults to a length of 16 and alphanumerics ( 0..9, A-Z and a-z).

    my $String = $MainObject->GenerateRandomString();

returns

    $String = 'mHLOx7psWjMe5Pj7';

with specific length:

    my $String = $MainObject->GenerateRandomString(
        Length => 32,
    );

returns

    $String = 'azzHab72wIlAXDrxHexsI5aENsESxAO7';

with specific length and alphabet:

    my $String = $MainObject->GenerateRandomString(
        Length     => 32,
        Dictionary => [ 0..9, 'a'..'f' ], # hexadecimal
        );

returns

    $String = '9fec63d37078fe72f5798d2084fea8ad';


=cut

sub GenerateRandomString {
    my ( $Self, %Param ) = @_;

    my $Length = $Param{Length} || 16;

    # The standard list of characters in the dictionary. Don't use special chars here.
    my @DictionaryChars = ( 0 .. 9, 'A' .. 'Z', 'a' .. 'z' );

    # override dictionary with custom list if given
    if ( $Param{Dictionary} && ref $Param{Dictionary} eq 'ARRAY' ) {
        @DictionaryChars = @{ $Param{Dictionary} };
    }

    my $DictionaryLength = scalar @DictionaryChars;

    # generate the string
    my $String;

    for ( 1 .. $Length ) {

        my $Key = int rand $DictionaryLength;

        $String .= $DictionaryChars[$Key];
    }

    return $String;
}

=begin Internal:

=cut

sub _Dump {
    my ( $Self, $Data ) = @_;

    # data is not a reference
    if ( !ref ${$Data} ) {
        Encode::_utf8_off( ${$Data} );

        return;
    }

    # data is a scalar reference
    if ( ref ${$Data} eq 'SCALAR' ) {

        # start recursion
        $Self->_Dump( ${$Data} );

        return;
    }

    # data is a hash reference
    if ( ref ${$Data} eq 'HASH' ) {
        KEY:
        for my $Key ( sort keys %{ ${$Data} } ) {
            next KEY if !defined ${$Data}->{$Key};

            # start recursion
            $Self->_Dump( \${$Data}->{$Key} );

            my $KeyNew = $Key;

            $Self->_Dump( \$KeyNew );

            if ( $Key ne $KeyNew ) {

                ${$Data}->{$KeyNew} = ${$Data}->{$Key};
                delete ${$Data}->{$Key};
            }
        }

        return;
    }

    # data is a array reference
    if ( ref ${$Data} eq 'ARRAY' ) {
        KEY:
        for my $Key ( 0 .. $#{ ${$Data} } ) {
            next KEY if !defined ${$Data}->[$Key];

            # start recursion
            $Self->_Dump( \${$Data}->[$Key] );
        }

        return;
    }

    # data is a ref reference
    if ( ref ${$Data} eq 'REF' ) {

        # start recursion
        $Self->_Dump( ${$Data} );

        return;
    }

    # data is a JSON::PP::Boolean
    if ( ref ${$Data} eq 'JSON::PP::Boolean' ) {

        # start recursion
        $Self->_Dump( ${$Data} );

        return;
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "Unknown ref '" . ref( ${$Data} ) . "'!",
    );

    return;
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
