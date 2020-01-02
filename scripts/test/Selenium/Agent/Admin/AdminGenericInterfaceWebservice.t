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

my $CheckBredcrumb = sub {

    my %Param = @_;

    my $BreadcrumbText = $Param{BreadcrumbText} || '';
    my $Count          = 1;

    for my $BreadcrumbText ( 'Web Service Management', $BreadcrumbText ) {
        $Self->Is(
            $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
            $BreadcrumbText,
            "Breadcrumb text '$BreadcrumbText' is found on screen"
        );

        $Count++;
    }
};

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        my $Home        = $ConfigObject->Get('Home');

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to AdminGenericInterfaceWebservice screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice");

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click 'Add web service' button.
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name').length" );

        # Check GenericInterface Web Service Management - Add screen.
        for my $ID (
            qw(Name Description RemoteSystem DebugThreshold ValidID ImportButton)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check breadcrumb on Add screen.
        $CheckBredcrumb->( BreadcrumbText => 'Add Web Service' );

        $Selenium->find_element( 'Cancel', 'link_text' )->VerifiedClick();

        # Set test values.
        my %Description = (
            webserviceconfig_1 => 'Connector to send and receive date from Nagios.',
            webserviceconfig_2 => 'Connector to send and receive date from Nagios 2.',
        );

        my %WebserviceNames = (
            webserviceconfig_1 => 'webserviceconfig_1',
            webserviceconfig_2 => $Helper->GetRandomID(),
        );

        for my $Webservice (
            qw(webserviceconfig_1 webserviceconfig_2)
            )
        {

            # Click 'Add web service' button.
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#ImportButton').length" );

            # Import web service.
            $Selenium->find_element( "#ImportButton", 'css' )->click();
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('.Dialog.Modal').length" );

            my $File     = $Webservice . '.yml';
            my $Location = "$Home/scripts/test/sample/Webservice/$File";
            my $Name     = $WebserviceNames{$Webservice};

            if ( $Name ne $Webservice ) {
                $Selenium->find_element( "#WebserviceName", 'css' )->send_keys($Name);
            }

            $Selenium->find_element( "#ConfigFile",         'css' )->send_keys($Location);
            $Selenium->find_element( "#ImportButtonAction", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && !\$('.Dialog.Modal').length && \$('tr td:contains(\"$Name\")').length"
            );

            # Verify that web service is created.
            $Self->True(
                $Selenium->execute_script("return \$('.MessageBox p:contains(Web service \"$Name\" created)').length"),
                "$Name is created",
            );

            # GenericInterface Web Service Management - Change screen.
            $Selenium->find_element( $Name, 'link_text' )->VerifiedClick();
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#ValidID').length && \$('#RemoteSystem').length"
            );
            $Selenium->InputFieldValueSet(
                Element => '#ValidID',
                Value   => 2,
            );
            $Selenium->find_element( "#RemoteSystem", 'css' )->send_keys('Test remote system');

            # Check breadcrumb on Edit screen.
            $CheckBredcrumb->( BreadcrumbText => 'Edit Web Service: ' . $Name );

            # Save edited value.
            $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('tr.Invalid td:contains(\"$Name\")').length"
            );

            # Check class of invalid web service in the overview table.
            $Self->True(
                $Selenium->execute_script(
                    "return \$('tr.Invalid td:contains($Name)').length"
                ),
                "There is a class 'Invalid' for test web service",
            );

            # Check web service values.
            $Selenium->find_element( $Name, 'link_text' )->VerifiedClick();
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name').length" );

            $Self->Is(
                $Selenium->find_element( '#Name', 'css' )->get_value(),
                $Name,
                "#Name stored value",
            );

            $Self->Is(
                $Selenium->find_element( '#Description', 'css' )->get_value(),
                $Description{$Webservice},
                '#Description stored value',
            );

            $Self->Is(
                $Selenium->find_element( '#RemoteSystem', 'css' )->get_value(),
                'Test remote system',
                '#RemoteSystem updated value',
            );

            $Self->Is(
                $Selenium->find_element( '#ValidID', 'css' )->get_value(),
                2,
                "#ValidID updated value",
            );

            # Delete web service.
            $Selenium->find_element( "#DeleteButton", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('.Dialog.Modal').length && \$('#DialogButton2').length"
            );
            $Selenium->find_element( "#DialogButton2", 'css' )->click();

            # Wait until delete dialog has closed and action performed.
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && !\$('#DialogButton2').length" );
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
            );

            # Verify that web service is deleted.
            $Self->True(
                index( $Selenium->get_page_source(), "Web service \"$Name\" deleted!" ) > -1,
                "$Name is deleted",
            );

        }
    }
);

1;
