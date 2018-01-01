# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::InvalidUserCleanup');
my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
my $UserObject    = $Kernel::OM->Get('Kernel::System::User');

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckMXRecord',
    Value => 0,
);

my $UserName = $Helper->TestUserCreate();
my %User     = $UserObject->GetUserData( User => $UserName );
my $UserID   = $User{UserID};

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'A test for ticket unlocking',
    Queue        => 'Raw',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'pending reminder',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $UserID,
    UserID       => 1,
);

$Kernel::OM->Get('Kernel::System::User')->UserUpdate(
    %User,
    ValidID      => 2,
    ChangeUserID => 1,
);

my $ExitCode = $CommandObject->Execute();

# just check exit code
$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::InvalidUserCleanup exit code",
);

my %Ticket = $TicketObject->TicketGet(
    UserID   => 1,
    TicketID => $TicketID,

);

$Self->Is(
    $Ticket{Lock},
    'unlock',
    'Ticket from invalid owner was unlocked',
);

$Self->Is(
    $Ticket{State},
    'open',
    'Ticket from invalid owner was set to "open"',
);

# cleanup cache is done by RestoreDatabase

1;
