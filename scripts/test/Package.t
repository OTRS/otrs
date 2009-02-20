# --
# Package.t - Package tests
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Package.t,v 1.16.2.5 2009-02-20 11:49:40 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use Kernel::System::Package;
use File::Copy;

$Self->{PackageObject} = Kernel::System::Package->new( %{$Self} );

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
  <Framework>2.4.x</Framework>
  <Framework>2.3.x</Framework>
  <Framework>2.2.x</Framework>
  <Framework>2.1.x</Framework>
  <Framework>2.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <CodeInstall>
   # just a test &lt;some&gt; plus some &amp; text
  </CodeInstall>
  <DatabaseInstall>
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
    <Insert Table="test_package">
        <Data Key="name_a">0</Data>
        <Data Key="name_b" Type="Quote">1</Data>
    </Insert>
  </DatabaseInstall>
  <DatabaseUninstall>
    <TableDrop Name="test_package"/>
  </DatabaseUninstall>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
    <File Location="var/Test" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';

my $RepositoryAdd = $Self->{PackageObject}->RepositoryAdd(
    String => $String,
);

$Self->True(
    $RepositoryAdd,
    '#1 RepositoryAdd()',
);

my $PackageGet = $Self->{PackageObject}->RepositoryGet(
    Name    => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $String eq $PackageGet,
    '#1 RepositoryGet()',
);

my $PackageRemove = $Self->{PackageObject}->RepositoryRemove(
    Name    => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $PackageRemove,
    '#1 RepositoryRemove()',
);

my $PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String,
);

$Self->True(
    $PackageInstall,
    '#1 PackageInstall()',
);

my $DeployCheck = $Self->{PackageObject}->DeployCheck(
    Name    => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $DeployCheck,
    '#1 DeployCheck()',
);

my %Structure = $Self->{PackageObject}->PackageParse(
    String => $String,
);

my $PackageBuild = $Self->{PackageObject}->PackageBuild(
    %Structure,
);

$Self->True(
    $PackageBuild,
    '#1 PackageBuild()',
);

my $PackageUninstall = $Self->{PackageObject}->PackageUninstall(
    String => $String,
);

$Self->True(
    $PackageUninstall,
    '#1 PackageUninstall()',
);

my $PackageInstall2 = $Self->{PackageObject}->PackageInstall(
    String => $PackageBuild,
);

$Self->True(
    $PackageInstall2,
    '#1 PackageInstall() - 2',
);

my $DeployCheck2 = $Self->{PackageObject}->DeployCheck(
    Name    => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $DeployCheck2,
    '#1 DeployCheck() - 2',
);

my $PackageUninstall2 = $Self->{PackageObject}->PackageUninstall(
    String => $PackageBuild,
);

$Self->True(
    $PackageUninstall2,
    '#1 PackageUninstall() - 2',
);

$String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test2</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <PackageRequired Version="0.1">SomeNotExistingModule</PackageRequired>
  <Framework>2.4.x</Framework>
  <Framework>2.3.x</Framework>
  <Framework>2.2.x</Framework>
  <Framework>2.1.x</Framework>
  <Framework>2.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';
$PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String,
);

$Self->True(
    !$PackageInstall || 0,
    '#2 PackageInstall() - PackageRequired not installed',
);

$String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test2</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <ModuleRequired Version="0.1">SomeNotExistingModule</ModuleRequired>
  <Framework>2.4.x</Framework>
  <Framework>2.3.x</Framework>
  <Framework>2.2.x</Framework>
  <Framework>2.1.x</Framework>
  <Framework>2.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';
$PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String,
);

$Self->True(
    !$PackageInstall || 0,
    '#3 PackageInstall() - ModuleRequired not installed',
);
$String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test2</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <ModuleRequired Version="12.999">Encode</ModuleRequired>
  <Framework>2.4.x</Framework>
  <Framework>2.3.x</Framework>
  <Framework>2.2.x</Framework>
  <Framework>2.1.x</Framework>
  <Framework>2.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';
$PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String,
);

$Self->True(
    !$PackageInstall || 0,
    '#4 PackageInstall() - ModuleRequired Min',
);

