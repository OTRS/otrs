# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));
use File::Path qw(mkpath rmtree);

# get selenium object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Selenium' => {
        Verbose => 1,
        }
);
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
                }
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # enable SMIME in config
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'SMIME',
            Value => 1
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # create directory for certificates and private keys
        my $CertPath    = $ConfigObject->Get('Home') . "/var/tmp/certs";
        my $PrivatePath = $ConfigObject->Get('Home') . "/var/tmp/private";
        mkpath( [$CertPath],    0, 0770 );    ## no critic
        mkpath( [$PrivatePath], 0, 0770 );    ## no critic

        # set SMIME paths in sysConfig
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'SMIME::CertPath',
            Value => $CertPath,
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'SMIME::PrivatePath',
            Value => $PrivatePath,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestCustomerUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # go to customer preferences
        $Selenium->get("${ScriptAlias}customer.pl?Action=CustomerPreferences");

        # change customer SMIME certificate preference
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/SMIME/SMIMECertificate-1.asc";
        $Selenium->find_element( "#UserSMIMEKey", 'css' )->send_keys($Location);
        $Selenium->execute_script("\$('#UserSMIMEKey').parents('form').submit();");

        # check for update SMIME certificate preference on screen
        $Self->True(
            index( $Selenium->get_page_source(), 'Certificate uploaded' ) > -1,
            'Customer preference SMIME certificate - updated'
        );

        # delete needed test directories
        for my $Directory ( $CertPath, $PrivatePath ) {
            my $Success = rmtree( [$Directory] );
            $Self->True(
                $Success,
                "Directory deleted - '$Directory'",
            );
        }
        }
);

1;
