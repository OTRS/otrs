# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Config;

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# Delete sysconfig_modified_version
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_modified_version',
);

# Delete sysconfig_modified
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_modified',
);

# Delete sysconfig_default_version
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_default_version',
);

# Delete sysconfig_default
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_default',
);

# Load setting from sample XML file
my $LoadSuccess = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XML/",
);
$Self->True(
    $LoadSuccess,
    "Load settings from Sample.xml."
);

# Basic tests
my @Tests = (
    {
        Description => 'Test #1',
        Config      => {
        },
        ExpectedResult => {
            'Core' => {
                'Core::CustomerUser' => {},
                'Core::Ticket'       => {},
            },
            'Frontend' => {
                'Frontend::Agent' => {
                    'Frontend::Agent::Dashboard'          => {},
                    'Frontend::Agent::ModuleRegistration' => {},
                    'Frontend::Agent::Ticket'             => {
                        'Frontend::Agent::Ticket::ViewPriority'    => {},
                        'Frontend::Agent::Ticket::ViewResponsible' => {},
                    },
                },
                'Frontend::Agentß∂čćžšđ' => {
                    'Frontend::Agentß∂čćžšđ::ModuleRegistration' => {},
                    }
            },
        },
    },
    {
        Description => 'Test #2',
        Config      => {
            RootNavigation => 'Frontend::Agent',
        },
        ExpectedResult => {
            'Frontend::Agent::Dashboard'          => {},
            'Frontend::Agent::ModuleRegistration' => {},
            'Frontend::Agent::Ticket'             => {
                'Frontend::Agent::Ticket::ViewPriority'    => {},
                'Frontend::Agent::Ticket::ViewResponsible' => {},
            },
        },
    },
    {
        Description => 'Test #3',
        Config      => {
            RootNavigation => 'Frontend::Agentß∂čćžšđ',
        },
        ExpectedResult => {
            'Frontend::Agentß∂čćžšđ::ModuleRegistration' => {},
        },
    },
);

for my $Test (@Tests) {
    my %Result = $SysConfigObject->ConfigurationNavigationTree( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        $Test->{Description} . ': ConfigurationNavigationTree(): Result must match expected one.',
    );
}

my $String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.0">
  <Name>TestPackage1</Name>
  <Version>0.0.1</Version>
  <Vendor>OTRS AG</Vendor>
  <URL>http://otrs.org/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 2, June 1991</License>
  <ChangeLog>2005-11-10 New package (some test &lt; &gt; &amp;).</ChangeLog>
  <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Kernel/Config/Files/XML/TestPackage1.xml" Permission="644" Encode="Base64">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+DQo8b3Ryc19jb25maWcgdmVyc2lvbj0iMi4wIiBpbml0PSJBcHBsaWNhdGlvbiI+DQogICAgPFNldHRpbmcgTmFtZT0iVGVzdFBhY2thZ2UxOjpTZXR0aW5nMSIgUmVxdWlyZWQ9IjAiIFZhbGlkPSIxIj4NCiAgICAgICAgPERlc2NyaXB0aW9uIFRyYW5zbGF0YWJsZT0iMSI+VGVzdCBTZXR0aW5nLjwvRGVzY3JpcHRpb24+DQogICAgICAgIDxOYXZpZ2F0aW9uPkNvcmU6OlRlc3RQYWNrYWdlPC9OYXZpZ2F0aW9uPg0KICAgICAgICA8VmFsdWU+DQogICAgICAgICAgICA8SXRlbSBWYWx1ZVR5cGU9IlN0cmluZyI+PC9JdGVtPg0KICAgICAgICA8L1ZhbHVlPg0KICAgIDwvU2V0dGluZz4NCiAgICA8U2V0dGluZyBOYW1lPSJUZXN0UGFja2FnZTE6OlNldHRpbmcyIiBSZXF1aXJlZD0iMCIgVmFsaWQ9IjEiPg0KICAgICAgICA8RGVzY3JpcHRpb24gVHJhbnNsYXRhYmxlPSIxIj5UZXN0IFNldHRpbmcuPC9EZXNjcmlwdGlvbj4NCiAgICAgICAgPE5hdmlnYXRpb24+Q29yZTo6VGVzdFBhY2thZ2U6Ok90aGVyPC9OYXZpZ2F0aW9uPg0KICAgICAgICA8VmFsdWU+DQogICAgICAgICAgICA8SXRlbSBWYWx1ZVR5cGU9IlN0cmluZyI+PC9JdGVtPg0KICAgICAgICA8L1ZhbHVlPg0KICAgIDwvU2V0dGluZz4NCiAgICA8U2V0dGluZyBOYW1lPSJUZXN0UGFja2FnZTE6OlNldHRpbmczIiBSZXF1aXJlZD0iMSIgVmFsaWQ9IjAiPg0KICAgICAgICA8RGVzY3JpcHRpb24gVHJhbnNsYXRhYmxlPSIxIj5UZXN0IFNldHRpbmcuPC9EZXNjcmlwdGlvbj4NCiAgICAgICAgPE5hdmlnYXRpb24+Q29yZTo6VGVzdFBhY2thZ2U6Ok90aGVyPC9OYXZpZ2F0aW9uPg0KICAgICAgICA8VmFsdWU+DQogICAgICAgICAgICA8SXRlbSBWYWx1ZVR5cGU9IkVudGl0eSIgVmFsdWVFbnRpdHlUeXBlPSJUeXBlIiBUcmFuc2xhdGFibGU9IjEiPlVuY2xhc3NpZmllZDwvSXRlbT4NCiAgICAgICAgPC9WYWx1ZT4NCiAgICA8L1NldHRpbmc+DQo8L290cnNfY29uZmlnPg==</File>
  </Filelist>
</otrs_package>
';

my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

my $PackageName = "TestPackage1";
if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
    my $PackagUninstall = $PackageObject->PackageUninstall( String => $String );

    $Self->True(
        $PackagUninstall,
        "$PackagUninstall() $PackageName",
    );
}

my $PackageInstall = $PackageObject->PackageInstall( String => $String );
$Self->True(
    $PackageInstall,
    "PackageInstall() $PackageName",
);

# tests after Package Installation
@Tests = (
    {
        Description => "Test #P1 - Category $PackageName",
        Config      => {
            Category => $PackageName,
        },
        ExpectedResult => {
            'Core' => {
                'Core::TestPackage' => {
                    'Core::TestPackage::Other' => {},
                },
            },
        },
    },
    {
        Description => 'Test #P2 - IsValid=0',
        Config      => {
            Category => $PackageName,
            IsValid  => 0,
        },
        ExpectedResult => {
            'Core' => {
                'Core::TestPackage' => {
                    'Core::TestPackage::Other' => {},
                },
            },
        },
    },
);

for my $Test (@Tests) {
    my %Result = $SysConfigObject->ConfigurationNavigationTree( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        $Test->{Description} . ': ConfigurationNavigationTree()',
    );
}

if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
    my $PackagUninstall = $PackageObject->PackageUninstall( String => $String );

    $Self->True(
        $PackagUninstall,
        "PackagUninstall() $PackageName",
    );
}

1;
