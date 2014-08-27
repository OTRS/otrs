# --
# scripts/test/Layout/HTMLLinkQuote.t - layout module testscript
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

my $ParamObject   = Kernel::System::Web::Request->new(
    WebRequest => $Param{WebRequest} || 0,
);

my $LayoutObject = Kernel::Output::HTML::Layout->new(
    UserChallengeToken => 'TestToken',
    UserID             => 1,
    Lang               => 'de',
    SessionID          => 123,
);

my $StartTime = time();

# html link quoting of html
my @Tests = (
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

# this check is only to display how long it had take
$Self->True(
    1,
    "Layout.t - to handle the whole test file it takes " . ( time() - $StartTime ) . " seconds.",
);

1;
