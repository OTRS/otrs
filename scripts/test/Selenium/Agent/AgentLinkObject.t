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

        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # do not check RichText
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'LinkObject::ViewMode',
            Value => 'Simple',
        );

        # create and login test customer
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my @TicketIDs;
        my @TicketNumbers;
        for my $Ticket ( 1 .. 2 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => 'Some Ticket Title',
                Queue        => 'Raw',
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

        # navigate to zoom view of created test ticket
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # hover on menu bar on the misc cluster
        $Selenium->WaitFor(
            JavaScript => 'return $("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
        );

        # click on 'Link'
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentLinkObject;SourceObject=Ticket;' )]")->click();

        # switch to link object window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # search for second created test ticket
        $Selenium->find_element(".//*[\@id='SEARCH::TicketNumber']")->send_keys( $TicketNumbers[1] );
        $Selenium->find_element(".//*[\@id='SEARCH::TicketNumber']")->submit();

        # link created test tickets
        $Selenium->find_element("//input[\@value='$TicketIDs[1]'][\@type='checkbox']")->click();
        $Selenium->execute_script(
            "\$('#TypeIdentifier').val('ParentChild::Target').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element("//button[\@type='submit'][\@name='AddLinks']")->click();

        # close link object window and switch back to agent ticket zoom
        $Selenium->close();
        $Selenium->switch_to_window( $Handles->[0] );

        # refresh agent ticket zoom
        $Selenium->refresh();

        # verify that parent test tickets is linked with child test ticket
        $Self->True(
            index( $Selenium->get_page_source(), 'Child' ) > -1,
            "Child - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "T:" . $TicketNumbers[1] ) > -1,
            "TicketNumber $TicketNumbers[1] - found",
        );

        # click on child ticket
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketZoom;TicketID=$TicketIDs[1]' )]")->click();

        # verify that child test ticket is linked with parent test ticket
        $Self->True(
            index( $Selenium->get_page_source(), 'Parent' ) > -1,
            "Parent - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "T:" . $TicketNumbers[0] ) > -1,
            "TicketNumber $TicketNumbers[0] - found",
        );

        # delete created test tickets
        for my $TicketID (@TicketIDs) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
            $Self->True(
                $Success,
                "Delete ticket - $TicketID"
            );
        }
    }
);

1;
