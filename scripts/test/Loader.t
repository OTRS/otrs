# --
# Loader.t - Loader backend tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: Loader.t,v 1.3 2010-05-26 12:18:50 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use Kernel::System::Loader;

my $LoaderObject = Kernel::System::Loader->new( %{$Self} );

my $CSS = $Self->{MainObject}->FileRead(
    Location => $Self->{ConfigObject}->Get('Home')
        . '/var/httpd/htdocs/skins/Agent/default/css/OTRS.Reset.CSS',
);

$CSS = ${$CSS};

my $ExpectedCSS = <<'EOF';
@media all{html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,font,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td,hr{margin:0;padding:0;border:0;outline:0;font-weight:inherit;font-style:inherit;font-size:100%;font-family:inherit;vertical-align:baseline;background-image:none;direction:inherit;}body{line-height:1;color:black;background:white;text-align:left;margin:0;padding:0;}ol,ul{list-style:none;}table{border-collapse:collapse;border-spacing:0;}caption,th,td{text-align:left;font-weight:normal;}.RTL caption,.RTL th,.RTL td{text-align:right;}blockquote:before,blockquote:after,q:before,q:after{content:"";}blockquote,q{quotes:"" "";}a{text-decoration:none;}strong{font-weight:bold;}select{margin-top:-1px;}}
EOF

chomp($ExpectedCSS);

my $MinifiedCSS = $LoaderObject->MinifyCSS( Code => $CSS );

$Self->Is(
    $MinifiedCSS || '',
    $ExpectedCSS,
    'MinifyCSS()',
);

my $JavaScript = $Self->{MainObject}->FileRead(
    Location => $Self->{ConfigObject}->Get('Home')
        . '/var/httpd/htdocs/js_new/OTRS.Agent.App.Login.js',
);
$JavaScript = ${$JavaScript};

my $MinifiedJS = $LoaderObject->MinifyJavaScript( Code => $JavaScript );

my $ExpectedJS = <<'EOF';
"use strict";var OTRS=OTRS||{};OTRS.Agent=OTRS.Agent||{};OTRS.Agent.App=OTRS.Agent.App||{};OTRS.Agent.App.Login=(function(TargetNS){TargetNS.Init=function(){if(!OTRS.Debug.BrowserCheck()){$('#LoginBox').hide();$('#OldBrowser').show();return;}
OTRS.Form.EnableForm($('#LoginBox form, #PasswordBox form'));if($('#User').val()&&$('#User').val().length){$('#Password').focus();}
else{$('#User').focus();}
$('#LostPassword, #BackToLogin').click(function(){$('#LoginBox, #PasswordBox').toggle();return false;});Now=new Date();$('#TimeOffset').val(Now.getTimezoneOffset());}
return TargetNS;}(OTRS.Agent.App.Login||{}));
EOF

chomp($ExpectedJS);

$Self->Is(
    $MinifiedJS || '',
    $ExpectedJS,
    'MinifyJavaScript()',
);

# empty cache
$LoaderObject->{CacheInternalObject}->CleanUp();

my $MinifiedCSSFile = $LoaderObject->GetMinifiedFile(
    Location => $Self->{ConfigObject}->Get('Home')
        . '/var/httpd/htdocs/skins/Agent/default/css/OTRS.Reset.CSS',
    Type => 'CSS',
);

my $MinifiedCSSFileCached = $LoaderObject->GetMinifiedFile(
    Location => $Self->{ConfigObject}->Get('Home')
        . '/var/httpd/htdocs/skins/Agent/default/css/OTRS.Reset.CSS',
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

1;
