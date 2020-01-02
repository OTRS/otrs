# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');

# Create a code scope to be able to redefine a function safely
{
    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::SysConfig', 'Kernel::System::SysConfig::DB' ],
    );

    # Redefine ConfigurationCategoriesGet to be able to use fake category Sample, with this we don't
    #   need to delete the tables and we can use this category for the tests. this needs to be
    #   redefine only locally otherwise the rest of the test will be affected.
    local *Kernel::System::SysConfig::ConfigurationCategoriesGet = sub {
        return (
            All => {
                DisplayName => 'All Settings',
                Files       => [],
            },
            OTRS => {
                DisplayName => 'OTRS',
                Files       => [
                    'Calendar.xml', 'CloudServices.xml', 'Daemon.xml', 'Framework.xml',
                    'GenericInterface.xml', 'ProcessManagement.xml', 'Ticket.xml',
                ],
            },
            Sample => {
                DisplayName => 'Sample',
                Files       => ['Sample.xml'],
            },
        );
    };

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

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
                Category => 'Sample',
            },
            ExpectedResult => {
                'Core' => {
                    'Count'    => 0,
                    'Subitems' => {
                        'Core::CustomerUser' => {
                            'Subitems' => {},
                            'Count'    => 4,
                        },
                        'Core::Ticket' => {
                            'Subitems' => {},
                            'Count'    => 3,
                        },
                    },
                },
                'Frontend' => {
                    'Count'    => 0,
                    'Subitems' => {
                        'Frontend::Agent' => {
                            'Count'    => 0,
                            'Subitems' => {
                                'Frontend::Agent::Dashboard' => {
                                    'Subitems' => {},
                                    'Count'    => 1,
                                },
                                'Frontend::Agent::ModuleRegistration' => {
                                    'Subitems' => {},
                                    'Count'    => 2,
                                },
                                'Frontend::Agent::Ticket' => {
                                    'Count'    => 0,
                                    'Subitems' => {
                                        'Frontend::Agent::Ticket::ViewPriority' => {
                                            'Subitems' => {},
                                            'Count'    => 3,
                                        },
                                        'Frontend::Agent::Ticket::ViewResponsible' => {
                                            'Subitems' => {},
                                            'Count'    => 1,
                                        },
                                    },
                                },
                            },
                        },
                        'Frontend::Agentß∂čćžšđ' => {
                            'Count'    => 0,
                            'Subitems' => {
                                'Frontend::Agentß∂čćžšđ::ModuleRegistration' => {
                                    'Subitems' => {},
                                    'Count'    => 1,
                                },
                            },
                        },
                    },
                },
            },
        },
        {
            Description => 'Test #2',
            Config      => {
                Category       => 'Sample',
                RootNavigation => 'Frontend::Agent',
            },
            ExpectedResult => {
                'Frontend::Agent::Dashboard' => {
                    'Subitems' => {},
                    'Count'    => 1,
                },
                'Frontend::Agent::ModuleRegistration' => {
                    'Subitems' => {},
                    'Count'    => 2,
                },
                'Frontend::Agent::Ticket' => {
                    'Count'    => 0,
                    'Subitems' => {
                        'Frontend::Agent::Ticket::ViewPriority' => {
                            'Subitems' => {},
                            'Count'    => 3,
                        },
                        'Frontend::Agent::Ticket::ViewResponsible' => {
                            'Subitems' => {},
                            'Count'    => 1,
                        },
                    },
                },
            },
        },
        {
            Description => 'Test #3',
            Config      => {
                Category       => 'Sample',
                RootNavigation => 'Frontend::Agentß∂čćžšđ',
            },
            ExpectedResult => {
                'Frontend::Agentß∂čćžšđ::ModuleRegistration' => {
                    'Subitems' => {},
                    'Count'    => 1,
                },
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
}

# Outside of the code scope be sure to discard affected objects, so they can load again normally
$Kernel::OM->ObjectsDiscard(
    Objects => [ 'Kernel::System::SysConfig', 'Kernel::System::SysConfig::DB' ],
);

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

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
my @Tests = (
    {
        Description => "Test #P1 - Category $PackageName",
        Config      => {
            Category => $PackageName,
        },
        ExpectedResult => {
            'Core' => {
                'Count'    => 0,
                'Subitems' => {
                    'Core::TestPackage' => {
                        'Count'    => 1,
                        'Subitems' => {
                            'Core::TestPackage::Other' => {
                                'Subitems' => {},
                                'Count'    => 2,
                            },
                        },
                    },
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
                'Count'    => 0,
                'Subitems' => {
                    'Core::TestPackage' => {
                        'Count'    => 0,
                        'Subitems' => {
                            'Core::TestPackage::Other' => {
                                'Subitems' => {},
                                'Count'    => 1,
                            },
                        },
                    },
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
