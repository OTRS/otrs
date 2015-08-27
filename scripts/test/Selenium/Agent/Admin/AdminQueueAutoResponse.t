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

# get needed objects
my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
my $DBObject            = $Kernel::OM->Get('Kernel::System::DB');
my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');
my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
my $AutoResponseObject  = $Kernel::OM->Get('Kernel::System::AutoResponse');
my $Selenium            = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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
        my $QueueID       = $QueueObject->QueueAdd(
            Name            => $QueueRandomID,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => 1,
            Comment         => 'Selenium Test',
        );

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
            my $AutoResponseID       = $AutoResponseObject->AutoResponseAdd(
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

            push @AutoResponseIDs, {
                ID   => $AutoResponseID,
                Name => $AutoResponseNameRand
            };
        }

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # check AdminQueueAutoResponse screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminQueueAutoResponse");

        for my $ID (
            qw(Queues AutoResponses FilterQueues FilterAutoResponses)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

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

        my $Success;
        eval {
            $Success = $Selenium->find_element(
                "//a[contains(\@href, 'Action=AdminAutoResponse;Subaction=Change;ID=$AutoResponseIDs[2]->{ID}' )]"
                )->is_displayed(),
        };

        $Self->False(
            $Success,
            "$AutoResponseIDs[2]->{Name} is not found screen",
        );
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
        $Selenium->find_element( $QueueRandomID, 'link_text' )->click();
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
            $Selenium->execute_script(
                "\$('#IDs_$Test->{TypeID}').val('$AutoResponseIDs[$Index]->{ID}').trigger('redraw.InputField').trigger('change');"
            );
            $Index++;
        }

        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check new QueueAutoResponse relations
        $Selenium->find_element( $QueueRandomID, 'link_text' )->click();
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

        # Since there are no tickets that rely on our test QueueAutoResponse,
        # we can remove test queue, system address and auto response from the DB
        $Success = $DBObject->Do(
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
                "Deleted AutoResponse - $AutoResponse->{ID}",
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

        # Make sure the caches are correct.
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
