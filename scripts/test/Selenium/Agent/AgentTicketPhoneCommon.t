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

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # do not check email addresses
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $TicketID     = $TicketObject->TicketCreate(
            Title         => 'Selenium Test Ticket',
            QueueID       => 2,
            Lock          => 'lock',
            Priority      => '3 normal',
            State         => 'open',
            CustomerID    => 'SeleniumCustomer',
            CustomerUser  => "SeleniumCustomer\@localhost.com",
            OwnerID       => $TestUserID,
            UserID        => $TestUserID,
            ResponsibleID => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID"
        );

        # get test data
        my @Test = (
            {
                Name        => 'AgentTicketPhoneOutbound',
                HistoryText => 'PhoneCallAgent',
            },
            {
                Name        => 'AgentTicketPhoneInbound',
                HistoryText => 'PhoneCallCustomer',
            },
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # do tests for Outbound and Inbound
        for my $Action (@Test)
        {

            # navigate to test action
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$Action->{Name};TicketID=$TicketID");

            # check page
            for my $ID (
                qw(Subject RichText FileUpload NextStateID submitRichText)
                )
            {
                my $Element = $Selenium->find_element( "#$ID", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # add body text and submit
            my $ActionText = $Action->{Name} . " Selenium Test";
            $Selenium->find_element( "#Subject",  'css' )->send_keys($ActionText);
            $Selenium->find_element( "#RichText", 'css' )->send_keys($ActionText);
            $Selenium->execute_script("\$('#NextStateID').val('4').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

            # navigate to AgentTicketHistory screen
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

            # verify for expected action
            $Self->True(
                index( $Selenium->get_page_source(), $Action->{HistoryText} ) > -1,
                "Action $Action->{Name} executed correctly",
            );
        }

        # delete created test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket ID $TicketID is deleted"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
