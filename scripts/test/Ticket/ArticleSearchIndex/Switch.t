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

#
# This test should make sure that after switching from StaticDB to RuntimeDB,
# tickets with stale entries in article_search can still be deleted (see bug#11677).
#

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$ConfigObject->Set(
    Key   => 'Ticket::SearchIndexModule',
    Value => 'Kernel::System::Ticket::ArticleSearchIndex::StaticDB',
);

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

$Self->True(
    $TicketObject->isa('Kernel::System::Ticket::ArticleSearchIndex::StaticDB'),
    "TicketObject loaded the correct backend",
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create some content
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

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID    => $TicketID,
    ArticleType => 'note-internal',
    SenderType  => 'agent',
    From        => 'Some Agent <email@example.com>',
    To          => 'Some Customer <customer@example.com>',
    Subject     => 'some short description',
    Body        => 'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,                                   # if you don't want to send agent notifications
);
$Self->True(
    $ArticleID,
    'ArticleCreate()',
);

my $IndexBuilt = $TicketObject->ArticleIndexBuild(
    ArticleID => $ArticleID,
    UserID    => 1,
);
$Self->True(
    $ArticleID,
    'Search index was created.',
);

# Make sure that the TicketObject gets recreated for each loop.
$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );

$ConfigObject->Set(
    Key   => 'Ticket::SearchIndexModule',
    Value => 'Kernel::System::Ticket::ArticleSearchIndex::RuntimeDB',
);

$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my $Delete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Delete,
    'TicketDelete()',
);

# cleanup is done by RestoreDatabase.

1;
