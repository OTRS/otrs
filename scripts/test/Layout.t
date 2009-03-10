# --
# scripts/test/Layout.t - layout module testscript
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Layout.t,v 1.18.2.1 2009-03-10 12:07:19 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use Kernel::System::AuthSession;
use Kernel::System::Web::Request;
use Kernel::System::Group;
use Kernel::System::User;
use Kernel::System::Ticket;
use Kernel::Output::HTML::Layout;

# declare externally defined variables to avoid errors under 'use strict'
use vars qw( $Self %Param );

$Self->{SessionObject} = Kernel::System::AuthSession->new(
    ConfigObject => $Self->{ConfigObject},
    LogObject    => $Self->{LogObject},
    DBObject     => $Self->{DBObject},
    MainObject   => $Self->{MainObject},
    TimeObject   => $Self->{TimeObject},
);

$Self->{ParamObject} = Kernel::System::Web::Request->new(
    %{$Self},
    WebRequest => $Param{WebRequest} || 0,
);

$Self->{GroupObject} = Kernel::System::Group->new(
    ConfigObject => $Self->{ConfigObject},
    LogObject    => $Self->{LogObject},
    MainObject   => $Self->{MainObject},
    DBObject     => $Self->{DBObject},
);

$Self->{TicketObject} = Kernel::System::Ticket->new(
    ConfigObject => $Self->{ConfigObject},
    LogObject    => $Self->{LogObject},
    TimeObject   => $Self->{TimeObject},
    MainObject   => $Self->{MainObject},
    DBObject     => $Self->{DBObject},
);

$Self->{UserObject} = Kernel::System::User->new(
    ConfigObject => $Self->{ConfigObject},
    LogObject    => $Self->{LogObject},
    TimeObject   => $Self->{TimeObject},
    MainObject   => $Self->{MainObject},
    DBObject     => $Self->{DBObject},
);

$Self->{LayoutObject} = Kernel::Output::HTML::Layout->new(
    ConfigObject  => $Self->{ConfigObject},
    LogObject     => $Self->{LogObject},
    TimeObject    => $Self->{TimeObject},
    MainObject    => $Self->{MainObject},
    EncodeObject  => $Self->{EncodeObject},
    SessionObject => $Self->{SessionObject},
    DBObject      => $Self->{DBObject},
    ParamObject   => $Self->{ParamObject},
    TicketObject  => $Self->{TicketObject},
    UserObject    => $Self->{UserObject},
    GroupObject   => $Self->{GroupObject},
    UserID        => 1,
    Lang          => 'de',
    SessionID     => 123,
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
my $Header = $Self->{LayoutObject}->Header( Title => 'HeaderTest' );
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
my $NavigationBar  = $Self->{LayoutObject}->NavigationBar();
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
my $Footer     = $Self->{LayoutObject}->Footer();
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
                $Self->{LayoutObject}->Block(
                    Name => $Block,
                    Data => \%Data,
                );
            }
        }

        # call the output function
        my $Output = $Self->{LayoutObject}->Output(
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
w<a href="http://www.example.net" target="_blank" title="http://www.example.net">http://www.example.net</a><br/>
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
my $ConvertedString = $Self->{LayoutObject}->Ascii2Html(
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
    my $HTML = $Self->{LayoutObject}->Ascii2Html(
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
        Result => 'some [..]',
        Max    => 5,
    },
    {
        Name   => 'Ascii2Html() - Max check #2',
        String => 'some Text',
        Result => 'some Tex[..]',
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
    my $HTML = $Self->{LayoutObject}->Ascii2Html(
        Text => $Test->{String},
        Max  => $Test->{Max},
    );
    $Self->Is(
        $HTML || '',
        $Test->{Result},
        $Test->{Name},
    );
}

# check if a Env setting is lost
# Attention the needed header.dtl is called a few tests before
my $Output = $Self->{LayoutObject}->Output(
    TemplateFile => 'Test',
    Data         => {},
);
$Output =~ m{^ .+? Box0:<\/td><td>(.*?)<\/td> .+? $}smx;
my $Box0 = $1;

$Self->Is(
    $Box0,
    '[ ',
    "Layout.t - check if a Box0 Env setting is lost.",
);
$Output =~ m{^ .+? Box1:<\/td><td>(.*?)<\/td> .+? $}smx;
my $Box1 = $1;

$Self->Is(
    $Box1,
    ' ]',
    "Layout.t - check if a Box1 Env setting is lost.",
);

#-------------------------------------#
# test the build selection
#-------------------------------------#

# zero test for SelectedID attribute
my $HTMLCode = $Self->{LayoutObject}->BuildSelection(
    Data        => {
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

if (  $HTMLCode =~ m{ value="0" \s selected}smx ) {
    $SelectedTest = 1;
}

$Self->True(
    $SelectedTest,
    "Layout.t - zero test for SelectedID attribute in BuildSelection().",
);

# this check is only to display how long it had take
$Self->True(
    1,
    "Layout.t - to handle the whole test file it takes " . ( time() - $StartTime ) . " seconds.",
);

1;
