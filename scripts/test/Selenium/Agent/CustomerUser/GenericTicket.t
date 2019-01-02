# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable CustomerUserGenericTicket sysconfig
        my @CustomerSysConfig = (
            '15-OpenTickets',   '16-OpenTicketsForCustomerUserLogin',
            '17-ClosedTickets', '18-ClosedTicketsForCustomerUserLogin'
        );

        for my $SysConfigChange (@CustomerSysConfig) {

            # get sysconfig object
            my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

            # get default sysconfig
            my $SysConfigName = 'Frontend::CustomerUser::Item###' . $SysConfigChange;
            my %Config        = $SysConfigObject->ConfigItemGet(
                Name    => $SysConfigName,
                Default => 1,
            );

            # set CustomerUserGenericTicket modules to valid
            %Config = map { $_->{Key} => $_->{Content} }
                grep { defined $_->{Key} } @{ $Config{Setting}->[1]->{Hash}->[1]->{Item} };

            $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => $SysConfigName,
                Value => \%Config,
            );
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

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # get test customer user ID
        my @CustomerIDs = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
            User => $TestCustomerUserLogin,
        );
        my $CustomerID = $CustomerIDs[0];

        # get needed objects
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test data parameters
        my %TicketData = (
            'Open' => {
                TicketState   => 'open',
                TicketCount   => '',
                TicketNumbers => [],
                TicketIDs     => [],
                TicketLink    => 'Open',
            },
            'Closed' => {
                TicketState   => 'closed successful',
                TicketCount   => '',
                TicketNumbers => [],
                TicketIDs     => [],
                TicketLink    => 'Closed',
            },
        );

        # create open and closed tickets
        for my $TicketCreate ( sort keys %TicketData ) {
            for my $TestTickets ( 1 .. 5 ) {
                my $TicketNumber = $TicketObject->TicketCreateNumber();
                my $TicketID     = $TicketObject->TicketCreate(
                    TN           => $TicketNumber,
                    Title        => 'Selenium Test Ticket',
                    Queue        => 'Raw',
                    Lock         => 'unlock',
                    Priority     => '3 normal',
                    State        => $TicketData{$TicketCreate}->{TicketState},
                    CustomerID   => $CustomerID,
                    CustomerUser => $TestCustomerUserLogin,
                    OwnerID      => $TestUserID,
                    UserID       => $TestUserID,
                );
                $Self->True(
                    $TicketID,
                    "$TicketCreate - ticket TicketID $TicketID - created - TN $TicketNumber",
                );
                push @{ $TicketData{$TicketCreate}->{TicketIDs} },     $TicketID;
                push @{ $TicketData{$TicketCreate}->{TicketNumbers} }, $TicketNumber;
            }
            my $TicketCount = $TicketObject->TicketSearch(
                Result     => 'Count',
                StateType  => $TicketCreate,
                CustomerID => $CustomerID,
                UserID     => $TestUserID,
            );
            $TicketData{$TicketCreate}->{TicketCount} = $TicketCount;
        }

        # go to zoom view of created test ticket
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketData{Open}->{TicketIDs}->[0]"
        );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # test CustomerUserGenericTicket module
        for my $TestLinks ( sort keys %TicketData ) {

            # check for layout and ticket count
            my $ExpectedText = $TestLinks . " tickets (customer) ($TicketData{$TestLinks}->{TicketCount})";
            $Self->True(
                index( $Selenium->get_page_source(), $ExpectedText ) > -1,
                "$ExpectedText - found on screen"
            );

            # click on link
            $Selenium->find_element(
                "//a[contains(\@href, \'$TicketData{$TestLinks}->{TicketLink};CustomerUserLogin=$TestCustomerUserLogin' )]"
            )->click();

            $Selenium->WaitFor( WindowCount => 2 );

            # link open in new window, switch to it
            my $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # wait until page has loaded, if necessary
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

            # check for test ticket numbers on search screen
            for my $CheckTicketNumbers ( @{ $TicketData{$TestLinks}->{TicketNumbers} } ) {
                $Self->True(
                    index( $Selenium->get_page_source(), $CheckTicketNumbers ) > -1,
                    "TicketNumber $CheckTicketNumbers - found on screen"
                );
            }

            # click on 'Change search option'
            $Selenium->find_element(
                "//a[contains(\@href, \'AgentTicketSearch;Subaction=LoadProfile' )]"
            )->click();

            # link open in new window switch to it
            $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[2] );

            # wait until search dialog has been loaded
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SearchFormSubmit").length' );

            # verify state search attributes are shown in search screen, see bug #10853
            $Selenium->find_element( "#StateIDs", 'css' );

            # close current window and return to original
            $Selenium->close();
            $Selenium->WaitFor( WindowCount => 1 );
            $Selenium->switch_to_window( $Handles->[0] );
        }

        # delete created test tickets
        for my $TicketState ( sort keys %TicketData ) {
            for my $TicketID ( @{ $TicketData{$TicketState}->{TicketIDs} } ) {

                my $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );

                $Self->True(
                    $Success,
                    "Delete ticket - $TicketID"
                );
            }
        }

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