# #5 file exists tests
my $String1 = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test2</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <Framework>2.4.x</Framework>
  <Framework>2.3.x</Framework>
  <Framework>2.2.x</Framework>
  <Framework>2.1.x</Framework>
  <Framework>2.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';
$PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String1,
);
$Self->True(
    $PackageInstall || 0,
    '#5 PackageInstall() - 1/3 File already exists in package X.',
);
my $String2 = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test3</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <Framework>2.4.x</Framework>
  <Framework>2.3.x</Framework>
  <Framework>2.2.x</Framework>
  <Framework>2.1.x</Framework>
  <Framework>2.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';
$PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String2,
);

$Self->True(
    !$PackageInstall || 0,
    '#5 PackageInstall() - 2/3 File already exists in package X.',
);
my $String3 = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test3</Name>
  <Version>0.0.2</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <Framework>2.4.x</Framework>
  <Framework>2.3.x</Framework>
  <Framework>2.2.x</Framework>
  <Framework>2.1.x</Framework>
  <Framework>2.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test3" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';
$PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String3,
);
my $String3a = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test3</Name>
  <Version>0.0.3</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <Framework>2.4.x</Framework>
  <Framework>2.3.x</Framework>
  <Framework>2.2.x</Framework>
  <Framework>2.1.x</Framework>
  <Framework>2.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';

my $PackageUpgrade = $Self->{PackageObject}->PackageUpgrade(
    String => $String3a,
);

$Self->True(
    !$PackageUpgrade || 0,
    '#5 PackageUpgrade() - 2/3 File already exists in package X.',
);

my $TmpDir   = $Self->{ConfigObject}->Get('TempDir');
my $String3b = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test3</Name>
  <Version>0.0.3</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <Framework>2.4.x</Framework>
  <Framework>2.3.x</Framework>
  <Framework>2.2.x</Framework>
  <Framework>2.1.x</Framework>
  <Framework>2.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <CodeUpgrade Type="pre" Version="0.0.4">
        my $Content = "test";
        $Self->{MainObject}-&gt;FileWrite(
            Location  =&gt; "' . $TmpDir . '/test1",
            Content   =&gt; \$Content,
        );
  </CodeUpgrade>
  <CodeUpgrade Type="pre" Version="0.0.3">
        my $Content = "test";
        $Self->{MainObject}-&gt;FileWrite(
            Location  =&gt; "' . $TmpDir . '/test2",
            Content   =&gt; \$Content,
        );
  </CodeUpgrade>
  <CodeUpgrade Type="pre" Version="0.0.2">
        my $Content = "test";
        $Self->{MainObject}-&gt;FileWrite(
            Location  =&gt; "' . $TmpDir . '/test3",
            Content   =&gt; \$Content,
        );
  </CodeUpgrade>
  <CodeUpgrade Type="pre" Version="0.0.1">
        my $Content = "test";
        $Self->{MainObject}-&gt;FileWrite(
            Location  =&gt; "' . $TmpDir . '/test3b",
            Content   =&gt; \$Content,
        );
  </CodeUpgrade>
  <CodeUpgrade Type="pre">
        my $Content = "test";
        $Self->{MainObject}-&gt;FileWrite(
            Location  =&gt; "' . $TmpDir . '/test4",
            Content   =&gt; \$Content,
        );
  </CodeUpgrade>
  <Filelist>
    <File Location="Test3" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';

$PackageUpgrade = $Self->{PackageObject}->PackageUpgrade(
    String => $String3b,
);

$Self->True(
    $PackageUpgrade,
    '#5 PackageUpgrade() - ok.',
);

$Self->True(
    !-f $TmpDir . '/test1',
    '#5 PackageUpgrade() - CodeUpgrade with version 0.0.4 (no file).',
);
$Self->True(
    -f $TmpDir . '/test2',
    '#5 PackageUpgrade() - CodeUpgrade with version 0.0.3.',
);
unlink $TmpDir . '/test2';
$Self->True(
    !-f $TmpDir . '/test3',
    '#5 PackageUpgrade() - CodeUpgrade with version 0.0.2 (no file).',
);
$Self->True(
    !-f $TmpDir . '/test3b',
    '#5 PackageUpgrade() - CodeUpgrade with version 0.0.1 (no file).',
);
$Self->True(
    -f $TmpDir . '/test4',
    '#5 PackageUpgrade() - CodeUpgrade without version.',
);
unlink $TmpDir . '/test4';

