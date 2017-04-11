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

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # disable check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # do not check service and type
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketCreate - ID $TicketID",
        );

        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

        # create test email article
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            IsVisibleForCustomer => 1,
            Subject              => 'some short description',
            Body                 => 'the message text',
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleCreate - ID $ArticleID",
        );

        my $Success = $ArticleBackendObject->ArticleWritePlain(
            ArticleID => $ArticleID,
            Email     => 'Test Email string',
            UserID    => 1,
        );
        $Self->True(
            $Success,
            "ArticleWritePlain for article ID $ArticleID - success",
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

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to ticket zoom page of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # click to bounce ticket
        $Selenium->find_element("//a[contains(\@href, 'Action=AgentTicketBounce') ]")->VerifiedClick();

        # switch to bounce window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # check agent ticket bounce screen
        for my $ID (
            qw(BounceTo BounceStateID To Subject RichText submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check JS functionality
        # click on checkbox - unchecked state
        $Selenium->execute_script("\$('#InformSender').prop('checked', true)");
        $Selenium->find_element( "#InformSender", 'css' )->VerifiedClick();

        # check up if labels does not have class Mandatory
        for my $Label (qw(To Subject RichText)) {
            $Self->Is(
                $Selenium->execute_script("return \$('label[for=$Label]').hasClass('Mandatory')"),
                0,
                "Label '$Label' has not class 'Mandatory'",
            );
        }

        # click on checkbox - checked state
        $Selenium->find_element( "#InformSender", 'css' )->VerifiedClick();

        # check up if labels have class Mandatory
        for my $Label (qw(To Subject RichText)) {
            $Self->Is(
                $Selenium->execute_script("return \$('label[for=$Label]').hasClass('Mandatory')"),
                1,
                "Label '$Label' has class 'Mandatory'",
            );
        }

        # set on initial unchecked state of checkbox
        $Selenium->find_element( "#InformSender", 'css' )->VerifiedClick();

        # bounce ticket to another test email
        $Selenium->find_element( "#BounceTo", 'css' )->send_keys("test\@localhost.com");
        $Selenium->execute_script("\$('#BounceStateID').val('4').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # wait for bounce to be handled
        $Selenium->WaitFor( WindowCount => 1 );

        # return back to zoom view
        $Selenium->switch_to_window( $Handles->[0] );

        # navigate to AgentTicketHistory of test created ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # verify that bounce worked as expected
        my $BounceText = 'Bounced to "test@localhost.com".';
        $Self->True(
            index( $Selenium->get_page_source(), $BounceText ) > -1,
            "Bounce executed correctly",
        );

        # delete created test ticket
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket id $TicketID is deleted"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
