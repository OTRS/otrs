# --
# Kernel/System/SupportBundleGenerator.pm - support bundle generator
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportBundleGenerator;

use strict;
use warnings;

use Archive::Tar;

use Kernel::System::CSV;
use Kernel::System::JSON;
use Kernel::System::Package;
use Kernel::System::Registration;
use Kernel::System::SupportDataCollector;

=head1 NAME

Kernel::System::SupportBundleGenerator - support bundle generator

=head1 SYNOPSIS

All support bundle generator functions.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::SystemDumpGenerator;

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
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $StatsObject = Kernel::System::SystemDumpGenerator->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash ref to object
    my $Self = {};
    bless( $Self, $Type );

    # check object list for completeness
    for my $Object (
        qw( ConfigObject LogObject MainObject DBObject EncodeObject TimeObject )
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{CSVObject}                  = Kernel::System::CSV->new( %{$Self} );
    $Self->{JSONObject}                 = Kernel::System::JSON->new( %{$Self} );
    $Self->{PackageObject}              = Kernel::System::Package->new( %{$Self} );
    $Self->{RegistrationObject}         = Kernel::System::Registration->new( %{$Self} );
    $Self->{SupportDataCollectorObject} = Kernel::System::SupportDataCollector->new( %{$Self} );

    # cleanup the Home variable (remove tailing "/")
    $Self->{Home} = $Self->{ConfigObject}->Get('Home');
    $Self->{Home} =~ s{\/\z}{};

    $Self->{RandomID} = $Self->{MainObject}->GenerateRandomString(
        Length => 8,
        Dictionary => [ 0 .. 9, 'a' .. 'f' ],
    );

    return $Self;
}

=item Generate()

Generates a support bundle tar or tar.gz with the following contents: Registration Information,
Support Data, Installed Packages, and another tar or tar.gz with all changed or new files in the
OTRS installation directory.

    my $Result = $SupportBundleGeneratorObject->Generate();

