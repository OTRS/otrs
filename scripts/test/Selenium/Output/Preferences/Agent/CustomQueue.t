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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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
        my $QueueName = 'Queue' . $Helper->GetRandomID();
        my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Selenium Queue',
            UserID          => $TestUserID,
        );
        $Self->True(
            $QueueID,
            "QueueAdd() successful for test $QueueName ID $QueueID",
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to agent preferences
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentPreferences");

        # add test queue to 'My Queues' preference
        $Selenium->execute_script("\$('#QueueID').val('$QueueID').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#QueueIDUpdate", 'css' )->click();

        # check for update preference message on screen
        my $UpdateMessage = "Preferences updated successfully!";
        $Self->True(
            index( $Selenium->get_page_source(), $UpdateMessage ) > -1,
            'Agent preference custom queue - updated'
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete personal queues connection
        my $Success = $DBObject->Do(
            SQL => "DELETE FROM personal_queues WHERE queue_id = $QueueID",
        );
        $Self->True(
            $Success,
            "Delete personal queues connection",
        );

        # delete created test queue
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Delete queue - $QueueID",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Queue',
        );

    }
);

1;
