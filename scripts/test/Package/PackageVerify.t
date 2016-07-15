# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get package object
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

# get OTRS Version
my $OTRSVersion = $Kernel::OM->Get('Kernel::Config')->Get('Version');

# leave only major and minor level versions
$OTRSVersion =~ s{ (\d+ \. \d+) .+ }{$1}msx;

# add x as patch level version
$OTRSVersion .= '.x';

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

my $StringSecond = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>TestSecond</Name>
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
    <File Location="TestSecond" Permission="644" Encode="Base64">aGVsbG8K</File>
    <File Location="var/TestSecond" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';

my %Intervall = (
    1 => 3,
    2 => 15,
    3 => 60,
    4 => 60 * 3,
    5 => 60 * 6,
);

my $Verification;
TRY:
for my $Try ( 1 .. 5 ) {

    $Verification = $PackageObject->PackageVerify(
        Package => $String,
        Name    => 'Test',
    );

    last TRY if $Verification ne 'unknown';

    sleep $Intervall{$Try};
}

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

TRY:
for my $Try ( 1 .. 5 ) {

    $Verification = $PackageObject->PackageVerify(
        Package => $Download,
        Name    => 'Support',
    );

    last TRY if $Verification ne 'unknown';

    sleep $Intervall{$Try};
}

$Self->Is(
    $Verification,
    'verified',
    "PackageVerify() - package 'Support' is verified",
);

# test again with changed line endings, see http://bugs.otrs.org/show_bug.cgi?id=9838
$Download =~ s{\n}{\r\n}xmsg;

TRY:
for my $Try ( 1 .. 5 ) {

    $Verification = $PackageObject->PackageVerify(
        Package => $Download,
        Name    => 'Support',
    );

    last TRY if $Verification ne 'unknown';

    sleep $Intervall{$Try};
}

$Self->Is(
    $Verification,
    'verified',
    "PackageVerify() - package 'Support' with changed line endings is verified",
);

my $PackageInstall = $PackageObject->PackageInstall( String => $String );

$Self->True(
    $PackageInstall,
    'PackageInstall() - Package Test',
);

$PackageInstall = $PackageObject->PackageInstall( String => $StringSecond );

$Self->True(
    $PackageInstall,
    'PackageInstall() - Package TestSecond',
);

TRY:
for my $Try ( 1 .. 5 ) {

    my %VerifyAll = $PackageObject->PackageVerifyAll();

    my $Unknown;
    for my $PackageName (qw( Test TestSecond )) {

        if ( $Try < 5 && $VerifyAll{$PackageName} eq 'unknown' ) {
            $Unknown = 1;
        }
        else {

            $Self->Is(
                $VerifyAll{$PackageName},
                'not_verified',
                "VerifyAll - result for $PackageName",
            );
        }
    }

    last TRY if !$Unknown;

    sleep $Intervall{$Try};
}

my $PackageUninstall = $PackageObject->PackageUninstall( String => $String );

$Self->True(
    $PackageUninstall,
    'PackageUninstall() - Package Test',
);

$PackageUninstall = $PackageObject->PackageUninstall( String => $StringSecond );

$Self->True(
    $PackageUninstall,
    'PackageUninstall() - Package TestSecond',
);

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

1;
