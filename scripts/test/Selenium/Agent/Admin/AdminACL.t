# --
# AdminACL.t - frontend tests for the ACL admin screen
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

use Selenium::Remote::WDKeys;

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 0,
        );

        my $CheckAlertJS = <<"JAVASCRIPT";
(function () {
    var lastAlert = undefined;
    window.alert = function (message) {
        lastAlert = message;
    };
    window.getLastAlert = function () {
        var result = lastAlert;
        lastAlert = undefined;
        return result;
    };
}());
JAVASCRIPT

        # defined user language for testing if message is being translated correctly
        my $Language = "de";

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

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminACL");

        # click 'Create new ACL' link
        $Selenium->find_element( "a.Create", 'css' )->click();

        # check add page
        for my $ID (
            qw(Name Comment Description StopAfterMatch ValidID)
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

        # create a real test queue
        my $RandomID = $Helper->GetRandomID();

        # fill in test data
        $Selenium->find_element( "#Name",                      'css' )->send_keys($RandomID);
        $Selenium->find_element( "#Comment",                   'css' )->send_keys('Selenium Test ACL');
        $Selenium->find_element( "#Description",               'css' )->send_keys('Selenium Test ACL');
        $Selenium->find_element( "#StopAfterMatch",            'css' )->click();
        $Selenium->find_element( "#ValidID option[value='1']", 'css' )->click();

        # send form
        $Selenium->find_element( "#Name", 'css' )->submit();

        # the next screen should be the edit screen for this ACL
        # which means that there should be dropdowns present for Match/Change settings
        $Self->Is(
            $Selenium->find_element( '.ItemAddLevel1', 'css' )->is_displayed(),
            '1',
            'Check if dropdown elements are present as expected',
        );

        # lets check for the correct values
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Selenium Test ACL',
            "#Comment stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Description', 'css' )->get_value(),
            'Selenium Test ACL',
            "#Description stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#StopAfterMatch', 'css' )->get_value(),
            '1',
            "#StopAfterMatch stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            '1',
            "#ValidID stored value",
        );

        # now lets play around with the match & change settings
        $Selenium->find_element( ".ItemAddLevel1 option[value='Properties']", 'css' )->click();

        # after clicking an ItemAddLevel1 element, there should be now a new .ItemAdd element
        $Self->Is(
            $Selenium->find_element( '#ACLMatch .ItemAdd', 'css' )->is_displayed(),
            '1',
            'Check for .ItemAdd element',
        );

        # now we should not be able to add the same element again, an alert box should appear
        $Selenium->execute_script($CheckAlertJS);
        $Selenium->find_element( ".ItemAddLevel1 option[value='Properties']", 'css' )->click();

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        $Self->Is(
            $Selenium->execute_script(
                "return window.getLastAlert()"
            ),
            $LanguageObject->Get('An item with this name is already present.'),
            'Check for opened alert text',
        );

        # now lets add the CustomerUser element on level 2
        $Selenium->find_element( "#ACLMatch .ItemAdd option[value='CustomerUser']", 'css' )->click();

        # now there should be a new .DataItem element with an input element
        $Self->Is(
            $Selenium->find_element( '#ACLMatch .DataItem .NewDataKey', 'css' )->is_displayed(),
            '1',
            'Check for .NewDataKey element',
        );

        # type in some text & confirm by pressing 'enter', which should produce a new field
        $Selenium->find_element( '#ACLMatch .DataItem .NewDataKey', 'css' )->send_keys('Test');
        $Selenium->find_element( '#ACLMatch .DataItem .NewDataKey', 'css' )->send_keys("\N{U+E007}");

        # now there should be a two new elements: .ItemPrefix and .NewDataItem
        $Self->Is(
            $Selenium->find_element( '#ACLMatch .DataItem .ItemPrefix', 'css' )->is_displayed(),
            '1',
            'Check for .ItemPrefix element',
        );
        $Self->Is(
            $Selenium->find_element( '#ACLMatch .DataItem .NewDataItem', 'css' )->is_displayed(),
            '1',
            'Check for .NewDataItem element',
        );

        # now lets add the DynamicField element on level 2, which should create a new dropdown
        # element containing dynamic fields and an 'Add all' button
        $Selenium->find_element( "#ACLMatch .ItemAdd option[value='DynamicField']", 'css' )->click();

        $Self->Is(
            $Selenium->find_element( '#ACLMatch .DataItem .NewDataKeyDropdown', 'css' )->is_displayed(),
            '1',
            'Check for .NewDataKeyDropdown element',
        );
        $Self->Is(
            $Selenium->find_element( ' #ACLMatch .DataItem .AddAll', 'css' )->is_displayed(),
            '1',
            'Check for .AddAll element',
        );

        # delete test ACL from the database
        my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $UserID    = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );
        my $ACLID = $ACLObject->ACLGet(
            Name   => $RandomID,
            UserID => $UserID,
        )->{ID};

        my $Success = $ACLObject->ACLDelete(
            ID     => $ACLID,
            UserID => $UserID,
        );

        $Self->True(
            $Success,
            "Deleted $RandomID ACL",
        );

        }
);

1;
