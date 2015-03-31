# --
# AdminQueueTemplates.t - frontend tests for AdminQueueTemplates
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

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject           = $Kernel::OM->Get('Kernel::Config');
my $DBObject               = $Kernel::OM->Get('Kernel::System::DB');
my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 0,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        my $QueueRandomID    = "queue" . $Helper->GetRandomID();
        my $TemplateRandomID = "template" . $Helper->GetRandomID();

        # add test queue
        my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueRandomID,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => $UserID,
            Comment         => 'Selenium Test Queue',
        );

        # create test template
        my $TemplateID = $StandardTemplateObject->StandardTemplateAdd(
            Name         => $TemplateRandomID,
            Template     => 'Thank you for your email.',
            ContentType  => 'text/plain; charset=utf-8',
            TemplateType => 'Answer',
            ValidID      => 1,
            UserID       => $UserID,
        );

        # check overview AdminQueueTemplates screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminQueueTemplates");

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
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Template;ID=$TemplateID' )]")->click();

        $Selenium->find_element("//input[\@value='$QueueID'][\@type='checkbox']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check test Template relation for test Queue
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Queue;ID=$QueueID' )]")->click();

        $Self->True(
            $Selenium->find_element("//input[\@value='$TemplateID'][\@type='checkbox']")->is_selected(),
            "$QueueRandomID is in a relation with $TemplateRandomID",
        );

        # Since there are no tickets that rely on our test QueueTemplate,
        # we can remove test template and  test queue from the DB

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

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => "Queue",
        );

        }

);

1;
