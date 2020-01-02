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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::FormDraft::Delete');

# get helper object
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# try to execute command without any options
my $ExitCode = $CommandObject->Execute();

# just check exit code
$Self->Is(
    $ExitCode,
    1,
    "Maint::FormDraft::Delete exit code - without any options",
);

# try to execute command with --expired option
$ExitCode = $CommandObject->Execute('expired');

# just check exit code
$Self->Is(
    $ExitCode,
    1,
    "Maint::FormDraft::Delete exit code - with --expired option",
);

# try to execute command with --object-type option without velue
$ExitCode = $CommandObject->Execute('--object-type');

# just check exit code
$Self->Is(
    $ExitCode,
    1,
    "Maint::FormDraft::Delete exit code - with ----object-type option without value",
);

# get FormDraft object
my $FormDraftObject = $Kernel::OM->Get('Kernel::System::FormDraft');

# create test Ticket
my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID,
    "Ticket is created - $TicketID"
);

$HelperObject->FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-02-01 10:10:00',
        },
    )->ToEpoch()
);

# test FormDraftAdd and FormDraftListGet functions
my $FormDraftID;
for ( 1 .. 3 ) {

    # create FormDraft
    my $FormDraftAdd = $FormDraftObject->FormDraftAdd(
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        ObjectType    => 'Ticket',
        ObjectID      => $TicketID,
        Action        => 'AgentTicketNote',
        FormDraftName => 'UnitTest FormDraft' . $HelperObject->GetRandomID(),
        UserID        => 1,
    );

    $Self->True(
        $TicketID,
        "FormDraft is created"
    );

    # set fix time in order so further created drafts will be expired
    # to test command with expired option and without it as well
    $HelperObject->FixedTimeSet(
        $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => '2016-01-15 10:10:00',
            },
        )->ToEpoch()
    );
}

$HelperObject->FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-02-01 10:10:00',
        },
    )->ToEpoch()
);

# execute command with --object-type option with velue ticket and --expired option
$ExitCode = $CommandObject->Execute( '--object-type', 'Ticket', '--expired' );

# just check exit code
$Self->Is(
    $ExitCode,
    0,
    "Maint::FormDraft::Delete exit code - with ----object-type option with 'Ticket' value and --expired option",
);

my $FormDraftList = $FormDraftObject->FormDraftListGet(
    ObjectType => 'Ticket',
    ObjectID   => $TicketID,
    Action     => 'AgentTicketNote',
    UserID     => 1,
);

$Self->Is(
    scalar @{$FormDraftList},
    1,
    "Expired FormDraft is deleted"
);

# execute command with --object-type option with velue Ticket
$ExitCode = $CommandObject->Execute( '--object-type', 'Ticket' );

# just check exit code
$Self->Is(
    $ExitCode,
    0,
    "Maint::FormDraft::Delete exit code - with ----object-type option with 'Ticket' value",
);

1;
