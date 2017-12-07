# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
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

            # Clean any garbage
            $MailQueueClean->();

            return;
        };

        # Make sure we start with a clean mail queue.
        $MailQueueClean->();

        # enable involved agent feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###InvolvedAgent',
            Value => 1,
        );

        # enable involved agent feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###InformAgent',
            Value => 1,
        );

        # do not check RichText
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

        # create test users and login first
        my @TestUser;
        for my $User ( 1 .. 3 ) {
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

        # get test users ID
        my @UserID;
        for my $UserID (@TestUser) {
            my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
                UserLogin => $UserID,
            );

            push @UserID, $TestUserID;
        }

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
            OwnerID      => $UserID[2],
            UserID       => $UserID[2],
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # update the ticket owner to have an involved user
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

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to zoom view of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Communication ul").css({ "height": "auto", "opacity": "100" });'
        );

        # click on 'Note' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")
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
            qw(InvolvedUserID InformUserID Subject RichText FileUpload IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # change ticket user owner
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

        # Process mail queue items
        $MailQueueProcess->();

        # check that emailS was sent
        my $Emails = $TestEmailObject->EmailsGet();

        # there should be 3 emails, one for the inform user, one for the involved user and one for
        #   the owner
        $Self->Is(
            scalar @{$Emails},
            3,
            'EmailsGet()',
        );

        # extract recipients from emails and compare to the expected results, the emails are sent in
        #   order with the UserID
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

        # make sure to navigate to zoom view of created test ticket at this moment to prevent error
        #   messages after the ticket is deleted
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # delete created test tickets
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
            "Ticket is deleted - ID $TicketID",
        );

        # make sure the cache is correct
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
