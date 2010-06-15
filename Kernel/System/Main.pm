# --
# Kernel/System/Main.pm - main core components
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: Main.pm,v 1.45 2010-06-15 05:00:27 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Main;

use strict;
use warnings;

use Digest::MD5 qw(md5_hex);
use Data::Dumper;
use File::stat;

use Kernel::System::Encode;
use Unicode::Normalize;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.45 $) [1];

=head1 NAME

Kernel::System::Main - main object

=head1 SYNOPSIS

All main functions to load modules or to die.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create new object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
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

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject LogObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # get or create encode object
    $Self->{EncodeObject} = $Param{EncodeObject};
    $Self->{EncodeObject} ||= Kernel::System::Encode->new(%Param);

    # set debug mode
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

=item Require()

require/load a module

    my $Loaded = $MainObject->Require('Kernel::System::Example');

=cut

sub Require {
    my ( $Self, $Module ) = @_;

    if ( !$Module ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need module!',
        );
        return;
    }

    # prepare module
    $Module =~ s/::/\//g;
    $Module .= '.pm';

    # just return if it's already loaded
    return 1 if $INC{$Module};

    my $Result;
    my $File;

    # find full path of module
    PREFIX:
    for my $Prefix (@INC) {
        $File = $Prefix . '/' . $Module;

        next PREFIX if !-f $File;

        $Result = do $File;

        last PREFIX;
    }

    # if there was an error
    if ($@) {

        # log error
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => "$@",
        );

        return;
    }

    # return true if module is loaded
    if ( !$Result ) {

        # if there is no file, show not found error
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => "Module $Module not found!",
        );

        return;
    }

    # add module
    $INC{$Module} = $File;

    # log debug message
    if ( $Self->{Debug} > 1 ) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message  => "Module: $Module loaded!",
        );
    }

    return 1;
}

=item Die()

to die

    $MainObject->Die('some message to die');

=cut

sub Die {
    my ( $Self, $Message ) = @_;

    $Message = $Message || 'Died!';

    # log message
    $Self->{LogObject}->Log(
        Caller   => 1,
        Priority => 'error',
        Message  => $Message,
    );

    exit;
}

=item FilenameCleanUp()

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

    if ( !$Param{Filename} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Filename!',
        );
        return;
    }

    if ( $Param{Type} && $Param{Type} =~ /^md5/i ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Filename} );
        $Param{Filename} = md5_hex( $Param{Filename} );
    }

    # replace invalid token for attachment file names
    elsif ( $Param{Type} && $Param{Type} =~ /^attachment/i ) {

        # replace invalid token like < > ? " : ; | \ / or *
        $Param{Filename} =~ s/[ <>\?":\\\*\|\/;\[\]]/_/g;

        # replace utf8 and iso
        $Param{Filename} =~ s/(\x{00C3}\x{00A4}|\x{00A4})/ae/g;
        $Param{Filename} =~ s/(\x{00C3}\x{00B6}|\x{00B6})/oe/g;
        $Param{Filename} =~ s/(\x{00C3}\x{00BC}|\x{00FC})/ue/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009F}|\x{00C4})/Ae/g;
        $Param{Filename} =~ s/(\x{00C3}\x{0096}|\x{0096})/Oe/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009C}|\x{009C})/Ue/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009F}|\x{00DF})/ss/g;
        $Param{Filename} =~ s/-+/-/g;

        # cut the string if too long
        if ( length( $Param{Filename} ) > 100 ) {
            my $Ext = '';
            if ( $Param{Filename} =~ /^.*(\.(...|....))$/ ) {
                $Ext = $1;
            }
            $Param{Filename} = substr( $Param{Filename}, 0, 95 ) . $Ext;
        }
    }
    else {

        # replace invalid token like [ ] * : ? " < > ; | \ /
        $Param{Filename} =~ s/[<>\?":\\\*\|\/;\[\]]/_/g;
    }

    return $Param{Filename};
}

=item FileRead()

