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

        # get helper object
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');

        # enable ticket responsible
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Responsible',
            Value => 1
        );

        # enable ticket watcher feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Watcher',
            Value => 1
        );

        # create test group
        my $TestGroup   = 'Group' . $Helper->GetRandomID();
        my $TestGroupID = $GroupObject->GroupAdd(
            Name    => $TestGroup,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $TestGroupID,
            "$TestGroup - created",
        );

        # get test params
        my @Tests = (
            {
                ToolBarModule => '110-Ticket::AgentTicketQueue',
                CssClassCheck => 'QueueView',
            },
            {
                ToolBarModule => '120-Ticket::AgentTicketStatus',
                CssClassCheck => 'StatusView',
            },
            {
                ToolBarModule => '130-Ticket::AgentTicketEscalation',
                CssClassCheck => 'EscalationView',
            },
            {
                ToolBarModule => '140-Ticket::AgentTicketPhone',
                CssClassCheck => 'PhoneTicket',
            },
            {
                ToolBarModule => '150-Ticket::AgentTicketEmail',
                CssClassCheck => 'EmailTicket',
            },
            {
                ToolBarModule => '160-Ticket::AgentTicketProcess',
                CssClassCheck => 'ProcessTicket',
            },
            {
                ToolBarModule => '170-Ticket::TicketResponsible',
                CssClassCheck => 'Responsible',
            },
            {
                ToolBarModule => '180-Ticket::TicketWatcher',
                CssClassCheck => 'Watcher',
            },
            {
                ToolBarModule => '190-Ticket::TicketLocked',
                CssClassCheck => 'Locked',
            },
        );

        # set group restriction for each toolbar module
        for my $ConfigUpdate (@Tests) {
            my %ToolBarConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
                Name    => 'Frontend::ToolBarModule###' . $ConfigUpdate->{ToolBarModule},
                Default => 1,
            );

            %ToolBarConfig = %{ $ToolBarConfig{EffectiveValue} };

            $ToolBarConfig{Group} = "ro:$TestGroup";

            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'Frontend::ToolBarModule###' . $ConfigUpdate->{ToolBarModule},
                Value => \%ToolBarConfig,
            );
        }

        # create test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title         => 'Some Ticket Title',
            Queue         => 'Raw',
            Lock          => 'lock',
            Priority      => '3 normal',
            State         => 'new',
            CustomerID    => '123465',
            CustomerUser  => 'customer@example.com',
            OwnerID       => $TestUserID,
            ResponsibleID => $TestUserID,
            UserID        => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket ID $TicketID - created"
        );

        # set test user watch subscription for test ticket
        my $Success = $TicketObject->TicketWatchSubscribe(
            TicketID    => $TicketID,
            WatchUserID => $TestUserID,
            UserID      => 1,
        );
        $Self->True(
            $TicketID,
            "User $TestUserLogin subscribed for test ticket ID $TicketID"
        );

        # give test user ro permission for test group
        $Success = $GroupObject->PermissionGroupUserAdd(
            GID        => $TestGroupID,
            UID        => $TestUserID,
            Permission => {
                ro => 1,
            },
            UserID => 1,
        );
        $Self->True(
            $Success,
            "For User $TestUserLogin set 'ro' permission in group $TestGroup",
        );

        # login test user
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # first check all toolbar modules are visible for test user
        for my $FirstCheck (@Tests) {

            # verify toolbar module is loaded for user
            my $ClassCheck = $FirstCheck->{CssClassCheck};
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#ToolBar li').hasClass('$ClassCheck')"
                ),
                '1',
                "ToolBar $FirstCheck->{ToolBarModule} for User $TestUserLogin - found",
            );
        }

        # remove test user ro permission for test group
        $Success = $GroupObject->PermissionGroupUserAdd(
            GID        => $TestGroupID,
            UID        => $TestUserID,
            Permission => {
                ro => 0,
            },
            UserID => 1,
        );
        $Self->True(
            $Success,
            "For User $TestUserLogin removed 'ro' permission in group $TestGroup",
        );

        # refresh screen
        $Selenium->refresh();

        # second check all toolbar modules are not visible for test user
        for my $SecondCheck (@Tests) {

            # verify toolbar is removed for test user
            my $ClassCheck = $SecondCheck->{CssClassCheck};
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#ToolBar li').hasClass('$ClassCheck')"
                ),
                '0',
                "ToolBar $SecondCheck->{ToolBarModule} for User $TestUserLogin - removed",
            );
        }

        # delete test group
        $TestGroup = $DBObject->Quote($TestGroup);
        $Success   = $DBObject->Do(
            SQL  => "DELETE FROM groups WHERE name = ?",
            Bind => [ \$TestGroup ],
        );
        $Self->True(
            $Success,
            "$TestGroup - deleted",
        );

        # delete test ticket
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        $Self->True(
            $Success,
            "Ticket ID $TicketID - deleted"
        );

        # make sure cache is correct
        for my $Cache (
            qw (Ticket Group)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
