# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable PGP
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PGP',
            Value => 1
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # check if gpg is located there
        if ( !-e $ConfigObject->Get('PGP::Bin') ) {

            # maybe it's a mac with macport
            if ( -e '/opt/local/bin/gpg' ) {
                $ConfigObject->Set(
                    Key   => 'PGP::Bin',
                    Value => '/opt/local/bin/gpg'
                );
            }

            # Try to guess using system 'which'
            else {    # try to guess
                my $GPGBin = `which gpg`;
                chomp $GPGBin;
                if ($GPGBin) {
                    $ConfigObject->Set(
                        Key   => 'PGP::Bin',
                        Value => $GPGBin,
                    );
                }
            }
        }

        my $Home = $ConfigObject->Get('Home');

        # create test PGP path and set it in sysConfig
        my $PGPPath = $Home . '/var/tmp/pgp' . $Helper->GetRandomID();
        mkpath( [$PGPPath], 0, 0770 );    ## no critic

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PGP::Options',
            Value => "--homedir $PGPPath --batch --no-tty --yes",
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestCustomerUserCreate(
            Groups   => ['admin'],
            Language => 'en'
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # go to customer preferences
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerPreferences");

        # change customer PGP key preference
        my $Location = $Home . '/scripts/test/sample/Crypt/PGPPrivateKey-1.asc';
        $Selenium->find_element( "#UserPGPKey",       'css' )->send_keys($Location);
        $Selenium->find_element( "#UserPGPKeyUpdate", 'css' )->VerifiedClick();

        # Check if PGP key was uploaded correctly.
        $Self->True(
            index( $Selenium->get_page_source(), '38677C3B' ) > -1,
            'Customer preference PGP key - updated'
        );

        # remove test PGP path
        my $Success = rmtree( [$PGPPath] );
        $Self->True(
            $Success,
            "Directory deleted - '$PGPPath'",
        );
    }
);

1;
