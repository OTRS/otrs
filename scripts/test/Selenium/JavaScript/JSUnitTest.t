# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));
use Time::HiRes qw(sleep);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $WebPath = $ConfigObject->Get('Frontend::WebPath');

        my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/httpd/htdocs/js/test',
            Filter    => "*.html",
        );

        for my $File (@Files) {

            # Remove path
            $File =~ s{.*/}{}smx;

            $Selenium->get("${WebPath}js/test/$File");

            my $JSModuleName = $File;
            $JSModuleName =~ s{\.UnitTest\.html}{}xms;

            # Wait for the tests to complete.
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('span.module-name:contains($JSModuleName)').length;"
            );
            $Selenium->WaitFor(
                JavaScript => 'return typeof($) === "function" && $("#qunit-testresult.complete").length;'
            );

            my $Completed = $Selenium->execute_script(
                "return \$('#qunit-testresult.complete').length"
            );

            $Self->True(
                $Completed,
                "$File - JavaScript unit tests completed"
            );

            $Selenium->find_element( "#qunit-testresult span.failed", 'css' );
            $Selenium->find_element( "#qunit-testresult span.passed", 'css' );
            $Selenium->find_element( "#qunit-testresult span.total",  'css' );

            my ( $Passed, $Failed, $Total );
            $Passed = $Selenium->execute_script(
                "return \$('#qunit-testresult span.passed').text()"
            );
            $Failed = $Selenium->execute_script(
                "return \$('#qunit-testresult span.failed').text()"
            );
            $Total = $Selenium->execute_script(
                "return \$('#qunit-testresult span.total').text()"
            );

            $Self->True( $Passed, "$File - found passed tests" );
            $Self->Is( $Passed, $Total, "$File - total number of tests" );
            $Self->False( $Failed, "$File - failed tests" );

            # Generate screenshot on failure
            if ( $Failed || !$Passed || $Passed != $Total ) {
                $Selenium->HandleError("Failed JS unit tests found.");
            }
        }

    }
);

1;
