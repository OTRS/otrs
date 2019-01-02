# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

        # do not check email addresses and mx records
        # change settings in both runtime and disk configuration
        for my $Key (qw(CheckEmailAddresses CheckMXRecord)) {
            $Helper->ConfigSettingChange(
                Key   => $Key,
                Value => 0,
            );
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => $Key,
                Value => 0,
            );
        }

        # Override FirstnameLastnameOrder setting to check if it is taken into account
        #   (see bug#12554 for more information).
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'FirstnameLastnameOrder',
            Value => 1,
        );

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

        my $RandomID = $Helper->GetRandomID();

        # create test queue
        my $QueueName = 'Queue' . $RandomID;
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
            "QueueAdd() successful for test $QueueName - ID $QueueID",
        );

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # create test users
        my @UserIDs;
        my %Users;
        for my $User ( 1 .. 15 ) {
            my $UserFirstname = 'Firstname' . $User;
            my $UserLastname  = 'Lastname' . $User;
            my $UserLogin     = 'test' . $RandomID . $User;
            my $UserID        = $UserObject->UserAdd(
                UserFirstname => $UserFirstname,
                UserLastname  => $UserLastname,
                UserLogin     => $UserLogin,
                UserEmail     => "test$RandomID$User\@example.com",
                ValidID       => 1,
                ChangeUserID  => $TestUserID,
            );
            $Self->True(
                $UserID,
                "User is created - $UserID",
            );

            push @UserIDs, $UserID;

            # Store user full name for later comparison.
            my %UserData = $UserObject->GetUserData(
                UserID => $UserID,
            );
            $Users{$UserID} = $UserData{UserFullname};
        }

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my @TicketIDs;
        my @TicketNumbers;
        for my $Ticket ( 1 .. 15 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN            => $TicketNumber,
                Title         => 'Some Ticket Title',
                Queue         => $QueueName,
                Lock          => 'unlock',
                Priority      => '3 normal',
                State         => 'new',
                CustomerID    => 'TestCustomer',
                CustomerUser  => 'customer@example.com',
                OwnerID       => $UserIDs[ $Ticket - 1 ],
                ResponsibleID => $UserIDs[ $Ticket - 1 ],
                UserID        => $TestUserID,
            );

            $Self->True(
                $TicketID,
                "Ticket is created - $TicketID"
            );

            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;
        }

        # reverse sort test ticket numbers for test purposes
        my @SortTicketNumbers = reverse sort @TicketNumbers;

        # go to status open view, overview small
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # set filter to test queue
        $Selenium->find_element("//a[contains(\@title, \'Queue, filter not active\' )]")->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#ColumnFilterQueue option[value=\"$QueueID\"]').length;"
        );
        $Selenium->execute_script(
            "\$('#ColumnFilterQueue').val('$QueueID').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('li.ContextSettings.RemoveFilters').length"
        );

        # set tickets per page to 10
        $Selenium->find_element( "#ShowContextSettingsDialog", 'css' )->VerifiedClick();
        $Selenium->execute_script(
            "\$('#UserTicketOverviewSmallPageShown').val('10').trigger('redraw.InputField').trigger('change');"
        );

        # TODO: remove limitation to firefox.
        if ( $Selenium->{browser_name} eq 'firefox' ) {
            $Self->True(
                1,
                "TODO: DragAndDrop is currently disabled in Firefox",
            );
        }
        else {

            # Move responsible from left to the right side.
            $Selenium->mouse_move_to_location(
                element => $Selenium->find_element( '//li[@data-fieldname="Responsible"]', 'xpath' ),
            );

            $Selenium->DragAndDrop(
                Element      => 'li[data-fieldname="Responsible"]',
                Target       => '#AssignedFields-DashboardAgentTicketStatusView',
                TargetOffset => {
                    X => 185,
                    Y => 10,
                },
            );
        }

        $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

        # sort by ticket number, order up
        $Selenium->find_element("//a[contains(\@title, \'TicketNumber\' )]")->VerifiedClick();

        # check for ticket with highest ticket number on first 1st page and verify that ticket
        # with lowest ticket number number is not present
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[0] ) > -1,
            "$SortTicketNumbers[0] - found on screen"
        );
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[14] ) == -1,
            "$SortTicketNumbers[14] - not found on screen"
        );

        # switch to 2nd page to test pagination
        $Selenium->find_element( "#AgentTicketStatusViewPage2", 'css' )->VerifiedClick();

        # check for ticket with lowest ticket number
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[14] ) > -1,
            "$SortTicketNumbers[14] - found on screen"
        );
        $Selenium->VerifiedRefresh();

        # test if filters are still stored
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[14] ) > -1,
            "$SortTicketNumbers[14] - found on screen"
        );

        my @Columns = (
            'Responsible',
            'Owner',
        );

        # TODO: remove limitation to firefox.
        # There is issue with DragAndDrop when Responsible column should be added on screen in Settings
        if ( $Selenium->{browser_name} eq 'firefox' ) {
            shift @Columns;
        }

        # Check if owner and responsible columns are sorted by full names instead of IDs
        #   (see bug#4439 for more information).
        for my $Column (@Columns) {

            # sort by column, order up
            $Selenium->find_element("//a[\@name='OverviewControl'][contains(\@title, '$Column')]")->VerifiedClick();

            # check user with 1 in their name is shown
            # and verify that user with 9 in their name is not present
            $Self->True(
                index( $Selenium->get_page_source(), $Users{ $UserIDs[9] } ) > -1,
                "$Users{ $UserIDs[0] } - found on screen"
            );
            $Self->True(
                index( $Selenium->get_page_source(), $Users{ $UserIDs[8] } ) == -1,
                "$Users{ $UserIDs[8] } - not found on screen"
            );

            # sort by column, order down
            $Selenium->find_element("//a[\@name='OverviewControl'][contains(\@title, '$Column')]")->VerifiedClick();

            # check user with 9 in their name is shown
            $Self->True(
                index( $Selenium->get_page_source(), $Users{ $UserIDs[8] } ) > -1,
                "$Users{ $UserIDs[8] } - found on screen"
            );
        }

        # remove all filters
        $Selenium->find_element( "li.ContextSettings.RemoveFilters a", 'css' )->VerifiedClick();

        # delete created test tickets
        my $Success;
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
            $Self->True(
                $Success,
                "Delete ticket - $TicketID"
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete created test users
        for my $UserID (@UserIDs) {
            $Success = $DBObject->Do(
                SQL => "DELETE FROM user_preferences WHERE user_id = $UserID",
            );
            $Self->True(
                $Success,
                "Delete user preferences - $UserID",
            );
            $Success = $DBObject->Do(
                SQL => "DELETE FROM users WHERE id = $UserID",
            );
            $Self->True(
                $Success,
                "Delete user - $UserID",
            );
        }

        # delete created test queue
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Delete queue - $QueueID",
        );

        # make sure cache is correct
        for my $Cache (qw( Ticket Queue User )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    },
);

1;
