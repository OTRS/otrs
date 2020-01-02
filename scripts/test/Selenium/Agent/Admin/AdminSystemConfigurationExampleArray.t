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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

my @Tests = (
    {
        Name     => 'ExampleArrayFrontendNavigation',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(2) input',
            },
            {
                JqueryClick =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(2) .Hash .HashItem:nth-of-type(4) .AddArrayItem',
            },
            {
                Select =>
                    'input#ExampleArrayFrontendNavigationExampleArrayFrontendNavigation_Array2_Hash\\#\\#\\#Group_Array0',
            },
            {
                Write => 'admin',
            },
            {
                JqueryClick => '.Update',
            },
            {
                # Wait for validation error (Description).
                Select => 'input.Error#ExampleArrayFrontendNavigation_Array2_Hash\\#\\#\\#Description',
            },
            {
                Write => 'Description',
            },
            {
                JqueryClick => '.Update',
            },
            {
                # Wait for validation error (Link).
                Select => 'input.Error#ExampleArrayFrontendNavigation_Array2_Hash\\#\\#\\#Link',
            },
            {
                Write => 'Action=AgentTest;Subaction=Test',
            },
            {
                JqueryClick => '.Update',
            },
            {
                # Wait for validation error (Name).
                Select => 'input.Error#ExampleArrayFrontendNavigation_Array2_Hash\\#\\#\\#Name',
            },
            {
                Write => 'Navigation name',
            },
            {
                JqueryClick => '.Update',
            },
            {
                # Wait for validation error (NavBar).
                Select => 'input.Error#ExampleArrayFrontendNavigation_Array2_Hash\\#\\#\\#NavBar',
            },
            {
                Write => 'Customers',
            },
            {
                # Remove first item (see https://bugs.otrs.org/show_bug.cgi?id=14137).
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(1) > .RemoveButton',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            {
                'AccessKey'   => '',
                'Block'       => '',
                'Description' => 'Description',
                'Group'       => [
                    'admin'
                ],
                "GroupRo"    => [],
                'Link'       => 'Action=AgentTest;Subaction=Test',
                'LinkOption' => '',
                'Name'       => 'Navigation name',
                'NavBar'     => 'Customers',
                'Prio'       => '',
                'Type'       => '',
            },
        ],
    },
    {
        Name     => 'ExampleArray',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },

            # check if remove buttons are hidden
            {
                ElementMissing => '.RemoveButton:visible',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                ElementValue => 'Default value',
            },
            {
                Clear => 1,
            },
            {
                Write => 'New item',
            },
            {
                JqueryClick => '.AddArrayItem',
            },

            # check if add button is hidden
            {
                ElementMissing => '.AddArrayItem:visible',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(3) .RemoveButton',
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            'Item 1',
            'New item',
        ],
    },
    {
        Name     => 'ExampleArrayCheckbox',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(1) input:nth-child(2)',
            },
            {
                ElementValue => 1,
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                # Make sure that label is working as well.
                # Normal click, it's not jQuery object.
                Click => '.ArrayItem:nth-of-type(2) label',
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            '1',
            '0',
        ],
    },
    {
        Name     => 'ExampleArrayDate',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },

            # check default day
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(2)',
            },
            {
                ElementValue => '1',
            },

            # check default month
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(1)',
            },
            {
                ElementValue => '1',
            },

            # check default year
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(3)',
            },
            {
                ElementValue => '2017',
            },
            {
                # select day (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDate\"] "
                    . ".ArrayItem:nth-of-type(1) select:nth-child(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDate\"] "
                    . ".ArrayItem:nth-of-type(1) select:nth-child(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDate\"] "
                    . ".ArrayItem:nth-of-type(1) select:nth-child(3)').val(\"2016\")",
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                # Wait to load item
                Select => '.ArrayItem:nth-of-type(2) select:nth-child(1)',
            },
            {
                # select day (15) for second item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDate\"] "
                    . ".ArrayItem:nth-of-type(2) select:nth-child(2)').val(\"15\")",
            },
            {
                # select month (12) for second item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDate\"] "
                    . ".ArrayItem:nth-of-type(2) select:nth-child(1)').val(\"12\")",
            },
            {
                # select year (2016) for second item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDate\"] "
                    . ".ArrayItem:nth-of-type(2) select:nth-child(3)').val(\"2016\")",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            '2016-05-05',
            '2016-12-15',
        ],
    },
    {
        Name     => 'ExampleArrayDate',
        Commands => [
            {
                VerifiedGet => 'Action=AdminSystemConfigurationGroup;RootNavigation=GenericInterface',
            },
            {
                # Click on the GenericInterface link in navigation tree.
                Navigate => 'Sample',
            },
            {
                # Wait until screen is loaded.
                Select => 'select',
            },
            {
                # There is animation running in the AJAX call, which scrolls on top of the page.
                WaitForJS => 'return $("ul.SettingsList").hasClass("Initialized");',
            },
            {
                # Scroll to the setting.
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDate\"]')[0].scrollIntoView(true);",
            },
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                # Wait until Datepicker is loaded.
                Select => '.ArrayItem:nth-of-type(1) .DatepickerIcon',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(1) .DatepickerIcon',
            },
            {
                DatepickerDay => 10,
            },
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-of-type(2)',
            },
            {
                # Make sure that Datepicker is working (Day is updated).
                ElementValue => 10,
            },
            {
                # Discard changes
                JqueryClick => '.Cancel',
            },
        ],
        ExpectedResult => [
            '2016-05-05',
            '2016-12-15',
        ],
    },
    {
        Name     => 'ExampleArrayDateTime',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },

            # check default day
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(2)'
            },
            {
                ElementValue => '1',
            },

            # check default month
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(1)',
            },
            {
                ElementValue => '1',
            },

            # check default year
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(3)',
            },
            {
                ElementValue => '2017',
            },

            # check default hour
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-of-type(4)',
            },
            {
                ElementValue => '1',
            },

            # check default year
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-of-type(5)',
            },
            {
                ElementValue => '45',
            },
            {
                # select day (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDateTime\"] "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDateTime\"] "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDateTime\"] "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(3)').val(\"2016\")",
            },
            {
                # select hour (2) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDateTime\"] "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(4)').val(\"2\")",
            },
            {
                # select minute (2) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDateTime\"] "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(5)').val(\"2\")",
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                # wait to init DatePicker
                Select => '.ArrayItem:nth-of-type(2) select:nth-of-type(2)',
            },
            {
                # select day (15) for second item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDateTime\"] "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(2)').val(\"15\")",
            },
            {
                # select month (12) for second item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDateTime\"] "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(1)').val(\"12\")",
            },
            {
                # select year (2016) for second item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDateTime\"] "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(3)').val(\"2016\")",
            },
            {

                # select hour (16) for second item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDateTime\"] "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(4)').val(\"16\")",
            },
            {
                # select minute (45) second item
                JS => "\$('.WidgetSimple[data-name=\"ExampleArrayDateTime\"] "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(5)').val(\"45\")",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            '2016-05-05 02:02:00',
            '2016-12-15 16:45:00',
        ],
    },
    {
        Name     => 'ExampleArrayDirectory',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                ElementValue => '/etc',
            },
            {
                Clear => 1,
            },
            {
                Write => '/usr',
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            '/etc',
            '/usr',
        ],
    },
    {
        Name     => 'ExampleArrayEntity',
        Index    => 6,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => '3 normal',
            },
            {
                # Select "1 very low".
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleArrayEntity\"] .ArrayItem:nth-of-type(2) select',
                    Value   => '1 very low',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleArrayEntity\"] "
                    . ".ArrayItem:nth-of-type(2) select').val() === '1 very low'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            '3 normal',
            '1 very low',
        ],
    },
    {
        Name     => 'ExampleArrayFile',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                ElementValue => '/etc/hosts',
            },
            {
                Clear => 1,
            },
            {
                Write => '/etc/localtime',
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            '/etc/hosts',
            '/etc/localtime',
        ],
    },
    {
        Name     => 'ExampleArrayFile',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                Write => '/usrfake#',
            },
            {
                Hover => '.Setting',
            },
            {
                ExpectAlert => 'Setting value is not valid!',
            },
            {
                JqueryClick => '.Update',
            },
            {
                JqueryClick => '.Cancel',
            },
        ],
        ExpectedResult => [    # Error occured, nothing was changed
            '/etc/hosts',
            '/etc/localtime',
        ],
    },
    {
        Name     => 'ExampleArrayPassword',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(1) input',
            },
            {
                ElementValue => 'Secret',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Password 1',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Password 2',
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            'Password 1',
            'Password 2',
        ],
    },
    {
        Name     => 'ExampleArrayPerlModule',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => 'Kernel::System::Log::SysLog',
            },
            {
                # Select Kernel::System::Log::File
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleArrayPerlModule\"] .ArrayItem:nth-of-type(2) select',
                    Value   => 'Kernel::System::Log::File',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleArrayPerlModule\"] "
                    . ".ArrayItem:nth-of-type(2) select').val() === 'Kernel::System::Log::File'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            'Kernel::System::Log::SysLog',
            'Kernel::System::Log::File',
        ],
    },
    {
        Name     => 'ExampleArraySelect',
        Index    => 11,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => 'option-2',
            },
            {
                # Select option-2.
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleArraySelect\"] .ArrayItem:nth-of-type(2) select',
                    Value   => 'option-2',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleArraySelect\"] "
                    . ".ArrayItem:nth-of-type(2) select').val() === 'option-2'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => 'option-2',
            },
        ],
        ExpectedResult => [
            'option-1',
            'option-2',
        ],
    },
    {
        Name     => 'ExampleArrayTextarea',
        Index    => 12,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) textarea',
            },
            {
                ElementValue => 'Textarea content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'test content',
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'textarea',
            },
        ],
        ExpectedResult => [
            'Content 1',
            'test content',
        ],
    },
    {
        Name     => 'ExampleArrayTimeZone',
        Index    => 13,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => 'UTC',
            },
            {
                # Select Europe/Berlin
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleArrayTimeZone\"] .ArrayItem:nth-of-type(2) select',
                    Value   => 'Europe/Berlin',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleArrayTimeZone\"] "
                    . ".ArrayItem:nth-of-type(2) select').val() === 'Europe/Berlin'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            'UTC',
            'Europe/Berlin',
        ],
    },
);

