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

        # create and login test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

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

        # navigate to AdminPGP screen
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminPGP");

        # add first test PGP key
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminPGP;Subaction=Add' )]")->click();

        my $Location1 = $ConfigObject->Get('Home')
            . "/scripts/test/sample/Crypt/PGPPrivateKey-1.asc";

        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location1);
        $Selenium->find_element("//button[\@type='submit']")->click();

        # wait for key to upload
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('td.Center').length" );

        # add second test PGP key
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminPGP;Subaction=Add' )]")->click();
        my $Location2 = $ConfigObject->Get('Home')
            . "/scripts/test/sample/Crypt/PGPPrivateKey-2.asc";

        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location2);
        $Selenium->find_element("//button[\@type='submit']")->click();

        # wait for key to upload
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('td.Center').length" );

        # check if test PGP keys show on AdminPGP screen
        my %PGPKey = (
            1 => "unittest\@example.com",
            2 => "unittest2\@example.com",
        );

        $Self->True(
            index( $Selenium->get_page_source(), $PGPKey{1} ) > -1,
            "$PGPKey{1} test PGP key found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $PGPKey{2} ) > -1,
            "$PGPKey{2} test PGP key found on page",
        );

        # test search filter
        $Selenium->find_element( "#Search", 'css' )->send_keys( $PGPKey{1} );
        $Selenium->find_element( "#Search", 'css' )->submit();

        $Self->True(
            index( $Selenium->get_page_source(), $PGPKey{1} ) > -1,
            "$PGPKey{1} test PGP key found on page",
        );
        $Self->False(
            index( $Selenium->get_page_source(), $PGPKey{2} ) > -1,
            "$PGPKey{2} test PGP key is not found on page",
        );

        #clear search filter
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->submit();

        # set test PGP in config so we can delete them
        $ConfigObject->Set(
            Key   => 'PGP',
            Value => 1,
        );
        $ConfigObject->Set(
            Key   => 'PGP::Options',
            Value => "--homedir $PGPPath --batch --no-tty --yes",
        );

        # delete test PGP keys
        for my $Count ( 1 .. 2 ) {
            my @Keys = $Kernel::OM->Get('Kernel::System::Crypt::PGP')->KeySearch(
                Search => $PGPKey{$Count},
            );

            for my $Key (@Keys) {
                if ( $Key->{Type} eq 'sec' ) {

                    # click on delete secure key
                    $Selenium->find_element(
                        "//a[contains(\@href, \'Subaction=Delete;Type=sec;Key=$Key->{FingerprintShort}' )]"
                    )->click();
                    $Self->True(
                        $Key,
                        "PGPKey - $Key->{Identifier} deleted",
                    );

                    # click on delete public key
                    $Selenium->find_element(
                        "//a[contains(\@href, \'Subaction=Delete;Type=pub;Key=$Key->{FingerprintShort}' )]"
                    )->click();
                    $Self->True(
                        $Key,
                        "PGPKey - $Key->{Identifier} deleted",
                    );
                }
            }
        }

        # remove test PGP path
        my $Success = rmtree( [$PGPPath] );
        $Self->True(
            $Success,
            "Directory deleted - '$PGPPath'",
        );

    }

);

1;
