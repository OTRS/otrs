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

        # make sure we start with RuntimeDB search
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Hook',
            Value => 'TestTicket#',
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::HookDivider',
            Value => '::',
        );

        # create and login test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # create test customer
        my $TestCustomerUser = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # get test customer user ID
        my %TestCustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $TestCustomerUser,
        );

        my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        # create test ticket
        my $TitleRandom  = "Title" . $Helper->GetRandomID();
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN         => $TicketNumber,
            Title      => $TitleRandom,
            Queue      => 'Raw',
            Lock       => 'unlock',
            Priority   => '3 normal',
            State      => 'open',
            CustomerID => $TestCustomerUserID{UserCustomerID},
            OwnerID    => 1,
            UserID     => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # create two ticket articles
        my @ArticleIDs;
        for my $ArticleCreate ( 1 .. 2 ) {
            my $ArticleID = $ArticleObject->ArticleCreate(
                TicketID       => $TicketID,
                ArticleType    => 'note-internal',
                SenderType     => 'agent',
                Subject        => 'Selenium subject test',
                Body           => "Article $ArticleCreate",
                ContentType    => 'text/plain; charset=ISO-8859-15',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                UserID         => 1,
                NoAgentNotify  => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleCreate - ID $ArticleID",
            );
            push @ArticleIDs, $ArticleID;
        }

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentTicketZoom for test created ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        $Self->True(
            $Selenium->execute_script("return \$('h1:contains(TestTicket#::)')"),
            "Ticket::Hook and Ticket::HookDivider found",
        );

        $Self->True(
            $Selenium->execute_script("return \$('h1:contains($TitleRandom)')"),
            "Ticket $TitleRandom found",
        );

        # check page
        for my $Action (
            qw( AgentTicketLock AgentTicketHistory AgentTicketPrint AgentTicketPriority
            AgentTicketFreeText AgentLinkObject AgentTicketOwner AgentTicketCustomer AgentTicketNote
            AgentTicketPhoneOutbound AgentTicketPhoneInbound AgentTicketEmailOutbound AgentTicketMerge
            AgentTicketPending)
            )
        {
            my $Element = $Selenium->find_element("//a[contains(\@href, \'Action=$Action')]");
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # verify article order in zoom screen
        $Self->Is(
            $Selenium->execute_script(
                "return \$(\$('table tbody tr')[0]).attr('id')"
            ),
            'Row2',
            "First Article in table is second created article",
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$(\$('table tbody tr')[1]).attr('id')"
            ),
            'Row1',
            "Second Article in table is first created article",
        );

        # click to sort by article number
        $Selenium->find_element("//th[\@class='No Sortable tablesorter-header tablesorter-headerUnSorted']")->click();

        # verify change in article order on column header click, test Core.UI.Table.Sort.js
        $Self->Is(
            $Selenium->execute_script(
                "return \$(\$('table tbody tr')[0]).attr('id')"
            ),
            'Row1',
            "First Article in table is first created article - JS success",
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$(\$('table tbody tr')[1]).attr('id')"
            ),
            'Row2',
            "Second Article in table is second created article - JS success",
        );

        # clean up test data from the DB
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket is deleted - ID $TicketID"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
