# --
# Maint/Ticket/Dump.t - command tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

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

use Data::Dumper;
print STDERR Dumper( \$Result );

$Self->True(
    index( $Result, "Title: My ticket created by Agent A" ) > -1,
    "Title found",
);

my $Deleted = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $Deleted,
    "Ticket deleted",
);

1;
