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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminSelectBox");

        # empty SQL statement, check client side validation
        $Selenium->find_element( "#SQL", 'css' )->clear();
        $Selenium->find_element( "#SQL", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#SQL').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value for #SQL',
        );

        # wrong SQL statement, check server side validation
        $Selenium->find_element( "#SQL", 'css' )->clear();
        $Selenium->find_element( "#SQL", 'css' )->send_keys("SELECT * FROM");
        $Selenium->find_element( "#SQL", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#SQL').hasClass('ServerError')"
            ),
            '1',
            'Server side validation correctly detected missing input value for #SQL',
        );

        # correct SQL statement
        $Selenium->find_element( "#SQL", 'css' )->clear();
        $Selenium->find_element( "#SQL", 'css' )->send_keys("SELECT * FROM valid");
        $Selenium->find_element( "#SQL", 'css' )->submit();

        # verify results
        my @Elements = $Selenium->find_elements( 'table thead tr', 'css' );
        $Self->Is(
            scalar @Elements,
            1,
            "Result table header row found",
        );

        @Elements = $Selenium->find_elements( 'table tbody tr', 'css' );
        $Self->Is(
            scalar @Elements,
            3,
            "Result table body rows found",
        );
    }
);

1;
