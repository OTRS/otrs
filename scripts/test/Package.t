# --
# Package.t - Package tests
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Package.t,v 1.1 2005-12-20 22:53:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::Package;

$Self->{PackageObject} = Kernel::System::Package->new(%{$Self});

my $String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>Test</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS GmbH</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <ChangeLog>2005-11-10  New package</ChangeLog>
  <Description Lang="en">A test package.</Description>
  <Description Lang="de">Ein Test Paket.</Description>
  <Framework>2.1.x</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';

my $RepositoryAdd = $Self->{PackageObject}->RepositoryAdd(
    String => $String,
);

$Self->True(
    $RepositoryAdd,
    'RepositoryAdd()',
);

my $PackageGet = $Self->{PackageObject}->RepositoryGet(
    Name => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $String eq $PackageGet,
    'RepositoryGet()',
);

my $PackageRemove = $Self->{PackageObject}->RepositoryRemove(
    Name => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $PackageRemove,
    'RepositoryRemove()',
);

my $PackageInstall = $Self->{PackageObject}->PackageInstall(
    String => $String,
);

$Self->True(
    $PackageInstall,
    'PackageInstall()',
);

my $DeployCheck = $Self->{PackageObject}->DeployCheck(
    Name => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $DeployCheck,
    'DeployCheck()',
);

my %Structur = $Self->{PackageObject}->PackageParse(
    String => $String,
);

my $PackageBuild = $Self->{PackageObject}->PackageBuild(
    %Structur,
);

$Self->True(
    $PackageBuild,
    'PackageBuild()',
);

my $PackageUninstall = $Self->{PackageObject}->PackageUninstall(
    String => $String,
);

$Self->True(
    $PackageUninstall,
    'PackageUninstall()',
);

my $PackageInstall2 = $Self->{PackageObject}->PackageInstall(
    String => $PackageBuild,
);

$Self->True(
    $PackageInstall2,
    'PackageInstall()',
);

my $DeployCheck2 = $Self->{PackageObject}->DeployCheck(
    Name => 'Test',
    Version => '0.0.1',
);

$Self->True(
    $DeployCheck2,
    'DeployCheck()',
);

my $PackageUninstall2 = $Self->{PackageObject}->PackageUninstall(
    String => $PackageBuild,
);

$Self->True(
    $PackageUninstall2,
    'PackageUninstall()',
);


1;
