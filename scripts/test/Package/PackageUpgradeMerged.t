# --
# PackageUpgradeMerged.t - Package Uninstall Mergerd tests
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

# get needed objects
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $DBObject      = $Kernel::OM->Get('Kernel::System::DB');
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
#my $MainObject    = $Kernel::OM->Get('Kernel::System::Main');

# get OTRS Version
my $OTRSVersion = $ConfigObject->Get('Version');

# leave only mayor and minor level versions
$OTRSVersion =~ s{ (\d+ \. \d+) .+ }{$1}msx;

# add x as patch level version
$OTRSVersion .= '.x';

my $Home = $ConfigObject->Get('Home');

# install package normally
my $MergeOne = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>MergeOne</Name>
  <Version>2.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <ChangeLog>2012-04-28 New package (some test &lt; &gt; &amp;).</ChangeLog>
  <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
  <Description Lang="de">Ein Test Paket (some test &lt; &gt; &amp;).</Description>
  <ModuleRequired Version="1.112">Encode</ModuleRequired>
  <Framework>' . $OTRSVersion . '</Framework>
  <BuildDate>2012-05-02 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
    <File Location="var/Test" Permission="644" Encode="Base64">aGVsbG8K</File>
    <File Location="DeleteMe" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';

# install package using package manager API
my $PackageInstall = $PackageObject->PackageInstall( String => $MergeOne );

# check result ok install action
$Self->True(
    $PackageInstall,
    'PackageInstall() - package installed with true',
);

# check if the package is installed
my $PackageIsInstalled = $PackageObject->PackageIsInstalled(
    Name => 'MergeOne',
);

$Self->True(
    $PackageIsInstalled,
    'PackageIsInstalled() - package is installed with true',
);

# package from file should exist on file system
for my $File (qw( Test var/Test DeleteMe)) {
    my $RealFile = $Home . '/' . $File;
    $RealFile =~ s/\/\//\//g;
    $Self->True(
        -e $RealFile,
        "FileExists - $RealFile with true",
    );
}

my $PrincipalOne = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
    <Name>TestPrincipal</Name>
    <Version>1.0.1</Version>
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
    <PackageMerge Name="MergeOne" TargetVersion="2.0.0">
      <DatabaseUpgrade Type="merge">
          <TableCreate Name="merge_package">
              <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
              <Column Name="description" Required="true" Size="200" Type="VARCHAR"/>
          </TableCreate>
      </DatabaseUpgrade>
    </PackageMerge>
</otrs_package>
';

# install main package where the Test package was merged
$PackageInstall = $PackageObject->PackageInstall( String => $PrincipalOne );

# check that the package is not installed
# installed version is newer than target one
$Self->False(
    $PackageInstall,
    'PackageInstall() - Error, installed version is newer than target one',
);

# merged package should be still installed

# check if the package is installed
$PackageIsInstalled = $PackageObject->PackageIsInstalled(
    Name => 'MergeOne',
);

# check that the package for merging is still installed
$Self->True(
    $PackageIsInstalled,
    'PackageIsInstalled() - merged package should be still installed',
);

# get tmp dir location
my $TmpDir = $ConfigObject->Get('TempDir');

my $PrincipalTwo = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
    <Name>TestPrincipal</Name>
    <Version>1.0.1</Version>
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
    <PackageMerge Name="MergeOne" TargetVersion="2.0.1">
      <DatabaseUpgrade Type="merge" Version="2.0.2">
          <TableCreate Name="merge_package">
              <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
              <Column Name="description" Required="true" Size="200" Type="VARCHAR"/>
          </TableCreate>
        <Insert Table="merge_package">
            <Data Key="description" Type="Quote">Lalala1</Data>
        </Insert>
      </DatabaseUpgrade>
      <CodeUpgrade Type="merge" Version="2.0.3">
            my $Content = "test";
            $Kernel::OM&gt;Get(\'Kernel::System::Main\')-&gt;FileWrite(
                Location  =&gt; "' . $TmpDir . '/test1",
                Content   =&gt; \$Content,
            );
      </CodeUpgrade>
      <CodeUpgrade Type="merge" Version="2.0.2">
            my $Content = "test";
            $Kernel::OM&gt;Get(\'Kernel::System::Main\')-&gt;FileWrite(
                Location  =&gt; "' . $TmpDir . '/test2",
                Content   =&gt; \$Content,
            );
      </CodeUpgrade>
      <CodeUpgrade Type="merge" Version="2.0.1">
            my $Content = "test";
            $Kernel::OM&gt;Get(\'Kernel::System::Main\')-&gt;FileWrite(
                Location  =&gt; "' . $TmpDir . '/test3",
                Content   =&gt; \$Content,
            );
      </CodeUpgrade>
      <CodeUpgrade Type="merge">
            my $Content = "test";
            $Kernel::OM&gt;Get(\'Kernel::System::Main\')-&gt;FileWrite(
                Location  =&gt; "' . $TmpDir . '/test4",
                Content   =&gt; \$Content,
            );
      </CodeUpgrade>
    </PackageMerge>
    <DatabaseUninstall Type="post">
      <TableDrop Name="merge_package"/>
    </DatabaseUninstall>
