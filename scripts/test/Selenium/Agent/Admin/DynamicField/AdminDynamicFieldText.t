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

        # create and edit Ticket and Article DynamicFieldText
        for my $Type (qw(Ticket Article)) {

            my $ObjectType = $Type . "DynamicField";
            $Selenium->execute_script("\$('#$ObjectType').val('Text').trigger('redraw.InputField').trigger('change');");

            # wait until page has finished loading
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

            for my $ID (
                qw(Name Label FieldOrder DefaultValue Link AddRegEx ValidID)
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

            # create real text DynamicFieldText
            my $RandomID      = $Helper->GetRandomID();
            my $RegEx         = '^[0-9]$';
            my $RegExErrorTxt = "Please remove this entry and enter a new one with the correct value.";

            $Selenium->find_element( "#Name",                        'css' )->send_keys($RandomID);
            $Selenium->find_element( "#Label",                       'css' )->send_keys($RandomID);
            $Selenium->find_element( "#AddRegEx",                    'css' )->VerifiedClick();
            $Selenium->find_element( "#RegEx_1",                     'css' )->send_keys($RegEx);
            $Selenium->find_element( "#CustomerRegExErrorMessage_1", 'css' )->send_keys($RegExErrorTxt);
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # check for test DynamicFieldText on AdminDynamicField screen
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) > -1,
                "DynamicFieldText $RandomID found on table"
            ) || die;

            # edit test DynamicFieldText default value and set it to invalid
            $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

            $Selenium->find_element( "#DefaultValue", 'css' )->send_keys("Default");
            $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # check new and edited DynamicFieldText values
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
                "Default",
                "#DefaultValue updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#RegEx_1', 'css' )->get_value(),
                $RegEx,
                "#RegEx_1 updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#CustomerRegExErrorMessage_1', 'css' )->get_value(),
                $RegExErrorTxt,
                "#CustomerRegExErrorMessage_1 updated value",
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
