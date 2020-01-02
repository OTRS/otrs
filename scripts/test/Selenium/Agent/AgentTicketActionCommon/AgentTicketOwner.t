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

        # Disable check of email addresses.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Disable MX record check.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckMXRecord',
            Value => 0,
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
            "Ticket $TicketID is created",
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to owner screen of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketOwner;TicketID=$TicketID");

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
        $Selenium->execute_script("\$('#NewOwnerID_Search').focus().focus();");

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
        $Selenium->InputFieldValueSet(
            Element => '#NewOwnerID',
            Value   => $UserID[1],
        );

        $Selenium->find_element( "#Subject",        'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

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

        # Navigate to note screen of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketNote;TicketID=$TicketID");

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#Subject").length && $("#RichText").length && $("#submitRichText").length;'
        );

        # Create Note article.
        $Selenium->find_element( "#Subject",        'css' )->send_keys('TestSubject');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('TestBody');
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#Row2 .Sender a').text() === '$TestUser[1] $TestUser[1]';"
        );

        # Verified there is no Out Of Office message in the 'Sender' column of created Note.
        $Self->Is(
            $Selenium->execute_script("return \$('#Row2 .Sender a').text();"),
            "$TestUser[1] $TestUser[1]",
            "There is no Out Of Office message in the article 'Sender' column."
        );

        # Check <OTRS_CUSTOMER_BODY> tag in NotificationOwnerUpdate notification body (see bug#14678).
        my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
        my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');

        # Cleanup mail queue.
        $MailQueueObject->Delete();

        my $SendEmails = sub {
            my %Param = @_;
            my $Items = $MailQueueObject->List();
            my @ToReturn;
            for my $Item (@$Items) {
                $MailQueueObject->Send( %{$Item} );
                push @ToReturn, $Item->{Message};
            }

            # Clean mail queue.
            $MailQueueObject->Delete();

            return @ToReturn;
        };

        # Enable Test email backend.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        # Cleanup test email backend.
        my $Success = $TestEmailObject->CleanUp();
        $Self->True(
            $Success,
            'Initial cleanup',
        );

        # Disable AgentTicketOwner###NoteMandatory.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketOwner###NoteMandatory',
            Value => 0
        );

        my $RandomID = $Helper->GetRandomID();
        my $Subject  = "Subject-$RandomID";
        my $Body     = "Body-$RandomID";

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        # Create customer article for test ticket.
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 1,
            SenderType           => 'customer',
            Subject              => $Subject,
            Body                 => $Body,
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Some free text!',
            UserID               => $UserID[1],
        );
        $Self->True(
            $ArticleID,
            "ArticleID $ArticleID is created for TicketID $TicketID",
        );

        # Add notification.
        my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');
        my $NotificationID          = $NotificationEventObject->NotificationAdd(
            Name => "Notification-$RandomID",
            Data => {
                Events          => ['NotificationOwnerUpdate'],
                RecipientAgents => [ $UserID[0] ],
                Transports      => ['Email'],
            },
            Message => {
                en => {
                    Subject     => "Notification-Subject-$RandomID",
                    Body        => 'OTRS_CUSTOMER_BODY tag: <OTRS_CUSTOMER_BODY>',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $NotificationID,
            "NotificationID $NotificationID is created",
        );

        # Navigate to owner screen of created test ticket to change owner without note (article).
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketOwner;TicketID=$TicketID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".WidgetSimple").length && $("#NewOwnerID").length;'
        );

        # Change ticket owner.
        $Selenium->InputFieldValueSet(
            Element => '#NewOwnerID',
            Value   => $UserID[0],
        );

        # Submit.
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        $SendEmails->();

        # Get test emails.
        my $Emails = $TestEmailObject->EmailsGet();

        # Check if OTRS_CUSTOMER_BODY tag is replaced correctly in any email.
        my $Found = 0;
        my $Match = "OTRS_CUSTOMER_BODY tag: $Body";
        EMAIL:
        for my $Email ( @{$Emails} ) {
            $Found = ( ${ $Email->{Body} } =~ m/$Match/ ? 1 : 0 );
            last EMAIL if $Found;
        }

        $Self->True(
            $Found,
            'OTRS_CUSTOMER_BODY tag is replaced correctly',
        );

        # Cleanup test email backend and mail queue.
        $TestEmailObject->CleanUp();
        $MailQueueObject->Delete();

        $Success = $NotificationEventObject->NotificationDelete(
            ID     => $NotificationID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "NotificationID $NotificationID is deleted",
        );

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
            "Ticket $TicketID is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
