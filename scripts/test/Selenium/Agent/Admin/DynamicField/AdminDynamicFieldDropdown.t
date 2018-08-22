# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my %DynamicFieldsOverviewPageShownSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemGet(
            Name => 'PreferencesGroups###DynamicFieldsOverviewPageShown',
        );

        %DynamicFieldsOverviewPageShownSysConfig = map { $_->{Key} => $_->{Content} }
            grep { defined $_->{Key} } @{ $DynamicFieldsOverviewPageShownSysConfig{Setting}->[1]->{Hash}->[1]->{Item} };

        # show more dynamic fields per page as the default value
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PreferencesGroups###DynamicFieldsOverviewPageShown',
            Value => {
                %DynamicFieldsOverviewPageShownSysConfig,
                DataSelected => 999,
            },
        );

        # create test user and login
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

        # navigate to AdminDynamicField screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

        # create and edit Ticket and Article DynamicFieldDropdown
        for my $Type (qw(Ticket Article)) {

            my $ObjectType = $Type . "DynamicField";

            # add dynamic field of type Dropdown
            $Selenium->execute_script("\$('#$ObjectType').val('Dropdown').trigger('change');");

            # wait until page has finished loading
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

            for my $ID (
                qw(Name Label FieldOrder ValidID DefaultValue AddValue PossibleNone TreeView TranslatableValues Link)
                )
            {
                my $Element = $Selenium->find_element( "#$ID", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # check client side validation
            my $Element = $Selenium->find_element( "#Name", 'css' );
            $Element->send_keys("");
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#Name').hasClass('Error')"
                ),
                '1',
                'Client side validation correctly detected missing input value',
            );

            # create real text DynamicFieldDropdown
            my $RandomID = $Helper->GetRandomID();

            $Selenium->find_element( "#Name",     'css' )->send_keys($RandomID);
            $Selenium->find_element( "#Label",    'css' )->send_keys($RandomID);
            $Selenium->find_element( "#AddValue", 'css' )->VerifiedClick();
            $Selenium->find_element( "#Key_1",    'css' )->send_keys("Key1");
            $Selenium->find_element( "#Value_1",  'css' )->send_keys("Value1");

            # check default value
            $Self->Is(
                $Selenium->find_element( "#DefaultValue option[value='Key1']", 'css' )->is_enabled(),
                1,
                "Key1 is possible #DefaultValue",
            );

            # add another possible value
            $Selenium->find_element( "#AddValue", 'css' )->VerifiedClick();
            $Selenium->find_element( "#Key_2",    'css' )->send_keys("Key2");
            $Selenium->find_element( "#Value_2",  'css' )->send_keys("Value2");

            # check default value
            $Self->Is(
                $Selenium->find_element( "#DefaultValue option[value='Key2']", 'css' )->is_enabled(),
                1,
                "Key2 is possible #DefaultValue",
            );

            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # check for test DynamicFieldDropdown on AdminDynamicField screen
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) > -1,
                "DynamicFieldDropdown $RandomID found on table"
            ) || die;

            # edit test DynamicFieldDropdown possible none, treeview, default value and set it to invalid
            $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

            $Selenium->execute_script(
                "\$('#DefaultValue').val('Key1').trigger('redraw.InputField').trigger('change');"
            );
            $Selenium->execute_script("\$('#PossibleNone').val('1').trigger('redraw.InputField').trigger('change');");
            $Selenium->execute_script("\$('#TreeView').val('1').trigger('redraw.InputField').trigger('change');");
            $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # check new and edited DynamicFieldDropdown values
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
                $Selenium->find_element( '#DefaultValue', 'css' )->get_value(),
                "Key1",
                "#DefaultValue updated value",
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

            # delete DynamicFields
            my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
            my $DynamicField       = $DynamicFieldObject->DynamicFieldGet(
                Name => $RandomID,
            );
            my $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicField->{ID},
                UserID => 1,
            );

            # sanity check
            $Self->True(
                $Success,
                "DynamicFieldDelete() - $RandomID"
            );

            # Go back to AdminDynamicField screen.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminDynamicField");

        }

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "DynamicField" );

    }

);

1;
