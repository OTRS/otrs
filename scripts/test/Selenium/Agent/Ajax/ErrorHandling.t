# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Language => $Language,
            Groups   => ['admin'],
        ) || die "Did not get test user";

        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentDashboard screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # wait until jquery is ready
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );

        # provoke an ajax error caused by unexpected result (404), should show no dialog, but an regular alert
        my $CheckConfirmJSBlock = <<"JAVASCRIPT";
(function () {
    var lastAlert = undefined;
    window.confirm = function () {
        return true;
    };
    window.alert = function(message) {
        lastAlert = message;
        return false;
    }
    window.getLastAlert = function () {
        var result = lastAlert;
        lastAlert = undefined;
        return result;
    };
    Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle') + ':12345', null, function () {});
}());
JAVASCRIPT
        $Selenium->execute_script($CheckConfirmJSBlock);

        # wait until all active requests are completed
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # there should be a alert dialog now
        $Self->Is(
            $Selenium->execute_script("return window.getLastAlert()"),
            'Error during AJAX communication. Status: error, Error: Not Found',
            'Check for opened alert text',
        );

        # change the queue to trigger an ajax call
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");

        # wait until we see a ajax loader icon on one of the fields (Owner in this case)
        $Selenium->WaitFor( JavaScript => "return \$('#NewUserID').next('#AJAXLoaderNewUserID:visible').length" );

        # wait until the requests started to run
        sleep(2);

        # there should be no error dialog yet
        $Selenium->WaitFor( JavaScript => "return \$('#AjaxErrorDialogInner .NoConnection:visible').length == 0" );

        # overload ajax function to simulate connection drop
        my $AjaxOverloadJSError = <<"JAVASCRIPT";
window.AjaxOriginal = \$.ajax;
\$.ajax = function() {
    var Status = 'Status',
        Error = 'Error';
    Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("Error during AJAX communication. Status: " + Status + ", Error: " + Error, 'ConnectionError'));
    return false;
};
JAVASCRIPT
        $Selenium->execute_script($AjaxOverloadJSError);

        # trigger faked ajax request
        $Selenium->execute_script(
            q{
                return $.ajax();
            }
        );

        # now check if we see a connection error popup
        $Selenium->WaitFor( JavaScript => "return \$('#AjaxErrorDialogInner .NoConnection:visible').length" );

        # now act as if the connection had been re-established
        my $AjaxOverloadJSSuccess = <<"JAVASCRIPT";
\$.ajax = window.AjaxOriginal;
Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), null, function () {}, 'html');
JAVASCRIPT
        $Selenium->execute_script($AjaxOverloadJSSuccess);

        # trigger faked ajax request
        $Selenium->execute_script(
            q{
                return $.ajax();
            }
        );

        # the dialog should show the re-established message now
        $Selenium->WaitFor(
            JavaScript => "return \$('#AjaxErrorDialogInner .ConnectionReEstablished:visible').length" );
        my $ItemVisible = $Selenium->execute_script(
            q{
                return $('#AjaxErrorDialogInner:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            1,
            "Connection issue dialog should show the re-established message"
        );

        # close the dialog
        $Selenium->execute_script(
            "\$('.Dialog:visible').find('.ContentFooter').find('button:nth-child(2)').trigger('click')"
        );

        # trigger faked ajax request again
        $Selenium->execute_script($AjaxOverloadJSError);
        $Selenium->execute_script(
            q{
                return $.ajax();
            }
        );

        # dialog should appear again
        $Selenium->WaitFor( JavaScript => "return \$('#AjaxErrorDialogInner .NoConnection:visible').length" );

        # now we close the dialog manually
        $Selenium->execute_script(
            "\$('.Dialog:visible').find('.ContentFooter').find('button:nth-child(2)').trigger('click')"
        );

        # dialog should be gone
        $Selenium->WaitFor( JavaScript => "return !\$('#AjaxErrorDialogInner .NoConnection:visible').length" );

        # now act as if the connection had been re-established
        $Selenium->execute_script($AjaxOverloadJSSuccess);
        $Selenium->execute_script(
            q{
                return $.ajax();
            }
        );

        # the dialog should show the re-established message now
        $Selenium->WaitFor(
            JavaScript => "return \$('#AjaxErrorDialogInner .ConnectionReEstablished:visible').length" );
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#AjaxErrorDialogInner:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            1,
            "Connection issue dialog should show the re-established message"
        );

        # create a test ticket to see if the dialogs work in popups, too
        my $TestCustomerUser = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # get test customer user ID
        my %TestCustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $TestCustomerUser,
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my $TitleRandom  = "Title" . $Helper->GetRandomID();
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN         => $TicketNumber,
            Title      => $TitleRandom,
            Queue      => 'Raw',
            Lock       => 'unlock',
            Priority   => '3 normal',
            State      => 'open',
            CustomerID => $TestCustomerUserID{UserCustomerID},
            OwnerID    => $TestUserID,
            UserID     => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # navigate to AgentTicketZoom for test created ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # open the owner change dialog
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketOwner' )]")->VerifiedClick();

        # switch to the new window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # trigger faked ajax request again
        $Selenium->execute_script($AjaxOverloadJSError);
        $Selenium->execute_script(
            q{
                return $.ajax();
            }
        );

        # dialog should appear again
        $Selenium->WaitFor( JavaScript => "return \$('#AjaxErrorDialogInner .NoConnection:visible').length" );

        # now act as if the connection had been re-established
        $Selenium->execute_script($AjaxOverloadJSSuccess);
        $Selenium->execute_script(
            q{
                return $.ajax();
            }
        );

        # the dialog should show the re-established message now
        $Selenium->WaitFor(
            JavaScript => "return \$('#AjaxErrorDialogInner .ConnectionReEstablished:visible').length" );
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#AjaxErrorDialogInner:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            1,
            "Connection issue dialog should show the re-established message"
        );

        # delete created test tickets
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket ID $TicketID is deleted"
        );

        # make sure the cache is correct
        for my $Cache (qw( Ticket Queue )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
