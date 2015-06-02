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
                RestoreSystemConfiguration => 1,
                }
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # enable ticket responsible and watch feature
        for my $SysConfigResWatch (qw( Responsible Watcher )) {
            $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => "Ticket::$SysConfigResWatch",
                Value => 1
            );
        }

        # get menu config params
        my @TicketMenu = (
            {
                SysConfigItem => {
                    Active      => "AgentTicketMove",
                    Description => "Delete this ticket",
                    Link        => "Action=AgentTicketMove;TicketID=[% Data.TicketID %];DestQueue=Delete",
                    Module      => "Kernel::Output::HTML::TicketMenu::Generic",
                    Name        => "Delete",
                    PopupType   => "",
                    Target      => "",
                },
                Key => "Ticket::Frontend::MenuModule###460-Delete",
            },
            {
                SysConfigItem => {
                    Active      => "AgentTicketMove",
                    Description => "Mark as Spam!",
                    Link        => "Action=AgentTicketMove;TicketID=[% Data.TicketID %];DestQueue=Delete",
                    Module      => "Kernel::Output::HTML::TicketMenu::Generic",
                    Name        => "Spam",
                    PopupType   => "",
                    Target      => "",
                },
                Key => "Ticket::Frontend::MenuModule###470-Spam",
            },
            {
                SysConfigItem => {
                    Active      => "AgentTicketMove",
                    Description => "Delete this ticket",
                    Link        => "Action=AgentTicketMove;TicketID=[% Data.TicketID %];DestQueue=Delete",
                    Module      => "Kernel::Output::HTML::TicketMenu::Generic",
                    Name        => "Delete",
                    PopupType   => "",
                    Target      => "",
                },
                Key => "Ticket::Frontend::PreMenuModule###450-Delete",
            },
            {
                SysConfigItem => {
                    Active      => "AgentTicketMove",
                    Description => "Mark as Spam!",
                    Link        => "Action=AgentTicketMove;TicketID=[% Data.TicketID %];DestQueue=Delete",
                    Module      => "Kernel::Output::HTML::TicketMenu::Generic",
                    Name        => "Spam",
                    PopupType   => "",
                    Target      => "",
                },
                Key => "Ticket::Frontend::PreMenuModule###460-Spam",
            },
        );

        # enable delete and spam menu in sysconfig
        for my $SysConfigItem (@TicketMenu) {
            $Kernel::OM->Get('Kernel::Config')->Set(
                Key   => $SysConfigItem->{Key},
                Value => $SysConfigItem->{SysConfigItem},
            );
            $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => $SysConfigItem->{Key},
                Value => $SysConfigItem->{SysConfigItem},
            );
        }

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to raw queue view with focus on created test ticket
        $Selenium->get(
            "${ScriptAlias}index.pl?Action=AgentTicketQueue;Filter=Unlocked;OrderBy=Down;QueueID=2;SortBy=Age;View=Preview;"
        );

        # create pre menu module test params
        my @PreMenuModule = (
            {
                Name   => "Lock",
                Action => "AgentTicket"
            },
            {
                Name   => "Zoom",
                Action => "AgentTicketZoom",
            },
            {
                Name   => "History",
                Action => "AgentTicketHistory",
            },
            {
                Name   => "Priority",
                Action => "AgentTicketPriority",
            },
            {
                Name   => "Note",
                Action => "AgentTicketNote",
            },
            {
                Name   => "Move",
                Action => "AgentTicketMove",
            },
            {
                Name   => "Delete",
                Action => "AgentTicketMove;TicketID=$TicketID;DestQueue=Delete",
            },
            {
                Name   => "Spam",
                Action => "AgentTicketMove;TicketID=$TicketID;DestQueue=Delete",
            },
        );

        # check ticket pre menu modules
        for my $MenuModulePre (@PreMenuModule) {
            $Self->True(
                $Selenium->find_element("//a[contains(\@href, \'Action=$MenuModulePre->{Action}' )]"),
                "Ticket pre menu $MenuModulePre->{Name} - found"
            );
        }

        # go to test created ticket zoom
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # create menu module test params
        my @MenuModule = (
            {
                Name   => "Back",
                Action => "AgentDashboard",
            },
            {
                Name   => "Lock",
                Action => "AgentTicket"
            },
            {
                Name   => "History",
                Action => "AgentTicketHistory",
            },
            {
                Name   => "Print",
                Action => "AgentTicketPrint",
            },
            {
                Name   => "Priority",
                Action => "AgentTicketPriority",
            },
            {
                Name   => "Free Fields",
                Action => "AgentTicketFreeText",
            },
            {
                Name   => "Link",
                Action => "AgentLinkObject",
            },
            {
                Name   => "Owner",
                Action => "AgentTicketOwner",
            },
            {
                Name   => "Responsible",
                Action => "AgentTicketResponsible",
            },
            {
                Name   => "Customer",
                Action => "AgentTicketCustomer",
            },
            {
                Name   => "Note",
                Action => "AgentTicketNote",
            },
            {
                Name   => "Phone Call Outbound",
                Action => "AgentTicketPhoneOutbound",
            },
            {
                Name   => "Phone Call Inbound",
                Action => "AgentTicketPhoneInbound",
            },
            {
                Name   => "E-Mail Outbound",
                Action => "AgentTicketEmailOutbound",
            },
            {
                Name   => "Merge",
                Action => "AgentTicketMerge",
            },
            {
                Name   => "Pending",
                Action => "AgentTicketPending",
            },
            {
                Name   => "Watch",
                Action => "AgentTicketWatcher",
            },
            {
                Name   => "Close",
                Action => "AgentTicketClose",
            },
            {
                Name   => "Delete",
                Action => "AgentTicketMove;TicketID=$TicketID;DestQueue=Delete",
            },
            {
                Name   => "Spam",
                Action => "AgentTicketMove;TicketID=$TicketID;DestQueue=Delete",
            },
        );

        # check ticket menu modules
        for my $ZoomMenuModule (@MenuModule) {
            $Self->True(
                $Selenium->find_element("//a[contains(\@href, \'Action=$ZoomMenuModule->{Action}' )]"),
                "Ticket menu $ZoomMenuModule->{Name} - found"
            );
        }

        # delete created test tickets
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );
        $Self->True(
            $Success,
            "Delete ticket - $TicketID"
        );

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
        }
);

1;
