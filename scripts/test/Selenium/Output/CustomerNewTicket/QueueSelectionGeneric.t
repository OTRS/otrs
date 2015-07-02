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
                }
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # make sure Ticket::Frontend::CustomerTicketMessage###Queue sysconfig is set to 'Yes'
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketMessage###Queue',
            Value => 1
        );

        # create test queues
        my @QueueIDs;
        my @QueueNames;
        for my $CreateQueue ( 1 .. 2 ) {
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
            push @QueueIDs,   $QueueID;
            push @QueueNames, $QueueName;
        }

        # create test system address
        my $SystemAddressName = "SystemAddress" . $Helper->GetRandomID() . "\@localhost.com";
        my $SystemAddressID   = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressAdd(
            Name     => $SystemAddressName,
            Realname => 'Selenium SystemAddress',
            ValidID  => 1,
            QueueID  => $QueueIDs[1],
            Comment  => 'Selenium SystemAddress',
            UserID   => 1,
        );

        # create and login test customer
        my $TestUserLogin = $Helper->TestCustomerUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # navigate to create new ticket
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}customer.pl?Action=CustomerTicketMessage");

        # check for test queue destination on customer new ticket
        my $ToQueueCheck
            = $Selenium->find_element( "#Dest option[value='$QueueIDs[0]||$QueueNames[0]']", 'css' )->is_enabled();
        $Self->True(
            $ToQueueCheck,
            "Test $QueueNames[0] is enabled"
        );

        # switch to system address as new destination for customer new ticket
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'CustomerPanelSelectionType',
            Value => 'SystemAddress'
        );
        $Selenium->refresh();

        # check for system address queue destination
        my $ToSystemAddressCheck
            = $Selenium->find_element( "#Dest option[value='$QueueIDs[1]||$QueueNames[1]']", 'css' )->is_enabled();
        $Self->True(
            $ToSystemAddressCheck,
            "Test $QueueNames[1] is enabled"
        );

        # verify that other test queue is not present as destination
        $Self->True(
            index( $Selenium->get_page_source(), "$QueueNames[0]" ) == -1,
            "$QueueNames[0] not found on page",
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete created test system address
        my $Success = $DBObject->Do(
            SQL => "DELETE FROM system_address WHERE value0 = \'$SystemAddressName\'",
        );
        $Self->True(
            $Success,
            "Deleted system address - $SystemAddressID",
        );

        # delete created test queues
        for my $QueueDelete (@QueueIDs) {
            $Success = $DBObject->Do(
                SQL => "DELETE FROM queue WHERE id = $QueueDelete",
            );
            $Self->True(
                $Success,
                "Deleted queue - $QueueDelete",
            );
        }

        # make sure the cache is correct.
        for my $Cache (qw(Queue SystemAddress)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }
    }
);

1;