to read files from file system

    my $ContentSCALARRef = $MainObject->FileRead(
        Directory => 'c:\some\location',
        Filename  => 'me_to/alal.xml',
        # or Location
        Location  => 'c:\some\location\me_to\alal.xml'
    );

    my $ContentARRAYRef = $MainObject->FileRead(
        Directory => 'c:\some\location',
        Filename  => 'me_to/alal.xml',
        # or Location
        Location  => 'c:\some\location\me_to\alal.xml'

        Result    => 'ARRAY', # optional - SCALAR|ARRAY
    );

    my $ContentSCALARRef = $MainObject->FileRead(
        Directory       => 'c:\some\location',
        Filename        => 'me_to/alal.xml',
        # or Location
        Location        => 'c:\some\location\me_to\alal.xml'

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
            Type => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s{//}{/}xmsg;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );

    }

    # check if file exists
    if ( !-e $Param{Location} ) {
        if ( !$Param{DisableWarnings} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "File '$Param{Location}' doesn't exist!"
            );
        }
        return;
    }

    # set open mode
    my $Mode = '<';
    if ( $Param{Mode} && $Param{Mode} =~ m{ \A utf-?8 \z }xmsi ) {
        $Mode = '<:utf8';
    }

    # return if file can not open
    if ( !open( $FH, $Mode, $Param{Location} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't open '$Param{Location}': $!",
        );
        return;
    }

    # lock file (Shared Lock)
    if ( !flock( $FH, 1 ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't lock '$Param{Location}': $!",
        );
    }

    # enable binmode
    if ( !$Param{Mode} || $Param{Mode} =~ m{ \A binmode }xmsi ) {
        binmode($FH);
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

=item FileWrite()

to write data to file system

    my $FileLocation = $MainObject->FileWrite(
        Directory => 'c:\some\location',
        Filename  => 'me_to/alal.xml',
        # or Location
        Location  => 'c:\some\location\me_to\alal.xml'

        Content   => \$Content,
    );

    my $FileLocation = $MainObject->FileWrite(
        Directory  => 'c:\some\location',
        Filename   => 'me_to/alal.xml',
        # or Location
        Location   => 'c:\some\location\me_to\alal.xml'

        Content    => \$Content,
        Mode       => 'binmode', # binmode|utf8
        Type       => 'Local',   # optional - Local|Attachment|MD5
        Permission => '644',     # unix file permissions
    );

=cut

sub FileWrite {
    my ( $Self, %Param ) = @_;

    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename => $Param{Filename},
            Type => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s/\/\//\//g;
    }
    else {
        $Self->{LogObject}->Log(
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
    if ( !open( $FH, $Mode, $Param{Location} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't write '$Param{Location}': $!",
        );
        return;
    }

    # lock file (Exclusive Lock)
    if ( !flock( $FH, 2 ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't lock '$Param{Location}': $!",
        );
    }

    # empty file first (needed if file is open by '+<')
    truncate( $FH, 0 );

    # enable binmode
    if ( !$Param{Mode} || lc $Param{Mode} eq 'binmode' ) {

        # make sure, that no utf8 stamp exists (otherway perl will do auto convert to iso)
        $Self->{EncodeObject}->EncodeOutput( $Param{Content} );

        # set file handle to binmode
        binmode($FH);
    }

    # write file and close it
    print $FH ${ $Param{Content} };
    close($FH);

    # set permission
    if ( $Param{Permission} ) {
        if ( length( $Param{Permission} ) == 3 ) {
            $Param{Permission} = "0$Param{Permission}";
        }
        chmod( oct( $Param{Permission} ), $Param{Location} );
    }

    return $Param{Filename} if $Param{Filename};
    return $Param{Location};
}

=item FileDelete()

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
            Filename => $Param{Filename},
            Type => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s/\/\//\//g;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );
    }

    # check if file exists
    if ( !-e $Param{Location} ) {
        if ( !$Param{DisableWarnings} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "File '$Param{Location}' doesn't exist!"
            );
        }
        return;
    }

    # delete file
    if ( !unlink( $Param{Location} ) ) {
        if ( !$Param{DisableWarnings} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't delete '$Param{Location}': $!",
            );
        }
        return;
    }

    return 1;
}

=item FileGetMTime()

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
            Type => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s{//}{/}xmsg;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );

    }

    # check if file exists
    if ( !-e $Param{Location} ) {
        if ( !$Param{DisableWarnings} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "File '$Param{Location}' doesn't exist!"
            );
        }
        return;
    }

    # get file metadata
    my $Stat = stat( $Param{Location} );

    if ( !$Stat ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Cannot stat file '$Param{Location}': $!"
        );
        return;
    }

    return $Stat->mtime;
}

=item MD5sum()

get a md5 sum of a file or a string

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

    if ( !$Param{Filename} && !$Param{String} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Filename or String!' );
        return;
    }

    # check if file exists
    if ( $Param{Filename} && !-e $Param{Filename} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "File '$Param{Filename}' doesn't exist!",
        );
        return;
    }

    # md5sum file
    if ( $Param{Filename} ) {

        # open file
        my $FH;
        if ( !open( $FH, '<', $Param{Filename} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't write '$Param{Filename}': $!",
            );
            return;
        }

        binmode($FH);
        my $MD5sum = Digest::MD5->new()->addfile($FH)->hexdigest();
        close($FH);

        return $MD5sum;
    }

    # md5sum string
    if ( !ref $Param{String} ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{String} );
        return md5_hex( $Param{String} );
    }

    # md5sum scalar reference
    if ( ref $Param{String} eq 'SCALAR' ) {
        $Self->{EncodeObject}->EncodeOutput( $Param{String} );
        return md5_hex( ${ $Param{String} } );
    }

    $Self->{LogObject}->Log(
        Priority => 'error',
        Message  => "Need a SCALAR reference like 'String => \$Content' in String param.",
    );

    return;
}