$PackageUninstall = $Self->{PackageObject}->PackageUninstall(
    String => $String3b,
);
$Self->True(
    $PackageUninstall,
    '#5 PackageUninstall() - 3/3 File already exists in package X.',
);
$PackageUninstall = $Self->{PackageObject}->PackageUninstall(
    String => $String1,
);
$Self->True(
    $PackageUninstall,
    '#5 PackageUninstall() - 3/3 File already exists in package X.',
);

# #6 os check
$String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test2</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <OS>_non_existing_</OS>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
</otrs_package>
';
$PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String,
);

$Self->True(
    !$PackageInstall,
    '#6 PackageInstall()',
);

# #7 fw check
$String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test2</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <Framework>99.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
</otrs_package>
';
$PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String,
);

$Self->True(
    !$PackageInstall,
    '#7 PackageInstall()',
);

# #8 version check
my $VersionCheck = $Self->{PackageObject}->_CheckVersion(
    Version1 => '1.0.1',
    Version2 => '1.0.2',
    Type     => 'Min',
);
$Self->True(
    $VersionCheck,
    '#8 _CheckVersion() - Min',
);
$VersionCheck = $Self->{PackageObject}->_CheckVersion(
    Version1 => '1.0.2',
    Version2 => '1.0.1',
    Type     => 'Min',
);
$Self->True(
    !$VersionCheck,
    '#8 _CheckVersion() - Min',
);
$VersionCheck = $Self->{PackageObject}->_CheckVersion(
    Version1 => '1.0.2',
    Version2 => '1.0.1',
    Type     => 'Max',
);
$Self->True(
    $VersionCheck,
    '#8 _CheckVersion() - Max',
);
$VersionCheck = $Self->{PackageObject}->_CheckVersion(
    Version1 => '1.0.1',
    Version2 => '1.0.2',
    Type     => 'Max',
);
$Self->True(
    !$VersionCheck,
    '#8 _CheckVersion() - Max',
);

# 9 pre tests
$String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test2</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <Framework>2.4.x</Framework>
  <Framework>2.3.x</Framework>
  <Framework>2.2.x</Framework>
  <Framework>2.1.x</Framework>
  <Framework>2.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
  <CodeInstall Type="pre">
   # pre install comment
  </CodeInstall>
  <CodeUninstall Type="pre">
   # pre uninstall comment
  </CodeUninstall>
  <DatabaseInstall Type="pre">
    <TableCreate Name="test_package">
        <Column Name="name_a" Required="true" Type="INTEGER"/>
        <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
        <Column Name="name_c" Required="false" Size="60" Type="VARCHAR"/>
    </TableCreate>
    <Insert Table="test_package">
        <Data Key="name_a">1</Data>
        <Data Key="name_b" Type="Quote">Lalala1</Data>
    </Insert>
  </DatabaseInstall>
  <DatabaseUninstall Type="pre">
    <TableDrop Name="test_package"/>
  </DatabaseUninstall>
</otrs_package>
';
$PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String,
);

$Self->True(
    $PackageInstall,
    '#9 PackageInstall() - pre',
);

$Self->{DBObject}->Prepare(
    SQL => 'SELECT name_b FROM test_package',
);
my $Result;
while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
    $Result = $Row[0];
}

$Self->Is(
    $Result || '',
    'Lalala1',
    '#9 SQL check - pre',
);

$PackageUninstall = $Self->{PackageObject}->PackageUninstall(
    String => $String,
);

$Self->True(
    $PackageUninstall,
    '#9 PackageUninstall() - pre',
);