</otrs_package>
';

# install main package where the Test package was merged
$PackageInstall = $PackageObject->PackageInstall( String => $PrincipalTwo );

# check that the package is installed and files exists
$Self->True(
    $PackageInstall,
    'PackageInstall() - package installed with true',
);

# merged package shouldn't be installed any more
# check if the package is installed
$PackageIsInstalled = $PackageObject->PackageIsInstalled(
    Name => 'MergeOne',
);

# check that the package is NOT installed
$Self->False(
    $PackageIsInstalled,
    'PackageIsInstalled() - merged package shouln\'t be installed',
);

# check that the original files from the package does not exists anymore
# this files are supose to be old files that are not required any more by the merged package
for my $File (qw( Delete DeleteMe )) {
    my $RealFile = $Home . '/' . $File;
    $RealFile =~ s/\/\//\//g;
    $Self->False(
        -e $RealFile,
        "FileExists - $RealFile with false",
    );
}

# check that the framework file still exists including the .save file
for my $File (qw( bin/otrs.CheckDB.pl )) {
    my $RealFile = $Home . '/' . $File;
    $RealFile =~ s/\/\//\//g;
    $Self->True(
        -e $RealFile,
        "FileExists - $RealFile with true",
    );
}

# since target version and installed version matched
# no database script should be executed, no new table present

my $ResultFalse = $DBObject->Prepare(
    SQL   => 'SELECT * FROM merge_package',
    Limit => 1,
);

$Self->False(
    $ResultFalse,
    'Prepare() SELECT - Prepare',
);

# remove principal packages
$PackageObject->PackageUninstall( String => $PrincipalTwo );

# reinstall merged for executing database script

# install package using package manager API
$PackageInstall = $PackageObject->PackageInstall( String => $MergeOne );

# check result ok install action
$Self->True(
    $PackageInstall,
    'PackageInstall() - package installed with true',
);

# check if the package is installed
$PackageIsInstalled = $PackageObject->PackageIsInstalled(
    Name => 'MergeOne',
);

$Self->True(
    $PackageIsInstalled,
    'PackageIsInstalled() - package is installed with true',
);

# copy package for installing
my $PrincipalThree = $PrincipalTwo;

my $PrevVersion   = 'TargetVersion="2.0.1"';
my $ActualVersion = 'TargetVersion="2.0.2"';

# change target version
$PrincipalThree =~ s{$PrevVersion}{$ActualVersion}g;

# install main package where the Test package was merged
$PackageInstall = $PackageObject->PackageInstall( String => $PrincipalThree );

# check that the package is installed and files exists
$Self->True(
    $PackageInstall,
    'PackageInstall() - package installed with true',
);

# merged package shouldn't be installed any more

# check if the package is installed
$PackageIsInstalled = $PackageObject->PackageIsInstalled(
    Name => 'MergeOne',
);

# check that the package is NOT installed
$Self->False(
    $PackageIsInstalled,
    'PackageIsInstalled() - merged package shouln\'t be installed',
);

# database merge script might be executed, so insert a record
# should be possible

$DBObject->Prepare( SQL => 'SELECT description FROM merge_package' );
my $Result;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $Result = $Row[0];
}

$Result //= '';

$Self->Is(
    $Result,
    'Lalala1',
    'SQL check - merge_package table was created and have one record for select',
);

$Self->True(
    !-f $TmpDir . '/test1',
    '#5 PackageUpgrade() - CodeUpgrade with version 2.0.3 (no file).',
);

