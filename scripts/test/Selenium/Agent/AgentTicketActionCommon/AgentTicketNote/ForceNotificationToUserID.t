# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

        # Enable involved agent feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###InvolvedAgent',
            Value => 1,
        );

        # Enable involved agent feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###InformAgent',
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

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Wait until page has loaded.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function";' );

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script("\$('#nav-Communication ul').css('height', 'auto');");
        $Selenium->execute_script("\$('#nav-Communication ul').css('opacity', '1');");
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#nav-Communication ul').css('height') !== '0px' && \$('#nav-Communication ul').css('opacity') == '1';"
        );

        # Click on 'Note' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")->click();

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
            qw(InvolvedUserID InformUserID Subject RichText FileUpload IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Change ticket user owner.
        $Selenium->execute_script(
            "\$('#InvolvedUserID').val('$UserID[2]').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script(
            "\$('#InformUserID').val('$UserID[1]').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#Subject",        'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

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

        # Make sure to navigate to zoom view of created test ticket at this moment to prevent error
        #   messages after the ticket is deleted.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Delete created test tickets.
        $Success = $TicketObject->TicketDelete(
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
            "TicketID $TicketID is deleted",
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
