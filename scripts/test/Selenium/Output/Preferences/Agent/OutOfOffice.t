# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Set OTRSTimeZone to UTC.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'OTRSTimeZone',
            Value => 'UTC',
        );

        # create and login test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to agent preferences
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");

        # Change test user time zone preference to -5 hours. Displayed out of office date values
        #   should not be converted to local time zone, see bug#12471.
        $Selenium->execute_script(
            "\$('#UserTimeZone').val('Pacific/Easter').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script(
            "\$('#UserTimeZone').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserTimeZone').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserTimeZone').closest('.WidgetSimple').find('.fa-check').length"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#UserTimeZone').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # reload the screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");

        # Get current date and time components.
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime'
        );
        my $Date = $DateTimeObject->Get();

        # Change test user out of office preference to current date.
        $Selenium->find_element( "#OutOfOfficeOn", 'css' )->VerifiedClick();
        for my $FieldGroup (qw(Start End)) {
            for my $FieldType (qw(Year Month Day)) {
                $Selenium->execute_script(
                    "\$('#OutOfOffice$FieldGroup$FieldType').val($Date->{$FieldType}).trigger('change');"
                );
            }
        }
        $Selenium->execute_script(
            "\$('#OutOfOfficeOn').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#OutOfOfficeOn').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#OutOfOfficeOn').closest('.WidgetSimple').find('.fa-check').length"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#OutOfOfficeOn').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # reload the screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");

        # Check displayed date and time values.
        for my $FieldGroup (qw(Start End)) {
            for my $FieldType (qw(Year Month Day)) {
                $Self->Is(
                    int $Selenium->find_element( "#OutOfOffice$FieldGroup$FieldType", 'css' )->get_value(),
                    int $Date->{$FieldType},
                    "Shown OutOfOffice$FieldGroup$FieldType field value"
                );
            }
        }

        # set start time after end time, see bug #8220
        my $StartYear = $Date->{Year} + 2;
        $Selenium->execute_script(
            "\$('#OutOfOfficeStartYear').val('$StartYear').trigger('change');"
        );

        $Selenium->execute_script(
            "\$('#OutOfOfficeOn').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#OutOfOfficeOn').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#OutOfOfficeOn').closest('.WidgetSimple').find('.WidgetMessage.Error:visible').length"
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#OutOfOfficeOn').closest('.WidgetSimple').find('.WidgetMessage.Error').text()"
            ),
            "Please specify an end date that is after the start date.",
            'Error message shows up correctly',
        );
    }
);

1;