$Self->True(
    -f $TmpDir . '/test2',
    '#5 PackageUpgrade() - CodeUpgrade with version 2.0.2.',
);
unlink $TmpDir . '/test2';
$Self->True(
    -f $TmpDir . '/test3',
    '#5 PackageUpgrade() - CodeUpgrade with version 2.0.1.',
);
unlink $TmpDir . '/test3';
$Self->True(
    -f $TmpDir . '/test4',
    '#5 PackageUpgrade() - CodeUpgrade without version.',
);
unlink $TmpDir . '/test4';

# remove principal packages
$PackageObject->PackageUninstall( String => $MergeOne );

$PackageObject->PackageUninstall( String => $PrincipalThree );

# define package for merging
my $MergeThree = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>MergeThree</Name>
  <Version>3.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">The third test package.</Description>
  <Framework>' . $OTRSVersion . '</Framework>
  <BuildDate>2014-05-02 17:59:59</BuildDate>
  <BuildHost>myhost.example.com</BuildHost>
  <Filelist>
    <File Location="DeleteMePlease" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';

my $PrincipalFour = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
    <Name>TestPrincipalFour</Name>
    <Version>1.0.1</Version>
    <Vendor>OTRS AG</Vendor>
    <URL>http://otrs.org/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
    <ChangeLog>2014-04-28 New package (some test &lt; &gt; &amp;).</ChangeLog>
    <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
    <Framework>' . $OTRSVersion . '</Framework>
    <BuildDate>2014-04-28 16:16:16</BuildDate>
    <BuildHost>yourhost.example.com</BuildHost>
    <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
    <File Location="DeleteMe" Permission="644" Encode="Base64">aGVsbG8K</File>
    </Filelist>

    %PackageMergeSection%

    <DatabaseInstall %LabelReplace% Type="pre">
        <TableCreate Name="test_package">
            <Column Name="name_a" Required="true" Type="INTEGER"/>
            <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
            <Column Name="name_c" Required="false" Size="60" Type="VARCHAR"/>
        </TableCreate>
        <Insert Table="test_package">
            <Data Key="name_a">1234</Data>
            <Data Key="name_b" Type="Quote">some text</Data>
            <Data Key="name_c" Type="Quote">some text &lt;more&gt;
              text &amp; text
            </Data>
        </Insert>
    </DatabaseInstall>
    <DatabaseUninstall Type="post">
        <TableDrop Name="test_package"/>
    </DatabaseUninstall>
    <CodeInstall %LabelReplace%>
        my $Content = "test";
        $Kernel::OM&gt;Get(\'Kernel::System::Main\')-&gt;FileWrite(
            Location  =&gt; "' . $TmpDir . '/test5",
            Content   =&gt; \$Content,
        );
    </CodeInstall>
</otrs_package>
';

my $PackageMergeSection = '<PackageMerge Name="MergeThree" TargetVersion="3.0.2"></PackageMerge>';

my @Tests = (
    {
        Name           => 'Test No package installed IfPackage tag',
        InstallPackage => 0,
        PackageMerge   => 1,
        Label          => "IfPackage",
        SQLTest        => 'IsNot',
        CodeTest       => 'False',
    },
    {
        Name           => 'Test No package installed IfNotPackage tag',
        InstallPackage => 0,
        PackageMerge   => 1,
        Label          => "IfNotPackage",
        SQLTest        => 'Is',
        CodeTest       => 'True',
    },
    {
        Name           => 'Test No package installed no condition package tag',
        InstallPackage => 0,
        PackageMerge   => 1,
        Label          => "",
        SQLTest        => 'Is',
        CodeTest       => 'True',
    },

    {
        Name           => 'Test No package installed IfPackage tag',
        InstallPackage => 0,
        PackageMerge   => 0,
        Label          => "IfPackage",
        SQLTest        => 'IsNot',
        CodeTest       => 'False',
    },
    {
        Name           => 'Test No package installed IfNotPackage tag',
        InstallPackage => 0,
        PackageMerge   => 0,
        Label          => "IfNotPackage",
        SQLTest        => 'Is',
        CodeTest       => 'True',
    },
    {
        Name           => 'Test No package installed no condition package tag',
        InstallPackage => 0,
        PackageMerge   => 0,
        Label          => "",
        SQLTest        => 'Is',
        CodeTest       => 'True',
    },

    {
        Name           => 'Test package installed IfPackage tag',
        InstallPackage => 1,
        PackageMerge   => 1,
        Label          => "IfPackage",
        SQLTest        => 'Is',
        CodeTest       => 'True',
    },
    {
        Name           => 'Test package installed IfNotPackage tag',
        InstallPackage => 1,
        PackageMerge   => 1,
        Label          => "IfNotPackage",
        SQLTest        => 'IsNot',
        CodeTest       => 'False',
    },
    {
        Name           => 'Test package installed no condition package tag',
        InstallPackage => 1,
        PackageMerge   => 1,
        Label          => "",
        SQLTest        => 'Is',
        CodeTest       => 'True',
    },

    {
        Name           => 'Test package installed IfPackage tag',
        InstallPackage => 1,
        PackageMerge   => 0,
        Label          => "IfPackage",
        SQLTest        => 'Is',
        CodeTest       => 'True',
    },
    {
        Name           => 'Test package installed IfNotPackage tag',
        InstallPackage => 1,
        PackageMerge   => 0,
        Label          => "IfNotPackage",
        SQLTest        => 'IsNot',
        CodeTest       => 'False',
    },
    {
        Name           => 'Test package installed no condition package tag',
        InstallPackage => 1,
        PackageMerge   => 0,
        Label          => "",
        SQLTest        => 'Is',
        CodeTest       => 'True',
    },
);

