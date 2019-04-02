# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Selenium::Remote::WDKeys;
use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

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

        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('#Name.Error').length" );

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

        # Test for Bug#14411, 300 is more than the allowed by the filed (200), exceeding characters
        #   are just not typed.
        my $Description = 'a' x 300;

        # fill in test data
        $Selenium->find_element( "#Name",           'css' )->send_keys( $TestACLNames[0] );
        $Selenium->find_element( "#Comment",        'css' )->send_keys('Selenium Test ACL');
        $Selenium->find_element( "#Description",    'css' )->send_keys($Description);
        $Selenium->find_element( "#StopAfterMatch", 'css' )->click();
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 1,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # check breadcrumb on Edit screen
        $Count = 1;
        for my $BreadcrumbText (
            $SecondBreadcrumbText,
            $LanguageObject->Translate('Edit ACL') . ': ' . $TestACLNames[0]
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # the next screen should be the edit screen for this ACL
        # which means that there should be modernize fields present for Match/Change settings
        $Self->Is(
            $Selenium->find_element( '#ItemAddLevel1Match_Search', 'css' )->is_displayed(),
            '1',
            'Check if modernize Match element is present as expected',
        );
        $Self->Is(
            $Selenium->find_element( '#ItemAddLevel1Change_Search', 'css' )->is_displayed(),
            '1',
            'Check if modernize Change element is present as expected',
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

        # Test for Bug#14411 (only 200 out of 300 characters should be stored).
        my $StoredDescription = 'a' x 200;
        $Self->Is(
            $Selenium->find_element( '#Description', 'css' )->get_value(),
            $StoredDescription,
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
            "\$('#ACLMatch').siblings('.ItemAddLevel1').val('Properties').trigger('redraw.InputField').trigger('change');"
        );

        # Wait until selection tree is closed.
        $Selenium->WaitFor(
            ElementMissing => [ '.InputField_ListContainer', 'css' ],
        );

        # after clicking an ItemAddLevel1 element, there should be now a new .ItemAdd element
        $Self->Is(
            $Selenium->find_element( '#ACLMatch #Properties_Search', 'css' )->is_displayed(),
            '1',
            'Check for .ItemAdd element - modernize element #Properties_Search is visible',
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
            "\$('#ACLMatch').siblings('.ItemAddLevel1').val('Properties').trigger('redraw.InputField').trigger('change');"
        );

        # Wait until selection tree is closed.
        $Selenium->WaitFor(
            ElementMissing => [ '.InputField_ListContainer', 'css' ],
        );

        $Self->Is(
            $Selenium->execute_script("return window.getLastAlert()"),
            $LanguageObject->Translate('An item with this name is already present.'),
            'Check for opened alert text',
        );

        # now lets add the CustomerUser element on level 2
        $Selenium->InputFieldValueSet(
            Element => '#ACLMatch .ItemAdd',
            Value   => 'CustomerUser',
        );

        # now there should be a new .DataItem element with an input element
        $Self->Is(
            $Selenium->find_element( '#ACLMatch .DataItem .NewDataKey', 'css' )->is_displayed(),
            '1',
            'Check for .NewDataKey element',
        );

        # type in some text & confirm by pressing 'enter', which should produce a new field
        $Selenium->find_element( '#ACLMatch .DataItem .NewDataKey', 'css' )->send_keys("<Test>\N{U+E007}");

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

        # now lets add the DynamicField element on level 2, which should create a new modernize
        # element containing dynamic fields and an 'Add all' button
        $Selenium->InputFieldValueSet(
            Element => '#ACLMatch .ItemAdd',
            Value   => 'DynamicField',
        );

        # Wait until element is shown.
        $Selenium->WaitFor(
            JavaScript => "return \$('#ACLMatch .DataItem .NewDataKeyDropdown').length;"
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#ACLMatch .DataItem .NewDataKeyDropdown').length;"),
            '1',
            'Check for .NewDataKeyDropdown element',
        );

        # Wait until element is shown.
        $Selenium->WaitFor(
            JavaScript => "return \$('#ACLMatch .DataItem .AddAll').length;"
        );
        $Self->Is(
            $Selenium->find_element( '#ACLMatch .DataItem .AddAll', 'css' )->is_displayed(),
            '1',
            'Check for .AddAll element',
        );

        # Add all possible prefix values to check for inputed values see bug#12854
        # ( https://bugs.otrs.org/show_bug.cgi?id=12854 ).
        $Count = 1;
        for my $Prefix ( '[Not]', '[RegExp]', '[regexp]', '[NotRegExp]', '[Notregexp]' ) {
            $Selenium->find_element( "#Prefixes option[Value='$Prefix']", 'css' )->click();
            $Selenium->find_element( ".NewDataItem",                      'css' )->send_keys('Test');
            $Selenium->find_element( ".AddDataItem",                      'css' )->click();
            $Self->Is(
                $Selenium->execute_script("return \$('ul li.Editable:eq($Count) span').text();"),
                $Prefix . 'Test',
                "Value with prefix $Prefix is correct"
            );
            $Selenium->find_element( ".AddDataItem", 'css' )->click();
            $Count++;
        }

        # set ACL to invalid
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # navigate to 'Create new ACL' screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLNew");

        # add new ACL
        $Selenium->execute_script("\$('#Name').val('$TestACLNames[1]')");
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( '#Name', 'css' )->send_keys("\N{U+E007}");

        # wait until the new for has been loaded and the "normal" Save button shows up
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SubmitAndContinue').length" );
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

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

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Create copy of the first ACL.
        my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $ACLID     = $ACLObject->ACLGet(
            Name   => $TestACLNames[0],
            UserID => 1,
        )->{ID};
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLCopy;ID=$ACLID;' )]")
            ->VerifiedClick();

        # Create another copy of the same ACL, see bug#13204 (https://bugs.otrs.org/show_bug.cgi?id=13204).
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLCopy;ID=$ACLID;' )]")
            ->VerifiedClick();

        # Verify there are both copied ACL's.
        push @TestACLNames,
            $LanguageObject->Translate( '%s (Copy) %s', $TestACLNames[0], 1 ),
            $LanguageObject->Translate( '%s (Copy) %s', $TestACLNames[0], 2 );

        $Self->True(
            index( $Selenium->get_page_source(), $TestACLNames[2] ) > -1,
            "First copied ACL '$TestACLNames[2]' found on screen",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $TestACLNames[3] ) > -1,
            "Second copied ACL '$TestACLNames[3]' found on screen",
        );

        # delete test ACLs from the database
        for my $TestACLName (@TestACLNames) {

            $ACLID = $ACLObject->ACLGet(
                Name   => $TestACLName,
                UserID => 1,
            )->{ID};

            my $Success = $ACLObject->ACLDelete(
                ID     => $ACLID,
                UserID => 1,
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
