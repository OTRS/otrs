# --
# Package.t - Package tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::Package;
use File::Copy;
use Kernel::System::Cache;

# create local objects
my $PackageObject = Kernel::System::Package->new( %{$Self} );
my $CacheObject   = Kernel::System::Cache->new( %{$Self} );

my $Home = $Self->{ConfigObject}->Get('Home');

my $CachePopulate = sub {
    my $CacheSet = $CacheObject->Set(
        Type  => 'TicketTest',
        Key   => 'Package',
        Value => 'PackageValue',
        TTL   => 24 * 60 * 60,
    );
    $Self->True(
        $CacheSet,
        "CacheSet successful",
    );
    my $CacheValue = $CacheObject->Get(
        Type => 'TicketTest',
        Key  => 'Package',
    );
    $Self->Is(
        $CacheValue,
        'PackageValue',
        "CacheSet value",
    );
};

my $CacheClearedCheck = sub {
    my $CacheValue = $CacheObject->Get(
        Type => 'TicketTest',
        Key  => 'Package',
    );
    $Self->Is(
        scalar $CacheValue,
        scalar undef,
        "CacheGet value was cleared",
    );
};

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
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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

my $Verification = $PackageObject->PackageVerify(
    Package => $String,
    Name    => 'Test',
);

$Self->Is(
    $Verification,
    'not_verified',
    "PackageVerify() - package 'Test' is NOT verified",
);

my $Download = $PackageObject->PackageOnlineGet(
    Source => 'http://ftp.otrs.org/pub/otrs/packages',
    File   => 'Support-1.4.4.opm',
);

$Self->True(
    $Download,
    "PackageOnlineGet - get Support package from ftp.otrs.org",
);

$Verification = $PackageObject->PackageVerify(
    Package => $Download,
    Name    => 'Support',
);

$Self->Is(
    $Verification,
    'verified',
    "PackageVerify() - package 'Support' is verified",
);

# check if the package is already installed - check by name
my $PackageIsInstalledByName = $PackageObject->PackageIsInstalled( Name => 'Test' );
$Self->True(
    !$PackageIsInstalledByName,
    '#1 PackageIsInstalled() - check if the package is already installed - check by name',
);

# check if the package is already installed - check by xml string
my $PackageIsInstalledByString = $PackageObject->PackageIsInstalled( String => $String );
$Self->True(
    !$PackageIsInstalledByString,
    '#1 PackageIsInstalled() - check if the package is already installed - check by string',
);

my $RepositoryAdd = $PackageObject->RepositoryAdd( String => $String );

$Self->True(
    $RepositoryAdd,
    '#1 RepositoryAdd()',
);

my $PackageGet = $PackageObject->RepositoryGet(
    Name    => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $String eq $PackageGet,
    '#1 RepositoryGet()',
);

my $PackageRemove = $PackageObject->RepositoryRemove(
    Name    => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $PackageRemove,
    '#1 RepositoryRemove()',
);

$CachePopulate->();

my $PackageInstall = $PackageObject->PackageInstall( String => $String );

$Self->True(
    $PackageInstall,
    '#1 PackageInstall()',
);

$CacheClearedCheck->();

# check if the package is already installed - check by name
$PackageIsInstalledByName = $PackageObject->PackageIsInstalled( Name => 'Test' );
$Self->True(
    $PackageIsInstalledByName,
    '#1 PackageIsInstalled() - check if the package is already installed - check by name',
);

# check if the package is already installed - check by xml string
$PackageIsInstalledByString = $PackageObject->PackageIsInstalled( String => $String );
$Self->True(
    $PackageIsInstalledByString,
    '#1 PackageIsInstalled() - check if the package is already installed - check by string',
);

my $DeployCheck = $PackageObject->DeployCheck(
    Name    => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $DeployCheck,
    '#1 DeployCheck()',
);

# write to var/test
my $Write   = $Self->{MainObject}->FileWrite(
    Location   => $Home . '/var/Test',
    Content    => \'aaaa',
    Mode       => 'binmode',
    Permission => '644',
);

$Self->True(
    $Write,
    '#1 FileWrite()',
);