for my $Test (@Tests) {

    if ( $Test->{InstallPackage} ) {

        # install predefined package
        my $AuxPackageInstall = $PackageObject->PackageInstall( String => $MergeThree );

        # check that the package is installed
        $Self->True(
            $AuxPackageInstall,
            'PackageInstall() - package installed with true for IfPackage test.',
        );
    }

    #check if an extra label might be added
    my $LabelReplacement = '';
    if ( $Test->{Label} ) {
        $LabelReplacement = $Test->{Label} . '="MergeThree"';
    }

    # duplicate string for don't replace on base string
    my $AuxPackageString = $PrincipalFour;

    # change IfPackage by IfNotPackage
    my $ReplacementOrigin = '%LabelReplace%';
    $AuxPackageString =~ s{$ReplacementOrigin}{$LabelReplacement}g;

    $ReplacementOrigin = '%PackageMergeSection%';
    $LabelReplacement  = '';
    if ( $Test->{PackageMerge} ) {

        # insert package merge section
        $LabelReplacement = $PackageMergeSection;
    }
    $AuxPackageString =~ s{$ReplacementOrigin}{$LabelReplacement}g;

    # install principal package
    my $PrincipalPackageInstall = $PackageObject->PackageInstall( String => $AuxPackageString );

    # check that the package is installed
    $Self->True(
        $PrincipalPackageInstall,
        'PackageInstall() - principal package installed with true for IfPackage test.',
    );

    # ------- Check Results ------- #

    # if everything is OK was possible to create test_package table
    my $SQLResult = '';
    if ( $DBObject->Prepare( SQL => 'SELECT name_a FROM test_package' ) ) {

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $SQLResult = $Row[0];
        }
    }

    my $SQLTest = $Test->{SQLTest};
    $Self->$SQLTest(
        $SQLResult,
        '1234',
        'SQL check - test_package table creation select one record',
    );

    my $CodeTest   = $Test->{CodeTest};
    my $FileExists = -f $TmpDir . '/test5';

    # was possible to execute CodeInstall
    $Self->$CodeTest(
        $FileExists,
        "PackageInstall() - CodeInstall $Test->{Name}.",
    );

    # ------- Cleanup ------- #

    unlink $TmpDir . '/test5' if $FileExists;

    # uninstall principal package
    $PackageObject->PackageUninstall( String => $AuxPackageString );

    # check if the package is installed
    my $PrincipalPackageIsInstalled = $PackageObject->PackageIsInstalled(
        Name => 'PrincipalFour',
    );

    # check that the package is NOT installed
    $Self->False(
        $PrincipalPackageIsInstalled,
        "PackageIsInstalled() - principal package for IfPackage test shouldn't be installed anymore.",
    );

    # check if the package is installed
    my $MergePackageIsInstalled = $PackageObject->PackageIsInstalled(
        Name => 'MergeThree',
    );

    if ($MergePackageIsInstalled) {

        # uninstall predefined package
        $PackageObject->PackageUninstall( String => $MergeThree );

        # check if the package is installed
        my $AuxPackageIsInstalled = $PackageObject->PackageIsInstalled(
            Name => 'MergeThree',
        );

        # check that the package is NOT installed
        $Self->False(
            $AuxPackageIsInstalled,
            "PackageIsInstalled() - package for IfPackage test shouldn't be installed anymore.",
        );
    }
}

1;
