# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable change owner to everyone feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::ChangeOwnerToEveryone',
            Value => 1
        );

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::AgentTicketOwner');
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketOwner',
            Value => {
                %$Config,
                Note          => 1,
                NoteMandatory => 1,
            },
        );

        # create test users and login first
        my @TestUser;
        for my $User ( 1 .. 2 ) {
            my $TestUserLogin = $Helper->TestUserCreate(
                Groups => [ 'admin', 'users' ],
            ) || die "Did not get test user";

            push @TestUser, $TestUserLogin;
        }

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUser[0],
            Password => $TestUser[0],
        );

        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # get test users ID
        my @UserID;
        for my $UserID (@TestUser) {
            my $TestUserID = $UserObject->UserLookup(
                UserLogin => $UserID,
            );

            push @UserID, $TestUserID;
        }

        my $DateTimeSettings = $Kernel::OM->Create('Kernel::System::DateTime')->Get();
        my %Values           = (
            'OutOfOffice'           => 'on',
            'OutOfOfficeStartYear'  => $DateTimeSettings->{Year},
            'OutOfOfficeStartMonth' => $DateTimeSettings->{Month},
            'OutOfOfficeStartDay'   => $DateTimeSettings->{Day},
            'OutOfOfficeEndYear'    => $DateTimeSettings->{Year} + 1,
            'OutOfOfficeEndMonth'   => $DateTimeSettings->{Month},
            'OutOfOfficeEndDay'     => $DateTimeSettings->{Day},
        );

        for my $Key ( sort keys %Values ) {
            $UserObject->SetPreferences(
                UserID => $UserID[1],
                Key    => $Key,
                Value  => $Values{$Key},
            );
        }

        my %UserData = $UserObject->GetUserData(
            UserID => $UserID[1],
            Valid  => 0,
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => $UserID[1],
            UserID       => $UserID[1],
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to zoom view of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-People ul").css({ "height": "auto", "opacity": "100" });'
        );

        # click on 'Owner' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketOwner;TicketID=$TicketID' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # check page
        for my $ID (
            qw(NewOwnerID Subject RichText FileUpload IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check out of office user message without filter
        $Self->Is(
            $Selenium->execute_script("return \$('#NewOwnerID option[value=$UserID[1]]').text();"),
            "$UserData{UserFullname}",
            "Out of office message is found for the user - $TestUser[1]"
        );

        # expand 'New owner' input field
        $Selenium->execute_script("\$('#NewOwnerID_Search').focus().focus()");

        # click on filter button in input fileld
        $Selenium->execute_script("\$('.InputField_Filters').click();");

        # enable 'Previous Owner' filter
        $Selenium->execute_script("\$('.InputField_FiltersList').children('input').click();");

        # check out of office user message with filter
        $Self->Is(
            $Selenium->execute_script("return \$('#NewOwnerID option[value=$UserID[1]]').text();"),
            "1: $UserData{UserFullname}",
            "Out of office message is found for the user - $TestUser[1]"
        );

        # change ticket user owner
        $Selenium->execute_script(
            "\$('#NewOwnerID').val('$UserID[1]').trigger('redraw.InputField').trigger('change');"
        );

        $Selenium->find_element( "#Subject",        'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # navigate to AgentTicketHistory of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # confirm owner change action
        my $OwnerMsg = "Added note (Owner)";
        $Self->True(
            index( $Selenium->get_page_source(), $OwnerMsg ) > -1,
            "Ticket owner action completed",
        );

        # delete created test tickets
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $UserID[0],
        );
        $Self->True(
            $Success,
            "Ticket is deleted - ID $TicketID"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );

    }
);

1;
