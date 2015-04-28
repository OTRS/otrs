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

# Update 'To' in CustomerTicketMessage on Add/Update Group (Bug#10988).

# get selenium object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Selenium' => {
        Verbose => 1,
    },
);
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 0,
                }
        );

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create and login test customer
        my $TestUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # meke sure that CustomerGroupSupport is disabled
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 0
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

        # get test queue ID
        my %Queue = $QueueObject->QueueGet(
            Name => $QueueName,
        );

        # click on 'Create your first ticket'
        $Selenium->find_element( ".Button", 'css' )->click();

        # verify that test queue is available for users group
        $Self->True(
            $Selenium->find_element( "#Dest option[value='$QueueID||$QueueName']", 'css' ),
            "$Queue{Name} is available to select"
        );

        # create test group
        my $GroupName   = "Group" . $Helper->GetRandomID();
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
        my $GroupID     = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
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

        # refresh page
        $Selenium->refresh();

        # check if test queue is available to select
        $Self->True(
            index( $Selenium->get_page_source(), $QueueName ) > -1,
            "$QueueName is available to select with new group $GroupName",
        );

        # update group
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
        $Selenium->refresh();

        # check test queue with invalid test group
        $Self->False(
            index( $Selenium->get_page_source(), $QueueName ) > -1,
            "$QueueName is not available to select with invalid group $GroupName",
        );

        # get database object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success;

        # clean up test data
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

        # make sure the cache is correct.
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
