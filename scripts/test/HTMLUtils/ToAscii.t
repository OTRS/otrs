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

use Kernel::System::ObjectManager;

my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

# ToAscii tests
my @Tests = (
    {
        Input  => 'Some Text',
        Result => 'Some Text',
        Name   => 'ToAscii - simple'
    },
    {
        Input  => '<b>Some Text</b>',
        Result => 'Some Text',
        Name   => 'ToAscii - simple'
    },
    {
        Input  => '<b>Some Text</b><br/><a href="http://example.com">Some URL</a>',
        Result => 'Some Text
[1]Some URL

[1] http://example.com
',
        Name => 'ToAscii - simple'
    },
    {
        Input  => '<b>Some Text</b><br/>More Text',
        Result => 'Some Text
More Text',
        Name => 'ToAscii - simple'
    },
    {
        Input  => '<b>Some Text</b><br  type="_moz" />More Text',
        Result => 'Some Text
More Text',
        Name => 'ToAscii - simple'
    },
    {
        Input  => '<b>Some Text</b><br />More <i>Text</i>',
        Result => 'Some Text
More Text',
        Name => 'ToAscii - simple'
    },
    {
        Input => '&gt; This is the first test.<br/>
&gt; <br/>
&gt; Buenas noches,<br/>
&gt; <br/>',
        Result => "> This is the first test.
> \n> Buenas noches,\n> \n",
        Name => 'ToAscii - simple'
    },
    {
        Input => '<div>Martin,</div>
<div>&nbsp;</div>
<div>I am lost. <b>Martin</b> says that...</div>
<div>&nbsp;</div>
<div>--Shawn</div>
<div>&nbsp;</div>',
        Result => 'Martin,
 ' . chr(160) . '
 I am lost. Martin says that...
 ' . chr(160) . '
 --Shawn
 ' . chr(160) . '
',
        Name => 'ToAscii - simple'
    },
    {
        Input =>
            '<ul><li>a</li><li>b</li><li>c</li></ul><ol><li>one</li><li>two</li><li>three</li></ol>',
        Result => '
 - a
 - b
 - c

 - one
 - two
 - three

',
        Name => 'ToAscii - simple'
    },
    {
        Input =>
            '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;"><p>test<br />
test<br />
test<br />
test<br />
test<br />
</p>
<ul><li>1</li><li>2</li><li>3</li><li>4</li><li>5</li></ul></body></html>',
        Result => '
test
test
test
test
test

 - 1
 - 2
 - 3
 - 4
 - 5

',
        Name => 'ToAscii - simple'
    },
    {
        Input  => "<pre>Some Text\n\nWith new Lines</pre>",
        Result => "\nSome Text\n\nWith new Lines\n\n",
        Name   => 'ToAscii - <pre>'
    },
    {
        Input  => "<code>Some Text\n\nWith new Lines  </code><br />Some Other Text",
        Result => "\nSome Text\n\nWith new Lines  \n\nSome Other Text",
        Name   => 'ToAscii - <code>'
    },
    {
        Input =>
            "<blockquote>Some Text<br/><br/>With new Lines  </blockquote><br />Some Other Text",
        Result => "> Some Text\n> \n> With new Lines \n\nSome Other Text",
        Name   => 'ToAscii - <blockquote>'
    },
    {
        Input =>
            "<pre><a class=\"moz-txt-link-freetext\"\rhref=\"mailto:html\@example.com\">mailto:html\@example.com</a></pre>",
        Result => "\n[1]mailto:html\@example.com\n\n\n\n[1] mailto:html\@example.com\n",
        Name   => 'ToAscii - <a class ... href ..>'
    },
    {
        Input => 'First Line<br>
Second Line<br />
Third Line<br class="foo">
Fourth Line<br class="bar" />
Fifth Line',
        Result => 'First Line
Second Line
Third Line
Fourth Line
Fifth Line',
        Name => 'ToAscii - <br> and line breaks'
    },
    {
        Input =>
            '<html><head><style type="text/css"> #some_css {color: #FF0000} </style><body>Important Text!<style type="text/css"> #some_more_css{ color: #00FF00 } </style> Some more text.</body></html>',
        Result => 'Important Text! Some more text.',
        Name   => 'ToAscii - Test for bug#7937 - HTMLUtils.pm ignore to much of e-mail source code.'
    },
    {
        Input  => '<td>Test table cell</td><td>Second cell</td>',
        Result => 'Test table cell Second cell ',
        Name   => 'ToAscii - Test for bug#8352 - Wrong substitution regex in HTMLUtils.pm->ToAscii.'
    },
    {
        Input  => 'a       b',
        Result => 'a b',
        Name   => 'ToAscii - Whitespace removal'
    },
    {
        Input  => 'a<style>b</style>c<style type="text/css">d</style  >e',
        Result => 'ace',
        Name   => 'ToAscii - <style> removal'
    },
    {
        Input  => '<!-- asdlfjasdf sdflajsdfj -->',
        Result => '',
        Name   => 'ToAscii - comment removal'
    },
    {
        Input  => 'a <!-- asdlfjasdf sdflajsdfj -->   ce',
        Result => 'a ce',
        Name   => 'ToAscii - comment removal with content'
    },
    {
        Input  => "a <!-- asdlfjasdf \n sdflajsdfj -->   ce",
        Result => 'a ce',
        Name   => 'ToAscii - comment removal with content',
    },
    {
        Input  => 'a<style />bc<style type="text/css">d</style  >e',
        Result => 'abce',
        Name   => 'ToAscii - <style /> removal'
    },
    {
        Input  => 'a<style type="text/css" />bc<style type="text/css">d</style  >e',
        Result => 'abce',
        Name   => 'ToAscii - <style /> (with attributes) removal'
    },
    {
        Input  => 'a<style/>bc<style type="text/css">d</style  >e',
        Result => 'abce',
        Name   => 'ToAscii - <style/> (no whitespaces) removal'
    },
);

for my $Test (@Tests) {
    my $Ascii = $HTMLUtilsObject->ToAscii(
        String => $Test->{Input},
    );

    # this line is for Windows check-out
    $Test->{Result} =~ s{\r\n}{\n}smxg;
    $Self->Is(
        $Ascii,
        $Test->{Result},
        $Test->{Name},
    );
}

1;
