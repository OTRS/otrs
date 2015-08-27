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

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminQueue");

        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click 'add new queue' link
        $Selenium->find_element( "a.Create", 'css' )->click();

        # check add page
        for my $ID (
            qw(Name GroupID FollowUpID FollowUpLock SalutationID SystemAddressID SignatureID ValidID)
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

        #$Element->click("button#Submit");
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminQueue");
        $Selenium->find_element( "a.Create", 'css' )->click();

        # create a real test queue
        my $RandomID = "Queue" . $Helper->GetRandomID();

        $Selenium->find_element( "#Name", 'css' )->send_keys($RandomID);
        $Selenium->execute_script("\$('#GroupID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#FollowUpID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#SalutationID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#SystemAddressID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#SignatureID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment", 'css' )->send_keys('Selenium test queue');
        $Selenium->find_element( "#Name",    'css' )->submit();

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminQueue");

        # check Queue - Responses page
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            'New queue found on table'
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # go to new queue again
        $Selenium->find_element( $RandomID, 'link_text' )->click();

        # check new queue values
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#GroupID', 'css' )->get_value(),
            1,
            "#GroupID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#FollowUpID', 'css' )->get_value(),
            1,
            "#FollowUpID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#FollowUpLock', 'css' )->get_value(),
            0,
            "#FollowUpLock stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#SalutationID', 'css' )->get_value(),
            1,
            "#SalutationID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#SystemAddressID', 'css' )->get_value(),
            1,
            "#SystemAddressID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#SignatureID', 'css' )->get_value(),
            1,
            "#SignatureID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Selenium test queue',
            "#Comment stored value",
        );

        # set test queue to invalid
        $Selenium->execute_script("\$('#GroupID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->find_element( "#Comment", 'css' )->submit();

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminQueue");

        # check overview page
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            'New queue found on table'
        );

        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check class of invalid Queue in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($RandomID)').length"
            ),
            "There is a class 'Invalid' for test Queue",
        );

        # go to new state again
        $Selenium->find_element( $RandomID, 'link_text' )->click();

        # check new queue values
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#GroupID', 'css' )->get_value(),
            2,
            "#GroupID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            '',
            "#Comment updated value",
        );

        # since there are no tickets that rely on our test queue, we can remove them again
        # from the DB.
        my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup(
            Queue => $RandomID,
        );
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "QueueDelete - $RandomID",
        );

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Queue',
        );

    }
);

1;
