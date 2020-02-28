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
use Digest::MD5 qw(md5_hex);

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
$Helper->FixedTimeSet();

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

my %ArticleHash = (
    TicketID               => $TicketID,
    CommunicationChannelID => 1,
    IsVisibleForCustomer   => 0,
    SenderTypeID           => 1,
    UserID                 => 1,
);
my $ArticleID = $ArticleBackendObject->_MetaArticleCreate(%ArticleHash);

$Self->True(
    $ArticleID,
    '_MetaArticleCreate() first article',
);

my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

delete $ArticleHash{UserID};
$ArticleHash{ArticleID}     = $ArticleID;
$ArticleHash{ArticleNumber} = 1;
$ArticleHash{CreateBy}      = 1;
$ArticleHash{ChangeBy}      = 1;
$ArticleHash{CreateTime}    = $TimeStamp;
$ArticleHash{ChangeTime}    = $TimeStamp;

my %ArticleHash2 = (
    TicketID               => $TicketID,
    CommunicationChannelID => 2,
    IsVisibleForCustomer   => 1,
    SenderTypeID           => 2,
    UserID                 => 1,
);
my $ArticleID2 = $ArticleBackendObject->_MetaArticleCreate(%ArticleHash2);

$Self->True(
    $ArticleID2,
    '_MetaArticleCreate() second article',
);

delete $ArticleHash2{UserID};
$ArticleHash2{ArticleID}     = $ArticleID2;
$ArticleHash2{ArticleNumber} = 2;
$ArticleHash2{CreateBy}      = 1;
$ArticleHash2{ChangeBy}      = 1;
$ArticleHash2{CreateTime}    = $TimeStamp;
$ArticleHash2{ChangeTime}    = $TimeStamp;

my %ResultHash = $ArticleBackendObject->_MetaArticleGet(
    ArticleID => $ArticleID,
    TicketID  => $TicketID,
);

$Self->IsDeeply(
    \%ResultHash,
    \%ArticleHash,
    '_MetaArticleGet()',
);

my @MetaArticleIndex = (
    {%ArticleHash},
    {%ArticleHash2},
);

$Self->IsDeeply(
    [ $ArticleObject->_MetaArticleList( TicketID => $TicketID ) ],
    \@MetaArticleIndex,
    'MetaArticleIndex()',
);

my $TicketIDLookup = $ArticleObject->TicketIDLookup(
    ArticleID => $ArticleID,
);

$Self->Is(
    $TicketIDLookup,
    $TicketID,
    'TicketIDLookup() - First article'
);

my $TicketIDLookup2 = $ArticleObject->TicketIDLookup(
    ArticleID => $ArticleID2,
);

$Self->Is(
    $TicketIDLookup2,
    $TicketID,
    'TicketIDLookup() - Second article'
);

my $TicketIDLookup3 = $ArticleObject->TicketIDLookup(
    ArticleID => 999_999_999,
);

$Self->False(
    $TicketIDLookup3,
    'TicketIDLookup() - Non-existent article'
);

#
# ArticleList tests
#

my @ArticleListTests = (
    {
        Name   => 'no filter',
        Filter => {},
        Result => [
            {%ArticleHash},
            {%ArticleHash2},
        ],
    },
    {
        Name   => 'OnlyFirst',
        Filter => {
            OnlyFirst => 1,
        },
        Result => [
            {%ArticleHash},
        ],
    },
    {
        Name   => 'OnlyLast',
        Filter => {
            OnlyLast => 1,
        },
        Result => [
            {%ArticleHash2},
        ],
    },
    {
        Name   => 'CommunicationChannelID',
        Filter => {
            CommunicationChannelID => 1,
        },
        Result => [
            {%ArticleHash},
        ],
    },
    {
        Name   => 'SenderTypeID',
        Filter => {
            SenderTypeID => 2,
        },
        Result => [
            {%ArticleHash2},
        ],
    },
    {
        Name   => 'IsVisibleForCustomer',
        Filter => {
            IsVisibleForCustomer => 0,
        },
        Result => [
            {%ArticleHash},
        ],
    },
    {
        Name   => 'IsVisibleForCustomer + OnlyFirst',
        Filter => {
            IsVisibleForCustomer => 0,
            OnlyFirst            => 1,
        },
        Result => [
            {%ArticleHash},
        ],
    },
    {
        Name   => 'IsVisibleForCustomer + OnlyLast',
        Filter => {
            IsVisibleForCustomer => 0,
            OnlyLast             => 1,
        },
        Result => [
            {%ArticleHash},
        ],
    },
    {
        Name   => 'OnlyFirst + OnlyLast (error)',
        Filter => {
            OnlyFirst => 1,
            OnlyLast  => 1,
        },
        Result => [],
    },
);

for my $Test (@ArticleListTests) {
    $Self->IsDeeply(
        [
            $ArticleObject->ArticleList(
                TicketID => $TicketID,
                %{ $Test->{Filter} },
            ),
        ],
        $Test->{Result},
        "ArticleList() - $Test->{Name}"
    );
}

