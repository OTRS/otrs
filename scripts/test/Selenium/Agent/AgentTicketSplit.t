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

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $SystemAddressObject  = $Kernel::OM->Get('Kernel::System::SystemAddress');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        my @TicketIDs;

        # create test system address
        my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
            Name     => 'systemaddress@localhost.com',
            Realname => 'SeleniumSystemAddress',
            ValidID  => 1,
            QueueID  => 1,
            Comment  => 'Selenium test address',
            UserID   => 1,
        );
        $Self->True(
            $SystemAddressID,
            'System address added.'
        );

        my $CustomerID = '123465';
        my $Queue      = 'Raw';
        my $Priority   = '3 normal';
        my $Subject    = 'Selenium test';
        my $Body       = 'Just a test body for selenium testing';

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'First test ticket',
            Queue        => $Queue,
            Lock         => 'unlock',
            Priority     => $Priority,
            State        => 'new',
            CustomerID   => $CustomerID,
            CustomerUser => 'customer@localhost.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID - created",
        );

        # get create article data
        my $Customer     = 'customer' . $Helper->GetRandomID();
        my $ToCustomer   = "to$Customer\@localhost.com";
        my $FromCustomer = "from$Customer\@localhost.com";
        my @TestArticles = (
            {
                SenderType => 'customer',
                From       => "From Customer <$FromCustomer>",
                To         => 'Raw',
            },
            {
                SenderType => 'system',
                From       => 'SeleniumSystemAddress <systemaddress@localhost.com>',
                To         => "To Customer <$ToCustomer>",
            },
            {
                SenderType => 'customer',
                From       => "From Customer <$FromCustomer>",
                To         => "To Customer <$ToCustomer>",
            },
        );

        # create test articles for test ticket
        my @ArticleIDs;
        for my $TestArticle (@TestArticles) {
            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 1,
                SenderType           => $TestArticle->{SenderType},
                From                 => $TestArticle->{From},
                To                   => $TestArticle->{To},
                Subject              => $Subject,
                Body                 => $Body,
                Charset              => 'ISO-8859-15',
                MimeType             => 'text/plain',
                HistoryType          => 'PhoneCallCustomer',
                HistoryComment       => 'Selenium testing',
                UserID               => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleID $ArticleID - created",
            );
            push @ArticleIDs, $ArticleID;
        }

        # create and login test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # get test data
        my @Tests = (
            {
                ArticleID      => $ArticleIDs[0],
                ToValueOnSplit => "From Customer <$FromCustomer>",
                ResultMessage  => 'From is Customer, To is Queue',
            },
            {
                ArticleID      => $ArticleIDs[1],
                ToValueOnSplit => "To Customer <$ToCustomer>",
                ResultMessage  => 'From is SystemAddress, To is Customer',
            },
            {
                ArticleID      => $ArticleIDs[2],
                ToValueOnSplit => "From Customer <$FromCustomer>",
                ResultMessage  => 'From is Customer, To is Customer',
            },
        );

        # run test scenarios
        for my $Test (@Tests) {

            for my $Screen (qw(Phone Email)) {

                # Navigate to the ticket zoom screen.
                $Selenium->VerifiedGet(
                    "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID;ArticleID=$Test->{ArticleID}",
                );

                # Click on the split action.
                $Selenium->find_element( '.SplitSelection', 'css' )->click();

                $Selenium->WaitFor(
                    JavaScript => 'return $("#SplitSubmit").length'
                );

                if ( $Screen eq 'Email' ) {

                    # Change it to Email.
                    $Selenium->execute_script(
                        "\$('#SplitSelection').val('EmailTicket').trigger('redraw.InputField').trigger('change');"
                    );
                }

                $Selenium->find_element( '#SplitSubmit', 'css' )->VerifiedClick();

                # Check From field.
                my $From = $Selenium->execute_script(
                    "return \$('#CustomerTicketText_1').val();"
                );
                $Self->Is(
                    $From,
                    $Test->{ToValueOnSplit},
                    "Check From field for ArticleID = $ArticleIDs[0] in $Screen split screen.",
                );

                # Check CustomerID.
                my $TestCustomerID = $Selenium->execute_script(
                    "return \$('#CustomerID').val();"
                );
                $Self->Is(
                    $TestCustomerID,
                    $CustomerID,
                    "Check CustomerID field for ArticleID = $ArticleIDs[0] in $Screen split screen",
                );

                # Check Queue.
                my $TestQueue = $Selenium->execute_script(
                    "return \$('#Dest option:selected').text();"
                );
                $Self->Is(
                    $TestQueue,
                    $Queue,
                    "Check Queue field for ArticleID = $ArticleIDs[0] in $Screen split screen",
                );

                # Check Priority.
                my $TestPriority = $Selenium->execute_script(
                    "return \$('#PriorityID option:selected').text();"
                );
                $Self->Is(
                    $TestPriority,
                    $Priority,
                    "Check Priority field for ArticleID = $ArticleIDs[0] in $Screen split screen",
                );

                # Check Subject.
                my $TestSubject = $Selenium->execute_script(
                    "return \$('#Subject').val();"
                );
                $Self->Is(
                    $TestSubject,
                    $Subject,
                    "Check Subject field for ArticleID = $ArticleIDs[0] in $Screen split screen",
                );

                # Check Body.
                my $TestBody = $Selenium->execute_script(
                    "return \$('#RichText').val();"
                );
                $Self->Is(
                    $TestBody,
                    $Body,
                    "Check Subject field for ArticleID = $ArticleIDs[0] in $Screen split screen",
                );
            }
        }

        # delete test system address
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success  = $DBObject->Do(
            SQL => "DELETE FROM system_address WHERE id = $SystemAddressID",
        );
        $Self->True(
            $Success,
            "SystemAddressID $SystemAddressID - deleted",
        );

        # delete test created ticket
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "TicketID $TicketID - deleted",
        );
    }
);

1;
