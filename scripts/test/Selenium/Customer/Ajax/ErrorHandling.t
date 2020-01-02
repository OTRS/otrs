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

# TODO: This test does not cancel potential other AJAX calls that might happen in the background,
#   e. g. when OTRSBusiness is installed and the Chat is active.

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $Language     = 'en';

        # Create test customer user and login.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
            Language => $Language,
        ) || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 1,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to CustomerPreference screen.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketMessage");

        # Provoke an ajax error caused by unexpected result (404), should show no dialog, but an regular alert.
        $Selenium->execute_script(
            "Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle') + ':12345', null, function () {});"
        );

        $Selenium->WaitFor( JavaScript => "return \$('.NoConnection:visible').length;" );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # Another alert dialog opens with the detail message.
        $Self->Is(
            $Selenium->execute_script("return \$('#AjaxErrorDialogInner .NoConnection p').text().trim();"),
            $LanguageObject->Translate(
                '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.',
                $ConfigObject->Get('Product')
            ),
            'Check for opened alert text',
        );

        # Close dialog.
        $Selenium->find_element( '#DialogButton2', 'css' )->click();

        # Wait until modal dialog has closed.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length;'
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Change the queue to trigger an ajax call.
        $Selenium->InputFieldValueSet(
            Element => '#Type',
            Value   => 1,
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # There should be no error dialog yet.
        $Self->Is(
            $Selenium->execute_script("return \$('#AjaxErrorDialogInner .NoConnection:visible').length;"),
            0,
            "Error dialog not visible yet"
        );

        # Overload ajax function to simulate connection drop.
        my $AjaxOverloadJSError = <<"JAVASCRIPT";
window.AjaxOriginal = \$.ajax;
\$.ajax = function() {
    var Status = 'Status',
        Error = 'Error';
    Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("Error during AJAX communication. Status: " + Status + ", Error: " + Error, 'ConnectionError'));
    return false;
};
\$.ajax();
JAVASCRIPT

        # Trigger faked ajax request.
        $Selenium->execute_script($AjaxOverloadJSError);

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Wait until modal dialog has open.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length;'
        );

        # Now check if we see a connection error popup.
        $Self->Is(
            $Selenium->execute_script("return \$('#AjaxErrorDialogInner .NoConnection:visible').length;"),
            1,
            "Error dialog visible - first try"
        );

        # Now act as if the connection had been re-established.
        my $AjaxOverloadJSSuccess = <<"JAVASCRIPT";
\$.ajax = window.AjaxOriginal;
Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), null, function () {}, 'html');
\$.ajax();
JAVASCRIPT

        # Trigger faked ajax request.
        $Selenium->execute_script($AjaxOverloadJSSuccess);

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Wait until modal dialog has open.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length;'
        );

        # The dialog should show the re-established message now.
        $Self->Is(
            $Selenium->execute_script("return \$('#AjaxErrorDialogInner .ConnectionReEstablished:visible').length;"),
            1,
            "ConnectionReEstablished dialog visible"
        );

        # Close the dialog.
        $Selenium->find_element( '#DialogButton2', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length;'
        );

        # Trigger faked ajax request again.
        $Selenium->execute_script($AjaxOverloadJSError);

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Wait until modal dialog has open.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length;'
        );

        # Now check if we see a connection error popup.
        $Self->Is(
            $Selenium->execute_script("return \$('#AjaxErrorDialogInner .NoConnection:visible').length;"),
            1,
            "Error dialog visible - second try"
        );

        # Now we close the dialog manually.
        $Selenium->find_element( '#DialogButton2', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length;'
        );

        # The dialog should be gone.
        $Self->Is(
            $Selenium->execute_script("return \$('#AjaxErrorDialogInner .NoConnection:visible').length;"),
            0,
            "Error dialog closed"
        );

        # Now act as if the connection had been re-established.
        $Selenium->execute_script($AjaxOverloadJSSuccess);

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Wait until modal dialog has open.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length;'
        );

        # The dialog should show the re-established message now.
        $Self->Is(
            $Selenium->execute_script("return \$('#AjaxErrorDialogInner .ConnectionReEstablished:visible').length;"),
            1,
            "ConnectionReEstablished dialog visible"
        );
    }
);

1;
