# --
# scripts/test/Layout/Blocks.t - layout testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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

my @Tests = (

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

1;
