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

use Kernel::System::PostMaster;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Import sample email.
        my $Location   = $ConfigObject->Get('Home') . '/scripts/test/sample/PostMaster/PostMaster-Test26.box';
        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Result   => 'ARRAY',
        );

        # Set ticket number in mail subject to get a follow-up.
        my $TicketNumber = $TicketObject->TicketNumberLookup(
            TicketID => $TicketID,
        );
        my @Content = ();
        for my $Line ( @{$ContentRef} ) {
            if ( $Line =~ /^Subject:/ ) {
                $Line = 'Subject: '
                    . $ConfigObject->Get('Ticket::Hook')
                    . $TicketNumber
                    . ' inline attachment test';
            }
            push @Content, $Line;
        }

        my @Return;

        # Execute PostMaster with the read email.
        {
            my $CommunicationLogObject = $Kernel::OM->Create(
                'Kernel::System::CommunicationLog',
                ObjectParams => {
                    Transport => 'Email',
                    Direction => 'Incoming',
                },
            );
            $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

            my $PostMasterObject = Kernel::System::PostMaster->new(
                CommunicationLogObject => $CommunicationLogObject,
                Email                  => \@Content,
            );

            @Return = $PostMasterObject->Run();

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Message',
                Status        => 'Successful',
            );
            $CommunicationLogObject->CommunicationStop(
                Status => 'Successful',
            );
        }

        # Check we actually got a follow-up.
        $Self->Is(
            $Return[0] || 0,
            2,
            'PostMaster::Run() - FollowUp'
        );

        # Check we actually got the same ticket ID.
        $Self->Is(
            $Return[1] || 0,
            $TicketID,
            'PostMaster::Run() - FollowUp/TicketID'
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Zoom the test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check if all attachments are displayed correctly.
        my @Tests = (
            {
                Name       => 'Plain text attachment',
                Attachment => 'file-1',
            },
            {
                Name       => 'PGP signature',
                Attachment => 'signature.asc',
            },
            {
                Name       => 'PDF attachment',
                Attachment => 'StdAttachment-Test1.pdf',
            },
        );

        for my $Test (@Tests) {
            $Selenium->find_element(
                "//ul[\@class='ArticleAttachments']/li/h5[contains(text(), '$Test->{Attachment}')]"
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
            "Ticket with ticket ID $TicketID is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
