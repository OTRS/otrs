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

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Enable SMIME due to 'Enable email security' checkbox must be enabled.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME',
            Value => 1,
        );

        # Defined user language for testing if message is being translated correctly.
        my $Language = "de";

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => ['admin'],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminNotificationEvent screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAppointmentNotificationEvent");

        # Check overview screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click "Add notification"
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminAppointmentNotificationEvent;Subaction=Add' )]")
            ->VerifiedClick();

        # Check add NotificationEvent screen.
        for my $ID (
            qw(Name Comment ValidID Events en_Subject en_Body)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check breadcrumb on Add screen.
        my $Count = 1;
        for my $BreadcrumbText (
            $LanguageObject->Translate('Appointment Notification Management'),
            $LanguageObject->Translate('Add Notification')
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Toggle Ticket filter widget.
        my $TranslatedAppointmentFilter = $LanguageObject->Translate('Appointment Filter');
        $Selenium->execute_script(
            "\$('.WidgetSimple.Collapsed:contains($TranslatedAppointmentFilter) .Toggle > a').trigger('click')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.WidgetSimple.Expanded:contains($TranslatedAppointmentFilter)').length"
        );

        # Create test NotificationEvent.
        my $NotifEventRandomID = 'NotificationEvent' . $Helper->GetRandomID();
        my $NotifEventText     = 'Selenium NotificationEvent test';
        $Selenium->find_element( '#Name',    'css' )->send_keys($NotifEventRandomID);
        $Selenium->find_element( '#Comment', 'css' )->send_keys($NotifEventText);
        $Selenium->InputFieldValueSet(
            Element => '#Events',
            Value   => 'AppointmentNotification',
        );
        $Selenium->find_element( '#en_Subject', 'css' )->send_keys($NotifEventText);
        $Selenium->find_element( '#en_Body',    'css' )->send_keys($NotifEventText);

        # Check 'Additional recipient' length validation from Additional recipient email addresses (see bug#13936).
        my $FieldValue = "a" x 201;

        # Check TransportEmail checkbox if it is not checked.
        my $TransportEmailCheck = $Selenium->execute_script("return \$('#TransportEmail').prop('checked');");
        if ( !$TransportEmailCheck ) {
            $Selenium->execute_script("\$('#TransportEmail').prop('checked', true);");
            $Selenium->WaitFor( JavaScript => "return \$('#TransportEmail').prop('checked') === true;" );
        }
        $Selenium->find_element( "#RecipientEmail", 'css' )->send_keys($FieldValue);
        $Selenium->find_element( "#Submit",         'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('#RecipientEmail.Error').length;" );

        $Self->True(
            $Selenium->execute_script("return \$('#RecipientEmail.Error').length;"),
            "Validation for 'Additional recipient' field is correct",
        );
        $Selenium->find_element( "#RecipientEmail", 'css' )->clear();

        # Set back TransportEmail checkbox if it was not checked.
        if ( !$TransportEmailCheck ) {
            $Selenium->execute_script("\$('#TransportEmail').prop('checked', false);");
            $Selenium->WaitFor( JavaScript => "return \$('#TransportEmail').prop('checked') === false;" );
        }

        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check if test NotificationEvent show on AdminNotificationEvent screen.
        $Self->True(
            index( $Selenium->get_page_source(), $NotifEventRandomID ) > -1,
            "$NotifEventRandomID NotificaionEvent found on page",
        );

        # Check is there notification 'Notification added!' after notification is added.
        my $Notification = $LanguageObject->Translate('Notification added!');
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        ) || die;

        # Check test NotificationEvent values.
        $Selenium->find_element( $NotifEventRandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $NotifEventRandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            $NotifEventText,
            "#Comment stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#en_Subject', 'css' )->get_value(),
            $NotifEventText,
            "#en_Subject stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#en_Body', 'css' )->get_value(),
            $NotifEventText,
            "#en_Body stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText (
            $LanguageObject->Translate('Appointment Notification Management'),
            $LanguageObject->Translate('Edit Notification') . ": $NotifEventRandomID"
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Edit test NotificationEvent and set it to invalid.
        my $EditNotifEventText = "Selenium edited NotificationEvent test";

        $Selenium->find_element( "#Comment",    'css' )->clear();
        $Selenium->find_element( "#en_Body",    'css' )->clear();
        $Selenium->find_element( "#en_Body",    'css' )->send_keys($EditNotifEventText);
        $Selenium->find_element( "#en_Subject", 'css' )->clear();
        $Selenium->find_element( "#en_Subject", 'css' )->send_keys($EditNotifEventText);
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check is there notification 'Notification updated!' after notification is added
        $Notification = $LanguageObject->Translate('Notification updated!');
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Check edited NotifcationEvent values
        $Selenium->find_element( $NotifEventRandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            "",
            "#Comment updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#en_Body', 'css' )->get_value(),
            $EditNotifEventText,
            "#en_Body updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );

        # test javascript enable/disable actions on checkbox checking
        my @InputFields = (
            "EmailSigningCrypting_Search",
            "EmailMissingSigningKeys_Search",
            "EmailMissingCryptingKeys_Search"
        );

        # set initial checkbox state
        $Selenium->execute_script("\$('#EmailSecuritySettings').prop('checked', false)");

        my @Tests = (
            {
                Name     => 'Input fields are enabled',
                HasClass => 0,
            },
            {
                Name     => 'Input fields are disabled',
                HasClass => 1,
            }
        );

        for my $Test (@Tests) {
            $Selenium->find_element( "#EmailSecuritySettings", 'css' )->click();

            for my $InputField (@InputFields) {
                $Selenium->WaitFor(
                    JavaScript => "return \$('.AlreadyDisabled > input#$InputField').length === $Test->{HasClass}"
                );

                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('#$InputField').parent().hasClass('AlreadyDisabled')"
                    ),
                    $Test->{HasClass},
                    $Test->{Name},
                );
            }
        }

        # Go back to AdminNotificationEvent overview screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAppointmentNotificationEvent");

        # Check class of invalid NotificationEvent in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($NotifEventRandomID)').length"
            ),
            "There is a class 'Invalid' for test NotificationEvent",
        );

        my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

        # Get NotificationEventID.
        my %NotifEventID = $NotificationEventObject->NotificationGet(
            Name => $NotifEventRandomID
        );

        # Create copy of test Notification.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=NotificationCopy;ID=$NotifEventID{ID}' )]")
            ->VerifiedClick();
        my $TranslatedNotificationCopy = $LanguageObject->Translate( '%s (copy)', $NotifEventRandomID );
        $Self->True(
            $Selenium->find_element("//a[contains(.,'$TranslatedNotificationCopy')]"),
            "Test NotificationEvent copy is created - $TranslatedNotificationCopy",
        );

        # Click on delete icon.
        my $CheckConfirmJS = <<"JAVASCRIPT";
