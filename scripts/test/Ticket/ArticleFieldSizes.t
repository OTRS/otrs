# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $MainObject    = $Kernel::OM->Get('Kernel::System::Main');
my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

my $SmallEmail     = ( 'x' x 900 ) . '@localunittest.com';
my $SmallReference = "<$SmallEmail>";

my $MediumEmail = join( ',', ( ($SmallEmail) x 20 ) );
my $MediumReference = $SmallReference x 20;

my $LargeEmail = join( ',', ( ($SmallEmail) x 200 ) );
my $LargeReference = $SmallReference x 200;

my @ArticleTests = (
    {
        Name        => 'Article with all fields < 998',
        ArticleData => {
            ArticleType    => 'note-internal',
            SenderType     => 'agent',
            From           => $SmallEmail,
            To             => $SmallEmail,
            Cc             => $SmallEmail,
            ReplyTo        => $SmallEmail,
            MessageID      => $SmallReference,
            References     => $SmallReference,
            InReplyTo      => $SmallReference,
            Subject        => 'some short description',
            Body           => 'the message text',
            Charset        => 'iso-8859-15',
            MimeType       => 'text/plain',
            Loop           => 0,
            HistoryType    => 'AddNote',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        },
    },
    {
        Name        => 'Article with allowed fields > 3800 (bug#5420)',
        ArticleData => {
            ArticleType    => 'note-internal',
            SenderType     => 'agent',
            From           => $MediumEmail,
            To             => $MediumEmail,
            Cc             => $MediumEmail,
            ReplyTo        => $MediumEmail,
            MessageID      => $SmallReference,
            References     => $MediumReference,
            InReplyTo      => $MediumReference,
            Subject        => 'some short description',
            Body           => 'the message text',
            Charset        => 'iso-8859-15',
            MimeType       => 'text/plain',
            Loop           => 0,
            HistoryType    => 'AddNote',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        },
    },
    {
        Name        => 'Article with huge fields (bug#5420)',
        ArticleData => {
            ArticleType    => 'note-internal',
            SenderType     => 'agent',
            From           => $LargeEmail,
            To             => $LargeEmail,
            Cc             => $LargeEmail,
            ReplyTo        => $LargeEmail,
            MessageID      => $SmallReference,
            References     => $LargeReference,
            InReplyTo      => $LargeReference,
            Subject        => 'some short description',
            Body           => 'the message text',
            Charset        => 'iso-8859-15',
            MimeType       => 'text/plain',
            Loop           => 0,
            HistoryType    => 'AddNote',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        },
    },
);

my %Article;
my $ArticleID;
my $ArticleCount = 0;

TEST:
for my $Test (@ArticleTests) {

    # create article
    $ArticleID = $ArticleObject->ArticleCreate(
        TicketID => $TicketID,
        %{ $Test->{ArticleData} },
    );

    $Self->True(
        $ArticleID,
        "$Test->{Name} - ArticleCreate()",
    );

    my %Article = $ArticleObject->ArticleGet(
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    KEY:
    for my $Key ( sort keys %{ $Test->{ArticleData} } ) {
        next KEY if $Key eq 'HistoryType';
        next KEY if $Key eq 'HistoryComment';
        next KEY if $Key eq 'UserID';
        next KEY if $Key eq 'Loop';
        $Self->Is(
            $Article{$Key},
            $Test->{ArticleData}->{$Key},
            "$Test->{Name} - ArticleGet() $Key"

            )
    }
}

# cleanup is done by RestoreDatabase.

1;
