# --
# scripts/test/Layout/RichTextDocumentComplete.t - layout testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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
        Name   => 'Empty document',
        String => '123',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">123</body></html>',
    },
    {
        Name => 'Image with ContentID, no session',
        String =>
            '123 <img src="No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;ContentID=inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">123 <img src="cid:inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234</body></html>',
    },
    {
        Name => 'Image with ContentID, with session',
        String =>
            '123 <img src="No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;ContentID=inline105816.238987884.1382708457.5104380.88084622@localhost;SessionID=123" /> 234',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">123 <img src="cid:inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234</body></html>',
    },
    {
        Name => 'Image with ContentID, with session',
        String =>
            '123 <img src="No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;ContentID=inline105816.238987884.1382708457.5104380.88084622@localhost&SessionID=123" /> 234',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">123 <img src="cid:inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234</body></html>',
    },
);

for my $Test (@Tests) {
    my $Result = $LayoutObject->RichTextDocumentComplete(
        String => $Test->{String},
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name}",
    );
}

1;
