# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
        Name   => 'Simple test',
        Params => {
            Name => 'test',
            Data => {
                1 => 'Testqueue',
            },
        },
        Result => '<select name="test" id="test" class=""   >
<option value="1">Testqueue</option>
</select>
',
    },
    {
        Name   => 'Special characters',
        Params => {
            Name => 'test',
            Data => {
                '1||"><script>alert(\'hey there\');</script>' => '"><script>alert(\'hey there\');</script>',
            },
        },
        Result => q{<select name="test" id="test" class=""   >
<option value="1||&quot;&gt;&lt;script&gt;alert('hey there');&lt;/script&gt;">&quot;&gt;&lt;script&gt;alert('hey there');&lt;/script&gt;</option>
</select>
},
    },

);

for my $Test (@Tests) {
    my $Result = $LayoutObject->AgentQueueListOption( %{ $Test->{Params} } );
    $Self->Is(
        $Result,
        $Test->{Result},
        $Test->{Name}
    );
}

1;
