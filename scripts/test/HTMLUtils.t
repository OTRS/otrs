# --
# HTMLUtils.t - HTMLUtils tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::HTMLUtils;

my $HTMLUtilsObject = Kernel::System::HTMLUtils->new( %{$Self} );

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

# DocumentComplete tests
@Tests = (
    {
        Input => 'Some Text',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Some Text</body></html>',
        Name => 'DocumentComplete - simple'
    },
    {
        Input  => '<html><body>Some Text</body></html>',
        Result => '<html><body>Some Text</body></html>',
        Name   => 'DocumentComplete - simple'
    },
);

for my $Test (@Tests) {
    my $Ascii = $HTMLUtilsObject->DocumentComplete(
        Charset => 'iso-8859-1',
        String  => $Test->{Input},
    );
    $Self->Is(
        $Ascii,
        $Test->{Result},
        $Test->{Name},
    );
}

# DocumentStrip tests
@Tests = (
    {
        Input => '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">

<META http-equiv="Content-Type content=text/html; charset=utf-8">
<META content="MSHTML 6.00.2900.3562" name=GENERATOR></HEAD>
<BODY style="FONT-SIZE: 12px; FONT-FAMILY: Courier New,monospace,fixed">
<DIV><SPAN class=678193704-17072009><FONT size=3><SPAN class=monospace>hm there is something
wrong....</SPAN></FONT></SPAN></DIV></BODY></HTML>',
        Result => "
\n
<DIV><SPAN class=678193704-17072009><FONT size=3><SPAN class=monospace>hm there is something
wrong....</SPAN></FONT></SPAN></DIV>",
        Name => 'DocumentStrip - MSHTML'
    },
    {
        Input => '<html>

<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=Windows-1252">

<meta name=Generator content="Microsoft Word 10 (filtered)">

<style>
<!--
 /* Font Definitions */
 @font-face
    {font-family:"Arial Unicode MS";
    panose-1:2 11 6 4 2 2 2 2 2 4;}
@font-face
    {font-family:"\@Arial Unicode MS";
    panose-1:2 11 6 4 2 2 2 2 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
    {margin:0cm;
    margin-bottom:.0001pt;
    font-size:12.0pt;
    font-family:"Times New Roman";}
a:link, span.MsoHyperlink
    {color:blue;
    text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
    {color:purple;
    text-decoration:underline;}
span.StyleCourrierlectronique17
    {font-family:Arial;
    color:windowtext;}
@page Section1
    {size:595.3pt 841.9pt;
    margin:70.85pt 70.85pt 70.85pt 70.85pt;}
div.Section1
    {page:Section1;}
-->
</style>

</head>

<body lang=FR link=blue vlink=purple>

<div class=Section1>

<p class=MsoNormal><font size=3 face="Courier New"><span lang=EN-GB
style=\'font-size:12.0pt;font-family:"Courier New"\'>Hello, <br>
</span></font></p>

</div>

</body>

</html>
',
        Result => "
\n\n\n\n
<div class=Section1>

<p class=MsoNormal><font size=3 face=\"Courier New\"><span lang=EN-GB
style='font-size:12.0pt;font-family:\"Courier New\"'>Hello, <br>
</span></font></p>

</div>
\n\n\n
",
        Name => 'DocumentStrip - Generator - Microsoft Word 10 (filtered)',
    },
    {
        Input => '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv="Content-Type content=text/html; charset=utf-8">
<META content="MSHTML 6.00.6002.18124" name=GENERATOR></HEAD>
<BODY style="FONT-SIZE: 12px; FONT-FAMILY: =
Geneva,Helvetica,Arial,sans-serif"=20
bgColor=#ffffff>
<DIV><FONT face=Arial size=2>xxx</FONT></DIV>
<DIV><FONT face=Arial size=2>
</FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>
</FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
',
        Result => "\n\n
<DIV><FONT face=Arial size=2>xxx</FONT></DIV>
<DIV><FONT face=Arial size=2>
</FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>
</FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
",

        Name => 'DocumentStrip - Generator - Microsoft Word 10 (filtered)',
    },
);

for my $Test (@Tests) {

    # these 2 lines are for Windows check-out
    $Test->{Input} =~ s{\r\n}{\n}smxg;
    $Test->{Result} =~ s{\r\n}{\n}smxg;
    my $Ascii = $HTMLUtilsObject->DocumentStrip(
        String => $Test->{Input},
    );
    $Self->Is(
        $Ascii,
        $Test->{Result},
        $Test->{Name},
    );
}

# DocumentCleanup tests
@Tests = (
    {
        Input  => '<p class="MsoNormal">Sehr geehrte Damen und Herren,<o:p></o:p></p>',
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>',
        Name   => 'DocumentCleanup - MSHTML'
    },
    {
        Input  => "<p\n class=\"MsoNormal\">Sehr geehrte Damen und Herren,<o:p></o:p></p>",
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>',
        Name   => 'DocumentCleanup - MSHTML'
    },
    {
        Input =>
            "<p\n class=\"MsoNormal\">Sehr geehrte Damen und Herren,<o:p></o:p></p>\n<p\nclass=\"MsoNormal\"><o:p>&nbsp;</o:p></p>",
        Result => "Sehr geehrte Damen und Herren,<o:p></o:p><br/>\n<o:p>&nbsp;</o:p><br/>",
        Name   => 'DocumentCleanup - MSHTML'
    },
    {
        Input  => "<p class='MsoNormal'>Sehr geehrte Damen und Herren,<o:p></o:p></p>",
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>',
        Name   => 'DocumentCleanup - MSHTML'
    },
    {
        Input  => "<p\n class='MsoNormal'>Sehr geehrte Damen und Herren,<o:p></o:p></p>",
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>',
        Name   => 'DocumentCleanup - MSHTML'
    },
    {
        Input =>
            "<p\n class='MsoNormal'>Sehr geehrte Damen und Herren,<o:p></o:p></p>\n<p\nclass='MsoNormal'><o:p>&nbsp;</o:p></p>",
        Result => "Sehr geehrte Damen und Herren,<o:p></o:p><br/>\n<o:p>&nbsp;</o:p><br/>",
        Name   => 'DocumentCleanup - MSHTML'
    },
    {
        Input =>
            "<p class=MsoNormal>Sehr geehrte Damen und Herren,<o:p></o:p></p>Some Other Text... ",
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>Some Other Text... ',
        Name   => 'DocumentCleanup - MSHTML'
    },
    {
        Input  => "<p\n class=MsoNormal>Sehr geehrte Damen und Herren,<o:p></o:p></p>",
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>',
        Name   => 'DocumentCleanup - MSHTML'
    },
    {
        Input =>
            "<p\n class=MsoNormal>Sehr geehrte Damen und Herren,<o:p></o:p></p>\n<p\nclass='MsoNormal'><o:p>&nbsp;</o:p></p>",
        Result => "Sehr geehrte Damen und Herren,<o:p></o:p><br/>\n<o:p>&nbsp;</o:p><br/>",
        Name   => 'DocumentCleanup - MSHTML'
    },
    {
        Input =>
            "<div\n class=MsoNormal>Sehr geehrte Damen und Herren,<o:div></o:div></div>\n<div\nclass='MsoNormal'><o:div>&nbsp;</o:div></div>",
        Result => "Sehr geehrte Damen und Herren,<o:div></o:div><br/>\n<o:div>&nbsp;</o:div><br/>",
        Name   => 'DocumentCleanup - MSHTML'
    },
    {
        Input =>
            "<div\r class=MsoNormal>Sehr geehrte Damen und Herren,<o:div></o:div></div>\n<div class='MsoNormal' type=\"cite\"><o:div>&nbsp;</o:div></div>",
        Result => "Sehr geehrte Damen und Herren,<o:div></o:div><br/>\n<o:div>&nbsp;</o:div><br/>",
        Name   => 'DocumentCleanup - MSHTML'
    },
    {
        Input  => 'Some Tex<b>t</b>',
        Result => 'Some Tex<b>t</b>',
        Name   => 'DocumentCleanup - blockquote'
    },
    {
        Input => '<blockquote>Some Tex<b>t</b></blockquote>',
        Result =>
            '<div  style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">Some Tex<b>t</b></div>',
        Name => 'DocumentCleanup - blockquote'
    },
    {
        Input => '<blockquote>Some Tex<b>t</b><blockquote>test</blockquote> </blockquote>',
        Result =>
            '<div  style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">Some Tex<b>t</b><div  style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">test</div> </div>',
        Name => 'DocumentCleanup - blockquote'
    },
);

for my $Test (@Tests) {
    my $HTML = $HTMLUtilsObject->DocumentCleanup(
        String => $Test->{Input},
    );
    $Self->Is(
        $HTML,
        $Test->{Result},
        $Test->{Name},
    );
}

# LinkQuote tests
@Tests = (
    {
        Input  => 'Some Text',
        Result => 'Some Text',
        Name   => 'LinkQuote - simple',
        Target => '',
    },
    {
        Input  => '<html><body>Some Text</body></html>',
        Result => '<html><body>Some Text</body></html>',
        Name   => 'LinkQuote - simple',
        Target => '',
    },
    {
        Input => 'Some Text with url http://example.com',
        Result =>
            'Some Text with url <a href="http://example.com" title="http://example.com">http://example.com</a>',
        Name   => 'LinkQuote - simple',
        Target => '',
    },
    {
        Input => 'Some Text with url http://xwww.example.com',
        Result =>
            'Some Text with url <a href="http://xwww.example.com" title="http://xwww.example.com">http://xwww.example.com</a>',
        Name   => 'LinkQuote - simple',
        Target => '',
    },
    {
        Input => 'Some Text with url http://example-domain.com',
        Result =>
            'Some Text with url <a href="http://example-domain.com" title="http://example-domain.com">http://example-domain.com</a>',
        Name   => 'LinkQuote - URL with dash',
        Target => '',
    },
    {
        Input  => 'Some Text with url <a href="http://example.com">http://example.com</a>',
        Result => 'Some Text with url <a href="http://example.com">http://example.com</a>',
        Name   => 'LinkQuote - simple',
        Target => '',
    },
    {
        Input  => "Some Text with url <a\nhref=\"http://example.com\">http://example.com</a>",
        Result => "Some Text with url <a\nhref=\"http://example.com\">http://example.com</a>",
        Name   => 'LinkQuote - simple',
        Target => '',
    },
    {
        Input  => "Some Text with url <a \nhref=\"http://example.com\">http://example.com</a>",
        Result => "Some Text with url <a \nhref=\"http://example.com\">http://example.com</a>",
        Name   => 'LinkQuote - simple',
        Target => '',
    },
    {
        Input =>
            'Some Text with url <a href="http://example.com">http://example.com</a> and not quoted url http://example.com/?q=123',
        Result =>
            'Some Text with url <a href="http://example.com">http://example.com</a> and not quoted url <a href="http://example.com/?q=123" title="http://example.com/?q=123">http://example.com/?q=123</a>',
        Name   => 'LinkQuote - simple',
        Target => '',
    },
    {
        Input =>
            'Some text with a complicated url http://example.com/otrs/index.pl?Action=AgentTicketZoom&TicketID=256868&ArticleID=696631&ZoomExpand=0#696631',
        Result =>
            'Some text with a complicated url <a href="http://example.com/otrs/index.pl?Action=AgentTicketZoom&TicketID=256868&ArticleID=696631&ZoomExpand=0#696631" title="http://example.com/otrs/index.pl?Action=AgentTicketZoom&TicketID=256868&ArticleID=696631&ZoomExpand=0#696631">http://example.com/otrs/index.pl?Action=AgentTicketZoom&TicketID=256868&ArticleID=696631&ZoomExpand=0#696631</a>',
        Name   => 'LinkQuote - complicated',
        Target => '',
    },
    {
        Input => 'Some Text with url <a href="http://example.com">http://example.com</a>',
        Result =>
            'Some Text with url <a href="http://example.com" target="_blank">http://example.com</a>',
        Name      => 'LinkQuote - simple',
        TargetAdd => 1,
        Target    => '_blank',
    },
    {
        Input =>
            'Some Text with url <a href="http://example.com">http://example.com</a> and not quoted url http://example.com/?q=123',
        Result =>
            'Some Text with url <a href="http://example.com" target="new_window">http://example.com</a> and not quoted url <a href="http://example.com/?q=123" target="new_window" title="http://example.com/?q=123">http://example.com/?q=123</a>',
        Name      => 'LinkQuote - simple',
        TargetAdd => 1,
        Target    => 'new_window',
    },
    {
        Input =>
            "<html xmlns:Z=\"urn:schemas-com:\" xmlns:st=\"&#1;\" xmlns=\"http://www.w3.org/TR/REC-html40\">Some Text with url <a \nhref=\"http://example.com\">http://example.com</a></html>",
        Result =>
            "<html xmlns:Z=\"urn:schemas-com:\" xmlns:st=\"&#1;\" xmlns=\"http://www.w3.org/TR/REC-html40\">Some Text with url <a \nhref=\"http://example.com\">http://example.com</a></html>",
        Name   => 'LinkQuote - simple',
        Target => '',
    },
    {
        Input => '<html>Some Text with url http://example.com</html>',
        Result =>
            '<html>Some Text with url <a href="http://example.com" title="http://example.com">http://example.com</a></html>',
        Name   => 'LinkQuote - simple',
        Target => '',
    },
    {
        Input => '<html>Some Text with url http://example.com </html>',
        Result =>
            '<html>Some Text with url <a href="http://example.com" title="http://example.com">http://example.com</a> </html>',
        Name   => 'LinkQuote - simple',
        Target => '',
    },
    {
        Input =>
            "<FONT face=Arial size=2><A title=http://www.example.com/\n href=\"http://www.example.com/\">http://www.example.com</A></FONT>",
        Result =>
            "<FONT face=Arial size=2><A title=http://www.example.com/\n href=\"http://www.example.com/\" target=\"_blank\">http://www.example.com</A></FONT>",
        Name      => 'LinkQuote - simple',
        Target    => '',
        TargetAdd => 1,
    },
    {
        Input =>
            'Some text with a full url http://example.com/otrs/index.pl?Action=AgentTicketZoom&TicketID=256868&ArticleID=696631&ZoomExpand=0#696631',
        Result =>
            'Some text with a full url <a href="http://example.com/otrs/index.pl?Action=AgentTicketZoom&TicketID=256868&ArticleID=696631&ZoomExpand=0#696631" title="http://example.com/otrs/index.pl?Action=AgentTicketZoom&TicketID=256868&ArticleID=696631&ZoomExpand=0#696631">http://example.com/otrs/index.pl?Action=AgentTicketZoom&TicketID=256868&ArticleID=696631&ZoomExpand=0#696631</a>',
        Name   => 'LinkQuote – full url',
        Target => '',
    },
    {
        Input => '<html>www.heise.de</html>',
        Result =>
            '<html><a href="http://www.heise.de" title="http://www.heise.de">www.heise.de</a></html>',
        Name   => 'LinkQuote with plain domains.',
        Target => '',
    },
    {
        Input  => '<html>xwww.heise.de</html>',
        Result => '<html>xwww.heise.de</html>',
        Name   => 'LinkQuote with plain domains.',
        Target => '',
    },
    {
        Input => '<html>ftp.heise.de</html>',
        Result =>
            '<html><a href="ftp://ftp.heise.de" title="ftp://ftp.heise.de">ftp.heise.de</a></html>',
        Name   => 'LinkQuote with plain domains.',
        Target => '',
    },
    {
        Input => '<html>www.heise.de/Suffix</html>',
        Result =>
            '<html><a href="http://www.heise.de/Suffix" title="http://www.heise.de/Suffix">www.heise.de/Suffix</a></html>',
        Name   => 'LinkQuote with plain domains.',
        Target => '',
    },
    {
        Input => '<html>www.heise-online.de/Suffix</html>',
        Result =>
            '<html><a href="http://www.heise-online.de/Suffix" title="http://www.heise-online.de/Suffix">www.heise-online.de/Suffix</a></html>',
        Name   => 'LinkQuote with plain domains with a dash.',
        Target => '',
    },
    {
        Input => '<html>ftp.heise.de/Suffix</html>',
        Result =>
            '<html><a href="ftp://ftp.heise.de/Suffix" title="ftp://ftp.heise.de/Suffix">ftp.heise.de/Suffix</a></html>',
        Name   => 'LinkQuote with plain domains.',
        Target => '',
    },
    {
        Input  => '<html>Prefixwww.heise.de</html>',
        Result => '<html>Prefixwww.heise.de</html>',
        Name   => 'LinkQuote with prefix plain domains.',
        Target => '',
    },
    {
        Input  => '<html>Prefixftp.heise.de</html>',
        Result => '<html>Prefixftp.heise.de</html>',
        Name   => 'LinkQuote with prefix plain domains.',
        Target => '',
    },
    {
        Input  => '<html>Prefixwww.heise.deSuffix</html>',
        Result => '<html>Prefixwww.heise.deSuffix</html>',
        Name   => 'LinkQuote with prefix and suffix plain domains.',
        Target => '',
    },
    {
        Input  => '<html>Prefixftp.heise.deSuffix</html>',
        Result => '<html>Prefixftp.heise.deSuffix</html>',
        Name   => 'LinkQuote with prefix and suffix plain domains.',
        Target => '',
    },
    {
        Input => '<html> www.heise.de </html>',
        Result =>
            '<html> <a href="http://www.heise.de" title="http://www.heise.de">www.heise.de</a> </html>',
        Name   => 'LinkQuote with plain domains.',
        Target => '',
    },
    {
        Input => '<html> ftp.heise.de </html>',
        Result =>
            '<html> <a href="ftp://ftp.heise.de" title="ftp://ftp.heise.de">ftp.heise.de</a> </html>',
        Name   => 'LinkQuote with plain domains.',
        Target => '',
    },
    {
        Input => '<html>&nbsp;www.heise.de&nbsp;</html>',
        Result =>
            '<html>&nbsp;<a href="http://www.heise.de" title="http://www.heise.de">www.heise.de</a>&nbsp;</html>',
        Name   => 'LinkQuote with plain domains.',
        Target => '',
    },
    {
        Input => '<html>&nbsp;ftp.heise.de&nbsp;</html>',
        Result =>
            '<html>&nbsp;<a href="ftp://ftp.heise.de" title="ftp://ftp.heise.de">ftp.heise.de</a>&nbsp;</html>',
        Name   => 'LinkQuote with plain domains.',
        Target => '',
    },
    {
        Input => '<html>&nbsp;www.heise.de&nbsp;www.heise.de</html>',
        Result =>
            '<html>&nbsp;<a href="http://www.heise.de" title="http://www.heise.de">www.heise.de</a>&nbsp;<a href="http://www.heise.de" title="http://www.heise.de">www.heise.de</a></html>',
        Name   => 'LinkQuote with plain domains.',
        Target => '',
    },
    {
        Input => '<html>&nbsp;ftp.heise.de&nbsp;ftp.heise.de</html>',
        Result =>
            '<html>&nbsp;<a href="ftp://ftp.heise.de" title="ftp://ftp.heise.de">ftp.heise.de</a>&nbsp;<a href="ftp://ftp.heise.de" title="ftp://ftp.heise.de">ftp.heise.de</a></html>',
        Name   => 'LinkQuote with plain domains.',
        Target => '',
    },
    {
        Input  => 'Some Text with url thisisnotanftp.link',
        Result => 'Some Text with url thisisnotanftp.link',
        Name   => 'LinkQuote - Not valid ftp url ',
        Target => '',
    },
    {
        Input  => 'Some Text with url thisisnotanwww.link',
        Result => 'Some Text with url thisisnotanwww.link',
        Name   => 'LinkQuote - Not valid www url ',
        Target => '',
    },
    {
        Input =>
            'Test www.example.org www.example3.org <sometag attribute="www.example4.org">www.example4.org</sometag> <sometag attribute="www5.example.org"> www.example5.org </sometag>',
        Result =>
            'Test <a href="http://www.example.org" target="_blue" title="http://www.example.org">www.example.org</a> <a href="http://www.example3.org" target="_blue" title="http://www.example3.org">www.example3.org</a> <sometag attribute="www.example4.org"><a href="http://www.example4.org" target="_blue" title="http://www.example4.org">www.example4.org</a></sometag> <sometag attribute="www5.example.org"> <a href="http://www.example5.org" target="_blue" title="http://www.example5.org">www.example5.org</a> </sometag>',
        Name   => 'LinkQuote - complex test with other tags ',
        Target => '_blue',
    },
    {
        Input =>
            'Test http://example.example.local/example/index.pl?Action=AgentTicketZoom&TicketID=2 link with &',
        Result =>
            'Test <a href="http://example.example.local/example/index.pl?Action=AgentTicketZoom&TicketID=2" title="http://example.example.local/example/index.pl?Action=AgentTicketZoom&TicketID=2">http://example.example.local/example/index.pl?Action=AgentTicketZoom&TicketID=2</a> link with &',
        Name   => 'LinkQuote - link params with &',
        Target => '',
    },
    {
        Input =>
            'Test http://example.example.local/example/index.pl?Action=AgentTicketZoom&amp;TicketID=2 link with &amp;',
        Result =>
            'Test <a href="http://example.example.local/example/index.pl?Action=AgentTicketZoom&amp;TicketID=2" title="http://example.example.local/example/index.pl?Action=AgentTicketZoom&amp;TicketID=2">http://example.example.local/example/index.pl?Action=AgentTicketZoom&amp;TicketID=2</a> link with &amp;',
        Name   => 'LinkQuote - link params with &amp;',
        Target => '',
    },
    {
        Input =>
            'Test http://example.example.local/example/index.pl?Action=AgentTicketZoom;TicketID=2 link with ;',
        Result =>
            'Test <a href="http://example.example.local/example/index.pl?Action=AgentTicketZoom;TicketID=2" title="http://example.example.local/example/index.pl?Action=AgentTicketZoom;TicketID=2">http://example.example.local/example/index.pl?Action=AgentTicketZoom;TicketID=2</a> link with ;',
        Name   => 'LinkQuote - link params with ;',
        Target => '',
    },
    {
        Input =>
            '<br />http://cuba/otrs/index.pl?Action=AgentTicketZoom&amp;TicketID=4348<br /><br />Your OTRS Notification Master',
        Result =>
            '<br /><a href="http://cuba/otrs/index.pl?Action=AgentTicketZoom&amp;TicketID=4348" title="http://cuba/otrs/index.pl?Action=AgentTicketZoom&amp;TicketID=4348">http://cuba/otrs/index.pl?Action=AgentTicketZoom&amp;TicketID=4348</a><br /><br />Your OTRS Notification Master',
        Name   => 'LinkQuote - just TLD given;',
        Target => '',
    },
);

for my $Test (@Tests) {
    my $HTML = $HTMLUtilsObject->LinkQuote(
        String    => $Test->{Input},
        Target    => $Test->{Target},
        TargetAdd => $Test->{TargetAdd},
    );
    $Self->Is(
        $HTML,
        $Test->{Result},
        $Test->{Name},
    );
}

#
# Special performance test for a large amount of data
#
my $XML = $Self->{MainObject}->FileRead(
    Location => $Self->{ConfigObject}->Get('Home')
        . '/scripts/test/sample/HTMLUtils/obstacles_upd2.xml',
);
$XML = ${$XML};

my $StartSeconds = $Self->{TimeObject}->SystemTime();

my $HTML = $HTMLUtilsObject->LinkQuote(
    String => \$XML,
);

my $EndSeconds = $Self->{TimeObject}->SystemTime();
$Self->True(
    ( $EndSeconds - $StartSeconds ) < 10,
    'LinkQuote - Performance on large data set',
);

# Safety tests
@Tests = (
    {
        Input  => 'Some Text',
        Result => {
            Output  => 'Some Text',
            Replace => 0,
        },
        Name => 'Safety - simple'
    },
    {
        Input  => '<b>Some Text</b>',
        Result => {
            Output  => '<b>Some Text</b>',
            Replace => 0,
        },
        Name => 'Safety - simple'
    },
    {
        Input  => '<a href="javascript:alert(1)">Some Text</a>',
        Result => {
            Output  => '<a href="">Some Text</a>',
            Replace => 1,
        },
        Name => 'Safety - simple'
    },
    {
        Input  => '<a href="http://example.com/" onclock="alert(1)">Some Text</a>',
        Result => {
            Output  => '<a href="http://example.com/">Some Text</a>',
            Replace => 1,
        },
        Name => 'Safety - simple'
    },
    {
        Input =>
            '<a href="http://example.com/" onclock="alert(1)">Some Text <img src="http://example.com/logo.png"/></a>',
        Result => {
            Output  => '<a href="http://example.com/">Some Text </a>',
            Replace => 1,
        },
        Name => 'Safety - simple'
    },
    {
        Input => '<script type="text/javascript" id="topsy_global_settings">
var topsy_style = "big";
</script><script type="text/javascript" id="topsy-js-elem" src="http://example.com/topsy.js?init=topsyWidgetCreator"></script>
<script type="text/javascript" src="/pub/js/podpress.js"></script>
',
        Result => {
            Output => '

',
            Replace => 1,
        },
        Name => 'Safety - script tag'
    },
    {
        Input => '<center>
<applet code="AEHousman.class" width="300" height="150">
Not all browsers can run applets.  If you see this, yours can not.
You should be able to continue reading these lessons, however.
</applet>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'Safety - applet tag'
    },
    {
        Input => '<center>
<object width="384" height="236" align="right" vspace="5" hspace="5"><param name="movie" value="http://www.youtube.com/v/l1JdGPVMYNk&hl=en_US&fs=1&hd=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/l1JdGPVMYNk&hl=en_US&fs=1&hd=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="384" height="236"></embed></object>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'Safety - object tag'
    },
    {
        Input => '<center>
\'\';!--"<XSS>=&{()}
</center>',
        Result => {
            Output => '<center>
\'\';!--"<XSS>=&{()}
</center>',
            Replace => 0,
        },
        Name => 'Safety - simple'
    },
    {
        Input => '<center>
<SCRIPT SRC=http://ha.ckers.org/xss.js></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'Safety - script/src tag'
    },
    {
        Input => '<center>
<SCRIPT SRC=http://ha.ckers.org/xss.js><!-- some comment --></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'Safety - script/src tag'
    },
    {
        Input => '<center>
<IMG SRC="javascript:alert(\'XSS\');">
</center>',
        Result => {
            Output => '<center>
<IMG SRC="">
</center>',
            Replace => 1,
        },
        Name => 'Safety - img tag'
    },
    {
        Input => '<center>
<IMG SRC=javascript:alert(\'XSS\');>
</center>',
        Result => {
            Output => '<center>
<IMG SRC="">
</center>',
            Replace => 1,
        },
        Name => 'Safety - img tag'
    },
    {
        Input => '<center>
<IMG SRC=JaVaScRiPt:alert(\'XSS\')>
</center>',
        Result => {
            Output => '<center>
<IMG SRC="">
</center>',
            Replace => 1,
        },
        Name => 'Safety - img tag'
    },
    {
        Input => '<center>
<IMG SRC=javascript:alert(&quot;XSS&quot;)>
</center>',
        Result => {
            Output => '<center>
<IMG SRC="">
</center>',
            Replace => 1,
        },
        Name => 'Safety - img tag'
    },
    {
        Input => '<center>
<IMG """><SCRIPT>alert("XSS")</SCRIPT>">
</center>',
        Result => {
            Output => '<center>
<IMG """>">
</center>',
            Replace => 1,
        },
        Name => 'Safety - script/img tag'
    },
    {
        Input => '<center>
<SCRIPT/XSS SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'Safety - script tag'
    },
    {
        Input => '<center>
<BODY onload!#$%&()*~+-_.,:;?@[/|\]^`="alert("XSS")">
</center>',
        Result => {
            Output => '<center>
<BODY>
</center>',
            Replace => 1,
        },
        Name => 'Safety - onload'
    },
    {
        Input => '<center>
<SCRIPT/SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'Safety - script tag'
    },
    {
        Input => '<center>
<<SCRIPT>alert("XSS");//<</SCRIPT>
</center>',
        Result => {
            Output => '<center>
<
</center>',
            Replace => 1,
        },
        Name => 'Safety - script tag'
    },
    {
        Input => '<center>
<SCRIPT SRC=http://ha.ckers.org/xss.js?<B>
</center>',
        Result => {
            Output => '<center>
/center>',
            Replace => 1,
        },
        Name => 'Safety - script tag'
    },
    {
        Input => '<center>
<SCRIPT SRC=//ha.ckers.org/.j>
</center>',
        Result => {
            Output => '<center>
/center>',
            Replace => 1,
        },
        Name => 'Safety - script tag'
    },
    {
        Input => '<center>
<iframe src=http://ha.ckers.org/scriptlet.html >
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'Safety - iframe'
    },
    {
        Input => '<center>
<BODY ONLOAD=alert(\'XSS\')>
</center>',
        Result => {
            Output => '<center>
<BODY>
</center>',
            Replace => 1,
        },
        Name => 'Safety - onload'
    },
    {
        Input => '<center>
<META HTTP-EQUIV="refresh" CONTENT="0;url=javascript:alert(\'XSS\');">
</center>',
        Result => {
            Output => '<center>
<META HTTP-EQUIV="refresh" CONTENT="0;url="">
</center>',
            Replace => 1,
        },
        Name => 'Safety - meta'
    },
    {
        Input => '<center>
<META HTTP-EQUIV="refresh" CONTENT="0; URL=http://;URL=javascript:alert(\'XSS\');">
</center>',
        Result => {
            Output => '<center>
<META HTTP-EQUIV="refresh" CONTENT="0; URL=http://;URL="">
</center>',
            Replace => 1,
        },
        Name => 'Safety - meta'
    },
    {
        Input => '<center>
<TABLE BACKGROUND="javascript:alert(\'XSS\')">
</center>',
        Result => {
            Output => '<center>
<TABLE BACKGROUND="">
</center>',
            Replace => 1,
        },
        Name => 'Safety - background'
    },
    {
        Input => '<center>
<SCRIPT a=">" SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'Safety - script'
    },
    {
        Input => '<center>
<SCRIPT =">" SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'Safety - script'
    },
    {
        Input => '<center>
<SCRIPT "a=\'>\'"
 SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'Safety - script'
    },
    {
        Input => '<center>
<SCRIPT>document.write("<SCRI");</SCRIPT>PT
 SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>
PT
 SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
            Replace => 1,
        },
        Name => 'Safety - script'
    },
    {
        Input => '<center>
<A
 HREF="javascript:document.location=\'http://www.example.com/\'">XSS</A>
</center>',
        Result => {
            Output => '<center>
<A
 HREF="">XSS</A>
</center>',
            Replace => 1,
        },
        Name => 'Safety - script'
    },
    {
        Input => '<center>
  <body style="background: #fff; color: #000;" onmouseover     ="var ga = document.createElement(\'script\'); ga.type = \'text/javascript\'; ga.src = (\'https:\' == document.location.protocol ? \'https://\' : \'http://\') + \'ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js\'; document.body.appendChild(ga); setTimeout(function() { jQuery(\'body\').append(jQuery(\'<div />\').attr(\'id\', \'hack-me\').css(\'display\', \'none\')); jQuery(\'#hack-me\').load(\'/otrs/index.pl?Action=AgentPreferences\', null, function() { jQuery.ajax({url: \'/otrs/index.pl\', type: \'POST\', data: ({Action: \'AgentPreferences\', ChallengeToken: jQuery(\'input[name=ChallengeToken]:first\', \'#hack-me\').val(), Group: \'Language\', \'Subaction\': \'Update\', UserLanguage: \'zh_CN\'})}); }); }, 500);">
</center>',
        Result => {
            Output => '<center>
  <body style="background: #fff; color: #000;" ga = document.createElement(\'script\'); ga.type = \'text/javascript\'; ga.src = (\'https:\' == document.location.protocol ? \'https://\' : \'http://\') + \'ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js\'; document.body.appendChild(ga); setTimeout(function() { jQuery(\'body\').append(jQuery(\'<div />\').attr(\'id\', \'hack-me\').css(\'display\', \'none\')); jQuery(\'#hack-me\').load(\'/otrs/index.pl?Action=AgentPreferences\', null, function() { jQuery.ajax({url: \'/otrs/index.pl\', type: \'POST\', data: ({Action: \'AgentPreferences\', ChallengeToken: jQuery(\'input[name=ChallengeToken]:first\', \'#hack-me\').val(), Group: \'Language\', \'Subaction\': \'Update\', UserLanguage: \'zh_CN\'})}); }); }, 500);">
</center>',
            Replace => 1,
        },
        Name => 'Safety - script'
    },
    {
        Input =>
            '<html><head><style type="text/css"> #some_css {color: #FF0000} </style><body>Important Text about "javascript"!<style type="text/css"> #some_more_css{ color: #00FF00 } </style> Some more text.</body></html>',
        Result => {
            Output =>
                '<html><head><style type="text/css"> #some_css {color: #FF0000} </style><body>Important Text about "javascript"!<style type="text/css"> #some_more_css{ color: #00FF00 } </style> Some more text.</body></html>',
            Replace => 0,
        },
        Name =>
            'Safety - Test for bug#7972 - Some mails may not present HTML part when using rich viewing.'
    },
    {
        Input =>
            '<html><head><style type="text/javascript"> alert("some evil stuff!);</style><body>Important Text about "javascript"!<style type="text/css"> #some_more_css{ color: #00FF00 } </style> Some more text.</body></html>',
        Result => {
            Output =>
                '<html><head><body>Important Text about "javascript"!<style type="text/css"> #some_more_css{ color: #00FF00 } </style> Some more text.</body></html>',
            Replace => 1,
        },
        Name =>
            'Safety - Additional test for bug#7972 - Some mails may not present HTML part when using rich viewing.'
    },
    {
        Name  => 'Safety - UTF7 tags',
        Input => <<EOF,
script:+ADw-script+AD4-alert(1);+ADw-/script+AD4-
applet:+ADw-applet+AD4-alert(1);+ADw-/applet+AD4-
embed:+ADw-embed src=test+AD4-
object:+ADw-object+AD4-alert(1);+ADw-/object+AD4-
EOF
        Result => {
            Output => <<EOF,
script:
applet:
embed:
object:
EOF
            Replace => 1,
        },
    },
    {
        Input => <<EOF,
<div style="width: expression(alert(\'XSS\');); height: 200px;" style="width: 400px">
<div style='width: expression(alert("XSS");); height: 200px;' style='width: 400px'>
EOF
        Result => {
            Output => <<EOF,
<div style="width: 400px">
<div style='width: 400px'>
EOF
            Replace => 1,
        },
        Name => 'Safety - Filter out MS CSS expressions'
    },
    {
        Input => <<EOF,
<div><XSS STYLE="xss:expression(alert('XSS'))"></div>
EOF
        Result => {
            Output => <<EOF,
<div><XSS></div>
EOF
            Replace => 1,
        },
        Name => 'Safety - Microsoft CSS expression on invalid tag'
    },
    {
        Input => <<EOF,
<div class="svg"><svg some-attribute evil="true"><someevilsvgcontent></svg></div>
EOF
        Result => {
            Output => <<EOF,
<div class="svg"></div>
EOF
            Replace => 1,
        },
        Name => 'Safety - Filter out SVG'
    },
    {
        Input => <<EOF,
<div><script ></script ><applet ></applet ></div >
EOF
        Result => {
            Output => <<EOF,
<div></div >
EOF
            Replace => 1,
        },
        Name => 'Safety - Closing tag with space'
    },
    {
        Input => <<EOF,
<style type="text/css">
div > span {
    width: 200px;
}
</style>
<style type="text/css">
div > span {
    width: expression(evilJS());
}
</style>
<style type="text/css">
div > span > div {
    width: 200px;
}
</style>
EOF
        Result => {
            Output => <<EOF,
<style type="text/css">
div > span {
    width: 200px;
}
</style>

<style type="text/css">
div > span > div {
    width: 200px;
}
</style>
EOF
            Replace => 1,
        },
        Name => 'Safety - Style tags with CSS expressions are filtered out'
    },
    {
        Input => <<EOF,
<s<script>...</script><script>...<cript type="text/javascript">
document.write("Hello World!");
</s<script>//<cript>
EOF
        Result => {
            Output => <<EOF,

EOF
            Replace => 1,
        },
        Name => 'Safety - Nested script tags'
    },
    {
        Input => <<EOF,
<img src="/img1.png"/>
<iframe src="  javascript:alert('XSS Exploit');"></iframe>
<img src="/img2.png"/>
EOF
        Result => {
            Output => <<EOF,
<img src="/img1.png"/>
<iframe src=""></iframe>
<img src="/img2.png"/>
EOF
            Replace => 1,
        },
        Name => 'Safety - javascript source with space'
    },
    {
        Input => <<EOF,
<img src="/img1.png"/>
<iframe src='  javascript:alert("XSS Exploit");'></iframe>
<img src="/img2.png"/>
EOF
        Result => {
            Output => <<EOF,
<img src="/img1.png"/>
<iframe src=""></iframe>
<img src="/img2.png"/>
EOF
            Replace => 1,
        },
        Name => 'Safety - javascript source with space'
    },
    {
        Input => <<EOF,
<img src="/img1.png"/>
<iframe src=javascript:alert('XSS_Exploit');></iframe>
<img src="/img2.png"/>
EOF
        Result => {
            Output => <<EOF,
<img src="/img1.png"/>
<iframe src=""></iframe>
<img src="/img2.png"/>
EOF
            Replace => 1,
        },
        Name => 'Safety - javascript source without delimiters'
    },
    {
        Input => <<EOF,
<img src="/img1.png"/>
<iframe src="" data-src="javascript:alert('XSS Exploit');"></iframe>
<img src="/img2.png"/>
EOF
        Result => {
            Output => <<EOF,
<img src="/img1.png"/>
<iframe src="" data-src="javascript:alert('XSS Exploit');"></iframe>
<img src="/img2.png"/>
EOF
            Replace => 0,
        },
        Name => 'Safety - javascript source in data tag, keep'
    },
);

for my $Test (@Tests) {
    my %Result = $HTMLUtilsObject->Safety(
        String       => $Test->{Input},
        NoApplet     => 1,
        NoObject     => 1,
        NoEmbed      => 1,
        NoSVG        => 1,
        NoIntSrcLoad => 0,
        NoExtSrcLoad => 1,
        NoJavaScript => 1,
    );
    if ( $Test->{Result}->{Replace} ) {
        $Self->True(
            $Result{Replace},
            "$Test->{Name} replaced",
        );
    }
    else {
        $Self->False(
            $Result{Replace},
            "$Test->{Name} not replaced",
        );
    }
    $Self->Is(
        $Result{String},
        $Test->{Result}->{Output},
        $Test->{Name},
    );
}

#
# EmbeddedImagesExtract()
#
my $InlineImage
    = '<img alt="text" src="data:image/gif;base64,R0lGODlhAQABAJH/AP///wAAAP///wAAACH/C0FET0JFOklSMS4wAt7tACH5BAEAAAIALAAAAAABAAEAAAICVAEAOw==" />';
@Tests = (
    {
        Name   => 'no image',
        Body   => '',
        Result => {
            Success     => 1,
            Body        => qr|^$|,
            Attachments => [],
            }
    },
    {
        Name   => 'no body',
        Body   => undef,
        Result => {
            Success => 0,
            }
    },
    {
        Name   => 'single image',
        Body   => "$InlineImage",
        Result => {
            Success     => 1,
            Body        => qr|^<img alt="text" src="cid:.*?" />$|,
            Attachments => [
                {
                    ContentType => qr|^image/gif;|,
                }
            ],
            }
    },
    {
        Name   => 'two images',
        Body   => "123 $InlineImage 456 $InlineImage 789",
        Result => {
            Success => 1,
            Body =>
                qr|^123 <img alt="text" src="cid:.*?" /> 456 <img alt="text" src="cid:.*?" /> 789$|,
            Attachments => [
                {
                    ContentType => qr|^image/gif;|,
                },
                {
                    ContentType => qr|^image/gif;|,
                }
            ],
            }
    },
    {
        Name   => 'two images, only one embedded',
        Body   => "123 $InlineImage 456 <img src=\"http://some.url/image.gif\" /> 789",
        Result => {
            Success => 1,
            Body =>
                qr|^123 <img alt="text" src="cid:.*?" /> 456 <img src=\"http://some.url/image.gif\" /> 789$|,
            Attachments => [
                {
                    ContentType => qr|^image/gif;|,
                },
            ],
            }
    },
    {
        Name => 'Win7 snipping tool',
        Body =>
            'Snipping Tool: <img alt="" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQIAAADJCAIAAABHdavEAAAgAElEQVR4nOx9d1gUWfZ27e63O0rnUJ2ISs5BRTFhzjo65uyYc4bOIFEUM9nsmHPOihkxkaGBJphQQM="> 456',
        Result => {
            Success => 1,
            Body =>
                qr|^Snipping Tool: <img alt="" src="cid:.*?"> 456$|,
            Attachments => [
                {
                    ContentType => qr|^image/png;|,
                },
            ],
            }
    },
);

TEST:
for my $Test (@Tests) {
    my $Body = $Test->{Body};
    my @Attachments;
    my $Success = $HTMLUtilsObject->EmbeddedImagesExtract(
        DocumentRef    => \$Body,
        AttachmentsRef => \@Attachments,
    );

    $Self->Is(
        $Success ? 1 : 0,
        $Test->{Result}->{Success},
        "$Test->{Name} success",
    );

    next TEST if !$Success;

    $Self->True(
        scalar $Body =~ ( $Test->{Result}->{Body} ),
        "$Test->{Name} body after image extraction (body: $Body, check: $Test->{Result}->{Body})",
    );

    $Self->Is(
        scalar @Attachments,
        scalar @{ $Test->{Result}->{Attachments} },
        "$Test->{Name} number of attachments",
    );

    my $Index = 0;
    for my $Attachment (@Attachments) {

        $Self->True(
            scalar $Attachment->{ContentType}
                =~ ( $Test->{Result}->{Attachments}->[$Index]->{ContentType} ),
            "$Test->{Name} content type of attachment $Index (content type: $Attachment->{ContentType}, check: $Test->{Result}->{Attachments}->[$Index]->{ContentType})",
        );
        $Self->True(
            scalar $Attachment->{Content},
            "$Test->{Name} content of attachment $Index is not empty",
        );

        $Index++;
    }
}

1;