$DeployCheck = $PackageObject->DeployCheck(
    Name    => 'Test',
    Version => '0.0.1',
);

$Self->False(
    $DeployCheck,
    '#1 DeployCheck after FileWrite()',
);

$Self->True(
    $PackageObject->PackageReinstall( String => $String ),
    '#1 Reinstall after FileWrite',
);

$DeployCheck = $PackageObject->DeployCheck(
    Name    => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $DeployCheck,
    '#1 DeployCheck after Reinstall()',
);

my %Structure = $PackageObject->PackageParse( String => $String );

my $PackageBuild = $PackageObject->PackageBuild(%Structure);

$Self->True(
    $PackageBuild,
    '#1 PackageBuild()',
);

my $PackageUninstall = $PackageObject->PackageUninstall( String => $String );

$Self->True(
    $PackageUninstall,
    '#1 PackageUninstall()',
);

$CachePopulate->();

my $PackageInstall2 = $PackageObject->PackageInstall( String => $PackageBuild );

$Self->True(
    $PackageInstall2,
    '#1 PackageInstall() - 2',
);

$CacheClearedCheck->();

my $DeployCheck2 = $PackageObject->DeployCheck(
    Name    => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $DeployCheck2,
    '#1 DeployCheck() - 2',
);

# reinstall test
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
  <Framework>99.0.x</Framework>
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

# reinstall
my $PackageReinstall = $PackageObject->PackageReinstall( String => $String );
$Self->False(
    $PackageReinstall,
    '#1 PackageReinstall() - TestFrameworkCheck reinstalled',
);

$CachePopulate->();

my $PackageUninstall2 = $PackageObject->PackageUninstall( String => $PackageBuild );

$Self->True(
    $PackageUninstall2,
    '#1 PackageUninstall() - 2',
);

$CacheClearedCheck->();

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
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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
$PackageInstall = $PackageObject->PackageInstall( String => $String );

$Self->True(
    !$PackageInstall || 0,
    '#2 PackageInstall() - PackageRequired not installed',
);

$String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>TestOSDetection1</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <OS>NonExistingOS</OS>
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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
$PackageInstall = $PackageObject->PackageInstall( String => $String );

$Self->True(
    !$PackageInstall || 0,
    'PackageInstall() - OSCheck not installed',
);

$String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>TestOSDetection2</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <OS>darwin</OS>
  <OS>linux</OS>
  <OS>freebsd</OS>
  <OS>MSWin32</OS>
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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
$PackageInstall = $PackageObject->PackageInstall( String => $String );

$Self->True(
    $PackageInstall,
    'PackageInstall() - OSCheck installed',
);

$PackageUninstall = $PackageObject->PackageUninstall( String => $String );

