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

# get needed object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::Delete');
my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');

$Kernel::OM->Get('Kernel::System::Cache')->Configure(
    CacheInMemory => 0,
);

my $CustomerUser = $Helper->GetRandomID() . '@example.com';

# create a new tickets
my @Tickets;
for ( 1 .. 4 ) {
    my $TicketNumber = $TicketObject->TicketCreateNumber();
    my $TicketID     = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
        TN           => $TicketNumber,
        Title        => 'Test ticket',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerNo   => '123465',
        CustomerUser => $CustomerUser,
        OwnerID      => 1,
        UserID       => 1,
    );

    $Self->True(
        $TicketID,
        "Ticket is created - $TicketID",
    );

    my %TicketHash = (
        TicketID => $TicketID,
        TN       => $TicketNumber,
    );
    push @Tickets, \%TicketHash;
}

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    1,
    "Maint::Ticket::Delete exit code without arguments.",
);

$ExitCode = $CommandObject->Execute( '--ticket-id', $Tickets[0]->{TicketID}, '--ticket-id', $Tickets[1]->{TicketID} );

$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::Delete exit code - delete by --ticket-id options.",
);

my %TicketIDs = $TicketObject->TicketSearch(
    Result            => 'HASH',
    CustomerUserLogin => $CustomerUser,
    UserID            => 1,
);

$Self->False(
    $TicketIDs{ $Tickets[0]->{TicketID} },
    "Ticket is deleted - $Tickets[0]->{TicketID}",
);

$Self->False(
    $TicketIDs{ $Tickets[1]->{TicketID} },
    "Ticket is deleted - $Tickets[1]->{TicketID}",
);

$ExitCode = $CommandObject->Execute( '--ticket-number', $Tickets[2]->{TN}, '--ticket-number', $Tickets[3]->{TN} );

$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::Delete exit code - delete by --ticket-number options.",
);

%TicketIDs = $TicketObject->TicketSearch(
    Result            => 'HASH',
    CustomerUserLogin => $CustomerUser,
    UserID            => 1,
);

$Self->False(
    $TicketIDs{ $Tickets[2]->{TicketID} },
    "Ticket is deleted - $Tickets[2]->{TicketID}",
);

$Self->False(
    $TicketIDs{ $Tickets[3]->{TicketID} },
    "Ticket is deleted - $Tickets[3]->{TicketID}",
);

$ExitCode = $CommandObject->Execute(
    '--ticket-id',     $Tickets[0]->{TicketID}, '--ticket-id',     $Tickets[1]->{TicketID},
    '--ticket-number', $Tickets[2]->{TN},       '--ticket-number', $Tickets[3]->{TN}
);

$Self->Is(
    $ExitCode,
    1,
    "Maint::Ticket::Delete exit code - try to delete with wrong ticket numbers and ticket IDs.",
);

# cleanup is done by RestoreDatabase

1;
