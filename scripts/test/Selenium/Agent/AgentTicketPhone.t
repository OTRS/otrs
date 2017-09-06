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

# Get selenium object.
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Overload CustomerUser => Map setting defined in the Defaults.pm - use external url.
        my $DefaultCustomerUser = $ConfigObject->Get("CustomerUser");
        $DefaultCustomerUser->{Map}->[5] = [
            'UserEmail',
            'Email',
            'email',
            1,
            1,
            'var',
            'http://www.otrs.com',
            0,
            '',
            'AsPopup OTRSPopup_TicketAction',
        ];
        $Helper->ConfigSettingChange(
            Key   => 'CustomerUser',
            Value => $DefaultCustomerUser,
        );

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Do not check service and type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0,
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $RandomID = $Helper->GetRandomID();

        # Add test customer for testing.
        my $TestCustomer       = 'Customer' . $RandomID;
        my $TestCustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomer,
            UserLastname   => $TestCustomer,
            UserCustomerID => $TestCustomer,
            UserLogin      => $TestCustomer,
            UserEmail      => "$TestCustomer\@localhost.com",
            ValidID        => 1,
            UserID         => $TestUserID,
        );
        $Self->True(
            $TestCustomerUserID,
            "CustomerUserAdd - ID $TestCustomerUserID"
        );

        # Get script alias.
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AgentTicketPhone screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # Check page.
        for my $ID (
            qw(FromCustomer CustomerID Dest Subject RichText FileUpload
            NextStateID PriorityID submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        my $Element = $Selenium->find_element( "#Subject", 'css' );
        $Element->send_keys("");
        $Element->VerifiedSubmit();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Subject').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Navigate to AgentTicketPhone screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # create test phone ticket
        my $TicketSubject = "Selenium Ticket";
        my $TicketBody    = "Selenium body test";
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys($TestCustomer);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomer)').click()");
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",  'css' )->send_keys($TicketSubject);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($TicketBody);

        # Wait for "Customer Information".
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".SidebarColumn fieldset .Value").length'
        );

        # Make sure that Customer email is link.
        my $LinkVisible = $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".SidebarColumn fieldset a.AsPopup:visible").length'
        );
        $Self->True(
            $LinkVisible,
            "Customer email is a link with class AsPopup."
        );

        # Overload CustomerUser => Map setting defined in the Defaults.pm - use internal url.
        $DefaultCustomerUser->{Map}->[5] = [
            'UserEmail',
            'Email',
            'email',
            1,
            1,
            'var',
            '[% Env("CGIHandle") %]?Action=AgentTicketCompose;ResponseID=1;TicketID=[% Data.TicketID | uri %];ArticleID=[% Data.ArticleID | uri %]',
            0,
            '',
            'AsPopup OTRSPopup_TicketAction',
        ];
        $Helper->ConfigSettingChange(
            Key   => 'CustomerUser',
            Value => $DefaultCustomerUser,
        );

        # remove customer
        $Selenium->find_element( "#TicketCustomerContentFromCustomer a.CustomerTicketRemove", "css" )->VerifiedClick();

        # add customer again
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys($TestCustomer);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomer)').click()");

        # Make sure that Customer email is not a link.
        $LinkVisible = $Selenium->execute_script("return \$('.SidebarColumn fieldset a.AsPopup').length;");
        $Self->False(
            $LinkVisible,
            "Customer email is not a link with class AsPopup."
        );

        # Use 'Enter' press instead of 'VerifiedSubmit' on 'Subject' field to check if works (see bug#13056).
        $Selenium->find_element( "#Subject", 'css' )->send_keys("\N{U+E007}");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".MessageBox a[href*=\'AgentTicketZoom;TicketID=\']").length !== 0'
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Get created test ticket ID and number.
        my @Ticket = split( 'TicketID=', $Selenium->get_current_url() );

        my $TicketID = $Ticket[1];

        my $TicketNumber = $TicketObject->TicketNumberLookup(
            TicketID => $TicketID,
            UserID   => 1,
        );

        $Self->True(
            $TicketID,
            "Ticket was created and found - $TicketID",
        );

        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketZoom;TicketID=$TicketID' )]"),
            "Ticket with ticket number $TicketNumber is created",
        );

        # Go to ticket zoom page of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check if test ticket values are genuine.
        $Self->True(
            index( $Selenium->get_page_source(), $TicketSubject ) > -1,
            "$TicketSubject found on page",
        ) || die "$TicketSubject not found on page";
        $Self->True(
            index( $Selenium->get_page_source(), $TicketBody ) > -1,
            "$TicketBody found on page",
        ) || die "$TicketBody not found on page";
        $Self->True(
            index( $Selenium->get_page_source(), $TestCustomer ) > -1,
            "$TestCustomer found on page",
        ) || die "$TestCustomer not found on page";

        # Test bug #12229
        my $QueueID1 = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => "<Queue>$RandomID",
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Some comment',
            UserID          => 1,
        );
        my $QueueID2 = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => "Junk::SubQueue $RandomID  $RandomID",
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Some comment',
            UserID          => 1,
        );

        $Self->True(
            $QueueID1,
            "Queue #1 created."
        );
        $Self->True(
            $QueueID2,
            "Queue #2 created."
        );

        # Navigate to AgentTicketPhone screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # select <Queue>
        my $QueueValue = "$QueueID1||<Queue>$RandomID";
        $Selenium->execute_script("\$('#Dest').val('$QueueValue').trigger('redraw.InputField').trigger('change');");

        # Wait for loader.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check Queue #1 is displayed as selected.
        $Self->Is(
            $Selenium->find_element( '#Dest', 'css' )->get_value(),
            $QueueValue,
            'Queue #1 is selected.',
        );

        # Check Queue #1 is displayed properly.
        $Self->Is(
            $Selenium->find_element( '#Dest', 'css' )->get_value(),
            $QueueID1 . "||<Queue>$RandomID",
            'Queue #1 is selected.',
        );

        # Select SubQueue on loading screen.
        # bug#12819 ( https://bugs.otrs.org/show_bug.cgi?id=12819 ) - queue contains spaces in the name.
        # Navigate to AgentTicketPhone screen again to check selecting a queue after loading screen.
        $QueueValue = $QueueID2 . "||Junk::SubQueue $RandomID  $RandomID";
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");
        $Selenium->execute_script("\$('#Dest').val('$QueueValue').trigger('redraw.InputField').trigger('change');");

        # Wait for loader.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check SubQueue is displayed properly.
        $Self->Is(
            $Selenium->find_element( '#Dest', 'css' )->get_value(),
            $QueueValue,
            'Queue #2 is selected.',
        );

        # delete Queues
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => "DELETE FROM queue WHERE id IN (?, ?)",
            Bind => [ \$QueueID1, \$QueueID2 ],
        );
        $Self->True(
            $Success,
            "Queues deleted",
        );

        # delete created test ticket
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
            "Ticket with ticket ID $TicketID is deleted",
        );

        # Delete created test customer user.
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

        # Make sure the cache is correct.
        for my $Cache (
            qw (Ticket CustomerUser)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
