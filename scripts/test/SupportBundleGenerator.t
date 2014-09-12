# --
# SupportBundleGenerator.t - SupportBundleGenerator tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Archive::Tar;

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject                 = $Kernel::OM->Get('Kernel::Config');
my $HelperObject                 = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MainObject                   = $Kernel::OM->Get('Kernel::System::Main');
my $SupportBundleGeneratorObject = $Kernel::OM->Get('Kernel::System::SupportBundleGenerator');
my $PackageObject                = $Kernel::OM->Get('Kernel::System::Package');
my $CSVObject                    = $Kernel::OM->Get('Kernel::System::CSV');
my $JSONObject                   = $Kernel::OM->Get('Kernel::System::JSON');
my $RegistrationObject           = $Kernel::OM->Get('Kernel::System::Registration');
my $SupportDataCollectorObject   = $Kernel::OM->Get('Kernel::System::SupportDataCollector');
my $TempObject                   = $Kernel::OM->Get('Kernel::System::FileTemp');

# cleanup the Home variable (remove tailing "/")
my $Home = $ConfigObject->Get('Home');
$Home =~ s{\/\z}{};

my $IsDevelopmentSystem;
if ( !-e $Home . '/ARCHIVE' ) {
    $IsDevelopmentSystem = 1;

    # perfect time to test the missing ARCHVIVE
    my $Result = $SupportBundleGeneratorObject->Generate();

    $Self->False(
        $Result->{Success},
        "Generate() - for a system without ARCHIVE file with false",
    );
}

# create an ARCHIVE file on developer systems to continue working
if ($IsDevelopmentSystem) {
    my $ArchiveGeneratorTool = $Home . '/bin/otrs.CheckSum.pl';

    # if tool is not present we can't continue
    if ( !-e $ArchiveGeneratorTool ) {
        $Self->True(
            0,
            "$ArchiveGeneratorTool does not exist, we can't continue",
        );
        return;
    }

    # execute ARCHIVE generator tool
    my $Result = `$ArchiveGeneratorTool -a create`;

    if ( !-e $Home . '/ARCHIVE' || -z $Home . '/ARCHIVE' ) {

        # if ARCHIVE file is not present we can't continue
        $Self->True(
            0,
            "ARCHIVE file was not generated, we can't continue",
        );
        return;
    }
    else {
        $Self->True(
            1,
            "ARCHIVE file was generated for a developer system",
        );

        # delete Kernel/Config.pm file from archive file
        my $ArchiveContent = $MainObject->FileRead(
            Location => $Home . '/ARCHIVE',
            Result   => 'ARRAY',
        );
        my $Output;
        my $File = 'Kernel/Config.pm';
        for my $Line ( @{$ArchiveContent} ) {
            if ( $Line =~ m(\A\w+::$File\n\z) ) {
                $Line = int( rand(1000000) ) . "::$File\n";
            }
            $Output .= $Line;
        }

        my $FileLocation = $MainObject->FileWrite(
            Location => $Home . '/ARCHIVE',
            Content  => \$Output,
        );
    }

}

# get OTRS Version
my $OTRSVersion = $ConfigObject->Get('Version');

# leave only mayor and minor level versions
$OTRSVersion =~ s{ (\d+ \. \d+) .+ }{$1}msx;

# add x as patch level version
$OTRSVersion .= '.x';

my $TestPackage = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <ChangeLog>2005-11-10 New package (some test &lt; &gt; &amp;).</ChangeLog>
  <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
  <Framework>' . $OTRSVersion . '</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
    <File Location="var/Test" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';

# tests for GenerateCustom Files Archive
my @Tests = (
    {
        Name          => 'Framework - Only Config',
        RequiredFiles => ["$Home/Kernel/Config.pm"],
    },
    {
        Name          => 'Package - Only Config',
        RequiredFiles => ["$Home/Kernel/Config.pm"],
        ProhibitFiles => [
            "$Home/Test",
            "$Home/var/Test",
        ],
        InstallPackages => {
            Test => $TestPackage,
        },
    },
    {
        Name          => 'Package - Modified File',
        RequiredFiles => [
            "$Home/Kernel/Config.pm",
            "$Home/var/Test",
        ],
        ProhibitFiles => [
            "$Home/Test",
        ],
        ModifyFiles => [
            "$Home/var/Test",
        ],
        UninstallPackages => {
            Test => $TestPackage,
        },
    },
);

