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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test Customer.
        my $RandomID        = $Helper->GetRandomID();
        my $Customer        = "Company$RandomID";
        my $KnownCustomerID = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID             => $Customer,
            CustomerCompanyName    => $Customer . ' Inc',
            CustomerCompanyStreet  => 'Some Street',
            CustomerCompanyZIP     => '12345',
            CustomerCompanyCity    => 'Some city',
            CustomerCompanyCountry => 'USA',
            CustomerCompanyURL     => 'http://example.com',
            CustomerCompanyComment => 'some comment',
            ValidID                => 1,
            UserID                 => 1,
        );
        $Self->True(
            $KnownCustomerID,
            "CustomerID $KnownCustomerID is created.",
        );

        my $TicketObject      = $Kernel::OM->Get('Kernel::System::Ticket');
        my $UnknownCustomerID = "UnknownCustomer$RandomID";

        # Create two test Tickets.
        my @TicketIDs;
        for my $CustomerID ( $KnownCustomerID, $UnknownCustomerID ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => 'Some Ticket_Title',
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'closed successful',
                CustomerID   => $CustomerID,
                CustomerUser => 'unittest@otrs.com',
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "TicketID $TicketID is created.",
            );
            push @TicketIDs, $TicketID;
        }

        # Import test sample statistics.
        my $ConfigObject     = $Kernel::OM->Get('Kernel::Config');
        my $StatisticContent = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $ConfigObject->Get('Home')
                . '/scripts/test/sample/Stats/Stats.TestTicketList.en.xml',
        );

        my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');
        my $StatID      = $StatsObject->Import(
            Content => $StatisticContent,
            UserID  => 1,
        );
        $Self->True(
            $StatID,
            "StatID $StatID is imported.",
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'stats' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Check if appropriate CustomerID's are possible for selection.
        my @Tests = (
            {
                InSelection => 1,
                ConfigValue => 1,
                Text        => 'is included',
            },
            {
                InSelection => 0,
                ConfigValue => 0,
                Text        => 'is not included'
            },
        );
        for my $Test (@Tests) {

            # Change 'IncludeUnknownTicketCustomers' config.
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'Ticket::IncludeUnknownTicketCustomers',
                Value => $Test->{ConfigValue},
            );

            # Navigate to AgentStatics screen of imported test statistic.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentStatistics;Subaction=Edit;StatID=$StatID");

            # Click on Filter.
            $Selenium->execute_script('$(".EditRestrictions").click();');
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $(".Dialog.Modal").length && $("#EditDialog select").length;'
            );

            # Add CustomerID restriction field.
            $Selenium->InputFieldValueSet(
                Element => '#EditDialog select',
                Value   => 'RestrictionsCustomerID',
            );
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#RestrictionsCustomerID').length;"
            );

            # Verify known CustomerID from DB is included in restriction selection.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#RestrictionsCustomerID option[Value=$Customer]').length;"
                ),
                1,
                "Known CustomerID $Customer is included in restriction selection."
            );

            # Verify unknown CustomerID that is not from DB is included in selection when config
            #   'IncludeUnknownTicketCustomers' is enabled. See bug#14869 (https://bugs.otrs.org/show_bug.cgi?id=14869).
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#RestrictionsCustomerID option[Value=$UnknownCustomerID]').length;"
                ),
                $Test->{InSelection},
                "Unknown CustomerID $Customer $Test->{Text} in restriction selection."
            );
        }

        # Delete statistic.
        my $Success = $Kernel::OM->Get('Kernel::System::Stats')->StatsDelete(
            StatID => $StatID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "StatisticID $StatID is deleted."
        );

        # Delete test created tickets.
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "TicketID $TicketID is deleted."
            );
        }

        # Delete created test entities
        $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
            Bind => [ \$KnownCustomerID ],
        );
        $Self->True(
            $Success,
            "CustomerID $KnownCustomerID is deleted.",
        );

    }
);

1;
