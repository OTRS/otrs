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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # use a calendar with the same business hours for every day so that the UT runs correctly
        # on every day of the week and outside usual business hours.
        my %Week;
        my @Days = qw(Sun Mon Tue Wed Thu Fri Sat);
        for my $Day (@Days) {
            $Week{$Day} = [ 0 .. 23 ];
        }
        $Helper->ConfigSettingChange(
            Key   => 'TimeWorkingHours',
            Value => \%Week,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeWorkingHours',
            Value => \%Week,
        );

        # disable default Vacation days
        $Helper->ConfigSettingChange(
            Key   => 'TimeVacationDays',
            Value => {},
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeVacationDays',
            Value => {},
        );

        # disable other dashboard modules
        my $Config = $ConfigObject->Get('DashboardBackend');
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => \%$Config,
        );

        # restore ticket calendar sysconfig
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0260-TicketCalendar',
            Value => {
                'Block'      => 'ContentSmall',
                'CacheTTL'   => '2',
                'Default'    => '1',
                'Group'      => '',
                'Limit'      => '6',
                'Module'     => 'Kernel::Output::HTML::Dashboard::Calendar',
                'OwnerOnly'  => '',
                'Permission' => 'rw',
                'Title'      => 'Upcoming Events'
            },
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create test queue
        my $QueueName = "Queue" . $Helper->GetRandomID();
        my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name              => $QueueName,
            ValidID           => 1,
            GroupID           => 1,
            FirstResponseTime => 60,
            SystemAddressID   => 1,
            SalutationID      => 1,
            SignatureID       => 1,
            Comment           => 'Selenium Queue',
            UserID            => $TestUserID,
        );
        $Self->True(
            $QueueID,
            "Queue is created - ID $QueueID",
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Selenium Test Ticket',
            QueueID      => $QueueID,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => 'TestCustomers',
            CustomerUser => 'customer@example.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID",
        );

        #  Discard TicketObject to let event handlers run also for transaction mode 1.
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::Ticket']
        );

        # get cache object
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # clean up dashboard cache
        $CacheObject->CleanUp( Type => 'Dashboard' );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AgentDashboard screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # check for created test ticket on dashboard screen
        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "$TicketNumber - found on screen"
        ) || die "$TicketNumber - found NOT on screen";

        $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # delete test ticket
        my $Success = $TicketObject->TicketDelete(
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
            "Ticket is deleted - ID $TicketID"
        );

        # delete created test queue
        $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Queue is deleted - ID $QueueID",
        );

        # make sure the cache is correct
        for my $Cache (
            qw (Ticket Queue)
            )
        {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
