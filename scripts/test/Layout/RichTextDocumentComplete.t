# --
# scripts/test/Layout/RichTextDocumentComplete.t - layout testscript
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
            '123 <img src="index.pl?Action=SomeAction;FileID=0;ContentID=inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">123 <img src="cid:inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234</body></html>',
    },
    {
        Name => 'Image with ContentID, with session',
        String =>
            '123 <img src="index.pl?Action=SomeAction;FileID=0;ContentID=inline105816.238987884.1382708457.5104380.88084622@localhost;SessionID=123" /> 234',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">123 <img src="cid:inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234</body></html>',
    },
    {
        Name => 'Image with ContentID, with session',
        String =>
            '123 <img src="index.pl?Action=SomeAction;FileID=0;ContentID=inline105816.238987884.1382708457.5104380.88084622@localhost&SessionID=123" /> 234',
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