$Self->True(
    $PackageUninstall,
    'PackageUninstall() - OSCheck uninstalled',
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
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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
$PackageInstall = $PackageObject->PackageInstall( String => $String );

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
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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
$PackageInstall = $PackageObject->PackageInstall( String => $String );

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
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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
$PackageInstall = $PackageObject->PackageInstall( String => $String1 );
$Self->True(
    $PackageInstall,
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
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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
$PackageInstall = $PackageObject->PackageInstall( String => $String2 );

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
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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
$PackageInstall = $PackageObject->PackageInstall( String => $String3 );
my $String3a = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test3</Name>
  <Version>0.0.3</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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

my $PackageUpgrade = $PackageObject->PackageUpgrade( String => $String3a );

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
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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

$CachePopulate->();

$PackageUpgrade = $PackageObject->PackageUpgrade( String => $String3b );

$Self->True(
    $PackageUpgrade,
    '#5 PackageUpgrade() - ok.',
);

$CacheClearedCheck->();

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

$PackageUninstall = $PackageObject->PackageUninstall( String => $String3b );
$Self->True(
    $PackageUninstall,
    '#5 PackageUninstall() - 3/3 File already exists in package X.',
);
$PackageUninstall = $PackageObject->PackageUninstall(
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
$PackageInstall = $PackageObject->PackageInstall( String => $String );

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
$PackageInstall = $PackageObject->PackageInstall( String => $String );

$Self->True(
    !$PackageInstall,
    '#7 PackageInstall()',
);

# #8 version check
my @Tests = (

    # test invalid type
    {
        VersionNew       => '1.0.1',
        VersionInstalled => '1.0.2',
        Type             => 'Something',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.2',
        VersionInstalled => '1.0.1',
        Type             => 'Something',
        ExternalPackage  => 0,
        Result           => 0,
    },

    # minimum tests
    {
        VersionNew       => '1.0.1',
        VersionInstalled => '1.0.2',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.2',
        VersionInstalled => '1.0.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.2',
        VersionInstalled => '1.0',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.1',
        VersionInstalled => '1.5.2.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.9.1',
        VersionInstalled => '1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.3.5',
        VersionInstalled => '1.3.4',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.3.99',
        VersionInstalled => '1.3.0',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '100.100.100',
        VersionInstalled => '99.100.100',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '999.1000.1000',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '1000.999.1000',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '1000.1000.999',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '9999.9999.9999.9999',
        VersionInstalled => '9999.9999.9999.9998',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.1.2',
        VersionInstalled => '1.0.1.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.1.2',
        VersionInstalled => '1.0.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.1.999',
        VersionInstalled => '1.0.1.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.0.999',
        VersionInstalled => '1.0.0.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.1.5',
        VersionInstalled => '1.1.4.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },

    # maximum tests
    {
        VersionNew       => '1.0.1',
        VersionInstalled => '1.0.2',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.2',
        VersionInstalled => '1.0.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0',
        VersionInstalled => '1.0.2',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.1',
        VersionInstalled => '1.5.2.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.9.1',
        VersionInstalled => '1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.3.5',
        VersionInstalled => '1.3.4',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.3.99',
        VersionInstalled => '1.3.0',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '100.100.100',
        VersionInstalled => '99.100.100',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '999.1000.1000',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '1000.999.1000',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '1000.1000.999',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '9999.9999.9999.9999',
        VersionInstalled => '9999.9999.9999.9998',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.1.2',
        VersionInstalled => '1.0.1.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.1.2',
        VersionInstalled => '1.0.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.1.999',
        VersionInstalled => '1.0.1.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.0.999',
        VersionInstalled => '1.0.0.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.1.5',
        VersionInstalled => '1.1.4.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
);

for my $Test (@Tests) {

    my $VersionCheck = $PackageObject->_CheckVersion(
        VersionNew       => $Test->{VersionNew},
        VersionInstalled => $Test->{VersionInstalled},
        Type             => $Test->{Type},
    );

    my $Name = "#8 _CheckVersion() - $Test->{Type} ($Test->{VersionNew}:$Test->{VersionInstalled})";

    if ( $Test->{Result} ) {
        $Self->True(
            $VersionCheck,
            $Name,
        );
    }
    else {
        $Self->True(
            !$VersionCheck,
            $Name,
        );
    }
}

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
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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
$PackageInstall = $PackageObject->PackageInstall( String => $String );

$Self->True(
    $PackageInstall,
    '#9 PackageInstall() - pre',
);

$Self->{DBObject}->Prepare( SQL => 'SELECT name_b FROM test_package' );
my $Result;
while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
    $Result = $Row[0];
}

$Self->Is(
    $Result || '',
    'Lalala1',
    '#9 SQL check - pre',
);

$PackageUninstall = $PackageObject->PackageUninstall( String => $String );

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
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <Framework>2.5.x</Framework>
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
$PackageInstall = $PackageObject->PackageInstall( String => $String );

$Self->True(
    $PackageInstall,
    '#10 PackageInstall() - post',
);

$Self->{DBObject}->Prepare( SQL => 'SELECT name_b FROM test_package' );
$Result = '';
while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
    $Result = $Row[0];
}

$Self->Is(
    $Result || '',
    'Lalala1',
    '#10 SQL check - post',
);

$PackageUninstall = $PackageObject->PackageUninstall( String => $String );

$Self->True(
    $PackageUninstall,
    '#10 PackageUninstall() - post',
);

# _FileInstall checks with not allowed files
my $FilesNotAllowed = [
    'Kernel/Config.pm',
    'Kernel/Config/Files/ZZZAuto.pm',
    'Kernel/Config/Files/ZZZAAuto.pm',
    'Kernel/Config/Files/ZZZProcessManagement.pm',
    'var/tmp/Cache/Tmp.cache',
    'var/log/some_log',
    '../../etc/passwd',
    '/etc/shadow',
];
my $FileNotAllowedString = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>
<otrs_package version=\"1.0\">
  <Name>FilesNotAllowed</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <Description Lang=\"en\">A test package.</Description>
  <Description Lang=\"de\">Ein Test Paket.</Description>
  <Framework>3.3.x</Framework>
  <Framework>3.2.x</Framework>
  <Framework>3.1.x</Framework>
  <Framework>3.0.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>\n";
for my $FileNotAllowed ( @{$FilesNotAllowed} ) {
    $FileNotAllowedString .=
        "    <File Location=\"$FileNotAllowed\" Permission=\"644\" Encode=\"Base64\">aGVsbG8K</File>\n";
}
$FileNotAllowedString .= "  </Filelist>
</otrs_package>\n";

$PackageInstall = $PackageObject->PackageInstall( String => $FileNotAllowedString );

$Self->True(
    $PackageInstall,
    "#11 PackageInstall() - File not allowed",
);

# check content of not allowed files for match against files from package
for my $FileNotAllowed ( @{$FilesNotAllowed} ) {
    my $Readfile = $Self->{MainObject}->FileRead(
        Location => $Home . '/' . $FileNotAllowed,
        Mode     => 'binmode',
    );

    my $Content;
    if ( ref $Readfile eq 'SCALAR' ) {
        $Content = ${$Readfile} || '';
    }
    else {
        $Content = '';
    }

    $Self->False(
        $Content eq 'hello',
        '#11 - check on filesystem - $FileNotAllowed',
    );
}

# uninstall package
$PackageUninstall = $PackageObject->PackageUninstall( String => $FileNotAllowedString );
$Self->True(
    $PackageUninstall,
    '#11 PackageUninstall()',
);

# find out if it is an developer installation with files
# from the version control system.
my $DeveloperSystem = 0;
my $Version         = $Self->{ConfigObject}->Get('Version');
if (
    !-e $Home . '/ARCHIVE'
    && $Version =~ m{git}
    )
{
    $DeveloperSystem = 1;
}

# check #12 doesn't work on developer systems because there is no ARCHIVE file!
if ( !$DeveloperSystem ) {

    # 12 check "do not remove framework file if no backup exists"
    my $RemoveFile          = $Home . '/' . 'bin/otrs.CheckDB.pl.save';
    my $RemoveFileFramework = $Home . '/' . 'bin/otrs.CheckDB.pl';
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
      <Framework>3.3.x</Framework>
      <Framework>3.2.x</Framework>
      <Framework>3.1.x</Framework>
      <Framework>3.0.x</Framework>
      <Framework>2.5.x</Framework>
      <Framework>2.4.x</Framework>
      <Framework>2.3.x</Framework>
      <Framework>2.2.x</Framework>
      <Framework>2.1.x</Framework>
      <Framework>2.0.x</Framework>
      <BuildDate>2005-11-10 21:17:16</BuildDate>
      <BuildHost>yourhost.example.com</BuildHost>
      <Filelist>
        <File Location="bin/otrs.CheckDB.pl" Permission="644" Encode="Base64">aGVsbG8K</File>
      </Filelist>
    </otrs_package>
    ';
    $PackageInstall = $PackageObject->PackageInstall( String => $String );

    $Self->True(
        $PackageInstall,
        '#12 PackageInstall() - TestFrameworkFileCheck installed',
    );

    # check if save file exists
    $Self->True(
        -e $RemoveFile,
        '#12 PackageInstall() - save file bin/otrs.CheckDB.pl.save exists',
    );

    # check if save file exists (should not anymore)
    my $RemoveFileUnlink = unlink $RemoveFile;
    $Self->True(
        $RemoveFileUnlink,
        '#12 PackageInstall() - save file bin/otrs.CheckDB.pl.save got removed',
    );

    # check if save file exists (should not anymore)
    $Self->True(
        !-e $RemoveFile,
        '#12 PackageInstall() - save file bin/otrs.CheckDB.pl.save does not exists',
    );

    # uninstall package
    $PackageUninstall = $PackageObject->PackageUninstall( String => $String );
    $Self->True(
        $PackageUninstall,
        '#12 PackageUninstall()',
    );

    # check if save file exists (should not)
    $Self->True(
        !-e $RemoveFile,
        '#12 PackageUninstall() - save file bin/otrs.CheckDB.pl.save does not exists',
    );

    # check if framework file exists
    $Self->True(
        -e $RemoveFileFramework,
        '#12 PackageUninstall() - save file bin/otrs.CheckDB.pl exists',
    );
    move(
        $RemoveFileFramework . '.orig',
        $RemoveFileFramework
    );
}

# check #13 doesn't work on developer systems because there is no ARCHIVE file!
if ( !$DeveloperSystem ) {

    # 13 check "do create .save file on reinstall if it's a framework file"
    my $SaveFile          = $Home . '/' . 'bin/otrs.CheckDB.pl.save';
    my $SaveFileFramework = $Home . '/' . 'bin/otrs.CheckDB.pl';
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
      <Framework>3.3.x</Framework>
      <Framework>3.2.x</Framework>
      <Framework>3.1.x</Framework>
      <Framework>3.0.x</Framework>
      <Framework>2.5.x</Framework>
      <Framework>2.4.x</Framework>
      <Framework>2.3.x</Framework>
      <Framework>2.2.x</Framework>
      <Framework>2.1.x</Framework>
      <Framework>2.0.x</Framework>
      <BuildDate>2005-11-10 21:17:16</BuildDate>
      <BuildHost>yourhost.example.com</BuildHost>
      <Filelist>
        <File Location="bin/otrs.CheckDB.pl" Permission="644" Encode="Base64">aGVsbG8K</File>
      </Filelist>
    </otrs_package>
    ';
    $PackageInstall = $PackageObject->PackageInstall( String => $String );

    $Self->True(
        $PackageInstall,
        '#13 PackageInstall() - TestFrameworkFileCheck installed',
    );

    # reinstall checks
    my $Content = 'Test 12345678';
    my $Write   = $Self->{MainObject}->FileWrite(
        Location   => $SaveFileFramework,
        Content    => \$Content,
        Mode       => 'binmode',
        Permission => '644',
    );
    $Self->True(
        $Write,
        '#13 FileWrite() - bin/otrs.CheckDB.pl modified',
    );
    my $ReadOrig = $Self->{MainObject}->FileRead(
        Location => $SaveFileFramework,
        Mode     => 'binmode',
    );
    if ( !$ReadOrig || ref $ReadOrig ne 'SCALAR' ) {
        my $Dummy = 'ReadOrig';
        $ReadOrig = \$Dummy;
    }

    # check if save file exists (should not anymore)
    my $SaveFileUnlink = unlink $SaveFile;
    $Self->True(
        $SaveFileUnlink,
        '#13 PackageInstall() - save file bin/otrs.CheckDB.pl.save got removed',
    );

    # check if save file exists (should not anymore)
    $Self->True(
        !-e $SaveFile,
        '#13 PackageInstall() - save file bin/otrs.CheckDB.pl.save does not exists',
    );

    # reinstall
    $CachePopulate->();

    my $PackageReinstall = $PackageObject->PackageReinstall( String => $String );
    $Self->True(
        $PackageReinstall,
        '#13 PackageReinstall() - TestFrameworkFileCheck reinstalled',
    );

    $CacheClearedCheck->();

    # check if save file exists
    $Self->True(
        -e $SaveFile,
        '#13 PackageReinstall() - save file bin/otrs.CheckDB.pl.save exists',
    );

    # uninstall package
    $PackageUninstall = $PackageObject->PackageUninstall( String => $String );
    $Self->True(
        $PackageUninstall,
        '#13 PackageUninstall()',
    );

    my $ReadLater = $Self->{MainObject}->FileRead(
        Location => $SaveFileFramework,
        Mode     => 'binmode',
    );
    if ( !$ReadLater || ref $ReadLater ne 'SCALAR' ) {
        my $Dummy = 'ReadLater';
        $ReadLater = \$Dummy;
    }

    $Self->True(
        ${$ReadOrig} eq ${$ReadLater},
        '#13 PackageReinstall() - file bin/otrs.CheckDB.pl is still the orig',
    );
    move(
        $SaveFileFramework . '.orig',
        $SaveFileFramework
    );

    # return the correct permissions to otrs.CheckDB.pl
    chmod 0755, $Home . '/' . 'bin/otrs.CheckDB.pl';

    # tests for  PackageUnintallMerged
    # install package normally
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
      <Framework>3.3.x</Framework>
      <Framework>3.2.x</Framework>
      <Framework>3.1.x</Framework>
      <Framework>3.0.x</Framework>
      <Framework>2.5.x</Framework>
      <Framework>2.4.x</Framework>
      <Framework>2.3.x</Framework>
      <Framework>2.2.x</Framework>
      <Framework>2.1.x</Framework>
      <Framework>2.0.x</Framework>
      <BuildDate>2005-11-10 21:17:16</BuildDate>
      <BuildHost>yourhost.example.com</BuildHost>
      <Filelist>
        <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
        <File Location="var/Test" Permission="644" Encode="Base64">aGVsbG8K</File>
      </Filelist>
    </otrs_package>
    ';
    $PackageInstall = $PackageObject->PackageInstall( String => $String );

    # check that the package is installed and files exists
    $Self->True(
        $PackageInstall,
        '#14 TestPackageUninstallMerged PackageInstall() - package installed with true',
    );
    for my $File (qw( Test var/Test )) {
        my $RealFile = $Home . '/' . $File;
        $RealFile =~ s/\/\//\//g;
        $Self->True(
             -e  $RealFile,
            "#14 TestPackageUninstallMerged FileExists - $RealFile with true",
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
      <Framework>3.3.x</Framework>
      <Framework>3.2.x</Framework>
      <Framework>3.1.x</Framework>
      <Framework>3.0.x</Framework>
      <Framework>2.5.x</Framework>
      <Framework>2.4.x</Framework>
      <Framework>2.3.x</Framework>
      <Framework>2.2.x</Framework>
      <Framework>2.1.x</Framework>
      <Framework>2.0.x</Framework>
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

    # now create an .save file for the framework file, content doesn't matter as it will be deleted
    $Write  = $Self->{MainObject}->FileWrite(
        Location   => $Home . '/bin/otrs.CheckDB.pl.save',
        Content    => \$Content,
        Mode       => 'binmode',
        Permission => '644',
    );
    $Self->True(
        $Write,
        '#14 TestPackageUninstallMerged FileWrite() - bin/otrs.CheckDB.pl.save',
    );

    # create PackageObject again to make sure cache is cleared
    my $PackageObject = Kernel::System::Package->new( %{$Self} );

    # run PackageUninstallMerged()
    my $PackageUninstallMerged = $PackageObject->_PackageUninstallMerged( Name => $PackageName );

    # check that the original files from the package does not exists anymore
    # this files are supose to be old files that are not required any more by the merged package
    for my $File (qw( Test var/Test bin/otrs.CheckDB.pl.save )) {
        my $RealFile = $Home . '/' . $File;
        $RealFile =~ s/\/\//\//g;
        $Self->False(
            -e $RealFile,
            "#14 TestPackageUninstallMerged FileExists - $RealFile with false",
        );
    }

    # check that the framework file still exists
    for my $File (qw( bin/otrs.CheckDB.pl )) {
        my $RealFile = $Home . '/' . $File;
        $RealFile =~ s/\/\//\//g;
        $Self->True(
            -e $RealFile,
            "#14 TestPackageUninstallMerged FileExists - $RealFile with true",
        );
    }

    # check that the package is uninstalled
    my $PackageInstalled = $PackageObject->PackageIsInstalled(
        Name   => $PackageName,
    );
    $Self->False(
        $PackageInstalled,
        '#14 TestPackageUninstallMerged PackageIsInstalled() - with flase',
    );
}

1;
