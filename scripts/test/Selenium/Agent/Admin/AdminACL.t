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

use Selenium::Remote::WDKeys;
use Kernel::Language;

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # defined user language for testing if message is being translated correctly
        my $Language = "de";

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => ['admin'],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminACL screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click 'Create new ACL' link
        $Selenium->find_element( "a.Create", 'css' )->VerifiedClick();

        # check add page
        for my $ID (
            qw(Name Comment Description StopAfterMatch ValidID)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check breadcrumb on Create New screen
        my $Count = 1;
        my $IsLinkedBreadcrumbText;
        my $SecondBreadcrumbText = $LanguageObject->Translate('ACL Management');
        my $ThirdBreadcrumbText  = $LanguageObject->Translate('Create New ACL');
        for my $BreadcrumbText ( $SecondBreadcrumbText, $ThirdBreadcrumbText ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # check client side validation
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->send_keys("");
        $Element->VerifiedSubmit();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        my @TestACLNames;

        # create test ACL names
        for my $Name (qw(ACL NewACL)) {
            my $TestACLName = $Name . $Helper->GetRandomNumber() . ' $ @';
            push @TestACLNames, $TestACLName;
        }

        # fill in test data
        $Selenium->find_element( "#Name",           'css' )->send_keys( $TestACLNames[0] );
        $Selenium->find_element( "#Comment",        'css' )->send_keys('Selenium Test ACL');
        $Selenium->find_element( "#Description",    'css' )->send_keys('Selenium Test ACL');
        $Selenium->find_element( "#StopAfterMatch", 'css' )->VerifiedClick();
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name", 'css' )->VerifiedSubmit();

        # check breadcrumb on Edit screen
        $Count = 1;
        for my $BreadcrumbText ( $SecondBreadcrumbText, 'Edit ACL: ' . $TestACLNames[0] ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

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
            $TestACLNames[0],
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
        $Selenium->execute_script(
            "\$('.ItemAddLevel1').val('Properties').trigger('redraw.InputField').trigger('change');"
        );

        # after clicking an ItemAddLevel1 element, there should be now a new .ItemAdd element
        $Self->Is(
            $Selenium->find_element( '#ACLMatch .ItemAdd', 'css' )->is_displayed(),
            '1',
            'Check for .ItemAdd element',
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

        $Selenium->execute_script($CheckAlertJS);

        # now we should not be able to add the same element again, an alert box should appear
        $Selenium->execute_script(
            "\$('.ItemAddLevel1').val('Properties').trigger('redraw.InputField').trigger('change');"
        );

        $Self->Is(
            $Selenium->execute_script("return window.getLastAlert()"),
            $LanguageObject->Translate('An item with this name is already present.'),
            'Check for opened alert text',
        );

        # now lets add the CustomerUser element on level 2
        $Selenium->find_element( "#ACLMatch .ItemAdd option[value='CustomerUser']", 'css' )->VerifiedClick();

        # now there should be a new .DataItem element with an input element
        $Self->Is(
            $Selenium->find_element( '#ACLMatch .DataItem .NewDataKey', 'css' )->is_displayed(),
            '1',
            'Check for .NewDataKey element',
        );

        # type in some text & confirm by pressing 'enter', which should produce a new field
        $Selenium->find_element( '#ACLMatch .DataItem .NewDataKey', 'css' )->send_keys( '<Test>', "\N{U+E007}" );

        # check if the text was escaped correctly
        $Self->Is(
            $Selenium->execute_script("return \$('.DataItem .DataItem.Editable').data('content');"),
            '<Test>',
            'Check for correctly unescaped item content',
        );
        $Self->Is(
            $Selenium->execute_script("return \$('.DataItem .DataItem.Editable').find('span:not(.Icon)').html();"),
            '&lt;Test&gt;',
            'Check for correctly escaped item text',
        );

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
        $Selenium->find_element( "#ACLMatch .ItemAdd option[value='DynamicField']", 'css' )->VerifiedClick();

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

        # set ACL to invalid
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change')");
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # navigate to 'Create new ACL' screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLNew");

        # add new ACL
        $Selenium->execute_script("\$('#Name').val('$TestACLNames[1]')");
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change')");
        $Selenium->find_element( '#Name', 'css' )->send_keys("\N{U+E007}");

        # wait until the new for has been loaded and the "normal" Save button shows up
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SubmitAndContinue').length" );

        # click 'Save and Finish'
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # check if both ACL exist in the table
        $Self->IsNot(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($TestACLNames[0])').parent().parent().css('display')"
            ),
            'none',
            "ACL $TestACLNames[0] is found",
        );
        $Self->IsNot(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($TestACLNames[1])').parent().parent().css('display')"
            ),
            'none',
            "ACL $TestACLNames[1] is found",
        );

        # insert name of second ACL into filter field
        $Selenium->find_element( "#FilterACLs", 'css' )->clear();
        $Selenium->find_element( "#FilterACLs", 'css' )->send_keys( $TestACLNames[1] );

        sleep 1;

        # check if the first ACL does not exist and second does in the table
        $Self->Is(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($TestACLNames[0])').parent().parent().css('display')"
            ),
            'none',
            "ACL $TestACLNames[0] is not found",
        );
        $Self->IsNot(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($TestACLNames[1])').parent().parent().css('display')"
            ),
            'none',
            "ACL $TestACLNames[1] is found",
        );

        # delete test ACLs from the database
        my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $UserID    = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        for my $TestACLName (@TestACLNames) {

            my $ACLID = $ACLObject->ACLGet(
                Name   => $TestACLName,
                UserID => $UserID,
            )->{ID};

            my $Success = $ACLObject->ACLDelete(
                ID     => $ACLID,
                UserID => $UserID,
            );
            $Self->True(
                $Success,
                "ACL $TestACLName is deleted",
            );
        }

        # sync ACL information from database with the system configuration
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy' )]")->VerifiedClick();

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'ACLEditor_ACL',
        );
    }
);

1;
