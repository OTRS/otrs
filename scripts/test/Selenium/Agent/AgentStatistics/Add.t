# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
        my $SLAObject     = $Kernel::OM->Get('Kernel::System::SLA');
        my $StatsObject   = $Kernel::OM->Get('Kernel::System::Stats');

        my $Success = $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        my @ServiceIDs;
        my @SLAIDs;

        # Add test services and SLAs.
        for ( 1 .. 5 ) {
            my $ServiceID = $ServiceObject->ServiceAdd(
                Name    => "TestService - " . $Helper->GetRandomID(),
                ValidID => 1,
                UserID  => 1,
            );
            $Self->True(
                $ServiceID,
                "Service $ServiceID has been created.",
            );

            $ServiceObject->CustomerUserServiceMemberAdd(
                CustomerUserLogin => '<DEFAULT>',
                ServiceID         => $ServiceID,
                Active            => 1,
                UserID            => 1,
            );
            push @ServiceIDs, $ServiceID;

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

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'stats' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Check add statistics screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Add");

        for my $Statistics (qw(DynamicMatrix DynamicList Static)) {
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('a[data-statistic-preselection=$Statistics]').length"
            );
            $Self->True(
                $Selenium->execute_script("return \$('a[data-statistic-preselection=$Statistics]').length"),
                "There is a link for adding '$Statistics' statistics",
            );
        }

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

        # Add new statistics.
        for my $StatsData (@Tests) {

            # Go to add statistics screen.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Add");

            $Selenium->find_element("//a[contains(\@data-statistic-preselection, \'$StatsData->{Type}\' )]")->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Title").length' );

            my $Description = 'Description ' . $StatsData->{Title};

            # Set values for new statistics - General Specifications.
            $Selenium->find_element( "#Title",       'css' )->send_keys( $StatsData->{Title} );
            $Selenium->find_element( "#Description", 'css' )->send_keys($Description);
            $Selenium->execute_script(
                "\$('#ObjectModule').val('$StatsData->{Object}').trigger('redraw.InputField').trigger('change');"
            );
            $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

            # Check X-axis configuration dialog.
            $Selenium->find_element( ".EditXAxis", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $(".Dialog.Modal").length && $("#DialogButton1").length'
            );

            if ( $StatsData->{Object} ne 'Kernel::System::Stats::Dynamic::TicketList' ) {
                $Selenium->execute_script(
                    "\$('#EditDialog select').val('$StatsData->{XAxis}').trigger('redraw.InputField').trigger('change');"
                );
            }

            $Selenium->find_element( "#DialogButton1", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

            # Check Y-axis configuration dialog.
            $Selenium->find_element( ".EditYAxis", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length' );
            $Selenium->WaitFor( JavaScript => 'return $("#EditDialog select").length && $("#DialogButton1").length' );

            $Selenium->execute_script(
                "\$('#EditDialog select').val('$StatsData->{YAxis}').trigger('redraw.InputField').trigger('change');"
            );

            if ( $StatsData->{Object} eq 'Kernel::System::Stats::Dynamic::TicketList' ) {

                # Wait for load selected YAxis.
                $Selenium->WaitFor(
                    JavaScript => "return typeof(\$) === 'function' && \$('#$StatsData->{YAxis}').length;"
                );

                # Select order by option.
                $Selenium->execute_script(
                    "\$('#EditDialog #$StatsData->{YAxis}').val('$StatsData->{OrderBy}').trigger('redraw.InputField').trigger('change');"
                );
            }
            $Selenium->find_element( "#DialogButton1", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

            # Check Restrictions configuration dialog.
            $Selenium->find_element( ".EditRestrictions", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $(".Dialog.Modal").length && $("#EditDialog select").length'
            );

            $Selenium->execute_script(
                "\$('#EditDialog select option[value=\"$StatsData->{RestrictionID}\"]').prop('selected', true).trigger('redraw.InputField').trigger('change');"
            );

            # Wait for load selected Restriction.
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#$StatsData->{RestrictionID}').length;"
            );

            # Add restriction.
            $Selenium->execute_script(
                "\$('#EditDialog #$StatsData->{RestrictionID} option[value=\"$StatsData->{Restrictionvalue}\"]').prop('selected', true).trigger('redraw.InputField').trigger('change');"
            );
            $Selenium->find_element( "#DialogButton1", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

            # Change preview format to Print.
            $Selenium->execute_script("\$('button[data-format=Print]').click()");
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#PreviewContentPrint").css("display") === "block"'
            );

            $Self->True(
                $Selenium->execute_script("return \$('#PreviewContentPrint').css('display')") eq 'block',
                "Print format is displayed",
            );

            my @StatsFormat = @StatsFormatDynamicMatrix;

            if ( $StatsData->{Type} eq 'DynamicList' ) {
                @StatsFormat = @StatsFormatDynamicList;
            }

            for my $StatsFormat (@StatsFormat) {

                # Change preview format.
                $Selenium->execute_script("\$('button[data-format=\"$StatsFormat->{Format}\"]').click()");
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('#$StatsFormat->{PreviewContent}').css('display') === 'block'"
                );

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

            # Save and finish test statistics.
            $Selenium->find_element( "#SaveAndFinish", 'css' )->VerifiedClick();

            # Sort decreasing by StatsID.
            $Selenium->VerifiedGet(
                "${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Overview;Direction=DESC;OrderBy=ID;StartHit=1"
            );

            # Get stats IDs.
            my $StatsIDs = $StatsObject->GetStatsList(
                AccessRw => 1,
                UserID   => 1,
            );

            my $Count       = scalar @{$StatsIDs};
            my $StatsIDLast = $StatsIDs->[ $Count - 1 ];

            # Check for created stats on overview screen.
            $Self->True(
                index( $Selenium->get_page_source(), $StatsData->{Title} ) > -1,
                "Test statistic is created - $StatsData->{Title} "
            );

            # Delete created test statistics.
            $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentStatistics;Subaction=DeleteAction;StatID=$StatsIDLast\' )]"
            )->click();

            $Selenium->WaitFor( AlertPresent => 1 );
            $Selenium->accept_alert();

            $Self->True(
                index( $Selenium->get_page_source(), "Action=AgentStatistics;Subaction=Edit;StatID=$StatsIDLast" )
                    == -1,
                "StatsData statistic is deleted - $StatsData->{Title} "
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Clean up test data.
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

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (
            qw (Service SLA Stats)
            )
        {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
