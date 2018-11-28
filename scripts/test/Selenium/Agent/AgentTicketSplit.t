# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $SystemAddressObject  = $Kernel::OM->Get('Kernel::System::SystemAddress');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        my $RandomID = $Helper->GetRandomID();

        # Disable check of email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # create test system address
        my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
            Name     => "sys$RandomID\@localhost.com",
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

        my $CustomerID   = 'customer' . $RandomID;
        my $CustomerUser = "$CustomerID\@localhost.com";
        my $Queue        = 'Raw';
        my $Priority     = '3 normal';
        my $Subject      = 'Selenium test';
        my $Body         = 'Just a test body for selenium testing';

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'First test ticket',
            Queue        => $Queue,
            Lock         => 'unlock',
            Priority     => $Priority,
            State        => 'new',
            CustomerID   => $CustomerID,
            CustomerUser => $CustomerUser,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID - created",
        );

        # get create article data
        my $ToCustomer   = "to$CustomerID\@localhost.com";
        my $FromCustomer = "from$CustomerID\@localhost.com";
        my @TestArticles = (
            {
                SenderType => 'customer',
                From       => "From Customer <$FromCustomer>",
                To         => 'Raw',
            },
            {
                SenderType => 'system',
                From       => "SeleniumSystemAddress <sys$RandomID\@localhost.com>",
                To         => "To Customer <$ToCustomer>",
            },
            {
                SenderType => 'customer',
                From       => "From Customer <$FromCustomer>",
                To         => "To Customer <$ToCustomer>",
            },
        );

        # create test articles for test ticket
        my $AccountedTime = 123;
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

            # Add accounted time to the ticket.
            my $Success = $TicketObject->TicketAccountTime(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                TimeUnit  => $AccountedTime,
                UserID    => 1,
            );
            $Self->True(
                $Success,
                "Accounted Time $AccountedTime added to ticket"
            );
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

        my @AllTicketIDs = ($TicketID);

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
                    $Selenium->InputFieldValueSet(
                        Element => '#SplitSelection',
                        Value   => 'EmailTicket',
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

                # Check accounted time on creation screen.
                my $TestAccountedTime = $Selenium->execute_script(
                    "return \$('#TimeUnits').val();"
                );
                $Self->Is(
                    $TestAccountedTime,
                    $AccountedTime,
                    "Check AccountedTime field for ArticleID = $ArticleIDs[0] in $Screen split screen",
                );

                # Submit form.
                $Selenium->find_element( '#submitRichText', 'css' )->VerifiedClick();

                # Get all tickets that we created.
                my @TicketIDs = $TicketObject->TicketSearch(
                    Result            => 'ARRAY',
                    CustomerUserLogin => $CustomerUser,
                    Limit             => 1,
                    OrderBy           => 'Down',
                    SortBy            => 'Age',
                    UserID            => 1,
                );

                my $CurrentTicketID = $TicketIDs[0];

                my $OldTicket = grep { $_ == $CurrentTicketID } @AllTicketIDs;
                $Self->False(
                    $OldTicket,
                    'Make sure that ticket is really created.',
                ) || die;

                push @AllTicketIDs, $CurrentTicketID;

                # Get ticket data.
                my %SplitTicketData = $TicketObject->TicketGet(
                    TicketID => $CurrentTicketID,
                    UserID   => 1,
                );

                $Kernel::OM->Get('Kernel::System::Log')
                    ->Dumper( 'Debug - ModuleName', 'VariableName', \%SplitTicketData );

                # Check if customer is present.
                $Self->Is(
                    $SplitTicketData{CustomerID},
                    $CustomerID,
                    'Check if CustomerID is present.'
                );

                # Check if customer user is present.
                $Self->Is(
                    $SplitTicketData{CustomerUserID},
                    $CustomerUser,
                    'Check if CustomerUserID is present.'
                );

                $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketZoom;' )]")->VerifiedClick();
                $Selenium->WaitFor(
                    JavaScript => "return \$('.TableLike label:contains(Accounted time:)').next().length;"
                );

                # Check accounted time on zoom screen.
                $TestAccountedTime = $Selenium->execute_script(
                    "return \$('.TableLike label:contains(Accounted time:)').next().text().trim();"
                );
                $Self->Is(
                    $TestAccountedTime,
                    $AccountedTime,
                    "Check AccountedTime field for ArticleID = $ArticleIDs[0] in $Screen split screen",
                );
            }
        }

        # Disable 'Frontend::Module###AgentTicketEmail' does not remove split target 'Email ticket'.
        # See bug#13690 (https://bugs.otrs.org/show_bug.cgi?id=13690) for more information.
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => "Frontend::Module###AgentTicketEmail",
        );

        # Navigate to AgentTicketZoom screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID",
        );

        # Click on the split action.
        $Selenium->find_element( '.SplitSelection', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return $("#SplitSubmit").length'
        );

        # Verify there is no 'Email ticket' split option.
        $Self->True(
            $Selenium->execute_script(
                "return \$(\"#SplitSelection option[value='EmailTicket']\").length === 0"
            ),
            "Split option for 'Email Ticket' is disabled.",
        );
        $Selenium->find_element( '.Close', 'css' )->click();

        # Delete test system address.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success  = $DBObject->Do(
            SQL  => "DELETE FROM system_address WHERE id = ?",
            Bind => [ \$SystemAddressID ],
        );
        $Self->True(
            $Success,
            "SystemAddressID $SystemAddressID - deleted",
        );

        for my $DeleteTicketID (@AllTicketIDs) {

            # delete test created ticket
            $Success = $TicketObject->TicketDelete(
                TicketID => $DeleteTicketID,
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "TicketID $DeleteTicketID - deleted",
            );
        }
    }
);

1;
