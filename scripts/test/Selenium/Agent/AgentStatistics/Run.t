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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'stats' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Import");

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # import test selenium statistic
        my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . "/scripts/test/sample/Stats/Stats.TicketOverview.de.xml";
        $Selenium->find_element( "#File", 'css' )->send_keys($Location);
        $Selenium->find_element("//button[\@value='Import'][\@type='submit']")->click();

        # create params for import test stats
        my %StatsValues = (
            Title       => 'Überblick über alle Tickets im System',
            Object      => 'Ticket',
            Description => 'Aktueller Status aller im System befindlicher Tickets ohne Zeitbeschränkung.',
            Format      => 'D3::BarChart',
        );

        # check for imported values on test stat
        for my $StatsValue ( sort keys %StatsValues ) {
            $Self->True(
                index( $Selenium->get_page_source(), $StatsValues{$StatsValue} ) > -1,
                "Expexted param $StatsValue for imported stat is founded - $StatsValues{$StatsValue}"
            );
        }

        # navigate to AgentStatistics Overview screen
        $Selenium->get(
            "${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Overview;"
        );

        my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

        # get stats IDs
        my $StatsIDs = $StatsObject->GetStatsList(
            AccessRw => 1,
            UserID   => 1,
        );

        my $Count       = scalar @{$StatsIDs};
        my $StatsIDLast = $StatsIDs->[ $Count - 1 ];

        # check for imported stat on overview screen
        $Self->True(
            index( $Selenium->get_page_source(), $StatsValues{Title} ) > -1,
            "Imported stat $StatsValues{Title} - found on overview screen"
        );

        # go to imported stat to run it
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentStatistics;Subaction=View;StatID=$StatsIDLast\' )]")
            ->click();

        # run test statistic
        $Selenium->find_element( "#StartStatistic", 'css' )->click();
        $Selenium->WaitFor( WindowCount => 2 );

        # switch to another window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Self->True(
            index( $Selenium->get_page_source(), $StatsValues{Title} ) > -1,
            "Title of stats is found - $StatsValues{Title} "
        );

        # run test statistic
        $Selenium->close();
        $Selenium->switch_to_window( $Handles->[0] );
        $Selenium->WaitFor( WindowCount => 1 );

        # navigate to AgentStatistics Overview screen
        $Selenium->get(
            "${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Overview;"
        );

        my $CheckConfirmJS = <<"JAVASCRIPT";
(function () {
    var lastConfirm = undefined;
    window.confirm = function (message) {
        lastConfirm = message;
        return true;
    };
}());
JAVASCRIPT

        $Selenium->execute_script($CheckConfirmJS);

        # delete test stats
        # click on delete icon
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentStatistics;Subaction=DeleteAction;StatID=$StatsIDLast\' )]"
        )->click();

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;' );

        $Self->True(
            index( $Selenium->get_page_source(), "Action=AgentStatistics;Subaction=Edit;StatID=$StatsIDLast" ) == -1,
            "Test statistic is deleted - $StatsIDLast "
        );

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "Stats" );

    }
);

1;