my @FilesToDelete;

for my $Test (@Tests) {

    # prepare testing environment
    if ( IsHashRefWithData( $Test->{InstallPackages} ) ) {

        for my $Package ( sort keys %{ $Test->{InstallPackages} } ) {
            my $Success =
                $PackageObject->PackageInstall( String => $Test->{InstallPackages}->{$Package} );
            $Self->True(
                $Success,
                "$Test->{Name}: PackageInstall() - Package:'$Package' with True",
            );
        }
    }
    if ( IsArrayRefWithData( $Test->{ModifyFiles} ) ) {

        for my $File ( @{ $Test->{ModifyFiles} } ) {

            # this operation is destructive be aware of it!
            my $Content = $HelperObject->GetRandomID();
            $Content .= "\n";
            my $FileLocation = $MainObject->FileWrite(
                Location => $File,
                Content  => \$Content,
            );
            $Self->IsNot(
                $FileLocation,
                undef,
                "$Test->{Name}: Modified File - $File"
            );
            push @FilesToDelete, $File;
        }
    }

    # execute function
    my ( $Content, $Filename ) = $SupportBundleGeneratorObject->GenerateCustomFilesArchive();

    $Self->IsNot(
        bytes::length( ${$Content} ) / ( 1024 * 1024 ),
        0,
        "$Test->{Name}: GenerateCustomFilesArchive() - The size of the application.tar is not 0",
    );
    my $ExpectedFilename = 'application.tar';
    if ( $Filename =~ m{\.gz\z} ) {
        $ExpectedFilename .= '.gz';
    }
    $Self->Is(
        $Filename,
        $ExpectedFilename,
        "$Test->{Name}: GenerateCustomFilesArchive() - Filename"
    );

    # save as a tmp file
    my ( $FileHandle, $TmpFilename ) = $TempObject->TempFile();
    binmode $FileHandle;
    print $FileHandle ${$Content};
    close $FileHandle;

    # new instance from tar object
    my $TarObject = Archive::Tar->new();

    # get files from tar
    my $FileCount = $TarObject->read($TmpFilename);
    $Self->IsNot(
        $FileCount,
        undef,
        "$Test->{Name}: GenerateCustomFilesArchive() - The number or files within application.tar should not be undef",
    );
    my @FileList = $TarObject->get_files();

    # create a lookup table (@FileList contains Archive::Tar::File objects)
    my %FileListLookup = map { $_->full_path() => 1 } sort @FileList;

    # check for files that must be in the application.tar file
    if ( IsArrayRefWithData( $Test->{RequiredFiles} ) ) {
        for my $File ( @{ $Test->{RequiredFiles} } ) {

            # remove heading slash
            $File =~ s{\A\/}{};
            $Self->True(
                $FileListLookup{$File},
                "$Test->{Name}: GenerateCustomFilesArchive() - Required:'$File' is in the application.tar file",
            );
        }
    }

    # check for files that must be in the application.tar file
    if ( IsArrayRefWithData( $Test->{ProhibitFiles} ) ) {
        for my $File ( @{ $Test->{ProhibitFiles} } ) {

            # remove heading slash
            $File =~ s{\A\/}{};
            $Self->False(
                $FileListLookup{$File},
                "$Test->{Name}: GenerateCustomFilesArchive() - Prohibit'$File' is not the application.tar file",
            );
        }
    }

    # clean environment
    if ( IsHashRefWithData( $Test->{UninstallPackages} ) ) {

        for my $Package ( sort keys %{ $Test->{UninstallPackages} } ) {
            my $Success =
                $PackageObject->PackageUninstall(
                String => $Test->{UninstallPackages}->{$Package}
                );
            $Self->True(
                $Success,
                "$Test->{Name}: PackageUninstall() - Package:'$Package' with True",
            );
            for my $File (@FilesToDelete) {
                unlink $File . '.custom_backup'
            }
        }
    }
}

# tests for GeneratePackageList

@Tests = (
    {
        Name => 'No Packages',
    },
    {
        Name            => 'Test Package',
        InstallPackages => {
            Test => $TestPackage,
        },
        UninstallPackages => {
            Test => $TestPackage,
        },
    },
);

