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

        # Get needed objects.
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $RandomNumber = $Helper->GetRandomNumber();

        # Create test customer company.
        my $TestCompany = 'Company' . $RandomNumber;
        my $CustomerID  = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID             => $TestCompany,
            CustomerCompanyName    => $TestCompany,
            CustomerCompanyStreet  => $TestCompany,
            CustomerCompanyZIP     => $TestCompany,
            CustomerCompanyCity    => $TestCompany,
            CustomerCompanyCountry => 'Germany',
            CustomerCompanyURL     => 'http://example.com',
            CustomerCompanyComment => $TestCompany,
            ValidID                => 1,
            UserID                 => 1,
        );
        $Self->True(
            $CustomerID,
            "CustomerCompanyID $CustomerID is created",
        );

        # Create test customer user.
        my $TestUser          = 'CustomerUser' . $RandomNumber;
        my $CustomerUserLogin = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestUser,
            UserLastname   => $TestUser,
            UserCustomerID => $CustomerID,
            UserLogin      => $TestUser,
            UserEmail      => "$TestUser\@example.com",
            ValidID        => 1,
            UserID         => 1
        );
        $Self->True(
            $CustomerUserLogin,
            "CustomerUser $CustomerUserLogin is created",
        );

        # Create test tickets.
        my $NumberOfTickets = 3;
        my @Tickets;
        for my $Count ( 1 .. $NumberOfTickets ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => $Count . '-SeleniumTicket-' . $RandomNumber,
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'open',
                CustomerID   => $CustomerID,
                CustomerUser => $CustomerUserLogin,
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "TicketID $TicketID is created",
            );
            my %Ticket = $TicketObject->TicketGet(
                TicketID => $TicketID,
            );

            # Create test email article.
            my $ArticleID = $TicketObject->ArticleCreate(
                TicketID       => $TicketID,
                ArticleType    => 'email-external',
                SenderType     => 'customer',
                Subject        => 'some short description',
                Body           => 'the message text',
                Charset        => 'ISO-8859-15',
                MimeType       => 'text/plain',
                HistoryType    => 'EmailCustomer',
                HistoryComment => 'Some free text!',
                UserID         => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleID $ArticleID is created",
            );

            push @Tickets, {
                %Ticket,
                ArticleID => $ArticleID,
            };
        }

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        my @Tests = (
            {
                Screen  => 'AgentTicketPhone',
                FieldID => 'FromCustomer',
            },
            {
                Screen  => 'AgentTicketEmail',
                FieldID => 'ToCustomer',
            },
            {
                Screen  => 'AgentTicketCustomer;TicketID=' . $Tickets[0]->{TicketID},
                FieldID => 'CustomerAutoComplete',
            },
        );

        my $TicketsLastIndex = scalar @Tickets - 1;
        for my $Test (@Tests) {
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$Test->{Screen}");

            if ( $Test->{FieldID} ne 'CustomerAutoComplete' ) {

                # Choose customer user and wait until customer history table appears.
                $Selenium->find_element( "#" . $Test->{FieldID}, 'css' )->clear();
                $Selenium->find_element( "#" . $Test->{FieldID}, 'css' )->send_keys($CustomerUserLogin);
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length'
                );

                $Self->Is(
                    $Selenium->execute_script(
                        'return typeof($) === "function" && $("li.ui-menu-item:visible").length'
                    ),
                    1,
                    "Check search result count",
                );

                $Self->Is(
                    $Selenium->execute_script('return $("li.ui-menu-item:nth-child(1) a").html()'),
                    "\"<strong>$TestUser</strong> $TestUser\" &lt;$TestUser\@example.com&gt; ($TestUser)",
                    "Check link html.",
                );

                $Selenium->find_element( "li.ui-menu-item:nth-child(1) a", 'css' )->VerifiedClick();
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".OverviewBox").length' );
            }

            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("a[name=OverviewControl][href*=\'View=Preview\']:visible").length'
            );

            # Go to 'Large' view because all of events could be checked there.
            $Selenium->find_element("//a[\@name='OverviewControl'][contains(\@href, \'View=Preview')]")->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#TicketOverviewLarge").length' );

            # wait for JavaScript to be executed completely (event bindings etc.)
            sleep 1;

            # Check sorting by title, ascending.
            $Selenium->execute_script("\$('#SortBy').val('Title|Up').trigger('change');");
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SortBy").val() === "Title|Up"' );

            # Get first and last ticket ID.
            my $FirstTicketID = $Tickets[0]->{TicketID};
            my $LastTicketID  = $Tickets[ $NumberOfTickets - 1 ]->{TicketID};

            # Wait until sorting is finished.
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#TicketOverviewLarge > li:eq(0)').attr('id') === 'TicketID_$FirstTicketID'"
            );

            # wait for JavaScript to be executed completely (event bindings etc.)
            sleep 1;

            my $Count = 0;
            for my $Ticket (@Tickets) {
                my $TicketID = $Ticket->{TicketID};
                $Self->Is(
                    $Selenium->execute_script("return \$('#TicketOverviewLarge > li:eq($Count)').attr('id');"),
                    "TicketID_$TicketID",
                    "$Test->{Screen} - TicketID $TicketID is found in expected row",
                );
                $Count++;
            }

            # Check sorting by title, descending and Reply action.
            $Selenium->execute_script(
                "\$('#SortBy').val('Title|Down').trigger('change');"
            );
            $Selenium->WaitFor(
                JavaScript => 'return typeof($) === "function" && $("#SortBy").val() === "Title|Down"'
            );

            # Wait until sorting is finished.
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#TicketOverviewLarge > li:eq(0)').attr('id') === 'TicketID_$LastTicketID'"
            );

            $Count = $TicketsLastIndex;
            for my $Ticket (@Tickets) {
                my $TicketID  = $Ticket->{TicketID};
                my $ArticleID = $Ticket->{ArticleID};

                $Self->Is(
                    $Selenium->execute_script("return \$('#TicketOverviewLarge > li:eq($Count)').attr('id');"),
                    "TicketID_$TicketID",
                    "$Test->{Screen} - TicketID $TicketID is found in expected row",
                );
                $Count--;

                # Reply action.
                $Selenium->execute_script(
                    "\$('#ResponseID$ArticleID').val('1').trigger('redraw.InputField').trigger('change');"
                );

                # Switch to compose window.
                $Selenium->WaitFor( WindowCount => 2 );
                my $Handles = $Selenium->get_window_handles();
                $Selenium->switch_to_window( $Handles->[1] );

                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $("div.Header p.AsteriskExplanation").length'
                );

                $Self->True(
                    $Selenium->execute_script("return \$('h1:contains(\"$Ticket->{Title}\")').length;"),
                    "$Test->{Screen} - Ticket title is correct",
                );

                # Close popup.
                $Selenium->close();
                $Selenium->WaitFor( WindowCount => 1 );
                $Selenium->switch_to_window( $Handles->[0] );
            }

            # Check master action link.
            $Selenium->find_element( ".MasterAction[id=TicketID_$Tickets[0]->{TicketID}]", 'css' )->VerifiedClick();

            $Self->True(
                index( $Selenium->get_current_url(), 'Action=AgentTicketZoom;TicketID=' . $Tickets[0]->{TicketID} )
                    > -1,
                "$Test->{Screen} - Link redirected to the correct page",
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success;

        # Delete test created tickets.
        for my $Ticket (@Tickets) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $Ticket->{TicketID},
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "Ticket $Ticket->{TicketID} is deleted"
            );
        }

        # Delete test created customer user.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$CustomerUserLogin ],
        );
        $Self->True(
            $Success,
            "CustomerUser $CustomerUserLogin is deleted",
        );

        # Delete test created customer company.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
            Bind => [ \$CustomerID ],
        );
        $Self->True(
            $Success,
            "CustomerCompanyID $CustomerID is deleted",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
    }
);

1;
