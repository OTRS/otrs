# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create test queue
        my $QueueRandomID = "queue" . $Helper->GetRandomID();
        my $QueueID       = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueRandomID,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => $UserID,
            Comment         => 'Selenium Test Queue',
        );
        $Self->True(
            $QueueID,
            "Created Queue - $QueueRandomID",
        );

        # get standard template object
        my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

        # create test template
        my $TemplateRandomID = "template" . $Helper->GetRandomID();
        my $TemplateID       = $StandardTemplateObject->StandardTemplateAdd(
            Name         => $TemplateRandomID,
            Template     => 'Thank you for your email.',
            ContentType  => 'text/plain; charset=utf-8',
            TemplateType => 'Answer',
            ValidID      => 1,
            UserID       => $UserID,
        );
        $Self->True(
            $QueueID,
            "Created StandardTemplate - $TemplateRandomID",
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminQueueTemplates screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminQueueTemplates");

        # check overview AdminQueueTemplates
        for my $ID (
            qw(Templates Queues FilterTemplates FilterQueues)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check for test template and test queue on screen
        $Self->True(
            index( $Selenium->get_page_source(), $TemplateRandomID ) > -1,
            "$TemplateRandomID found on screen"
        );
        $Self->True(
            index( $Selenium->get_page_source(), $QueueRandomID ) > -1,
            "$QueueRandomID found on screen"
        );

        # test search filters
        $Selenium->find_element( "#FilterTemplates", 'css' )->send_keys($TemplateRandomID);
        $Selenium->find_element( "#FilterQueues",    'css' )->send_keys($QueueRandomID);
        sleep 1;

        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Template;ID=$TemplateID' )]")->is_displayed(),
            "$TemplateRandomID found on screen with filter on",
        );

        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Queue;ID=$QueueID' )]")->is_displayed(),
            "$QueueRandomID found on screen with filter on",
        );

        # change test Queue relation for test Queue
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Template;ID=$TemplateID' )]")->VerifiedClick();

        $Selenium->find_element("//input[\@value='$QueueID'][\@type='checkbox']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # check test Template relation for test Queue
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Queue;ID=$QueueID' )]")->VerifiedClick();

        $Self->True(
            $Selenium->find_element("//input[\@value='$TemplateID'][\@type='checkbox']")->is_selected(),
            "$QueueRandomID is in a relation with $TemplateRandomID",
        );

        # since there are no tickets that rely on our test QueueTemplate,
        # we can remove test template and  test queue from the DB
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success;
        if ($QueueID) {
            $Success = $DBObject->Do(
                SQL => "DELETE FROM queue_standard_template WHERE queue_id = $QueueID",
            );
            $Self->True(
                $Success,
                "Deleted standard_template_queue relation"
            );

            $Success = $DBObject->Do(
                SQL => "DELETE FROM queue WHERE id = $QueueID",
            );
            $Self->True(
                $Success,
                "Deleted - $QueueRandomID",
            );
        }

        if ($TemplateID) {
            $Success = $StandardTemplateObject->StandardTemplateDelete(
                ID => $TemplateID,
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => "Queue",
        );

    }

);

1;
