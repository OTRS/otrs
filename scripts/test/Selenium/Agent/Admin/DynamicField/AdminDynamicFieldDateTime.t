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

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my %DynamicFieldsOverviewPageShownSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name => 'PreferencesGroups###DynamicFieldsOverviewPageShown',
        );

        # Show more dynamic fields per page as the default value.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PreferencesGroups###DynamicFieldsOverviewPageShown',
            Value => {
                %{ $DynamicFieldsOverviewPageShownSysConfig{EffectiveValue} },
                DataSelected => 999,
            },
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminDynamicField.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

        # Create and edit Ticket and Article DynamicFieldCheckbox.
        for my $Type (qw(Ticket Article)) {

            my $ObjectType = $Type . "DynamicField";
            $Selenium->InputFieldValueSet(
                Element => "#$ObjectType",
                Value   => 'Date',
            );

            for my $ID (
                qw(Name Label FieldOrder ValidID DefaultValue YearsPeriod Link DateRestriction)
                )
            {
                $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length" );
                my $Element = $Selenium->find_element( "#$ID", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # Check client side validation.
            my $Element = $Selenium->find_element( "#Name", 'css' );
            $Element->send_keys("");
            $Selenium->find_element( "#Submit", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name.Error").length' );

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#Name').hasClass('Error')"
                ),
                '1',
                'Client side validation correctly detected missing input value',
            );

            # Check default values.
            $Selenium->InputFieldValueSet(
                Element => '#YearsPeriod',
                Value   => 1,
            );

            $Self->Is(
                $Selenium->find_element( '#DefaultValue', 'css' )->get_value(),
                '0',
                "#DefaultValue updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#YearsInPast', 'css' )->get_value(),
                '5',
                "#YearsInPast updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#YearsInFuture', 'css' )->get_value(),
                '5',
                "#YearsInFuture updated value",
            );

            # Create real text DynamicFieldDate.
            my $RandomID = $Helper->GetRandomID();

            $Selenium->find_element( "#Name",   'css' )->send_keys($RandomID);
            $Selenium->find_element( "#Label",  'css' )->send_keys($RandomID);
            $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

            # Check for test DynamicFieldCheckbox on AdminDynamicField screen.
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) > -1,
                "DynamicFieldDate $RandomID found on table"
            ) || die;

            # Edit test DynamicFieldDate years period, default value and set it to invalid.
            $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

            $Selenium->find_element( "#DefaultValue",  'css' )->clear();
            $Selenium->find_element( "#DefaultValue",  'css' )->send_keys("3600");
            $Selenium->find_element( "#YearsInPast",   'css' )->clear();
            $Selenium->find_element( "#YearsInPast",   'css' )->send_keys("10");
            $Selenium->find_element( "#YearsInFuture", 'css' )->clear();
            $Selenium->find_element( "#YearsInFuture", 'css' )->send_keys("8");
            $Selenium->InputFieldValueSet(
                Element => '#ValidID',
                Value   => 2,
            );
            $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

            # Check new and edited DynamicFieldDateTime values.
            $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

            $Self->Is(
                $Selenium->find_element( '#Name', 'css' )->get_value(),
                $RandomID,
                "#Name updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#Label', 'css' )->get_value(),
                $RandomID,
                "#Label updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#DefaultValue', 'css' )->get_value(),
                "3600",
                "#DefaultValue updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#YearsPeriod', 'css' )->get_value(),
                1,
                "#YearsPeriod updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#YearsInPast', 'css' )->get_value(),
                "10",
                "#YearsInPast updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#YearsInFuture', 'css' )->get_value(),
                "8",
                "#YearsInFuture updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#ValidID', 'css' )->get_value(),
                2,
                "#ValidID updated value",
            );

            # Delete DynamicFields.
            my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
            my $DynamicField       = $DynamicFieldObject->DynamicFieldGet(
                Name => $RandomID,
            );
            my $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicField->{ID},
                UserID => 1,
            );
            $Self->True(
                $Success,
                "DynamicFieldDelete() - $RandomID"
            );

            # Go back to AdminDynamicField screen.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");
        }

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "DynamicField" );
    }
);

1;
