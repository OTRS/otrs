# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# TODO: Disable this test for now, until compatibility issues with CI infrastructure are fixed.
return 1;

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Use test database, if configured. Otherwise, skip this test. ProvideTestDatabase() will clean the test database and
#   change database settings system-wide.
my $Success = $Helper->ProvideTestDatabase();
if ( !$Success ) {
    $Self->False(
        0,
        'Test database could not be provided, skipping test'
    );
    return 1;
}
$Self->True(
    $Success,
    'ProvideTestDatabase - Database cleared'
);

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Parse the TestDatabase hash from configuration to variables.
        my $TestDatabase = $ConfigObject->Get('TestDatabase');
        my ( $DBType, $DBName, $DBPort, $DBHost );
        if ( $TestDatabase->{DatabaseDSN} =~ /^DBI:mysql/ ) {
            $DBType = 'mysql';
            ( $DBName, $DBHost ) = ( $TestDatabase->{DatabaseDSN} =~ /database=(.*);host=(.*);?/ );
        }
        elsif ( $TestDatabase->{DatabaseDSN} =~ /^DBI:Pg/ ) {
            $DBType = 'postgresql';
            ( $DBName, $DBHost ) = ( $TestDatabase->{DatabaseDSN} =~ /dbname=(.*);host=(.*);?/ );
        }
        elsif ( $TestDatabase->{DatabaseDSN} =~ /^DBI:Oracle/ ) {
            $DBType = 'oracle';
            ( $DBName, $DBHost, $DBPort ) = ( $TestDatabase->{DatabaseDSN} =~ /sid=(.*);host=(.*);port=(.*);/ );
        }
        else {
            die 'Unsupported database backend';
        }

        my $Home = $ConfigObject->Get('Home');

        # Backup original configuration and make sure secure mode is inactive so that installer can be accessed.
        #   Enforce exception handling for the whole test, and if something goes wrong, we can always restore original
        #   configuration from the backup.
        my $ConfigPmFile       = $Home . '/Kernel/Config.pm';
        my $ConfigPmFileBackup = $Home . '/Kernel/Config.pm.' . $Helper->GetRandomID();

        eval {

            # Make a copy of original configuration file.
            system("cp $ConfigPmFile $ConfigPmFileBackup");
            $Self->True(
                -e $ConfigPmFileBackup,
                'Original configuration backed up successfully'
            ) || die;

            # Turn off secure mode setting via additional configuration file. This works on systems where secure mode is
            #   activated outside the main configuration file (Config.pm).
            $Helper->ConfigSettingChange(
                Key   => 'SecureMode',
                Value => 0,
            );

            # Reload the config object.
            $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Config'] );
            $ConfigObject = $Kernel::OM->Get('Kernel::Config');

            if ( $ConfigObject->Get('SecureMode') ) {
                $Self->True(
                    0,
                    'Secure mode cannot be deactivated'
                );
                die 'Terminating test, please check if you have overridden SecureMode in Config.pm';
            }

            my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

            $Selenium->VerifiedGet("${ScriptAlias}installer.pl");

            # Check if right screen was loaded.
            $Selenium->find_element( '#WebInstallerBox', 'css' );

            # Go to first step of installation (Accept license).
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # Go to second step of installation (Database Selection).
            $Selenium->find_element("//button[\@value='Accept license and continue'][\@type='submit']")
                ->VerifiedClick();

            # Set database type.
            $Selenium->execute_script("\$('#DBType').val('$DBType').trigger('redraw.InputField').trigger('change');");

            # Choose to use existing database for OTRS.
            if ( $DBType ne 'oracle' ) {
                $Selenium->find_element( '#DBInstallTypeUseDB', 'css' )->VerifiedClick();
            }

            # Go to next step of installation (Configure selected DB).
            $Selenium->find_element( '#FormDBSubmit', 'css' )->VerifiedClick();

            # Fill database params.
            $Selenium->find_element( '#DBUser',     'css' )->clear();
            $Selenium->find_element( '#DBUser',     'css' )->send_keys( $TestDatabase->{DatabaseUser} );
            $Selenium->find_element( '#DBPassword', 'css' )->clear();
            $Selenium->find_element( '#DBPassword', 'css' )->send_keys( $TestDatabase->{DatabasePw} );
            $Selenium->find_element( '#DBHost',     'css' )->clear();
            $Selenium->find_element( '#DBHost',     'css' )->send_keys($DBHost);

            if ( $DBType eq 'oracle' ) {
                $Selenium->find_element( '#DBSID',  'css' )->clear();
                $Selenium->find_element( '#DBSID',  'css' )->send_keys($DBName);
                $Selenium->find_element( '#DBPort', 'css' )->clear();
                $Selenium->find_element( '#DBPort', 'css' )->send_keys($DBPort);
            }
            else {
                $Selenium->find_element( '#DBName', 'css' )->clear();
                $Selenium->find_element( '#DBName', 'css' )->send_keys($DBName);
            }

            $Selenium->find_element( '#ButtonCheckDB', 'css' )->VerifiedClick();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Result:visible").length === 1;' );

            $Self->Is(
                $Selenium->execute_script("return \$('.Result p').text().trim();"),
                'Database check successful.',
                'Database check was successful'
            );

            # Go to next step of installation (Create Database).
            $Selenium->find_element( '#FormDBSubmit', 'css' )->VerifiedClick();

            $Self->Is(
                $Selenium->execute_script("return \$('.Result p').text().trim();"),
                'Database setup successful!',
                'Database setup was successful'
            );

            # Go to next step of installation (System Settings).
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # Go to next step of installation (Mail Configuration).
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # Go to last step of installation.
            $Selenium->find_element( '#ButtonSkipMail', 'css' )->VerifiedClick();

            # Verify we are on the last screen.
            $Self->Is(
                $Selenium->execute_script("return \$('.Header h2').text().trim()"),
                'Finished (4/4)',
                'Loaded 4/4 screen'
            );

            my @DatabaseXMLFiles = (
                "$Home/scripts/database/otrs-schema.xml",
                "$Home/scripts/database/otrs-initial_insert.xml",
            );

            my @Tables = $Kernel::OM->Get('Kernel::System::DB')->ListTables();

            # Count number of table elements in OTRS schema for comparison.
            my $XMLString = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => $DatabaseXMLFiles[0],
            );
            my $TableCount = () = ( ${$XMLString} =~ /<Table/g );
            $Self->Is(
                scalar @Tables,
                $TableCount,
                'OTRS tables are found'
            );

            # Try to login in new installed system.
            my $Password = $Selenium->execute_script("return \$('span.Emphasis').text().trim();");
            $Selenium->Login(
                Type     => 'Agent',
                User     => 'root@localhost',
                Password => $Password,
            );

            my $Product = $ConfigObject->Get('Product');
            my $Version = $ConfigObject->Get('Version');

            # Check for version tag in the footer.
            $Self->True(
                index( $Selenium->get_page_source(), "$Product $Version" ) > -1,
                "Version information present ($Product $Version)",
            );

            # Turn on secure mode.
            $Helper->ConfigSettingChange(
                Key   => 'SecureMode',
                Value => 1,
            );

            # Check that secure mode is honored.
            $Selenium->VerifiedGet("${ScriptAlias}installer.pl");
            $Self->True(
                index( $Selenium->get_page_source(), 'SecureMode active!' ) > -1,
                'Secure mode is active'
            );
        };

        # Catch any exceptions raised during the test.
        if ($@) {
            $Selenium->HandleError($@);
            $Self->Is(
                $@,
                undef,
                'Errors encountered during install process'
            );
        }
        else {
            $Self->False(
                $@,
                'No trappable errors encountered'
            );
        }

        # Restore original configuration.
        system("cp $ConfigPmFileBackup $ConfigPmFile") if -e $ConfigPmFileBackup;
        system("rm $ConfigPmFileBackup")               if -e $ConfigPmFileBackup;
    }
);

# Discard the Selenium object before unit test helper object goes out of scope. This will demolish the object before
#   restoring database configuration, and prevents issues with Selenium cleanup because of empty database.
$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::UnitTest::Selenium'] );

1;
