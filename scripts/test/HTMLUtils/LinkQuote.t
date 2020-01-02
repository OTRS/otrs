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

# get needed objects
my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

# LinkQuote tests
my @Tests = (
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
        Input => 'Some Text with nested url http://www.example.com/redirect?location=www.example2.com',
        Result =>
            'Some Text with nested url <a href="http://www.example.com/redirect?location=www.example2.com" title="http://www.example.com/redirect?location=www.example2.com">http://www.example.com/redirect?location=www.example2.com</a>',
        Name   => 'LinkQuote - nested URL bug#8761',
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
        Input =>
            'Some text with a complicated url http://example.com/index.pl?key=v_al-ue#hash-te_st',
        Result =>
            'Some text with a complicated url <a href="http://example.com/index.pl?key=v_al-ue#hash-te_st" title="http://example.com/index.pl?key=v_al-ue#hash-te_st">http://example.com/index.pl?key=v_al-ue#hash-te_st</a>',
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
    {
        Input =>
            '<br />http://www.server.nl:80/%7Eguido/Python.html<br />',
        Result =>
            '<br /><a href="http://www.server.nl:80/%7Eguido/Python.html" title="http://www.server.nl:80/%7Eguido/Python.html">http://www.server.nl:80/%7Eguido/Python.html</a><br />',
        Name   => 'LinkQuote - address with port given;',
        Target => '',
    },
    {
        Input =>
            '<br />https://aa.bb.com/wiki/Obs%C5%82uga_ABC#Sekcja<br />',
        Result =>
            '<br /><a href="https://aa.bb.com/wiki/Obs%C5%82uga_ABC#Sekcja" title="https://aa.bb.com/wiki/Obs%C5%82uga_ABC#Sekcja">https://aa.bb.com/wiki/Obs%C5%82uga_ABC#Sekcja</a><br />',
        Name   => 'LinkQuote - address with URL encodings and hash; ',
        Target => '',
    },
    {
        Input =>
            '<br />http://msdn.microsoft.com/en-us/library/windows/hardware/ff557211%28v=vs.85%29.aspx<br />',
        Result =>
            '<br /><a href="http://msdn.microsoft.com/en-us/library/windows/hardware/ff557211%28v=vs.85%29.aspx" title="http://msdn.microsoft.com/en-us/library/windows/hardware/ff557211%28v=vs.85%29.aspx">http://msdn.microsoft.com/en-us/library/windows/hardware/ff557211%28v=vs.85%29.aspx</a><br />',
        Name   => 'LinkQuote - address with =; ',
        Target => '',
    },
    {
        Input =>
            '<img title="00073905.TMH_plausible-921733-edited.jpg" alt="00073905.TMH_plausible-921733-edited.jpg" src="http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=96" data-constrained="true" style="vertical-align:bottom; -ms-interpolation-mode:bicubic; width:96px; max-width:96px; margin:0px 0px 10px 10px; float:right" align="right" width="96" srcset="http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=48 48w, http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=96 96w, http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=144 144w, http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=192 192w, http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=240 240w, http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=288 288w" sizes="(max-width: 96px) 100vw, 96px">',
        Result =>
            '<img title="00073905.TMH_plausible-921733-edited.jpg" alt="00073905.TMH_plausible-921733-edited.jpg" src="http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=96" data-constrained="true" style="vertical-align:bottom; -ms-interpolation-mode:bicubic; width:96px; max-width:96px; margin:0px 0px 10px 10px; float:right" align="right" width="96" srcset="http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=48 48w, http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=96 96w, http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=144 144w, http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=192 192w, http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=240 240w, http://info.isightpartners.com/hs-fs/hubfs/00073905.TMH_plausible-921733-edited.jpg?t=1467377990501&width=288 288w" sizes="(max-width: 96px) 100vw, 96px">',
        Name   => 'Complex tag with nested URLs',
        Target => '',
    },
    {
        Input =>
            '<img src="http://www.test.com" data-link="http://www.test.com, http://www.test2.com">Test</img>',
        Result =>
            '<img src="http://www.test.com" data-link="http://www.test.com, http://www.test2.com">Test</img>',
        Name   => 'Complex tag with nested URLs',
        Target => '',
    },
    {
        Input => 'Following unquoted link looks strangely like an ftp URL: www.ftp.de',
        Result =>
            'Following unquoted link looks strangely like an ftp URL: <a href="http://www.ftp.de" title="http://www.ftp.de">www.ftp.de</a>',
        Name   => 'Text with HTTP url (bug#12472)',
        Target => '',
    },
    {
        Input => 'Following unquoted link is an actual ftp URL: ftp.my.de',
        Result =>
            'Following unquoted link is an actual ftp URL: <a href="ftp://ftp.my.de" title="ftp://ftp.my.de">ftp.my.de</a>',
        Name   => 'Text with FTP url (bug#12472)',
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
my $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Location => $Kernel::OM->Get('Kernel::Config')->Get('Home')
        . '/scripts/test/sample/HTMLUtils/obstacles_upd2.xml',
);
$XML = ${$XML};

my $StartSeconds = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

my $HTML = $HTMLUtilsObject->LinkQuote(
    String => $XML,
);

my $EndSeconds = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
$Self->True(
    ( $EndSeconds - $StartSeconds ) < 10,
    'LinkQuote - Performance on large data set',
);

1;
