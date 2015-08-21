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

        # create test phone ticket
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        my $AutoCompleteString = "\"$TestCustomer $TestCustomer\" <$TestCustomer\@localhost.com> ($TestCustomer)";
        my $TicketSubject      = "Selenium Ticket";
        my $TicketBody         = "Selenium body test";
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys($TestCustomer);

        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length' );

        $Selenium->find_element("//*[text()='$AutoCompleteString']")->click();
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",                     'css' )->send_keys($TicketSubject);
        $Selenium->find_element( "#RichText",                    'css' )->send_keys($TicketBody);
        $Selenium->find_element( "#Subject",                     'css' )->submit();

        $Selenium->WaitFor( JavaScript => 'return $("form").length' );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # get ticket ID
        my %TicketIDs = $TicketObject->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $TestCustomer,
        );
        my $TicketID = (%TicketIDs)[0];

        # navigate to created test ticket in AgentTicketZoom page
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # click on forward
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketForward;TicketID=$TicketID;' )]")->click();

        # switch to forward window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check AgentTicketFoward page
        for my $ID (
            qw(ToCustomer CcCustomer BccCustomer Subject RichText
            FileUpload ComposeStateID ArticleTypeID submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # input fields and send forward
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys($TestCustomer);

        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length' );

        $Selenium->find_element("//*[text()='$AutoCompleteString']")->click();
        $Selenium->execute_script("\$('#ComposeStateID').val('4').trigger('redraw.InputField').trigger('change');");

        $Selenium->find_element( "#ToCustomer", 'css' )->submit();

        # if Core::Sendmail setting aren't set up for sending mail, check for error message and exit test
        my $Success;
        eval {
            $Success = -1;
            $Selenium->switch_to_window( $Handles->[1] );
            $Success = index( $Selenium->get_page_source(), 'Impossible to send message to:' );
        };

        if ( $Success > -1 ) {
            $Kernel::OM->Get('Kernel::System::Console::BaseCommand')->Print(
                "<yellow>WARNING:Selenium Test prematurely Completed. Please configure Core::Sendmail to send email from system!</yellow>\n"
            );
        }
        else {

            # return back to AgentTicketZoom
            $Selenium->switch_to_window( $Handles->[0] );

            # click on history link and switch window
            $Selenium->find_element("//*[text()='History']")->click();
            $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # verify for expected action
            $Self->True(
                index( $Selenium->get_page_source(), "Forwarded to " ) > -1,
                "Action Forward executed correctly",
            );

            # close history and return to AgentTicketZoom for created test ticket
            $Selenium->find_element( ".CancelClosePopup", 'css' )->click();
            $Selenium->switch_to_window( $Handles->[0] );

        }

        # delete created test ticket
        $Success = $TicketObject->TicketDelete(
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
