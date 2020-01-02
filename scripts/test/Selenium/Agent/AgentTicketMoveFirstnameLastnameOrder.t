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

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Set to change queue for ticket in a new window.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MoveType',
            Value => 'link'
        );

        # Enable note in AgentTicketMove screen.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketMove###Note',
            Value => 1
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Set FirstnameLastnameOrder to 3 - 'Lastname, Firstname (UserLogin)'.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'FirstnameLastnameOrder',
            Value => 3
        );

        my $RandomID  = $Helper->GetRandomID();
        my $Firstname = "Firstname$RandomID";
        my $Lastname  = "Lastname$RandomID";
        my $UserLogin = "UserLogin$RandomID";

        # Create test user.
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserAdd(
            UserFirstname => $Firstname,
            UserLastname  => $Lastname,
            UserLogin     => $UserLogin,
            UserPw        => $UserLogin,
            UserEmail     => "$UserLogin\@localunittest.com",
            ValidID       => 1,
            ChangeUserID  => 1,
        );
        $Self->True(
            $UserID,
            "UserID $UserID is created"
        );

        my $Success;

        for my $GroupName (qw(admin users)) {

            my $GroupID = $GroupObject->GroupLookup(
                Group => $GroupName,
            );
            $Success = $GroupObject->PermissionGroupUserAdd(
                GID        => $GroupID,
                UID        => $UserID,
                Permission => {
                    ro        => 1,
                    move_into => 1,
                    create    => 1,
                    owner     => 1,
                    priority  => 1,
                    rw        => 1,
                },
                UserID => 1,
            );
            $Self->True(
                $Success,
                "UserID $UserID set permission for '$GroupName' group"
            );
        }

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => "Selenium Test Ticket",
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => "SeleniumCustomer\@localhost.com",
            OwnerID      => $UserID,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $UserLogin,
            Password => $UserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketMove;TicketID=$TicketID");

        # Wait until page has loaded.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#DestQueueID").length;' );

        # Change ticket queue.
        $Selenium->InputFieldValueSet(
            Element => '#DestQueueID',
            Value   => 4,
        );

        $Selenium->execute_script("\$('#WidgetArticle.Collapsed .WidgetAction > a').trigger('click');");
        $Selenium->WaitFor( JavaScript => 'return $("#WidgetArticle.Expanded").length;' );

        $Selenium->find_element( "#Subject",        'css' )->send_keys("Subject-QueueMove$RandomID");
        $Selenium->find_element( "#RichText",       'css' )->send_keys("Body-QueueMove$RandomID");
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Wait until page has loaded.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#ArticleTable tbody .Sender a").length;'
        );

        # Check if the sender format is correct.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ArticleTable tbody .Sender a:contains(\"$Lastname, $Firstname ($UserLogin)\")').length;"
            ),
            1,
            "Sender format is correct - defined in FirstnameLastnameOrder setting",
        ) || die;

        # Delete test ticket.
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        $Self->True(
            $Success,
            "TicketID $TicketID is deleted"
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete group-user relation.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_user WHERE user_id =  ?",
            Bind => [ \$UserID ],
        );
        $Self->True(
            $Success,
            "Relation for UserID $UserID is deleted",
        );

        # Delete test created user.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM user_preferences WHERE user_id = ?",
            Bind => [ \$UserID ],
        );
        $Self->True(
            $Success,
            "User preferences for $UserID is deleted",
        );

        $Success = $DBObject->Do(
            SQL  => "DELETE FROM users WHERE id = ?",
            Bind => [ \$UserID ],
        );
        $Self->True(
            $Success,
            "UserID $UserID is deleted",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw( Ticket User )) {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
