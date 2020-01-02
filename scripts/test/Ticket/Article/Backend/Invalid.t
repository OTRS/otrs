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

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $EmailBackendObject   = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');
my $InvalidBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Invalid');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
$Helper->FixedTimeSet();

# Create test ticket.
my $TicketID = $TicketObject->TicketCreate(
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

my $MessageID   = '<' . $Helper->GetRandomID() . '@example.com>';
my %ArticleHash = (
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer A <customer-a@example.com>',
    Cc                   => 'Some Customer B <customer-b@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    MessageID            => $MessageID,
    Charset              => 'ISO-8859-15',
    MimeType             => 'text/plain',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    UnlockOnAway         => 1,
);

my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

# Create test article via email backend.
my $ArticleID = $EmailBackendObject->ArticleCreate(
    %ArticleHash,
);
$Self->True(
    $ArticleID,
    "ArticleCreate() - Added article $ArticleID via email backend"
);
$ArticleHash{ArticleID}     = $ArticleID;
$ArticleHash{ArticleNumber} = 1;
$ArticleHash{CreateBy}      = 1;
$ArticleHash{CreateTime}    = $TimeStamp;

my %ResultHash = $EmailBackendObject->ArticleGet(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
);

KEY:
for my $Key (
    qw(TicketID ArticleID From ReplyTo To Cc Subject MessageID InReplyTo References ContentType Body SenderType SenderTypeID IsVisibleForCustomer CreateBy CreateTime Charset MimeType FromRealname ToRealname CcRealname)
    )
{
    next KEY if !defined $ArticleHash{$Key};

    $Self->Is(
        $ResultHash{$Key},
        $ArticleHash{$Key},
        "ArticleGet - Value for $Key"
    );
}

$Self->Is(
    scalar $InvalidBackendObject->ArticleCreate(%ArticleHash),
    scalar undef,
    'Invalid backend dummy ArticleCreate()',
);

my $UpdateResult = $InvalidBackendObject->ArticleUpdate(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    Key       => 'IsVisibleForCustomer',
    Value     => 1,
    UserID    => 1,
);
$Self->Is(
    $UpdateResult,
    scalar undef,
    'Invalid backend dummy ArticleUpdate()',
);

# Construct expected meta article data.
my %MetaArticleHash;
my @SliceFields = qw(TicketID ArticleID ArticleNumber IsVisibleForCustomer CreateBy CreateTime);
@MetaArticleHash{@SliceFields} = @ArticleHash{@SliceFields};

$MetaArticleHash{ChangeBy}               = 1;
$MetaArticleHash{ChangeTime}             = $TimeStamp;
$MetaArticleHash{CommunicationChannelID} = 1;
$MetaArticleHash{SenderType}             = 'agent';
$MetaArticleHash{SenderTypeID}           = 1;

$Self->IsDeeply(
    { $InvalidBackendObject->ArticleGet(%ArticleHash) },
    \%MetaArticleHash,
    'Invalid backend ArticleGet() returns meta article data',
);

$Self->Is(
    scalar $InvalidBackendObject->ArticleSearchableContentGet(%ArticleHash),
    scalar undef,
    'Invalid backend dummy ArticleSearchableContentGet()',
);

$Self->Is(
    scalar $InvalidBackendObject->BackendSearchableFieldsGet(%ArticleHash),
    scalar undef,
    'Invalid backend dummy BackendSearchableFieldsGet()',
);

$Self->Is(
    scalar $InvalidBackendObject->ArticleDelete( %ArticleHash, UserID => 1 ),
    1,
    'Invalid backend ArticleDelete() success',
);

$Self->IsDeeply(
    { $InvalidBackendObject->ArticleGet(%ArticleHash) },
    {},
    'Invalid backend ArticleGet() after ArticleDelete()',
);

$Self->IsDeeply(
    { $EmailBackendObject->ArticleGet(%ArticleHash) },
    {},
    'Email backend ArticleGet() after ArticleDelete()',
);

# cleanup is done by RestoreDatabase.

1;
