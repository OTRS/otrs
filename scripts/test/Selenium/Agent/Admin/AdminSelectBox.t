# --
# AdminSelectBox.t - frontend tests for AdminSQL
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose        => 1,
    UnitTestObject => $Self,
);

$Selenium->RunTest(
    sub {

        $Selenium->Login(
            Type     => 'Agent',
            User     => 'root@localhost',
            Password => 'root',
        );

        my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminSelectBox");

        # empty SQL statement, check client side validation
        $Selenium->find_element( "#SQL", 'css' )->clear();
        $Selenium->find_element( "#SQL", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#SQL').hasClass('Error')"
            ),
            'true',
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
            'true',
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
