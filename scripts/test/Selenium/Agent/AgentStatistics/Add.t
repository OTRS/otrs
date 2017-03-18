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

        my $Success = $Helper->ConfigSettingChange(
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
                "Service $ServiceID has been created.",
            );

            # add service as default service for all customers
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
                "SLA $SLAID has been created.",
            );

            push @SLAIDs, $SLAID;

        }

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # check add statistics screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Add");

        # check breadcrumb on Add screen
        my $Count = 1;
        for my $BreadcrumbText ( 'Statistics Overview', 'Add Statistics' )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

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
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentStatistics;Subaction=Overview\' )]")
            ->VerifiedClick();

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

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
                Title             => 'Statistic DynamicMatrix' . $Helper->GetRandomID(),
                Object            => 'Kernel::System::Stats::Dynamic::Ticket',
                Type              => 'DynamicMatrix',
                XAxis             => 'XAxisCreateTime',
                YAxis             => 'YAxisSLAIDs',
                RestrictionID     => 'RestrictionsQueueIDs',
                Restrictionvalue  => 3,
                SelectedTimeField => 1,
            },
            {
                Title            => 'Statistic - TicketAccountedTime' . $Helper->GetRandomID(),
                Object           => 'Kernel::System::Stats::Dynamic::TicketAccountedTime',
                Type             => 'DynamicMatrix',
                XAxis            => 'XAxisKindsOfReporting',
                YAxis            => 'YAxisSLAIDs',
                RestrictionID    => 'RestrictionsServiceIDs',
                Restrictionvalue => $ServiceIDs[0],
            },
            {
                Title            => 'Statistic - TicketSolutionResponseTime' . $Helper->GetRandomID(),
                Object           => 'Kernel::System::Stats::Dynamic::TicketSolutionResponseTime',
                Type             => 'DynamicMatrix',
                XAxis            => 'XAxisKindsOfReporting',
                YAxis            => 'YAxisSLAIDs',
                RestrictionID    => 'RestrictionsServiceIDs',
                Restrictionvalue => $ServiceIDs[0],
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

        my @StatsFormatDynamicMatrix = (
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

        my @StatsFormatDynamicList = (
            {
                Format         => 'Print',
                PreviewContent => 'PreviewContentPrint',
            },
        );

        # add new statistics
        for my $StatsData (@Tests) {

            # go to add statistics screen
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Add");

            # add new statistics
            $Selenium->find_element("//a[contains(\@data-statistic-preselection, \'$StatsData->{Type}\' )]")
                ->VerifiedClick();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Title").length' );

            my $Description = 'Description ' . $StatsData->{Title};

            # set values for new statistics - General Specifications
            $Selenium->find_element( "#Title",       'css' )->send_keys( $StatsData->{Title} );
            $Selenium->find_element( "#Description", 'css' )->send_keys($Description);
            $Selenium->execute_script(
                "\$('#ObjectModule').val('$StatsData->{Object}').trigger('redraw.InputField').trigger('change');"
            );
            $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

            # check X-axis configuration dialog
            $Selenium->find_element( ".EditXAxis", 'css' )->VerifiedClick();
            if ( $StatsData->{Object} ne 'Kernel::System::Stats::Dynamic::TicketList' ) {
                $Selenium->execute_script(
                    "\$('#EditDialog select').val('$StatsData->{XAxis}').trigger('redraw.InputField').trigger('change');"
                );
            }
            $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

            # check Y-axis configuration dialog
            $Selenium->find_element( ".EditYAxis", 'css' )->VerifiedClick();
            $Selenium->execute_script(
                "\$('#EditDialog select').val('$StatsData->{YAxis}').trigger('redraw.InputField').trigger('change');"
            );

            if ( $StatsData->{Object} eq 'Kernel::System::Stats::Dynamic::TicketList' ) {

                # wait for load selected YAxis
                $Selenium->WaitFor(
                    JavaScript => "return typeof(\$) === 'function' && \$('#$StatsData->{YAxis}').length;"
                );

                # select order by option
                $Selenium->execute_script(
                    "\$('#EditDialog #$StatsData->{YAxis}').val('$StatsData->{OrderBy}').trigger('redraw.InputField').trigger('change');"
                );
            }
            $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

            # check Restrictions configuration dialog
            $Selenium->find_element( ".EditRestrictions", 'css' )->VerifiedClick();
            $Selenium->execute_script(
                "\$('#EditDialog select option[value=\"$StatsData->{RestrictionID}\"]').prop('selected', true).trigger('redraw.InputField').trigger('change');"
            );

            # wait for load selected Restriction
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#$StatsData->{RestrictionID}').length;"
            );

            # add restriction
            $Selenium->execute_script(
                "\$('#EditDialog #$StatsData->{RestrictionID} option[value=\"$StatsData->{Restrictionvalue}\"]').prop('selected', true).trigger('redraw.InputField').trigger('change');"
            );
            $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

            # change preview format to Print
            $Selenium->find_element("//button[contains(\@data-format, \'Print')]")->VerifiedClick();
            $Self->True(
                $Selenium->execute_script("return \$('#PreviewContentPrint').css('display')") eq 'block',
                "Print format is displayed",
            );

            my @StatsFormat = @StatsFormatDynamicMatrix;

            if ( $StatsData->{Type} eq 'DynamicList' ) {
                @StatsFormat = @StatsFormatDynamicList;
            }

            for my $StatsFormat (@StatsFormat) {

                # change preview format
                $Selenium->find_element("//button[contains(\@data-format, \'$StatsFormat->{Format}')]")
                    ->VerifiedClick();
                $Self->True(
                    $Selenium->execute_script("return \$('#$StatsFormat->{PreviewContent}').css('display')") eq 'block',
                    "StackedArea format is displayed",
                );
            }

            # Check the options for the cache field in the general section.
            if ( $StatsData->{SelectedTimeField} ) {

                $Self->True(
                    $Selenium->execute_script(
                        "return \$('#Cache option[value=\"1\"]').val() == 1 && \$('#Cache option[value=\"1\"]')[0].innerHTML == 'Yes'"
                    ),
                    'Found element "Yes" in Cache the select field.',
                );
            }
            else {

                $Self->False(
                    $Selenium->execute_script("return \$('#Cache option[value=\"1\"]').val() == 1"),
                    'Found no element "Yes" in the Cache select field.',
                );
            }

            # save and finish test statistics
            $Selenium->find_element("//button[\@name='SaveAndFinish'][\@type='submit']")->VerifiedClick();

            my $CheckConfirmJS = <<"JAVASCRIPT";
(function () {
    window.confirm = function (message) {
        return true;
    };
}());
JAVASCRIPT

            # sort decreasing by StatsID
            $Selenium->VerifiedGet(
                "${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Overview;Direction=DESC;OrderBy=ID;StartHit=1"
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
            )->VerifiedClick();

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
