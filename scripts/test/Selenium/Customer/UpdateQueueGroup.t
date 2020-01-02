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

# Update 'To' in CustomerTicketMessage on Add/Update Group (Bug#10988).

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # make sure that CustomerGroupSupport is disabled
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 0
        );

        # create test customer user and login
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # add test queue in group users
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
        my $QueueName   = "Queue" . $Helper->GetRandomID();
        my $QueueID     = $QueueObject->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => 1,
            Comment         => 'Selenium test queue',
        );
        $Self->True(
            $QueueID,
            "Queue is created - $QueueName"
        );

        # click on 'Create your first ticket'
        $Selenium->find_element( ".Button", 'css' )->VerifiedClick();

        # verify that test queue is available for users group
        $Self->True(
            $Selenium->find_element( "#Dest option[value='$QueueID||$QueueName']", 'css' ),
            "$QueueName is available to select"
        );

        # create test group
        my $GroupName   = "Group" . $Helper->GetRandomID();
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
        my $GroupID     = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "Group is created - $GroupName"
        );

        # add test queue to test group
        my $QueueUpdateID = $QueueObject->QueueUpdate(
            QueueID         => $QueueID,
            Name            => $QueueName,
            GroupID         => $GroupID,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            FollowUpID      => 1,
            UserID          => 1,
            ValidID         => 1,
        );
        $Self->True(
            $QueueUpdateID,
            "Queue is updated - $QueueName"
        );

        # refresh page
        $Selenium->VerifiedRefresh();

        # check if test queue is available to select
        $Self->True(
            index( $Selenium->get_page_source(), $QueueName ) > -1,
            "$QueueName is available to select with new group $GroupName",
        );

        # update group to invalid
        my $GroupUpdate = $GroupObject->GroupUpdate(
            ID      => $GroupID,
            Name    => $GroupName,
            ValidID => 2,
            UserID  => 1,
        );
        $Self->True(
            $GroupUpdate,
            "$GroupName is updated to invalid status",
        );

        # refresh page
        $Selenium->VerifiedRefresh();

        # check test queue with invalid test group
        $Self->False(
            index( $Selenium->get_page_source(), $QueueName ) > -1,
            "$QueueName is not available to select with invalid group $GroupName",
        );

        # get database object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # clean up test data
        my $Success;
        if ($QueueID) {
            $Success = $DBObject->Do(
                SQL => "DELETE FROM queue WHERE id = $QueueID",
            );
            $Self->True(
                $Success,
                "Queue is deleted - $QueueName",
            );
        }

        if ($GroupID) {
            $Success = $DBObject->Do(
                SQL => "DELETE FROM groups WHERE id = $GroupID",
            );
            $Self->True(
                $Success,
                "Group is deleted - $GroupName",
            );
        }

        # make sure the cache is correct
        for my $Cache (
            qw (Queue Group)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
