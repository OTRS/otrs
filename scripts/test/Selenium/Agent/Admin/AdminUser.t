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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Enable Service.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminUser screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUser");

        # check overview AdminUser
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Check for test agent in AdminUser.
        $Self->True(
            index( $Selenium->get_page_source(), $TestUserLogin ) > -1,
            "$TestUserLogin found on page",
        );

        # Check search field.
        $Selenium->find_element( "#Search", 'css' )->send_keys($TestUserLogin);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), $TestUserLogin ) > -1,
            "$TestUserLogin found on page",
        );

        # Check add agent page.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminUser;Subaction=Add' )]")->VerifiedClick();

        for my $ID (
            qw(UserFirstname UserLastname UserLogin UserEmail)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check breadcrumb on Add screen.
        my $Count = 1;
        for my $BreadcrumbText ( 'Agent Management', 'Add Agent' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Check client side validation.
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys("");
        $Selenium->find_element( "#Submit",        'css' )->click();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#UserFirstname').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Reload page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUser;Subaction=Add");

        # Create a real test agent.
        my $RandomID     = $Helper->GetRandomID();
        my $UserRandomID = 'TestAgent' . $RandomID;
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($UserRandomID);
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($UserRandomID);
        $Selenium->find_element( "#UserLogin",     'css' )->send_keys($UserRandomID);
        $Selenium->find_element( "#UserEmail",     'css' )->send_keys( $UserRandomID . '@localhost.com' );
        $Selenium->find_element( "#Submit",        'css' )->VerifiedClick();

        # Test search filter by agent $UserRandomID.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUser");
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($UserRandomID);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        # Edit real test agent values.
        my $EditRandomID = 'EditedTestAgent' . $RandomID;
        $Selenium->find_element( $UserRandomID, 'link_text' )->VerifiedClick();

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText ( 'Agent Management', 'Edit Agent: ' . $UserRandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Edit some values.
        $Selenium->find_element( "#UserFirstname", 'css' )->clear();
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($EditRandomID);
        $Selenium->find_element( "#UserLastname",  'css' )->clear();
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($EditRandomID);
        $Selenium->find_element( "#Submit",        'css' )->VerifiedClick();

        # Check is there notification after agent is updated.
        my $Notification = 'Agent updated!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Test search filter by agent $EditRandomID.
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($EditRandomID);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        # Check new agent values.
        $Selenium->find_element( $UserRandomID, 'link_text' )->VerifiedClick();
        $Self->Is(
            $Selenium->find_element( '#UserFirstname', 'css' )->get_value(),
            $EditRandomID,
            "#UserFirstname stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserLastname', 'css' )->get_value(),
            $EditRandomID,
            "#UserLastname stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserLogin', 'css' )->get_value(),
            $UserRandomID,
            "#UserLogin stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserEmail', 'css' )->get_value(),
            "$UserRandomID\@localhost.com",
            "#UserEmail stored value",
        );

        # Set added test agent to invalid.
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Test search filter by agent $UserRandomID.
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($UserRandomID);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        # Check class of invalid Agent in the overview table.
        $Self->True(
            $Selenium->find_element( "tr.Invalid", 'css' ),
            "There is a class 'Invalid' for test Agent",
        );

        # Testing bug#13463 (https://bugs.otrs.org/show_bug.cgi?id=13463),
        #   updating Agent data, removes it's 'My Queue' and 'My Services' preferences.
        my $QueueName = 'TestQueue' . $RandomID;
        my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueName,
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
            "QueueID $QueueID is created.",
        );

        my $ServiceName = 'TestService' . $RandomID;
        my $ServiceID   = $Kernel::OM->Get('Kernel::System::Service')->ServiceAdd(
            Name    => $ServiceName,
            Comment => 'Selenium Test',
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $ServiceID,
            "ServiceID $ServiceID is created."
        );

        # Navigate to AgentPreferences notification setting screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=NotificationSettings"
        );

        # Select test created Queue as 'My Queue' and update preference.
        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => $QueueID,
        );
        $Selenium->execute_script(
            "\$('#QueueID').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );

        # Wait for the AJAX call to finish.
        $Selenium->WaitFor(
            ElementMissing =>
                "//i[contains(\@class,\'fa fa-circle-o-notch fa-spin\')]"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#QueueID').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # Select test created Service as 'My Service' and update preference.
        $Selenium->InputFieldValueSet(
            Element => '#ServiceID',
            Value   => $ServiceID,
        );
        $Selenium->execute_script(
            "\$('#ServiceID').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );

        # Wait for the AJAX call to finish.
        $Selenium->WaitFor(
            ElementMissing =>
                "//i[contains(\@class,\'fa fa-circle-o-notch fa-spin\')]"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#ServiceID').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Verify selected 'My Queue' and 'My Service' preference values.
        $Self->Is(
            $Selenium->execute_script("return \$('#QueueID :selected').text().trim()"),
            $QueueName,
            "Selected Queue '$QueueName' is in 'My Queue'",
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#ServiceID :selected').text().trim()"),
            $ServiceName,
            "Selected Service '$ServiceName' is in 'My Services'",
        );

        # Navigate to AdminUser screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUser");
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($TestUserLogin);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();
        $Selenium->find_element( $TestUserLogin, 'link_text' )->VerifiedClick();

        # Submit not changed Agent data.
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Navigate to AgentPreferences notification setting screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=NotificationSettings"
        );

        # Verify 'My Queue' and 'My Service' values are not modified.
        $Self->Is(
            $Selenium->execute_script("return \$('#QueueID :selected').text().trim()"),
            $QueueName,
            "Selected Queue '$QueueName' is in 'My Queue'",
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#ServiceID :selected').text().trim()"),
            $ServiceName,
            "Selected Service '$ServiceName' is in 'My Services'",
        );

        # Create another test user.
        my $TestUserLogin2 = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin2,
            Password => $TestUserLogin2,
        );

        my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

        for my $Test (qw(ChangeUserLogin SetToInvalid)) {

            # Navigate to AdminUser screen.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUser");

            # Remove scheduled asynchronous tasks from DB, as they may interfere with tests run later.
            my @TaskIDs;
            my @AllTasks = $SchedulerDBObject->TaskList(
                Type => 'AsynchronousExecutor',
            );
            for my $Task (@AllTasks) {
                if ( $Task->{Name} eq 'Kernel::System::AuthSession-RemoveSessionByUser()' ) {
                    my $Success = $SchedulerDBObject->TaskDelete(
                        TaskID => $Task->{TaskID},
                    );
                    $Self->True(
                        $Success,
                        "$Test - TaskID $Task->{TaskID} is deleted",
                    );
                }
            }

            $Selenium->find_element( "#Search", 'css' )->clear();
            $Selenium->find_element( "#Search", 'css' )->send_keys($TestUserLogin);
            $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

            if ( $Test eq 'ChangeUserLogin' ) {
                $Selenium->WaitFor(
                    JavaScript => "return typeof(\$) === 'function' && \$('#User a:contains($TestUserLogin)').length;"
                );

                $Selenium->find_element( $TestUserLogin, 'link_text' )->VerifiedClick();

                $Selenium->WaitFor(
                    JavaScript => "return typeof(\$) === 'function' && \$('#UserLogin').length;"
                );

                $Self->Is(
                    $Selenium->find_element( "#UserLogin", 'css' )->get_value(),
                    $TestUserLogin,
                    "$Test - UserLogin value is correct",
                );

                $Selenium->find_element( "#UserLogin", 'css' )->send_keys('-edit');
                $Selenium->find_element( "#Submit",    'css' )->VerifiedClick();
            }
            else {
                $TestUserLogin .= '-edit';
                $Selenium->WaitFor(
                    JavaScript => "return typeof(\$) === 'function' && \$('#User a:contains($TestUserLogin)').length;"
                );

                $Selenium->find_element( $TestUserLogin, 'link_text' )->VerifiedClick();

                $Selenium->WaitFor(
                    JavaScript => "return typeof(\$) === 'function' && \$('#ValidID').length;"
                );

                $Self->Is(
                    $Selenium->find_element( "#ValidID", 'css' )->get_value(),
                    1,
                    "$Test - ValidID value is correct",
                );

                $Selenium->InputFieldValueSet(
                    Element => '#ValidID',
                    Value   => 2,
                );

                $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
            }

            @AllTasks = $SchedulerDBObject->TaskList(
                Type => 'AsynchronousExecutor',
            );

            for my $Task (@AllTasks) {
                if ( $Task->{Name} eq 'Kernel::System::AuthSession-RemoveSessionByUser()' ) {
                    $Self->True(
                        $Task->{TaskID},
                        "$Test - Task (Name 'RemoveSessionByUser()', TaskID $Task->{TaskID}) is found",
                    );

                    my $Success = $SchedulerDBObject->TaskDelete(
                        TaskID => $Task->{TaskID},
                    );
                    $Self->True(
                        $Success,
                        "$Test - TaskID $Task->{TaskID} is deleted",
                    );
                }
            }

        }

        # Cleanup.

        # Delete Queue.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success  = $DBObject->Do(
            SQL => "DELETE FROM personal_queues WHERE queue_id = $QueueID",
        );
        $Self->True(
            $Success,
            "Delete personal queues - $QueueID",
        );
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Delete Queue - $QueueID",
        );

        # Delete Service.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM personal_services WHERE service_id = $ServiceID",
        );
        $Self->True(
            $Success,
            "Delete personal services - $ServiceID",
        );
        $Success = $DBObject->Do(
            SQL => "DELETE FROM service WHERE id = $ServiceID",
        );
        $Self->True(
            $Success,
            "Delete Service - $ServiceID",
        );

        # Make sure the cache is correct.
        for my $Cache (qw(Queue Service)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }

);

1;
