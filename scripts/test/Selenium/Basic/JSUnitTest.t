# --
# JSUnitTest.t - frontend tests that collect the JavaScript unit test results
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

use Time::HiRes qw(sleep);

use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $WebPath = $ConfigObject->Get('Frontend::WebPath');

        $Selenium->get("${WebPath}js/test/JSUnitTest.html");

        # wait for the javascript tests (including AJAX) to complete
        WAIT:
        for ( 1 .. 20 ) {

            if ( eval { $Selenium->find_element( "p.result span.failed", 'css' ); } ) {
                last WAIT;
            }

            sleep(0.2);
        }

        $Selenium->find_element( "p.result span.failed", 'css' );
        $Selenium->find_element( "p.result span.passed", 'css' );
        $Selenium->find_element( "p.result span.total",  'css' );

        my ( $Passed, $Failed, $Total );
        $Passed = $Selenium->execute_script(
            "return \$('p.result span.passed').text()"
        );
        $Failed = $Selenium->execute_script(
            "return \$('p.result span.failed').text()"
        );
        $Total = $Selenium->execute_script(
            "return \$('p.result span.total').text()"
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
        }
);

1;
