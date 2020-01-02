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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::Dump');

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    1,
    "Maint::Ticket::Dump exit code without arguments",
);

# create a new ticket
my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID,
    "Ticket created",
);
my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

my %ArticleHash = (
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer A <customer-a@example.com>',
    Cc                   => 'Some Customer B <customer-b@example.com>',
    Bcc                  => 'Some Customer C <customer-c@example.com>',
    Subject              => 'some short description',
    Body                 => "the message\ntext",
    Charset              => 'ISO-8859-15',
    MimeType             => 'text/plain',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    UnlockOnAway         => 1,
    FromRealname         => 'Some Agent',
);

my $ArticleBackendObject = $Kernel::OM->Get("Kernel::System::Ticket::Article::Backend::Email");

# Create test article.
my $ArticleID = $ArticleBackendObject->ArticleCreate(
    %ArticleHash,
);

$Self->True(
    $ArticleID,
    "Article created",
);

# TODO: article fields testing

my $Result;

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $CommandObject->Execute( $TicketID, '--no-ansi' );
}

$Self->Is(
    $ExitCode,
    0,
    "Exit code",
);

my @Tests = (
    {
        Field => 'TicketNumber',
        Match => qr{^TicketNumber:\s+$Ticket{TicketNumber}$}sm,
    },
    {
        Field => 'TicketID',
        Match => qr{^TicketID:\s+$Ticket{TicketID}$}sm,
    },
    {
        Field => 'Title',
        Match => qr{^Title:\s+My ticket created by Agent A$}sm,
    },
    {
        Field => 'Queue',
        Match => qr{^Queue:\s+Raw$}sm,
    },
    {
        Field => 'State',
        Match => qr{^State:\s+open$}sm,
    },
    {
        Field => 'Lock',
        Match => qr{^Lock:\s+unlock$}sm,
    },
    {
        Field => 'CustomerID',
        Match => qr{^CustomerID:\s+123465$}sm,
    },
    {
        Field => 'CustomerUserID',
        Match => qr{^CustomerUserID:\s+customer\@example.com$}sm,
    },
    {
        Field => 'ArticleID',
        Match => qr{^ArticleID:\s+$ArticleID$}sm,
    },
    {
        Field => 'SenderType',
        Match => qr{^SenderType:\s+agent}sm,
    },
    {
        Field => 'Channel',
        Match => qr{^Channel:\s+Email$}sm,
    },
    {
        Field => 'From',
        Match => qr{^From:\s+Some Agent <email\@example.com>$}sm,
    },
    {
        Field => 'To',
        Match => qr{^To:\s+Some Customer A <customer-a\@example.com>$}sm,
    },
    {
        Field => 'Cc',
        Match => qr{^Cc:\s+Some Customer B <customer-b\@example.com>$}sm,
    },
    {
        Field => 'Bcc',
        Match => qr{^Bcc:\s+Some Customer C <customer-c\@example.com>$}sm,
    },
    {
        Field => 'Subject',
        Match => qr{^Subject:\s+some short description$}sm,
    },
    {
        Field => 'Body',
        Match => qr{^the message\ntext$}sm,
    },
);

for my $Test (@Tests) {
    $Self->True(
        scalar $Result =~ $Test->{Match},
        "$Test->{Field} found",
    );
}

# cleanup is done by RestoreDatabase

1;
