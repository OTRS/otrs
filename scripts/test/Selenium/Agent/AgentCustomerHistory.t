# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');

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
        my @Tickets;
        for my $Count ( 1 .. 3 ) {
            my $Title    = $Count . '-SeleniumTicket-' . $RandomNumber;
            my $TicketID = $TicketObject->TicketCreate(
                Title        => $Title,
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

            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 1,
                SenderType           => 'customer',
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
                "ArticleID $ArticleID is created",
            );

            push @Tickets, {
                Title     => $Title,
                TicketID  => $TicketID,
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

        for my $Test (@Tests) {
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$Test->{Screen}");

            if ( $Test->{FieldID} ne 'CustomerAutoComplete' ) {

                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $("#' . $Test->{FieldID} . '").length'
                );

                $Selenium->find_element( "#" . $Test->{FieldID}, 'css' )->clear();
                $Selenium->find_element( "#" . $Test->{FieldID}, 'css' )->send_keys($CustomerUserLogin);
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('li.ui-menu-item:contains($CustomerUserLogin):visible').length"
                );
                $Selenium->execute_script("\$('li.ui-menu-item:contains($CustomerUserLogin)').click()");
            }

            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("a.Large").length'
            );

            # Go to 'Large' view because all of events could be checked there.
            $Selenium->find_element( ".Large", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#TicketOverviewLarge > li").length === 3'
            );
            sleep 2;

            for my $Ticket (@Tickets) {
                my $TicketID = $Ticket->{TicketID};
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('#TicketOverviewLarge > li[id=\"TicketID_$TicketID\"]').length === 1"
                    ),
                    "$Test->{Screen} - TicketID $TicketID is found in the table",
                );
            }

            # Check master action link.
            $Selenium->execute_script(
                "\$('.MasterAction[id=TicketID_$Tickets[0]->{TicketID}]').trigger('click');"
            );
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $(".Cluster").length'
            );

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

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $Ticket->{TicketID},
                    UserID   => 1,
                );
            }
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
