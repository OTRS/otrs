# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # add test queue
        my $QueueName = "queue" . $Helper->GetRandomID();
        my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueName,
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
            "Created Queue - $QueueName",
        );

        # get standard template object
        my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
        my @Templates;

        # create test template
        for ( 1 .. 2 ) {
            my $StandardTemplateName = "standard template" . $Helper->GetRandomID();
            my $TemplateID           = $StandardTemplateObject->StandardTemplateAdd(
                Name         => $StandardTemplateName,
                Template     => 'Thank you for your email.',
                ContentType  => 'text/plain; charset=utf-8',
                TemplateType => 'Answer',
                ValidID      => 1,
                UserID       => $UserID,
            );

            $Self->True(
                $TemplateID,
                "Test StandardTemplate is created - $TemplateID"
            );

            my %Template = (
                TemplateID => $TemplateID,
                Name       => $StandardTemplateName,
            );
            push @Templates, \%Template;
        }

        # check overview AdminQueueTemplates screen
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
            index( $Selenium->get_page_source(), $Templates[0]->{Name} ) > -1,
            "$Templates[0]->{Name} found on screen"
        );
        $Self->True(
            index( $Selenium->get_page_source(), $QueueName ) > -1,
            "$QueueName found on screen"
        );

        # test search filters
        $Selenium->find_element( "#FilterTemplates", 'css' )->send_keys( $Templates[0]->{Name} );
        $Selenium->find_element( "#FilterQueues",    'css' )->send_keys($QueueName);
        sleep 1;

        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Template;ID=$Templates[0]->{TemplateID}' )]")
                ->is_displayed(),
            "$Templates[0]->{Name} found on screen with filter on",
        );

        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Queue;ID=$QueueID' )]")->is_displayed(),
            "$QueueName found on screen with filter on",
        );

        # change test Queue relation for the first Template
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Template;ID=$Templates[0]->{TemplateID}' )]")
            ->VerifiedClick();
        $Selenium->find_element("//input[\@value='$QueueID'][\@type='checkbox']")->VerifiedClick();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # change test Template relation for test Queue
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Queue;ID=$QueueID' )]")->VerifiedClick();
        $Selenium->find_element("//input[\@value='$Templates[1]->{TemplateID}'][\@type='checkbox']")->VerifiedClick();

        # test checked and unchecked values while filter is used for Template
        # test filter with "WrongFilterTemplate" to uncheck all values
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys("WrongFilterTemplate");
        sleep 1;

        # test is no data matches
        $Self->True(
            $Selenium->find_element( ".FilterMessage.Hidden>td", 'css' )->is_displayed(),
            "'No data matches' is displayed'"
        );

        # check template filter with existing Template
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys( $Templates[1]->{Name} );
        sleep 1;

        # uncheck the second test standard template
        $Selenium->find_element("//input[\@value='$Templates[1]->{TemplateID}'][\@type='checkbox']")->VerifiedClick();

        # test checked and unchecked values after using filter
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys("StandardTemplate");
        sleep 1;

        $Self->Is(
            $Selenium->find_element("//input[\@value='$Templates[0]->{TemplateID}'][\@type='checkbox']")->is_selected(),
            1,
            "$QueueName is in a relation with $Templates[0]->{Name}",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$Templates[1]->{TemplateID}'][\@type='checkbox']")->is_selected(),
            0,
            "$QueueName is not in a relation with $Templates[1]->{Name}",
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
                "Deleted queue- $QueueName",
            );
        }

        for my $Template (@Templates) {
            $Success = $StandardTemplateObject->StandardTemplateDelete(
                ID => $Template->{TemplateID},
            );

            $Self->True(
                $Success,
                "Deleted StandardTemplate - $Template->{TemplateID}",
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => "Queue",
        );

    }

);

1;
