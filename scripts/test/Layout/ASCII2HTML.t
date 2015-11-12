# --
# scripts/test/Layout/ASCII2HTML.t - layout testscript
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

use Kernel::Output::HTML::Layout;

# get needed objects
my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

my $LayoutObject = Kernel::Output::HTML::Layout->new(
    UserChallengeToken => 'TestToken',
    UserID             => 1,
    Lang               => 'de',
    SessionID          => 123,
);

# check the function Ascii2Html
my $TestString = << 'END_STRING';
Created:
02/19/2008 12:17:03
http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone

asdfasfd  sdfas dfsdf
http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone
asdfasf

asdfasf asasdfa fasdf
http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone
asdfasdf

http://localhost/otrs-22-utf8/index.pl?Action=AgentTicke()tPhone

asdfasfd  sdfas dfsdf
http://localhost/otrs-22-utf8/index.pl?Action=AgentTi()cketPhone
asdfasf

asdfasf asasdfa fasdf
http://localhost/otrs-22-utf8/index.pl?Action=AgentTick()etPhone
asdfasdf

ak@example.com
http://www.example.net
http://bugs.example.org/show_bug.cgi?id=2450
<http://bugs.example.org/show_bug.cgi?id=2450>
<http://bugs.example.org/s()how_bug.cgi?id=2450>

http://bugs.example.org/show_bug.cgi?id=2450as
<http://bugs.example.org/show_bug.cgi?id=2450>asdf
<http://bugs.example.org/s()how_bug.cgi?id=2450> as

wwww.example.net

ftp.example.org

https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/home/tr/CVSUpdate().pl

lkj https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/home/tr/CVSUpdate().pl lk
lkj https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/home/tr/CVSUpdate().pl
lk
END_STRING

my $NeededResult = <<'END_RESULT';
Created:<br/>
02/19/2008 12:17:03<br/>
<a href="http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone" target="_blank" title="http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone">http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone</a><br/>
<br/>
asdfasfd&nbsp;&nbsp;sdfas dfsdf<br/>
<a href="http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone" target="_blank" title="http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone">http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone</a><br/>
asdfasf<br/>
<br/>
asdfasf asasdfa fasdf<br/>
<a href="http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone" target="_blank" title="http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone">http://localhost/otrs-22-utf8/index.pl?Action=AgentTicketPhone</a><br/>
asdfasdf<br/>
<br/>
<a href="http://localhost/otrs-22-utf8/index.pl?Action=AgentTicke()tPhone" target="_blank" title="http://localhost/otrs-22-utf8/index.pl?Action=AgentTicke()tPhone">http://localhost/otrs-22-utf8/index.pl?Action=AgentTicke()tPhone</a><br/>
<br/>
asdfasfd&nbsp;&nbsp;sdfas dfsdf<br/>
<a href="http://localhost/otrs-22-utf8/index.pl?Action=AgentTi()cketPhone" target="_blank" title="http://localhost/otrs-22-utf8/index.pl?Action=AgentTi()cketPhone">http://localhost/otrs-22-utf8/index.pl?Action=AgentTi()cketPhone</a><br/>
asdfasf<br/>
<br/>
asdfasf asasdfa fasdf<br/>
<a href="http://localhost/otrs-22-utf8/index.pl?Action=AgentTick()etPhone" target="_blank" title="http://localhost/otrs-22-utf8/index.pl?Action=AgentTick()etPhone">http://localhost/otrs-22-utf8/index.pl?Action=AgentTick()etPhone</a><br/>
asdfasdf<br/>
<br/>
ak@example.com<br/>
<a href="http://www.example.net" target="_blank" title="http://www.example.net">http://www.example.net</a><br/>
<a href="http://bugs.example.org/show_bug.cgi?id=2450" target="_blank" title="http://bugs.example.org/show_bug.cgi?id=2450">http://bugs.example.org/show_bug.cgi?id=2450</a><br/>
&lt;<a href="http://bugs.example.org/show_bug.cgi?id=2450" target="_blank" title="http://bugs.example.org/show_bug.cgi?id=2450">http://bugs.example.org/show_bug.cgi?id=2450</a>&gt;<br/>
&lt;<a href="http://bugs.example.org/s()how_bug.cgi?id=2450" target="_blank" title="http://bugs.example.org/s()how_bug.cgi?id=2450">http://bugs.example.org/s()how_bug.cgi?id=2450</a>&gt;<br/>
<br/>
<a href="http://bugs.example.org/show_bug.cgi?id=2450as" target="_blank" title="http://bugs.example.org/show_bug.cgi?id=2450as">http://bugs.example.org/show_bug.cgi?id=2450as</a><br/>
&lt;<a href="http://bugs.example.org/show_bug.cgi?id=2450" target="_blank" title="http://bugs.example.org/show_bug.cgi?id=2450">http://bugs.example.org/show_bug.cgi?id=2450</a>&gt;asdf<br/>
&lt;<a href="http://bugs.example.org/s()how_bug.cgi?id=2450" target="_blank" title="http://bugs.example.org/s()how_bug.cgi?id=2450">http://bugs.example.org/s()how_bug.cgi?id=2450</a>&gt; as<br/>
<br/>
<a href="http://wwww.example.net" target="_blank" title="http://wwww.example.net">http://wwww.example.net</a><br/>
<br/>
<a href="ftp://ftp.example.org" target="_blank" title="ftp://ftp.example.org">ftp://ftp.example.org</a><br/>
<br/>
<a href="https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/home/tr/CVSUpdate().pl" target="_blank" title="https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/home/tr/CVSUpdate().pl">https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/[..]</a><br/>
<br/>
lkj <a href="https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/home/tr/CVSUpdate().pl" target="_blank" title="https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/home/tr/CVSUpdate().pl">https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/[..]</a> lk<br/>
lkj <a href="https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/home/tr/CVSUpdate().pl" target="_blank" title="https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/home/tr/CVSUpdate().pl">https://portal.example.com/otrs/index.pl?Action=AgentFileManager&Location=/[..]</a><br/>
lk<br/>
END_RESULT

