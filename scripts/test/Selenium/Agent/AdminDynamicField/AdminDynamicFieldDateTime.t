# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminDynamicField");

        # create and edit Ticket and Article DynamicFieldCheckbox
        for my $Type (qw(Ticket Article)) {

            my $ObjectType = $Type . "DynamicField";
            $Selenium->execute_script("\$('#$ObjectType').val('Date').trigger('redraw.InputField').trigger('change');");

            for my $ID (
                qw(Name Label FieldOrder ValidID DefaultValue YearsPeriod Link DateRestriction)
                )
            {
                my $Element = $Selenium->find_element( "#$ID", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # check client side validation
            my $Element = $Selenium->find_element( "#Name", 'css' );
            $Element->send_keys("");
            $Element->submit();

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#Name').hasClass('Error')"
                ),
                '1',
                'Client side validation correctly detected missing input value',
            );

            # check default values
            $Selenium->execute_script("\$('#YearsPeriod').val('1').trigger('redraw.InputField').trigger('change');");

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

            # create real text DynamicFieldDate
            my $RandomID = $Helper->GetRandomID();

            $Selenium->find_element( "#Name",  'css' )->send_keys($RandomID);
            $Selenium->find_element( "#Label", 'css' )->send_keys($RandomID);
            $Selenium->find_element( "#Name",  'css' )->submit();

            # check for test DynamicFieldCheckbox on AdminDynamicField screen
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) > -1,
                "DynamicFieldDate $RandomID found on table"
            );

            # edit test DynamicFieldDate years period, default value and set it to invalid
            $Selenium->find_element( $RandomID, 'link_text' )->click();

            $Selenium->find_element( "#DefaultValue",              'css' )->clear();
            $Selenium->find_element( "#DefaultValue",              'css' )->send_keys("3600");
            $Selenium->find_element( "#YearsInPast",               'css' )->clear();
            $Selenium->find_element( "#YearsInPast",               'css' )->send_keys("10");
            $Selenium->find_element( "#YearsInFuture",             'css' )->clear();
            $Selenium->find_element( "#YearsInFuture",             'css' )->send_keys("8");
            $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element( "#Name",                      'css' )->submit();

            # check new and edited DynamicFieldDateTime values
            $Selenium->find_element( $RandomID, 'link_text' )->click();

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

            # go back to AdminDynamicField screen
            $Selenium->get("${ScriptAlias}index.pl?Action=AdminDynamicField");

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

        }

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "DynamicField" );

    }

);

1;
