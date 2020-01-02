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
                %{ $DynamicFieldsOverviewPageShownSysConfig{EffectiveValue} },,
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

        # Navigate to AdminDynamicField screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

        # Create and edit Ticket and Article DynamicFieldMultiselect.
        for my $Type (qw(Ticket Article)) {

            my $ObjectType = $Type . "DynamicField";
            $Selenium->InputFieldValueSet(
                Element => "#$ObjectType",
                Value   => 'Multiselect',
            );

            for my $ID (
                qw(Name Label FieldOrder ValidID DefaultValue AddValue PossibleNone TreeView TranslatableValues)
                )
            {
                $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length;" );
                my $Element = $Selenium->find_element( "#$ID", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # Check client side validation.
            my $Element2 = $Selenium->find_element( "#Name", 'css' );
            $Element2->send_keys("");
            $Selenium->find_element( "#Submit", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return $("#Name.Error").length;' );

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#Name').hasClass('Error');"
                ),
                '1',
                'Client side validation correctly detected missing input value',
            );

            # Create real text DynamicFieldMultiselect.
            my $RandomID = $Helper->GetRandomID();

            $Selenium->find_element( "#Name",     'css' )->send_keys($RandomID);
            $Selenium->find_element( "#Label",    'css' )->send_keys($RandomID);
            $Selenium->find_element( "#AddValue", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return $("#Key_1").length && $("#Value_1").length;' );
            $Selenium->find_element( "#Key_1",   'css' )->send_keys("Key1");
            $Selenium->find_element( "#Value_1", 'css' )->send_keys("Value1");

            # Check default value.
            $Self->Is(
                $Selenium->find_element( "#DefaultValue option[value='Key1']", 'css' )->get_value(),
                'Key1',
                "Key1 is possible #DefaultValue",
            );

            # Add another possible value.
            $Selenium->find_element( "#AddValue", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return $("#Key_2").length && $("#Value_2").length;' );
            $Selenium->find_element( "#Key_2",   'css' )->send_keys("Key2");
            $Selenium->find_element( "#Value_2", 'css' )->send_keys("Value2");

            # Add another possible value.
            $Selenium->find_element( "#AddValue", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return $("#Key_3").length && $("#Value_3").length;' );

            # Submit form, expecting validation check.
            $Selenium->find_element("//button[\@type='submit']")->click();
            $Selenium->WaitFor( JavaScript => 'return $("#Key_3.Error").length;' );

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#Key_3').hasClass('Error');"
                ),
                '1',
                'Client side validation correctly detected missing input value for added possible value',
            );

            # Input possible value.
            $Selenium->find_element( "#Key_3",   'css' )->send_keys("Key3");
            $Selenium->find_element( "#Value_3", 'css' )->send_keys("Value3");

            # Select default value.
            $Selenium->InputFieldValueSet(
                Element => '#DefaultValue',
                Value   => 'Key3',
            );

            # Verify default value.
            $Self->Is(
                $Selenium->find_element( "#DefaultValue", 'css' )->get_value(),
                'Key3',
                "Key3 is possible #DefaultValue",
            );

            # Remove added possible value.
            $Selenium->find_element( "#RemoveValue__3", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return !$("#Key_3:visible").length && !$("#Value_3:visible").length;' );

            # Verify default value is changed.
            $Self->Is(
                $Selenium->find_element( "#DefaultValue", 'css' )->get_value(),
                '',
                "DefaultValue is removed",
            );

            # Select both possible values as default values to make sure that more than one can be selected.
            $Selenium->InputFieldValueSet(
                Element => '#DefaultValue',
                Value   => "['Key1', 'Key2']",
            );

            $Selenium->execute_script(
                "\$('#Submit')[0].scrollIntoView(true);"
            );

            # Submit form.
            $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

            # Check for test DynamicFieldMultiselect on AdminDynamicField screen.
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) > -1,
                "DynamicFieldMultiselect $RandomID found on table"
            ) || die;

            # Click on created dynamic field.
            $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

            # Check for saved 'defaul values' on creation, expecting both values to be present.
            $Self->IsDeeply(
                $Selenium->execute_script(
                    "return \$('#DefaultValue').val();"
                ),
                [ 'Key1', 'Key2' ],
                'Found default values after creation',
            );

            # Edit test DynamicFieldMultiselect possible none, default value, treeview and set it to invalid.
            $Selenium->InputFieldValueSet(
                Element => '#PossibleNone',
                Value   => 1,
            );
            $Selenium->InputFieldValueSet(
                Element => '#TreeView',
                Value   => 1,
            );
            $Selenium->InputFieldValueSet(
                Element => '#ValidID',
                Value   => 2,
            );

            $Selenium->execute_script(
                "\$('#Submit')[0].scrollIntoView(true);"
            );

            $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

            # Check new and edited DynamicFieldMultiselect values.
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
                $Selenium->find_element( '#Key_1', 'css' )->get_value(),
                "Key1",
                "#Key_1 possible updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#Value_1', 'css' )->get_value(),
                "Value1",
                "#Value_1 possible updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#Key_2', 'css' )->get_value(),
                "Key2",
                "#Key_2 possible updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#Value_2', 'css' )->get_value(),
                "Value2",
                "#Value_2 possible updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#PossibleNone', 'css' )->get_value(),
                1,
                "#PossibleNone updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#TreeView', 'css' )->get_value(),
                1,
                "#TreeView updated value",
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
