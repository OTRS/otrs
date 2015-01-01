# --
# scripts/test/Layout/Tags.t - layout testscript
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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
        Result => 's[...]',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$Quote{"some Text", "8"}',
        Result => 'som[...]',
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
        String => '$QData{"Key4","12"}',
        Result => 'Value&quot;4[...]',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$QData{"Key4", "12"}',
        Result => 'Value&quot;4[...]',
    },
    {
        Name   => 'QuoteAndCut()',
        String => '$QData{"Key4",   "12"}',
        Result => 'Value&quot;4[...]',
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

1;
