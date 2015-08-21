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
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # do not check RichText
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # do not check service and type
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $SysConfigObject->ConfigItemUpdate(
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

        # add test customer for testing
        my $TestCustomer = 'Customer' . $Helper->GetRandomID();
        my $UserLogin    = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomer,
            UserLastname   => $TestCustomer,
            UserCustomerID => $TestCustomer,
            UserLogin      => $TestCustomer,
            UserEmail      => "$TestCustomer\@localhost.com",
            ValidID        => 1,
            UserID         => $TestUserID,
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $TicketID     = $TicketObject->TicketCreate(
            Title         => 'Selenium Test Ticket',
            QueueID       => 2,
            Lock          => 'lock',
            Priority      => '3 normal',
            State         => 'open',
            CustomerID    => $TestCustomer,
            CustomerUser  => "$TestCustomer\@localhost.com",
            OwnerID       => $TestUserID,
            UserID        => $TestUserID,
            ResponsibleID => $TestUserID,
        );

        # navigate to created test ticket in AgentTicketZoom page
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

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

        # do tests for Outbound and Inbound
        for my $Action (@Test)
        {

            # click on action
            $Selenium->find_element("//a[contains(\@href, \'Action=$Action->{Name};TicketID=$TicketID')]")->click();

            # switch to AgentPhoneCallOutbound window
            my $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

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
            $Selenium->find_element( "#RichText",                      'css' )->send_keys($ActionText);
            $Selenium->execute_script("\$('#NextStateID').val('4').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element( "#submitRichText",                'css' )->click();

            # return back to AgentTicketZoom
            $Selenium->switch_to_window( $Handles->[0] );
            $Selenium->WaitFor( JavaScript => "return \$('div.MainBox').length" );

            # click on history link and switch window
            $Selenium->find_element("//*[text()='History']")->click();
            $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            $Selenium->WaitFor( JavaScript => "return \$('table.DataTable').length" );

            # verify for expected action
            $Self->True(
                index( $Selenium->get_page_source(), $Action->{HistoryText} ) > -1,
                "Action $Action->{Name} executed correctly",
            );

            # close history and return to AgentTicketZoom for created test ticket
            $Selenium->find_element( ".CancelClosePopup", 'css' )->click();
            $Selenium->switch_to_window( $Handles->[0] );

        }

        # delete created test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket id $TicketID is deleted"
        );

        # delete created test customer user
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $TestCustomer = $DBObject->Quote($TestCustomer);
        $Success      = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomer ],
        );
        $Self->True(
            $Success,
            "Delete customer user - $TestCustomer",
        );

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'CustomerUser' );

    }
);

1;
