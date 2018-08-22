# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

        # Enable change owner to everyone feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::ChangeOwnerToEveryone',
            Value => 1
        );

        # Do not check RichText.
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

        # Create test users and login first.
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

        # Get test users ID.
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

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
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

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-People ul").css({ "height": "auto", "opacity": "100" });'
        );

        # Click on 'Owner' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketOwner;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Check page.
        for my $ID (
            qw(NewOwnerID Subject RichText FileUpload IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check out of office user message without filter.
        $Self->Is(
            $Selenium->execute_script("return \$('#NewOwnerID option[value=$UserID[1]]').text();"),
            "$UserData{UserFullname}",
            "Out of office message is found for the user - $TestUser[1]"
        );

        # Expand 'New owner' input field.
        $Selenium->execute_script("\$('#NewOwnerID_Search').focus().focus()");

        # Click on filter button in input fileld.
        $Selenium->execute_script("\$('.InputField_Filters').click();");

        # Enable 'Previous Owner' filter.
        $Selenium->execute_script("\$('.InputField_FiltersList').children('input').click();");

        # Check out of office user message with filter.
        $Self->Is(
            $Selenium->execute_script("return \$('#NewOwnerID option[value=$UserID[1]]').text();"),
            "1: $UserData{UserFullname}",
            "Out of office message is found for the user - $TestUser[1]"
        );

        # Change ticket user owner.
        $Selenium->execute_script(
            "\$('#NewOwnerID').val('$UserID[1]').trigger('redraw.InputField').trigger('change');"
        );

        $Selenium->find_element( "#Subject",        'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Navigate to AgentTicketHistory of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # Confirm owner change action.
        my $OwnerMsg = "Added note (Owner)";
        $Self->True(
            index( $Selenium->get_page_source(), $OwnerMsg ) > -1,
            "Ticket owner action completed",
        );

        # Login as second created user who is set Out Of Office and create Note article, see bug#13521.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUser[1],
            Password => $TestUser[1],
        );

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Communication ul").css({ "height": "auto", "opacity": "100" });'
        );

        # Click on 'Note' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Create Note article.
        $Selenium->find_element( "#Subject",        'css' )->send_keys('TestSubject');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('TestBody');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Switch window back to AgentTicketZoom view of created test ticket.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Verified there is no Out Of Office message in the 'Sender' column of created Note.
        $Self->Is(
            $Selenium->execute_script("return \$('#Row2 .Sender a').text();"),
            "$TestUser[1] $TestUser[1]",
            "There is no Out Of Office message in the article 'Sender' column."
        );

        # Delete created test tickets.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $UserID[0],
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $UserID[0],
            );
        }
        $Self->True(
            $Success,
            "Ticket is deleted - ID $TicketID"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
