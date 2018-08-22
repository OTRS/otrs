# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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
        Name     => 'ExampleCheckbox1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => 'label',    # make sure that label is working as well
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'label',
            },
        ],
        ExpectedResult => 1,
    },
    {
        Name     => 'ExampleCheckbox2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => 'label',    # make sure that label is working as well
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'label',
            },
        ],
        ExpectedResult => 0,
    },
    {
        Name     => 'ExampleDate',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until DatePicker is initialized
                Select => '.DatepickerIcon',
            },
            {
                # select day (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleDate\"] "
                    . "select:nth-child(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleDate\"] "
                    . "select:nth-child(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleDate\"] "
                    . "select:nth-child(3)').val(\"2016\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => '2016-05-05',
    },
    {
        Name     => 'ExampleDateTime',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until DatePicker is initialized
                Select => '.DatepickerIcon',
            },
            {
                # select day (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleDateTime\"] "
                    . "select:nth-child(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleDateTime\"] "
                    . "select:nth-child(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleDateTime\"] "
                    . "select:nth-child(3)').val(\"2016\")",
            },
            {
                # select hour (2) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleDateTime\"] "
                    . "select:nth-of-type(4)').val(\"2\")",
            },
            {
                # select minute (2) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleDateTime\"] "
                    . "select:nth-of-type(5)').val(\"2\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => '2016-05-05 02:02:00',
    },
    {
        Name     => 'ExampleDirectory',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
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
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => '/usr',
    },
    {
        Name     => 'ExampleDirectory',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
            },
            {
                Clear => 1,
            },
            {
                Write => '/usr123#',
            },
            {
                Hover => '.Setting',
            },
            {
                ExpectAlert => 'Setting value is not valid!',
            },
            {
                Click => '.Update',
            },
            {
                Click => '.Cancel',
            },
        ],
        ExpectedResult => '/usr',
    },
    {
        Name     => 'ExampleEntityPriority',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select '1 very low'.
                JS => "\$('.WidgetSimple[data-name=\"ExampleEntityPriority\"] "
                    . " select').val('1 very low')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleEntityPriority\"] "
                    . "select').val() === '1 very low'",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => '1 very low',
    },
    {
        Name     => 'ExampleEntityQueue',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select 'Raw'.
                JS => "\$('.WidgetSimple[data-name=\"ExampleEntityQueue\"] "
                    . " select').val('Raw')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleEntityQueue\"] "
                    . "select').val() === 'Raw'",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => 'Raw',
    },
    {
        Name     => 'ExampleFile',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
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
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => '/etc/localtime',
    },
    {
        Name     => 'ExampleFile',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
            },
            {
                Clear => 1,
            },
            {
                Write => '/usr123#',
            },
            {
                Hover => '.Setting',
            },
            {
                ExpectAlert => 'Setting value is not valid!',
            },
            {
                Click => '.Update',
            },
            {
                Click => '.Cancel',
            },
        ],
        ExpectedResult => '/etc/localtime',
    },
    {
        Name     => 'ExampleFrontendRegistration###AgentTest',
        Commands => [
            {
                Click => '.Header',
            },
            {
                # Disable setting.
                Click => 'a.SettingEnabled',
            },
            {
                Deploy => 1,
            },
        ],
        ExpectedResult => undef,
    },
    {
        Name     => 'ExampleFrontendRegistration###AgentTest',
        Commands => [
            {
                Click => '.Header',
            },
            {
                # Enable setting.
                Click => 'a.SettingDisabled',
            },
            {
                Deploy => 1,
            },
        ],
        ExpectedResult => {
            'Description' => 'Incoming Phone Call.',
            'Group'       => [],
            'GroupRo'     => [],
            'NavBarName'  => 'Ticket',
            'Title'       => 'Phone-Ticket',
        },
    },
    {
        Name     => 'ExampleFrontendRegistration###AgentTest',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
            },
            {
                # Add new Group item.
                Click => '.HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                Select => '.HashItem:nth-of-type(2) input.Entry',
            },
            {
                Write => 'admin',
            },
            {
                Select => '.HashItem:nth-of-type(4) .SettingContent input',
            },
            {
                Write => '#',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'Description' => 'Incoming Phone Call.',
            'Group'       => ['admin'],
            'GroupRo'     => [],
            'NavBarName'  => 'Ticket#',
            'Title'       => 'Phone-Ticket',
        },
    },
    {
        Name     => 'ExamplePassword',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Password 1',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => 'Password 1',
    },
    {
        Name     => 'ExamplePerlModule',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.WidgetSimple[data-name=\"ExamplePerlModule\"] "
                    . " select').val('Kernel::System::Log::File')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExamplePerlModule\"] "
                    . "select').val() === 'Kernel::System::Log::File'",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => 'Kernel::System::Log::File',
    },
    {
        Name     => 'ExampleSelect',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select option-2.
                JS => "\$('.WidgetSimple[data-name=\"ExampleSelect\"] "
                    . " select').val('option-2')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleSelect\"] "
                    . "select').val() === 'option-2'",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
            {
                ElementValue => 'option-2',
            },
        ],
        ExpectedResult => 'option-2',
    },
    {
        Name     => 'ExampleString',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Ticket#45',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => '.Setting input',
            },
            {
                ElementValue => 'Ticket#45',
            },
        ],
        ExpectedResult => 'Ticket#45',
    },
    {
        Name     => 'ExampleString',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
            },
            {
                Clear => 1,
            },
            {
                Write => '',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => '.Setting input',
            },
            {
                ElementValue => '',
            },
        ],
        ExpectedResult => '',
    },
    {
        Name     => 'ExampleTextarea',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => 'textarea',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Area text',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'textarea',
            },
            {
                ElementValue => 'Area text',
            },
        ],
        ExpectedResult => 'Area text',
    },
    {
        Name     => 'ExampleTextarea',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => 'textarea',
            },
            {
                Clear => 1,
            },
            {
                Write => '',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'textarea',
            },
            {
                ElementValue => '',
            },
        ],
        ExpectedResult => '',
    },
    {
        Name     => 'ExampleTimeZone',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select Europe/Berlin
                JS => "\$('.WidgetSimple[data-name=\"ExampleTimeZone\"] "
                    . " select').val('Europe/Berlin')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleTimeZone\"] "
                    . "select').val() === 'Europe/Berlin'",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => 'Europe/Berlin',
    },
    {
        Name     => 'ExampleVacationDays',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.AddArrayItem',
            },
        ],
        ExpectedResult => {},
    },
    {
        Name     => 'ExampleVacationDays',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until Add item button is shown
                Select => '.AddArrayItem',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                # Select month 04
                JS => "\$('.WidgetSimple[data-name=\"ExampleVacationDays\"] "
                    . " .ArrayItem:nth-of-type(1) select:nth-of-type(1)').val('04')",
            },
            {
                # Select day 05
                JS => "\$('.WidgetSimple[data-name=\"ExampleVacationDays\"] "
                    . " .ArrayItem:nth-of-type(1) select:nth-of-type(2)').val('05')",
            },
            {
                Select => '.ArrayItem:nth-of-type(1) input',
            },
            {
                Write => 'Vacation day 1',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                # Select month 11
                JS => "\$('.WidgetSimple[data-name=\"ExampleVacationDays\"] "
                    . " .ArrayItem:nth-of-type(2) select:nth-of-type(1)').val('11')",
            },
            {
                # Select day 22
                JS => "\$('.WidgetSimple[data-name=\"ExampleVacationDays\"] "
                    . " .ArrayItem:nth-of-type(2) select:nth-of-type(2)').val('22')",
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                Write => 'Vacation day 2',
            },

            {
                Click => '.AddArrayItem',
            },
            {
                # Select month 02
                JS => "\$('.WidgetSimple[data-name=\"ExampleVacationDays\"] "
                    . " .ArrayItem:nth-of-type(3) select:nth-of-type(1)').val('02')",
            },
            {
                # Select day 10
                JS => "\$('.WidgetSimple[data-name=\"ExampleVacationDays\"] "
                    . " .ArrayItem:nth-of-type(3) select:nth-of-type(2)').val('10')",
            },
            {
                Select => '.ArrayItem:nth-of-type(3) input',
            },
            {
                Write => 'Vacation day 3',
            },

            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.AddArrayItem',
            },
        ],
        ExpectedResult => {
            '4' => {
                '5' => 'Vacation day 1'
            },
            '11' => {
                '22' => 'Vacation day 2'
            },
            '2' => {
                '10' => 'Vacation day 3'
            },
        },
    },
    {
        Name     => 'ExampleVacationDaysOneTime',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.AddArrayItem',
            },
        ],
        ExpectedResult => {},
    },
    {
        Name     => 'ExampleVacationDaysOneTime',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until Add item button is shown
                Select => '.AddArrayItem',
            },
            {
                Click => '.AddArrayItem',
            },

            #MDY
            {
                # Select month 04
                JS => "\$('.WidgetSimple[data-name=\"ExampleVacationDaysOneTime\"] "
                    . " .ArrayItem:nth-of-type(1) select:nth-of-type(1)').val('4')",
            },
            {
                # Select day 05
                JS => "\$('.WidgetSimple[data-name=\"ExampleVacationDaysOneTime\"] "
                    . " .ArrayItem:nth-of-type(1) select:nth-of-type(2)').val('5')",
            },
            {
                # Select year 2017
                JS => "\$('.WidgetSimple[data-name=\"ExampleVacationDaysOneTime\"] "
                    . " .ArrayItem:nth-of-type(1) select:nth-of-type(3)').val('2017')",
            },
            {
                Select => '.ArrayItem:nth-of-type(1) input.VacationDaysOneTime',
            },
            {
                Write => 'Vacation day 1',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.AddArrayItem',
            },
        ],
        ExpectedResult => {
            '2017' => {
                '4' => {
                    '5' => 'Vacation day 1',
                },
            },
        },
    },
    {
        Name     => 'ExampleWorkingHours',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => '.Update',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(9)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(10)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(34)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(35)',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.Update',
            },
        ],
        ExpectedResult => {},
    },
    {
        Name     => 'ExampleWorkingHours',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => '.Update',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(9)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(10)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(34)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(35)',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.Update',
            },
        ],
        ExpectedResult => {
            'Mon' => [
                '8',
                '9',
            ],
            'Tue' => [
                '8',
                '9',
            ],
        },
    },
    {
        # This test checks if disabled settings work properly.
        Name     => 'ZZZExampleStringDisabled',
        Commands => [
            {
                # Edit button is not visible.
                ElementMissing => '.SettingEdit:visible',
            },
            {
                # Expand setting bar.
                Click => '.Header',
            },
            {
                # Edit alias button is not visible.
                ElementMissing => '.EditAlias:visible',
            },
            {
                # Enable setting.
                Click => '.SettingDisabled',
            },
            {
                # wait and edit
                Click => '.EditAlias',
            },
            {
                Select => 'input#ZZZExampleStringDisabled',
            },
            {
                Clear => 1,
            },
            {
                Write => 'abc',
            },
            {
                Click => '.SaveAlias',
            },
            {
                ElementMissing => '.SaveAlias:visible',
            },
            {
                # Disable the setting.
                Click => '.SettingEnabled',
            },
        ],
        ExpectedResult => 'abc',
    },
    {
        # This test checks if disabled invalid settings work properly.
        Name     => 'ZZZZExampleFileInvalidDisabled',
        Commands => [
            {
                # Edit button is not visible.
                ElementMissing => '.SettingEdit:visible',
            },
            {
                # Expand setting bar.
                Click => '.Header',
            },
            {
                # Edit alias button is not visible.
                ElementMissing => '.EditAlias:visible',
            },
            {
                # Enable setting.
                Click => '.SettingDisabled',
            },
            {
                # wait and edit
                Click => '.EditAlias',
            },
            {
                Select => 'input#ZZZZExampleFileInvalidDisabled',
            },
            {
                Write => 'ijwiofj',    # Try with wrong value, to check if validation still works.
            },
            {
                ExpectAlert => 'Setting value is not valid!',
            },
            {
                Click => '.SaveAlias',
            },
            {
                Select => '.SaveAlias',
            },
            {
                Select => 'input#ZZZZExampleFileInvalidDisabled',
            },
            {
                Clear => 1,
            },
            {
                Write => '/etc/hosts',
            },
            {
                Click => '.SaveAlias',
            },
            {
                ElementMissing => '.SaveAlias:visible',
            },
            {
                # Disable the setting.
                Click => '.SettingEnabled',
            },
        ],
        ExpectedResult => '/etc/hosts',
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
            Comments    => "AdminSystemConfiguration.t deployment",
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
        my $OBTeaserFound = index( $Selenium->get_page_source(), 'supports versioning, rollback and' ) > -1;
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

                    $Selenium->find_element( "$Prefix $Value", "css" )->click();
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
                        JavaScript => 'return typeof($) === "function" && $("' . "$Prefix $JSValue" . '").length',
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
                elsif ( $CommandType eq 'WaitForJS' ) {
                    $Selenium->WaitFor(
                        JavaScript => $Value,
                    );
                }
                elsif ( $CommandType eq 'Deploy' ) {
                    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
                        Comments    => "AdminSystemConfigurationBasic.t deployment",
                        UserID      => 1,
                        Force       => 1,
                        AllSettings => 1,
                    );

                    $Self->True(
                        $DeploymentResult{Success},
                        "Deployment successful.",
                    );

                    # Reload page.
                    $Selenium->VerifiedGet(
                        "${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=Sample;"
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

        # Make sure that invisible setting can't be reached by manipulating url.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=SystemConfiguration::MaximumDeployments"
        );

        # Check if there is notification.
        $Self->True(
            index(
                $Selenium->get_page_source(),
                "This group doesn't contain any settings. Please try navigating to one of its sub groups or another group."
            ) > -1,
            "Invisible setting not found."
        );

    }
);

1;
