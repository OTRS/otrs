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

        # Use a calendar with the same business hours for every day so that the UT runs correctly
        #   on every day of the week and outside usual business hours.
        my %Week;
        my @Days = qw(Sun Mon Tue Wed Thu Fri Sat);
        for my $Day (@Days) {
            $Week{$Day} = [ 0 .. 23 ];
        }
        $Helper->ConfigSettingChange(
            Key   => 'TimeWorkingHours',
            Value => \%Week,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeWorkingHours',
            Value => \%Week,
        );

        # Disable default Vacation days.
        $Helper->ConfigSettingChange(
            Key   => 'TimeVacationDays',
            Value => {},
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeVacationDays',
            Value => {},
        );

        # Do not check email addresses and mx records,
        #   change settings in both runtime and disk configuration.
        for my $Key (qw(CheckEmailAddresses CheckMXRecord)) {
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => $Key,
                Value => 0,
            );
        }

        # Create enviroment for testing Escalation ORDER BY modification from the bug#13458.
        # Create Queues with different Escalation times.
        my @QueueConfig = (
            {
                # First created Queue does not have Update time set, value is 0 for created ticket.
                Name              => 'Queue' . $Helper->GetRandomID(),
                FirstResponseTime => 50,
                SolutionTime      => 60,
            },
            {
                # Second created Queue does not have First response time set, value is 0 for created ticket.
                Name         => 'Queue' . $Helper->GetRandomID(),
                UpdateTime   => 70,
                SolutionTime => 80,
            },
            {
                # Third created Queue does not have Solution time set, value is 0 for created ticket.
                Name              => 'Queue' . $Helper->GetRandomID(),
                FirstResponseTime => 60,
                UpdateTime        => 30,
            },
        );

        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
        my @QueueIDs;
        for my $QueueCreate (@QueueConfig) {
            my $QueueID = $QueueObject->QueueAdd(
                ValidID         => 1,
                GroupID         => 1,
                FollowUpID      => 1,
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => 1,
                Comment         => 'Some comment',
                UserID          => 1,
                %{$QueueCreate},
            );
            push @QueueIDs, $QueueID;
        }

        my $RandomNumber = $Helper->GetRandomNumber();

        # Add special characters to CustomerID. See bug#14982.
        # Create CustomerCompany.
        my $TestCompany        = 'Company#%' . $RandomNumber;
        my $TestCompanyEncoded = 'Company%23%25' . $RandomNumber;
        my $CustomerID         = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
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

        # Create CustomerUser.
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

        # Create Tickets.
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );
        my @TicketIDs;
        for my $QueueID (@QueueIDs) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => 'Some Ticket Title',
                QueueID      => $QueueID,
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => $CustomerID,
                CustomerUser => $CustomerUserLogin,
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "TicketID $TicketID is created"
            );
            push @TicketIDs, $TicketID;

            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                From                 => 'Agent Some Agent Some Agent <email@example.com>',
                To                   => 'Customer A <customer-a@example.com>',
                Cc                   => 'Customer B <customer-b@example.com>',
                ReplyTo              => 'Customer B <customer-b@example.com>',
                Subject              => 'some short description',
                Body                 => 'the message text Perl modules provide a range of',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                HistoryType          => 'AddNote',
                HistoryComment       => 'Some free text!',
                UserID               => 1,
                NoAgentNotify        => 1,
            );

            my $TicketEscalationIndexBuild = $TicketObject->TicketEscalationIndexBuild(
                TicketID => $TicketID,
                UserID   => 1,
            );

            # Renew objects because of transaction.
            $Kernel::OM->ObjectsDiscard(
                Objects => [
                    'Kernel::System::Ticket',
                    'Kernel::System::Ticket::Article',
                    'Kernel::System::Ticket::Article::Backend::Internal',
                ],
            );
            $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
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

        # Go to AgentTicketStatusView, overview small, default sort is Age, default order is Down.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # Set filter to test CustomerID.
        $Selenium->execute_script("\$('.ColumnSettingsTrigger[title*=\"Customer ID\"]').click();");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.CustomerIDAutoComplete:visible').length;"
        );
        $Selenium->find_element( ".CustomerIDAutoComplete", 'css' )->send_keys($TestCompany);
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('ul.ui-autocomplete li.ui-menu-item:visible').length;"
        );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCompany)').click();");

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.OverviewHeader.CustomerID.FilterActive a[name=OverviewControl]').length;"
        );

        # Check a link in CustomerID column header.
        $Self->True(
            $Selenium->execute_script(
                "return \$('.OverviewHeader.CustomerID.FilterActive a[name=OverviewControl][href*=\"$TestCompanyEncoded\"]').length;"
            ),
            "Link for filter by CustomerID $TestCompany is encoded correctly"
        );

        # Check if CustomerID column containing special characters.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('a[href*=\"Action=AgentTicketCustomer;TicketID=$TicketIDs[0]\"] span').text().trim();"
            ),
            "$TestCompany",
            "CustomerID $TestCompany is found in the table"
        );

        # TODO: remove limitation to firefox.
        if ( $Selenium->{browser_name} eq 'firefox' ) {
            $Self->True(
                1,
                "TODO: DragAndDrop is currently disabled in Firefox",
            );
        }
        else {

            # Open ticket overview setting dialog.
            $Selenium->find_element( "#ShowContextSettingsDialog", 'css' )->click();

            # Wait until setting dialog to open, if necessary.
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog").length' );

            # Enable escalation time columns in overview screen.
            for my $ColumName ( 'EscalationResponseTime', 'EscalationSolutionTime', 'EscalationUpdateTime' ) {
                $Selenium->mouse_move_to_location(
                    element => $Selenium->find_element( "//li[\@data-fieldname='$ColumName']", 'xpath' ),
                );
                $Selenium->DragAndDrop(
                    Element      => "li[data-fieldname=\"$ColumName\"]",
                    Target       => '#AssignedFields-DashboardAgentTicketStatusView',
                    TargetOffset => {
                        X => 185,
                        Y => 10,
                    },
                );
            }

            $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

            # Create test scenarions.
            my @Tests = (
                {
                    Name          => 'Update Time',
                    ColumnName    => 'EscalationUpdateTime',
                    OrderBy       => 'Down',
                    ExpectedOrder => [ $TicketIDs[1], $TicketIDs[2], $TicketIDs[0] ],
                },
                {
                    Name          => 'Update Time',
                    ColumnName    => 'EscalationUpdateTime',
                    OrderBy       => 'Up',
                    ExpectedOrder => [ $TicketIDs[0], $TicketIDs[2], $TicketIDs[1] ],
                },
                {
                    Name          => 'Solution Time',
                    ColumnName    => 'EscalationSolutionTime',
                    OrderBy       => 'Up',
                    ExpectedOrder => [ $TicketIDs[2], $TicketIDs[0], $TicketIDs[1] ],
                },
                {
                    Name          => 'Solution Time',
                    ColumnName    => 'EscalationSolutionTime',
                    OrderBy       => 'Down',
                    ExpectedOrder => [ $TicketIDs[1], $TicketIDs[0], $TicketIDs[2] ],
                },
                {
                    Name          => 'First Response Time',
                    ColumnName    => 'EscalationResponseTime',
                    OrderBy       => 'Down',
                    ExpectedOrder => [ $TicketIDs[2], $TicketIDs[0], $TicketIDs[1] ],
                },
                {
                    Name          => 'First Response Time',
                    ColumnName    => 'EscalationResponseTime',
                    OrderBy       => 'Up',
                    ExpectedOrder => [ $TicketIDs[1], $TicketIDs[0], $TicketIDs[2] ],
                },
            );

            for my $Test (@Tests) {

                # Sort by Escalation column and verify OrderBy of ticket with and without escalation times.
                $Selenium->find_element("//a[contains(\@title, \'$Test->{ColumnName}\' )]")->VerifiedClick();

                my $Index = 0;
                for my $TicketID ( @{ $Test->{ExpectedOrder} } ) {
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('tbody tr:eq($Index)').attr('id');"
                        ),
                        "TicketID_$TicketID",
                        "For TicketID $TicketID, Sort By $Test->{Name}, Order By $Test->{OrderBy} is correct",
                    );
                    $Index++;
                }
            }

        }

        # Delete test created Tickets.
        my $Success;
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
                "TicketID $TicketID is deleted"
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test created CustomerUser.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$CustomerUserLogin ],
        );
        $Self->True(
            $Success,
            "CustomerUser $CustomerUserLogin is deleted",
        );

        # Delete test created CustomerCompany.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
            Bind => [ \$CustomerID ],
        );
        $Self->True(
            $Success,
            "CustomerID $CustomerID is deleted",
        );

        # Delete test created Queue.
        for my $QueueID (@QueueIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM queue WHERE id = ?",
                Bind => [ \$QueueID ],
            );
            $Self->True(
                $Success,
                "QueueID $QueueID is deleted",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
    },
);

1;
