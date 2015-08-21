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

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketEmail");

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

        # create test email ticket
        my $AutoCompleteString = "\"$TestCustomer $TestCustomer\" <$TestCustomer\@localhost.com> ($TestCustomer)";
        my $TicketSubject      = "Selenium Ticket";
        my $TicketBody         = "Selenium body test";
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#ToCustomer",                  'css' )->send_keys($TestCustomer);
        sleep 1;
        $Selenium->find_element("//*[text()='$AutoCompleteString']")->click();
        sleep 1;
        $Selenium->find_element( "#Subject",  'css' )->send_keys($TicketSubject);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($TicketBody);
        $Selenium->find_element( "#Subject",  'css' )->submit();

        # if Core::Sendmail setting aren't set up for sending mail, check for error message and exit test
        my $Success;
        eval {
            $Success = index( $Selenium->get_page_source(), 'Impossible to send message to:' ),
        };

        if ( $Success > -1 ) {
            print "Selenium Test Completed. Please configure Core::Sendmail to send email from system \n";
        }
        else {

            my %TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
                Result         => 'HASH',
                Limit          => 1,
                CustomerUserID => $TestCustomer,
            );
            my $TicketNumber = (%TicketIDs)[1];
            my $TicketID     = (%TicketIDs)[0];

            $Self->True(
                index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                "Ticket with ticket id $TicketID is created"
            );

            # go to ticket zoom page of created test ticket
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketZoom' )]")->click();

            # click to bounce ticket
            $Selenium->find_element("//a[contains(\@href, 'Action=AgentTicketBounce') ]")->click();

            # switch to bounce window
            my $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # check agent ticket bounce screen
            for my $ID (
                qw(BounceTo BounceStateID To Subject RichText submitRichText)
                )
            {
                my $Element = $Selenium->find_element( "#$ID", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # bounce ticket to another test email
            $Selenium->find_element( "#BounceTo",                        'css' )->send_keys("test\@localhost.com");
            $Selenium->execute_script("\$('#BounceStateID').val('4').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element( "#submitRichText",                  'css' )->click();

            # return back to zoom view
            $Selenium->switch_to_window( $Handles->[0] );

            # click on history link and switch window
            $Selenium->find_element("//*[text()='History']")->click();
            $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # verify that bounce worked as expected
            my $BounceText = 'Bounced to "test@localhost.com".';
            $Self->True(
                index( $Selenium->get_page_source(), $BounceText ) > -1,
                "Bounce executed correctly",
            );

            # delete created test ticket
            $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "Ticket with ticket id $TicketID is deleted"
            );

        }

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
