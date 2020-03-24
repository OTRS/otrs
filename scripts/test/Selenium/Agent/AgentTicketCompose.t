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

use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper                    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
        my $StandardTemplateObject    = $Kernel::OM->Get('Kernel::System::StandardTemplate');
        my $CustomerUserObject        = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');

        # Disable check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Do not check service and type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # Disable RequiredLock for AgentTicketCompose.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketCompose###RequiredLock',
            Value => 0
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketCompose###MessageIsVisibleForCustomer',
            Value => '1'
        );

        # Use test email backend.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        my $RandomID = $Helper->GetRandomID();

        my %DynamicFields = (
            Text => {
                Name       => 'TestText' . $RandomID,
                Label      => 'TestText' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'Text',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue => '',
                    Link         => '',
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
            Dropdown => {
                Name       => 'TestDropdown' . $RandomID,
                Label      => 'TestDropdown' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'Dropdown',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue   => '',
                    Link           => '',
                    PossibleNone   => 0,
                    PossibleValues => {
                        0 => 'No',
                        1 => 'Yes',
                    },
                    TranslatableValues => 1,
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
            Multiselect => {
                Name       => 'TestMultiselect' . $RandomID,
                Label      => 'TestMultiselect' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'Multiselect',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue   => '',
                    Link           => '',
                    PossibleNone   => 0,
                    PossibleValues => {
                        year  => 'year',
                        month => 'month',
                        week  => 'week',
                    },
                    TranslatableValues => 1,
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
            Date => {
                Name       => 'TestDate' . $RandomID,
                Label      => 'TestDate' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'Date',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue  => 0,
                    YearsInFuture => 0,
                    YearsInPast   => 0,
                    YearsPeriod   => 0,
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
            DateTime => {
                Name       => 'TestDateTime' . $RandomID,
                Label      => 'TestDateTime' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'DateTime',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue  => 0,
                    YearsInFuture => 0,
                    YearsInPast   => 0,
                    YearsPeriod   => 0,
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
        );

        my @DynamicFieldIDs;

        # Create test dynamic fields.
        for my $DynamicFieldType ( sort keys %DynamicFields ) {

            my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
                %{ $DynamicFields{$DynamicFieldType} },
            );

            $Self->True(
                $DynamicFieldID,
                "Dynamic field $DynamicFields{$DynamicFieldType}->{Name} - ID $DynamicFieldID - created",
            );

            push @DynamicFieldIDs, $DynamicFieldID;
        }

        # Create a new template.
        my $TemplateID = $StandardTemplateObject->StandardTemplateAdd(
            Name     => 'New Standard Template' . $RandomID,
            Template => "Thank you for your email.
                             Ticket state: <OTRS_TICKET_State>.\n
                             Ticket lock: <OTRS_TICKET_Lock>.\n
                             Ticket priority: <OTRS_TICKET_Priority>.\n
                             Ticket created: <OTRS_TICKET_Created>.\n
                             Ticket pending until time: <OTRS_TICKET_UntilTime>.\n
                             Ticket will not be used till: <OTRS_TICKET_RealTillTimeNotUsed>.\n
                             DynamicField Text: <OTRS_TICKET_DynamicField_" . $DynamicFields{Text}->{Name} . "_Value>
                             DynamicField Dropdown: <OTRS_TICKET_DynamicField_"
                . $DynamicFields{Dropdown}->{Name}
                . "_Value>
                             DynamicField Multiselect: <OTRS_TICKET_DynamicField_"
                . $DynamicFields{Multiselect}->{Name}
                . "_Value>
                             DynamicField Date: <OTRS_TICKET_DynamicField_" . $DynamicFields{Date}->{Name} . "_Value>
                             DynamicField DateTime: <OTRS_TICKET_DynamicField_"
                . $DynamicFields{DateTime}->{Name}
                . "_Value>
                            ",
            ContentType  => 'text/plain; charset=utf-8',
            TemplateType => 'Answer',
            ValidID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TemplateID,
            "Standard template is created - ID $TemplateID",
        );

        # Assign template to the queue.
        my $Success = $Kernel::OM->Get('Kernel::System::Queue')->QueueStandardTemplateMemberAdd(
            QueueID            => 1,
            StandardTemplateID => $TemplateID,
            Active             => 1,
            UserID             => 1,
        );
        $Self->True(
            $Success,
            "$TemplateID is assigned to the queue.",
        );

        # Create test user with admin permissions.
        my $UserName = "Name$RandomID";
        my $UserID   = $Kernel::OM->Get('Kernel::System::User')->UserAdd(
            UserFirstname => $UserName,
            UserLastname  => $UserName,
            UserLogin     => $UserName,
            UserEmail     => "$UserName\@example.com",
            ValidID       => 1,
            ChangeUserID  => 1,
        );
        $Self->True(
            $UserID,
            "UserID $UserID is created",
        );

        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        my $GroupID = $GroupObject->GroupLookup(
            Group => 'admin',
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
            "UserID '$UserID' set permission for 'admin' group"
        );

        # Create test customer.
        my $TestCustomer       = 'Customer' . $RandomID;
        my $CustomerEmail      = "$TestCustomer\@localhost.com";
        my $TestCustomerUserID = $CustomerUserObject->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomer,
            UserLastname   => $TestCustomer,
            UserCustomerID => $TestCustomer,
            UserLogin      => $TestCustomer,
            UserEmail      => $CustomerEmail,
            ValidID        => 1,
            UserID         => 1
        );
        $Self->True(
            $TestCustomerUserID,
            "CustomerUserAdd - ID $TestCustomerUserID",
        );

        # Set customer user language.
        my $Language = 'es';
        $Success = $CustomerUserObject->SetPreferences(
            Key    => 'UserLanguage',
            Value  => $Language,
            UserID => $TestCustomer,
        );
        $Self->True(
            $Success,
            "Customer user language is set.",
        );

        # Create test ticket.
        my %TicketData = (
            State     => 'pending reminder',
            Priority  => '4 high',
            Lock      => 'unlock',
            UntilTime => '1 d 23 h'
        );

        my %DynamicFieldValues = (
            Text        => "Test Text $RandomID",
            Dropdown    => '1',
            Multiselect => 'year',
        );

        my %DynamicFieldDateValues = (
            Date     => '2016-04-13 00:00:00',
            DateTime => '2016-04-13 14:20:00',
        );

        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium ticket',
            QueueID      => 1,
            Lock         => $TicketData{Lock},
            Priority     => $TicketData{Priority},
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => $TestCustomer,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # Set dynamic field values.
        for my $DynamicFieldType ( sort keys %DynamicFieldValues, sort keys %DynamicFieldDateValues ) {
            my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                Name => $DynamicFields{$DynamicFieldType}->{Name},
            );

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
                Value  => $DynamicFieldValues{$DynamicFieldType} || $DynamicFieldDateValues{$DynamicFieldType},
                UserID => 1,
            );
        }

        my $ArticleBackendObject
            = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel( ChannelName => 'Email' );

        # Create test email article.
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 1,
            SenderType           => 'customer',
            Subject              => 'some short description',
            Body                 => 'the message text',
            From                 => "\"$TestCustomer $TestCustomer\" <${CustomerEmail}>",
            To                   => 'Some Customer A <customer-a@example.com>',
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - ID $ArticleID",
        );

        # Set state to 'pending reminder' for next 2 days.
        $Success = $TicketObject->TicketStateSet(
            State    => $TicketData{State},
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "TicketID $TicketID - set state to pending reminder successfully",
        );
        $Success = $TicketObject->TicketPendingTimeSet(
            Diff     => ( 2 * 24 * 60 ),
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Set pending time successfully",
        );

        my %CreatedTicketData = $TicketObject->TicketGet(
            TicketID => $TicketID,
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketCompose page.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketCompose;TicketID=$TicketID;ArticleID=$ArticleID;ResponseID=$TemplateID"
        );

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ToCustomer").length;' );

        my $Message = 'Article subject will be empty if the subject contains only the ticket hook!';

        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice:contains(\"$Message\")').length;"),
            "Notification about empty subject is found",
        );

        # Check duplication of customer user who doesn't exist in the system (see bug#13784).
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys( 'Test', "\N{U+E007}" );
        $Selenium->WaitFor( JavaScript => 'return $("#RemoveCustomerTicket_2").length;' );
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys( 'Test', "\N{U+E007}" );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".Dialog.Modal.Alert:visible").length;'
        );
        $Self->Is(
            $Selenium->execute_script('return $(".Dialog.Modal.Alert").length;'),
            1,
            "Alert dialog is found.",
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#DialogButton1',
        );

        $Selenium->execute_script("\$('#DialogButton1').click();");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length;' );

        # Change focus from #ToCustomer input field.
        $Selenium->find_element( "body", 'css' )->click();

        $Selenium->WaitFor( JavaScript => 'return $("#RemoveCustomerTicket_2").length;' );

        # Remove entered 'Test' for customer user.
        $Selenium->find_element( "#RemoveCustomerTicket_2", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$("#RemoveCustomerTicket_2").length;' );

        # Input required field and select customer.
        $Selenium->VerifiedRefresh();
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#ToCustomer',
            Event       => 'change',
        );
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys($TestCustomer);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length;' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomer)').click();");

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".Dialog.Modal.Alert:visible").length;'
        );

        $Self->Is(
            $Selenium->execute_script('return $(".Dialog.Modal.Alert").length;'),
            1,
            "Error message found.",
        );

        $Selenium->execute_script("\$('#DialogButton1').click();");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length;' );

        # Check AgentTicketCompose page.
        for my $ID (
            qw(ToCustomer CcCustomer BccCustomer Subject RichText
            FileUpload StateID IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
        }

        $Self->Is(
            $Selenium->execute_script('return $("#IsVisibleForCustomer").val();'),
            1,
            "Default customer visibility is honored",
        );

        # Test bug #11810 - http://bugs.otrs.org/show_bug.cgi?id=11810.
        # Translate ticket data tags (e.g. <OTRS_TICKET_State> ) in standard template.
        $Kernel::OM->ObjectParamAdd(
            'Kernel::Language' => {
                UserLanguage => $Language,
            },
        );
        my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

        # Check translated values.
        for my $Item ( sort keys %TicketData ) {
            my $TransletedTicketValue = $LanguageObject->Translate( $TicketData{$Item} );

            $Self->True(
                index( $Selenium->get_page_source(), $TransletedTicketValue ) > -1,
                "Translated \'$Item\' value is found - $TransletedTicketValue .",
            );
        }

        # Check if the transformed date value exists.
        my $TranslatedTicketCreated = $LanguageObject->FormatTimeString(
            $CreatedTicketData{Created},
            'DateFormat',
            'NoSeconds',
        );

        $Self->True(
            index( $Selenium->get_page_source(), $TranslatedTicketCreated ) > -1,
            "Translated 'Created' value is found - $TranslatedTicketCreated.",
        );

        my $RealTillTimeNotUsed = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $CreatedTicketData{RealTillTimeNotUsed},
            }
        )->ToString();

        $RealTillTimeNotUsed = $LanguageObject->FormatTimeString(
            $RealTillTimeNotUsed,
            'DateFormat',
            'NoSeconds',
        );

        $Self->True(
            index( $Selenium->get_page_source(), $RealTillTimeNotUsed ) > -1,
            "Translated 'RealTillTimeNotUsed' value is found - $RealTillTimeNotUsed.",
        );

        for my $DynamicFieldType ( sort keys %DynamicFieldValues ) {

            my $Value = $DynamicFields{$DynamicFieldType}->{Config}->{PossibleValues}
                ? $DynamicFields{$DynamicFieldType}->{Config}->{PossibleValues}
                ->{ $DynamicFieldValues{$DynamicFieldType} }
                : $DynamicFieldValues{$DynamicFieldType};

            my $TransletedDynamicFieldValue = $LanguageObject->Translate($Value);

            # Check dynamic field date format.
            $Self->True(
                index( $Selenium->get_page_source(), $DynamicFieldType . ': ' . $TransletedDynamicFieldValue . "\n" )
                    > -1,
                "Translated date format for  \'DynamicField_$DynamicFields{$DynamicFieldType}->{Name}\' value is found - $TransletedDynamicFieldValue.",
            );
        }

        for my $DynamicFieldType ( sort keys %DynamicFieldDateValues ) {

            my $DateFormat = $DynamicFieldType eq 'Date' ? 'DateFormatShort' : 'DateFormat';

            my $LanguageFormatDateValue = $LanguageObject->FormatTimeString(
                $DynamicFieldDateValues{$DynamicFieldType},
                $DateFormat,
                'NoSeconds',
            );

            # Check dynamic field date format.
            $Self->True(
                index( $Selenium->get_page_source(), $DynamicFieldType . ': ' . $LanguageFormatDateValue . "\n" ) > -1,
                "Translated date format for  \'DynamicField_$DynamicFields{$DynamicFieldType}->{Name}\' value is found - $LanguageFormatDateValue.",
            );
        }

        # Input required fields and submit compose.
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Selenium Compose Text');
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Navigate to AgentTicketHistory page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length;' );

        # Verify that compose worked as expected.
        my $HistoryText = "Sent email to \"\"$TestCustomer $TestCustomer\"";
        $Self->True(
            index( $Selenium->get_page_source(), $HistoryText ) > -1,
            'Compose executed correctly'
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::ResponseFormat',
            Value => '[% Data.TicketNumber | html%]',
        );

        # Test ticket lock and owner after closing AgentTicketCompose popup (see bug#12479).
        # Enable RequiredLock for AgentTicketCompose.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketCompose###RequiredLock',
            Value => 1,
        );

        # Set test created user as ticket owner.
        my $OwnerSet = $TicketObject->TicketOwnerSet(
            TicketID  => $TicketID,
            UserID    => 1,
            NewUserID => $UserID,
        );
        $Self->Is(
            $OwnerSet,
            1,
            "UserID '$UserID' is set successfully as ticket owner for TicketID '$TicketID'"
        );

        # Navigate to created test ticket in AgentTicketZoom page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#ResponseID$ArticleID').length;" );

        my %TicketDataBeforeUndo = $TicketObject->TicketGet(
            TicketID => $TicketID,
        );
        $Self->Is(
            $TicketDataBeforeUndo{Lock},
            'unlock',
            "Before undo - Ticket lock is 'unlock'"
        );
        $Self->Is(
            $TicketDataBeforeUndo{OwnerID},
            $UserID,
            "Before undo - Ticket owner is test user $UserID"
        );

        # Click on reply.
        $Selenium->InputFieldValueSet(
            Element => "#ResponseID$ArticleID",
            Value   => $TemplateID,
        );

        # Switch to compose window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '.UndoClosePopup',
        );

        # Check if Ticket number is shown correctly in text field.
        # See bug#133995 https://bugs.otrs.org/show_bug.cgi?id=13995
        my $TicketNumber = $TicketObject->TicketNumberLookup(
            TicketID => $TicketID,
        );
        $Self->Is(
            $Selenium->execute_script('return $("#RichText").val().trim();'),
            $TicketNumber,
            "Text field contains ticket number $TicketNumber"
        );

        # Click on 'Undo&Close' to close popup and set state and owner to the previous values.
        $Selenium->execute_script('$(".UndoClosePopup").click();');
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Wait for reload to kick in.
        sleep 1;
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # Clean Ticket cache, to get refreshed test ticket data.
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        $CacheObject->CleanUp( Type => 'Ticket' );

        # Navigate to created test ticket in AgentTicketZoom page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        my %TicketDataAfterUndo = $TicketObject->TicketGet(
            TicketID => $TicketID,
        );

        $Self->Is(
            $TicketDataAfterUndo{Lock},
            'unlock',
            "After undo - Ticket lock is still 'unlock'"
        ) || die;
        $Self->Is(
            $TicketDataAfterUndo{OwnerID},
            $UserID,
            "After undo - Ticket owner is still test user $UserID"
        ) || die;

        # Create article in OTRS channel.
        my $InternalArticleBackendObject
            = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel( ChannelName => 'Internal' );
        $ArticleID = $InternalArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'agent',
            IsVisibleForCustomer => 1,
            From                 => 'Test Agent <email@example.com>',
            To                   => 'Customer A <customer-a@example.com>',
            Cc                   => 'Customert B <customer-b@example.com>',
            Subject              => 'Test Subject',
            Body                 => 'Test Body',
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - ID $ArticleID",
        );

        # Refresh screen and verify there is a reply button for internal type article. See bug#14958 for more details.
        $Selenium->VerifiedRefresh();
        $Self->True(
            $Selenium->execute_script("return \$('#ResponseID$ArticleID').length;"),
            "Reply for internal article typo found."
        );

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
            "Ticket with ticket ID $TicketID is deleted"
        );

        # Delete standard template.
        $Success = $StandardTemplateObject->StandardTemplateDelete(
            ID => $TemplateID,
        );
        $Self->True(
            $Success,
            "Standard template is deleted - ID $TemplateID"
        );

        # Delete test customer user.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $TestCustomer = $DBObject->Quote($TestCustomer);
        $Success      = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomer ],
        );
        $Self->True(
            $Success,
            "Delete customer user - $TestCustomer",
        );

        # Delete created test dynamic fields.
        for my $DynamicFieldID (@DynamicFieldIDs) {
            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicFieldID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Dynamic field - ID $DynamicFieldID - deleted",
            );
        }

        # Delete group-user relation.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_user WHERE group_id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "Relation for group ID $GroupID is deleted",
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

        # Make sure the cache is correct.
        for my $Cache (qw( Ticket CustomerUser User )) {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
