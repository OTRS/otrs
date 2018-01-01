# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));
use File::Path ();

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get needed objects
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # create directory for certificates and private keys
        my $CertPath    = $ConfigObject->Get('Home') . "/var/tmp/certs";
        my $PrivatePath = $ConfigObject->Get('Home') . "/var/tmp/private";
        File::Path::rmtree($CertPath);
        File::Path::rmtree($PrivatePath);
        File::Path::make_path( $CertPath,    { chmod => 0770 } );    ## no critic
        File::Path::make_path( $PrivatePath, { chmod => 0770 } );    ## no critic

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # disabled SMIME in config
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME',
            Value => 0
        );

        # navigate to AdminSMIME screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSMIME");

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # check widget sidebar when SMIME sysconfig is disabled
        $Self->True(
            $Selenium->find_element( 'h3 span.Warning', 'css' ),
            "Widget sidebar with warning message is displayed.",
        );
        $Self->True(
            $Selenium->find_element("//button[\@value='Enable it here!']"),
            "Button 'Enable it here!' to the SMIME SysConfig is displayed.",
        );

        # enable SMIME in config
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME',
            Value => 1
        );

        # set SMIME paths in sysConfig
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

        # refresh AdminSMIME screen
        $Selenium->VerifiedRefresh();

        # check widget sidebar when SMIME sysconfig does not work
        $Self->True(
            $Selenium->find_element( 'h3 span.Error', 'css' ),
            "Widget sidebar with error message is displayed.",
        );
        $Self->True(
            $Selenium->find_element("//button[\@value='Configure it here!']"),
            "Button 'Configure it here!' to the SMIME SysConfig is displayed.",
        );

        # set SMIME paths in sysConfig
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

        # refresh AdminSMIME screen
        $Selenium->VerifiedRefresh();

        # check overview screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );
        $Selenium->find_element( "#FilterSMIME",      'css' );

        # click 'Add certificate'
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ShowAddCertificate' )]")->VerifiedClick();

        # check breadcrumb on 'Add Certificate' screen
        my $Count = 1;
        for my $BreadcrumbText ( 'S/MIME Management', 'Add Certificate' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # add certificate
        my $CertLocation = $ConfigObject->Get('Home')
            . "/scripts/test/sample/SMIME/SMIMECertificate-smimeuser1.crt";

        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($CertLocation);
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # click 'Add private key'
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ShowAddPrivate' )]")->VerifiedClick();

        # check breadcrumb on 'Add Private Key' screen
        $Count = 1;
        for my $BreadcrumbText ( 'S/MIME Management', 'Add Private Key' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # add private key
        my $PrivateLocation = $ConfigObject->Get('Home')
            . "/scripts/test/sample/SMIME/SMIMEPrivateKey-smimeuser1.pem";

        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($PrivateLocation);
        $Selenium->find_element( "#Secret",     'css' )->send_keys("secret");
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # click to 'Read certificate', verify JS will open a pop up window
        $Selenium->find_element( ".CertificateRead", 'css' )->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait for page to be fully loaded
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("a.CancelClosePopup:visible").length === 1;'
        );

        $Self->True(
            $Selenium->find_element( "a.CancelClosePopup", 'css' )->click(),
            "Pop-up window is found - JS is successful"
        );

        # switch window back
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # check for test created Certificate and Privatekey and delete them
        for my $TestSMIME (qw(key cert)) {

            $Self->True(
                index( $Selenium->get_page_source(), "Type=$TestSMIME;Filename=" ) > -1,
                "Test $TestSMIME SMIME found on table",
            );

            $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;Type=$TestSMIME;Filename=' )]")->click();

            $Selenium->WaitFor( AlertPresent => 1 );

            # accept JS delete confirmation dialog
            $Selenium->accept_alert();

            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
            );
        }

        # delete needed test directories
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
