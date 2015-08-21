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

        my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $Language = 'de';

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => ['admin'],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminRole");

        # check roles overview screen,
        # if there are roles, check is there table on screen
        # otherwise check is there a message that no roles are defined
        my %RoleList = $Kernel::OM->Get('Kernel::System::Group')->RoleList();
        if (%RoleList) {
            $Selenium->find_element( "table",             'css' );
            $Selenium->find_element( "table thead tr th", 'css' );
            $Selenium->find_element( "table tbody tr td", 'css' );
        }
        else {
            my $LanguageObject = Kernel::Language->new(
                UserLanguage => $Language,
            );

            $Self->True(
                index(
                    $Selenium->get_page_source(),
                    $LanguageObject->Get(
                        "There are no roles defined. Please use the 'Add' button to create a new role."
                        )
                    ) > -1,
                "There are no roles defined.",
            );
        }

        # click 'add new role' linK
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminRole;Subaction=Add' )]")->click();

        # check add page
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Selenium->find_element( "#Comment", 'css' );
        $Selenium->find_element( "#ValidID", 'css' );

        # check client side validation
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element( "#Name", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # create a real test role
        my $RandomID = 'TestRole' . $Helper->GetRandomID();
        $Selenium->find_element( "#Name",                      'css' )->send_keys($RandomID);
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment",                   'css' )->send_keys('Selenium test role');
        $Selenium->find_element( "#Name",                      'css' )->submit();

        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # go to new role again
        $Selenium->find_element( $RandomID, 'link_text' )->click();

        # check new role values
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Selenium test role',
            "#Comment stored value",
        );

        # set test role to invalid
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment",                   'css' )->clear();
        $Selenium->find_element( "#Name",                      'css' )->submit();

        # check overview page
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );

        # chack class of invalid Role in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($RandomID)').length"
            ),
            "There is a class 'Invalid' for test Role",
        );

        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # go to new role again
        $Selenium->find_element( $RandomID, 'link_text' )->click();

        # check new role values
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name updated value",
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

        # Since there are no tickets that rely on our test roles, we can remove them again
        # from the DB.
        if ($RandomID) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            $RandomID = $DBObject->Quote($RandomID);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM roles WHERE name = ?",
                Bind => [ \$RandomID ],
            );
            $Self->True(
                $Success,
                "RoleDelete - $RandomID",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Group',
        );

    }

);

1;
