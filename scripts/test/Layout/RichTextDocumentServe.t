# --
# scripts/test/Layout/RichTextDocumentServe.t - layout testscript
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
        Name => '',
        Data => {
            Content     => '<img src="cid:1234567890ABCDEF">',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                '<img src="No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;SessionID=123">',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Name => '',
        Data => {
            Content     => "<img border=\"0\" src=\"cid:1234567890ABCDEF\">",
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                '<img border="0" src="No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;SessionID=123">',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Name => '',
        Data => {
            Content     => "<img border=\"0\" \nsrc=\"cid:1234567890ABCDEF\">",
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                "<img border=\"0\" \nsrc=\"No-\$ENV{\"SCRIPT_NAME\"}?Action=SomeAction;FileID=0;SessionID=123\">",
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Name => '',
        Data => {
            Content     => '<img src=cid:1234567890ABCDEF>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                '<img src="No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;SessionID=123">',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Name => '',
        Data => {
            Content     => '<img src=cid:1234567890ABCDEF />',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                '<img src="No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;SessionID=123" />',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Name => '',
        Data => {
            Content     => '<img src=\'cid:1234567890ABCDEF\' />',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<1234567890ABCDEF>',
                },
        },
        Result => {
            Content =>
                '<img src=\'No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;SessionID=123\' />',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Name => '',
        Data => {
            Content     => '<img src=\'Untitled%20Attachment\' />',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 =>
                {
                ContentID => '<Untitled%20Attachment>',
                },
        },
        Result => {
            Content =>
                '<img src=\'No-$ENV{"SCRIPT_NAME"}?Action=SomeAction;FileID=0;SessionID=123\' />',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Name => 'drop script tag',
        Data => {
            Content     => '1<script></script>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<Untitled%20Attachment>',
            },
        },
        Result => {
            Content     => '1',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Name => 'keep script tag',
        Data => {
            Content     => '1<script></script>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<Untitled%20Attachment>',
            },
        },
        LoadInlineContent => 1,
        Result            => {
            Content     => '1<script></script>',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Name => 'drop external image',
        Data => {
            Content     => '1<img src="http://google.com"/>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<Untitled%20Attachment>',
            },
        },
        Result => {
            Content => '

<div style="margin: 5px 0; padding: 0px; border: 1px solid #999; border-radius: 2px; -moz-border-radius: 2px; -webkit-border-radius: 2px;">
    <div style="padding: 5px; background-color: #DDD; font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 11px; text-align: center;">
        Zum Schutz Ihrer Privatsphäre wurden entfernte Inhalte blockiert.
        <a href="No-$ENV{"SCRIPT_NAME"}?;LoadExternalImages=1">Blockierte Inhalte laden.</a>
    </div>
</div>1',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Name => 'keep external image',
        Data => {
            Content     => '1<img src="http://google.com"/>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<Untitled%20Attachment>',
            },
        },
        LoadExternalImages => 1,
        Result             => {
            Content     => '1<img src="http://google.com"/>',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Name => 'transform content charset',
        Data => {
            Content => <<EOF,
<!DOCTYPE html SYSTEM "about:legacy-compat">
<html lang="de-de">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
    <p>Some note about UTF8, UTF-8, utf8 and utf-8.</p>
    <p>Some note about ISO-8859-1 and iso-8859-1.</p>
</body>
</html>
EOF
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<Untitled%20Attachment>',
            },
        },
        LoadExternalImages => 1,
        Result             => {
            Content => <<EOF,
<!DOCTYPE html SYSTEM "about:legacy-compat">
<html lang="de-de">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
    <p>Some note about UTF8, UTF-8, utf8 and utf-8.</p>
    <p>Some note about ISO-8859-1 and iso-8859-1.</p>
</body>
</html>
EOF
            ContentType => 'text/html; charset="utf-8"',
        },
    },
);

for my $Test (@Tests) {
    my %HTML = $LayoutObject->RichTextDocumentServe(
        %{$Test},
    );
    $Self->Is(
        $HTML{Content},
        $Test->{Result}->{Content},
        "$Test->{Name} - Content",
    );
    $Self->Is(
        $HTML{ContentType},
        $Test->{Result}->{ContentType},
        "$Test->{Name} - ContentType",
    );
}

1;
