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

        # enable tool bar TicketSearchFulltext
        my %TicketSearchFulltext = (
            Block       => 'ToolBarSearchFulltext',
            CSS         => 'Core.Agent.Toolbar.FulltextSearch.css',
            Description => 'Fulltext search',
            Module      => 'Kernel::Output::HTML::ToolBar::Generic',
            Name        => 'Fulltext search',
            Priority    => '1990020',
            Size        => '10',
        );

        $Helper->ConfigSettingChange(
            Key   => 'Frontend::ToolBarModule###12-Ticket::TicketSearchFulltext',
            Value => \%TicketSearchFulltext,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###12-Ticket::TicketSearchFulltext',
            Value => \%TicketSearchFulltext,
        );

        # create test user and login
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

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title         => "ticket",
            Queue         => 'Raw',
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'open',
            CustomerID    => 'SeleniumCustomerID',
            CustomerUser  => 'test@localhost.com',
            OwnerID       => $TestUserID,
            UserID        => 1,
            ResponsibleID => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID"
        );

        my $RandomID  = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomID();
        my $Subject   = "Test subject $RandomID";
        my $ArticleID = $TicketObject->ArticleCreate(
            TicketID       => $TicketID,
            ArticleType    => 'email-internal',
            SenderType     => 'agent',
            From           => 'Some Agent <otrs@example.com>',
            To             => 'Suplier<suplier@example.com>',
            Subject        => $Subject,
            Body           => 'the message text',
            Charset        => 'utf8',
            MimeType       => 'text/plain',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - $ArticleID"
        );

        # input test user in search fulltext
        $Selenium->find_element( "#Fulltext", 'css' )->send_keys( $Subject, "\N{U+E007}" );

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('tbody tr:contains($Subject)').length;"
        );

        # verify search
        $Self->True(
            index( $Selenium->get_page_source(), $Subject ) > -1,
            "Ticket is found by Subject - $Subject",
        );

        # delete test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
        }
        $Self->True(
            $Success,
            "Ticket is deleted - $TicketID"
        );
    }
);

1;
