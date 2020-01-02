# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my $StartTime = time();

# HTML link quoting of HTML
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