# 10 post tests
$String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test2</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 110101</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <Framework>2.4.x</Framework>
  <Framework>2.3.x</Framework>
  <Framework>2.2.x</Framework>
  <Framework>2.1.x</Framework>
  <Framework>2.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
  <CodeInstall Type="post">
   # post install comment
  </CodeInstall>
  <CodeUninstall Type="post">
   # post uninstall comment
  </CodeUninstall>
  <DatabaseInstall Type="post">
    <TableCreate Name="test_package">
        <Column Name="name_a" Required="true" Type="INTEGER"/>
        <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
        <Column Name="name_c" Required="false" Size="60" Type="VARCHAR"/>
    </TableCreate>
    <Insert Table="test_package">
        <Data Key="name_a">1</Data>
        <Data Key="name_b" Type="Quote">Lalala1</Data>
    </Insert>
  </DatabaseInstall>
  <DatabaseUninstall Type="post">
    <TableDrop Name="test_package"/>
  </DatabaseUninstall>
</otrs_package>
';
$PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String,
);

$Self->True(
    $PackageInstall,
    '#10 PackageInstall() - post',
);

$Self->{DBObject}->Prepare(
    SQL => 'SELECT name_b FROM test_package',
);
$Result = '';
while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
    $Result = $Row[0];
}

$Self->Is(
    $Result || '',
    'Lalala1',
    '#10 SQL check - post',
);

$PackageUninstall = $Self->{PackageObject}->PackageUninstall(
    String => $String,
);

$Self->True(
    $PackageUninstall,
    '#10 PackageUninstall() - post',
);

# find out if it is an developer installation with files
# from the version control system.
my $DeveloperSystem = 0;
my $Version         = $Self->{ConfigObject}->Get('Version');
if (
    !-e $Self->{ConfigObject}->Get('Home') . '/ARCHIVE'
    && $Version =~ m{CVS}
    )
{
    $DeveloperSystem = 1;
}

# check #11 doesn't work on developer systems because there is no ARCHIVE file!
if ( !$DeveloperSystem ) {

    # 11 check "do not remove framework file if no backup exists"
    my $RemoveFile          = $Self->{ConfigObject}->Get('Home') . '/' . 'bin/CheckDB.pl.save';
    my $RemoveFileFramework = $Self->{ConfigObject}->Get('Home') . '/' . 'bin/CheckDB.pl';
    copy( $RemoveFileFramework, $RemoveFileFramework . '.orig' );
    $String = '<?xml version="1.0" encoding="utf-8" ?>
    <otrs_package version="1.0">
      <Name>TestFrameworkFileCheck</Name>
      <Version>0.0.1</Version>
      <Vendor>OTRS AG</Vendor>
      <URL>http://otrs.org/</URL>
      <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
      <Description Lang="en">A test package.</Description>
      <Description Lang="de">Ein Test Paket.</Description>
      <Framework>2.4.x</Framework>
      <Framework>2.3.x</Framework>
      <Framework>2.2.x</Framework>
      <Framework>2.1.x</Framework>
      <Framework>2.0.x</Framework>
      <BuildDate>2005-11-10 21:17:16</BuildDate>
      <BuildHost>yourhost.example.com</BuildHost>
      <Filelist>
        <File Location="bin/CheckDB.pl" Permission="644" Encode="Base64">aGVsbG8K</File>
      </Filelist>
    </otrs_package>
    ';
    $PackageInstall = $Self->{PackageObject}->PackageInstall(
        String => $String,
    );

    $Self->True(
        $PackageInstall || 0,
        '#11 PackageInstall() - TestFrameworkFileCheck installed',
    );

    # check if save file exists
    $Self->True(
        -e $RemoveFile || 0,
        '#11 PackageInstall() - save file bin/CheckDB.pl.save exists',
    );

    # check if save file exists (should not anymore)
    my $RemoveFileUnlink = unlink $RemoveFile;
    $Self->True(
        $RemoveFileUnlink || 0,
        '#11 PackageInstall() - save file bin/CheckDB.pl.save got removed',
    );

    # check if save file exists (should not anymore)
    $Self->True(
        !-e $RemoveFile,
        '#11 PackageInstall() - save file bin/CheckDB.pl.save does not exists',
    );

    # unistall package
    $PackageUninstall = $Self->{PackageObject}->PackageUninstall(
        String => $String,
    );
    $Self->True(
        $PackageUninstall,
        '#11 PackageUninstall()',
    );

    # check if save file exists (should not)
    $Self->True(
        !-e $RemoveFile,
        '#11 PackageUninstall() - save file bin/CheckDB.pl.save does not exists',
    );

    # check if framework file exists
    $Self->True(
        -e $RemoveFileFramework || 0,
        '#11 PackageUninstall() - save file bin/CheckDB.pl exists',
    );
    move( $RemoveFileFramework . '.orig', $RemoveFileFramework );
}

