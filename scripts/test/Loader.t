# --
# Loader.t - Loader backend tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: Loader.t,v 1.10 2011-03-09 14:37:29 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::Loader;

my $LoaderObject = Kernel::System::Loader->new( %{$Self} );

{
    my $CSS = $Self->{MainObject}->FileRead(
        Location => $Self->{ConfigObject}->Get('Home')
            . '/scripts/test/sample/Loader/OTRS.Reset.css',
    );

    $CSS = ${$CSS};

    my $ExpectedCSS = $Self->{MainObject}->FileRead(
        Location => $Self->{ConfigObject}->Get('Home')
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
    $LoaderObject->{CacheInternalObject}->CleanUp();

    my $MinifiedCSSFile = $LoaderObject->GetMinifiedFile(
        Location => $Self->{ConfigObject}->Get('Home')
            . '/scripts/test/sample/Loader/OTRS.Reset.css',
        Type => 'CSS',
    );

    my $MinifiedCSSFileCached = $LoaderObject->GetMinifiedFile(
        Location => $Self->{ConfigObject}->Get('Home')
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
    my $JavaScript = $Self->{MainObject}->FileRead(
        Location => $Self->{ConfigObject}->Get('Home')
            . '/scripts/test/sample/Loader/OTRS.Agent.App.Login.js',
    );
    $JavaScript = ${$JavaScript};

    # Make sure line endings are standardized
    $JavaScript =~ s{\r\n}{\n}xmsg;

    my $MinifiedJS = $LoaderObject->MinifyJavaScript( Code => $JavaScript );

    my $ExpectedJS = $Self->{MainObject}->FileRead(
        Location => $Self->{ConfigObject}->Get('Home')
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
            $Self->{ConfigObject}->Get('Home')
                . '/scripts/test/sample/Loader/OTRS.Agent.App.Login.js',
            $Self->{ConfigObject}->Get('Home')
                . '/scripts/test/sample/Loader/OTRS.Agent.App.Dashboard.js',
        ],
        Type            => 'JavaScript',
        TargetDirectory => $Self->{ConfigObject}->Get('TempDir'),
    );

    $Self->True(
        $MinifiedJSFilename,
        'MinifyFiles() - no cache',
    );

    my $MinifiedJSFilename2 = $LoaderObject->MinifyFiles(
        List => [
            $Self->{ConfigObject}->Get('Home')
                . '/scripts/test/sample/Loader/OTRS.Agent.App.Login.js',
            $Self->{ConfigObject}->Get('Home')
                . '/scripts/test/sample/Loader/OTRS.Agent.App.Dashboard.js',
        ],
        Type            => 'JavaScript',
        TargetDirectory => $Self->{ConfigObject}->Get('TempDir'),
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

    my $MinifiedJS = $Self->{MainObject}->FileRead(
        Location => $Self->{ConfigObject}->Get('TempDir') . "/$MinifiedJSFilename",
    );
    $MinifiedJS = ${$MinifiedJS};
    $MinifiedJS =~ s{\r\n}{\n}xmsg;

    my $Expected = $Self->{MainObject}->FileRead(
        Location => $Self->{ConfigObject}->Get('Home')
            . '/scripts/test/sample/Loader/CombinedJavaScript.min.js',
    );
    $Expected = ${$Expected};
    $Expected =~ s{\r\n}{\n}xmsg;

    $Self->Is(
        $MinifiedJS,
        $Expected,
        'MinifyFiles() result content',
    );

    $Self->{MainObject}->FileDelete(
        Location => $Self->{ConfigObject}->Get('TempDir') . "/$MinifiedJSFilename",
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
