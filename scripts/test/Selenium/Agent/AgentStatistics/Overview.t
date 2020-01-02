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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'stats' ],
        ) || die "Did not get test user";

        # update the number of max stats shown on one page
        my $Success = $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Stats::SearchPageShown',
            Value => 1000,
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Overview");

        # check layout screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check add button
        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentStatistics;Subaction=Add\' )]"),
            "There is add button",
        );

        # check import button
        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentStatistics;Subaction=Import\' )]"),
            "There is import button",
        );

        my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

        # get stats IDs
        my $StatsIDs = $StatsObject->GetStatsList(
            AccessRw => 1,
            UserID   => 1,
        );

        # open the default stats
        my $Counter = 0;
        STATS:
        for my $StatID ( @{$StatsIDs} ) {

            # check edit link
            $Self->True(
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentStatistics;Subaction=Edit;StatID=$StatID\' )]"
                ),
                "There is Edit link.",
            );

            # check export link
            $Self->True(
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentStatistics;Subaction=ExportAction;StatID=$StatID\' )]"
                ),
                "There is Export link.",
            );

            # check delete link
            $Self->True(
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentStatistics;Subaction=DeleteAction;StatID=$StatID\' )]"
                ),
                "There is Delete link.",
            );

            # check view link
            $Self->True(
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentStatistics;Subaction=View;StatID=$StatID\' )]"
                ),
                "There is View link.",
            );

            # go to view screen of statistics
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentStatistics;Subaction=View;StatID=$StatID\' )]")
                ->VerifiedClick();

            # check 'Go to overview' link on the view screen
            $Self->True(
                $Selenium->find_element( "Go to overview", 'link_text' ),
                "There is 'Go to overview' link.",
            );

            # check edit link on the view screen
            $Self->True(
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentStatistics;Subaction=Edit;StatID=$StatID\' )]"
                ),
                "There is Edit link.",
            );

            # check edit link on the view screen
            $Self->True(
                $Selenium->find_element("//button[\@value='Run now'][\@type='submit']"),
                "There is 'Run now' link.",
            );

            # go to overview screen
            $Selenium->find_element( "Cancel", 'link_text' )->VerifiedClick();

            last STATS if $Counter > 5;

            $Counter++;
        }

        # define the first statsID
        my $StatsIDFirst = $StatsIDs->[0];

        # go to Edit screen of the first statistics
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Edit;StatID=$StatsIDFirst");

        # get data for the first statistics
        my $StatsData = $StatsObject->StatsGet(
            StatID => $StatsIDFirst,
            UserID => 1,
        );
    }
);

1;
