# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# prevent use once warning
use Kernel::System::ObjectManager;

my @Tests = (
    {
        Name    => 'Empty',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing String',
        Config => {
            Chars => 20
        },
        Success => 0,
    },
    {
        Name   => 'Missing Chars',
        Config => {
            String => 'Hi',
        },
        Success => 0,
    },

    # this is an odd example as it shows the ellipsis where it should not
    {
        Name   => 'No HTML on string end',
        Config => {
            String => 'Hi',
            Chars  => '2'
        },
        ExpectedResults => 'Hi&#8230;',
        Success         => 1,
    },
    {
        Name   => 'No HTML after string end',
        Config => {
            String => 'Hi',
            Chars  => '3'
        },
        ExpectedResults => 'Hi',
        Success         => 1,
    },
    {
        Name   => 'No HTML after string end 2',
        Config => {
            String => 'Hi',
            Chars  => '4'
        },
        ExpectedResults => 'Hi',
        Success         => 1,
    },

    # this is an odd example as it shows the ellipsis where it should not
    {
        Name   => 'Simple HTML on string end',
        Config => {
            String => '<a>Hi</a>',
            Chars  => '2'
        },
        ExpectedResults => '<a>Hi&#8230;</a>',
        Success         => 1,
    },
    {
        Name   => 'Simple HTML after string end',
        Config => {
            String => '<a>Hi</a>',
            Chars  => '3'
        },
        ExpectedResults => '<a>Hi</a>',
        Success         => 1,
    },
    {
        Name   => 'Simple HTML after string end 2',
        Config => {
            String => '<a>Hi</a>',
            Chars  => '4'
        },
        ExpectedResults => '<a>Hi</a>',
        Success         => 1,
    },
    {
        Name   => 'Complex correct HTML',
        Config => {
            String => '<p><i>We</i> have to test <strong>something</strong>.</p>',
            Chars  => 20,
        },
        ExpectedResults => '<p><i>We</i> have to test <strong>some&#8230;</strong></p>',
        Success         => 1,
    },
    {
        Name   => 'Complex correct HTML on HTML entity',
        Config => {
            String => '<p><i>We</i> have to test <strong>s&oacute;mething</strong>.</p>',
            Chars  => 20,
        },
        ExpectedResults => '<p><i>We</i> have to test <strong>s&oacute;me&#8230;</strong></p>',
        Success         => 1,
    },
    {
        Name   => 'Complex correct HTML on HTML entity utf8',
        Config => {
            String   => '<p><i>We</i> have to test <strong>s&oacute;mething</strong>.</p>',
            Chars    => 20,
            UTF8Mode => 1,
        },
        ExpectedResults => '<p><i>We</i> have to test <strong>sóme…</strong></p>',
        Success         => 1,
    },

    # this example is odd as it puts the ellipsis in side the strong tag
    {
        Name   => 'Complex correct HTML On Space',
        Config => {
            String  => '<p><i>We</i> have to test <strong>something</strong>.</p>',
            Chars   => 20,
            OnSpace => 1,
        },
        ExpectedResults => '<p><i>We</i> have to test <strong>&#8230;</strong></p>',
        Success         => 1,
    },
    {
        Name   => 'Complex correct HTML On Space 2',
        Config => {
            String  => '<p><i>We</i> have to test <strong>something</strong>.</p>',
            Chars   => 16,
            OnSpace => 1,
        },
        ExpectedResults => '<p><i>We</i> have to test&#8230;</p>',
        Success         => 1,
    },
    {
        Name   => 'Complex broken HTML',
        Config => {
            String => '<p><i>We</i> have to test <strong>something',
            Chars  => 20,
        },
        ExpectedResults => '<p><i>We</i> have to test <strong>some&#8230;</strong></p>',
        Success         => 1,
    },
    {
        Name   => 'Complex correct HTML table',
        Config => {
            String =>
                '<p><i>We</i> have to test <strong><table><tbody><tr><td></td></tr><tr><td>something</td></tr></tbody></table></strong>.</p>',
            Chars => 20,
        },
        ExpectedResults =>
            '<p><i>We</i> have to test <strong><table><tbody><tr><td></td></tr><tr><td>some&#8230;</td></tr></tbody></table></strong></p>',
        Success => 1,
    },
    {
        Name   => 'Complex correct HTML table with class',
        Config => {
            String =>
                '<p><i>We</i> have to test <strong><table><tbody><tr><td></td></tr><tr><td class="Center">something</td></tr></tbody></table></strong>.</p>',
            Chars => 20,
        },
        ExpectedResults =>
            '<p><i>We</i> have to test <strong><table><tbody><tr><td></td></tr><tr><td class="Center">some&#8230;</td></tr></tbody></table></strong></p>',
        Success => 1,
    },
    {
        Name   => 'Complex correct HTML ul',
        Config => {
            String => '<p><i>We</i> have to test <strong><ul><li>something</li></ul></strong>.</p>',
            Chars  => 20,
        },
        ExpectedResults => '<p><i>We</i> have to test <strong><ul><li>some&#8230;</li></ul></strong></p>',
        Success         => 1,
    },
    {
        Name   => 'Complex correct HTML link',
        Config => {
            String => '<p><i>We</i> have to test <strong><a href="www.otrs.com">something</a></strong>.</p>',
            Chars  => 20,
        },
        ExpectedResults => '<p><i>We</i> have to test <strong><a href="www.otrs.com">some&#8230;</a></strong></p>',
        Success         => 1,
    },
    {
        Name   => 'Complex correct HTML Ellipsis',
        Config => {
            String   => '<p><i>We</i> have to test <strong>something</strong>.</p>',
            Chars    => 20,
            Ellipsis => '...',
        },
        ExpectedResults => '<p><i>We</i> have to test <strong>some...</strong></p>',
        Success         => 1,
    },
    {
        Name   => 'Complex correct HTML with image',
        Config => {
            String =>
                '<p><i>We</i> have to test <img/src="http://example.com/image.png"/><strong>something</strong>.</p>',
            Chars => 20,
        },
        ExpectedResults => '<p><i>We</i> have to test ✂︎<strong>so&#8230;</strong></p>',
        Success         => 1,
    },
);

my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

TEST:
for my $Test (@Tests) {
    my $Result = $HTMLUtilsObject->HTMLTruncate( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->Is(
            $Result,
            undef,
            "$Test->{Name} - Result should be undef",
        );
        next TEST;
    }

    $Self->Is(
        $Result,
        $Test->{ExpectedResults},
        "$Test->{Name} - Result",
    );
}

1;