=item Dump()

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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need \$String in Dump()!" );
        return;
    }

    # check type
    if ( !$Type ) {
        $Type = 'binary';
    }
    if ( $Type ne 'ascii' && $Type ne 'binary' ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Invalid Type '$Type'!" );
        return;
    }

    # mild pretty print
    $Data::Dumper::Indent = 1;

    # sort hash keys
    $Data::Dumper::Sortkeys = 1;

    # This Dump() is using Data::Dumer with a utf8 workarounds to handle
    # the bug [rt.cpan.org #28607] Data::Dumper::Dumper is dumping utf8
    # strings as latin1/8bit instead of utf8. Use Storable module used for
    # workaround.
    # -> http://rt.cpan.org/Ticket/Display.html?id=28607
    if (
        $Self->{EncodeObject}->CharsetInternal()
        && $Self->Require('Storable')
        && $Type eq 'binary'
        )
    {

        # Clone the data because we need to disable the utf8 flag in all
        # reference variables and we want not to do this in the orig.
        # variables because this will still used in the system.
        my $DataNew = Storable::dclone( \$Data );

        # Disable utf8 flag.
        $Self->_Dump($DataNew);

        # Dump it as binary strings.
        my $String = Data::Dumper::Dumper( ${$DataNew} );

        # Enable utf8 flag.
        Encode::_utf8_on($String);

        return $String;
    }

    # fallback if Storable can not be loaded
    return Data::Dumper::Dumper($Data);

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
        for my $Key ( keys %{ ${$Data} } ) {
            next KEY if !defined ${$Data}->{$Key};

            # start recursion
            $Self->_Dump( \${$Data}->{$Key} );
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

    $Self->{LogObject}->Log(
        Priority => 'error',
        Message  => "Unknown ref '" . ref( ${$Data} ) . "'!",
    );

    return;
}

=item DirectoryRead()

Reads a directory and returns an array with results

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => '/tmp',
        Filter => 'FileNam*',
    );

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => $Path,
    );

    without filter the default is *
    even you can place several filters

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => '/tmp',
        Filter => \@MyFilters,
    );

=cut

sub DirectoryRead {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw ( Directory )) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Message  => "Needed $Needed : $!",
                Priority => 'info',
            );
            return;
        }
    }

    # if directory doesn't exists stop
    if ( !-d $Param{Directory} ) {
        $Self->{LogObject}->Log(
            Message  => "Directory doesn't exists: $Param{Directory} : $!",
            Priority => 'info',
        );
        return;
    }

    my @GlobResults;
    my $Filter;

    # glob search
    # see if filter is an array
    if ( ref $Param{Filter} ne "ARRAY" ) {
        $Filter = $Param{Filter} || '*';    # if no filter glob look for all files
        if ( $Filter !~ m{\*}xms ) {
            $Filter = '*' . $Filter . '*'
        }
        @GlobResults = glob "$Param{Directory}/$Filter";
    }
    else {
        my @Filter;

        # prepare filter
        for my $Filter ( @{ $Param{Filter} } ) {
            if ( $Filter !~ m{(?:\A \*|\* \z)}xms ) {
                $Filter = '*' . $Filter . '*'
            }
            push @Filter, $Filter;
        }

        # executes glob for every filter
        for my $Filter (@Filter) {
            my @Glob;
            push @Glob, glob "$Param{Directory}/$Filter";

            # look for repeted values
            for my $GlobName (@Glob) {
                my $Found;
                for my $StoredName (@GlobResults) {
                    if ( $GlobName eq $StoredName ) {
                        $Found = 1
                    }
                }
                if ( !$Found ) {
                    push @GlobResults, $GlobName;
                }
            }
        }
    }

    my @CleanResults;

    # clean up registries (delete path)
    if ( !scalar @GlobResults ) {
        return;
    }
    else {

        # clean results
        for my $Data (@GlobResults) {
            if ( $Data =~ s{\A $Param{Directory}/}{}xms ) {
                push @CleanResults, $Data;
            }
        }
    }

    # if clean results
    my @Results;
    if ( !@CleanResults ) {
        $Self->{LogObject}->Log(
            Message  => "No results on directory search: $Param{Directory}: $!",
            Priority => 'info',
        );
        return;
    }
    else {

        # compose normalize every name in the file list
        for my $FileName (@CleanResults) {
            my $Normalized = Unicode::Normalize::normalize( "NFC", $FileName );
            push @Results, $Normalized;
        }
    }

    return @Results;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.45 $ $Date: 2010-06-15 05:00:27 $

=cut