for my $Test (@Tests) {

    my @OriginalList = $PackageObject->RepositoryList(
        Result => 'short',
    );

    # prepare testing environment
    if ( IsHashRefWithData( $Test->{InstallPackages} ) ) {

        for my $Package ( sort keys %{ $Test->{InstallPackages} } ) {
            my $Success =
                $PackageObject->PackageInstall( String => $Test->{InstallPackages}->{$Package} );
            $Self->True(
                $Success,
                "$Test->{Name}: PackageInstall() - Package:'$Package' with True",
            );
        }
    }

    # execute function
    my ( $Content, $Filename ) = $SupportBundleGeneratorObject->GeneratePackageList();

    if ( $Test->{InstallPackages} || scalar @OriginalList ) {
        $Self->IsNot(
            bytes::length( ${$Content} ) / ( 1024 * 1024 ),
            0,
            "$Test->{Name}: GeneratePackageList() - The size of the InstalledPackages.csv is not 0",
        );
    }
    else {
        $Self->Is(
            bytes::length( ${$Content} ),
            0,
            "$Test->{Name}: GeneratePackageList() - The size of the InstalledPackages.csv is 0",
        );
    }
    $Self->Is(
        $Filename,
        'InstalledPackages.csv',
        "$Test->{Name}: GeneratePackageList() - Filename"
    );

    my @PackageListRaw = $PackageObject->RepositoryList( Result => 'Short' );

    my @PackageList;
    for my $Package (@PackageListRaw) {

        my @PackageData = (
            [
                $Package->{Name},
                $Package->{Version},
                $Package->{MD5sum},
                $Package->{Vendor},
            ],
        );

        push @PackageList, @PackageData,
    }

    my $RefArray = $CSVObject->CSV2Array(
        String => ${$Content},
    );

    $Self->IsDeeply(
        $RefArray,
        \@PackageList,
        "$Test->{Name}: GeneratePackageList() - Content"
    );

    # clean environment
    if ( IsHashRefWithData( $Test->{UninstallPackages} ) ) {

        for my $Package ( sort keys %{ $Test->{UninstallPackages} } ) {
            my $Success =
                $PackageObject->PackageUninstall(
                String => $Test->{UninstallPackages}->{$Package}
                );
            $Self->True(
                $Success,
                "$Test->{Name}: PackageUninstall() - Package:'$Package' with True",
            );
        }
    }
}

# GenerateRegistrationInfo tests
my %RegistrationInfo = $RegistrationObject->RegistrationDataGet();

# execute function
my ( $Content, $Filename ) = $SupportBundleGeneratorObject->GenerateRegistrationInfo();

if (%RegistrationInfo) {
    $Self->IsNot(
        bytes::length( ${$Content} ) / ( 1024 * 1024 ),
        0,
        "GenerateRegistrationInfo() - The size of the RegistrationInfo.json is not 0",
    );
}

# by encoding an empty string into JSON it will produce '{}' which is exactly 2 bytes
else {
    $Self->Is(
        bytes::length( ${$Content} ),
        2,
        "GenerateRegistrationInfo() - The size of the  RegistrationInfo.json is 2",
    );
}
$Self->Is(
    $Filename,
    'RegistrationInfo.json',
    "GenerateRegistrationInfo() - Filename"
);

my $PerlStructureScalar = $JSONObject->Decode(
    Data => ${$Content},
);

if (%RegistrationInfo) {
    for my $Attribute (
        qw(
        FQDN OTRSVersion OSType OSVersion DatabaseVersion PerlVersion
        Description SupportDataSending RegistrationKey APIKey State Type
        )
        )
    {
        $Self->IsNot(
            $PerlStructureScalar->{$Attribute},
            undef,
            "GenerateRegistrationInfo() - $Attribute should not be undef",
        );
        $Self->IsNot(
            $PerlStructureScalar->{$Attribute},
            '',
            "GenerateRegistrationInfo() - $Attribute should not be empty",
        );
    }
}

# GenerateSupportData tests
my %OriginalResult = $SupportDataCollectorObject->Collect();

# for this test we will just check that both results has the same identifiers
my %OriginalIdentifiers;
for my $Entry ( @{ $OriginalResult{Result} } ) {
    $OriginalIdentifiers{ $Entry->{Identifier} } = $Entry->{DisplayPath};
}
$OriginalResult{Result} = \%OriginalIdentifiers;