$Selenium->RunTest(
    sub {

        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # Rebuild system configuration.
        my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild');
        my $ExitCode      = $CommandObject->Execute('--cleanup');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # Load sample XML file.
        my $Directory = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . '/scripts/test/sample/SysConfig/XML/AdminSystemConfiguration';

        my $XMLLoaded = $SysConfigObject->ConfigurationXML2DB(
            UserID    => 1,
            Directory => $Directory,
            Force     => 1,
            CleanUp   => 0,
        );

        $Self->True(
            $XMLLoaded,
            "Example XML loaded.",
        );

        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            Comments    => "AdminSystemConfigurationArray.t deployment",
            UserID      => 1,
            Force       => 1,
            AllSettings => 1,
        );

        $Self->True(
            $DeploymentResult{Success},
            "Deployment successful.",
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfiguration");

        my $OTRSBusinessIsInstalled = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled();
        my $OBTeaserFound           = index( $Selenium->get_page_source(), 'supports versioning, rollback and' ) > -1;
        if ( !$OTRSBusinessIsInstalled ) {
            $Self->True(
                $OBTeaserFound,
                "OTRSBusiness teaser found on page",
            );
        }
        else {
            $Self->False(
                $OBTeaserFound,
                "OTRSBusiness teaser not found on page",
            );
        }

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=Sample;");

        # Check LinkOption field value (see bug#14575 - https://bugs.otrs.org/show_bug.cgi?id=14575).
        $Self->Is(
            $Selenium->find_element( "input[id*=LinkOption]", "css" )->get_value(),
            'onclick="OpenDialog(\'AgentTest\')"',
            "LinkOption field value is correct",
        );

        my $SelectedItem;
        my $AlertText;

        for my $Test (@Tests) {

            my $Prefix = ".WidgetSimple[data-name='$Test->{Name}']";

            $Selenium->execute_script(
                "\$(\"$Prefix\")[0].scrollIntoView(true);",
            );

            for my $Command ( @{ $Test->{Commands} } ) {
                my $CommandType = ( keys %{$Command} )[0];
                my $Value       = $Command->{$CommandType};

                if ( $CommandType eq 'Click' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );

                    # Give JS some time to do the stuff.
                    Time::HiRes::sleep(0.2);

                    $Selenium->execute_script(
                        '$("' . "$Prefix $Value" . '").click();'
                    );

                    if ($AlertText) {
                        $Selenium->WaitFor(
                            AlertPresent => 1,
                        );

                        # Verify alert message.
                        $Self->Is(
                            $AlertText,
                            $Selenium->get_alert_text(),
                            "$Test->{Name} - Check alert text - $AlertText",
                        );

                        # Accept alert.
                        $Selenium->accept_alert();

                        # Reset alert text.
                        $AlertText = '';
                    }
                    else {
                        $Selenium->WaitFor(
                            Time       => 120,
                            JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                        );
                    }
                }
                elsif ( $CommandType eq 'JqueryClick' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );

                    $Selenium->WaitForjQueryEventBound(
                        CSSSelector => "$Prefix $Value",
                    );

                    $Selenium->execute_script(
                        '$("' . "$Prefix $Value" . '").click();'
                    );

                    if ($AlertText) {
                        $Selenium->WaitFor(
                            AlertPresent => 1,
                        );

                        # Verify alert message.
                        $Self->Is(
                            $AlertText,
                            $Selenium->get_alert_text(),
                            "$Test->{Name} - Check alert text - $AlertText",
                        );

                        # Accept alert.
                        $Selenium->accept_alert();

                        # Reset alert text.
                        $AlertText = '';
                    }
                    else {
                        $Selenium->WaitFor(
                            Time       => 120,
                            JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                        );
                    }
                }
                elsif ( $CommandType eq 'Clear' ) {
                    $SelectedItem->clear();
                }
                elsif ( $CommandType eq 'Hover' ) {
                    my $SelectedItem = $Selenium->find_element( "$Prefix $Value", "css" );
                    $Selenium->mouse_move_to_location( element => $SelectedItem );

                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . "$Prefix $Value" . ':visible").length',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );
                }
                elsif ( $CommandType eq 'ExpectAlert' ) {
                    $AlertText = $Value;
                }
                elsif ( $CommandType eq 'Write' ) {

                    $SelectedItem->send_keys($Value);
                }
                elsif ( $CommandType eq 'ElementValue' ) {

                    $Self->Is(
                        $SelectedItem->get_value(),
                        $Value,
                        "$Test->{Name} - Check if element value is OK.",
                    );
                }
                elsif ( $CommandType eq 'ElementMissing' ) {

                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . "$Prefix $Value" . '").length == 0',
                    );
                }
                elsif ( $CommandType eq 'Select' ) {

                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . $Prefix
                            . '").hasClass("HasOverlay") == 0',
                    );

                    # JS needs more escapes.
                    my $JSValue = $Value;
                    $JSValue =~ s{\\}{\\\\}g;

                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . "$Prefix $JSValue" . '").length'
                    );

                    $SelectedItem = $Selenium->find_element( "$Prefix $Value", "css" );
                }
                elsif ( $CommandType eq 'JS' ) {

                    # Wait for any tasks to complete.
                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . $Prefix
                            . '").hasClass("HasOverlay") == 0',
                    );

                    $Selenium->execute_script(
                        $Command->{JS},
                    );
                }
                elsif ( $CommandType eq 'InputFieldValueSet' ) {

                    # Wait for any tasks to complete.
                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . $Prefix
                            . '").hasClass("HasOverlay") == 0',
                    );

                    $Selenium->InputFieldValueSet(
                        Element => $Value->{Element},
                        Value   => $Value->{Value},
                    );
                }
                elsif ( $CommandType eq 'WaitForJS' ) {
                    $Selenium->WaitFor(
                        JavaScript => $Value,
                    );
                }
                elsif ( $CommandType eq 'VerifiedGet' ) {
                    $Selenium->VerifiedGet("${ScriptAlias}index.pl?$Value");
                }
                elsif ( $CommandType eq 'Navigate' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $("li#' . $Value . ' > i").length',
                    );
                    $Selenium->find_element( "li#$Value > i", "css" )->click();
                }
                elsif ( $CommandType eq 'DatepickerDay' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $(".ui-datepicker-calendar:visible").length',
                    );

                    $Selenium->find_element( '//a[text()="' . $Value . '"]' )->click();
                    $Selenium->WaitFor(
                        JavaScript => 'return $(".ui-datepicker-calendar:visible").length == 0',
                    );
                }
            }

            # Compare results.
            my %Setting = $SysConfigObject->SettingGet(
                Name => $Test->{Name},
            );

            if ( $Test->{ExpectedResult} ) {

                $Self->IsDeeply(
                    $Setting{EffectiveValue},
                    $Test->{ExpectedResult},
                    "Test Effective value deeply for $Test->{Name}",
                );
            }
        }

        # Reload page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=Sample;");

        # Check if there is notification.
        $Self->True(
            index( $Selenium->get_page_source(), 'You have undeployed settings, would you like to deploy them?' ) > -1,
            "Notification shown for undeployed settings."
        );

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#CloudService > i:visible").length',
        );

        $Selenium->execute_script("\$('#CloudService > i').trigger('click')");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#ConfigTree ul > li:first > ul > li:first:visible").length',
        );

        # Check navigation for disabled nodes.
        my $NodeDisabled = $Selenium->execute_script(
            'return $("#ConfigTree ul > li:first > ul > li:first a").hasClass("jstree-disabled");',
        );

        $Self->True(
            $NodeDisabled,
            'Check if CloudService::Admin node is disabled.',
        );

        # Enable this block if you want to test it multiple times.
        my @TestNames;

        # Reset settings to Default.
        for my $Test (@Tests) {
            if ( !grep { $_ eq $Test->{Name} } @TestNames ) {
                my %Setting = $SysConfigObject->SettingGet(
                    Name      => $Test->{Name},
                    Translate => 0,
                );

                my $Guid = $SysConfigObject->SettingLock(
                    UserID    => 1,
                    DefaultID => $Setting{DefaultID},
                    Force     => 1,
                );
                $Self->True(
                    $Guid,
                    "Lock setting before reset($Test->{Name}).",
                );

                my $Success = $SysConfigObject->SettingReset(
                    Name              => $Test->{Name},
                    ExclusiveLockGUID => $Guid,
                    UserID            => 1,
                );
                $Self->True(
                    $Success,
                    "Setting $Test->{Name} reset to the default value.",
                );

                $SysConfigObject->SettingUnlock(
                    DefaultID => $Setting{DefaultID},
                );

                push @TestNames, $Test->{Name};
            }
        }
    }
);

1;