# html quoting
my $ConvertedString = $LayoutObject->Ascii2Html(
    NewLine        => 90,
    Text           => $TestString,
    VMax           => 6000,
    HTMLResultMode => 1,
    LinkFeature    => 1,
);

$Self->Is(
    $ConvertedString,
    $NeededResult,
    'Ascii2Html() - Check if the link feature works correct',
);

# html quoting 2
my @Tests = (
    {
        Name   => 'Ascii2Html() - #1',
        String => 'http://example.com/',
        Result =>
            '<a href="http://example.com/" target="_blank" title="http://example.com/">http://example.com/</a>',
    },
    {
        Name   => 'Ascii2Html() - #2',
        String => ' http://example.com/',
        Result =>
            ' <a href="http://example.com/" target="_blank" title="http://example.com/">http://example.com/</a>',
    },
    {
        Name   => 'Ascii2Html() - #3',
        String => ' http://example.com/ ',
        Result =>
            ' <a href="http://example.com/" target="_blank" title="http://example.com/">http://example.com/</a> ',
    },
    {
        Name   => 'Ascii2Html() - #4',
        String => ' http://example.com/. ',
        Result =>
            ' <a href="http://example.com/" target="_blank" title="http://example.com/">http://example.com/</a>. ',
    },
    {
        Name   => 'Ascii2Html() - #5',
        String => ' http://example.com. ',
        Result =>
            ' <a href="http://example.com" target="_blank" title="http://example.com">http://example.com</a>. ',
    },
    {
        Name   => 'Ascii2Html() - #6',
        String => ' www.example.com ',
        Result =>
            ' <a href="http://www.example.com" target="_blank" title="http://www.example.com">http://www.example.com</a> ',
    },
    {
        Name   => 'Ascii2Html() - #7',
        String => ' ftp://ftp.example.com. ',
        Result =>
            ' <a href="ftp://ftp.example.com" target="_blank" title="ftp://ftp.example.com">ftp://ftp.example.com</a>. ',
    },
    {
        Name   => 'Ascii2Html() - #8',
        String => ' HTTP://www.example.com, ',
        Result =>
            ' <a href="HTTP://www.example.com" target="_blank" title="HTTP://www.example.com">HTTP://www.example.com</a>, ',
    },
    {
        Name   => 'Ascii2Html() - #9',
        String => ' http://example.com?some_long_url=yes&some_what_else=index.html ',
        Result =>
            ' <a href="http://example.com?some_long_url=yes&some_what_else=index.html" target="_blank" title="http://example.com?some_long_url=yes&some_what_else=index.html">http://example.com?some_long_url=yes&some_what_else=index.html</a> ',
    },
    {
        Name   => 'Ascii2Html() - #10',
        String => ' http://example.com?some_long_url=yes&some_what_else=index+test.html ',
        Result =>
            ' <a href="http://example.com?some_long_url=yes&some_what_else=index+test.html" target="_blank" title="http://example.com?some_long_url=yes&some_what_else=index+test.html">http://example.com?some_long_url=yes&some_what_else=index+test.html</a> ',
    },
    {
        Name => 'Ascii2Html() - #11',
        String =>
            ' http://example.com?some_long_url=yes&some_what_else=0123456789.0123456789.0123456789.0123456789.0123456789.0123456789.0123456789.0123456789.index.html ',
        Result =>
            ' <a href="http://example.com?some_long_url=yes&some_what_else=0123456789.0123456789.0123456789.0123456789.0123456789.0123456789.0123456789.0123456789.index.html" target="_blank" title="http://example.com?some_long_url=yes&some_what_else=0123456789.0123456789.0123456789.0123456789.0123456789.0123456789.0123456789.0123456789.index.html">http://example.com?some_long_url=yes&some_what_else=0123456789.0123456789.0[..]</a> ',
    },
    {
        Name   => 'Ascii2Html() - #12',
        String => ' http://example.com/ http://www.example.com/ ',
        Result =>
            ' <a href="http://example.com/" target="_blank" title="http://example.com/">http://example.com/</a> <a href="http://www.example.com/" target="_blank" title="http://www.example.com/">http://www.example.com/</a> ',
    },
    {
        Name   => 'Ascii2Html() - #13',
        String => 'Please visit this url http://example.com.',
        Result =>
            'Please visit this url <a href="http://example.com" target="_blank" title="http://example.com">http://example.com</a>.',
    },
    {
        Name   => 'Ascii2Html() - #14',
        String => 'Please visit this url http://example.com, and follow the second link.',
        Result =>
            'Please visit this url <a href="http://example.com" target="_blank" title="http://example.com">http://example.com</a>, and follow the second link.',
    },
    {
        Name   => 'Ascii2Html() - #15',
        String => '&',
        Result => '&amp;',
    },
    {
        Name   => 'Ascii2Html() - #16',
        String => '&&',
        Result => '&amp;&amp;',
    },
    {
        Name   => 'Ascii2Html() - #17',
        String => ' ',
        Result => ' ',
    },
    {
        Name   => 'Ascii2Html() - #18',
        String => '  ',
        Result => '&nbsp;&nbsp;',
    },
    {
        Name   => 'Ascii2Html() - #19',
        String => '<',
        Result => '&lt;',
    },
    {
        Name   => 'Ascii2Html() - #20',
        String => '<<',
        Result => '&lt;&lt;',
    },
    {
        Name   => 'Ascii2Html() - #21',
        String => '>',
        Result => '&gt;',
    },
    {
        Name   => 'Ascii2Html() - #22',
        String => '>>',
        Result => '&gt;&gt;',
    },
    {
        Name   => 'Ascii2Html() - #23',
        String => '"',
        Result => '&quot;',
    },
    {
        Name   => 'Ascii2Html() - #24',
        String => '""',
        Result => '&quot;&quot;',
    },
    {
        Name   => 'Ascii2Html() - #25',
        String => "\t",
        Result => ' ',
    },
    {
        Name => 'Ascii2Html() - #26',
        String =>
            '<script language="JavaScript" type="text/javascript"> alert("Not safe!"); </script>',
        Result =>
            '&lt;script language=&quot;JavaScript&quot; type=&quot;text/javascript&quot;&gt; alert(&quot;Not safe!&quot;); &lt;/script&gt;',
    },
    {
        Name   => 'Ascii2Html() - #27 http.-check',
        String => "http.\nsome text http.\nsome text http. some text\n",
        Result => "http.<br/>\nsome text http.<br/>\nsome text http. some text<br/>\n",
    },
    {
        Name   => 'Ascii2Html() - #27 ftp-check',
        String => "ftp.example.com",
        Result =>
            "<a href=\"ftp://ftp.example.com\" target=\"_blank\" title=\"ftp://ftp.example.com\">ftp://ftp.example.com</a>",
    },
);