Returns:

    $Result = {
        Success => 1,                                # Or false, in case of an error
        Data    => {
            Filecontent => \$Tar,                    # Outer tar content reference
            Filename    => 'SupportBundle.tar',      # The outer tar filename
            Filesize    =>  123                      # The size of the file in mega bytes
        },

=cut

sub Generate {
    my ( $Self, %Param ) = @_;

    if ( !-e $Self->{Home} . '/ARCHIVE' ) {
        my $Message = $Self->{Home} . '/ARCHIVE: Is missing, can not continue!';
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Message,
        );
        return {
            Success => 0,
            Message => $Message,
        };
    }

    my %SupportFiles;

    # get the list of installed packages
    ( $SupportFiles{PackageListContent}, $SupportFiles{PackageListFilename} )
        = $Self->GeneratePackageList();
    if ( !$SupportFiles{PackageListFilename} ) {
        my $Message = 'Can not generate the list of installed packages!';
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Message,
        );
        return {
            Success => 0,
            Message => $Message,
        };
    }

    # get the registration information
    ( $SupportFiles{RegistrationInfoContent}, $SupportFiles{RegistrationInfoFilename} )
        = $Self->GenerateRegistrationInfo();
    if ( !$SupportFiles{RegistrationInfoFilename} ) {
        my $Message = 'Can not get the registration information!';
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Message,
        );
        return {
            Success => 0,
            Message => $Message,
        };
    }

    # get the support data
    ( $SupportFiles{SupportDataContent}, $SupportFiles{SupportDataFilename} )
        = $Self->GenerateSupportData();
    if ( !$SupportFiles{SupportDataFilename} ) {
        my $Message = 'Can not collect the support data!';
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Message,
        );
        return {
            Success => 0,
            Message => $Message,
        };
    }

    # get the archive of custom files
    ( $SupportFiles{CustomFilesArchiveContent}, $SupportFiles{CustomFilesArchiveFilename} )
        = $Self->GenerateCustomFilesArchive();
    if ( !$SupportFiles{CustomFilesArchiveFilename} ) {
        my $Message = 'Can not generate the custom files archive!';
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Message,
        );
        return {
            Success => 0,
            Message => $Message,
        };
    }

    # save and create archive
    my $TempDir
        = $Self->{ConfigObject}->Get('TempDir') . '/SupportBundle/' . $Self->{RandomID} . '/';

    if ( !-d $TempDir ) {
        mkdir $TempDir;
    }

    # remove all files
    my @ListOld = glob( $TempDir . '/*' );
    for my $File (@ListOld) {
        unlink $File;
    }

    my @List;
    for my $Key (qw(PackageList RegistrationInfo SupportData CustomFilesArchive)) {
        if ( $SupportFiles{ $Key . 'Filename' } && $SupportFiles{ $Key . 'Content' } ) {
            my $Location = $TempDir . '/' . $SupportFiles{ $Key . 'Filename' };
            my $Content  = $SupportFiles{ $Key . 'Content' };

            my $FileLocation = $Self->{MainObject}->FileWrite(
                Location   => $Location,
                Content    => $Content,
                Mode       => 'binmode',
                Type       => 'Local',
                Permission => '644',
            );
            push @List, $Location;
        }
    }

    ## no critic
    my ( $s, $m, $h, $D, $M, $Y, $wd, $yd, $dst ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    ## use critic
    my $Filename = "SupportBundle_$Y-$M-$D" . '_' . "$h-$m";

    # add files to the tar archive
    my $Archive   = $TempDir . '/' . $Filename;
    my $TarObject = Archive::Tar->new();
    $TarObject->add_files(@List);
    $TarObject->write( $Archive, 0 ) || die "Could not write: $_!";

    # add files to the tar archive
    open( my $Tar, '<', $Archive );    ## no critic
    binmode $Tar;
    my $TmpTar = do { local $/; <$Tar> };
    close $Tar;

    # remove all files
    @ListOld = glob( $TempDir . '/*' );
    for my $File (@ListOld) {
        unlink $File;
    }

    # remove temporary directory
    rmdir $TempDir;

    if ( $Self->{MainObject}->Require('Compress::Zlib') ) {
        my $GzTar = Compress::Zlib::memGzip($TmpTar);

        # log info
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => 'Download Compress::Zlib end',
        );

        return {
            Success => 1,
            Data    => {
                Filecontent => \$GzTar,
                Filename    => $Filename . '.tar.gz',
                Filesize    => bytes::length($GzTar) / ( 1024 * 1024 ),
            },
        };
    }

    # log info
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => 'Download no Compress::Zlib end',
    );

    return {
        Success => 1,
        Data    => {
            Filecontent => \$TmpTar,
            Filename    => $Filename . '.tar',
            Filesize    => bytes::length($TmpTar) / ( 1024 * 1024 ),
        },
    };
}

=item GenerateCustomFilesArchive()

Generates a .tar or tar.gz file with all eligible changed or added files taking the ARCHIVE file as
a reference

    my ( $Content, $Filename ) = $SupportBundleGeneratorObject->GenerateCustomFilesArchive();

Returns:
    $Content  = $FileContentsRef;
    $Filename = 'application.tar';      # or 'application.tar.gz'

=cut

