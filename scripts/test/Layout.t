# --
# scripts/test/Layout.t - layout module testscript
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: Layout.t,v 1.56 2011-12-02 13:56:03 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self %Param));

use Kernel::System::AuthSession;
use Kernel::System::Web::Request;
use Kernel::System::Group;
use Kernel::System::Ticket;
use Kernel::System::User;
use Kernel::Output::HTML::Layout;

# create local objects
my $SessionObject = Kernel::System::AuthSession->new( %{$Self} );
my $GroupObject   = Kernel::System::Group->new( %{$Self} );
my $TicketObject  = Kernel::System::Ticket->new( %{$Self} );
my $UserObject    = Kernel::System::User->new( %{$Self} );
my $ParamObject   = Kernel::System::Web::Request->new(
    %{$Self},
    WebRequest => $Param{WebRequest} || 0,
);
my $LayoutObject = Kernel::Output::HTML::Layout->new(
    ConfigObject       => $Self->{ConfigObject},
    LogObject          => $Self->{LogObject},
    TimeObject         => $Self->{TimeObject},
    MainObject         => $Self->{MainObject},
    EncodeObject       => $Self->{EncodeObject},
    SessionObject      => $SessionObject,
    DBObject           => $Self->{DBObject},
    ParamObject        => $ParamObject,
    TicketObject       => $TicketObject,
    UserObject         => $UserObject,
    GroupObject        => $GroupObject,
    UserChallengeToken => 'TestToken',
    UserID             => 1,
    Lang               => 'de',
    SessionID          => 123,
);

# here everyone can insert example data for the tests
my %Data = (
    Created                   => '2007-11-30 08:58:54',
    CreateTime                => '2007-11-30 08:58:54',
    ChangeTime                => '2007-11-30 08:58:54',
    TicketFreeTime            => '2007-11-30 08:58:54',
    TicketFreeTime1           => '2007-11-30 08:58:54',
    TicketFreeTime2           => '2007-11-30 08:58:54',
    TimeStartMax              => '2007-11-30 08:58:54',
    TimeStopMax               => '2007-11-30 08:58:54',
    UpdateTimeDestinationDate => '2007-11-30 08:58:54',
    Body                      => "What do you\n mean with body?"
);

my $StartTime = time();

# --------------------------------------------------------------------#
# Search for $Data{""} etc. because this is the most dangerous bug if you
# modify the Output funciton
# --------------------------------------------------------------------#

# check the header
my $Header = $LayoutObject->Header( Title => 'HeaderTest' );
my $HeaderFlag = 1;
if (
    $Header =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) }msx
    || $Header =~ m{ <dtl \W if }msx
    )
{
    $HeaderFlag = 0;

}
$Self->True(
    $HeaderFlag,
    'Header() check the output for not replaced variables',
);

# check the navigation bar
my $NavigationBar  = $LayoutObject->NavigationBar();
my $NavigationFlag = 1;
if (
    $NavigationBar =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) }msx
    || $NavigationBar =~ m{ <dtl \W if }msx
    )
{
    $NavigationFlag = 0;
}
$Self->True(
    $NavigationFlag,
    'NavigationBar() check the output for not replaced variables',
);

# check the footer
my $Footer     = $LayoutObject->Footer();
my $FooterFlag = 1;
if (
    $Footer =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) }msx
    || $Footer =~ m{ <dtl \W if }msx
    )
{
    $FooterFlag = 0;
}
$Self->True(
    $FooterFlag,
    'Footer() check the output for not replaced variables',
);

# check all dtl files
my $HomeDirectory = $Self->{ConfigObject}->Get('Home');
my $DTLDirectory  = $HomeDirectory . '/Kernel/Output/HTML/Standard/';
my $DIR;
if ( !opendir $DIR, $DTLDirectory ) {
    print "Can not open Directory: $DTLDirectory";
    return;
}

my @Files = ();
while ( defined( my $Filename = readdir $DIR ) ) {
    if ( $Filename =~ m{ \. dtl $}xms ) {
        push( @Files, "$DTLDirectory/$Filename" )
    }
}
closedir $DIR;