# check #12 doesn't work on developer systems because there is no ARCHIVE file!
if ( !$DeveloperSystem ) {

    # 12 check "do create .save file on reinstall if it's a framework file"
    my $SaveFile          = $Self->{ConfigObject}->Get('Home') . '/' . 'bin/CheckDB.pl.save';
    my $SaveFileFramework = $Self->{ConfigObject}->Get('Home') . '/' . 'bin/CheckDB.pl';
    copy( $SaveFileFramework, $SaveFileFramework . '.orig' );
    $String = '<?xml version="1.0" encoding="utf-8" ?>
    <otrs_package version="1.0">
      <Name>TestFrameworkFileCheck</Name>
      <Version>0.0.1</Version>
      <Vendor>OTRS AG</Vendor>
      <URL>http://otrs.org/</URL>
      <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
      <Description Lang="en">A test package.</Description>
      <Description Lang="de">Ein Test Paket.</Description>
      <Framework>2.4.x</Framework>
      <Framework>2.3.x</Framework>
      <Framework>2.2.x</Framework>
      <Framework>2.1.x</Framework>
      <Framework>2.0.x</Framework>
      <BuildDate>2005-11-10 21:17:16</BuildDate>
      <BuildHost>yourhost.example.com</BuildHost>
      <Filelist>
        <File Location="bin/CheckDB.pl" Permission="644" Encode="Base64">aGVsbG8K</File>
      </Filelist>
    </otrs_package>
    ';
    $PackageInstall = $Self->{PackageObject}->PackageInstall(
        String => $String,
    );

    $Self->True(
        $PackageInstall || 0,
        '#12 PackageInstall() - TestFrameworkFileCheck installed',
    );

    my $Content = 'Test 12345678';
    my $Write   = $Self->{MainObject}->FileWrite(
        Location   => $SaveFileFramework,
        Content    => \$Content,
        Mode       => 'binmode',
        Permission => '644',
    );
    $Self->True(
        $Write || 0,
        '#12 FileWrite() - bin/CheckDB.pl modified',
    );
    my $ReadOrig = $Self->{MainObject}->FileRead(
        Location => $SaveFileFramework,
        Mode     => 'binmode',
    );

    # check if save file exists (should not anymore)
    my $SaveFileUnlink = unlink $SaveFile;
    $Self->True(
        $SaveFileUnlink || 0,
        '#12 PackageInstall() - save file bin/CheckDB.pl.save got removed',
    );

    # check if save file exists (should not anymore)
    $Self->True(
        !-e $SaveFile,
        '#12 PackageInstall() - save file bin/CheckDB.pl.save does not exists',
    );

    # reinstall
    my $PackageReinstall = $Self->{PackageObject}->PackageReinstall(
        String => $String,
    );
    $Self->True(
        $PackageReinstall || 0,
        '#12 PackageReinstall() - TestFrameworkFileCheck reinstalled',
    );

    # check if save file exists
    $Self->True(
        -e $SaveFile,
        '#12 PackageReinstall() - save file bin/CheckDB.pl.save exists',
    );

    # unistall package
    $PackageUninstall = $Self->{PackageObject}->PackageUninstall(
        String => $String,
    );
    $Self->True(
        $PackageUninstall,
        '#12 PackageUninstall()',
    );

    my $ReadLater = $Self->{MainObject}->FileRead(
        Location => $SaveFileFramework,
        Mode     => 'binmode',
    );

    $Self->True(
        ${$ReadOrig} eq ${$ReadLater},
        '#12 PackageReinstall() - file bin/CheckDB.pl is still the orig',
    );
    move( $SaveFileFramework . '.orig', $SaveFileFramework );
}
1;
