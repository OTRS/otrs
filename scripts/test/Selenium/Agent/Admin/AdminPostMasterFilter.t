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

use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $Language = 'de';

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminPostMasterFilter screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPostMasterFilter");

        # Check overview AdminPostMasterFilter.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Click 'Add filter'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminPostMasterFilter;Subaction=AddAction' )]")
            ->VerifiedClick();

        # Check client side validation.
        $Selenium->find_element( "#EditName", 'css' )->clear();
        $Selenium->find_element( "#EditName", 'css' )->VerifiedSubmit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#EditName').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Check add page.
        for my $ID (
            qw(EditName StopAfterMatch MatchHeaderExample MatchValueExample SetHeaderExample SetValueExample)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        my $HeaderFieldCount = $ConfigObject->Get('PostmasterHeaderFieldCount');
        if ($HeaderFieldCount) {
            for my $HeaderID ( 1 .. $HeaderFieldCount ) {
                for my $Header (
                    qw (MatchHeader MatchNot MatchValue SetHeader SetValue)
                    )
                {
                    my $Element = $Selenium->find_element( "#$Header$HeaderID", 'css' );
                    $Element->is_enabled();
                    $Element->is_displayed();
                }

                $HeaderID++;
            }
        }

        # Add first test PostMasterFilter.
        my $PostMasterName     = "postmasterfilter" . $Helper->GetRandomID();
        my $PostMasterBody     = "Selenium test for PostMasterFilter";
        my $PostMasterPriority = "2 low";

        $Selenium->find_element( "#EditName", 'css' )->send_keys($PostMasterName);
        $Selenium->execute_script("\$('#MatchHeader1').val('Body').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#MatchNot1",   'css' )->VerifiedClick();
        $Selenium->find_element( "#MatchValue1", 'css' )->send_keys($PostMasterBody);
        $Selenium->execute_script(
            "\$('#SetHeader1').val('X-OTRS-Priority').trigger('redraw.InputField').trigger('change');"
        );

        # Make sure that "Body" is disabled on other condition selects.
        my $BodyDisabled
            = $Selenium->execute_script("return \$('#MatchHeader2 option[Value=\"Body\"]').attr('disabled');");
        $Self->Is(
            $BodyDisabled,
            "disabled",
            "Body is disabled in #MatchHeader2."
        );

        # Make sure that "X-OTRS-Priority" is disabled on other selects.
        my $XOTRSPriorityDisabled
            = $Selenium->execute_script("return \$('#SetHeader2 option[Value=\"X-OTRS-Priority\"]').attr('disabled');");
        $Self->Is(
            $XOTRSPriorityDisabled,
            "disabled",
            "X-OTRS-Priority is disabled in #SetHeader2."
        );

        $Selenium->find_element( "#SetValue1", 'css' )->send_keys($PostMasterPriority);
        $Selenium->find_element( "#EditName",  'css' )->VerifiedSubmit();

        # Check for created first test PostMasterFilter on screen.
        $Self->True(
            index( $Selenium->get_page_source(), $PostMasterName ) > -1,
            "$PostMasterName PostMasterFilter found on page",
        );

        # Check new test PostMasterFilter values.
        $Selenium->find_element( $PostMasterName, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#EditName', 'css' )->get_value(),
            $PostMasterName,
            "#EditName stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#MatchHeader1', 'css' )->get_value(),
            "Body",
            "#MatchHeader1 stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#MatchNot1', 'css' )->is_selected(),
            1,
            "#MatchNot1 stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#MatchValue1', 'css' )->get_value(),
            $PostMasterBody,
            "#MatchValue1 stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#SetHeader1', 'css' )->get_value(),
            "X-OTRS-Priority",
            "#SetHeader1 stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#SetValue1', 'css' )->get_value(),
            $PostMasterPriority,
            "#SetValue1 stored value",
        );

        # Edit test PostMasterFilter.
        my $EditPostMasterPriority = "4 high";

        $Selenium->execute_script("\$('#StopAfterMatch').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#MatchNot1", 'css' )->VerifiedClick();
        $Selenium->find_element( "#SetValue1", 'css' )->clear();
        $Selenium->find_element( "#SetValue1", 'css' )->send_keys($EditPostMasterPriority);
        $Selenium->find_element( "#EditName",  'css' )->VerifiedSubmit();

        # Check edited test PostMasterFilter values.
        $Selenium->find_element( $PostMasterName, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#StopAfterMatch', 'css' )->get_value(),
            1,
            "#StopAfterMatch updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#MatchNot1', 'css' )->is_selected(),
            0,
            "#MatchNot1 updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#SetValue1', 'css' )->get_value(),
            $EditPostMasterPriority,
            "#SetValue1 updated value",
        );

        # Make sure that 0 can be stored in match and set as well (see http://bugs.otrs.org/show_bug.cgi?id=12218).
        $Selenium->find_element( "#MatchValue1", 'css' )->clear();
        $Selenium->find_element( "#MatchValue1", 'css' )->send_keys('0');
        $Selenium->find_element( "#SetValue1",   'css' )->clear();
        $Selenium->find_element( "#SetValue1",   'css' )->send_keys('0');
        $Selenium->find_element( "#EditName",    'css' )->VerifiedSubmit();

        # Check edited test PostMasterFilter values.
        $Selenium->find_element( $PostMasterName, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#MatchValue1', 'css' )->get_value(),
            0,
            "#SetValue1 updated value",
        );

        $Self->Is(
            $Selenium->find_element( '#SetValue1', 'css' )->get_value(),
            0,
            "#SetValue1 updated value",
        );

        # Go back to AdminPostMasterFilter screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPostMasterFilter");

        # Try to create PostMasterFilter with the same name, (see https://bugs.otrs.org/show_bug.cgi?id=12718).
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminPostMasterFilter;Subaction=AddAction' )]")
            ->VerifiedClick();

        $Selenium->find_element( "#EditName", 'css' )->send_keys($PostMasterName);
        $Selenium->execute_script("\$('#MatchHeader1').val('Body').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#MatchValue1", 'css' )->send_keys($PostMasterBody);
        $Selenium->execute_script(
            "\$('#SetHeader1').val('X-OTRS-Priority').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#SetValue1", 'css' )->send_keys($PostMasterPriority);
        $Selenium->find_element( "#EditName",  'css' )->VerifiedSubmit();

        # Confirm JS error.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();

        # Verify duplicated name error.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#EditName').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected duplicated name input value',
        );

        # Edit name to create second PostMasterFilter.
        my $PostMasterName2 = $PostMasterName . '2';
        $Selenium->find_element( "#EditName", 'css' )->clear();
        $Selenium->find_element( "#EditName", 'css' )->send_keys($PostMasterName2);
        $Selenium->find_element( "#EditName", 'css' )->VerifiedSubmit();

        # Verify second PostMasterFilter is created.
        $Self->True(
            index( $Selenium->get_page_source(), $PostMasterName2 ) > -1,
            "$PostMasterName2 second PostMasterFilter found on page",
        );

        # Click to edit second PostMasterFilter.
        $Selenium->find_element( $PostMasterName2, 'link_text' )->VerifiedClick();

        # Try to change name as first PostMasterFilter, verify duplication error.
        $Selenium->find_element( "#EditName", 'css' )->clear();
        $Selenium->find_element( "#EditName", 'css' )->send_keys($PostMasterName);
        $Selenium->find_element( "#EditName", 'css' )->VerifiedSubmit();

        # Confirm JS error.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();

        # Verify duplicated name error.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#EditName').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected duplicated name input value',
        );

        # Change name to something else, verify second PostMasterFilter will be first deleted
        # then created new one.
        my $PostMasterName3 = $PostMasterName . '3';
        $Selenium->find_element( "#EditName", 'css' )->clear();
        $Selenium->find_element( "#EditName", 'css' )->send_keys($PostMasterName3);
        $Selenium->find_element( "#EditName", 'css' )->VerifiedSubmit();

        $Self->True(
            index( $Selenium->get_page_source(), $PostMasterName2 ) == -1,
            "$PostMasterName2 original second PostMasterFilter is not found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $PostMasterName3 ) > -1,
            "$PostMasterName2 edited second PostMasterFilter found on page",
        );

        # Delete second PostMasterFilter.
        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=Delete;Name=$PostMasterName3' )]"
        )->click();

        # Accept delete confirmation dialog
        $Selenium->accept_alert();

        # Check if second PostMasterFilter is deleted.
        $Self->True(
            index( $Selenium->get_page_source(), $PostMasterName3 ) == -1,
            "Second PostMasterFilter '$PostMasterName3' is deleted"
        );

        # Delete first PostMasterFilter.
        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=Delete;Name=$PostMasterName' )]"
        )->click();

        # Accept delete confirmation dialog
        $Selenium->accept_alert();

        # Check if first postmaster filter is deleted.
        $Self->True(
            index( $Selenium->get_page_source(), $PostMasterName ) == -1,
            "First PostMasterFilter '$PostMasterName' is deleted"
        );
    }
);

1;