for my $File (@Files) {
    if ( $File =~ m{ / ( [^/]+ ) \. dtl}smx ) {
        my $DTLName = $1;

        # find all blocks auf the dtl files
        my $ContentARRAYRef = $Self->{MainObject}->FileRead(
            Location => $File,
            Result   => 'ARRAY'
        );
        my @Blocks             = ();
        my %DoubleBlockChecker = ();
        for my $Line ( @{$ContentARRAYRef} ) {
            if ( $Line =~ m{ <!-- \s{0,1} dtl:block: (.+?) \s{0,1} --> }smx ) {
                if ( !$DoubleBlockChecker{$1} ) {
                    push @Blocks, $1;
                }
            }
        }

        # call all blocks
        for my $Block (@Blocks) {

            # do it three times (its more realistic)
            for ( 1 .. 3 ) {
                $LayoutObject->Block(
                    Name => $Block,
                    Data => \%Data,
                );
            }
        }

        # call the output function
        my $Output = $LayoutObject->Output(
            TemplateFile => $DTLName,
            Data         => \%Data,
        );
        my $OutputFlag = 1;
        if (
            $Output =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) \{" }msx
            || $Output =~ m{ <dtl \W if }msx
            )
        {
            $OutputFlag = 0;
        }
        $Self->True(
            $OutputFlag,
            "Output() check the output for not replaced variables in $DTLName",
        );
    }
}

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
        Result => 'some [...]',
        Max    => 5,
    },
    {
        Name   => 'Ascii2Html() - Max check #2',
        String => 'some Text',
        Result => 'some Tex[...]',
        Max    => 8,
    },
    {
        Name   => 'Ascii2Html() - Max check #2',
        String => 'some Text',
        Result => 'some Text',
        Max    => 9,
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

# html link quoting of html
@Tests = (
    {
        Name   => 'HTMLLinkQuote() - simple',
        String => 'some Text',
        Result => 'some Text',
    },
    {
        Name   => 'HTMLLinkQuote() - simple',
        String => 'some <a name="top">Text',
        Result => 'some <a name="top">Text',
    },
    {
        Name   => 'HTMLLinkQuote() - extended',
        String => 'some <a href="http://example.com">Text</a>',
        Result => 'some <a href="http://example.com" target="_blank">Text</a>',
    },
    {
        Name   => 'HTMLLinkQuote() - extended',
        String => 'some <a
 href="http://example.com">Text</a>',
        Result => 'some <a
 href="http://example.com" target="_blank">Text</a>',
    },
    {
        Name   => 'HTMLLinkQuote() - extended',
        String => 'some <a href="http://example.com" target="somewhere">Text</a>',
        Result => 'some <a href="http://example.com" target="somewhere">Text</a>',
    },
    {
        Name   => 'HTMLLinkQuote() - extended',
        String => 'some <a href="http://example.com" target="somewhere">http://example.com</a>',
        Result => 'some <a href="http://example.com" target="somewhere">http://example.com</a>',
    },
);

for my $Test (@Tests) {
    my $HTML = $LayoutObject->HTMLLinkQuote(
        String => $Test->{String},
    );
    $Self->Is(
        $HTML || '',
        $Test->{Result},
        $Test->{Name},
    );
}

#-------------------------------------#
# test the build selection
#-------------------------------------#

# zero test for SelectedID attribute
my $HTMLCode = $LayoutObject->BuildSelection(
    Data => {
        0 => 'zero',
        1 => 'one',
        2 => 'two',
    },
    SelectedID  => 0,
    Name        => 'test',
    Translation => 0,
    Max         => 37,
);
my $SelectedTest = 0;

if ( $HTMLCode =~ m{ value="0" \s selected}smx ) {
    $SelectedTest = 1;
}

$Self->True(
    $SelectedTest,
    "Layout.t - zero test for SelectedID attribute in BuildSelection().",
);

# Ajax and OnChange exclude each other
$HTMLCode = $LayoutObject->BuildSelection(
    Data => {
        0 => 'zero',
        1 => 'one',
        2 => 'two',
    },
    Name     => 'test',
    OnChange => q{alert('just testing')},
    Ajax     => {},
);

$Self->False(
    $HTMLCode,
    q{Layout.t - 'Ajax' and 'OnChange' exclude each other in BuildSelection().},
);

# test quoting and cutting of strings for $Quote, $QData and $QEnv
@Tests = (
    {
        Name   => 'QuoteAndCut()',
        String => '$Quote{"some Text"}',
        Result => 'some Text',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$Quote{"some "T"ext"}',
        Result => 'some &quot;T&quot;ext',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$Quote{"some Text","6"}',
        Result => 'some T[...]',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$Quote{"some Text", "6"}',
        Result => 'some T[...]',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$Quote{"some Text",   "6"}',
        Result => 'some T[...]',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$QData{"Key1"}',
        Result => 'Value1',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$QData{"Key3"}',
        Result => 'Value&quot;3&quot;',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$QData{"Key4","10"}',
        Result => 'Value&quot;4&quot;Va[...]',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$QData{"Key4", "10"}',
        Result => 'Value&quot;4&quot;Va[...]',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$QData{"Key4",   "10"}',
        Result => 'Value&quot;4&quot;Va[...]',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$QEnv{"DOESNOTEXIST"}',
        Result => '',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$QEnv{"DOESNOTEXIST","1"}',
        Result => '',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$QEnv{"DOESNOTEXIST", "1"}',
        Result => '',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$QEnv{"DOESNOTEXIST",   "1"}',
        Result => '',
    },
);
for my $Test (@Tests) {
    my $Result = $LayoutObject->Output(
        Template => $Test->{String},
        Data     => {
            Key1 => 'Value1',
            Key2 => 'Value2',
            Key3 => 'Value"3"',
            Key4 => 'Value"4"Value',
        },
    );
    $Self->Is(
        $Result || '',
        $Test->{Result},
        $Test->{Name},
    );
}

# this check is only to display how long it had take
$Self->True(
    1,
    "Layout.t - to handle the whole test file it takes " . ( time() - $StartTime ) . " seconds.",
);

# rich text tests
@Tests = (
    {
        Name => '_RichTextReplaceLinkOfInlineContent() - generated by outlook',
        String =>
            '<img alt="" src="/otrs-cvs/otrs-cvs/bin/cgi-bin/index.pl?Action=PictureUpload&amp;FormID=1255961382.1012148.29113074&amp;ContentID=&lt;734083011@19102009-1795&gt;" />',
        Result => '<img alt="" src="cid:&lt;734083011@19102009-1795&gt;" />',
    },
    {
        Name => '_RichTextReplaceLinkOfInlineContent() - generated itself',
        String =>
            '<img width="343" height="563" alt="" src="/otrs-cvs/otrs-cvs/bin/cgi-bin/index.pl?Action=PictureUpload&amp;FormID=1255961382.1012148.29113074&amp;ContentID=inline244217.547683276.1255961382.1012148.29113074@vo7.vo.otrs.com" />',
        Result =>
            '<img width="343" height="563" alt="" src="cid:inline244217.547683276.1255961382.1012148.29113074@vo7.vo.otrs.com" />',
    },
    {
        Name => '_RichTextReplaceLinkOfInlineContent() - generated itself, with newline',
        String =>
            "<img width=\"343\" height=\"563\" alt=\"\"\nsrc=\"/otrs-cvs/otrs-cvs/bin/cgi-bin/index.pl?Action=PictureUpload&amp;FormID=1255961382.1012148.29113074&amp;ContentID=inline244217.547683276.1255961382.1012148.29113074\@vo7.vo.otrs.com\" />",
        Result =>
            "<img width=\"343\" height=\"563\" alt=\"\"\nsrc=\"cid:inline244217.547683276.1255961382.1012148.29113074\@vo7.vo.otrs.com\" />",
    },
    {
        Name =>
            '_RichTextReplaceLinkOfInlineContent() - generated itself, with internal and external image',
        String =>
            '<img width="140" vspace="10" hspace="1" height="38" border="0" alt="AltText" src="http://www.otrs.com/fileadmin/templates/skins/skin_otrs/css/images/logo.gif" /> This text should be displayed <img width="400" height="81" border="0" alt="Description: cid:image001.jpg@01CC3AFE.F81F0B30" src="/otrs/index.pl?Action=PictureUpload&amp;FormID=1311080525.12118416.3676164&amp;ContentID=image001.jpg@01CC4216.1E22E9A0" id="Picture_x0020_1" />',
        Result =>
            '<img width="140" vspace="10" hspace="1" height="38" border="0" alt="AltText" src="http://www.otrs.com/fileadmin/templates/skins/skin_otrs/css/images/logo.gif" /> This text should be displayed <img width="400" height="81" border="0" alt="Description: cid:image001.jpg@01CC3AFE.F81F0B30" src="cid:image001.jpg@01CC4216.1E22E9A0" id="Picture_x0020_1" />',
    },
    {
        Name =>
            '_RichTextReplaceLinkOfInlineContent() - generated itself, with internal and external image, no space before />',
        String =>
            '<img width="140" vspace="10" hspace="1" height="38" border="0" alt="AltText" src="http://www.otrs.com/fileadmin/templates/skins/skin_otrs/css/images/logo.gif" /> This text should be displayed <img width="400" height="81" border="0" alt="Description: cid:image001.jpg@01CC3AFE.F81F0B30" src="/otrs/index.pl?Action=PictureUpload&amp;FormID=1311080525.12118416.3676164&amp;ContentID=image001.jpg@01CC4216.1E22E9A0" id="Picture_x0020_1"/>',
        Result =>
            '<img width="140" vspace="10" hspace="1" height="38" border="0" alt="AltText" src="http://www.otrs.com/fileadmin/templates/skins/skin_otrs/css/images/logo.gif" /> This text should be displayed <img width="400" height="81" border="0" alt="Description: cid:image001.jpg@01CC3AFE.F81F0B30" src="cid:image001.jpg@01CC4216.1E22E9A0" id="Picture_x0020_1"/>',
    },
);

for my $Test (@Tests) {
    my $HTML = $LayoutObject->_RichTextReplaceLinkOfInlineContent(
        String => \$Test->{String},
    );
    $Self->Is(
        ${$HTML} || '',
        $Test->{Result},
        $Test->{Name},
    );
}

# rich text tests
@Tests = (
    {
        Name => 'RichTextDocumentServe() ',
        Data => {
            Content     => '<img src="cid:1234567890ABCDEF">',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                '<img src="No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;;SessionID=123">',
            }
    },
    {
        Name => 'RichTextDocumentServe() ',
        Data => {
            Content     => "<img border=\"0\" src=\"cid:1234567890ABCDEF\">",
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                '<img border="0" src="No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;;SessionID=123">',
            }
    },
    {
        Name => 'RichTextDocumentServe() ',
        Data => {
            Content     => "<img border=\"0\" \nsrc=\"cid:1234567890ABCDEF\">",
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                "<img border=\"0\" \nsrc=\"No-\$ENV{\"SCRIPT_NAME\"}?Action=SomeAction;FileID=0;;SessionID=123\">",
            }
    },
    {
        Name => 'RichTextDocumentServe() ',
        Data => {
            Content     => '<img src=cid:1234567890ABCDEF>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                '<img src="No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;;SessionID=123">',
            }
    },
    {
        Name => 'RichTextDocumentServe() ',
        Data => {
            Content     => '<img src=cid:1234567890ABCDEF />',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                '<img src="No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;;SessionID=123" />',
            }
    },
    {
        Name => 'RichTextDocumentServe() ',
        Data => {
            Content     => '<img src=\'cid:1234567890ABCDEF\' />',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                '<img src=\'No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;;SessionID=123\' />',
            }
    },
    {
        Name => 'RichTextDocumentServe() ',
        Data => {
            Content     => '<img src=\'Untitled%20Attachment\' />',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<Untitled%20Attachment>',
                },
        },
        Result => {
            Content =>
                '<img src=\'No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;;SessionID=123\' />',
            }
    },
);

