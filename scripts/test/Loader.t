# --
# Loader.t - Loader backend tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: Loader.t,v 1.5 2010-05-31 10:51:11 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

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

    my $MinifiedJS = $LoaderObject->MinifyJavaScript( Code => $JavaScript );

    my $ExpectedJS = $Self->{MainObject}->FileRead(
        Location => $Self->{ConfigObject}->Get('Home')
            . '/scripts/test/sample/Loader/OTRS.Agent.App.Login.min.js',
    );
    $ExpectedJS = ${$ExpectedJS};

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

    my $Expected = $Self->{MainObject}->FileRead(
        Location => $Self->{ConfigObject}->Get('Home')
            . '/scripts/test/sample/Loader/CombinedJavaScript.min.js',
    );
    $Expected = ${$Expected};

    $Self->Is(
        $MinifiedJS,
        $Expected,
        'MinifyFiles() result content',
    );

    $Self->{MainObject}->FileDelete(
        Location => $Self->{ConfigObject}->Get('TempDir') . "/$MinifiedJSFilename",
    );
}

1;
