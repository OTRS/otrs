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
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # enable PGP
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'PGP',
            Value => 1
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # create test PGP path and set it in sysConfig
        my $PGPPath = $ConfigObject->Get('Home') . "/var/tmp/pgp";
        mkpath( [$PGPPath], 0, 0770 );    ## no critic

        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'PGP::Options',
            Value => "--homedir $PGPPath --batch --no-tty --yes",
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

        # change customer PGP key preference
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/Crypt/PGPPrivateKey-1.asc";
        $Selenium->find_element( "#UserPGPKey", 'css' )->send_keys($Location);
        $Selenium->find_element( "#UserPGPKey", 'css' )->submit();

        # check for update PGP preference key on screen
        $Self->True(
            index( $Selenium->get_page_source(), 'imported: 1 gpg' ) > -1,
            'Customer preference PGP key - updated'
        );
        sleep 10;

        # remove test PGP path
        my $Success = rmtree( [$PGPPath] );
        $Self->True(
            $Success,
            "Directory deleted - '$PGPPath'",
        );
    }
);

1;
