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
        my $Helper         = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ACLObject      = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');
        my $TypeObject     = $Kernel::OM->Get('Kernel::System::Type');
        my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');
        my $QueueObject    = $Kernel::OM->Get('Kernel::System::Queue');
        my $ServiceObject  = $Kernel::OM->Get('Kernel::System::Service');
        my $SLAObject      = $Kernel::OM->Get('Kernel::System::SLA');
        my $CacheObject    = $Kernel::OM->Get('Kernel::System::Cache');

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
            Key   => 'Ticket::Service',
            Value => 1,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate()
            || die "Did not get test customer user";

        # Enable some fields in AgentTicketFreeText.
        for my $Field (qw(Type Priority Queue Service SLA)) {
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => "Ticket::Frontend::AgentTicketFreeText###$Field",
                Value => 1,
            );
        }

        # Create test types.
        my @TypeIDs;
        my @TypeNames;
        for my $Count ( 1 .. 2 ) {
            my $Name   = "Type$Count-$RandomID";
            my $TypeID = $TypeObject->TypeAdd(
                Name    => $Name,
                ValidID => 1,
                UserID  => 1,
            );
            $Self->True(
                $TypeID,
                "TypeID $TypeID is created",
            );
            push @TypeIDs,   $TypeID;
            push @TypeNames, $Name;
        }

        # Create test priorities.
        my @PriorityIDs;
        my @PriorityNames;
        for my $Count ( 1 .. 2 ) {
            my $Name       = "Priority$Count-$RandomID";
            my $PriorityID = $PriorityObject->PriorityAdd(
                Name    => $Name,
                ValidID => 1,
                UserID  => 1,
            );
            $Self->True(
                $PriorityID,
                "PriorityID $PriorityID is created",
            );
            push @PriorityIDs,   $PriorityID;
            push @PriorityNames, $Name;
        }

        # Create test queues.
        my @QueueIDs;
        my @QueueNames;
        for my $Count ( 1 .. 2 ) {
            my $Name    = "Queue$Count-$RandomID";
            my $QueueID = $QueueObject->QueueAdd(
                Name            => $Name,
                ValidID         => 1,
                GroupID         => 1,
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => 1,
                UserID          => 1,
                Comment         => 'Selenium Test Queue',
            );
            $Self->True(
                $QueueID,
                "QueueID $QueueID is created",
            );
            push @QueueIDs,   $QueueID;
            push @QueueNames, $Name;
        }

        # Create test services.
        my @ServiceIDs;
        my @ServiceNames;
        for my $Count ( 1 .. 2 ) {
            my $Name      = "Service$Count-$RandomID";
            my $ServiceID = $ServiceObject->ServiceAdd(
                Name    => $Name,
                ValidID => 1,
                UserID  => 1,
            );
            $Self->True(
                $ServiceID,
                "ServiceID $ServiceID is created"
            );
            push @ServiceIDs,   $ServiceID;
            push @ServiceNames, $Name;

            # Add member customer user to the test service.
            $ServiceObject->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $TestCustomerUserLogin,
                ServiceID         => $ServiceID,
                Active            => 1,
                UserID            => 1,
            );
        }

        # Create test SLAs.
        my @SLAIDs;
        my @SLANames;
        for my $Count ( 1 .. 2 ) {
            my $Name  = "SLA$Count-$RandomID";
            my $SLAID = $SLAObject->SLAAdd(
                ServiceIDs => \@ServiceIDs,
                Name       => $Name,
                ValidID    => 1,
                UserID     => 1,
            );
            $Self->True(
                $SLAID,
                "SLAID $SLAID is created"
            );
            push @SLAIDs,   $SLAID;
            push @SLANames, $Name;
        }

        # Create 2 ACLs:
        # 1. Disable all
        # 2. PossibleAdd appropriate attributes, Match "Frontend->Action->[RegExp]^Agent".
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TicketAcl',
            Value => {
                'SeleniumTestACL-1' => {
                    PossibleNot => {
                        Ticket => {
                            Priority => ['[RegExp].+'],
                            Queue    => ['[RegExp].+'],
                            Type     => ['[RegExp].+'],
                            Service  => ['[RegExp].+'],
                            SLA      => ['[RegExp].+'],
                        }
                    },
                    Properties     => {},
                    StopAfterMatch => 0,
                },
                'SeleniumTestACL-2' => {
                    PossibleAdd => {
                        Ticket => {
                            Priority => \@PriorityNames,
                            Queue    => \@QueueNames,
                            Type     => \@TypeNames,
                            Service  => \@ServiceNames,
                            SLA      => \@SLANames,
                        }
                    },
                    Properties => {
                        Frontend => {
                            Action => ['[RegExp]^AgentTicket'],
                        },
                    },
                    StopAfterMatch => 0,
                },
            },
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Ticket Title',
            Queue        => $QueueNames[0],
            Type         => $TypeNames[0],
            Service      => $ServiceNames[0],
            SLA          => $SLANames[0],
            Priority     => $PriorityNames[0],
            Lock         => 'unlock',
            State        => 'open',
            CustomerID   => '123465',
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

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
                ID    => 'TypeID',
                Value => $TypeIDs[1],
            },
            {
                Field => 'QueueID',
                ID    => 'NewQueueID',
                Value => $QueueIDs[1],
            },
            {
                ID    => 'ServiceID',
                Value => $ServiceIDs[1],
            },
            {
                ID    => 'SLAID',
                Value => $SLAIDs[1],
            },
        );

        for my $Test (@Tests) {

            # Navigate to AgentTicketFreeText screen.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketFreeText;TicketID=$TicketID");

            # Select the second value.
            $Selenium->InputFieldValueSet(
                Element => '#' . $Test->{ID},
                Value   => $Test->{Value},
            );

            $Selenium->execute_script(
                "\$('#submitRichText')[0].scrollIntoView(true);",
            );
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#submitRichText').length;"
                ),
                "Element '#submitRichText' is found in screen"
            );
            $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

            $CacheObject->CleanUp( Type => 'Ticket' );

            # Check if the value is changed.
            my %Ticket = $TicketObject->TicketGet(
                TicketID => $TicketID,
                UserID   => 1,
            );

            # Change because attribute and field ID are different.
            if ( $Test->{Field} ) {
                $Test->{ID} = $Test->{Field};
            }

            $Self->Is(
                $Ticket{ $Test->{ID} },
                $Test->{Value},
                "$Test->{ID} is changed succesfully",
            );
        }

        # Navigate to AgentTicketFreeText screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketFreeText;TicketID=$TicketID");

        # Check if test priorities exist in screen.
        for my $PriorityID (@PriorityIDs) {
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#NewPriorityID option[value=$PriorityID]').length;"
                ),
                "PriorityID $PriorityID is found",
            );
        }

        # Cleanup.

        # Delete test ticket.
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
            "TicketID $TicketID is deleted"
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete customer user referenced for service.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM service_customer_user WHERE customer_user_login = ?",
            Bind => [ \$TestCustomerUserLogin ],
        );
        $Self->True(
            $Success,
            "CustomerUser-Service relation for customer user '$TestCustomerUserLogin' is deleted",
        );

        for my $SLAID (@SLAIDs) {

            # Delete Service-SLA relation.
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM service_sla WHERE sla_id = ?",
                Bind => [ \$SLAID ],
            );
            $Self->True(
                $Success,
                "Service-SLA relation for SLAID $SLAID is deleted",
            );

            # Delete test SLAs.
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM sla WHERE id = ?",
                Bind => [ \$SLAID ],
            );
            $Self->True(
                $Success,
                "SLAID $SLAID is deleted",
            );
        }

        # Delete test services.
        for my $ServiceID (@ServiceIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM service WHERE id = ?",
                Bind => [ \$ServiceID ],
            );
            $Self->True(
                $Success,
                "ServiceID $ServiceID is deleted",
            );
        }

        # Delete test queues.
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

        # Delete test priorities.
        for my $PriorityID (@PriorityIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM ticket_priority WHERE id = ?",
                Bind => [ \$PriorityID ],
            );
            $Self->True(
                $Success,
                "PriorityID $PriorityID is deleted"
            );
        }

        # Delete test types.
        for my $TypeID (@TypeIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM ticket_type WHERE id = ?",
                Bind => [ \$TypeID ],
            );
            $Self->True(
                $Success,
                "TypeID $TypeID is deleted",
            );
        }

        # Make sure the cache is correct.
        for my $Cache (qw( Ticket Priority Queue Type Service SLA )) {
            $CacheObject->CleanUp( Type => $Cache );
        }

    },
);

1;
