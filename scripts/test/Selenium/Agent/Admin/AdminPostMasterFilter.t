# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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
        my $FirstBreadcrumbText  = $LanguageObject->Translate('You are here') . ':';
        my $SecondBreadcrumbText = $LanguageObject->Translate('PostMaster Filter Management');
        my $ThirdBreadcrumbText  = $LanguageObject->Translate('Add PostMaster Filter');
        my $Count                = 0;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText ( $FirstBreadcrumbText, $SecondBreadcrumbText, $ThirdBreadcrumbText ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $IsLinkedBreadcrumbText =
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').children('a').length");

            if ( $BreadcrumbText eq $SecondBreadcrumbText ) {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    1,
                    "Breadcrumb text '$BreadcrumbText' is linked"
                );
            }
            else {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    0,
                    "Breadcrumb text '$BreadcrumbText' is not linked"
                );
            }

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
        $Count               = 0;
        $ThirdBreadcrumbText = $LanguageObject->Translate('Edit PostMaster Filter') . ": $PostMasterName";
        for my $BreadcrumbText ( $FirstBreadcrumbText, $SecondBreadcrumbText, $ThirdBreadcrumbText ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $IsLinkedBreadcrumbText =
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').children('a').length");

            if ( $BreadcrumbText eq $SecondBreadcrumbText ) {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    1,
                    "Breadcrumb text '$BreadcrumbText' is linked"
                );
            }
            else {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    0,
                    "Breadcrumb text '$BreadcrumbText' is not linked"
                );
            }

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

        my $ConfirmJS = <<"JAVASCRIPT";
(function () {
    var lastConfirm = undefined;
    window.confirm = function (message) {
        lastConfirm = message;
        return false; // stop action at first try
    };
    window.getLastConfirm = function () {
        var result = lastConfirm;
        lastConfirm = undefined;
        return result;
    };
}());
JAVASCRIPT

        $Selenium->execute_script($ConfirmJS);
        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=Delete;Name=$PostMasterName' )]"
        )->VerifiedClick();

        $Self->Is(
            $Selenium->execute_script("return window.getLastConfirm()"),
            $LanguageObject->Translate('Do you really want to delete this filter?'),
            'Dialog window text is correct',
        );

        my $CheckConfirmJS = <<"JAVASCRIPT";
(function () {
    window.confirm = function () {
        return true; // allow action at second try
    };
}());
JAVASCRIPT

        $Selenium->execute_script($CheckConfirmJS);
        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=Delete;Name=$PostMasterName' )]"
        )->VerifiedClick();

        # navigate to AdminPostMasterFilter screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPostMasterFilter");

        # check up if postmaster filter is deleted
        $Self->Is(
            $Selenium->execute_script("return \$('#PostMasterFilters a.AsBlock[href*=$PostMasterName]').length"),
            0,
            "Postmaster Filter $PostMasterName is deleted",
        );

    }
);

1;