sub GenerateCustomFilesArchive {
    my ( $Self, %Param ) = @_;

    my $TempDir
        = $Self->{ConfigObject}->Get('TempDir') . '/SupportBundle/' . $Self->{RandomID} . '/';

    if ( !-d $TempDir ) {
        mkdir $TempDir;
    }

    # remove all files
    my @ListOld = glob( $TempDir . '/*' );
    for my $File (@ListOld) {
        unlink $File;
    }

    my $CustomFilesArchive = $TempDir . '/application.tar';
    if ( -f $CustomFilesArchive ) {
        unlink $CustomFilesArchive || die "Can't unlink $CustomFilesArchive: $!";
    }

    # get a MD5Sum lookup table from all known files (from framework and packages)
    $Self->{MD5SumLookup} = $Self->_GetMD5SumLookup();

    # get the list of file to add to the Dump
    my @List = $Self->_GetCustomFileList( Directory => $Self->{Home} );

    # add files to the Dump
    my $TarObject = Archive::Tar->new();

    $TarObject->add_files(@List);

    # within the tar file the paths are not absolute, so leading "/" must be removed
    my $HomeWithoutSlash = $Self->{Home};
    $HomeWithoutSlash =~ s{\A\/}{};

    # Mask Passwords in Config.pm
    my $Config = $TarObject->get_content( $HomeWithoutSlash . '/Kernel/Config.pm' );

    if ( !$Config ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Kernel/Config.pm was not found in the modified files!",
        );
        return;
    }

    my @TrimAction = qw(
        DatabasePw
        SearchUserPw
        UserPw
        SendmailModule::AuthPassword
        AuthModule::Radius::Password
        PGP::Key::Password
        Customer::AuthModule::DB::CustomerPassword
        Customer::AuthModule::Radius::Password
    );

    STRING:
    for my $String (@TrimAction) {
        next STRING if !$String;
        $Config =~ s/(^\s+\$Self.*?$String.*?=.*?)\'.*?\';/$1\'xxx\';/mg;
    }
    $Config =~ s/(^\s+Password.*?=>.*?)\'.*?\',/$1\'xxx\',/mg;

    $TarObject->replace_content( $HomeWithoutSlash . '/Kernel/Config.pm', $Config );

    my $Write = $TarObject->write( $CustomFilesArchive, 0 );
    if ( !$Write ) {

        # log info
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't write $CustomFilesArchive: $!",
        );
        return;
    }

    # add files to the tar archive
    my $TARFH;
    if ( !open( $TARFH, '<', $CustomFilesArchive ) ) {    ## no critic

        # log info
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't read $CustomFilesArchive: $!",
        );
        return;
    }

    binmode $TARFH;
    my $TmpTar = do { local $/; <$TARFH> };
    close $TARFH;

    if ( $Self->{MainObject}->Require('Compress::Zlib') ) {
        my $GzTar = Compress::Zlib::memGzip($TmpTar);

        # log info
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Compression of $CustomFilesArchive end",
        );

        return ( \$GzTar, 'application.tar.gz' );
    }

    # log info
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "$CustomFilesArchive was not compressed",
    );

    return ( \$TmpTar, 'application.tar' );
}

=item GeneratePackageList()

Generates a .csv file with all installed packages

    my ( $Content, $Filename ) = $SupportBundleGeneratorObject->GeneratePackageList();

Returns:
    $Content  = $FileContentsRef;
    $Filename = 'InstalledPackages.csv';

=cut

sub GeneratePackageList {
    my ( $Self, %Param ) = @_;

    my @PackageList = $Self->{PackageObject}->RepositoryList( Result => 'Short' );

    my $CSVContent = '';
    for my $Package (@PackageList) {

        my @PackageData = (
            [
                $Package->{Name},
                $Package->{Version},
                $Package->{MD5sum},
                $Package->{Vendor},
            ],
        );

        # convert data into CSV string
        $CSVContent .= $Self->{CSVObject}->Array2CSV(
            Data => \@PackageData,
        );
    }
    return ( \$CSVContent, 'InstalledPackages.csv' );
}

=item GenerateRegistrationInfo()

Generates a .json file with the otrs system registration information

    my ( $Content, $Filename ) = $SupportBundleGeneratorObject->GenerateRegistrationInfo();

Returns:
    $Content  = $FileContentsRef;
    $Filename = 'RegistrationInfo.json';

=cut

sub GenerateRegistrationInfo {
    my ( $Self, %Param ) = @_;

    my %RegistrationInfo = $Self->{RegistrationObject}->RegistrationDataGet(
        Extended => 1,
    );

    my %Data;

    if (%RegistrationInfo) {
        my $State = $RegistrationInfo{State} || '';
        if ( $State && lc $State eq 'registered' ) {
            $State = 'active';
        }

        %Data = (
            %{ $RegistrationInfo{System} },
            State              => $State,
            APIVersion         => $RegistrationInfo{APIVersion},
            APIKey             => $RegistrationInfo{APIKey},
            LastUpdateID       => $RegistrationInfo{LastUpdateID},
            RegistrationKey    => $RegistrationInfo{UniqueID},
            SupportDataSending => $RegistrationInfo{SupportDataSending},
            Type               => $RegistrationInfo{Type},
            Description        => $RegistrationInfo{Description},
        );
    }
    else {
        %Data = %RegistrationInfo;
    }

    my $JSONContent = $Self->{JSONObject}->Encode(
        Data => \%Data,
    );
    return ( \$JSONContent, 'RegistrationInfo.json' );
}

