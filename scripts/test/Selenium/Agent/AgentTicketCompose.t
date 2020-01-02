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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # disable check email addresses
        $ConfigObject->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # do not check RichText
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # do not check service and type
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # disable RequiredLock for AgentTicketCompose
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketCompose###RequiredLock',
            Value => 0
        );

        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketCompose###DefaultArticleType',
            Value => 'email-internal'
        );

        # use test email backend
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        my $RandomID = $Helper->GetRandomID();

        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

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

        # Create test dynamic field of type date
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

        # get standard template object
        my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

        # create a new template
        my $TemplateID = $StandardTemplateObject->StandardTemplateAdd(
            Name     => 'New Standard Template' . $RandomID,
            Template => "Thank you for your email.
                             Ticket state: <OTRS_TICKET_State>.\n
                             Ticket lock: <OTRS_TICKET_Lock>.\n
                             Ticket priority: <OTRS_TICKET_Priority>.\n
                             Ticket created: <OTRS_TICKET_Created>.\n
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

        # assign template to the queue
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

        # get customer user object
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # add test customer for testing
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

        # set customer user language
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my %TicketData = (
            State    => 'new',
            Priority => '4 high',
            Lock     => 'unlock',
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
            State        => $TicketData{State},
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => $TestCustomer,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        for my $DynamicFieldType ( sort keys %DynamicFieldValues, sort keys %DynamicFieldDateValues ) {

            # Set the value from the dynamic field.
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

        my $FromCustomer = "\"$TestCustomer $TestCustomer\" <$CustomerEmail>";

        # create test email article
        my $ArticleID = $TicketObject->ArticleCreate(
            TicketID       => $TicketID,
            ArticleType    => 'email-external',
            SenderType     => 'customer',
            From           => $FromCustomer,
            To             => 'Some Customer A Some Customer A <customer-a@example.com>',
            Subject        => 'some short description',
            Body           => 'the message text',
            Charset        => 'ISO-8859-15',
            MimeType       => 'text/plain',
            HistoryType    => 'EmailCustomer',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - ID $ArticleID",
        );

        my %CreatedTicketData = $TicketObject->TicketGet(
            TicketID => $TicketID,
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

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to created test ticket in AgentTicketZoom page
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # click on reply
        $Selenium->execute_script(
            "\$('#ResponseID').val('$TemplateID').trigger('redraw.InputField').trigger('change');"
        );

        # switch to compose window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ToCustomer").length' );

        # check AgentTicketCompose page
        for my $ID (
            qw(ToCustomer CcCustomer BccCustomer Subject RichText
            FileUpload StateID ArticleTypeID submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
        }

        # test bug #11810 - http://bugs.otrs.org/show_bug.cgi?id=11810
        # translate ticket data tags (e.g. <OTRS_TICKET_State> ) in standard template
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );
        for my $Item ( sort keys %TicketData ) {
            my $TransletedTicketValue = $LanguageObject->Translate( $TicketData{$Item} );

            # check translated value
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
            "Translated \'Created\' value is found - $TranslatedTicketCreated.",
        );

        for my $DynamicFieldType ( sort keys %DynamicFieldValues ) {

            my $Value = $DynamicFields{$DynamicFieldType}->{Config}->{PossibleValues}
                ? $DynamicFields{$DynamicFieldType}->{Config}->{PossibleValues}
                ->{ $DynamicFieldValues{$DynamicFieldType} }
                : $DynamicFieldValues{$DynamicFieldType};

            my $TransletedDynamicFieldValue = $LanguageObject->Translate($Value);

            # check dynamic field date format
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

            # check dynamic field date format
            $Self->True(
                index( $Selenium->get_page_source(), $DynamicFieldType . ': ' . $LanguageFormatDateValue . "\n" ) > -1,
                "Translated date format for  \'DynamicField_$DynamicFields{$DynamicFieldType}->{Name}\' value is found - $LanguageFormatDateValue.",
            );
        }

        # Input required fields and submit compose.
        my $AutoCompleteString = "\"$TestCustomer $TestCustomer\" <$TestCustomer\@localhost.com> ($TestCustomer)";
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys($TestCustomer);

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomer)').click()");

        # Verify that error occurs.
        $Self->Is(
            $Selenium->execute_script("return \$('.Dialog.Modal.Alert').length"),
            "1",
            "Error message found.",
        );

        $Selenium->find_element( "#DialogButton1", 'css' )->click();

        $Selenium->find_element( "#RichText",       'css' )->send_keys('Selenium Compose Text');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        sleep 2;
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        $Selenium->find_element("//*[text()='History']")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

        # verify that compose worked as expected
        my $HistoryText = "Email sent to \"\"$TestCustomer $TestCustomer\"";

        $Self->True(
            index( $Selenium->get_page_source(), $HistoryText ) > -1,
            "Compose executed correctly",
        );

        # delete created test ticket
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

        # delete standard template
        $Success = $StandardTemplateObject->StandardTemplateDelete(
            ID => $TemplateID,
        );
        $Self->True(
            $Success,
            "Standard template is deleted - ID $TemplateID"
        );

        # delete created test customer user
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

        for my $DynamicFieldID (@DynamicFieldIDs) {

            # delete created test dynamic field
            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicFieldID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Dynamic field - ID $DynamicFieldID - deleted",
            );
        }

        # make sure the cache is correct
        for my $Cache (
            qw (Ticket CustomerUser )
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
