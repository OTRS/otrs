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

use Kernel::Language;

# Get Selenium object.
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

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to created test ticket in AgentTicketZoom page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Click on reply.
        $Selenium->execute_script(
            "\$('#ResponseID$ArticleID').val('$TemplateID').trigger('redraw.InputField').trigger('change');"
        );

        # Switch to compose window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait without jQuery because it might not be loaded yet.
        $Selenium->WaitFor( JavaScript => 'return document.getElementById("ToCustomer");' );

        # Input required field and select customer.
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys($TestCustomer);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->find_element("//*[text()='$TestCustomer']")->VerifiedClick();

        $Self->Is(
            $Selenium->execute_script('return $(".Dialog.Modal.Alert") > -1'),
            0,
            "Error message found.",
        );

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal.Alert:visible").length'
        );

        $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

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
            $Selenium->execute_script('return $("#IsVisibleForCustomer").val()'),
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

        for my $Item ( sort keys %TicketData ) {
            my $TransletedTicketValue = $LanguageObject->Translate( $TicketData{$Item} );

            # Check translated value.
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
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        $Selenium->find_element("//*[text()='History']")->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

        # Verify that compose worked as expected.
        my $HistoryText = "Sent email to \"\"$TestCustomer $TestCustomer\"";
        $Self->True(
            index( $Selenium->get_page_source(), $HistoryText ) > -1,
            'Compose executed correctly'
        );

        # Wait until all current AJAX requests have completed, before cleaning up test entities. Otherwise, it could
        #   happen some asynchronous calls prevent entries from being deleted by running into race conditions.
        #   jQuery property $.active contains number of active AJAX calls on the page.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $.active === 0' );

        # Delete test ticket.
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
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

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw( Ticket CustomerUser )) {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
