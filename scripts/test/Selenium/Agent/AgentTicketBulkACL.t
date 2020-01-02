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

        my @Fields = (
            {
                ID   => 'StateID',
                Name => 'state',
            },
            {
                ID   => 'TypeID',
                Name => 'type',
            },
            {
                ID   => 'QueueID',
                Name => 'queue',
            },
            {
                ID   => 'OwnerID',
                Name => 'owner',
            },
            {
                ID   => 'ResponsibleID',
                Name => 'responsible',
            },
            {
                ID   => 'PriorityID',
                Name => 'priority',
            },

        );

        my $CheckFieldOptions = sub {
            my %Param = @_;
            FIELD:
            for my $Field (@Fields) {
                if ( $Param{Restricted}->{ $Field->{ID} } ) {
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('#$Field->{ID} option:not([value=\"\"])').length"
                        ),
                        1,
                        "There there is only one option in the $Field->{Name} selection",
                    );
                    next FIELD;
                }
                $Self->IsNot(
                    $Selenium->execute_script(
                        "return \$('#$Field->{ID} option:not([value=\"\"])').length"
                    ),
                    1,
                    "There there are many options in the $Field->{Name} selection",
                );
            }
        };

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ACLObject    = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my $RandomID = $Helper->GetRandomID();

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckMXRecord',
            Value => 0,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Responsible',
            Value => 1,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketBulk###State',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketBulk###TicketType',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketBulk###Owner',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketBulk###Responsible',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketBulk###Priority',
            Value => 1,
        );

        # Create test user and login.
        my $TestUserLogin1 = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        my $UserID1    = $UserObject->UserLookup(
            UserLogin => $TestUserLogin1,
        );
        my ( $TestUserLogin2, $UserID2 ) = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        );

        # Create new ticket types
        my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');
        my $TypeID1    = $TypeObject->TypeAdd(
            Name    => "Type1$RandomID",
            ValidID => 1,
            UserID  => 1,
        );
        my $TypeID2 = $TypeObject->TypeAdd(
            Name    => "Type2$RandomID",
            ValidID => 1,
            UserID  => 1,
        );

        # Import test ACL.
        $ACLObject->ACLImport(
            Content => <<"EOF",
- ChangeBy: root\@localhost
  ChangeTime: 2016-02-16 03:08:58
  Comment: ''
  ConfigChange:
    Possible:
      Ticket:
        Type:
        - Type1$RandomID
  ConfigMatch:
    Properties:
      Ticket:
        State:
        - open
  CreateBy: root\@localhost
  CreateTime: 2016-02-16 02:55:35
  Description: ''
  ID: '1'
  Name: ThisIsAUnitTestACL-1
  StopAfterMatch: 0
  ValidID: '1'
- ChangeBy: root\@localhost
  ChangeTime: 2016-02-16 03:08:58
  Comment: ''
  ConfigChange:
    Possible:
      Ticket:
        Queue:
        - Postmaster
  ConfigMatch:
    Properties:
      Ticket:
        Type:
        - Type2$RandomID
  CreateBy: root\@localhost
  CreateTime: 2016-02-16 02:55:35
  Description: ''
  ID: '2'
  Name: ThisIsAUnitTestACL-2
  StopAfterMatch: 0
  ValidID: '1'
- ChangeBy: root\@localhost
  ChangeTime: 2016-02-16 03:08:58
  Comment: ''
  ConfigChange:
    Possible:
      Ticket:
        Owner:
        - '[regexp]$TestUserLogin1'
  ConfigMatch:
    Properties:
      Ticket:
        Queue:
        - Misc
  CreateBy: root\@localhost
  CreateTime: 2016-02-16 02:55:35
  Description: ''
  ID: '3'
  Name: ThisIsAUnitTestACL-3
  StopAfterMatch: 0
  ValidID: '1'
- ChangeBy: root\@localhost
  ChangeTime: 2016-02-16 03:08:58
  Comment: ''
  ConfigChange:
    Possible:
      Ticket:
        Responsible:
        - '[regexp]$TestUserLogin1'
  ConfigMatch:
    Properties:
      Ticket:
        Owner:
        - $TestUserLogin2
  CreateBy: root\@localhost
  CreateTime: 2016-02-16 02:55:35
  Description: ''
  ID: '4'
  Name: ThisIsAUnitTestACL-4
  StopAfterMatch: 0
  ValidID: '1'
- ChangeBy: root\@localhost
  ChangeTime: 2016-02-16 03:08:58
  Comment: ''
  ConfigChange:
    Possible:
      Ticket:
        Priority:
        - 1 very low
  ConfigMatch:
    Properties:
      Ticket:
        Responsible:
        - $TestUserLogin2
  CreateBy: root\@localhost
  CreateTime: 2016-02-16 02:55:35
  Description: ''
  ID: '5'
  Name: ThisIsAUnitTestACL-5
  StopAfterMatch: 0
  ValidID: '1'
- ChangeBy: root\@localhost
  ChangeTime: 2016-02-16 03:08:58
  Comment: ''
  ConfigChange:
    Possible:
      Ticket:
        State:
        - open
  ConfigMatch:
    Properties:
      Ticket:
        Priority:
        - 2 low
  CreateBy: root\@localhost
  CreateTime: 2016-02-16 02:55:35
  Description: ''
  ID: '6'
  Name: ThisIsAUnitTestACL-6
  StopAfterMatch: 0
  ValidID: '1'
EOF
            OverwriteExistingEntities => 1,
            UserID                    => 1,
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin1,
            Password => $TestUserLogin1,
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

        # Add a customer.
        my $CustomerUserLogin = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            UserFirstname  => 'Huber',
            UserLastname   => 'Manfred',
            UserCustomerID => 'A124',
            UserLogin      => 'customeruser_' . $Helper->GetRandomID(),
            UserPassword   => 'some-pass',
            UserEmail      => $Helper->GetRandomID() . '@localhost.com',
            ValidID        => 1,
            UserID         => 1,
        );

        # Create test tickets.
        my $TicketID1 = $TicketObject->TicketCreate(
            Title        => 'Selenium Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => $CustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID1,
            "TicketCreate - ID $TicketID1",
        );
        my $TicketID2 = $TicketObject->TicketCreate(
            Title        => 'Selenium Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => $CustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID2,
            "TicketCreate - ID $TicketID2",
        );

        # Navigate to AgentTicketStatusView to select all tickets.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # Wait until page has loaded
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SelectAllTickets").length' );

        # Select all tickets.
        $Selenium->execute_script("\$('#SelectAllTickets').click()");

        # click on 'Bulk' and switch window
        $Selenium->find_element( "Bulk", 'link_text' )->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#StateID").length' );

        # State
        # Check field restrictions
        $CheckFieldOptions->( Restricted => {} );

        # Set open state and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#StateID',
            Value   => 4,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => { TypeID => 1 } );

        # Set another state and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#StateID',
            Value   => 2,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => {} );

        # Type
        # Set test 2 type and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#TypeID',
            Value   => $TypeID2,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => { QueueID => 1 } );

        # Set another type and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#TypeID',
            Value   => $TypeID1,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => {} );

        # Queue
        # Set Misc queue and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => 4,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => { OwnerID => 1 } );

        # Set another queue and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => 1,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => {} );

        # Owner
        # Set test 2 owner and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#OwnerID',
            Value   => $UserID2,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => { ResponsibleID => 1 } );

        # Set another owner and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#OwnerID',
            Value   => $UserID1,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => {} );

        # Responsible
        # Set test 2 responsible and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#ResponsibleID',
            Value   => $UserID2,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => { PriorityID => 1 } );

        # Set another responsible and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#ResponsibleID',
            Value   => $UserID1,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => {} );

        # Priority
        # Set priority 2 and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#PriorityID',
            Value   => 2,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => { StateID => 1 } );

        # Set another priority and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#PriorityID',
            Value   => 3,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Check field restrictions
        $CheckFieldOptions->( Restricted => {} );

        # Cleanup

        # Delete test ACLs rules.
        for my $Count ( 1 .. 6 ) {
            my $ACLData = $ACLObject->ACLGet(
                Name   => 'ThisIsAUnitTestACL-' . $Count,
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

        for my $TicketID ( $TicketID1, $TicketID2 ) {

            # Delete created test tickets.
            my $Success = $TicketObject->TicketDelete(
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
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$CustomerUserLogin ],
        );
        $Self->True(
            $Success,
            "Deleted Customer $CustomerUserLogin",
        );

        # Delete ticket types
        for my $TypeID ( $TypeID1, $TypeID2 ) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM ticket_type WHERE id = ?",
                Bind => [ \$TypeID ],
            );
            $Self->True(
                $Success,
                "Deleted Type with ID $TypeID",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw( CustomerUser Type )) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    },
);

1;
