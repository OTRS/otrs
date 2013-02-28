# --
# 000-JSUnitTest.t - frontend tests that collect the JavaScript unit test results
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::Config;
use Kernel::System::User;

use Kernel::System::UnitTest::Helper;

use Time::HiRes qw(sleep);

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

require Kernel::System::UnitTest::Selenium;    ## no critic

my $Helper = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

for my $SeleniumScenario ( @{ $Helper->SeleniumScenariosGet() } ) {
    eval {
        my $Selenium = Kernel::System::UnitTest::Selenium->new(
            Verbose        => 1,
            UnitTestObject => $Self,
            %{$SeleniumScenario},
        );

        eval {

            my $WebPath = $Self->{ConfigObject}->Get('Frontend::WebPath');

            $Selenium->open_ok("${WebPath}js/test/JSUnitTest.html");
            $Selenium->wait_for_page_to_load_ok("30000");

            # wait for the javascript tests (including AJAX) to complete
            WAIT:
            for ( 1 .. 20 ) {
                last WAIT if ( $Selenium->is_element_present("css=p.result span.failed") );
                sleep(0.2);
            }

            $Selenium->is_element_present_ok("css=p.result span.failed");
            $Selenium->is_element_present_ok("css=p.result span.passed");
            $Selenium->is_element_present_ok("css=p.result span.total");

            my ( $Passed, $Failed, $Total );
            $Passed = $Selenium->get_eval(
                "this.browserbot.getCurrentWindow().\$('p.result span.passed').text()"
            );
            $Failed = $Selenium->get_eval(
                "this.browserbot.getCurrentWindow().\$('p.result span.failed').text()"
            );
            $Total
                = $Selenium->get_eval(
                "this.browserbot.getCurrentWindow().\$('p.result span.total').text()"
                );

            $Self->True( $Passed, 'Found passed tests' );
            $Self->Is( $Passed, $Total, 'Total number of tests' );
            $Self->False( $Failed, 'Failed tests' );

            for my $Test ( 1 .. $Passed ) {
                $Self->True( 1, 'Successful JavaScript unit test found' );
            }

            for my $Test ( 1 .. $Failed ) {
                $Self->True(
                    0,
                    'Failed JavaScript unit test found (open js/test/JSUnitTest.html in your browser for details)'
                );
            }

            return 1;
        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;
    }
        || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" )
        ;
}

1;