# for some strange reasons if mod_perl is activated, it happnes that some times it uses it and
# sometimes is doesn't for this test we delete the possible offending identifiers
for my $Identifier (
    qw(
    Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ApacheDBIUsed
    Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ApacheReloadUsed
    Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ModDeflateLoaded
    Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ModHeadersLoaded
    Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::MOD_PERL
    Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::MOD_PERL_API_VERSION
    )
    )
{
    delete $OriginalResult{Result}->{$Identifier};
}

# execute function
( $Content, $Filename ) = $SupportBundleGeneratorObject->GenerateSupportData();

if (%OriginalResult) {
    $Self->IsNot(
        bytes::length( ${$Content} ) / ( 1024 * 1024 ),
        0,
        "GenerateSupportData() - The size of the SupportData.json is not 0",
    );
}
else {
    $Self->Is(
        bytes::length( ${$Content} ),
        0,
        "GenerateSupportData() - The size of the  SupportData.json is 0",
    );
}
$Self->Is(
    $Filename,
    'SupportData.json',
    "GenerateSupportData() - Filename"
);

$PerlStructureScalar = $JSONObject->Decode(
    Data => ${$Content},
);

my %NewIdentifiers;
for my $Entry ( @{ $PerlStructureScalar->{Result} } ) {
    $NewIdentifiers{ $Entry->{Identifier} } = $Entry->{DisplayPath};
}
$PerlStructureScalar->{Result} = \%NewIdentifiers;

# for some strange reasons if mod_perl is activated, it happnes that some times it uses it and
# sometimes is doesn't for this test we delete the possible offending identifiers
for my $Identifier (
    qw(
    Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ApacheDBIUsed
    Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ApacheReloadUsed
    Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ModDeflateLoaded
    Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ModHeadersLoaded
    Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::MOD_PERL
    Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::MOD_PERL_API_VERSION
    )
    )
{
    delete $PerlStructureScalar->{Result}->{$Identifier};
}

$Self->IsDeeply(
    \%OriginalResult,
    $PerlStructureScalar,
    "GenerateSupportData() - Result",
);

# Generate tests
my $Result = $SupportBundleGeneratorObject->Generate();

$Self->True(
    $Result->{Success},
    "Generate() - With True",
);
$Self->IsNot(
    bytes::length( $Result->{Data}->{Filecontent} ) / ( 1024 * 1024 ),
    0,
    "Generate() - The size of the file is not 0",
);
$Self->IsNot(
    bytes::length( $Result->{Data}->{Filecontent} ) / ( 1024 * 1024 ),
    $Result->{Data}->{Filesize},
    "Generate() - The size of the file",
);
$Self->IsNot(
    $Result->{Data}->{Filename},
    undef,
    "Generate() - Filename"
);

# save as a tmp file
my ( $FileHandle, $TmpFilename ) = $TempObject->TempFile();
binmode $FileHandle;
print $FileHandle ${ $Result->{Data}->{Filecontent} };
close $FileHandle;

# new instance from tar object
my $TarObject = Archive::Tar->new();

# get files from tar
my $FileCount = $TarObject->read($TmpFilename);
$Self->Is(
    $FileCount,
    4,
    "Generate() - The number or files",
);
my @FileList = $TarObject->get_files();

# create a lookup table (@FileList contains Archive::Tar::File objects)
my %FileListLookup = map { $_->name() => 1 } sort @FileList;

# check for files that must be in the tar file
my @ExpectedFiles   = qw(InstalledPackages.csv RegistrationInfo.json SupportData.json);
my $ApplicationFile = 'application.tar';
if ( $Result->{Data}->{Filename} =~ m{\.gz} ) {
    $ApplicationFile .= '.gz';
}
push @ExpectedFiles, $ApplicationFile;
for my $File (@ExpectedFiles) {
    $Self->True(
        $FileListLookup{$File},
        "Generate() - Required:'$File' is in the tar file",
    );
}

# cleanup
if ($IsDevelopmentSystem) {
    my $Success = unlink $Home . '/ARCHIVE';
    $Self->True(
        $Success,
        "ARCHIVE was deleted form a developer system"
    );
}

1;
