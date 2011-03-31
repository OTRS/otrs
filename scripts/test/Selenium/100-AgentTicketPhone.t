# --
# 100-AgentTicketPhone.t - frontend tests for AgentTicketPhone
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: 100-AgentTicketPhone.t,v 1.1.2.1 2011-03-31 00:00:37 en Exp $
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
use Kernel::System::User;
use Kernel::System::CustomerUser;
use Kernel::System::Ticket;

use Time::HiRes qw(sleep);

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

require Kernel::System::UnitTest::Selenium;

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
        my $sel = Kernel::System::UnitTest::Selenium->new(
            Verbose        => 1,
            UnitTestObject => $Self,
            %{$SeleniumScenario},
        );

        eval {

            $sel->Login(
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

            my $UserObject = Kernel::System::User->new(
                %{$Self},
                ConfigObject => $ConfigObject,
            );
            my $CustomerUserObject = Kernel::System::CustomerUser->new(
                %{$Self},
                ConfigObject => $ConfigObject,
            );
            my $ServiceObject = Kernel::System::Service->new(
                %{$Self},
                ConfigObject => $ConfigObject,
            );
            my $TicketObject = Kernel::System::Ticket->new(
                %{$Self},
                ConfigObject       => $ConfigObject,
                CustomerUserObject => $CustomerUserObject,
            );

            #
            my $RandomNumber = int( rand(1000000) );
            my $UserRand     = 'Test-Selenium-CustomerUser-' . $RandomNumber;
            $Self->{EncodeObject}->Encode( \$UserRand );

            # create a test customer
            my $UserID = $CustomerUserObject->CustomerUserAdd(
                Source         => 'CustomerUser',
                UserFirstname  => 'Test-Selenium-CustomerUser-Name',
                UserLastname   => 'Lastname Test',
                UserCustomerID => $UserRand . '-Customer-Id',
                UserLogin      => $UserRand,
                UserEmail      => $UserRand . '-Email@mydomain.com',
                UserPassword   => 'some_pass',
                ValidID        => 1,
                UserID         => 1,
            );

            # create a ticket from the just created customer
            my $TicketID = $TicketObject->TicketCreate(
                Title        => 'Selenium Test-Some Ticket Title',
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'closed successful',
                CustomerUser => $UserRand,
                OwnerID      => 1,
                UserID       => 1,
            );

            # create a test service
            my $ServiceID = $ServiceObject->ServiceAdd(
                Name    => 'SeleniumTestService' . $RandomNumber,
                Comment => 'Selenium Test Service',
                ValidID => 1,
                UserID  => 1,
            );

            # allow access to the just created service to the test user
            $ServiceObject->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $UserRand,
                ServiceID         => $ServiceID,
                Active            => 1,
                UserID            => 1,
            );

            # real selenium test start
            # open the zoom view of the just created ticket
            $sel->open_ok("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");
            $sel->wait_for_page_to_load_ok("30000");

           #            # click on split
           #            $sel->click_ok("css=a#Split");
           #            $sel->wait_for_page_to_load_ok("30000");
           #
           #            # verify that the services dropdown has the just created service
           #            $sel->select_ok( "ServiceID", "label=SeleniumTestService" . $RandomNumber );

            # set test customer to invalid
            $CustomerUserObject->CustomerUserUpdate(
                Source         => 'CustomerUser',
                UserFirstname  => 'Test-Selenium-CustomerUser-Name',
                UserLastname   => 'Lastname Test',
                UserCustomerID => $UserRand . '-Customer-Id',
                ID             => $UserRand,
                UserLogin      => $UserRand,
                UserEmail      => $UserRand . '-Email@mydomain.com',
                UserPassword   => 'some_pass',
                ValidID        => 2,
                UserID         => 1,
            );

            # set the test service to invalid
            $ServiceObject->ServiceUpdate(
                ServiceID => $ServiceID,
                Name      => 'SeleniumTestService' . $RandomNumber,
                ValidID   => 2,
                UserID    => 1,
            );

            return 1;

        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;

    } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );
}

1;
