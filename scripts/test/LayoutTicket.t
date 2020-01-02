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

use vars (qw($Self %Param));

my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $UploadCacheObject    = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create test data
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);

# add HTML
my $HTML = '<html>
<head>
<title>Test</title>
</head>
<body>
<b>Test HTML document.</b>
<img src="cid:1234" border="0">
<img src="Untitled%20Attachment" border="0">
Special case from Lotus Notes:
<img src=cid:_1_09B1841409B1651C003EDE23C325785D border="0">
</body>
</html>';

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer@example.com>',
    Subject              => 'Fax Agreement laalala',
    Body                 => $HTML,
    ContentType          => 'text/html; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,                                        # if you don't want to send agent notifications
);

$ArticleBackendObject->ArticleWriteAttachment(
    Filename    => 'some.html',
    MimeType    => 'text/html',
    ContentType => 'text/html',
    Content     => '<html>some html</html>',
    ContentID   => '',
    ArticleID   => $ArticleID,
    UserID      => 1,
);

$ArticleBackendObject->ArticleWriteAttachment(
    Filename    => 'image.png',
    MimeType    => 'image/png',
    ContentType => 'image/png',
    Content     => '#fake image#',
    ContentID   => '1234',
    ArticleID   => $ArticleID,
    UserID      => 1,
);

$ArticleBackendObject->ArticleWriteAttachment(
    Filename    => 'image2.png',
    MimeType    => 'image/png',
    ContentType => 'image/png',
    Content     => '#fake image2#',
    ArticleID   => $ArticleID,
    UserID      => 1,
);
$ArticleBackendObject->ArticleWriteAttachment(
    Filename    => 'image3.png',
    MimeType    => 'image/png',
    ContentType => 'image/png',
    Content     => '#fake image3#',
    ArticleID   => $ArticleID,
    UserID      => 1,
);
$ArticleBackendObject->ArticleWriteAttachment(
    Filename    => 'image4.png',
    MimeType    => 'image/png',
    ContentType => 'image/png',
    Content     => '#fake image3#',
    ContentID   => '_1_09B1841409B1651C003EDE23C325785D',
    ArticleID   => $ArticleID,
    UserID      => 1,
);
$ArticleBackendObject->ArticleWriteAttachment(
    Filename    => 'image.bmp',
    MimeType    => 'image/bmp',
    ContentType => 'image/bmp',
    Content     => '#fake image#',
    ContentID   => 'Untitled%20Attachment',
    ArticleID   => $ArticleID,
    UserID      => 1,
);

# defined tests
my @Tests = (
    {
        Config => {
            'Frontend::RichText' => 1,
        },
        BodyRegExp => [
            '<b>Test HTML document.<\/b>',
            '<img src="[^;]+?Action=PictureUpload;FormID=[0-9.]+;SessionID=123;ContentID=1234" border="0">',
        ],
        AttachmentsInclude => 1,
        Attachment         => {
            'image.png'  => 1,
            'image2.png' => 1,
            'image3.png' => 1,
            'some.html'  => 1,
        }
    },
    {
        Config => {
            'Frontend::RichText' => 1,
        },
        BodyRegExp => [
            '<b>Test HTML document.<\/b>',
            '<img src="[^;]+?Action=PictureUpload;FormID=[0-9.]+;SessionID=123;ContentID=_1_09B1841409B1651C003EDE23C325785D" border="0">',
        ],
        AttachmentsInclude => 1,
        Attachment         => {
            'image4.png' => 1,
            'some.html'  => 1,
        }
    },
    {
        Config => {
            'Frontend::RichText' => 1,
        },
        BodyRegExp => [
            '<b>Test HTML document.<\/b>',
            '<img src="[^;]+?Action=PictureUpload;FormID=[0-9.]+;SessionID=123;ContentID=1234" border="0">',
        ],
        AttachmentsInclude => 0,
        Attachment         => {
            'image.png' => 1,
        }
    },
    {
        Config => {
            'Frontend::RichText' => 0,
        },
        BodyRegExp => [
            'Test HTML document.'
        ],
        AttachmentsInclude => 1,
        Attachment         => {
            'file-2'     => 0,
            'some.html'  => 1,
            'image.png'  => 1,
            'image.png'  => 1,
            'image2.png' => 1,
            'image3.png' => 1,
        },
    },
    {
        Config => {
            'Frontend::RichText' => 0,
        },
        BodyRegExp => [
            'Test HTML document.'
        ],
        AttachmentsInclude => 0,
        Attachment         => {
            'file-2' => 0,
        },
    },
    {
        Config => {
            'Frontend::RichText' => 1,
        },
        BodyRegExp => [
            '<img src="[^;]+?Action=PictureUpload;FormID=[0-9.]+;SessionID=123;ContentID=Untitled%2520Attachment" border="0">',
        ],
        AttachmentsInclude => 0,
        Attachment         => {
            'image.bmp' => 1,
        },
    },
);

# get layout object
$Kernel::OM->ObjectParamAdd(
    'Kernel::Output::HTML::Layout' => {
        UserChallengeToken => 'TestToken',
        UserID             => 1,
        Lang               => 'de',
        SessionID          => 123,
    },
);
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

# get form ID
my $FormID = $UploadCacheObject->FormIDCreate();

# execute tests
for my $Test (@Tests) {

    # set config settings
    for my $Key ( sort keys %{ $Test->{Config} } ) {
        $ConfigObject->Set(
            Key   => $Key,
            Value => $Test->{Config}->{$Key},
        );
    }

    # quote article
    my $HTMLBody = $LayoutObject->ArticleQuote(
        TicketID           => $TicketID,
        ArticleID          => $ArticleID,
        FormID             => $FormID,
        UploadCacheObject  => $UploadCacheObject,
        AttachmentsInclude => $Test->{AttachmentsInclude},
    );

    # check body
    for my $RegExp ( @{ $Test->{BodyRegExp} } ) {
        if ( $HTMLBody =~ /$RegExp/ ) {
            $Self->True(
                1,
                "BodyRegExp - $RegExp",
            );
        }
        else {
            $Self->True(
                0,
                "BodyRegExp - $RegExp",
            );
        }
    }

    # check attachments
    my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
        FormID => $FormID,
    );
    ATTACHMENT:
    for my $Filename ( sort keys %{ $Test->{Attachment} } ) {
        for my $Attachment (@Attachments) {
            if ( $Attachment->{Filename} eq $Filename && $Test->{Attachment}->{$Filename} ) {
                $Self->True(
                    1,
                    "Attachment is included as expected - $Filename",
                );
                next ATTACHMENT;
            }
            elsif ( $Attachment->{Filename} eq $Filename && !$Test->{Attachment}->{$Filename} ) {
                $Self->True(
                    0,
                    "Attachment is included, but it is not expected - $Filename",
                );
                next ATTACHMENT;
            }
        }
        if ( $Test->{Attachment}->{$Filename} ) {
            $Self->True(
                0,
                "Attachment is not included, but it is not expected - $Filename",
            );
        }
        else {
            $Self->True(
                1,
                "Attachment is not included as expected - $Filename",
            );
        }

    }
}

# cleanup is done by RestoreDatabase

1;
