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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable TicketOverViewPageShown preference
        for my $View (qw( Small Medium Preview )) {

            my %TicketOverViewPageShown = (
                Active       => "1",
                Column       => "Other Settings",
                DataSelected => "25",
                Key          => "Ticket limit per page for Ticket Overview \"$View\"",
                Label        => "Ticket Overview \"$View\" Limit",
                Module       => "Kernel::Output::HTML::Preferences::Generic",
                PrefKey      => "UserTicketOverview" . $View . "PageShown",
                Prio         => "8000",
                Data         => {
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

        # go to agent preferences
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences");

        # wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # create test params
        my @Tests = (
            {
                Name   => 'Overview Refresh Time',
                ID     => 'UserRefreshTime',
                Value  => '5',
                Update => 'UserRefreshTimeUpdate',
            },
            {
                Name   => 'Ticket Overview "Small" Limit',
                ID     => 'UserTicketOverviewSmallPageShown',
                Value  => '10',
                Update => 'UserTicketOverviewSmallPageShownUpdate',
            },
            {
                Name   => 'Ticket Overview "Medium" Limit',
                ID     => 'UserTicketOverviewMediumPageShown',
                Value  => '10',
                Update => 'UserTicketOverviewMediumPageShownUpdate',
            },
            {
                Name   => 'Ticket Overview "Preview" Limit',
                ID     => 'UserTicketOverviewPreviewPageShown',
                Value  => '10',
                Update => 'UserTicketOverviewPreviewPageShownUpdate',
            },
            {
                Name   => 'Screen after new ticket',
                ID     => 'UserCreateNextMask',
                Value  => 'AgentTicketZoom',
                Update => 'UserCreateNextMaskUpdate',
            },

        );

        my $UpdateMessage = "Preferences updated successfully!";

        # update generic preferences
        for my $Test (@Tests) {

            $Selenium->execute_script(
                "\$('#$Test->{ID}').val('$Test->{Value}').trigger('redraw.InputField').trigger('change');"
            );
            $Selenium->find_element( "#$Test->{Update}", 'css' )->VerifiedClick();

            # wait until form has loaded, if neccessary
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

            $Self->True(
                index( $Selenium->get_page_source(), $UpdateMessage ) > -1,
                "Agent preference $Test->{Name} - updated"
            );
        }
    }
);

1;
