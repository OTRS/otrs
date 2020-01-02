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

# Get selenium object.
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # Get helper object.
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Hide Fred.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Fred::Active',
            Value => 0
        );

        # Get ticket object.
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Get RandomID.
        my $RandomID = $Helper->GetRandomID();

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket ID $TicketID is created",
        );

        # Get FormDraft object.
        my $FormDraftObject = $Kernel::OM->Get('Kernel::System::FormDraft');

        # Create FormDrafts in each different Action.
        my @FormDrafts;
        for my $Action (
            qw(Close Compose EmailOutbound Forward FreeText Move Note Owner Pending PhoneInbound PhoneOutbound Priority)
            )
        {
            my $Title        = $Action . 'FormDraft' . $RandomID;
            my $FormDraftAdd = $FormDraftObject->FormDraftAdd(
                FormData => {
                    Subject => 'UnitTest Subject',
                    Body    => 'UnitTest Body',
                },
                ObjectType => 'Ticket',
                ObjectID   => $TicketID,
                Action     => 'AgentTicket' . $Action,
                Title      => $Title,
                UserID     => 1,
            );
            $Self->True(
                $FormDraftAdd,
                "FormDraftAdd $Title is created",
            );
            push @FormDrafts, $Title;
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

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Verify created test FormDrafts are visible in AgentTicketZoom screen.
        for my $FormDraftVerify (@FormDrafts) {
            $Self->True(
                index( $Selenium->get_page_source(), $FormDraftVerify ) > -1,
                "FormDraft $FormDraftVerify is found",
            );
        }

        # Delete created test ticket.
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
            "Ticket ID $TicketID is deleted"
        );
    }
);

1;