(function () {
    window.confirm = function (message) {
        return true;
    };
}());
JAVASCRIPT

        for my $Item ( $TranslatedNotificationCopy, $NotifEventRandomID ) {
            $Selenium->execute_script($CheckConfirmJS);

            my %NotifEventID = $NotificationEventObject->NotificationGet(
                Name => $Item
            );

            # Delete test Notification with delete button.
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;ID=$NotifEventID{ID}' )]")
                ->VerifiedClick();

            # Check if test NotificationEvent is deleted
            $Self->False(
                $Selenium->execute_script(
                    "return \$('tr.Invalid td a:contains($Item)').length"
                ),
                "Test NotificationEvent is deleted - $Item",
            ) || die;

            $Selenium->VerifiedRefresh();
        }

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Import existing template without overwrite.
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/NotificationEvent/Export_Notification_Appointment_reminder_notification.yml";
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

        my $TranslatedUploadNotification = $LanguageObject->Translate('Upload Notification configuration');
        $Selenium->find_element("//button[\@value=\'$TranslatedUploadNotification\']")->VerifiedClick();

        my $TranslatedMessage =
            $LanguageObject->Translate(
            'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.',
            $NotifEventRandomID
            );
        $TranslatedMessage = substr( $TranslatedMessage, 0, 30 );
        $Selenium->find_element(
            "//p[contains(text(),'$TranslatedMessage')]"
        );

        # Import existing template with overwrite.
        $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/NotificationEvent/Export_Notification_Appointment_reminder_notification.yml";
        $Selenium->find_element( "#FileUpload",                     'css' )->send_keys($Location);
        $Selenium->find_element( "#OverwriteExistingNotifications", 'css' )->click();
        $Selenium->find_element("//button[\@value=\'$TranslatedUploadNotification\']")->VerifiedClick();

        $TranslatedMessage = $LanguageObject->Translate(
            'The following Notifications have been updated successfully: %s',
            $NotifEventRandomID
        );
        $TranslatedMessage = substr( $TranslatedMessage, 0, 30 );
        $Selenium->find_element("//p[contains(text(),'$TranslatedMessage')]");
    }
);

1;
