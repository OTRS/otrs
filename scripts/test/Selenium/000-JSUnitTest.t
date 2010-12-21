# --
# 000-JSUnitTest.t - frontend tests that collect the JavaScript unit test results
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: 000-JSUnitTest.t,v 1.1 2010-12-21 13:31:11 mg Exp $
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

use Kernel::System::UnitTest::Selenium;
use Time::HiRes qw(sleep);

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

my $sel = Kernel::System::UnitTest::Selenium->new(
    Verbose        => 1,
    UnitTestObject => $Self,
);

my $WebPath = $Self->{ConfigObject}->Get('Frontend::WebPath');

$sel->open_ok("${WebPath}js/test/JSUnitTest.html");
$sel->wait_for_page_to_load_ok("30000");

# wait for the javascript tests (including AJAX) to complete
$sel->set_timeout_ok("3000");

$sel->is_element_present_ok("css=p.result span.failed");
$sel->is_element_present_ok("css=p.result span.passed");
$sel->is_element_present_ok("css=p.result span.total");

if (
    !eval {
        $sel->eval_is(
            "this.browserbot.getCurrentWindow().\$('p.result span.failed').text()",
            "0"
        );
        $sel->eval_is(
            "this.browserbot.getCurrentWindow().\$('p.result span.passed').text() > 0",
            "true"
        );
        $sel->eval_is(
            "this.browserbot.getCurrentWindow().\$('p.result span.passed').text() == this.browserbot.getCurrentWindow().\$('p.result span.total').text()",
            "true"
        );
    }
    )
{
    $Self->True( 0, "An expeption occurred: $@" );
}

1;
