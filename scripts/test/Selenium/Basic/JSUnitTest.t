# --
# JSUnitTest.t - frontend tests that collect the JavaScript unit test results
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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
use Kernel::System::UnitTest::Selenium;

use Time::HiRes qw(sleep);

if ( !$Self->{ConfigObject}->Get('SeleniumTestsConfig') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

my $Helper = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose        => 1,
    UnitTestObject => $Self,
);

eval {

    my $WebPath = $Self->{ConfigObject}->Get('Frontend::WebPath');

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
    $Total
        = $Selenium->execute_script(
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
};

$Selenium->HandleError($@) if $@;

return 1;

1;