for my $Test (@Tests) {
    my %HTML = $LayoutObject->RichTextDocumentServe(
        %{$Test},
    );
    $Self->Is(
        $HTML{Content},
        $Test->{Result}->{Content},
        $Test->{Name},
    );
}

# Tests for _RemoveScriptTags method
@Tests = (
    {
        Input  => '',
        Result => '',
        Name   => '_RemoveScriptTags - empty test',
    },
    {
        Input  => '<script type="text/javascript"></script>',
        Result => '',
        Name   => '_RemoveScriptTags - just tags test',
    },
    {
        Input => '
<script type="text/javascript">
    123
    // 456
    789
</script>',
        Result => '

    123
    // 456
    789
',
        Name => '_RemoveScriptTags - some content test',
    },
    {
        Input => '
<script type="text/javascript">//<![CDATA[
    OTRS.UI.Tables.InitTableFilter($(\'#FilterCustomers\'), $(\'#Customers\'));
    OTRS.UI.Tables.InitTableFilter($(\'#FilterGroups\'), $(\'#Groups\'));
//]]></script>
        ',
        Result => '

    OTRS.UI.Tables.InitTableFilter($(\'#FilterCustomers\'), $(\'#Customers\'));
    OTRS.UI.Tables.InitTableFilter($(\'#FilterGroups\'), $(\'#Groups\'));

        ',
        Name => '_RemoveScriptTags - complete content test',
    },
    {
        Input => <<'EOF',
<!--DocumentReadyActionRowAdd-->
<script type="text/javascript">  //<![CDATA[
   alert();
//]]></script>
<!--/DocumentReadyActionRowAdd-->
<!--DocumentReadyStart-->
<script type="text/javascript">//  <![CDATA[
   alert();
//]]></script>
<!--/DocumentReadyStart-->
EOF
        Result => <<"EOF",

   alert();
\n
   alert();

EOF
        Name => '_RemoveScriptTags - complete content test with block comments',
    },
    {
        Input => <<'EOF',
<script type="text/javascript">  //<![CDATA[
<!--DocumentReadyActionRowAdd-->
   alert();
<!--/DocumentReadyActionRowAdd-->
//]]></script>
EOF
        Result => <<"EOF",

   alert();

EOF
        Name =>
            '_RemoveScriptTags - complete content test with block comments inside the script tags',
    },
);

for my $Test (@Tests) {
    my $LRST = $LayoutObject->_RemoveScriptTags(
        Code => $Test->{Input},
    );
    $Self->Is(
        $LRST,
        $Test->{Result},
        $Test->{Name},
    );
}

# block tests
@Tests = (

    # test 1
    {
        Input => '<!-- dtl:block:ConfigElementBlock -->
<b>test</b>
<!-- dtl:block:ConfigElementBlock -->',
        Result => '
<b>test</b>',
        Block => [
            {
                Name => 'ConfigElementBlock',
                Data => {},
            },
        ],
        Name => 'Output() - test 1',
    },

    # test 2
    {
        Input => '<!-- dtl:block:ConfigElementBlock -->
<b>$QData{"Name"}</b>
<!-- dtl:block:ConfigElementBlock -->',
        Result => '
<b>test123</b>
<b>test1234</b>',
        Block => [
            {
                Name => 'ConfigElementBlock',
                Data => { Name => 'test123' },
            },
            {
                Name => 'ConfigElementBlock',
                Data => { Name => 'test1234' },
            },
        ],
        Name => 'Output() - test 2',
    },

    # --------------------------------------------------------- #
    # Commented out this UnitTest as this test will fail        #
    # This functionality never worked in otrs, but it would be  #
    # desirable that it will be fixed in the Output() function  #
    # in Layout.pm                                              #
    # --------------------------------------------------------- #
    #
    #    # test 3
    #    {
    #        Input => '<!-- dtl:block:ConfigElementBlock1 -->
    #<b>$QData{"Name"}</b>
    #<!-- dtl:block:ConfigElementBlock1 -->
    #<!-- dtl:block:ConfigElementBlock2 -->
    #<b>$QData{"Name"}</b>
    #<!-- dtl:block:ConfigElementBlock2 -->',
    #        Result => '
    #<!--ConfigElementBlock1-->
    #<b>test123</b>
    #<!--/ConfigElementBlock1-->
    #
    #<!--ConfigElementBlock1-->
    #<b>test1235</b>
    #<!--/ConfigElementBlock1-->
    #
    #<!--ConfigElementBlock2-->
    #<b>test1234</b>
    #<!--/ConfigElementBlock2-->',
    #        Block => [
    #            {
    #                Name => 'ConfigElementBlock1',
    #                Data => { Name => 'test123' },
    #            },
    #            {
    #                Name => 'ConfigElementBlock2',
    #                Data => { Name => 'test1234' },
    #            },
    #            {
    #                Name => 'ConfigElementBlock1',
    #                Data => { Name => 'test1235' },
    #            },
    #        ],
    #        Name => 'Output() - test 3',
    #    },

    # test 4
    {
        Input => '<!-- dtl:block:ConfigElementBlock1 -->
<b>$QData{"Name1"}</b>
<!-- dtl:block:ConfigElementBlock2 -->
<b>$QData{"Name2"}</b>
<!-- dtl:block:ConfigElementBlock2 -->
<!-- dtl:block:ConfigElementBlock1 -->',

        Result => '
<b>test123</b>

<b>test1234</b>',
        Block => [
            {
                Name => 'ConfigElementBlock1',
                Data => { Name1 => 'test123' },
            },
            {
                Name => 'ConfigElementBlock2',
                Data => { Name2 => 'test1234' },
            },
        ],
        Name => 'Output() - test 4',
    },

    # test 5
    {
        Input => '<!-- dtl:block:ConfigElementBlock1 -->
<b>$QData{"Name1"}</b>
<!-- dtl:block:ConfigElementBlock1A -->
<b>$QData{"Name1A"}</b>
<!-- dtl:block:ConfigElementBlock1A -->
<!-- dtl:block:ConfigElementBlock1 -->
<!-- dtl:block:ConfigElementBlock2 -->
<b>$QData{"Name2"}</b>
<!-- dtl:block:ConfigElementBlock2 -->',

        Result => '
<b>AAA</b>

<b>BBB1</b>
<b>BBB2</b>
<b>XXX</b>

<b>YYY</b>

<b>CCC</b>',
        Block => [
            {
                Name => 'ConfigElementBlock1',
                Data => { Name1 => 'AAA' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'BBB1' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'BBB2' },
            },
            {
                Name => 'ConfigElementBlock1',
                Data => { Name1 => 'XXX' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'YYY' },
            },
            {
                Name => 'ConfigElementBlock2',
                Data => { Name2 => 'CCC' },
            },
        ],
        Name => 'Output() - test 5',
    },

    # test 6
    {
        Input => '<!-- dtl:block:ConfigElementBlock2 -->
<b>$QData{"Name2"}</b>
<!-- dtl:block:ConfigElementBlock2 -->
<!-- dtl:block:ConfigElementBlock1 -->
<b>$QData{"Name1"}</b>
<!-- dtl:block:ConfigElementBlock1A -->
<b>$QData{"Name1A"}</b>
<!-- dtl:block:ConfigElementBlock1A -->
<!-- dtl:block:ConfigElementBlock1 -->',

        Result => '
<b>CCC</b>

<b>AAA</b>

<b>BBB1</b>
<b>BBB2</b>
<b>XXX</b>

<b>YYY</b>',
        Block => [
            {
                Name => 'ConfigElementBlock1',
                Data => { Name1 => 'AAA' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'BBB1' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'BBB2' },
            },
            {
                Name => 'ConfigElementBlock1',
                Data => { Name1 => 'XXX' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'YYY' },
            },
            {
                Name => 'ConfigElementBlock2',
                Data => { Name2 => 'CCC' },
            },
        ],
        Name => 'Output() - test 6',
    },

);

for my $Test (@Tests) {
    for my $Block ( @{ $Test->{Block} } ) {
        $LayoutObject->Block( %{$Block} );
    }
    my $Output = $LayoutObject->Output(
        Template => $Test->{Input},
        Data     => {},
    );
    $Self->Is(
        $Output,
        $Test->{Result},
        $Test->{Name},
    );
}

my @LinkEncodeTests = (

    {
        Source => '%',
        Target => '%25',
    },
    {
        Source => '&',
        Target => '%26',
    },
    {
        Source => '=',
        Target => '%3D',
    },
    {
        Source => '!',
        Target => '%21',
    },
    {
        Source => '"',
        Target => '%22',
    },
    {
        Source => '#',
        Target => '%23',
    },
    {
        Source => '$',
        Target => '%24',
    },
    {
        Source => '\'',
        Target => '%27',
    },
    {
        Source => ',',
        Target => '%2C',
    },
    {
        Source => '+',
        Target => '%2B',
    },
    {
        Source => '?',
        Target => '%3F',
    },
    {
        Source => '|',
        Target => '%7C',
    },
    {
        Source => '/',
        Target => '%2F',
    },

    # According to the URL encoding RFC, the path segment of an URL must use %20 for space,
    # while in the query string + is used normally. However, IIS does not understand + in the
    # path segment, but understands %20 in the query string, like all others do as well.
    # Therefore we use %20.
    {
        Source => ' ',
        Target => '%20',
    },
    {
        Source => ':',
        Target => '%3A',
    },
    {
        Source => ';',
        Target => '%3B',
    },
    {
        Source => '@',
        Target => '%40',
    },

    # LinkEncode() on reserved characters
    {
        Source => '!*\'();:@&=+$,/?#[]',
        Target => '%21%2A%27%28%29%3B%3A%40%26%3D%2B%24%2C%2F%3F%23%5B%5D',
    },

    # LinkEncode() on common characters
    {
        Source => '<>"{}|\`^% ',
        Target => '%3C%3E%22%7B%7D%7C%5C%60%5E%25%20',
    },

    # LinkEncode() on normal characters
    {
        Source => 'normaltext123',
        Target => 'normaltext123',
    },
);

for my $LinkEncodeTest (@LinkEncodeTests) {
    $Self->Is(
        $LayoutObject->LinkEncode( $LinkEncodeTest->{Source} ),
        $LinkEncodeTest->{Target},
        "LinkEncode from '$LinkEncodeTest->{Source}' to '$LinkEncodeTest->{Target}'",
    );
}

1;
