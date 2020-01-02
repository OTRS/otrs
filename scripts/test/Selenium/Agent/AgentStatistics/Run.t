# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Show more stats per page as the default 50.
        my $Success = $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Stats::SearchPageShown',
            Value => 99,
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'stats' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Import");

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Import test selenium statistic.
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/Stats/Stats.TicketOverview.de.xml";
        $Selenium->find_element( "#File", 'css' )->send_keys($Location);
        $Selenium->find_element("//button[\@value='Import'][\@type='submit']")->VerifiedClick();

        # Create params for import test stats.
        my %StatsValues = (
            Title       => 'Überblick über alle Tickets im System',
            Object      => 'Ticket',
            Description => 'Aktueller Status aller im System befindlicher Tickets ohne Zeitbeschränkung.',
            Format      => 'D3::BarChart',
        );

        # Check for imported values on test stat.
        for my $StatsValue ( sort keys %StatsValues ) {
            $Self->True(
                index( $Selenium->get_page_source(), $StatsValues{$StatsValue} ) > -1,
                "Expected param $StatsValue for imported stat is founded - $StatsValues{$StatsValue}"
            );
        }

        # Navigate to AgentStatistics Overview screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Overview;"
        );

        my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

        # Get stats IDs.
        my $StatsIDs = $StatsObject->GetStatsList(
            AccessRw => 1,
            UserID   => 1,
        );

        my $Count       = scalar @{$StatsIDs};
        my $StatsIDLast = $StatsIDs->[ $Count - 1 ];

        # Check for imported stat on overview screen.
        $Self->True(
            index( $Selenium->get_page_source(), $StatsValues{Title} ) > -1,
            "Imported stat $StatsValues{Title} - found on overview screen"
        );

        # Go to imported stat to run it.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentStatistics;Subaction=View;StatID=$StatsIDLast\' )]")
            ->VerifiedClick();

        # Get stat data.
        my $StatData = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
            StatID => $StatsIDLast,
            UserID => 1,
        );

        # Run test statistic.
        $Selenium->find_element( "#StartStatistic", 'css' )->click();

        # Switch to another window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait for loading statistic data.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#download-svg").length' );

        $Self->True(
            index( $Selenium->get_page_source(), $StatsValues{Title} ) > -1,
            "Title of stats is found - $StatsValues{Title} "
        );

        # Close test statistic.
        $Selenium->close();
        $Selenium->switch_to_window( $Handles->[0] );
        $Selenium->WaitFor( WindowCount => 1 );

        # Navigate to AgentStatistics Overview screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Overview;"
        );

        # Delete test stats.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentStatistics;Subaction=DeleteAction;StatID=$StatsIDLast\' )]"
        )->click();

        $Selenium->WaitFor( AlertPresent => 1 );
        $Selenium->accept_alert();

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && !\$('a[href*=\"Action=AgentStatistics;Subaction=Edit;StatID=$StatsIDLast;\"]').length;"
        );

        $Self->True(
            $Selenium->execute_script(
                "return !\$('a[href*=\"Action=AgentStatistics;Subaction=Edit;StatID=$StatsIDLast;\"]').length;"
            ),
            "Test statistic is deleted - $StatsIDLast "
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "Stats" );

    }
);

1;