for my $Test (@Tests) {
    my $HTML = $LayoutObject->Ascii2Html(
        Text           => $Test->{String},
        LinkFeature    => 1,
        HTMLResultMode => 1,
    );
    $Self->Is(
        $HTML || '',
        $Test->{Result},
        $Test->{Name},
    );
}

# html quoting 3
@Tests = (
    {
        Name   => 'Ascii2Html() - Max check #1',
        String => 'some Text',
        Result => '[...]',
        Max    => 5,
    },
    {
        Name   => 'Ascii2Html() - Max check #2',
        String => 'some Text',
        Result => 'som[...]',
        Max    => 8,
    },
    {
        Name   => 'Ascii2Html() - Max check #3',
        String => 'some Text',
        Result => 'some Text',
        Max    => 9,
    },
    {
        Name   => 'Ascii2Html() - Max check #3',
        String => 'søme Text',
        Result => 'søm[...]',
        Max    => 8,
    },
    {
        Name   => 'Ascii2Html()',
        String => '',
        Result => '',
    },
    {
        Name   => 'Ascii2Html()',
        String => undef,
        Result => '',
    },
);

for my $Test (@Tests) {

    my $HTML = $LayoutObject->Ascii2Html(
        Text => $Test->{String},
        Max  => $Test->{Max},
    );

    $Self->Is(
        $HTML || '',
        $Test->{Result},
        $Test->{Name},
    );
}

1;
