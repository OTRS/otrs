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

        # enable tool bar TicketSearchProfile
        my %TicketSearchProfile = (
            Block       => "ToolBarSearchProfile",
            Description => "Search template",
            MaxWidth    => "40",
            Module      => "Kernel::Output::HTML::ToolBar::TicketSearchProfile",
            Name        => "Search template",
            Priority    => "1990010",
        );

        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'Frontend::ToolBarModule###11-Ticket::TicketSearchProfile',
            Value => \%TicketSearchProfile,
        );

        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###11-Ticket::TicketSearchProfile',
            Value => \%TicketSearchProfile
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

        # create ticket number
        my $TicketNumber = $TicketObject->TicketCreateNumber();

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            TN            => $TicketNumber,
            Title         => 'Selenium test ticket',
            Queue         => 'Raw',
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'open',
            CustomerID    => 'SeleniumCustomerID',
            CustomerUser  => "test\@localhost.com",
            OwnerID       => $TestUserID,
            UserID        => 1,
            ResponsibleID => $TestUserID,
        );

        # click on search
        $Selenium->find_element( "#GlobalSearchNav", 'css' )->click();

        # wait until search window is loading
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfileNew').length" );

        # create new template search
        my $SearchProfileName = "SeleniumTest";
        $Selenium->find_element( "#SearchProfileNew",       'css' )->click();
        $Selenium->find_element( "#SearchProfileAddName",   'css' )->send_keys($SearchProfileName);
        $Selenium->find_element( "#SearchProfileAddAction", 'css' )->click();
        $Selenium->execute_script(
            "\$('#Attribute').val('TicketNumber').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( ".AddButton", 'css' )->click();
        $Selenium->find_element("//input[\@name='TicketNumber']")->send_keys("$TicketNumber");
        $Selenium->find_element( "#SearchFormSubmit", 'css' )->click();

        # verify search
        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "Found on screen, Ticket Number - $TicketNumber",
        );

        # return to dashboard screen
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl");

        # click on test search profile
        $Selenium->execute_script(
            "\$('#ToolBarSearchProfile').val('SeleniumTest').trigger('redraw.InputField').trigger('change');"
        );

        sleep 1;

        # verify search profile
        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "Found on screen using search profile, Ticket Number - $TicketNumber",
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete search profile from DB
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM search_profile WHERE profile_name = ?",
            Bind => [ \$SearchProfileName ],
        );
        $Self->True(
            $Success,
            "Deleted test search profile",
        );

        # delete test ticket
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );
        $Self->True(
            $Success,
            "Delete ticket - $TicketID"
        );
    }
);

1;
