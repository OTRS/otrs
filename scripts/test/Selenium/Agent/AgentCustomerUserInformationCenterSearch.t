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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
        my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
        my $Helper                = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Disable email checks when create new customer user.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my @CustomerCompanies;
        my @CustomerUsers;
        my @TicketIDs;

        # Create test customer companies, create customer user and ticket for each one.
        for ( 0 .. 2 ) {
            my $RandomID = $Helper->GetRandomID();

            my $CustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
                CustomerID             => 'Company' . $RandomID,
                CustomerCompanyName    => 'CompanyName' . $RandomID,
                CustomerCompanyStreet  => 'CompanyStreet' . $RandomID,
                CustomerCompanyZIP     => $RandomID,
                CustomerCompanyCity    => 'Miami',
                CustomerCompanyCountry => 'USA',
                CustomerCompanyURL     => 'http://www.example.org',
                CustomerCompanyComment => 'comment',
                ValidID                => 1,
                UserID                 => 1,
            );
            $Self->True(
                $CustomerCompanyID,
                "CustomerCompanyID $CustomerCompanyID is created",
            );

            my %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
                CustomerID => $CustomerCompanyID,
            );
            push @CustomerCompanies, \%CustomerCompany;

            my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
                Source         => 'CustomerUser',
                UserFirstname  => 'Firstname' . $RandomID,
                UserLastname   => 'Lastname' . $RandomID,
                UserCustomerID => $CustomerCompanyID,
                UserLogin      => 'CustomerUser' . $RandomID,
                UserEmail      => $RandomID . '@example.com',
                UserPassword   => 'password',
                ValidID        => 1,
                UserID         => 1,
            );
            $Self->True(
                $CustomerUserID,
                "CustomerUserID $CustomerUserID is created",
            );

            my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
                User => $CustomerUserID,
            );
            push @CustomerUsers, \%CustomerUser;

            my $TicketID = $TicketObject->TicketCreate(
                Title        => 'TicketTitle' . $RandomID,
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => $CustomerCompanyID,
                CustomerUser => $CustomerUserID,
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "TicketID $TicketID is created",
            );
            push @TicketIDs, $TicketID;
        }

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Create some test cases for the customer user information center search.
        my @Tests = (
            {
                Name        => 'Navigate to AgentCustomerUserInformationCenter screen',
                ReachMethod => 'VerifiedGet',
                Searches    => [
                    {
                        InputValue => $CustomerUsers[0]->{UserEmail},
                        FieldID    => '#AgentCustomerUserInformationCenterSearchCustomerUser',
                        SendKeys   => $CustomerUsers[0]->{UserLogin},
                    }
                ],
                CheckTitle =>
                    "\"$CustomerUsers[0]->{UserFirstname} $CustomerUsers[0]->{UserLastname}\" <$CustomerUsers[0]->{UserEmail}>",
                CheckTicket => $TicketIDs[0],
            },
            {
                Name        => 'Click on Customer User Information Center title',
                ReachMethod => 'execute_script',
                ReachField  => '#CustomerUserInformationCenterHeading',
                Searches    => [
                    {
                        InputValue => $CustomerUsers[1]->{UserEmail},
                        FieldID    => '#AgentCustomerUserInformationCenterSearchCustomerUser',
                        SendKeys   => $CustomerUsers[1]->{UserLogin},
                    }
                ],
                CheckTitle =>
                    "\"$CustomerUsers[1]->{UserFirstname} $CustomerUsers[1]->{UserLastname}\" <$CustomerUsers[1]->{UserEmail}>",
                CheckTicket => $TicketIDs[1],
            },
            {
                Name        => 'Click on Search menu button',
                ReachMethod => 'execute_script',
                ReachField  => '#GlobalSearchNav',
                Searches    => [
                    {
                        InputValue => $CustomerUsers[2]->{UserEmail},
                        FieldID    => '#AgentCustomerUserInformationCenterSearchCustomerUser',
                        SendKeys   => $CustomerUsers[2]->{UserLogin},
                    }
                ],
                CheckTitle =>
                    "\"$CustomerUsers[2]->{UserFirstname} $CustomerUsers[2]->{UserLastname}\" <$CustomerUsers[2]->{UserEmail}>",
                CheckTicket => $TicketIDs[2],
            }
        );

        for my $Test (@Tests) {

            for my $Search ( @{ $Test->{Searches} } ) {

                if ( $Test->{ReachMethod} eq 'VerifiedGet' ) {
                    $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentCustomerUserInformationCenter");
                }
                else {
                    $Selenium->execute_script("\$('$Test->{ReachField}').click()");
                }

                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $("#AgentCustomerUserInformationCenterSearchCustomerUser").length;'
                );

                $Selenium->find_element( "$Search->{FieldID}", 'css' )->send_keys( $Search->{SendKeys} );
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length;'
                );

                $Selenium->execute_script("\$('li.ui-menu-item:contains($Search->{InputValue})').click()");

                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && !\$('.Dialog.Modal').length;"
                );
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
                );
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('#CustomerUserInformationCenterHeading').length;"
                );

                # Check customer user information center page.
                $Self->Is(
                    $Selenium->execute_script("return \$('#CustomerUserInformationCenterHeading').text();"),
                    $Test->{CheckTitle},
                    "Title '$Test->{CheckTitle}' found on page"
                );
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('a[href*=\"Action=AgentTicketZoom;TicketID=$Test->{CheckTicket}\"]').length;"
                    ),
                    1,
                    "TicketID $Test->{CheckTicket} found on page"
                );
            }
        }

        # Cleanup the created test data.
        my $Success;

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test created tickets.
        for my $TicketID (@TicketIDs) {
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
                "TicketID $TicketID is deleted",
            );
        }

        # Delete test created customer users.
        for my $CustomerUser (@CustomerUsers) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE customer_id = ?",
                Bind => [ \$CustomerUser->{UserID} ],
            );
            $Self->True(
                $Success,
                "CustomerUserID $CustomerUser->{UserID} is deleted",
            );
        }

        # Delete test created customer companies.
        for my $CustomerCompany (@CustomerCompanies) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind => [ \$CustomerCompany->{CustomerID} ],
            );
            $Self->True(
                $Success,
                "CustomerCompanyID $CustomerCompany->{CustomerID} is deleted",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct after the test is done.
        for my $Cache (qw(Ticket CustomerUser CustomerCompany)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }

);

1;
