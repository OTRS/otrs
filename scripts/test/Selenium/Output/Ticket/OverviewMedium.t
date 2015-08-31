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
                RestoreSystemConfiguration => 1,
                }
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sort attributes config params
        my %SortOverview = (
            Age          => 1,
            Title        => 1,
            TicketNumber => 1,
        );

        # defines from which ticket attributes the agent can select the result order
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'TicketOverviewMenuSort###SortAttributes',
            Value => \%SortOverview,
        );
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'TicketOverviewMenuSort###SortAttributes',
            Value => \%SortOverview,
        );

        # create and log in test useer
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
        my @SortTicketNumbers = sort @TicketNumbers;

        # go to queue ticket overview
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketQueue;QueueID=$QueueID;View=");

        # switch to medium view
        $Selenium->find_element( "a.Medium", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('ul#TicketOverviewMedium').length" );

        # sort by ticket number
        $Selenium->execute_script(
            "\$('#SortBy').val('TicketNumber|Up').trigger('redraw.InputField').trigger('change');"
        );
        sleep 3;
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('div.MainBox')" );

        # set 10 tickets per page
        $Selenium->find_element( "a#ShowContextSettingsDialog", 'css' )->click();
        $Selenium->execute_script(
            "\$('#UserTicketOverviewMediumPageShown').val('10').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('a#AgentTicketQueuePage2').length" );

        # check for ticket with lowest ticket number on first 1st page and verifty that ticket
        # with highest ticket number number is not present
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[0] ) > -1,
            "$SortTicketNumbers[0] - found on screen"
        );
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[14] ) == -1,
            "$SortTicketNumbers[14] - not found on screen"
        );

        # switch to 2nd page to test pagination
        $Selenium->find_element( "#AgentTicketQueuePage2", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('ul#TicketOverviewMedium').length" );

        # check for ticket with highest ticket number
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[14] ) > -1,
            "$SortTicketNumbers[14] - found on screen"
        );

        # check if settings are stored when switching between view
        $Selenium->find_element( "a.Large",  'css' )->click();
        $Selenium->find_element( "a.Medium", 'css' )->click();
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[0] ) > -1,
            "$SortTicketNumbers[0] - found on screen after changing views"
        );
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[14] ) == -1,
            "$SortTicketNumbers[14] - not found on screen after changing views"
        );

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
