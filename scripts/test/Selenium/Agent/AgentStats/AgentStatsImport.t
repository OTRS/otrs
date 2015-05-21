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
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Selenium' => {
        Verbose => 1,
        }
);
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 0,
                }
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sys config object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # do not check service and type
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

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
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentStats;Subaction=Import");

        # import test selenium statistic
        my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . "/scripts/test/sample/Stats/Stats.TicketOverview.de.xml";
        $Selenium->find_element( "#file_upload", 'css' )->send_keys($Location);
        $Selenium->find_element("//button[\@value='Import'][\@type='submit']")->click();

        # wait until test stats is imported, if neccessary
        ACTIVESLEEP:
        for my $Second ( 1 .. 20 ) {
            if ( $Selenium->execute_script("return \$('#compose').length") ) {
                last ACTIVESLEEP;
            }
            sleep 1;
        }

        # create params for import test stats
        my %StatsValues =
            (
            Title       => 'Überblick über alle Tickets im System',
            Object      => 'TicketAccumulation',
            Description => 'Aktueller Status aller im System befindlicher Tickets ohne',
            Format      => 'Print',
            XAxis       => 'State',
            ValueSeries => 'Queue',
            Restriction => 'No element selected.',
            );

        # check for imported values on test stats
        for my $StatsValue ( sort keys %StatsValues ) {
            $Self->True(
                index( $Selenium->get_page_source(), $StatsValues{$StatsValue} ) > -1,
                "Expexted param $StatsValue for imported stats is founded - $StatsValues{$StatsValue}"
            );
        }

        # navigate to AgentStats Overview screen with descending order
        $Selenium->get(
            "${ScriptAlias}index.pl?Action=AgentStats;Subaction=Overview;Direction=DESC;OrderBy=ID;StartHit=1"
        );

        # get stats object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::Stats' => {
                UserID => 1,
                }
        );
        my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

        # get stats IDs
        my $StatsIDs = $StatsObject->GetStatsList(
            AccessRw => 1,
        );

        my $Count       = scalar @{$StatsIDs};
        my $StatsIDLast = $StatsIDs->[ $Count - 1 ];

        # check for imported stats on overview screen
        $Self->True(
            index( $Selenium->get_page_source(), $StatsValues{Title} ) > -1,
            "Imported stat $StatsValues{Title} - found on overview screen"
        );

        # click on imported stats to edit it
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentStats;Subaction=View;StatID=$StatsIDLast\' )]")
            ->click();
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentStats;Subaction=EditSpecification;StatID=$StatsIDLast\' )]"
        )->click();

        # Step 1
        my $EditStatTitle = "Edited Imported Stats " . $Helper->GetRandomID();
        $Selenium->find_element( "#Title", 'css' )->clear();
        $Selenium->find_element( "#Title", 'css' )->send_keys($EditStatTitle);
        $Selenium->find_element("//button[\@value='Next...'][\@type='submit']")->click();

        # Step 2
        $Selenium->find_element("//input[\@value='StateTypeIDs']")->click();
        $Selenium->find_element( "#FixedStateTypeIDs", 'css' )->click();
        $Selenium->find_element("//button[\@value='Next...'][\@type='submit']")->click();

        # Step 3
        $Selenium->find_element("//input[\@name='SelectQueueIDs']")->click();
        $Selenium->find_element("//input[\@name='SelectPriorityIDs']")->click();
        $Selenium->find_element( "#FixedPriorityIDs", 'css' )->click();
        $Selenium->find_element("//button[\@value='Next...'][\@type='submit']")->click();

        # Step 4
        $Selenium->find_element("//input[\@name='SelectLockIDs']")->click();
        $Selenium->find_element( "#FixedLockIDs", 'css' )->click();
        $Selenium->find_element("//button[\@value='Finish'][\@type='submit']")->click();

        # verify edited values
        $Self->True(
            index( $Selenium->get_page_source(), $EditStatTitle ) > -1,
            "Edited imported stat title - found on overview screen"
        );

        for my $EditedStatsValues (
            qw(UseAsXvalueStateTypeIDs UseAsValueSeriesPriorityIDs UseAsRestrictionLockIDs)
            )
        {
            my $Element = $Selenium->find_element( "#$EditedStatsValues", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # delete edited imported test stats
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete\' )]")->click();
        $Selenium->find_element("//button[\@value='Yes'][\@type='submit']")->click();

        # wait until test stats is deleted, if neccessary
        ACTIVESLEEP:
        for my $Second ( 1 .. 20 ) {
            if ( $Selenium->execute_script("return \$('.ContentColumn').length") ) {
                last ACTIVESLEEP;
            }
            sleep 1;
        }

        # check if stats is deleted
        $Self->True(
            index( $Selenium->get_page_source(), $EditStatTitle ) == -1,
            "$EditStatTitle is deleted"
        );
        }
);

1;
