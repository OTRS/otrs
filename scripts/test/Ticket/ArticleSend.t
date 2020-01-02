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

my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disable email addresses checking.
$HelperObject->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

$Self->True(
    $Success,
    'Set Email Test backend with true',
);

my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');

# testing ArticleSend, especially for bug#8828 (attachments)
# create a ticket first
my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'Some Ticket_Title',
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

# get example attachment data
my $Location       = $ConfigObject->Get('Home') . "/scripts/test/sample/Ticket/Ticket-Article-Test1.pdf";
my $FileContentRef = $MainObject->FileRead(
    Location => $Location,
    Mode     => 'binmode',
);
my $FileContent = ${$FileContentRef};

my @ArticleTests = (
    {
        Name        => 'First article',
        ArticleData => {
            SenderType           => 'agent',
            IsVisibleForCustomer => 1,
            From                 => 'Some Agent <email@example.com>',
            To                   => 'Some Customer A <customer-a@example.com>',
            Subject              => 'some short description',
            Body                 => 'the message text',
            Charset              => 'iso-8859-15',
            MimeType             => 'text/plain',
            Loop                 => 0,
            HistoryType          => 'SendAnswer',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        },
        ExpectedAttachmentCount => 0,
        ExpectedToArray         => [
            'customer-a@example.com',
        ],
    },
    {
        Name        => 'With base64-encoded image',
        ArticleData => {
            SenderType           => 'agent',
            IsVisibleForCustomer => 1,
            From                 => 'Some Agent <email@example.com>',
            To                   => 'Some Customer A <customer-a@example.com>',
            Subject              => 'some short description',
            Body =>
                '<p>the message text with an image <strong>here</strong>: <img alt="" src="data:image/png;base64,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" /> and some more text</p>',
            Charset        => 'iso-8859-15',
            MimeType       => 'text/html',
            Loop           => 0,
            HistoryType    => 'SendAnswer',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        },
        ExpectedAttachmentCount => 1,
        ExpectedToArray         => [
            'customer-a@example.com',
        ],
    },
    {
        Name        => 'With normal attachment (image)',
        ArticleData => {
            SenderType           => 'agent',
            IsVisibleForCustomer => 1,
            From                 => 'Some Agent <email@example.com>',
            To                   => 'Some Customer A <customer-a@example.com>',
            Subject              => 'some short description',
            Body                 => 'the message text',
            Attachment           => [
                {
                    Content     => $FileContent,
                    ContentType => 'application/pdf',
                    Filename    => 'Ticket-Article-Test1.pdf',
                },
            ],
            Charset        => 'iso-8859-15',
            MimeType       => 'text/plain',
            Loop           => 0,
            HistoryType    => 'SendAnswer',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        },
        ExpectedAttachmentCount => 1,
        ExpectedToArray         => [
            'customer-a@example.com',
        ],
    },
);

my %Article;
my $ArticleID;
my %AttachmentIndex;
my $ArticleAttachmentCount;
my $ArticleCount = 0;
my $Emails;
my $Email;
my $MailQueueObj = $Kernel::OM->Get('Kernel::System::MailQueue');

TEST:
for my $Test (@ArticleTests) {

    $Success = $TestEmailObject->CleanUp();
    $Self->True(
        $Success,
        $Test->{Name} . ' - Cleanup Email backend',
    );

    $Self->IsDeeply(
        $TestEmailObject->EmailsGet(),
        [],
        $Test->{Name} . ' - Test backend empty after cleanup',
    );

    # create article
    $ArticleID = $ArticleBackendObject->ArticleSend(
        TicketID => $TicketID,
        %{ $Test->{ArticleData} },
    );

    $Self->True(
        $ArticleID,
        $Test->{Name} . ' - ArticleSend()',
    );

    # Force email queue handling for this object
    my $Item   = $MailQueueObj->Get( ArticleID => $ArticleID );
    my $Result = $MailQueueObj->Send( %{$Item} );

    # check that email was sent
    $Emails = $TestEmailObject->EmailsGet();

    # because of cleanup before (see above), there is only one email
    $Self->Is(
        scalar @{$Emails},
        1,
        $Test->{Name} . ' - EmailsGet()',
    );

    # get first (and only) email
    $Email = $Emails->[0];

    $Self->IsDeeply(
        $Email->{ToArray},
        $Test->{ExpectedToArray},
        $Test->{Name} . ' - EmailsGet() To',
    );

    # check article count
    $ArticleCount++;
    $Self->Is(
        scalar $ArticleObject->ArticleList( TicketID => $TicketID ),
        $ArticleCount,
        $Test->{Name} . ' - ArticleCount',
    );

    # check article content
    %Article = $ArticleBackendObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );

    $Self->True(
        $Article{From} eq $Test->{ArticleData}->{From},
        $Test->{Name} . ' - ArticleGet()',
    );

    # check article attachments
    %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID        => $ArticleID,
        ExcludePlainText => 1,
        ExcludeHTMLBody  => 1,
    );

    $ArticleAttachmentCount = scalar keys %AttachmentIndex;

    $Self->Is(
        $ArticleAttachmentCount,
        $Test->{ExpectedAttachmentCount},
        $Test->{Name} . ' - Attachment Count'
    );

}

# cleanup is done by RestoreDatabase.

1;
