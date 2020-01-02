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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable FilterQueuesWithoutAutoResponse filter
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'FilterQueuesWithoutAutoResponses',
            Value => 1,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # add test queue
        my $QueueRandomID = "queue" . $Helper->GetRandomID();
        my $QueueID       = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueRandomID,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => 1,
            Comment         => 'Selenium Test',
        );
        $Self->True(
            $QueueID,
            "Created Queue - $QueueRandomID",
        );

        # get system address object
        my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');

        # add test system address
        my $SystemAddressRandomID = "sysadd" . $Helper->GetRandomID();
        my $SystemAddressID       = $SystemAddressObject->SystemAddressAdd(
            Name     => $SystemAddressRandomID . '@example.com',
            Realname => $SystemAddressRandomID,
            ValidID  => 1,
            QueueID  => 1,
            Comment  => 'Selenium Test',
            UserID   => 1,
        );
        $Self->True(
            $SystemAddressID,
            "Created SystemAddress - $SystemAddressRandomID",
        );

        my $AutoResponseNameRand;
        my $AutoResponseID;

        # Tests for AutoResponseAdd()
        my @Tests = (
            {
                Name    => 'autoreply',
                Subject => 'Auto reply response',
                TypeID  => 1,
                Comment => "Auto response reply selenium test",
            },
            {
                Name    => 'autoreject',
                Subject => 'Auto reject response',
                TypeID  => 2,
                Comment => "Auto response reject selenium test",
            },
            {
                Name    => 'autofollowup',
                Subject => 'Auto follow up response',
                TypeID  => 3,
                Comment => "Auto response follow up selenium test",
            },
            {
                Name    => 'autoreplynew',
                Subject => 'Auto reply new ticket response',
                TypeID  => 4,
                Comment => "Auto response reply new ticket selenium test",
            },
            {
                Name    => 'autoremove',
                Subject => 'Auto remove response',
                TypeID  => 5,
                Comment => "Auto response remove selenium test",
            },

        );

        # add test auto responses
        my @AutoResponseIDs;
        for my $Test (@Tests) {
            my $AutoResponseNameRand = $Test->{Name} . $Helper->GetRandomID();
            my $AutoResponseID       = $Kernel::OM->Get('Kernel::System::AutoResponse')->AutoResponseAdd(
                Name        => $AutoResponseNameRand,
                Subject     => $Test->{Subject},
                Response    => 'Some Response',
                Comment     => $Test->{Comment},
                AddressID   => $SystemAddressID,
                TypeID      => $Test->{TypeID},
                Charset     => 'iso-8859-1',
                ContentType => 'text/plain',
                ValidID     => 1,
                UserID      => 1,
            );
            $Self->True(
                $AutoResponseID,
                "Created AutoResponse - $AutoResponseNameRand",
            );

            push @AutoResponseIDs, {
                ID   => $AutoResponseID,
                Name => $AutoResponseNameRand
            };
        }

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminQueueAutoResponse screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminQueueAutoResponse");

        # check overview AdminQueueAutoResponse
        for my $ID (
            qw(Queues AutoResponses FilterQueues FilterAutoResponses)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # check for created test Queue and AutoResponses on screen
        $Self->True(
            index( $Selenium->get_page_source(), $QueueRandomID ) > -1,
            "$QueueRandomID found on screen"
        );

        for my $AutoResponse (@AutoResponseIDs) {
            $Self->True(
                index( $Selenium->get_page_source(), $AutoResponse->{Name} ) > -1,
                "$AutoResponse->{Name} auto response found on screen"
            );
        }

        # test search filter auto response
        $Selenium->find_element( "#FilterAutoResponses", 'css' )->send_keys( $AutoResponseIDs[1]->{Name} );
        sleep 1;
        $Self->True(
            $Selenium->find_element(
                "//a[contains(\@href, 'Action=AdminAutoResponse;Subaction=Change;ID=$AutoResponseIDs[1]->{ID}' )]"
            )->is_displayed(),
            "$AutoResponseIDs[1]->{Name} found on screen",
        );

        $Self->True(
            index(
                $Selenium->get_page_source(),
                'Action=AdminAutoResponse;Subaction=Change;ID=$AutoResponseIDs[2]->{ID}'
            ) == -1,
            "$AutoResponseIDs[2]->{Name} is not found screen",
        );

        # clear filter
        $Selenium->find_element( "#FilterAutoResponses", 'css' )->clear();

        # test search filter queue
        $Selenium->find_element( "#FilterQueues", 'css' )->send_keys($QueueRandomID);
        sleep 1;

        $Self->True(
            $Selenium->find_element( $QueueRandomID, 'link_text' )->is_displayed(),
            "$QueueRandomID found on screen",
        );
        $Selenium->find_element( "#FilterQueues", 'css' )->clear();
        sleep 1;

        # check auto response relation for queue screen
        $Selenium->find_element( $QueueRandomID, 'link_text' )->VerifiedClick();

        my $Index = 0;
        for my $Test (@Tests)
        {
            my $Element = $Selenium->find_element( "#IDs_$Test->{TypeID}", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();

            # check auto response relation for queue default values
            $Self->Is(
                $Selenium->find_element( "#IDs_$Test->{TypeID} option[value='']", 'css' )->is_enabled(),
                1,
                "Relation between auto response $Test->{Name} and $QueueRandomID is not set"
            );

            # change auto response relation for test queue
            $Selenium->InputFieldValueSet(
                Element => "#IDs_$Test->{TypeID}",
                Value   => $AutoResponseIDs[$Index]->{ID},
            );
            $Index++;
        }

        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # check new QueueAutoResponse relations
        $Selenium->find_element( $QueueRandomID, 'link_text' )->VerifiedClick();

        $Index = 1;
        for my $BreadcrumbText (
            'Manage Queue-Auto Response Relations',
            'Change Auto Response Relations for Queue ' . $QueueRandomID
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Index)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Index++;
        }

        $Index = 0;
        for my $Test (@Tests)
        {

            $Self->Is(
                $Selenium->find_element( "#IDs_$Test->{TypeID}", 'css' )->get_value(),
                $AutoResponseIDs[$Index]->{ID},
                "$AutoResponseIDs[$Index]->{Name} stored value",
            );
            $Index++;

        }

        # click 'Go to overview'
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminQueueAutoResponse' )]")->VerifiedClick();

        # test QueuesWithoutAutoResponse filter
        $Selenium->find_element("//a[contains(\@href, 'Filter=QueuesWithoutAutoResponses' )]")->VerifiedClick();

        # verify filter excluded test queue from the list
        $Self->True(
            index( $Selenium->get_page_source(), $QueueRandomID ) == -1,
            "$QueueRandomID not found on screen with QueuesWithoutAutoResponses filter on"
        );

        $Self->Is(
            $Selenium->execute_script("return \$('.BreadCrumb li:eq(2)').text().trim()"),
            'Queues without Auto Responses',
            "Breadcrumb text 'Queues without Auto Responses' is found on screen"
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # since there are no tickets that rely on our test QueueAutoResponse,
        # we can remove test queue, system address and auto response from the DB
        my $Success = $DBObject->Do(
            SQL => "DELETE FROM queue_auto_response WHERE queue_id = $QueueID",
        );
        $Self->True(
            $Success,
            "Deleted QueueAutoResponse",
        );

        for my $AutoResponse (@AutoResponseIDs) {

            $Success = $DBObject->Do(
                SQL => "DELETE FROM auto_response WHERE id = $AutoResponse->{ID}",
            );
            $Self->True(
                $Success,
                "Deleted AutoResponse - $AutoResponse->{Name}",
            );
        }

        if ($QueueRandomID) {

            $Success = $DBObject->Do(
                SQL => "DELETE FROM queue WHERE id = $QueueID",
            );
            $Self->True(
                $Success,
                "Deleted Queue - $QueueRandomID",
            );
        }

        if ($SystemAddressRandomID) {
            my %SystemAddressID = $SystemAddressObject->SystemAddressGet(
                ID => $SystemAddressID
            );
            $Success = $DBObject->Do(
                SQL => "DELETE FROM system_address WHERE id= $SystemAddressID",
            );
            $Self->True(
                $Success,
                "Deleted SystemAddress - $SystemAddressRandomID",
            );
        }

        # make sure the caches are correct
        for my $Cache (
            qw (Queue AutoResponse SystemAddress QueueAutoResponse)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }

);

1;
