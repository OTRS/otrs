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

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 0,
                }
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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
            "QueueAdd() successful for test $QueueName - ID $QueueID",
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my @TicketIDs;
        my @TicketNumbers;
        for my $Ticket ( 1 .. 15 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => 'Some Ticket Title',
                Queue        => $QueueName,
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => '123465',
                CustomerUser => 'customer@example.com',
                OwnerID      => $TestUserID,
                UserID       => $TestUserID,
            );
            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;
        }

        # reverse sort test ticket numbers for test purposes
        my @SortTicketNumbers = reverse sort @TicketNumbers;

        # go to status open view, overview small
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # set filter to test queue
        $Selenium->find_element("//a[contains(\@title, \'Queue, filter not active\' )]")->click();
        $Selenium->WaitFor( JavaScript => "return \$('#ColumnFilterQueue option[value=\"$QueueID\"]').length;" );
        $Selenium->execute_script(
            "\$('#ColumnFilterQueue').val('$QueueID').trigger('redraw.InputField').trigger('change');");
        $Selenium->WaitFor( JavaScript => "return \$('li.ContextSettings.RemoveFilters').length" );

        # set tickets per page to 10
        $Selenium->find_element( "#ShowContextSettingsDialog", 'css' )->click();
        $Selenium->execute_script(
            "\$('#UserTicketOverviewSmallPageShown').val('10').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('div#OverviewBody').length" );

        # sort by ticket number, order up
        $Selenium->find_element("//a[contains(\@title, \'TicketNumber\' )]")->click();

        # check for ticket with highest ticket number on first 1st page and verifty that ticket
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
        $Selenium->find_element( "#AgentTicketStatusViewPage2", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('div#OverviewBody').length" );

        # check for ticket with lowest ticket number
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[14] ) > -1,
            "$SortTicketNumbers[14] - found on screen"
        );

        # test if filters are still stored
        $Selenium->refresh();

        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[14] ) > -1,
            "$SortTicketNumbers[14] - found on screen"
        );

        # remove all filters
        $Selenium->find_element( "li.ContextSettings.RemoveFilters a", 'css' )->click();

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

        # delete created test queue
        $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Delete queue - $QueueID",
        );

        # make sure cache is correct
        for my $Cache (qw( Ticket Queue )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
