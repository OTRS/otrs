# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
## nofilter(TidyAll::Plugin::OTRS::Perl::TestSubs)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my $String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>TestPackage1</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>https://otrs.com/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
  <ChangeLog>2005-11-10 New package (some test &lt; &gt; &amp;).</ChangeLog>
  <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Kernel/Config/Files/XML/TestPackage1.xml" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';

my $String2 = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>TestPackage2</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>https://otrs.com/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
  <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Kernel/Config/Files/XML/TestPackage2-1.xml" Permission="644" Encode="Base64">aGVsbG8K</File>
    <File Location="Kernel/Config/Files/XML/TestPackage2-2.xml" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otrs_package>
';

my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

# Cleanup the system.
for my $PackageName (qw(TestPackage1 TestPackage2)) {
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackageRemove = $PackageObject->RepositoryRemove(
            Name    => $PackageName,
            Version => '0.0.1',
        );

        $Self->True(
            $PackageRemove,
            "RepositoryRemove() $PackageName",
        );
    }
}

my @Tests = (
    {
        Name                   => 'Initial',
        ExpectedResultsContain => {
            All => {
                DisplayName => 'All Settings',
                Files       => [],
            },
            OTRS => {
                DisplayName => 'OTRS',
                Files       => [
                    'Calendar.xml', 'CloudServices.xml', 'Daemon.xml', 'Framework.xml', 'GenericInterface.xml',
                    'ProcessManagement.xml', 'Ticket.xml'
                ],
            },
        },
        ExpectedResultsNotContain => [ 'TestPackage1', 'TestPackage2' ],
    },
    {
        Name          => 'TestPackage1 Installed',
        RepositoryAdd => {
            PackageName => 'TestPackage1',
            String      => $String,
        },
        ExpectedResultsContain => {
            All => {
                DisplayName => 'All Settings',
                Files       => [],
            },
            OTRS => {
                DisplayName => 'OTRS',
                Files       => [
                    'Calendar.xml', 'CloudServices.xml', 'Daemon.xml', 'Framework.xml', 'GenericInterface.xml',
                    'ProcessManagement.xml', 'Ticket.xml'
                ],
            },
            TestPackage1 => {
                DisplayName => 'TestPackage1',
                Files       => ['TestPackage1.xml'],
            },
        },
        ExpectedResultsNotContain => ['TestPackage2'],
    },
    {
        Name          => 'TestPackage1 and TestPackage2 Installed',
        RepositoryAdd => {
            PackageName => 'TestPackage2',
            String      => $String2,
        },
        ExpectedResultsContain => {
            All => {
                DisplayName => 'All Settings',
                Files       => [],
            },
            OTRS => {
                DisplayName => 'OTRS',
                Files       => [
                    'Calendar.xml', 'CloudServices.xml', 'Daemon.xml', 'Framework.xml', 'GenericInterface.xml',
                    'ProcessManagement.xml', 'Ticket.xml'
                ],
            },
            TestPackage1 => {
                DisplayName => 'TestPackage1',
                Files       => ['TestPackage1.xml'],
            },
            TestPackage2 => {
                DisplayName => 'TestPackage2',
                Files       => [ 'TestPackage2-1.xml', 'TestPackage2-2.xml' ],
            },
        },
    },
);

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

for my $Test (@Tests) {

    # cleanup cache
    $CacheObject->Delete(
        Type => 'SysConfig',
        Key  => 'ConfigurationCategoriesGet',
    );

    if ( $Test->{RepositoryAdd} ) {
        my $RepositoryAdd = $PackageObject->RepositoryAdd( String => $Test->{RepositoryAdd}->{String} );
        $Self->True(
            $RepositoryAdd,
            "RepositoryAdd() $Test->{RepositoryAdd}->{PackageName}",
        );

    }

    my %Result = $SysConfigObject->ConfigurationCategoriesGet();

    for my $Category ( @{ $Test->{ExpectedResultsNotContain} } ) {
        $Self->Is(
            $Result{$Category},
            undef,
            "$Test->{Name} ConfigurationCategoriesGet() - should not contain $Category",
        );
    }

    for my $Category ( sort keys %{ $Test->{ExpectedResultsContain} } ) {
        $Self->IsDeeply(
            $Result{$Category},
            $Test->{ExpectedResultsContain}->{$Category},
            "$Test->{Name} ConfigurationCategoriesGet() - $Category",
        );
    }
}

# Cleanup the system.
for my $PackageName (qw(TestPackage1 TestPackage2)) {
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackageRemove = $PackageObject->RepositoryRemove(
            Name    => $PackageName,
            Version => '0.0.1',
        );

        $Self->True(
            $PackageRemove,
            "RepositoryRemove() $PackageName",
        );
    }
}

1;
