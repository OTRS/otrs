# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # Enable TimeZoneUser feature.
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'TimeZoneUser',
            Value => 1,
        );

        # Disable TimeZoneUserBrowserAutoOffset feature.
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'TimeZoneUserBrowserAutoOffset',
            Value => 0,
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
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences");

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # Change test user time zone preference to -5 hours. Displayed out of office date values
        #   should not be converted to local time zone, see bug#12471.
        $Selenium->execute_script("\$('#UserTimeZone').val('-5').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( '#UserTimeZoneUpdate', 'css' )->VerifiedClick();

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # Get current date and time components.
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
        my %Date;
        ( $Date{Sec}, $Date{Min}, $Date{Hour}, $Date{Day}, $Date{Month}, $Date{Year}, $Date{WeekDay} )
            = $TimeObject->SystemTime2Date(
            SystemTime => $TimeObject->SystemTime(),
            );

        # Change test user out of office preference to current date.
        $Selenium->find_element( "#OutOfOfficeOn", 'css' )->VerifiedClick();
        for my $FieldGroup (qw(Start End)) {
            for my $FieldType (qw(Year Month Day)) {
                $Selenium->execute_script(
                    "\$('#OutOfOffice$FieldGroup$FieldType').val($Date{$FieldType}).trigger('change');"
                );
            }
        }
        $Selenium->find_element( "#Update", 'css' )->VerifiedClick();

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # check for update preference message on screen
        my $UpdateMessage = "Preferences updated successfully!";
        $Self->True(
            index( $Selenium->get_page_source(), $UpdateMessage ) > -1,
            'Agent preference out of office time - updated'
        );

        # Check displayed date and time values.
        for my $FieldGroup (qw(Start End)) {
            for my $FieldType (qw(Year Month Day)) {
                $Self->Is(
                    int $Selenium->find_element( "#OutOfOffice$FieldGroup$FieldType", 'css' )->get_value(),
                    int $Date{$FieldType},
                    "Shown OutOfOffice$FieldGroup$FieldType field value"
                );
            }
        }
    }
);

1;
