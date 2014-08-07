# --
# PackageUninstallMerged.t - Package Uninstall Mergerd tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::Package;

# create local objects
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $PackageObject = Kernel::System::Package->new( %{$Self} );

# get OTRS Version
my $OTRSVersion = $Self->{ConfigObject}->Get('Version');

# leave only mayor and minor level versions
$OTRSVersion =~ s{ (\d+ \. \d+) .+ }{$1}msx;

# add x as patch level version
$OTRSVersion .= '.x';

# find out if it is an developer installation with files
# from the version control system.
my $DeveloperSystem = 0;
my $Home            = $ConfigObject->Get('Home');
my $Version         = $ConfigObject->Get('Version');
if (
    !-e $Home . '/ARCHIVE'
    && $Version =~ m{git}
    )
{
    $DeveloperSystem = 1;
}

# check #13 doesn't work on developer systems because there is no ARCHIVE file!
if ( !$DeveloperSystem ) {

    # install package normally
    my $String = '<?xml version="1.0" encoding="utf-8" ?>
    <otrs_package version="1.0">
      <Name>Test</Name>
      <Version>0.0.1</Version>
      <Vendor>OTRS AG</Vendor>
      <URL>http://otrs.org/</URL>
      <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
      <ChangeLog>2005-11-10 New package (some test &lt; &gt; &amp;).</ChangeLog>
      <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
      <Description Lang="de">Ein Test Paket (some test &lt; &gt; &amp;).</Description>
      <ModuleRequired Version="1.112">Encode</ModuleRequired>
      <Framework>' . $OTRSVersion . '</Framework>
      <BuildDate>2005-11-10 21:17:16</BuildDate>
      <BuildHost>yourhost.example.com</BuildHost>
      <Filelist>
        <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
        <File Location="var/Test" Permission="644" Encode="Base64">aGVsbG8K</File>
      </Filelist>
    </otrs_package>
    ';
    my $PackageInstall = $PackageObject->PackageInstall( String => $String );

    # check that the package is installed and files exists
    $Self->True(
        $PackageInstall,
        'PackageInstall() - package installed with true',
    );
    for my $File (qw( Test var/Test )) {
        my $RealFile = $Home . '/' . $File;
        $RealFile =~ s/\/\//\//g;
        $Self->True(
            -e $RealFile,
            "FileExists - $RealFile with true",
        );
    }

    # modify the installed package including one framework file, this will simulate that the
    # package was installed before feature merge into the framework, the idea is that the package
    # will be uninstalled, the not framewrok files will be removed and the framework files will
    # remain
    $String = '<?xml version="1.0" encoding="utf-8" ?>
    <otrs_package version="1.0">
      <Name>Test</Name>
      <Version>0.0.1</Version>
      <Vendor>OTRS AG</Vendor>
      <URL>http://otrs.org/</URL>
      <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
      <ChangeLog>2005-11-10 New package (some test &lt; &gt; &amp;).</ChangeLog>
      <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
      <Description Lang="de">Ein Test Paket (some test &lt; &gt; &amp;).</Description>
      <ModuleRequired Version="1.112">Encode</ModuleRequired>
      <Framework>' . $OTRSVersion . '</Framework>
      <BuildDate>2005-11-10 21:17:16</BuildDate>
      <BuildHost>yourhost.example.com</BuildHost>
      <Filelist>
        <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
        <File Location="var/Test" Permission="644" Encode="Base64">aGVsbG8K</File>
        <File Location="bin/otrs.CheckDB.pl" Permission="755" Encode="Base64">aGVsbG8K</File>
      </Filelist>
    </otrs_package>
    ';
    my $PackageName = 'Test';

    # the modifications has to be at DB level, otherwise a .save file will be generated for the
    # framework file, and we are trying to prvent it
    $Self->{DBObject}->Do(
        SQL => '
            UPDATE package_repository
            SET content = ?
            WHERE name = ?',
        Bind => [ \$String, \$PackageName ],
    );

    my $Content = 'Test 12345678';

    # now create an .save file for the framework file, content doesn't matter as it will be deleted
    my $Write = $Self->{MainObject}->FileWrite(
        Location   => $Home . '/bin/otrs.CheckDB.pl.save',
        Content    => \$Content,
        Mode       => 'binmode',
        Permission => '644',
    );
    $Self->True(
        $Write,
        '#FileWrite() - bin/otrs.CheckDB.pl.save',
    );

    # create PackageObject again to make sure cache is cleared
    my $PackageObject = Kernel::System::Package->new( %{$Self} );

    # run PackageUninstallMerged()
    my $Success = $PackageObject->_PackageUninstallMerged( Name => $PackageName );
    $Self->True(
        $Success,
        "_PackageUninstallMerged() - Executed with true",
    );

    # check that the original files from the package does not exists anymore
    # this files are supose to be old files that are not required any more by the merged package
    for my $File (qw( Test var/Test bin/otrs.CheckDB.pl.save )) {
        my $RealFile = $Home . '/' . $File;
        $RealFile =~ s/\/\//\//g;
        $Self->False(
            -e $RealFile,
            "FileExists - $RealFile with false",
        );
    }

    # check that the framework file still exists
    for my $File (qw( bin/otrs.CheckDB.pl )) {
        my $RealFile = $Home . '/' . $File;
        $RealFile =~ s/\/\//\//g;
        $Self->True(
            -e $RealFile,
            "FileExists - $RealFile with true",
        );
    }

    # check that the package is uninstalled
    my $PackageInstalled = $PackageObject->PackageIsInstalled(
        Name => $PackageName,
    );
    $Self->False(
        $PackageInstalled,
        'PackageIsInstalled() - with false',
    );
}

1;
