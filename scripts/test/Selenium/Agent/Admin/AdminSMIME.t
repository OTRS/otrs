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
use File::Path ();

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Create directory for certificates and private keys.
        my $CertPath    = $ConfigObject->Get('Home') . "/var/tmp/certs";
        my $PrivatePath = $ConfigObject->Get('Home') . "/var/tmp/private";
        File::Path::rmtree($CertPath);
        File::Path::rmtree($PrivatePath);
        File::Path::make_path( $CertPath,    { chmod => 0770 } );    ## no critic
        File::Path::make_path( $PrivatePath, { chmod => 0770 } );    ## no critic

        # Disabled SMIME in config.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME',
            Value => 0
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminSMIME screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSMIME");

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Check widget sidebar when SMIME sysconfig is disabled.
        $Self->True(
            $Selenium->find_element( 'h3 span.Warning', 'css' ),
            "Widget sidebar with warning message is displayed.",
        );
        $Self->True(
            $Selenium->find_element("//button[\@value='Enable it here!']"),
            "Button 'Enable it here!' to the SMIME SysConfig is displayed.",
        );

        # Enable SMIME in config.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME',
            Value => 1
        );

        # Set SMIME paths in sysConfig.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME::CertPath',
            Value => '/SomeCertPath',
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME::PrivatePath',
            Value => '/SomePrivatePath',
        );

        # Refresh AdminSMIME screen.
        $Selenium->VerifiedRefresh();

        # Check widget sidebar when SMIME sysconfig does not work.
        $Self->True(
            $Selenium->find_element( 'h3 span.Error', 'css' ),
            "Widget sidebar with error message is displayed.",
        );
        $Self->True(
            $Selenium->find_element("//button[\@value='Configure it here!']"),
            "Button 'Configure it here!' to the SMIME SysConfig is displayed.",
        );

        # Set SMIME paths in sysConfig.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME::CertPath',
            Value => $CertPath,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME::PrivatePath',
            Value => $PrivatePath,
        );

        # Refresh AdminSMIME screen.
        $Selenium->VerifiedRefresh();

        # Check overview screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );
        $Selenium->find_element( "#FilterSMIME",      'css' );

        # Click 'Add certificate'.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ShowAddCertificate' )]")->VerifiedClick();

        # Check breadcrumb on 'Add Certificate' screen.
        my $Count = 1;
        for my $BreadcrumbText ( 'S/MIME Management', 'Add Certificate' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim();"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Add certificate.
        my $CertLocation = $ConfigObject->Get('Home')
            . "/scripts/test/sample/SMIME/SMIMECertificate-smimeuser1.crt";

        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($CertLocation);
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Click 'Add private key'.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ShowAddPrivate' )]")->VerifiedClick();

        # Check breadcrumb on 'Add Private Key' screen.
        $Count = 1;
        for my $BreadcrumbText ( 'S/MIME Management', 'Add Private Key' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim();"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Add private key.
        my $PrivateLocation = $ConfigObject->Get('Home')
            . "/scripts/test/sample/SMIME/SMIMEPrivateKey-smimeuser1.pem";

        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($PrivateLocation);
        $Selenium->find_element("//button[\@type='submit']")->click();

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Secret.Error').length" );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Secret').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($PrivateLocation);
        $Selenium->find_element( "#Secret",     'css' )->send_keys("secret");
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Click to 'Read certificate', verify JS will open a pop up window.
        $Selenium->find_element( ".CertificateRead", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait for page to be fully loaded.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("a.CancelClosePopup:visible").length === 1;'
        );
        $Selenium->VerifiedRefresh();
        $Selenium->find_element( "a.CancelClosePopup", 'css' )->click();

        # Switch window back.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Check download file name.
        my $BaseURL = $ConfigObject->Get('HttpType') . '://';

        $BaseURL .= $Helper->GetTestHTTPHostname() . '/';
        $BaseURL .= $ConfigObject->Get('ScriptAlias') . 'index.pl?';

        my $UserAgent = LWP::UserAgent->new(
            Timeout => 60,
        );
        $UserAgent->cookie_jar( {} );    # keep cookies

        my $ResponseLogin = $UserAgent->get(
            $BaseURL . "Action=Login;User=$TestUserLogin;Password=$TestUserLogin;"
        );

        for my $TestSMIME (qw(key cert)) {

            # Check for test created Certificate and Private key download file name.
            my $Response = $UserAgent->get(
                $BaseURL . "Action=AdminSMIME;Subaction=Download;Type=$TestSMIME;Filename=4d400195.0"
            );
            if ( $ResponseLogin->is_success() && $Response->is_success() ) {

                $Self->True(
                    index( $Response->header('content-disposition'), "4d400195-$TestSMIME.pem" ) > -1,
                    "Download file name is correct - 4d400195-$TestSMIME.pem",
                );
            }

            # Check for test created Certificate and Privatekey and delete them.
            $Self->True(
                index( $Selenium->get_page_source(), "Type=$TestSMIME;Filename=" ) > -1,
                "Test $TestSMIME SMIME found on table",
            );

            $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;Type=$TestSMIME;Filename=' )]")->click();
            sleep 1;

            $Selenium->WaitFor( AlertPresent => 1 );
            $Selenium->accept_alert();

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('a[href*=\"Delete;Type=$TestSMIME;Filename=\"]').length == 0;"
            );
            $Selenium->VerifiedRefresh();

            # Check if Certificate and Privatekey is deleted.
            $Self->False(
                $Selenium->execute_script(
                    "return \$('a[href*=\"Delete;Type=$TestSMIME;Filename=\"]').length;"
                ),
                "SMIME-$TestSMIME is deleted",
            );
        }

        # Delete needed test directories.
        for my $Directory ( $CertPath, $PrivatePath ) {
            my $Success = File::Path::rmtree( [$Directory] );
            $Self->True(
                $Success,
                "Directory deleted - '$Directory'",
            );
        }
    }
);

1;
