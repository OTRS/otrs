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

our $ObjectManagerDisabled = 1;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # set generic agent run limit
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::GenericAgentRunLimit',
            Value => 10
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # create test tickets
        my $TestTicketTitle = 'TestTicketGenericAgent';
        my @TicketNumbers;
        for ( 1 .. 20 ) {

            # create Ticket to test AdminGenericAgent frontend
            my $TicketID = $TicketObject->TicketCreate(
                Title        => $TestTicketTitle,
                Queue        => 'Raw',
                Lock         => 'unlock',
                PriorityID   => 1,
                StateID      => 1,
                CustomerNo   => '123465',
                CustomerUser => 'customerUnitTest@example.com',
                OwnerID      => $UserID,
                UserID       => $UserID,
            );

            my $TicketNumber = $TicketObject->TicketNumberLookup(
                TicketID => $TicketID,
                UserID   => 1,
            );

            push @TicketNumbers, $TicketNumber;

        }

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminGenericAgent");
        my $RandomID = "GenericAgent" . $Helper->GetRandomID();

        # check overview AdminGenericAgent
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check add job page
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Update' )]")->click();

        my $Element = $Selenium->find_element( "#Profile", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();

        # Toggle widgets
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # create test job
        $Selenium->find_element( "#Profile", 'css' )->send_keys($RandomID);
        $Selenium->find_element( "#Title",   'css' )->send_keys($TestTicketTitle);
        $Selenium->find_element( "#Profile", 'css' )->submit();

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("i.fa-trash-o").length' );

        # check if test job show on AdminGenericAgent
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID job found on page",
        );

        # edit test job to delete test ticket
        $Selenium->find_element( $RandomID, 'link_text' )->click();

        # toggle Execute Ticket Commands widget
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".WidgetSimple.Collapsed").length' );
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');
        $Selenium->execute_script("\$('#NewDelete').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Profile", 'css' )->submit();

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("i.fa-trash-o").length' );

        # run test job
        $Selenium->execute_script("\$('a[href*=\"Subaction=Run;Profile=$RandomID\"]')[0].click();");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple .Content a.CallForAction[href*=Update]").length'
        );

        # check if test job show expected result
        for my $TicketNumber (@TicketNumbers) {

            $Self->True(
                index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                "$TicketNumber found on page",
            );

        }

        # check if there is warning message:
        # "Affected more tickets then how many will be executed on run job"
        $Self->True(
            $Selenium->execute_script(
                "return \$('p.Error:contains(tickets affected but only)').length"
            ),
            "RunLimit warning message shown",
        );

        # execute test job
        $Selenium->find_element("//a[contains(\@href, \'Subaction=RunNow' )]")->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple .Content a.CallForAction[href*=Update]").length'
        );

        # run test job again
        $Selenium->execute_script("\$('a[href*=\"Subaction=Run;Profile=$RandomID\"]')[0].click();");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple .Content a.CallForAction[href*=Update]").length'
        );

        # check if there is not warning message:
        # "Affected more tickets than how many will be executed on run job"
        $Self->False(
            $Selenium->execute_script(
                "return \$('p.Error:contains(tickets affected but only)').length"
            ),
            "There is no warning message",
        );

        # execute test job
        $Selenium->find_element("//a[contains(\@href, \'Subaction=RunNow' )]")->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("i.fa-trash-o").length' );

        # set test job to invalid
        $Selenium->find_element( $RandomID, 'link_text' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".WidgetSimple").length' );

        $Selenium->execute_script("\$('#Valid').val('0').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Profile", 'css' )->submit();

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("i.fa-trash-o").length' );

        # check class of invalid generic job in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td:contains($RandomID)').length"
            ),
            "There is a class 'Invalid' for test generic job",
        );

        # delete test job
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;Profile=$RandomID\' )]")->click();

    }

);

1;
