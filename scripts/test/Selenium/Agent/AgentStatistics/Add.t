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
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
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

        # add Service and SLA test data
        my $Config = {

            # service data
            Services => [
                { Name => "TestService - " . $Helper->GetRandomID() },
                { Name => "TestService - " . $Helper->GetRandomID() },
            ],

            # SLA data
            SLAs => [
                {
                    Name => "TestSLA - " . $Helper->GetRandomID(),
                },
                {
                    Name => "TestSLA - " . $Helper->GetRandomID(),
                },
            ],
        };

        my $Success = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        # get service object
        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
        my @ServiceIDs;

        # get SLA object
        my $SLAObject = $Kernel::OM->Get('Kernel::System::SLA');
        my @SLAIDs;

        for ( 1 .. 5 ) {

            # add test Services
            my $ServiceID = $ServiceObject->ServiceAdd(
                Name    => "TestService - " . $Helper->GetRandomID(),
                ValidID => 1,
                UserID  => 1,
            );

            $Self->True(
                $ServiceID,
                "Service $ServiceID has been created."
            );

            # add service as defalut service for all customers
            $ServiceObject->CustomerUserServiceMemberAdd(
                CustomerUserLogin => '<DEFAULT>',
                ServiceID         => $ServiceID,
                Active            => 1,
                UserID            => 1,
            );

            push @ServiceIDs, $ServiceID;

            # add test SLAs
            my $SLAID = $SLAObject->SLAAdd(
                Name    => "TestSLA - " . $Helper->GetRandomID(),
                ValidID => 1,
                UserID  => 1,
            );

            $Self->True(
                $SLAID,
                "SLA $SLAID has been created."
            );

            push @SLAIDs, $SLAID;

        }

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # check add statsistics screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Add");

        # check link 'DynamicMatrix'
        $Self->True(
            $Selenium->find_element("//a[contains(\@data-statistic-preselection, \'DynamicMatrix\' )]"),
            "There is a link for adding 'DynamicMatrix' statistics",
        );

        # check link 'DynamicList'
        $Self->True(
            $Selenium->find_element("//a[contains(\@data-statistic-preselection, \'DynamicList\' )]"),
            "There is a link for adding 'DynamicList' statistics",
        );

        # check link 'Static'
        $Self->True(
            $Selenium->find_element("//a[contains(\@data-statistic-preselection, \'Static\' )]"),
            "There is a link for adding 'Static' statistics",
        );

        # check "Go to overview" button
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentStatistics;Subaction=Overview\' )]")->click();

        my @Tests = (
            {
                Title            => 'Statistic DynamicMatrix' . $Helper->GetRandomID(),
                Object           => 'Kernel::System::Stats::Dynamic::Ticket',
                Type             => 'DynamicMatrix',
                XAxis            => 'XAxisServiceIDs',
                YAxis            => 'YAxisSLAIDs',
                RestrictionID    => 'RestrictionsQueueIDs',
                Restrictionvalue => 3,
            },
            {
                Title            => 'Statistic - TicketAccountedTime' . $Helper->GetRandomID(),
                Object           => 'Kernel::System::Stats::Dynamic::TicketAccountedTime',
                Type             => 'DynamicList',
                XAxis            => 'XAxisServiceIDs',
                YAxis            => 'YAxisSLAIDs',
                RestrictionID    => 'RestrictionsKindsOfReporting',
                Restrictionvalue => 'TotalTime',
            },
            {
                Title            => 'Statistic - TicketSolutionResponseTime' . $Helper->GetRandomID(),
                Object           => 'Kernel::System::Stats::Dynamic::TicketSolutionResponseTime',
                Type             => 'DynamicList',
                XAxis            => 'XAxisServiceIDs',
                YAxis            => 'YAxisSLAIDs',
                RestrictionID    => 'RestrictionsKindsOfReporting',
                Restrictionvalue => 'SolutionAverageAllOver',
            },
            {
                Title            => 'Statistic - TicketList' . $Helper->GetRandomID(),
                Object           => 'Kernel::System::Stats::Dynamic::TicketList',
                Type             => 'DynamicList',
                YAxis            => 'YAxisOrderBy',
                OrderBy          => 'TicketNumber',
                RestrictionID    => 'RestrictionsServiceIDs',
                Restrictionvalue => $ServiceIDs[0],
            },

        );

        my @StatsFormat = (
            {
                Format         => 'Print',
                PreviewContent => 'PreviewContentPrint',
            },
            {
                Format         => 'D3::StackedAreaChart',
                PreviewContent => 'PreviewContentD3StackedAreaChart',

            },
            {
                Format         => 'D3::LineChart',
                PreviewContent => 'PreviewContentD3LineChart',
            },
            {
                Format         => 'D3::BarChart',
                PreviewContent => 'PreviewContentD3BarChart',
            },

        );

        # add new statistics
        for my $StatsData (@Tests) {

            # go to add statsistics screen
            $Selenium->get("${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Add");

            #$Selenium->find_element("//a[contains(\@href, \'Action=AgentStatistics;Subaction=Add\' )]")->click();

            # add new statistics
            $Selenium->find_element("//a[contains(\@data-statistic-preselection, \'$StatsData->{Type}\' )]")->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Title").length' );

            my $Description = 'Description ' . $StatsData->{Title};

            # set velues for new statistics - General Specifications
            $Selenium->find_element( "#Title",       'css' )->send_keys( $StatsData->{Title} );
            $Selenium->find_element( "#Description", 'css' )->send_keys($Description);
            $Selenium->execute_script(
                "\$('#ObjectModule').val('$StatsData->{Object}').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->click();

            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".EditXAxis").length' );

            # check X-axis configuration dialog
            $Selenium->find_element( ".EditXAxis", 'css' )->click();
            if ( $StatsData->{Object} ne 'Kernel::System::Stats::Dynamic::TicketList' ) {
                $Selenium->execute_script(
                    "\$('#EditDialog select').val('$StatsData->{XAxis}').trigger('redraw.InputField').trigger('change');"
                );
            }
            $Selenium->find_element( "#DialogButton1", 'css' )->click();

            # check Y-axis configuration dialog
            $Selenium->find_element( ".EditYAxis", 'css' )->click();
            $Selenium->execute_script(
                "\$('#EditDialog select').val('$StatsData->{YAxis}').trigger('redraw.InputField').trigger('change');");

            if ( $StatsData->{Object} eq 'Kernel::System::Stats::Dynamic::TicketList' ) {

                # wait for load selected Restriction
                $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$StatsData->{YAxis}').length;" );

                # select order by option
                $Selenium->execute_script(
                    "\$('#EditDialog #$StatsData->{YAxis}').val('$StatsData->{OrderBy}').trigger('redraw.InputField').trigger('change');"
                );
            }
            $Selenium->find_element( "#DialogButton1", 'css' )->click();

            # check Restrictions configuration dialog
            $Selenium->find_element( ".EditRestrictions", 'css' )->click();
            $Selenium->execute_script(
                "\$('#EditDialog select').val('$StatsData->{RestrictionID}').trigger('redraw.InputField').trigger('change');"
            );

            # wait for load selected Restriction
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$StatsData->{RestrictionID}').length;" );

            # add restriction
            $Selenium->execute_script(
                "\$('#EditDialog #$StatsData->{RestrictionID}').val('$StatsData->{RestrictionValue}').trigger('redraw.InputField').trigger('change');"
            );
            $Selenium->find_element( "#DialogButton1", 'css' )->click();

            # change preview format to Print
            $Selenium->find_element("//button[contains(\@data-format, \'Print')]")->click();
            $Self->True(
                $Selenium->execute_script("return \$('#PreviewContentPrint').css('display')") eq 'block',
                "Print format is displayed",
            );

            for my $StatsFormat (@StatsFormat) {

                # change preview format
                $Selenium->find_element("//button[contains(\@data-format, \'$StatsFormat->{Format}')]")->click();
                $Self->True(
                    $Selenium->execute_script("return \$('#$StatsFormat->{PreviewContent}').css('display')") eq 'block',
                    "StackedArea format is displayed",
                );
            }

            # save and finish test statistics
            $Selenium->find_element("//button[\@name='SaveAndFinish'][\@type='submit']")->click();

            my $CheckConfirmJS = <<"JAVASCRIPT";
(function () {
    var lastConfirm = undefined;
    window.confirm = function (message) {
        lastConfirm = message;
        return true;
    };
}());
JAVASCRIPT

            # sort decreasing by StatsID
            $Selenium->get(
                "${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Overview;Direction=DESC;OrderBy=ID;StartHit=1\' )]"
            );

            my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

            # get stats IDs
            my $StatsIDs = $StatsObject->GetStatsList(
                AccessRw => 1,
                UserID   => 1,
            );

            my $Count       = scalar @{$StatsIDs};
            my $StatsIDLast = $StatsIDs->[ $Count - 1 ];

            # check for created stats on overview screen
            $Self->True(
                index( $Selenium->get_page_source(), $StatsData->{Title} ) > -1,
                "Test statistic is created - $StatsData->{Title} "
            );

            $Selenium->execute_script($CheckConfirmJS);

            # delete created test statistics
            # click on delete icon
            $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentStatistics;Subaction=DeleteAction;StatID=$StatsIDLast\' )]"
            )->click();

            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;' );

            $Self->True(
                index( $Selenium->get_page_source(), "Action=AgentStatistics;Subaction=Edit;StatID=$StatsIDLast" )
                    == -1,
                "StatsData statistic is deleted - $StatsData->{Title} "
            );

        }

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # clean up test data
        for my $SLAID (@SLAIDs) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM service_sla WHERE sla_id = $SLAID",
            );
            $Self->True(
                $Success,
                "ServiceSla - $SLAID",
            );

            $Success = $DBObject->Do(
                SQL => "DELETE FROM sla WHERE id = $SLAID",
            );
            $Self->True(
                $Success,
                "SLADelete - $SLAID",
            );
        }

        for my $ServiceID (@ServiceIDs) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM service_customer_user WHERE service_id = $ServiceID",
            );
            $Self->True(
                $Success,
                "ServiceCustomerUser deleted - $ServiceID",
            );

            $Success = $DBObject->Do(
                SQL => "DELETE FROM service WHERE id = $ServiceID",
            );
            $Self->True(
                $Success,
                "Deleted Service - $ServiceID",
            );
        }

        # make sure the cache is correct.
        for my $Cache (
            qw (Service SLA Stats)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
