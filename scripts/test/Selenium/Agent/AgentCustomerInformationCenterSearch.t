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

        my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
        my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');
        my $Helper                = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Do not check email addresses.
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
                Name        => 'Navigate to AgentCustomerInformationCenter screen',
                ReachMethod => 'VerifiedGet',
                Searches    => [
                    {
                        InputValue => $CustomerCompanies[0]->{CustomerID},
                        FieldID    => '#AgentCustomerInformationCenterSearchCustomerID',
                        SendKeys   => $CustomerCompanies[0]->{CustomerID},
                    },
                    {
                        InputValue => $CustomerUsers[0]->{UserEmail},
                        FieldID    => '#AgentCustomerInformationCenterSearchCustomerUser',
                        SendKeys   => $CustomerUsers[0]->{UserID},
                    }
                ],
                CheckTitle  => "$CustomerCompanies[0]->{CustomerCompanyName} ($CustomerCompanies[0]->{CustomerID})",
                CheckUser   => $CustomerUsers[0]->{UserID},
                CheckTicket => $TicketIDs[0],
            },
            {
                Name        => 'Click on Customer Information Center title',
                ReachMethod => 'execute_script',
                ReachField  => '#CustomerInformationCenterHeading',
                Searches    => [
                    {
                        InputValue => $CustomerCompanies[1]->{CustomerID},
                        FieldID    => '#AgentCustomerInformationCenterSearchCustomerID',
                        SendKeys   => $CustomerCompanies[1]->{CustomerID},
                    },
                    {
                        InputValue => $CustomerUsers[1]->{UserEmail},
                        FieldID    => '#AgentCustomerInformationCenterSearchCustomerUser',
                        SendKeys   => $CustomerUsers[1]->{UserID},
                    }
                ],
                CheckTitle  => "$CustomerCompanies[1]->{CustomerCompanyName} ($CustomerCompanies[1]->{CustomerID})",
                CheckUser   => $CustomerUsers[1]->{UserID},
                CheckTicket => $TicketIDs[1],
            },
            {
                Name        => 'Click on Search menu button',
                ReachMethod => 'execute_script',
                ReachField  => '#GlobalSearchNav',
                Searches    => [
                    {
                        InputValue => $CustomerCompanies[2]->{CustomerID},
                        FieldID    => '#AgentCustomerInformationCenterSearchCustomerID',
                        SendKeys   => $CustomerCompanies[2]->{CustomerID},
                    },
                    {
                        InputValue => $CustomerUsers[2]->{UserEmail},
                        FieldID    => '#AgentCustomerInformationCenterSearchCustomerUser',
                        SendKeys   => $CustomerUsers[2]->{UserID},
                    }
                ],
                CheckTitle  => "$CustomerCompanies[2]->{CustomerCompanyName} ($CustomerCompanies[2]->{CustomerID})",
                CheckUser   => $CustomerUsers[2]->{UserID},
                CheckTicket => $TicketIDs[2],
            }
        );

        for my $Test (@Tests) {

            for my $Search ( @{ $Test->{Searches} } ) {

                # Get AgentCustomerInformationCenterSearch modal dialog.
                if ( $Test->{ReachMethod} eq 'VerifiedGet' ) {
                    $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentCustomerInformationCenter");
                }
                else {
                    $Selenium->execute_script("\$('$Test->{ReachField}').click();");
                }

                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('$Search->{FieldID}:visible').length;"
                );

                $Selenium->find_element( "$Search->{FieldID}", 'css' )->send_keys( $Search->{SendKeys} );
                $Selenium->WaitFor(
                    JavaScript => "return \$('li.ui-menu-item:visible:contains($Search->{InputValue})').length;"
                );

                $Selenium->execute_script("\$('li.ui-menu-item:contains($Search->{InputValue})').click();");
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
                        "return typeof(\$) === 'function' && \$('#CustomerInformationCenterHeading').length;"
                );

                # Check customer information center page.
                $Self->Is(
                    $Selenium->execute_script("return \$('#CustomerInformationCenterHeading').text();"),
                    $Test->{CheckTitle},
                    "Title '$Test->{CheckTitle}' found on page"
                );
                $Self->Is(
                    $Selenium->execute_script("return \$('.MasterActionLink:contains($Test->{CheckUser})').length;"),
                    1,
                    "Customer user '$Test->{CheckUser}' found on page"
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

        # Make sure cache is correct.
        for my $Cache (qw(Ticket CustomerUser CustomerCompany)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }

);

1;
