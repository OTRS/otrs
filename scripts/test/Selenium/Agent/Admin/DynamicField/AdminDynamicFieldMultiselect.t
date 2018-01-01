# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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

        # create and edit Ticket and Article DynamicFieldMultiselect
        for my $Type (qw(Ticket Article)) {

            my $ObjectType = $Type . "DynamicField";
            $Selenium->execute_script(
                "\$('#$ObjectType').val('Multiselect').trigger('redraw.InputField').trigger('change');"
            );

            # wait until page has finished loading
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

            for my $ID (
                qw(Name Label FieldOrder ValidID DefaultValue AddValue PossibleNone TreeView TranslatableValues)
                )
            {
                my $Element = $Selenium->find_element( "#$ID", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # check client side validation
            my $Element2 = $Selenium->find_element( "#Name", 'css' );
            $Element2->send_keys("");
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#Name').hasClass('Error')"
                ),
                '1',
                'Client side validation correctly detected missing input value',
            );

            # create real text DynamicFieldMultiselect
            my $RandomID = $Helper->GetRandomID();

            $Selenium->find_element( "#Name",     'css' )->send_keys($RandomID);
            $Selenium->find_element( "#Label",    'css' )->send_keys($RandomID);
            $Selenium->find_element( "#AddValue", 'css' )->VerifiedClick();
            $Selenium->find_element( "#Key_1",    'css' )->send_keys("Key1");
            $Selenium->find_element( "#Value_1",  'css' )->send_keys("Value1");

            # check default value
            $Self->Is(
                $Selenium->find_element( "#DefaultValue option[value='Key1']", 'css' )->get_value(),
                'Key1',
                "Key1 is possible #DefaultValue",
            );

            # add another possible value
            $Selenium->find_element( "#AddValue", 'css' )->VerifiedClick();
            $Selenium->find_element( "#Key_2",    'css' )->send_keys("Key2");
            $Selenium->find_element( "#Value_2",  'css' )->send_keys("Value2");

            # add another possible value
            $Selenium->find_element( "#AddValue", 'css' )->VerifiedClick();

            # submit form, expecting validation check
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#Key_3').hasClass('Error')"
                ),
                '1',
                'Client side validation correctly detected missing input value for added possible value',
            );

            # input possible value
            $Selenium->find_element( "#Key_3",   'css' )->send_keys("Key3");
            $Selenium->find_element( "#Value_3", 'css' )->send_keys("Value3");

            # select default value
            $Selenium->execute_script(
                "\$('#DefaultValue').val('Key3').trigger('redraw.InputField').trigger('change');"
            );

            # verify default value
            $Self->Is(
                $Selenium->find_element( "#DefaultValue", 'css' )->get_value(),
                'Key3',
                "Key3 is possible #DefaultValue",
            );

            # remove added possible value
            $Selenium->find_element( "#RemoveValue__3", 'css' )->VerifiedClick();

            # verify default value is changed
            $Self->Is(
                $Selenium->find_element( "#DefaultValue", 'css' )->get_value(),
                '',
                "DefaultValue is removed",
            );

            # Select both possible values as default values to make sure that more than one can be selected.
            $Selenium->execute_script(
                "\$('#DefaultValue').val(['Key1', 'Key2']).trigger('redraw.InputField').trigger('change');"
            );

            # submit form
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # check for test DynamicFieldMultiselect on AdminDynamicField screen
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) > -1,
                "DynamicFieldMultiselect $RandomID found on table"
            ) || die;

            # click on created dynamic field
            $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

            # check for saved 'defaul values' on creation, expecting both values to be present
            $Self->IsDeeply(
                $Selenium->execute_script(
                    "return \$('#DefaultValue').val();"
                ),
                [ 'Key1', 'Key2' ],
                'Found default values after creation',
            );

            # edit test DynamicFieldMultiselect possible none, default value, treeview and set it to invalid
            $Selenium->execute_script("\$('#PossibleNone').val('1').trigger('redraw.InputField').trigger('change');");
            $Selenium->execute_script("\$('#TreeView').val('1').trigger('redraw.InputField').trigger('change');");
            $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # check new and edited DynamicFieldMultiselect values
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
