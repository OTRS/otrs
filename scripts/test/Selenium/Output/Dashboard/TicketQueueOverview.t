# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # disable all dashboard plugins
        my $Config = $Kernel::OM->Get('Kernel::Config')->Get('DashboardBackend');
        $SysConfigObject->ConfigItemUpdate(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => \%$Config,
        );

        # reset TicketQueueOverview dashboard sysconfig
        $SysConfigObject->ConfigItemReset(
            Name => 'DashboardBackend###0270-TicketQueueOverview',
        );

        # create test queue
        my $QueueName = "Queue" . $Helper->GetRandomID();
        my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Selenium Queue',
            UserID          => 1,
        );
        $Self->True(
            $QueueID,
            "Queue add $QueueName - ID $QueueID",
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create two test tickets in different states
        my @TicketIDs;
        for my $TicketState (qw( new open )) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => 'Selenium Test Ticket',
                QueueID      => $QueueID,
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => $TicketState,
                CustomerID   => '123465',
                CustomerUser => 'customer@example.com',
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID",
            );

            push @TicketIDs, $TicketID;
        }

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # test if TicketQueueOverview shows correct links
        for my $TQOLinkState (qw(1 4)) {
            $Self->True(
                index( $Selenium->get_page_source(), "StateIDs=$TQOLinkState;QueueIDs=$QueueID;SortBy=Age;OrderBy=Up" )
                    > -1,
                "TicketQueueOverview dashboard plugin link - found for state - ID $TQOLinkState",
            );
        }

        # delete test tickets
        my $Success;
        for my $TicketDelete (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketDelete,
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "Delete ticket - ID $TicketDelete"
            );
        }

        # delete test queue
        $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Delete queue - ID $QueueID",
        );

        # make sure cache is correct
        for my $Cache (qw( Ticket Queue Dashboard DashboardQueueOverview )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
