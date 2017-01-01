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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $Language = 'de';

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Language => $Language,
            Groups   => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get needed objects
        my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AdminPostMasterFilter screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPostMasterFilter");

        # check overview AdminPostMasterFilter
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click 'Add filter'
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminPostMasterFilter;Subaction=AddAction' )]")
            ->VerifiedClick();

        # check client side validation
        $Selenium->find_element( "#EditName", 'css' )->clear();
        $Selenium->find_element( "#EditName", 'css' )->VerifiedSubmit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#EditName').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # check add page
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

        # check breadcrumb on Add screen
        my $SecondBreadcrumbText = $LanguageObject->Translate('PostMaster Filter Management');
        my $ThirdBreadcrumbText  = $LanguageObject->Translate('Add PostMaster Filter');
        my $Count                = 1;
        for my $BreadcrumbText ( $SecondBreadcrumbText, $ThirdBreadcrumbText ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # add test PostMasterFilter
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

        # make sure that "Body" is disabled on other condition selects
        my $BodyDisabled
            = $Selenium->execute_script("return \$('#MatchHeader2 option[Value=\"Body\"]').attr('disabled');");
        $Self->Is(
            $BodyDisabled,
            "disabled",
            "Body is disabled in #MatchHeader2."
        );

        # make sure that "X-OTRS-Priority" is disabled on other selects
        my $XOTRSPriorityDisabled
            = $Selenium->execute_script("return \$('#SetHeader2 option[Value=\"X-OTRS-Priority\"]').attr('disabled');");
        $Self->Is(
            $XOTRSPriorityDisabled,
            "disabled",
            "X-OTRS-Priority is disabled in #SetHeader2."
        );

        $Selenium->find_element( "#SetValue1", 'css' )->send_keys($PostMasterPriority);
        $Selenium->find_element( "#EditName",  'css' )->VerifiedSubmit();

        # check for created test PostMasterFilter on screen
        $Self->True(
            index( $Selenium->get_page_source(), $PostMasterName ) > -1,
            "$PostMasterName PostMasterFilter found on page",
        );

        # check new test PostMasterFilter values
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

        # check breadcrumb on Edit screen
        $Count               = 1;
        $ThirdBreadcrumbText = $LanguageObject->Translate('Edit PostMaster Filter') . ": $PostMasterName";
        for my $BreadcrumbText ( $SecondBreadcrumbText, $ThirdBreadcrumbText ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # edit test PostMasterFilter
        my $EditPostMasterPriority = "4 high";

        $Selenium->execute_script("\$('#StopAfterMatch').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#MatchNot1", 'css' )->VerifiedClick();
        $Selenium->find_element( "#SetValue1", 'css' )->clear();
        $Selenium->find_element( "#SetValue1", 'css' )->send_keys($EditPostMasterPriority);
        $Selenium->find_element( "#EditName",  'css' )->VerifiedSubmit();

        # check edited test PostMasterFilter values
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

        # Make sure that 0 can be stored in match and set as well (see http://bugs.otrs.org/show_bug.cgi?id=12218)
        $Selenium->find_element( "#MatchValue1", 'css' )->clear();
        $Selenium->find_element( "#MatchValue1", 'css' )->send_keys('0');
        $Selenium->find_element( "#SetValue1",   'css' )->clear();
        $Selenium->find_element( "#SetValue1",   'css' )->send_keys('0');
        $Selenium->find_element( "#EditName",    'css' )->VerifiedSubmit();

        # check edited test PostMasterFilter values
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

        # go back to AdminPostMasterFilter screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPostMasterFilter");

        # click on delete button
        $Selenium->find_element(
            "//a[contains(\@data-query-string, \'Subaction=Delete;Name=$PostMasterName' )]"
        )->click();

        # wait for dialog appears
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;' );

        # verify delete dialog message
        my $DeleteMessage = "Do you really want to delete this postmaster filter?";
        $Self->True(
            index( $Selenium->get_page_source(), $DeleteMessage ) > -1,
            "Delete message is found",
        );

        # confirm delete action
        $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

        # wait for the dialog to disappear and than check that the new page is loaded completely
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;' );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#PostMasterFilters").length > 0;' );

        # check if postmaster filter sits on overview page
        $Self->True(
            index( $Selenium->get_page_source(), $PostMasterName ) == -1,
            "PostMasterFilter '$PostMasterName' is deleted"
        );

    }
);

1;
