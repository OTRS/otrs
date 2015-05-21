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
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Selenium' => {
        Verbose => 1,
        }
);
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
                }
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sys config object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # do not check service and type
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'PDF',
            Value => 0
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'stats' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentStats;Subaction=Import");

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # add test customer for testing
        my $TestCustomer = 'Customer' . $Helper->GetRandomID();
        my $UserLogin    = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomer,
            UserLastname   => $TestCustomer,
            UserCustomerID => $TestCustomer,
            UserLogin      => $TestCustomer,
            UserEmail      => "$TestCustomer\@localhost.com",
            ValidID        => 1,
            UserID         => $TestUserID,
        );

        $Self->True(
            $UserLogin,
            "CustomerUser is created - $TestCustomer",
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my @TicketIDs;
        my @TicketNumbers;
        for ( 1 .. 5 ) {

            # create test ticcket
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => "Selenium Test Ticket",
                Queue        => 'Junk',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => 'SeleniumCustomer',
                CustomerUser => "SeleniumCustomer\@localhost.com",
                OwnerID      => $TestUserID,
                UserID       => $TestUserID,
            );

            $Self->True(
                $TicketID,
                "Ticket is created - $TicketID",
            );

            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;

        }

        # import test selenium statistic
        my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . "/scripts/test/sample/Stats/Stats.TestTicketList.en.xml";
        $Selenium->find_element( "#file_upload", 'css' )->send_keys($Location);
        $Selenium->find_element("//button[\@value='Import'][\@type='submit']")->click();

        # wait until test stat is imported, if neccessary
        $Selenium->WaitFor( JavaScript => "return \$('#compose').length" );

        # create params for import test stats
        my %StatsValues =
            (
            Title       => 'Test TicketList statistic',
            Object      => 'Ticketlist',
            Description => 'List of all tickets. Restricted by Junk Queue.',
            Format      => 'Print',
            Restriction => 'UseAsRestrictionQueueIDs',
            );

        # check for imported values on test stat
        for my $StatsValue ( sort keys %StatsValues ) {
            $Self->True(
                index( $Selenium->get_page_source(), $StatsValues{$StatsValue} ) > -1,
                "Expexted param $StatsValue for imported stat is founded - $StatsValues{$StatsValue}"
            );
        }

        # navigate to AgentStats Overview screen
        $Selenium->get(
            "${ScriptAlias}index.pl?Action=AgentStats;Subaction=Overview;"
        );

        # get stats object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::Stats' => {
                UserID => 1,
                }
        );
        my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

        # get stats IDs
        my $StatsIDs = $StatsObject->GetStatsList(
            AccessRw => 1,
        );

        my $Count       = scalar @{$StatsIDs};
        my $StatsIDLast = $StatsIDs->[ $Count - 1 ];

        # check for imported stat on overview screen
        $Self->True(
            index( $Selenium->get_page_source(), $StatsValues{Title} ) > -1,
            "Imported stat $StatsValues{Title} - found on overview screen"
        );

        # go to imported stat to run it
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentStats;Subaction=View;StatID=$StatsIDLast\' )]")
            ->click();

        # run test statistic
        $Selenium->find_element( "#StartStatistic", 'css' )->click();

        sleep 3;

        # switch to another window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check result of stats
        for my $TicketNumber (@TicketNumbers) {

            $Self->True(
                index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                "TicketNumber is founded on stats - $TicketNumber "
            );
        }

        $Self->True(
            index( $Selenium->get_page_source(), $StatsValues{Title} ) > -1,
            "Title of stats is founded - $StatsValues{Title} "
        );

        # delete test stats
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => "DELETE FROM xml_storage where xml_key = ?",
            Bind => [ \$StatsIDLast ],
        );
        $Self->True(
            $Success,
            "Deleted stats - $StatsValues{Title}",
        );

        # delete created test tickets
        for my $TicketID (@TicketIDs) {

            my $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
            $Self->True(
                $Success,
                "Ticket is deleted - $TicketID"
            );
        }

        # make sure the cache is correct.
        for my $Cache (qw( Ticket Stats )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => 'Ticket',
            );
        }

        }
);

1;
