# --
# HTMLUtils.t - HTMLUtils tests
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: HTMLUtils.t,v 1.13 2009-09-08 16:28:11 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use Kernel::System::HTMLUtils;

$Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new( %{$Self} );

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
 > \n > Buenas noches,\n > \n",
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
);

for my $Test (@Tests) {
    my $Ascii = $Self->{HTMLUtilsObject}->ToAscii(
        String => $Test->{Input},
    );
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
            '<html><head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Some Text</body></html>',
        Name => 'DocumentComplete - simple'
    },
    {
        Input  => '<html><body>Some Text</body></html>',
        Result => '<html><body>Some Text</body></html>',
        Name   => 'DocumentComplete - simple'
    },
);

for my $Test (@Tests) {
    my $Ascii = $Self->{HTMLUtilsObject}->DocumentComplete(
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
        Name => 'DocumentStrip - Generator - Microsoft Word 10 (filtered)'
    },
);

for my $Test (@Tests) {
    my $Ascii = $Self->{HTMLUtilsObject}->DocumentStrip(
        String => $Test->{Input},
    );
    $Self->Is(
        $Ascii,
        $Test->{Result},
        $Test->{Name},
    );
}

# DocumentStyleCleanup tests
@Tests = (
    {
        Input  => '<p class="MsoNormal">Sehr geehrte Damen und Herren,<o:p></o:p></p>',
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>',
        Name   => 'DocumentStyleCleanup - MSHTML'
    },
    {
        Input  => "<p\n class=\"MsoNormal\">Sehr geehrte Damen und Herren,<o:p></o:p></p>",
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>',
        Name   => 'DocumentStyleCleanup - MSHTML'
    },
    {
        Input =>
            "<p\n class=\"MsoNormal\">Sehr geehrte Damen und Herren,<o:p></o:p></p>\n<p\nclass=\"MsoNormal\"><o:p>&nbsp;</o:p></p>",
        Result => "Sehr geehrte Damen und Herren,<o:p></o:p><br/>\n<o:p>&nbsp;</o:p><br/>",
        Name   => 'DocumentStyleCleanup - MSHTML'
    },
    {
        Input  => "<p class='MsoNormal'>Sehr geehrte Damen und Herren,<o:p></o:p></p>",
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>',
        Name   => 'DocumentStyleCleanup - MSHTML'
    },
    {
        Input  => "<p\n class='MsoNormal'>Sehr geehrte Damen und Herren,<o:p></o:p></p>",
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>',
        Name   => 'DocumentStyleCleanup - MSHTML'
    },
    {
        Input =>
            "<p\n class='MsoNormal'>Sehr geehrte Damen und Herren,<o:p></o:p></p>\n<p\nclass='MsoNormal'><o:p>&nbsp;</o:p></p>",
        Result => "Sehr geehrte Damen und Herren,<o:p></o:p><br/>\n<o:p>&nbsp;</o:p><br/>",
        Name   => 'DocumentStyleCleanup - MSHTML'
    },
    {
        Input =>
            "<p class=MsoNormal>Sehr geehrte Damen und Herren,<o:p></o:p></p>Some Other Text... ",
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>Some Other Text... ',
        Name   => 'DocumentStyleCleanup - MSHTML'
    },
    {
        Input  => "<p\n class=MsoNormal>Sehr geehrte Damen und Herren,<o:p></o:p></p>",
        Result => 'Sehr geehrte Damen und Herren,<o:p></o:p><br/>',
        Name   => 'DocumentStyleCleanup - MSHTML'
    },
    {
        Input =>
            "<p\n class=MsoNormal>Sehr geehrte Damen und Herren,<o:p></o:p></p>\n<p\nclass='MsoNormal'><o:p>&nbsp;</o:p></p>",
        Result => "Sehr geehrte Damen und Herren,<o:p></o:p><br/>\n<o:p>&nbsp;</o:p><br/>",
        Name   => 'DocumentStyleCleanup - MSHTML'
    },
    {
        Input =>
            "<div\n class=MsoNormal>Sehr geehrte Damen und Herren,<o:div></o:div></div>\n<div\nclass='MsoNormal'><o:div>&nbsp;</o:div></div>",
        Result => "Sehr geehrte Damen und Herren,<o:div></o:div><br/>\n<o:div>&nbsp;</o:div><br/>",
        Name   => 'DocumentStyleCleanup - MSHTML'
    },
    {
        Input =>
            "<div\r class=MsoNormal>Sehr geehrte Damen und Herren,<o:div></o:div></div>\n<div class='MsoNormal' type=\"cite\"><o:div>&nbsp;</o:div></div>",
        Result => "Sehr geehrte Damen und Herren,<o:div></o:div><br/>\n<o:div>&nbsp;</o:div><br/>",
        Name   => 'DocumentStyleCleanup - MSHTML'
    },
    {
        Input  => 'Some Tex<b>t</b>',
        Result => 'Some Tex<b>t</b>',
        Name   => 'DocumentStyleCleanup - blockquote'
    },
    {
        Input => '<blockquote>Some Tex<b>t</b></blockquote>',
        Result =>
            '<div  style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">Some Tex<b>t</b></div>',
        Name => 'DocumentStyleCleanup - blockquote'
    },
    {
        Input => '<blockquote>Some Tex<b>t</b><blockquote>test</blockquote> </blockquote>',
        Result =>
            '<div  style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">Some Tex<b>t</b><div  style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">test</div> </div>',
        Name => 'DocumentStyleCleanup - blockquote'
    },
);

for my $Test (@Tests) {
    my $HTML = $Self->{HTMLUtilsObject}->DocumentStyleCleanup(
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
);

for my $Test (@Tests) {
    my $HTML = $Self->{HTMLUtilsObject}->LinkQuote(
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

1;
