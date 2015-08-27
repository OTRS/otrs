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
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # do not check RichText
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticcket
        my $TicketID = $TicketObject->TicketCreate(
            TN           => $TicketObject->TicketCreateNumber(),
            Title        => "Selenium Test Ticket",
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => "SeleniumCustomer\@localhost.com",
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );

        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID",
        );

        # naviage to zoom view of created test ticket
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # check ticket priority
        $Self->True(
            index( $Selenium->get_page_source(), '3 normal' ) > -1,
            "Ticket priority checked - 3 normal",
        );

        # click on 'Priority' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketPriority;TicketID=$TicketID' )]")->click();

        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check page
        for my $ID (
            qw(NewPriorityID Subject RichText FileUpload ArticleTypeID submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        my $Element = $Selenium->find_element( "#RichText", 'css' );
        $Element->send_keys("");
        $Element->submit();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#RichText').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # change ticket priority
        $Selenium->execute_script("\$('#NewPriorityID').val('5').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",        'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        $Selenium->switch_to_window( $Handles->[0] );
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # confirm priority change action
        my $PriorityMsg = "Changed priority from \"3 normal\" (3) to \"5 very high\" (5).";
        $Self->True(
            index( $Selenium->get_page_source(), $PriorityMsg ) > -1,
            "Ticket priority change action completed",
        );

        # delete created test tickets
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );
        $Self->True(
            $Success,
            "Delete ticket - $TicketID"
        );

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );

    }
);

1;
