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

use Kernel::Output::HTML::Layout;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Disable SessionUseCookie. See bug#14432.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SessionUseCookie',
            Value => 0,
        );

        # Get all sessions before login.
        my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
        my @PreLoginSessions  = $AuthSessionObject->GetAllSessionIDs();

        my $Language = 'en';

        # Create test customer user and login.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
            Language => $Language,
        ) || die "Did not get test customer user";

        my $LayoutObject = Kernel::Output::HTML::Layout->new(
            Lang         => $Language,
            UserTimeZone => 'UTC',
        );

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias              = $ConfigObject->Get('ScriptAlias');
        my $Home                     = $ConfigObject->Get('Home');
        my $CustomerPanelSessionName = $ConfigObject->Get('CustomerPanelSessionName');
        my $CustomerPanelSessionToken;

        # Get all session after login.
        my @PostLoginSessions = $AuthSessionObject->GetAllSessionIDs();

        # If there are no other sessions before login, take token from only available one.
        if ( !scalar @PreLoginSessions ) {
            $CustomerPanelSessionToken = $PostLoginSessions[0];
        }

        # If there are more sessions, find current logged one by looking at the difference.
        else {
            my %Difference;
            @Difference{@PostLoginSessions} = @PostLoginSessions;
            delete @Difference{@PreLoginSessions};
            $CustomerPanelSessionToken = ( keys %Difference )[0];
        }

        $Selenium->VerifiedGet(
            "${ScriptAlias}customer.pl?Action=CustomerTicketMessage;$CustomerPanelSessionName=$CustomerPanelSessionToken"
        );

        # Check DnDUpload.
        my $Element = $Selenium->find_element( ".DnDUpload", 'css' );
        $Element->is_enabled();
        $Element->is_displayed();

        # Hide DnDUpload and show input field.
        $Selenium->execute_script(
            "\$('.DnDUpload').css('display', 'none')"
        );
        $Selenium->execute_script(
            "\$('#FileUpload').css('display', 'block')"
        );

        my $Location = "$Home/scripts/test/sample/Main/Main-Test1.doc";
        $Selenium->find_element( "#FileUpload", 'css' )->clear();
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.AttachmentDelete i').length"
        );
        sleep 1;

        # Check if uploaded.
        $Self->True(
            $Selenium->execute_script(
                "return \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.doc\")').length"
            ),
            "Upload file correct"
        );

        # Check if files still there.
        $Self->True(
            $Selenium->execute_script(
                "return \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.doc\")').length"
            ),
            "Uploaded 'doc' file still there"
        );

        # Delete Attachment.
        $Selenium->find_element( "(//a[\@class='AttachmentDelete'])[1]", 'xpath' )->click();
        sleep 1;

        # Wait until attachment is deleted.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.AttachmentDelete i').length === 0"
        );

        # Check if deleted.
        $Self->True(
            $Selenium->execute_script(
                "return \$('.AttachmentDelete i').length === 0"
            ),
            "CustomerTicketMessage - Uploaded file 'Main-Test1.doc' deleted"
        );
    }
);

1;
