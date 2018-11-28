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

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # enable SMIME due to 'Enable email security' checkbox must be enabled
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME',
            Value => 1,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminNotificationEvent screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAppointmentNotificationEvent");

        # check overview screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click "Add notification"
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminAppointmentNotificationEvent;Subaction=Add' )]")
            ->VerifiedClick();

        # check add NotificationEvent screen
        for my $ID (
            qw(Name Comment ValidID Events en_Subject en_Body)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check breadcrumb on Add screen
        my $Count = 1;
        for my $BreadcrumbText ( 'Appointment Notification Management', 'Add Notification' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # toggle Ticket filter widget
        $Selenium->execute_script(
            "\$('.WidgetSimple.Collapsed:contains(Appointment Filter) .Toggle > a').trigger('click')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.WidgetSimple.Expanded:contains(Appointment Filter)').length"
        );

        # create test NotificationEvent
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

        # check if test NotificationEvent show on AdminNotificationEvent screen
        $Self->True(
            index( $Selenium->get_page_source(), $NotifEventRandomID ) > -1,
            "$NotifEventRandomID NotificaionEvent found on page",
        );

        # check is there notification 'Notification added!' after notification is added
        my $Notification = 'Notification added!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # check test NotificationEvent values
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

        # check breadcrumb on Edit screen
        $Count = 1;
        for my $BreadcrumbText (
            'Appointment Notification Management',
            'Edit Notification: ' . $NotifEventRandomID
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # edit test NotificationEvent and set it to invalid
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

        # check is there notification 'Notification updated!' after notification is added
        $Notification = 'Notification updated!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # check edited NotifcationEvent values
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

        # go back to AdminNotificationEvent overview screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAppointmentNotificationEvent");

        # check class of invalid NotificationEvent in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($NotifEventRandomID)').length"
            ),
            "There is a class 'Invalid' for test NotificationEvent",
        );

        # get NotificationEventID
        my %NotifEventID = $Kernel::OM->Get('Kernel::System::NotificationEvent')->NotificationGet(
            Name => $NotifEventRandomID
        );

        # click on delete icon
        my $CheckConfirmJS = <<"JAVASCRIPT";
(function () {
    window.confirm = function (message) {
        return true;
    };
}());
JAVASCRIPT
        $Selenium->execute_script($CheckConfirmJS);

        # delete test SLA with delete button
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;ID=$NotifEventID{ID}' )]")->VerifiedClick();

        # check if test NotificationEvent is deleted
        $Self->False(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($NotifEventRandomID)').length"
            ),
            "Test NotificationEvent is deleted - $NotifEventRandomID",
        ) || die;

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # import existing template without overwrite
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/NotificationEvent/Export_Notification_Appointment_reminder_notification.yml";
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

        $Selenium->find_element("//button[\@value=\'Upload Notification configuration']")->VerifiedClick();

        $Selenium->find_element(
            "//p[contains(text(), \'There where errors adding/updating the following Notifications')]"
        );

        # import existing template with overwrite
        $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/NotificationEvent/Export_Notification_Appointment_reminder_notification.yml";
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

        $Selenium->find_element( "#OverwriteExistingNotifications", 'css' )->click();

        $Selenium->find_element("//button[\@value=\'Upload Notification configuration']")->VerifiedClick();

        $Selenium->find_element("//p[contains(text(), \'The following Notifications have been updated successfully')]");
    }
);

1;
