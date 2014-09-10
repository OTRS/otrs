# --
# scripts/test/Layout/RichText2Ascii.t - layout testscript
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

use Kernel::Output::HTML::Layout;
use Kernel::System::Web::Request;

my $ParamObject = Kernel::System::Web::Request->new(
    WebRequest => $Param{WebRequest} || 0,
);

my $LayoutObject = Kernel::Output::HTML::Layout->new(
    UserChallengeToken => 'TestToken',
    UserID             => 1,
    Lang               => 'de',
    SessionID          => 123,
);

my @Tests = (
    {
        Name   => 'Plain',
        String => 'some plain text',
        Result => 'some plain text',

    },
    {
        Name   => 'Umlauts',
        String => '&Auml;nderung',
        Result => 'Änderung',

    },
);
for my $Test (@Tests) {
    my $Plain = $LayoutObject->RichText2Ascii(
        String => $Test->{String},
    );
    $Self->Is(
        $Plain || '',
        $Test->{Result},
        $Test->{Name},
    );
}

1;
