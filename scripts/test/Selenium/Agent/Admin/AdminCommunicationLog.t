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

        # Disable check of email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Disable the rich text control.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Use test email backend for duration of the test.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::DoNotSendEmail',
        );

        my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

        # Clean up all existing communications.
        $Self->True(
            $CommunicationLogDBObj->CommunicationDelete(),
            'Cleaned up existing communications'
        );

        my $RandomID = $Helper->GetRandomID();

        my $MailAccountObject = $Kernel::OM->Get('Kernel::System::MailAccount');

        # Create test mail accounts.
        my %MailAccounts;
        for my $Type (qw(IMAP IMAPS IMAPTLS)) {
            my $MailAccountID = $MailAccountObject->MailAccountAdd(
                Login         => $RandomID,
                Password      => 'SomePassword',
                Host          => lc($Type) . '.example.com',
                Type          => $Type,
                ValidID       => 1,
                Trusted       => 0,
                IMAPFolder    => 'INBOX',
                DispatchingBy => 'Queue',
                QueueID       => 1,
                UserID        => 1,
            );

            $Self->True(
                $MailAccountID,
                "MailAccountAdd - Added $Type mail account"
            );

            my %MailAccount = $MailAccountObject->MailAccountGet(
                ID => $MailAccountID,
            );
            $MailAccounts{$MailAccountID} = \%MailAccount;
        }

        # First, create some test logs for mail accounts.
        MAILACCOUNT:
        for my $MailAccountID ( sort keys %MailAccounts ) {

            # Skip IMAPS account for now.
            next MAILACCOUNT if $MailAccounts{$MailAccountID}->{Type} eq 'IMAPS';

            # Start a new incoming communication.
            my $CommunicationLogObject = $Kernel::OM->Create(
                'Kernel::System::CommunicationLog',
                ObjectParams => {
                    Transport   => 'Email',
                    Direction   => 'Incoming',
                    AccountType => $MailAccounts{$MailAccountID}->{Type},
                    AccountID   => $MailAccountID,
                },
            );

            $CommunicationLogObject->ObjectLogStart(
                ObjectLogType => 'Connection',
            );

            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Debug',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value =>
                    "Open connection to '$MailAccounts{$MailAccountID}->{Host}' ($MailAccounts{$MailAccountID}->{Login}).",
            );

            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Notice',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value =>
                    "1 messages available for fetching ($MailAccounts{$MailAccountID}->{Login}/$MailAccounts{$MailAccountID}->{Host}).",
            );

            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Debug',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value         => "Prepare fetching of message '1/1' (Size: 12.3 KB) from server.",
            );

            # Fetch a single message from each account.
            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Debug',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value         => "Message '1' successfully received from server.",
            );

            $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

            my $MessageStatus = 'Successful';

            # In case of IMAP, fail the message only.
            if ( $MailAccounts{$MailAccountID}->{Type} eq 'IMAP' ) {
                $CommunicationLogObject->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Error',
                    Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                    Value =>
                        "Could not process message. Raw mail saved (report it on http://bugs.otrs.org/)!",
                );

                $MessageStatus = 'Failed';
            }

            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Debug',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value         => "Message '1' marked for deletion.",
            );

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Message',
                Status        => $MessageStatus,
            );

            # Close the connection successfully.
            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Info',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value         => $MessageStatus eq 'Failed'
                ?
                    "Fetched 0 message(s) from server ($MailAccounts{$MailAccountID}->{Login}/$MailAccounts{$MailAccountID}->{Host})."
                :
                    "Fetched 1 message(s) from server ($MailAccounts{$MailAccountID}->{Login}/$MailAccounts{$MailAccountID}->{Host}).",
            );

            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Debug',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value =>
                    "Executed deletion of marked messages from server ($MailAccounts{$MailAccountID}->{Login}/$MailAccounts{$MailAccountID}->{Host}).",
            );

            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Debug',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value         => "Connection to '$MailAccounts{$MailAccountID}->{Host}' closed.",
            );

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Connection',
                Status        => 'Successful',
            );

            $CommunicationLogObject->CommunicationStop(
                Status => $MessageStatus,
            );
        }

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die 'Did not get test user';

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminCommunicationLog screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCommunicationLog;Expand=1;");

        $Selenium->execute_script('window.Core.App.PageLoadComplete = false;');

        # Set Time Range to 'All Communication', see bug#14379
        $Selenium->InputFieldValueSet(
            Element => '#TimeRange',
            Value   => '0',
        );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # Verify status widgets show successful accounts and failed communications.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.GridView .ItemListGrid .Successful').length;"
            ),
            1,
            'Successful account status'
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.GridView .ItemListGrid .Failed').length;"
            ),
            1,
            'Failed communication'
        );

        # Filter for successful communications.
        $Selenium->find_element( 'Successful (1)', 'link_text' )->VerifiedClick();

        # Verify one communication is shown.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('table#CommunicationsTable tbody tr:visible').length;"
            ),
            1,
            'Test communication filtered properly (Successful)'
        );

        # Filter for failed communications.
        $Selenium->find_element( 'Failed (1)', 'partial_link_text' )->VerifiedClick();

        # Verify one communication is shown.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('table#CommunicationsTable tbody tr:visible').length;"
            ),
            1,
            'Test communication filtered properly (Failed)'
        );

        # Add one failing communication for the IMAPTLS account.
        my %MailAccountLookup = map { $_->{Type} => $_->{ID} } values %MailAccounts;
        for my $MailAccountType (qw(IMAPTLS)) {
            my $MailAccountID = $MailAccountLookup{$MailAccountType};

            my $CommunicationLogObject = $Kernel::OM->Create(
                'Kernel::System::CommunicationLog',
                ObjectParams => {
                    Transport   => 'Email',
                    Direction   => 'Incoming',
                    AccountType => $MailAccounts{$MailAccountID}->{Type},
                    AccountID   => $MailAccountID,
                },
            );

            $CommunicationLogObject->ObjectLogStart(
                ObjectLogType => 'Connection',
            );

            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Debug',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value =>
                    "Open connection to '$MailAccounts{$MailAccountID}->{Host}' ($MailAccounts{$MailAccountID}->{Login}).",
            );

            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value =>
                    "Something went wrong while trying to connect to 'IMAP => $MailAccounts{$MailAccountID}->{Login}/$MailAccounts{$MailAccountID}->{Host}'.",
            );

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Connection',
                Status        => 'Failed',
            );

            $CommunicationLogObject->CommunicationStop(
                Status => 'Failed',
            );
        }

        $Selenium->VerifiedRefresh();

        # Verify status widgets show failing communication.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.GridView .ItemListGrid .Failed').length;"
            ),
            1,
            'Failing communications status'
        );

        # Warning is shown because IMAPTLS has one successful and one failing communication.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.GridView .ItemListGrid .Warning').length;"
            ),
            1,
            'Warning mail account status'
        );

        # Filter for unsuccessful communications.
        $Selenium->find_element( 'Failed (2)', 'link_text' )->VerifiedClick();

        # Verify two communications are shown.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('table#CommunicationsTable tbody tr:visible').length;"
            ),
            2,
            'Test communications filtered properly (Failed)'
        );

        # Add one failing communication for the IMAPS account.
        for my $MailAccountType (qw(IMAPS)) {
            my $MailAccountID = $MailAccountLookup{$MailAccountType};

            my $CommunicationLogObject = $Kernel::OM->Create(
                'Kernel::System::CommunicationLog',
                ObjectParams => {
                    Transport   => 'Email',
                    Direction   => 'Incoming',
                    AccountType => $MailAccounts{$MailAccountID}->{Type},
                    AccountID   => $MailAccountID,
                },
            );

            $CommunicationLogObject->ObjectLogStart(
                ObjectLogType => 'Connection',
            );

            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Debug',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value =>
                    "Open connection to '$MailAccounts{$MailAccountID}->{Host}' ($MailAccounts{$MailAccountID}->{Login}).",
            );

            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailAccount::' . $MailAccounts{$MailAccountID}->{Type},
                Value =>
                    "Something went wrong while trying to connect to 'IMAP => $MailAccounts{$MailAccountID}->{Login}/$MailAccounts{$MailAccountID}->{Host}'.",
            );

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Connection',
                Status        => 'Failed',
            );

            $CommunicationLogObject->CommunicationStop(
                Status => 'Failed',
            );
        }

        $Selenium->VerifiedRefresh();

        # Verify status widgets show failing account status and communications.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.GridView .ItemListGrid .Failed').length;"
            ),
            2,
            'Failing account status and communications'
        );

        # Filter for unsuccessful communications.
        $Selenium->find_element( 'Failed (3)', 'link_text' )->VerifiedClick();

        # Verify three communications are shown.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('table#CommunicationsTable tbody tr:visible').length;"
            ),
            3,
            'Test communications filtered properly (Failed)'
        );

        # Click 'Failing accounts' for account overview.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminCommunicationLog;Subaction=Accounts' )]")
            ->VerifiedClick();

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#AccountsWidget.Loading").length == 0;'
        );

        # Verify all three possible states are displayed next to accounts.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#AccountsTable td.Status .Error').length;"
            ),
            1,
            'Failing state display'
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#AccountsTable td.Status .Warning').length;"
            ),
            1,
            'Warning state display'
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#AccountsTable td.Status .Confirmation').length;"
            ),
            1,
            'Successful state display'
        );

        # Click on single communication for zoom screen.
        $Selenium->find_element( '.MasterActionLink', 'css' )->VerifiedClick();

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#CommunicationObjectWidget.Loading").length == 0;'
        );

        # Verify test account login is shown in the log.
        $Self->True(
            index( $Selenium->get_page_source(), "($RandomID)" ) > -1,
            'Test account login displayed correctly'
        );

        # Limit log level to 'Error' only.
        $Selenium->InputFieldValueSet(
            Element => '#PriorityFilter',
            Value   => 'Error',
        );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#CommunicationObjectWidget.Loading").length == 0 && $("#ObjectLogListTable tbody tr:visible").length == 1;'
        );

        # Verify only one log entry is shown.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ObjectLogListTable tbody tr:visible').length;"
            ),
            1,
            'Error log filtered correctly'
        );

        # Try to navigate to invalid Communication ID,
        #   see bug#13523 (https://bugs.otrs.org/show_bug.cgi?id=13523).
        my $RandomNumber = $Helper->GetRandomNumber();
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminCommunicationLog;Subaction=Zoom;CommunicationID=$RandomNumber"
        );

        # Verify error screen.
        $Selenium->find_element( 'div.ErrorScreen', 'css' );

        # Clean up all communications created by the test.
        $Self->True(
            $CommunicationLogDBObj->CommunicationDelete(),
            'Cleaned up test communications'
        );

        # Clean up mail accounts.
        for my $MailAccountID ( sort keys %MailAccounts ) {
            my $Success = $MailAccountObject->MailAccountDelete(
                ID => $MailAccountID,
            );
            $Self->True(
                $Success,
                "MailAccountDelete - Deleted test mail account $MailAccountID"
            );
        }
    }
);

1;
