# --
# Maint/PostMaster/Read.t - command tests
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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::PostMaster::Read');

my ( $ExitCode, $Result );

{
    local *STDIN;
    open STDIN, '<:utf8', \'';    ## no critic
    $ExitCode = $CommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    1,
    "Maint::PostMaster::Read exit code without email input",
);

{
    my $Email = "From: me\@home.com\nTo: you\@home.com\nSubject: Test\nUnit tests rock.\n";
    local *STDIN;
    open STDIN, '<:utf8', \$Email;    ## no critic
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $CommandObject->Execute('--debug');
}

$Self->Is(
    $ExitCode,
    0,
    "Maint::PostMaster::Read exit code with email input",
);

my ($TicketID) = $Result =~ m{TicketID:\s+(\d+)};

$Self->True(
    $TicketID,
    'Ticket created from email',
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
