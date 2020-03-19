# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
        my $GroupObject     = $Kernel::OM->Get('Kernel::System::Group');
        my $QueueObject     = $Kernel::OM->Get('Kernel::System::Queue');

        my %MailQueueCurrentItems = map { $_->{ID} => $_ } @{ $MailQueueObject->List() || [] };

        my $MailQueueClean = sub {
            my $Items = $MailQueueObject->List();
            MAIL_QUEUE_ITEM:
            for my $Item ( @{$Items} ) {
                next MAIL_QUEUE_ITEM if $MailQueueCurrentItems{ $Item->{ID} };
                $MailQueueObject->Delete(
                    ID => $Item->{ID},
                );
            }

            return;
        };

        my $MailQueueProcess = sub {
            my %Param = @_;

            my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

            # Process all items except the ones already present before the tests.
            my $Items = $MailQueueObject->List();
            MAIL_QUEUE_ITEM:
            for my $Item ( @{$Items} ) {
                next MAIL_QUEUE_ITEM if $MailQueueCurrentItems{ $Item->{ID} };
                $MailQueueObject->Send( %{$Item} );
            }

            # Clean any garbage.
            $MailQueueClean->();

            return;
        };

        # Make sure we start with a clean mail queue.
        $MailQueueClean->();

        # Enable involved agent feature in AgentTicketNote.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###InvolvedAgent',
            Value => 1,
        );

        # Enable inform agent feature in AgentTicketNote.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###InformAgent',
            Value => 1,
        );

        # Enable inform agent feature in AgentTicketResponsible.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketResponsible###InformAgent',
            Value => 1,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'AgentSelfNotifyOnAction',
            Value => 1,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        $Helper->ConfigSettingChange(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Responsible',
            Value => 1,
        );

        # Create test users.
        my @TestUser;
        for my $User ( 1 .. 3 ) {
            my $TestUserLogin = $Helper->TestUserCreate(
                Groups => [ 'admin', 'users' ],
            ) || die "Did not get test user";

            push @TestUser, $TestUserLogin;
        }

        # Get test users ID.
        my @UserID;
        for my $UserID (@TestUser) {
            my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
                UserLogin => $UserID,
            );
            push @UserID, $TestUserID;
        }

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
            OwnerID      => $UserID[2],
            UserID       => $UserID[2],
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # Update the ticket owner to have an involved user.
        my $Success = $TicketObject->TicketOwnerSet(
            TicketID  => $TicketID,
            NewUserID => $UserID[0],
            UserID    => $UserID[2],
        );

        my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');

        $Success = $TestEmailObject->CleanUp();
        $Self->True(
            $Success,
            'Cleanup Email backend',
        );

        # Login as the first created test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUser[0],
            Password => $TestUser[0],
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketNote view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketNote;TicketID=$TicketID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Check page.
        for my $ID (
            qw(InvolvedUserID InformUserID Subject RichText FileUpload IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Change ticket user owner.
        $Selenium->InputFieldValueSet(
            Element => '#InvolvedUserID',
            Value   => $UserID[2],
        );
        $Selenium->InputFieldValueSet(
            Element => '#InformUserID',
            Value   => $UserID[1],
        );
        $Selenium->find_element( "#Subject",        'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Process mail queue items.
        $MailQueueProcess->();

        # Check that emailS was sent.
        my $Emails = $TestEmailObject->EmailsGet();

        # There should be 3 emails, one for the inform user, one for the involved user and one for the owner.
        $Self->Is(
            scalar @{$Emails},
            3,
            'EmailsGet()',
        );

        # Extract recipients from emails and compare to the expected results, the emails are sent in
        #   order with the UserID.
        my @Recipients;
        for my $Email ( @{$Emails} ) {
            push @Recipients, $Email->{ToArray}->[0];
        }
        my @Ordered = sort @Recipients;
        $Self->IsDeeply(
            \@Ordered,
            [
                $TestUser[0] . '@localunittest.com',
                $TestUser[1] . '@localunittest.com',
                $TestUser[2] . '@localunittest.com',
            ],
            'Email recipients',
        );

        # Verify InformAgent are in Article 'To' as recipients.
        my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );
        my @Articles             = $ArticleObject->ArticleList(
            TicketID => $TicketID,
        );
        my %Article = $ArticleBackendObject->ArticleGet(
            TicketID  => $TicketID,
            ArticleID => $Articles[0]->{ArticleID},
        );
        my $ExpectedArticleTo
            = "\"$TestUser[1] $TestUser[1]\" <$TestUser[1]\@localunittest.com>, \"$TestUser[2] $TestUser[2]\" <$TestUser[2]\@localunittest.com>";

        $Self->Is(
            $Article{To},
            $ExpectedArticleTo,
            "InformAgent are in Article 'To' correctly "
        );

        # Navigate to AgentTicketResponsible view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketResponsible;TicketID=$TicketID");

        $Selenium->InputFieldValueSet(
            Element => '#NewResponsibleID',
            Value   => $UserID[1],
        );
        $Selenium->InputFieldValueSet(
            Element => '#InformUserID',
            Value   => $UserID[1],
        );

        if ( $Selenium->execute_script("return \$('#WidgetArticle.Collapsed').length;") ) {
            $Selenium->execute_script("\$('#WidgetArticle .Header a').click();");
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#WidgetArticle.Expanded").length;'
            );
        }

        $Selenium->find_element( "#Subject",        'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Navigate to AgentTicketZoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Clean the article cache, otherwise we'll get the caches result,
        # which are wrong.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Article',
        );

        # Verify InformAgent are in Article 'To' as recipients.
        @Articles = $ArticleObject->ArticleList(
            TicketID => $TicketID,
        );
        %Article = $ArticleBackendObject->ArticleGet(
            TicketID  => $TicketID,
            ArticleID => $Articles[-1]->{ArticleID},
        );
        $ExpectedArticleTo = "\"$TestUser[1] $TestUser[1]\" <$TestUser[1]\@localunittest.com>";

        $Self->Is(
            $Article{To},
            $ExpectedArticleTo,
            "InformAgent are in Article 'To' correctly "
        );

        my $NewTicketID;
        my $RandomID = $Helper->GetRandomID();

        # Add new groups and queues.
        my $Group0 = $GroupObject->GroupAdd(
            Name    => 'Group0-' . $RandomID,
            ValidID => 1,
            UserID  => $UserID[0],
        );
        $Self->True(
            $Group0,
            "Group Group0-$RandomID is created."
        );
        my $Group1 = $GroupObject->GroupAdd(
            Name    => 'Group1-' . $RandomID,
            ValidID => 1,
            UserID  => $UserID[1],
        );
        $Self->True(
            $Group1,
            "Group Group1-$RandomID is created."
        );
        my $Queue0 = $QueueObject->QueueAdd(
            Name            => 'Queue0-' . $RandomID,
            ValidID         => 1,
            GroupID         => $Group0,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => $UserID[0],
            Comment         => 'Some Comment',
        );
        $Self->True(
            $Queue0,
            "Queue Queue0-$RandomID is created.",
        );
        my $Queue1 = $QueueObject->QueueAdd(
            Name            => 'Queue1-' . $RandomID,
            ValidID         => 1,
            GroupID         => $Group1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => $UserID[1],
            Comment         => 'Some Comment',
        );
        $Self->True(
            $Queue1,
            "Queue Queue1-$RandomID is created.",
        );

        my @Permissions = (
            {
                UID        => $UserID[0],
                GID        => $Group0,
                Permission => {
                    ro        => 1,
                    move_into => 1,
                    create    => 1,
                    note      => 1,
                    owner     => 1,
                    priority  => 1,
                    rw        => 1,
                },
            },
            {
                UID        => $UserID[1],
                GID        => $Group1,
                Permission => {
                    ro        => 1,
                    move_into => 1,
                    create    => 1,
                    note      => 1,
                    owner     => 1,
                    priority  => 1,
                    rw        => 1,
                },
            },
            {
                UID        => $UserID[0],
                GID        => $Group1,
                Permission => {
                    ro        => 1,
                    move_into => 1,
                    create    => 0,
                    note      => 1,
                    owner     => 0,
                    priority  => 0,
                    rw        => 0,
                },
            },
            {
                UID        => $UserID[1],
                GID        => $Group0,
                Permission => {
                    ro        => 0,
                    move_into => 1,
                    create    => 0,
                    note      => 1,
                    owner     => 0,
                    priority  => 0,
                    rw        => 0,
                },
            }
        );

        for my $Permission (@Permissions) {

            # Add user group permissions.
            $Success = $GroupObject->PermissionGroupUserAdd(
                %{$Permission},
                UserID => $UserID[2],
            );
            $Self->True(
                $Success,
                "UserID $Permission->{UID} set permissions for group ID $Permission->{GID}."
            );
        }

        # Create new test ticket in Queue0.
        $NewTicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Group Test Ticket',
            Queue        => 'Queue0-' . $RandomID,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => $UserID[0],
            UserID       => $UserID[0],
        );
        $Self->True(
            $NewTicketID,
            "Ticket is created - ID $NewTicketID",
        );

        # Move the test ticket to Queue1.
        $Success = $TicketObject->TicketQueueSet(
            QueueID  => $Queue1,
            TicketID => $NewTicketID,
            UserID   => $UserID[0],
        );

        # Change ticket owner.
        $Success = $TicketObject->TicketOwnerSet(
            TicketID  => $NewTicketID,
            NewUserID => $UserID[1],
            UserID    => $UserID[0],
        );

        # Lock the test ticket with User 1.
        $TicketObject->TicketLockSet(
            Lock     => 'lock',
            TicketID => $NewTicketID,
            UserID   => $UserID[1],
        );

        # Make sure we start with a clean mail queue.
        $MailQueueClean->();

        $Success = $TestEmailObject->CleanUp();
        $Self->True(
            $Success,
            'Cleanup Email backend.',
        );

        # Login as the second created test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUser[1],
            Password => $TestUser[1],
        );

        # Navigate to AgentTicketNote view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketNote;TicketID=$NewTicketID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Select involved user, fill necessary fields and save the note.
        $Selenium->InputFieldValueSet(
            Element => '#InvolvedUserID',
            Value   => $UserID[0],
        );
        $Selenium->find_element( "#Subject",        'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Process mail queue items.
        $MailQueueProcess->();

        # Check that emailS was sent.
        $Emails = $TestEmailObject->EmailsGet();

        # There should be 3 emails, one for the inform user, one for the involved user and one for the owner.
        $Self->Is(
            scalar @{$Emails},
            2,
            'EmailsGet()',
        );

        # Extract recipients from emails and compare to the expected results, the emails are sent in
        #   order with the UserID.
        my @NewRecipients;
        for my $Email ( @{$Emails} ) {
            push @NewRecipients, $Email->{ToArray}->[0];
        }
        @Ordered = sort @NewRecipients;
        $Self->IsDeeply(
            \@Ordered,
            [
                $TestUser[0] . '@localunittest.com',
                $TestUser[1] . '@localunittest.com',
            ],
            'Email recipients',
        );

        # Delete created test ticket.
        for my $TicketDelete ( $NewTicketID, $TicketID ) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketDelete,
                UserID   => $UserID[0],
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketDelete,
                    UserID   => $UserID[0],
                );
            }
            $Self->True(
                $Success,
                "TicketID $TicketDelete is deleted.",
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete group-user relation.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_user WHERE user_id = ?",
            Bind => [ \$UserID[0] ],
        );
        $Self->True(
            $Success,
            "Relation for UserID $UserID[0] is deleted.",
        );
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_user WHERE user_id = ?",
            Bind => [ \$UserID[1] ],
        );
        $Self->True(
            $Success,
            "Relation for UserID $UserID[1] is deleted.",
        );

        # Delete test queues.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM queue WHERE id = ?",
            Bind => [ \$Queue0 ],
        );
        $Self->True(
            $Success,
            "Queue is deleted - ID $Queue0",
        );
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM queue WHERE id = ?",
            Bind => [ \$Queue1 ],
        );
        $Self->True(
            $Success,
            "Queue is deleted - ID $Queue1",
        );

        # Delete test groups.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM groups WHERE id = ?",
            Bind => [ \$Group0 ],
        );
        $Self->True(
            $Success,
            "Group is deleted - ID $Group0",
        );
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM groups WHERE id = ?",
            Bind => [ \$Group1 ],
        );
        $Self->True(
            $Success,
            "Group is deleted - ID $Group1",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );

        $Success = $TestEmailObject->CleanUp();
        $Self->True(
            $Success,
            'Cleanup Email backend',
        );
    }
);

1;
