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

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Change settings Ticket::Frontend::AgentTicketQueue###VisualAlarms to 'Yes'.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketQueue###VisualAlarms',
            Value => 1,
        );

        # Change settings Ticket::Frontend::AgentTicketQueue###Blink to 'Yes'.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketQueue###Blink',
            Value => 1,
        );

        # Change settings Ticket::Frontend::AgentTicketQueue###HighlightAge1 to 10 minutes.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketQueue###HighlightAge1',
            Value => 10,
        );

        # Change settings Ticket::Frontend::AgentTicketQueue###HighlightAge2 to 20 minutes.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketQueue###HighlightAge2',
            Value => 20,
        );

        # Create test user.
        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'users' ],
            Language => $Language,
        ) || die "Did not get test user";

        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        # Create test queues.
        my @Queues;
        for my $Item ( 1 .. 4 ) {

            my $QueueID;
            my $QueueName = 'Queue' . $Helper->GetRandomID();
            if ( $Item == 3 ) {
                $QueueName = 'Delete';
                $QueueID   = $QueueObject->QueueLookup( Queue => $QueueName );
            }
            elsif ( $Item == 4 ) {
                $QueueName = $Queues[1]->{QueueName} . '::' . $QueueName;

                # $QueueID   = $QueueObject->QueueLookup( Queue => $QueueName );
            }

            my $Created = '';
            if ( !defined $QueueID ) {
                $QueueID = $QueueObject->QueueAdd(
                    Name            => $QueueName,
                    ValidID         => 1,
                    GroupID         => 1,
                    SystemAddressID => 1,
                    SalutationID    => 1,
                    SignatureID     => 1,
                    Comment         => 'Selenium Queue',
                    UserID          => $TestUserID,
                );
                $Self->True(
                    $QueueID,
                    "QueueAdd() successful for test $QueueName ID $QueueID",
                );
                $Created = 1;
            }

            push @Queues,
                {
                QueueName => $QueueName,
                QueueID   => $QueueID,
                Created   => $Created,
                };
        }

        # Set fixed time to test Visual alarms
        my $FixedTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

        # Create params for test tickets
        my @Tests = (
            {
                Queue   => 'Postmaster',
                QueueID => 1,
                Lock    => 'unlock',
                State   => 'open',
            },
            {
                Queue        => 'Raw',
                QueueID      => 2,
                Lock         => 'unlock',
                FixedTimeSet => $FixedTime - 60 * 60 - 100,
                State        => 'open',
            },
            {
                Queue   => 'Junk',
                QueueID => 3,
                Lock    => 'lock',
                State   => 'open',
            },
            {
                Queue   => 'Misc',
                QueueID => 4,
                Lock    => 'lock',
                State   => 'open',
            },
            {
                Queue        => $Queues[0]->{QueueName},
                QueueID      => $Queues[0]->{QueueID},
                Lock         => 'unlock',
                FixedTimeSet => $FixedTime - 10 * 60 - 100,
                State        => 'open',
            },
            {
                Queue        => $Queues[1]->{QueueName},
                QueueID      => $Queues[1]->{QueueID},
                Lock         => 'unlock',
                FixedTimeSet => $FixedTime - 20 * 60 - 100,
                State        => 'open',
            },
            {
                Queue   => $Queues[2]->{QueueName},
                QueueID => $Queues[2]->{QueueID},
                Lock    => 'unlock',
                State   => 'open',
            },
            {
                Queue   => $Queues[3]->{QueueName},
                QueueID => $Queues[3]->{QueueID},
                Lock    => 'unlock',
                State   => 'new',
            }
        );

        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # Create test tickets.
        my @TicketIDs;
        for my $TicketCreate (@Tests) {

            $Helper->FixedTimeSet( $TicketCreate->{FixedTimeSet} ) if defined $TicketCreate->{FixedTimeSet};

            my $TicketID = $TicketObject->TicketCreate(
                Title         => 'Selenium Test Ticket',
                Queue         => $TicketCreate->{Queue},
                Lock          => $TicketCreate->{Lock},
                Priority      => '3 normal',
                State         => $TicketCreate->{State},
                CustomerID    => 'SeleniumCustomer',
                CustomerUser  => 'SeleniumCustomer@localhost.com',
                OwnerID       => $TestUserID,
                UserID        => $TestUserID,
                ResponsibleID => $TestUserID,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID",
            );

            push @TicketIDs, $TicketID;

            # Create email article.
            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                SenderType           => 'customer',
                IsVisibleForCustomer => 1,
                From                 => 'Some Customer A <customer-a@example.com>',
                To                   => 'Some Agent <email@example.com>',
                Subject              => 'some short description',
                Body                 => 'the message text',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                HistoryType          => 'EmailCustomer',
                HistoryComment       => 'Customer sent an email',
                UserID               => $TestUserID,
            );
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AgentTicketQueue screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketQueue");

        # Check Blink visual alarm - Oldest class.
        $Self->True(
            $Selenium->find_element( '.Oldest', 'css' ),
            "Visual alarm Blink is found - Oldest class",
        );

        # Check HighlightAge1 visual alarm - OlderLevel1 class.
        $Self->True(
            $Selenium->find_element( '.OlderLevel1', 'css' ),
            "Visual alarm HighlightAge1 is found - OlderLevel1 class",
        );

        # Check HighlightAge2 visual alarm - OlderLevel2 class.
        $Self->True(
            $Selenium->find_element( '.OlderLevel2', 'css' ),
            "Visual alarm HighlightAge2 is found - OlderLevel2 class",
        );

        # Verify that there is no tickets with My Queue filter.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketQueue;QueueID=0;\' )]")->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), $LanguageObject->Translate('No ticket data found.') ) > -1,
            'No tickets found with My Queue filters',
        );

        # Return to default queue view.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketQueue;View=Small");

        # Test if tickets show with appropriate filters.
        TEST:
        for my $Test (@Tests) {
            next TEST if $Test->{State} eq 'new';

            # Check for Queue filter buttons (Postmaster / Raw / Junk / Misc / QueueTest).
            my $Element = $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentTicketQueue;QueueID=$Test->{QueueID};\' )]"
            );
            $Element->is_enabled();
            $Element->is_displayed();

            # Check different views for filters.
            for my $View (qw(Small Medium Preview)) {

                # Return to default small view.
                $Selenium->VerifiedGet(
                    "${ScriptAlias}index.pl?Action=AgentTicketQueue;QueueID=$Test->{QueueID};SortBy=Age;OrderBy=Down;View=Small"
                );

                # Wait until page has finished loading.
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('a[href*=\"Action=AgentTicketQueue;Filter=Unlocked;View=$View;QueueID=$Test->{QueueID};SortBy=Age;OrderBy=Down;View=Small\"]').length;"
                );

                # Click on viewer controller.
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentTicketQueue;Filter=Unlocked;View=$View;QueueID=$Test->{QueueID};SortBy=Age;OrderBy=Down;View=Small;\' )]"
                )->VerifiedClick();

                # Verify that all expected tickets are present.
                for my $TicketID (@TicketIDs) {

                    my %TicketData = $TicketObject->TicketGet(
                        TicketID => $TicketID,
                        UserID   => $TestUserID,
                    );

                    # Check for locked and unlocked tickets.
                    if ( $Test->{Lock} eq 'lock' ) {

                        # For locked tickets we expect no data to be found with 'Available tickets' filter on.
                        $Self->True(
                            index( $Selenium->get_page_source(), $TicketData{TicketNumber} ) == -1,
                            "Ticket is not found on page - $TicketData{TicketNumber}",
                        );

                    }

                    elsif ( ( $TicketData{Lock} eq 'unlock' ) && ( $TicketData{QueueID} eq $Test->{QueueID} ) ) {

                        # Check for tickets with 'Available tickets' filter on.
                        $Self->True(
                            index( $Selenium->get_page_source(), $TicketData{TicketNumber} ) > -1,
                            "Ticket is found on page - $TicketData{TicketNumber} ",
                        );
                    }
                }
            }
        }

        # Test bug #14473 (https://bugs.otrs.org/show_bug.cgi?id=14473).
        # Config 'Ticket::Frontend::Overview::PreviewArticleSenderTypes' does not work.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketQueue;QueueID=$Queues[0]->{QueueID};View=Preview;Filter=Unlocked"
        );
        $Self->True(
            $Selenium->execute_script("return \$('.Content .Preview').length;"),
            "ArticlePreview is found"
        );

        # Enable config 'Ticket::Frontend::Overview::PreviewArticleSenderTypes' and set value
        # to not show customer articles in preview mode.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::Overview::PreviewArticleSenderTypes',
            Value => {
                agent    => 1,
                customer => 0,
                system   => 1,
            },
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        $Self->False(
            $Selenium->execute_script("return \$('.Content .Preview').length;"),
            "ArticlePreview is not found for customer sender type."
        );

        # Go to small view for 'Delete' queue.
        # See Bug 13826 - Queue Names are translated (but should not).
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketQueue;QueueID=$Queues[2]->{QueueID};View=Small;Filter=Unlocked"
        );

        $Self->Is(
            $Selenium->execute_script("return \$('.OverviewBox.Small h1').text().trim();"),
            $LanguageObject->Translate('QueueView') . ": Delete",
            "Title for filtered AgentTicketQueue screen is not translated.",
        );

        # Check state ID for states 'open' and 'new'.
        my $StateObject = $Kernel::OM->Get('Kernel::System::State');
        my $OpenStateID = $StateObject->StateLookup(
            State => 'open',
        );
        my $NewStateID = $StateObject->StateLookup(
            State => 'new',
        );

        # Navigate to test queue view of queue with sub-queue.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketQueue;QueueID=$Queues[1]->{QueueID};View=Small"
        );

        # Click on state column filter.
        $Selenium->execute_script("\$('.ColumnSettingsTrigger[title*=\"Status\"]').click();");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#ColumnFilterState:visible').length;"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#ColumnFilterState option[value=\"$OpenStateID\"]').length"
        );

        # Verify there is only 'open' state to filter from.
        $Self->True(
            $Selenium->execute_script("return \$('#ColumnFilterState option[value=\"$OpenStateID\"]').length;"),
            "'open' state is available as filter selection."
        );
        $Self->False(
            $Selenium->execute_script("return \$('#ColumnFilterState option[value=\"$NewStateID\"]').length;"),
            "'new' state is not available as filter selection."
        );

        # Naviage to test queue view with sub-queue.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketQueue;QueueID=$Queues[1]->{QueueID};View=Small;UseSubQueues=1;"
        );

        # Click on state column filter.
        $Selenium->execute_script("\$('.ColumnSettingsTrigger[title*=\"Status\"]').click();");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#ColumnFilterState:visible').length;"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#ColumnFilterState option[value=\"$OpenStateID\"]').length"
        );

        # Verify there are both 'open' and 'new' state to filter from.
        $Self->True(
            $Selenium->execute_script("return \$('#ColumnFilterState option[value=\"$OpenStateID\"]').length;"),
            "'open' state is available as filter selection with sub-queues."
        );
        $Self->True(
            $Selenium->execute_script("return \$('#ColumnFilterState option[value=\"$NewStateID\"]').length;"),
            "'new' state is available as filter selection with sub-queues."
        );

        # Delete created test tickets.
        my $Success;
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );
            }
            $Self->True(
                $Success,
                "Delete ticket - ID $TicketID"
            );
        }

        # Delete created test queue.
        for my $Queue (@Queues) {
            if ( $Queue->{Created} ) {
                $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
                    SQL => "DELETE FROM queue WHERE id = $Queue->{QueueID}",
                );
                $Self->True(
                    $Success,
                    "Delete queue - ID $Queue->{QueueID}",
                );
            }
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (
            qw (Ticket Queue)
            )
        {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }

        # Unset fixed time.
        $Helper->FixedTimeUnset();

    }
);

1;
