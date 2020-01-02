# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Enable TicketOverViewPageShown preference.
        for my $View (qw( Small Medium Preview )) {

            my %TicketOverViewPageShown = (
                Active          => "1",
                PreferenceGroup => "Miscellaneous",
                DataSelected    => "25",
                Key             => "Ticket limit per page for Ticket Overview \"$View\"",
                Label           => "Ticket Overview \"$View\" Limit",
                Module          => "Kernel::Output::HTML::Preferences::Generic",
                PrefKey         => "UserTicketOverview" . $View . "PageShown",
                Prio            => "8000",
                Data            => {
                    "10" => "10",
                    "15" => "15",
                    "20" => "20",
                    "25" => "25",
                    "30" => "30",
                    "35" => "35",
                },
            );

            my $Key = "PreferencesGroups###TicketOverview" . $View . "PageShown";
            $Helper->ConfigSettingChange(
                Key   => $Key,
                Value => \%TicketOverViewPageShown,
            );

            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => $Key,
                Value => \%TicketOverViewPageShown,
            );
        }

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Go to agent preferences.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=Miscellaneous");

        # Create test params.
        my @Tests = (
            {
                Name  => 'Overview Refresh Time',
                ID    => 'UserRefreshTime',
                Value => '5',
            },
            {
                Name  => 'Ticket Overview "Small" Limit',
                ID    => 'UserTicketOverviewSmallPageShown',
                Value => '10',
            },
            {
                Name  => 'Ticket Overview "Medium" Limit',
                ID    => 'UserTicketOverviewMediumPageShown',
                Value => '10',
            },
            {
                Name  => 'Ticket Overview "Preview" Limit',
                ID    => 'UserTicketOverviewPreviewPageShown',
                Value => '10',
            },
            {
                Name  => 'Screen after new ticket',
                ID    => 'UserCreateNextMask',
                Value => 'AgentTicketZoom',
            },

        );

        my $UpdateMessage = "Preferences updated successfully!";

        # Update generic preferences.
        for my $Test (@Tests) {

            $Selenium->InputFieldValueSet(
                Element => "#$Test->{ID}",
                Value   => $Test->{Value},
            );

            sleep 1;

            # Save the setting, wait for the ajax call to finish and check if success sign is shown.
            $Selenium->execute_script(
                "\$('#$Test->{ID}').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return \$('#$Test->{ID}').closest('.WidgetSimple').hasClass('HasOverlay');"
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return \$('#$Test->{ID}').closest('.WidgetSimple').find('.fa-check').length;"
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return !\$('#$Test->{ID}').closest('.WidgetSimple').hasClass('HasOverlay');"
            );

        }
    }
);

1;
