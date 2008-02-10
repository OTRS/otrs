# --
# scripts/test/Layout.t - layout module testscript
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Layout.t,v 1.1 2008-02-10 15:40:51 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;

use Kernel::System::AuthSession;
use Kernel::System::Web::Request;
use Kernel::System::Ticket;
use Kernel::Output::HTML::Layout;

$Self->{SessionObject} = Kernel::System::AuthSession->new(
    ConfigObject   => $Self->{ConfigObject},
    LogObject      => $Self->{LogObject},
    DBObject       => $Self->{DBObject},
    MainObject     => $Self->{MainObject},
    TimeObject     => $Self->{TimeObject},
);

$Self->{ParamObject} = Kernel::System::Web::Request->new(
    %{$Self},
    WebRequest => $Param{WebRequest} || 0,
);

$Self->{TicketObject} = Kernel::System::Ticket->new(
    ConfigObject   => $Self->{ConfigObject},
    LogObject      => $Self->{LogObject},
    TimeObject     => $Self->{TimeObject},
    MainObject     => $Self->{MainObject},
    DBObject       => $Self->{DBObject},
);

$Self->{LayoutObject} = Kernel::Output::HTML::Layout->new(
    ConfigObject   => $Self->{ConfigObject},
    LogObject      => $Self->{LogObject},
    TimeObject     => $Self->{TimeObject},
    MainObject     => $Self->{MainObject},
    EncodeObject   => $Self->{EncodeObject},
    SessionObject  => $Self->{SessionObject},
    DBObject       => $Self->{DBObject},
    ParamObject    => $Self->{ParamObject},
    TicketObject   => $Self->{TicketObject},
    UserID         => 1,
    Lang => 'de',
);
# here everyone can insert example data for the tests
my %Data = (
    Created         => '2007-11-30 08:58:54',
    CreateTime      => '2007-11-30 08:58:54',
    ChangeTime      => '2007-11-30 08:58:54',
    TicketFreeTime  => '2007-11-30 08:58:54',
    TicketFreeTime1 => '2007-11-30 08:58:54',
    TicketFreeTime2 => '2007-11-30 08:58:54',
    TimeStartMax    => '2007-11-30 08:58:54',
    TimeStopMax     => '2007-11-30 08:58:54',
    UpdateTimeDestinationDate => '2007-11-30 08:58:54',
    Body            => "What do you\n mean with body?"
);

my $StartTime = time();
# --------------------------------------------------------------------#
# Search for $Data{""} etc. because this is the most dangerous bug if you
# modify the Output funciton
# --------------------------------------------------------------------#

# check the header
my $Header = $Self->{LayoutObject}->Header( Title => 'HeaderTest' );
my $HeaderFlag = 1;
if ($Header =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) }msx
    || $Header =~ m{ <dtl \W if }msx
) {
    $HeaderFlag = 0;
}
$Self->True(
    $HeaderFlag,
    'Header() check the output for not replaced variables',
);

# check the navigation bar
my $NavigationBar = $Self->{LayoutObject}->NavigationBar();
my $NavigationFlag = 1;
if ($NavigationBar =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) }msx
    || $NavigationBar =~ m{ <dtl \W if }msx
) {
    $NavigationFlag = 0;
}
$Self->True(
    $NavigationFlag,
    'NavigationBar() check the output for not replaced variables',
);

# check the footer
my $Footer = $Self->{LayoutObject}->Footer();
my $FooterFlag = 1;
if ($Footer =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) }msx
    || $Footer =~ m{ <dtl \W if }msx
) {
    $FooterFlag = 0;
}
$Self->True(
    $FooterFlag,
    'Footer() check the output for not replaced variables',
);

# check all dtl files
my $HomeDirectory = $Self->{ConfigObject}->Get('Home');
my $DTLDirectory = $HomeDirectory . '/Kernel/Output/HTML/Standard/';
my $DIR;
if (!opendir $DIR, $DTLDirectory) {
    print "Can not open Directory: $DTLDirectory";
    return;
}

my @Files = ();
while (defined (my $Filename = readdir $DIR)) {
    if ($Filename=~ m{ \. dtl $}xms ) {
        push(@Files, "$DTLDirectory/$Filename")
    }
}
closedir $DIR;

for my $File (@Files) {
    if ($File =~ m{ / ( [^/]+ ) \. dtl}smx) {
        my $DTLName = $1;

        # find all blocks auf the dtl files
        my $ContentARRAYRef = $Self->{MainObject}->FileRead(
            Location  => $File,
            Result    => 'ARRAY'
        );
        my @Blocks             = ();
        my %DoubleBlockChecker = ();
        for my $Line (@{$ContentARRAYRef}) {
            if ($Line =~ m{ <!-- \s{0,1} dtl:block: (.+?) \s{0,1} --> }smx) {
                if (!$DoubleBlockChecker{$1}) {
                    push @Blocks, $1;
                }
            }
        }

        # call all blocks
        for my $Block (@Blocks) {
            # do it three times (its more realistic)
            for (1..3) {
                $Self->{LayoutObject}->Block(
                    Name => $Block,
                    Data => \%Data,
                );
            }
        };

        # call the output function
        my $Output = $Self->{LayoutObject}->Output(
            TemplateFile => $DTLName,
            Data         => \%Data,
        );
        my $OutputFlag = 1;
        if ($Output =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) \{" }msx
            || $Output =~ m{ <dtl \W if }msx
        ) {
            $OutputFlag = 0;
        }
        $Self->True(
            $OutputFlag,
            "Output() check the output for not replaced variables in $DTLName",
        );
    }
}

# this check is only to display how long it had take
$Self->True(
    1,
    "Layout.t - to handle the whole test file it takes " . (time() - $StartTime) . " seconds." ,
);

1;
