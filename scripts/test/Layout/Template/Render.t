# --
# scripts/test/Layout/Template/Render.t - layout testscript
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

use Scalar::Util qw();

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
    ConfigObject  => $Self->{ConfigObject},
    LogObject     => $Self->{LogObject},
    TimeObject    => $Self->{TimeObject},
    MainObject    => $Self->{MainObject},
    EncodeObject  => $Self->{EncodeObject},
    SessionObject => $SessionObject,
    DBObject      => $Self->{DBObject},
    ParamObject   => $ParamObject,
    TicketObject  => $TicketObject,
    UserObject    => $UserObject,
    GroupObject   => $GroupObject,
    UserID        => 1,
    Lang          => 'de',
);

my @Tests = (
    {
        Name => 'Simple data',
        Data => {
            Title => 'B&B'
        },
        Template => 'Test: [% Data.Title %]',
        Result   => 'Test: B&B',
    },
    {
        Name => 'Simple data with colons',
        Data => {
            'Title::Test' => 'B&B'
        },
        Template => 'Test: [% Data.item("Title::Test") %]',
        Result   => 'Test: B&B',
    },
    {
        Name => 'Simple data with underscore',
        Data => {
            Title_Sub => 'B&B'
        },
        Template => 'Test: [% Data.Title_Sub %]',
        Result   => 'Test: B&B',
    },
    {
        Name => 'Simple data, html quoting',
        Data => {
            Title => '<B&B>'
        },
        Template => 'Test: [% Data.Title | html %]',
        Result   => 'Test: &lt;B&amp;B&gt;',
    },
    {
        Name => 'Interpolate filter',
        Data => {
            Title    => 'B&B [% Data.TicketID %]',
            TicketID => '1234'
        },
        Template => 'Test: [% Data.Title | Interpolate %]',
        Result   => 'Test: B&B 1234',
    },
    {
        Name     => 'Config()',
        Template => '[% Config("Home") %]',
        Result   => $Self->{ConfigObject}->Get('Home'),
    },
    {
        Name     => 'Env()',
        Template => '[% Env("UserLanguage") %]',
        Result   => 'de',
    },
    {
        Name => 'JSON filter',
        Data => {
            Title => "Some data with special characters ' \"."
        },
        Template => '[% Data.Title | JSON %]',
        Result   => '"Some data with special characters \' \\"."',
    },
    {
        Name => 'JSON function complex data',
        Data => {
            Array => ["Some data with special characters ' \"."],
        },
        Template => '[% JSON(Data.Array) %]',
        Result   => '["Some data with special characters \' \\"."]',
    },
    {
        Name     => 'Translate()',
        Template => '[% Translate("Yes") %]',
        Result   => 'Ja',
    },
    {
        Name     => 'Translate() with parameters',
        Template => '[% Translate("Customer %s added", "Testkunde") %]',
        Result   => 'Kunde Testkunde hinzugefügt',
    },
    {
        Name => 'Translate() filter with parameters',
        Data => {
            Text => 'Customer %s added',
        },
        Template => '[% Data.Text | Translate("Testkunde") %]',
        Result   => 'Kunde Testkunde hinzugefügt',
    },
    {
        Name => 'Localize() TimeLong',
        Data => {
            DateTime => '2000-01-01 00:00:00',
        },
        Template => '[% Data.DateTime | Localize("TimeLong") %]',
        Result   => '01.01.2000 00:00:00',
    },
    {
        Name => 'Localize() TimeShort',
        Data => {
            DateTime => '2000-01-01 00:00:00',
        },
        Template => '[% Data.DateTime | Localize("TimeShort") %]',
        Result   => '01.01.2000 00:00',
    },
    {
        Name => 'Localize() Date',
        Data => {
            DateTime => '2000-01-01 00:00:00',
        },
        Template => '[% Data.DateTime | Localize("Date") %]',
        Result   => '01.01.2000',
    },
    {
        Name => 'Blocks',
        Data => {
            Title => 'Template',
        },
        BlockData => [
            {
                Name => 'b1',
                Data => { Title => 'b1', },
            },
            {
                Name => 'b11',
                Data => { Title => 'b11', },
            },
            {
                Name => 'b11',
                Data => { Title => 'b11', },
            },
            {
                Name => 'b12',
                Data => { Title => 'b12', },
            },
            {
                Name => 'b1',
                Data => { Title => 'b1', },
            },
            {
                Name => 'b2',
                Data => { Title => 'b2', },
            },
            {
                Name => 'b21',
                Data => { Title => 'b21', },
            },
            {
                Name => 'b2',
                Data => { Title => 'b2', },
            },
        ],
        Template => '
[% RenderBlockStart("b1") %]
[% Data.Title %]
[% RenderBlockStart("b11") %]
[% Data.Title %]
[% RenderBlockEnd("b11") %]
[% RenderBlockStart("b12") %]
[% Data.Title %]
[% RenderBlockEnd("b12") %]
[% RenderBlockEnd("b1") %]
[% RenderBlockStart("b2") %]
[% Data.Title %]
[% RenderBlockStart("b21") %]
[% Data.Title %]
[% RenderBlockEnd("b21") %]
[% RenderBlockEnd("b2") %]
',
        Result => '
b1
b11
b11
b12
b1
b2
b21
b2
',
    },
    {
        Name => 'Unrendered Blocks',
        Data => {
            Title => 'Template',
        },
        BlockData => [
            {
                Name => 'b1',
                Data => { Title => 'b1', },
            },
        ],
        Template => 'empty',
        Result   => 'empty',
    },
    {
        Name => 'Block from previous test',
        Data => {
            Title => 'Template',
        },
        BlockData => [],
        Template  => '
[% RenderBlockStart("b1") %]
[% Data.Title %]
[% RenderBlockEnd("b1") %]
',
        Result => '
b1
',
    },
    {
        Name     => 'JSOnDocumentComplete 1',
        Template => '
[% WRAPPER JSOnDocumentComplete -%]
console.log(11);
[% END -%]
[% WRAPPER JSOnDocumentComplete -%]
console.log(12);
[% END -%]',
        Result => '
',
    },
    {
        Name     => 'JSOnDocumentComplete 2 with AddJSOnDocumentComplete()',
        Template => '
[% WRAPPER JSOnDocumentComplete -%]
console.log(21);
[% END -%]
[% WRAPPER JSOnDocumentComplete -%]
console.log(22);
[% END -%]',
        AddJSOnDocumentComplete => "console.log(23);\n",
        Result                  => '
',
    },
    {
        Name     => 'JSOnDocumentCompleteInsert',
        Template => '
[% PROCESS "JSOnDocumentCompleteInsert" -%]',
        Result => '
console.log(11);
console.log(12);
console.log(23);
console.log(21);
console.log(22);
',
    },
    {
        Name     => 'JSOnDocumentCompleteInsert, no data',
        Template => '
[% PROCESS "JSOnDocumentCompleteInsert" -%]',
        Result => '
',
    },
    {
        Name     => 'Form without ChallengeToken',
        Template => '
<form action="#"></form>',
        Result => '
<form action="#"></form>',
    },
    {
        Name     => 'Form with ChallengeToken',
        Template => '
<form action="#"></form>',
        Result => '
<form action="#"><input type="hidden" name="ChallengeToken" value="TestToken"/></form>',
        Env => {
            UserChallengeToken => 'TestToken',
            }
    },
    {
        Name     => 'Form with SessionID (no cookie) and ChallengeToken',
        Template => '
<form action="#"></form>',
        Result => '
<form action="#"><input type="hidden" name="ChallengeToken" value="TestToken"/><input type="hidden" name="SID" value="123"/></form>',
        Env => {
            UserChallengeToken => 'TestToken',
            SessionID          => '123',
            SessionName        => 'SID',
            SessionIDCookie    => 0,
            }
    },
    {
        Name     => 'Form with SessionID (with cookie) and ChallengeToken',
        Template => '
<form action="#"></form>',
        Result => '
<form action="#"><input type="hidden" name="ChallengeToken" value="TestToken"/></form>',
        Env => {
            UserChallengeToken => 'TestToken',
            SessionID          => '123',
            SessionName        => 'Session',
            SessionIDCookie    => 1,
            }
    },
    {
        Name     => 'Link with SessionID (no cookie)',
        Template => '
<a href="index.pl?Action=Test">link</a>',
        Result => '
<a href="index.pl?Action=Test;SID=123">link</a>',
        Env => {
            UserChallengeToken => 'TestToken',
            SessionID          => '123',
            SessionName        => 'SID',
            SessionIDCookie    => 0,
            }
    },
    {
        Name     => 'Link with SessionID (with cookie)',
        Template => '
<a href="index.pl?Action=Test">link</a>',
        Result => '
<a href="index.pl?Action=Test">link</a>',
        Env => {
            UserChallengeToken => 'TestToken',
            SessionID          => '123',
            SessionName        => 'Session',
            SessionIDCookie    => 1,
            }
    },

);

for my $Test (@Tests) {

    # Make sure EnvRef is populated every time
    delete $LayoutObject->{EnvRef};
    for my $Key ( sort keys %{ $Test->{Env} || {} } ) {
        $LayoutObject->{$Key} = $Test->{Env}->{$Key};
    }

    for my $Block ( @{ $Test->{BlockData} || [] } ) {
        $LayoutObject->Block( %{$Block} );
    }

    if ( $Test->{AddJSOnDocumentComplete} ) {
        $LayoutObject->AddJSOnDocumentComplete(
            Code => $Test->{AddJSOnDocumentComplete},
        );
    }

    my $Result = $LayoutObject->Output(
        Template => $Test->{Template},
        Data => $Test->{Data} // {},
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        $Test->{Name},
    );
}

# Verify that the TemplateObject is correctly destroyed to make sure there
#   are no ring references.
my $TemplateObject = $LayoutObject->{TemplateObject};
Scalar::Util::weaken($TemplateObject);
undef $LayoutObject;
$Self->False(
    defined $TemplateObject,
    "TemplateObject must be correctly destroyed (no ring references)",
);

1;
