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

        # Set to change queue for ticket in a new window.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MoveType',
            Value => 'link'
        );

        # Import test ACL.
        $ACLObject->ACLImport(
            Content => <<"EOF",
- ChangeBy: root\@localhost
  ChangeTime: 2018-10-23 14:57:08
  Comment: ''
  ConfigChange:
    Possible:
      Ticket:
        State:
        - closed successful
  ConfigMatch:
    Properties:
      Frontend:
        Action:
        - AgentTicketClose
        - AgentTicketMove
        - AgentTicketCompose
      Ticket:
        Queue:
        - Raw
  CreateBy: root\@localhost
  CreateTime: 2018-10-23 14:30:24
  Description: ''
  ID: '1'
  Name: ThisIsAUnitTestACL
  StopAfterMatch: 0
  ValidID: '1'
EOF
            OverwriteExistingEntities => 1,
            UserID                    => 1,
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

        # Get test user ID.
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
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
            OwnerID      => $UserID,
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

        my @Tests = (
            {
                Name          => 'Check ACL on AgentTicketMove',
                Action        => "AgentTicketMove;TicketID=$TicketID",
                Count         => 2,
                StateSelector => "NewStateID",
            },
            {
                Name          => 'Check ACL on AgentTicketClose',
                Action        => "AgentTicketClose;TicketID=$TicketID",
                Count         => 1,
                StateSelector => "NewStateID",
            },
            {
                Name          => 'Check ACL on AgentTicketCompose',
                Action        => "AgentTicketCompose&TicketID=$TicketID&ArticleID=$ArticleID&ResponseID=1",
                Count         => 2,
                StateSelector => "StateID",
            },
        );

        for my $Test (@Tests) {

            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$Test->{Action}");

            # Check if ACL works on the screen.
            # Check if there is only 'closed successful' state on the screen.
            $Self->Is(
                $Selenium->execute_script("return \$('#$Test->{StateSelector} option').length;"),
                $Test->{Count},    # there are two option, posible none is enabled
                "There is only one state on the screen"
            ) || die;
            $Self->True(
                $Selenium->execute_script("return \$('#$Test->{StateSelector} option[value=2]').length;"),
                "There is only 'closed successful' state on the screen"
            ) || die;
        }

        # Delete test ACLs rules.
        my $ACLData = $ACLObject->ACLGet(
            Name   => 'ThisIsAUnitTestACL',
            UserID => 1,
        );

        my $Success = $ACLObject->ACLDelete(
            ID     => $ACLData->{ID},
            UserID => 1,
        );
        $Self->True(
            $Success,
            "ACL with ID $ACLData->{ID} is deleted"
        );

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