my $SuccessUpdate = $ArticleBackendObject->_MetaArticleUpdate(
    ArticleID => $ArticleID,
    TicketID  => $TicketID,
    Key       => 'SenderTypeID',
    Value     => 2,
    UserID    => 1,
);

$Self->True(
    $SuccessUpdate,
    '_MetaArticleUpdate() - SenderTypeID'
);

$ArticleHash{SenderTypeID} = 2;
$MetaArticleIndex[0]->{SenderTypeID} = 2;

%ResultHash = $ArticleBackendObject->_MetaArticleGet(
    ArticleID => $ArticleID,
    TicketID  => $TicketID,
);

$Self->IsDeeply(
    \%ResultHash,
    \%ArticleHash,
    '_MetaArticleGet() - after update of SenderType',
);

$Self->IsDeeply(
    [ $ArticleObject->_MetaArticleList( TicketID => $TicketID ) ],
    \@MetaArticleIndex,
    'MetaArticleIndex()'
);

$SuccessUpdate = $ArticleBackendObject->_MetaArticleUpdate(
    ArticleID => $ArticleID,
    TicketID  => $TicketID,
    Key       => 'IsVisibleForCustomer',
    Value     => 1,
    UserID    => 1,
);

$Self->True(
    $SuccessUpdate,
    '_MetaArticleUpdate() - IsVisibleForCustomer'
);

$ArticleHash{IsVisibleForCustomer} = 1;
$MetaArticleIndex[0]->{IsVisibleForCustomer} = 1;

%ResultHash = $ArticleBackendObject->_MetaArticleGet(
    ArticleID => $ArticleID,
    TicketID  => $TicketID,
);

$Self->IsDeeply(
    \%ResultHash,
    \%ArticleHash,
    '_MetaArticleGet() - after update of IsVisibleForCustomer'
);

$Self->IsDeeply(
    [ $ArticleObject->_MetaArticleList( TicketID => $TicketID ) ],
    \@MetaArticleIndex,
    'MetaArticleIndex()'
);

$Helper->FixedTimeAddSeconds(60);

$SuccessUpdate = $ArticleBackendObject->_MetaArticleUpdate(
    ArticleID => $ArticleID,
    TicketID  => $TicketID,
    UserID    => 1,
);

$Self->True(
    $SuccessUpdate,
    '_MetaArticleUpdate() - Update ChangeTime only'
);

$ArticleHash{ChangeTime} = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();
$MetaArticleIndex[0]->{ChangeTime} = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

%ResultHash = $ArticleBackendObject->_MetaArticleGet(
    ArticleID => $ArticleID,
    TicketID  => $TicketID,
);

$Self->IsDeeply(
    \%ResultHash,
    \%ArticleHash,
    '_MetaArticleGet() - after update of ChangeTime'
);

$Self->IsDeeply(
    [ $ArticleObject->_MetaArticleList( TicketID => $TicketID ) ],
    \@MetaArticleIndex,
    'MetaArticleIndex()'
);

my $SuccessDelete = $ArticleBackendObject->_MetaArticleDelete(
    ArticleID => $ArticleID,
    TicketID  => $TicketID,
    UserID    => 1,
);

$Self->True(
    $SuccessDelete,
    '_MetaArticleDelete()'
);

%ResultHash = $ArticleBackendObject->_MetaArticleGet(
    ArticleID => $ArticleID,
    TicketID  => $TicketID,
);

$Self->IsDeeply(
    \%ResultHash,
    {},
    '_MetaArticleGet() after delete'
);

# Check default image for avatar.
# See bug#14615 for more information.
my $DefaultImage = 'mp';
$Helper->ConfigSettingChange(
    Valid => 0,
    Key   => "Frontend::Gravatar::ArticleDefaultImage",
    Value => $DefaultImage,
);

my $Email       = 'someagentUnitTest@example.com';
my $SenderImage = $Kernel::OM->Get('Kernel::Output::HTML::TicketZoom::Agent::Base')->_ArticleSenderImage(
    Sender => "Some Agent <$Email>",
);

$Self->Is(
    $SenderImage,
    '//www.gravatar.com/avatar/' . md5_hex( lc $Email ) . '?s=80&d=' . $DefaultImage,
    'Avatar link is generated successfully'
);

# Test case for bug#14953 when in email there are utf-8 chars.
$Email       = 'нештотест@example.com';
$SenderImage = $Kernel::OM->Get('Kernel::Output::HTML::TicketZoom::Agent::Base')->_ArticleSenderImage(
    Sender => "Some Agent <$Email>",
);
$Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Email );
$Self->Is(
    $SenderImage,
    '//www.gravatar.com/avatar/' . md5_hex( lc $Email ) . '?s=80&d=' . $DefaultImage,
    'Avatar link is generated successfully with utf-8 chars.'
);

# cleanup is done by RestoreDatabase.

1;