=item GenerateSupportData()

Generates a .json file with the support data

    my ( $Content, $Filename ) = $SupportBundleGeneratorObject->GenerateSupportData();

Returns:
    $Content  = $FileContentsRef;
    $Filename = 'GenerateSupportData.json';

=cut

sub GenerateSupportData {
    my ( $Self, %Param ) = @_;

    my %SupportData = $Self->{SupportDataCollectorObject}->Collect();

    my $JSONContent = $Self->{JSONObject}->Encode(
        Data => \%SupportData,
    );

    return ( \$JSONContent, 'SupportData.json' );
}

sub _GetMD5SumLookup {
    my ( $Self, %Param ) = @_;

    # generate a MD5 Sum lookup table from framework ARCHIVE
    my $FileList = $Self->{MainObject}->FileRead(
        Location        => $Self->{Home} . '/ARCHIVE',
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'ARRAY',
        DisableWarnings => 1,
    );
    my %MD5SumLookup;
    for my $Line ( @{$FileList} ) {
        my ( $MD5Sum, $File ) = split /::/, $Line;
        chomp $File;
        $MD5SumLookup{ $Self->{Home} . '/' . $File } = $MD5Sum;
    }

    # get a list of packages installed
    my @PackagesList = $Self->{PackageObject}->RepositoryList(
        Result => 'short',
    );

    # get from each installed package  a MD5 Sum Lookup table and store it on a global Lookup table
    my %PackageMD5SumLookup;
    for my $Package (@PackagesList) {
        my $PartialMD5Sum = $Self->{PackageObject}->PackageFileGetMD5Sum( %{$Package} );
        %PackageMD5SumLookup = ( %PackageMD5SumLookup, %{$PartialMD5Sum} );
    }

    # TODO: Should we include also the .save files?

    # add MD5Sums from all packages to the list from framwork ARCHIVE
    # overwritten files by packages will also overwrite the MD5 Sum
    %MD5SumLookup = ( %MD5SumLookup, %PackageMD5SumLookup );

    return \%MD5SumLookup;
}

sub _GetCustomFileList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Directory)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # article directory
    my $ArticleDir = $Self->{ConfigObject}->Get('ArticleDir');

    # cleanup file name
    $ArticleDir =~ s/\/\//\//g;

    # temp directory
    my $TempDir = $Self->{ConfigObject}->Get('TempDir');

    # cleanup file name
    $TempDir =~ s/\/\//\//g;

    # check all $Param{Directory}/* in home directory
    my @Files;
    my @List = glob("$Param{Directory}/*");
    FILE:
    for my $File (@List) {

        # cleanup file name
        $File =~ s/\/\//\//g;

        # check if directory
        if ( -d $File ) {

            # do not include article in file system
            next FILE if $File =~ /\Q$ArticleDir\E/i;

            # do not include tmp in file system
            next FILE if $File =~ /\Q$TempDir\E/i;

            # do not include js-cache
            next FILE if $File =~ /js-cache/;

            # do not include css-cache
            next FILE if $File =~ /css-cache/;

            # do not include documentation
            next FILE if $File =~ /doc/;

            # add directory to list
            push @Files, $Self->_GetCustomFileList( Directory => $File );
        }
        else {

            # do not include hidden files
            next FILE if $File =~ /^\./;

            # do not include files with # in file name
            next FILE if $File =~ /#/;

            # do not include previous system dumps
            next FILE if $File =~ /.tar/;

            # do not include ARCHIVE
            next FILE if $File =~ /ARCHIVE/;

            # do not include if file is not readable
            next FILE if !-r $File;

            my $MD5Sum = $Self->{MainObject}->MD5sum(
                Filename => $File,
            );

            # check if is a known file, in such case, check if MD5 is the same as the expected
            #   skip file if MD5 matches
            if ( $Self->{MD5SumLookup}->{$File} && $Self->{MD5SumLookup}->{$File} eq $MD5Sum ) {
                next FILE;
            }

            # add file to list
            push @Files, $File;
        }
    }
    return @Files;
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
