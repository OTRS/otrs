# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;
use Kernel::System::CloudService::Backend::Run;

use vars (qw($Self));

my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
my $OTRSVersion   = $Kernel::OM->Get('Kernel::Config')->Get('Version');

# Leave only major and minor level versions.
$OTRSVersion =~ s{ (\d+ \. \d+) .+ }{$1}msx;

# Add x as patch level version.
$OTRSVersion .= '.x';

my $String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>https://otrs.com/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
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

my $StringSecond = "<?xml version='1.0' encoding='utf-8' ?>
<otrs_package version='1.0'>
  <Name>TestSecond</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>https://otrs.com/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
  <ChangeLog>2005-11-10 New package (some test &lt; &gt; &amp;).</ChangeLog>
  <Description Lang='en'>A test package (some test &lt; &gt; &amp;).\nNew line for testing.</Description>
  <Description Lang='de'>Ein Test Paket (some test &lt; &gt; &amp;).\nNeue Linie zum Testen.</Description>
  <ModuleRequired Version='1.112'>Encode</ModuleRequired>
  <Framework>$OTRSVersion</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location='TestSecond' Permission='644' Encode='Base64'>aGVsbG8K</File>
    <File Location='var/TestSecond' Permission='644' Encode='Base64'>aGVsbG8K</File>
  </Filelist>
</otrs_package>
";

# Override Request() from K::S::CloudService::Backend::Run to always return expected data without any real web call.
#   This should prevent instability in case cloud services are unavailable.
local *Kernel::System::CloudService::Backend::Run::Request = sub {
    my ( $Self, %Param ) = @_;

    return if $Param{RequestData}->{PackageManagement}->[0]->{Operation} ne 'PackageVerify';

    my $Packages = $Param{RequestData}->{PackageManagement}->[0]->{Data}->{Package};

    if ( scalar @{$Packages} == 1 ) {
        if ( $Packages->[0]->{Name} eq 'Test' ) {
            return {
                PackageManagement => [
                    {
                        Success   => '1',
                        Operation => 'PackageVerify',
                        Data      => {
                            Test => 'not_verified',
                        },
                    }
                ],
            };
        }
        elsif ( $Packages->[0]->{Name} eq 'TestSecond' ) {
            return {
                PackageManagement => [
                    {
                        Success   => '1',
                        Operation => 'PackageVerify',
                        Data      => {
                            TestSecond => 'verified',
                        },
                    }
                ],
            };
        }
    }
    else {
        return {
            PackageManagement => [
                {
                    Success   => '1',
                    Operation => 'PackageVerify',
                    Data      => {
                        Test       => 'not_verified',
                        TestSecond => 'not_verified',
                    },
                }
            ],
        };
    }
};

#
# Tests for PackageVerify().
#
my @Tests = (
    {
        Name        => "PackageVerify - Package 'Test'",
        Package     => $String,
        PackageName => 'Test',
        Result      => 'not_verified',
    },
    {
        Name        => "PackageVerify - Package 'TestSecond'",
        Package     => $StringSecond,
        PackageName => 'TestSecond',
        Result      => 'verified',
    },
    {
        Name              => "PackageVerify - Package 'TestSecond'",
        Package           => $StringSecond,
        PackageName       => 'TestSecond',
        ChangeLineEndings => 1,
        Result            => 'verified',
    },
);

for my $Test (@Tests) {

    # Change line endings in the package source, see http://bugs.otrs.org/show_bug.cgi?id=9838 for more information.
    if ( $Test->{ChangeLineEndings} ) {
        $Test->{Package} =~ s{\n}{\r\n}xmsg;
    }

    my $Verification = $PackageObject->PackageVerify(
        Package => $Test->{Package},
        Name    => $Test->{PackageName},
    );
    $Self->Is(
        $Verification,
        $Test->{Result},
        "$Test->{Name} - Result"
    );
}

my @Packages = (
    {
        Name    => 'Test',
        Package => $String,
    },
    {
        Name    => 'TestSecond',
        Package => $StringSecond,
    },
);

# Install packages.
for my $Package (@Packages) {
    my $PackageInstall = $PackageObject->PackageInstall( String => $Package->{Package} );

    $Self->True(
        $PackageInstall,
        "Package '$Package->{Name}' - installed successfully"
    );
}

#
# Test for PackageVerifyAll().
#
my %VerifyAll = $PackageObject->PackageVerifyAll();

for my $PackageName (qw( Test TestSecond )) {
    $Self->Is(
        $VerifyAll{$PackageName},
        'not_verified',
        "PackageVerifyAll - '$PackageName' not verified"
    );
}

# Uninstall packages.
for my $Package (@Packages) {
    my $PackageUninstall = $PackageObject->PackageUninstall( String => $Package->{Package} );

    $Self->True(
        $PackageUninstall,
        "Package '$Package->{Name}' - uninstalled successfully"
    );
}

# Cache cleanup.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

1;
