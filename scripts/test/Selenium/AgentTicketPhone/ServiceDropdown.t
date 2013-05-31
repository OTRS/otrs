# --
# ServiceDropdown.t - frontend test AgentTicketPhone
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::UnitTest::Helper;
use Kernel::System::Service;
use Kernel::System::Ticket;

# this test is to check that when AgentTicketPhone is loaded already with
# customer data on it (like when doing Split), the dropdown of Service is
# prefilled with the correct data. This is because of bug
# http://bugs.otrs.org/show_bug.cgi?id=7060

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

require Kernel::System::UnitTest::Selenium;    ## no critic

my $Helper = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

my $TestUserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
) || die "Did not get test user";

for my $SeleniumScenario ( @{ $Helper->SeleniumScenariosGet() } ) {
    eval {
        my $Selenium = Kernel::System::UnitTest::Selenium->new(
            Verbose        => 1,
            UnitTestObject => $Self,
            %{$SeleniumScenario},
        );

        eval {

            $Selenium->Login(
                Type     => 'Agent',
                User     => $TestUserLogin,
                Password => $TestUserLogin,
            );

            my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

            # create a customer and a ticket from that customer as previous
            # steps to do the selenium testing

            # create local objects
            my $ConfigObject = Kernel::Config->new();

            # do not checkmx
            $ConfigObject->Set(
                Key   => 'CheckEmailAddresses',
                Value => 0,
            );

            my $ServiceObject = Kernel::System::Service->new(
                %{$Self},
                ConfigObject => $ConfigObject,
            );
            my $TicketObject = Kernel::System::Ticket->new(
                %{$Self},
                ConfigObject => $ConfigObject,
            );

            # create a test customer
            my $TestUserCustomer = $Helper->TestCustomerUserCreate()
                || die "Did not get test customer user";

            # create a ticket from the just created customer
            my $TicketID = $TicketObject->TicketCreate(
                Title        => 'Selenium Test-Some Ticket Title',
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'closed successful',
                CustomerUser => $TestUserCustomer,
                OwnerID      => 1,
                UserID       => 1,
            );

            my $RandomID = $Helper->GetRandomID();

            # create a test service
            my $ServiceID = $ServiceObject->ServiceAdd(
                Name    => 'SeleniumTestService' . $RandomID,
                Comment => 'Selenium Test Service',
                ValidID => 1,
                UserID  => 1,
            );

            # allow access to the just created service to the test user
            $ServiceObject->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $TestUserCustomer,
                ServiceID         => $ServiceID,
                Active            => 1,
                UserID            => 1,
            );

            # create an article for the test ticket
            my $ArticleID = $TicketObject->ArticleCreate(
                TicketID       => $TicketID,
                ArticleType    => 'note-internal',
                SenderType     => 'agent',
                Subject        => 'Selenium test',
                Body           => 'Just a test body for selenium testing',
                Charset        => 'ISO-8859-15',
                MimeType       => 'text/plain',
                HistoryType    => 'AddNote',
                HistoryComment => 'Selenium testing',
                UserID         => 1,
            );

            # real selenium test start
            # open the page that clicking on Split link of the zoom view of the
            # just created ticket would open
            $Selenium->open_ok(
                "${ScriptAlias}index.pl?Action=AgentTicketPhone;TicketID=$TicketID;ArticleID=$ArticleID"
            );
            $Selenium->wait_for_page_to_load_ok("30000");

            # verify that the services dropdown has the just created service
            $Selenium->select_ok( "ServiceID", "label=SeleniumTestService" . $RandomID );

            # set the test service to invalid
            $ServiceObject->ServiceUpdate(
                ServiceID => $ServiceID,
                Name      => 'SeleniumTestService' . $RandomID,
                ValidID   => 2,
                UserID    => 1,
            );

            # delete the test ticket
            $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );

            return 1;

        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;

    } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );
}

1;
