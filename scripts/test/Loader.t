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
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $LoaderObject = $Kernel::OM->Get('Kernel::System::Loader');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

{
    my $CSS = $MainObject->FileRead(
        Location => $ConfigObject->Get('Home')
            . '/scripts/test/sample/Loader/OTRS.Reset.css',
    );

    $CSS = ${$CSS};

    my $ExpectedCSS = $MainObject->FileRead(
        Location => $ConfigObject->Get('Home')
            . '/scripts/test/sample/Loader/OTRS.Reset.min.css',
    );

    $ExpectedCSS = ${$ExpectedCSS};

    my $MinifiedCSS = $LoaderObject->MinifyCSS( Code => $CSS );

    $Self->Is(
        $MinifiedCSS || '',
        $ExpectedCSS,
        'MinifyCSS()',
    );

    # empty cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Loader',
    );

    my $MinifiedCSSFile = $LoaderObject->GetMinifiedFile(
        Location => $ConfigObject->Get('Home')
            . '/scripts/test/sample/Loader/OTRS.Reset.css',
        Type => 'CSS',
    );

    my $MinifiedCSSFileCached = $LoaderObject->GetMinifiedFile(
        Location => $ConfigObject->Get('Home')
            . '/scripts/test/sample/Loader/OTRS.Reset.css',
        Type => 'CSS',
    );

    $Self->Is(
        $MinifiedCSSFile,
        $ExpectedCSS,
        'GetMinifiedFile() for CSS, no cache',
    );

    $Self->Is(
        $MinifiedCSSFile,
        $ExpectedCSS,
        'GetMinifiedFile() for CSS, with cache',
    );
}

{
    my $JavaScript = $MainObject->FileRead(
        Location => $ConfigObject->Get('Home')
            . '/scripts/test/sample/Loader/OTRS.Agent.App.Login.js',
    );
    $JavaScript = ${$JavaScript};

    # make sure line endings are standardized
    $JavaScript =~ s{\r\n}{\n}xmsg;

    my $MinifiedJS = $LoaderObject->MinifyJavaScript( Code => $JavaScript );

    my $ExpectedJS = $MainObject->FileRead(
        Location => $ConfigObject->Get('Home')
            . '/scripts/test/sample/Loader/OTRS.Agent.App.Login.min.js',
    );
    $ExpectedJS = ${$ExpectedJS};
    $ExpectedJS =~ s{\r\n}{\n}xmsg;

    $Self->Is(
        $MinifiedJS || '',
        $ExpectedJS,
        'MinifyJavaScript()',
    );
}

{
    my $MinifiedJSFilename = $LoaderObject->MinifyFiles(
        List => [
            $ConfigObject->Get('Home')
                . '/scripts/test/sample/Loader/OTRS.Agent.App.Login.js',
            $ConfigObject->Get('Home')
                . '/scripts/test/sample/Loader/OTRS.Agent.App.Dashboard.js',
        ],
        Type            => 'JavaScript',
        TargetDirectory => $ConfigObject->Get('TempDir'),
    );

    $Self->True(
        $MinifiedJSFilename,
        'MinifyFiles() - no cache',
    );

    my $MinifiedJSFilename2 = $LoaderObject->MinifyFiles(
        List => [
            $ConfigObject->Get('Home')
                . '/scripts/test/sample/Loader/OTRS.Agent.App.Login.js',
            $ConfigObject->Get('Home')
                . '/scripts/test/sample/Loader/OTRS.Agent.App.Dashboard.js',
        ],
        Type            => 'JavaScript',
        TargetDirectory => $ConfigObject->Get('TempDir'),
    );

    $Self->True(
        $MinifiedJSFilename2,
        'MinifyFiles() - with cache',
    );

    $Self->Is(
        $MinifiedJSFilename,
        $MinifiedJSFilename2,
        'MinifyFiles() - compare cache and no cache',
    );

    my $MinifiedJS = $MainObject->FileRead(
        Location => $ConfigObject->Get('TempDir') . "/$MinifiedJSFilename",
    );
    $MinifiedJS = ${$MinifiedJS};
    $MinifiedJS =~ s{\r\n}{\n}xmsg;

    my $Expected = $MainObject->FileRead(
        Location => $ConfigObject->Get('Home')
            . '/scripts/test/sample/Loader/CombinedJavaScript.min.js',
    );
    $Expected = ${$Expected};
    $Expected =~ s{\r\n}{\n}xmsg;

    $Self->Is(
        $MinifiedJS,
        $Expected,
        'MinifyFiles() result content',
    );

    $MainObject->FileDelete(
        Location => $ConfigObject->Get('TempDir') . "/$MinifiedJSFilename",
    );
}

my @JSTests = (

    # this next test shows a case where the minification currently only works with
    # parens around the regular expression. Without them, CSS::Minifier (currently 1.05) will die.
    {
        Source => 'function test(s) { return (/\d{1,2}/).test(s); }',
        Result => 'function test(s){return(/\d{1,2}/).test(s);}',
        Name   => 'Regexp minification',
    }
);

for my $Test (@JSTests) {
    my $Result = $LoaderObject->MinifyJavaScript(
        Code => $Test->{Source},
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        $Test->{Name},
    );
}

1;
