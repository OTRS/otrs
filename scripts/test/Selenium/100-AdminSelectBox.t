# --
# 100-AdminSelectBox.t - frontend tests for AdminSQL
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: 100-AdminSelectBox.t,v 1.4.2.2 2011-02-09 15:45:46 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::UnitTest::Helper;
use Time::HiRes qw(sleep);

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

require Kernel::System::UnitTest::Selenium;

my $Helper = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

for my $SeleniumScenario ( @{ $Helper->SeleniumScenariosGet() } ) {
    eval {
        my $sel = Kernel::System::UnitTest::Selenium->new(
            Verbose        => 1,
            UnitTestObject => $Self,
            %{$SeleniumScenario},
        );

        eval {

            $sel->Login(
                Type     => 'Agent',
                User     => 'root@localhost',
                Password => 'root',
            );

            my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

            $sel->open_ok("${ScriptAlias}index.pl?Action=AdminSelectBox");
            $sel->wait_for_page_to_load_ok("30000");

            # empty SQL statement, check client side validation
            $sel->type_ok( "SQL", "" );
            $sel->click_ok("css=button#Run");
            $Self->Is(
                $sel->get_eval(
                    "this.browserbot.getCurrentWindow().\$('#SQL').hasClass('Error')"
                ),
                'true',
                'Client side validation correctly detected missing input value for #SQL',
            );

            # wrong SQL statement, check server side validation
            $sel->type_ok( "SQL", "SELECT * FROM" );
            $sel->click_ok("css=button#Run");
            $sel->wait_for_page_to_load_ok("30000");
            $Self->Is(
                $sel->get_eval(
                    "this.browserbot.getCurrentWindow().\$('#SQL').hasClass('ServerError')"
                ),
                'true',
                'Server side validation correctly detected missing input value for #SQL',
            );

            # correct SQL statement
            $sel->type_ok( "SQL", "SELECT * FROM valid" );
            $sel->click_ok("css=button#Run");

            # now the button must be disabled
            $Self->Is(
                $sel->get_eval(
                    "this.browserbot.getCurrentWindow().\$('button#Run').attr('disabled')"
                ),
                'true',
                'Check for prevention of multiple submits',
            );
            $sel->wait_for_page_to_load_ok("30000");

            # verify results
            $sel->table_is( "//table.0.0", "1" );
            $sel->table_is( "//table.0.1", "valid" );
            $sel->table_is( "//table.1.0", "2" );
            $sel->table_is( "//table.1.1", "invalid" );
            $sel->table_is( "//table.2.0", "3" );
            $sel->table_is( "//table.2.1", "invalid-temp[...]" );

            return 1;
        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;

    } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );
}

1;
