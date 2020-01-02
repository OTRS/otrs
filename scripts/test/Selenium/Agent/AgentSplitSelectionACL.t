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
        my $ACLObject            = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        # Import test ACL.
        $ACLObject->ACLImport(
            Content => <<"EOF",
- ChangeBy: root\@localhost
  ChangeTime: 2018-07-04 03:08:58
  Comment: ''
  ConfigChange:
    PossibleNot:
      Action:
        - AgentTicketEmail
  ConfigMatch:
    Properties:
      Ticket:
        State:
        - new
  CreateBy: root\@localhost
  CreateTime: 2018-07-04 02:55:35
  Description: ''
  ID: '1'
  Name: ThisIsAUnitTestACL-1
  StopAfterMatch: 0
  ValidID: '1'
- ChangeBy: root\@localhost
  ChangeTime: 2018-07-04 03:08:58
  Comment: ''
  ConfigChange:
    PossibleNot:
      Action:
        - AgentTicketPhone
  ConfigMatch:
    Properties:
      Ticket:
        State:
        - open
  CreateBy: root\@localhost
  CreateTime: 2018-07-04 02:55:35
  Description: ''
  ID: '2'
  Name: ThisIsAUnitTestACL-2
  StopAfterMatch: 0
  ValidID: '1'
EOF
            OverwriteExistingEntities => 1,
            UserID                    => 1,
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => "customer1\@localhost.com",
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketCreateID $TicketID is created",
        );

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
            UserID               => 1,
        );
        $Self->True(
            $TicketID,
            "ArticleID $ArticleID is created",
        );

        # create and login test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # After login, we need to navigate to the ACL deployment to make the imported ACL work.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");
        $Self->False(
            index(
                $Selenium->get_page_source(),
                'ACL information from database is not in sync with the system configuration, please deploy all ACLs.'
                )
                > -1,
            "ACL deployment successful."
        );

        # Navigate to AgentTicketZoom screen of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Click on the split action. First ACL is in action, expecting 'Phone Ticket' selection to be
        #   enabled and 'Email Ticket' selection to be disabled.
        $Selenium->find_element( '.SplitSelection', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return $("#SplitSubmit").length'
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$(\"#SplitSelection option[value='PhoneTicket']\").length === 1"
            ),
            "Split option for 'Phone Ticket' is enabled.",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$(\"#SplitSelection option[value='EmailTicket']\").length === 0"
            ),
            "Split option for 'Email Ticket' is disabled.",
        );
        $Selenium->find_element( '.Close', 'css' )->click();

        # Update state to 'open' to trigger second test ACL.
        my $Success = $TicketObject->TicketStateSet(
            State    => 'open',
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "TicketID $TicketID is set to 'open' state"
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Click on the split action. Second ACL is in action, expecting 'Phone Ticket' selection to be
        #   disabled and 'Email Ticket' selection to be enabled.
        $Selenium->find_element( '.SplitSelection', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return $("#SplitSubmit").length'
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$(\"#SplitSelection option[value='PhoneTicket']\").length === 0"
            ),
            "Split option for 'Phone Ticket' is disabled.",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$(\"#SplitSelection option[value='EmailTicket']\").length === 1"
            ),
            "Split option for 'Email Ticket' is enabled.",
        );
        $Selenium->find_element( '.Close', 'css' )->click();

        # Delete test ACLs rules.
        for my $Count ( 1 .. 2 ) {
            my $ACLData = $ACLObject->ACLGet(
                Name   => 'ThisIsAUnitTestACL-' . $Count,
                UserID => 1,
            );

            $Success = $ACLObject->ACLDelete(
                ID     => $ACLData->{ID},
                UserID => 1,
            );
            $Self->True(
                $Success,
                "ACL with ID $ACLData->{ID} is deleted"
            );
        }

        # Deploy again after we deleted the test ACL.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");
        $Self->False(
            index(
                $Selenium->get_page_source(),
                'ACL information from database is not in sync with the system configuration, please deploy all ACLs.'
                )
                > -1,
            "ACL deployment successful."
        );

        # Delete created test tickets.
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
            "Ticket with ticket ID $TicketID is deleted"
        );
    },
);

1;
