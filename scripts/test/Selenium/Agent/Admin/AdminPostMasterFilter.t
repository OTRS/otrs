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

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminPostMasterFilter");

        # check overview AdminPostMasterFilter
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click 'Add filter'
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminPostMasterFilter;Subaction=AddAction' )]")->click();

        # check client side validation
        $Selenium->find_element( "#EditName", 'css' )->clear();
        $Selenium->find_element( "#EditName", 'css' )->submit();
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

        # add test PostMasterFilter
        my $PostMasterRandomID = "postmasterfilter" . $Helper->GetRandomID();
        my $PostMasterBody     = "Selenium test for PostMasterFilter";
        my $PostMasterPriority = "2 low";

        $Selenium->find_element( "#EditName",                                   'css' )->send_keys($PostMasterRandomID);
        $Selenium->execute_script("\$('#MatchHeader1').val('Body').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#MatchNot1",                                  'css' )->click();
        $Selenium->find_element( "#MatchValue1",                                'css' )->send_keys($PostMasterBody);
        $Selenium->execute_script("\$('#SetHeader1').val('X-OTRS-Priority').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#SetValue1",                                  'css' )->send_keys($PostMasterPriority);
        $Selenium->find_element( "#EditName",                                   'css' )->submit();

        # check for created test PostMasterFilter on screen
        $Self->True(
            index( $Selenium->get_page_source(), $PostMasterRandomID ) > -1,
            "$PostMasterRandomID PostMasterFilter found on page",
        );

        # check new test PostMasterFilter values
        $Selenium->find_element( $PostMasterRandomID, 'link_text' )->click();
        $Self->Is(
            $Selenium->find_element( '#EditName', 'css' )->get_value(),
            $PostMasterRandomID,
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

        # edit test PostMasterFilter
        my $EditPostMasterPriority = "4 high";

        $Selenium->execute_script("\$('#StopAfterMatch').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#MatchNot1",                        'css' )->click();
        $Selenium->find_element( "#SetValue1",                        'css' )->clear();
        $Selenium->find_element( "#SetValue1",                        'css' )->send_keys($EditPostMasterPriority);
        $Selenium->find_element( "#EditName",                         'css' )->submit();

        # check edited test PostMasterFilter values
        $Selenium->find_element( $PostMasterRandomID, 'link_text' )->click();
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

        # go back to AdminPostMasterFilter screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminPostMasterFilter");

        # delete test PostMasterFilter with delete button
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;Name=$PostMasterRandomID' )]")->click();

    }

);

1;
