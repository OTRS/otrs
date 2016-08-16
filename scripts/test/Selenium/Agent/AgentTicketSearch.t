# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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
            Key   => 'Ticket::SearchIndexModule',
            Value => 'Kernel::System::Ticket::ArticleSearchIndex::RuntimeDB',
        );

        $Helper->ConfigSettingChange(
            Key   => 'Ticket::SearchIndexModule',
            Value => 'Kernel::System::Ticket::ArticleSearchIndex::RuntimeDB',
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create random variable
        my $RandomID = $Helper->GetRandomID();

        # create test ticket
        my $TitleRandom  = "Title" . $RandomID;
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN         => $TicketNumber,
            Title      => $TitleRandom,
            Queue      => 'Raw',
            Lock       => 'unlock',
            Priority   => '3 normal',
            State      => 'open',
            CustomerID => 'SeleniumCustomer',
            OwnerID    => 1,
            UserID     => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # create test article
        my $MinCharString = 'ct';
        my $MaxCharString = $RandomID . 'text' . $RandomID;
        my $Subject       = 'SubjectTitle' . $RandomID;
        my $ArticleID     = $TicketObject->ArticleCreate(
            TicketID    => $TicketID,
            ArticleType => 'note-internal',
            SenderType  => 'agent',
            Subject     => $Subject,
            Body =>
                "'maybe $MinCharString in an abbreviation' this is string with more than 30 characters $MaxCharString",
            ContentType    => 'text/plain; charset=ISO-8859-15',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'Some free text!',
            UserID         => 1,
            NoAgentNotify  => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - ID $ArticleID",
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentTicketSearch screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # wait until form and overlay has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # check ticket search page
        for my $ID (
            qw(SearchProfile SearchProfileNew Attribute ResultForm SearchFormSubmit)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # add search filter by ticket number and run it
        $Selenium->find_element( ".AddButton",   'css' )->click();
        $Selenium->find_element( "TicketNumber", 'name' )->send_keys($TicketNumber);
        $Selenium->find_element( "TicketNumber", 'name' )->VerifiedSubmit();

        # check for expected result
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        # navigate to AgentTicketSearch screen again
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # wait until form and overlay has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # input wrong search parameters, result should be 'No ticket data found'
        $Selenium->find_element( "Fulltext", 'name' )->send_keys("abcdfgh");
        $Selenium->find_element( "Fulltext", 'name' )->VerifiedSubmit();

        # check for expected result
        $Self->True(
            index( $Selenium->get_page_source(), "No ticket data found." ) > -1,
            "Ticket is not found on page",
        );

        # navigate to AgentTicketSearch screen again
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # wait until form and overlay has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # input wrong search parameters, result should be 'No ticket data found'
        $Selenium->find_element( "Fulltext", 'name' )->send_keys($MaxCharString);
        $Selenium->find_element( "Fulltext", 'name' )->VerifiedSubmit();

        # check for expected result
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page with RuntimeDB search with string longer then 30 characters",
        );

        # change search index module
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::SearchIndexModule',
            Value => 'Kernel::System::Ticket::ArticleSearchIndex::StaticDB',
        );

        $Helper->ConfigSettingChange(
            Key   => 'Ticket::SearchIndexModule',
            Value => 'Kernel::System::Ticket::ArticleSearchIndex::StaticDB',
        );

        # enable warn on stop word usage
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::SearchIndex::WarnOnStopWordUsage',
            Value => 1,
        );

        # Recreate TicketObject and update article index for staticdb
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
        $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        $TicketObject->ArticleIndexBuild(
            ArticleID => $ArticleID,
            UserID    => 1,
        );

        # navigate to AgentTicketSearch screen again
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # wait until form and overlay has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # try to search fulltext with string less then 3 characters
        $Selenium->find_element( "Fulltext", 'name' )->send_keys($MinCharString);
        $Selenium->find_element("//button[\@id='SearchFormSubmit']")->click();

        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert not found';

        # verify alert message
        my $ExpectedAlertText = "Fulltext: $MinCharString";
        $Self->True(
            $Selenium->get_alert_text() =~ /$ExpectedAlertText/,
            'Minimum character string search warning is found',
        );

        # accept alert
        $Selenium->accept_alert();

        # try to search fulltext with string more than 30 characters
        $Selenium->find_element( "Fulltext", 'name' )->clear();
        $Selenium->find_element( "Fulltext", 'name' )->send_keys($MaxCharString);
        $Selenium->find_element("//button[\@id='SearchFormSubmit']")->click();

        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert not found';

        # verify alert message
        $ExpectedAlertText = "Fulltext: $MaxCharString";
        $Self->True(
            $Selenium->get_alert_text() =~ /$ExpectedAlertText/,
            'Maximum character string search warning is found',
        );

        # accept alert
        $Selenium->accept_alert();

        # try to search fulltext with 'stop word' search
        $Selenium->find_element( "Fulltext", 'name' )->clear();
        $Selenium->find_element( "Fulltext", 'name' )->send_keys('because');
        $Selenium->find_element("//button[\@id='SearchFormSubmit']")->click();

        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert not found';

        # verify alert message
        $ExpectedAlertText = "Fulltext: because";
        $Self->True(
            $Selenium->get_alert_text() =~ /$ExpectedAlertText/,
            'Stop word search string warning is found',
        );

        # accept alert
        $Selenium->accept_alert();

        # search fulltext with correct input
        $Selenium->find_element( "Fulltext", 'name' )->clear();
        $Selenium->find_element( "Fulltext", 'name' )->send_keys($Subject);
        $Selenium->find_element("//button[\@id='SearchFormSubmit']")->VerifiedClick();

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('div.TicketZoom').length" );

        # check for expected result
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page with correct StaticDB search",
        );

        # clean up test data from the DB
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket ID $TicketID is deleted",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
