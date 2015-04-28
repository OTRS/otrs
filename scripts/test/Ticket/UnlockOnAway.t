# --
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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $TimeObject   = $Kernel::OM->Get('Kernel::System::Time');

$ConfigObject->Set(
    Key   => 'Ticket::UnlockOnAway',
    Value => 1,
);

my $TestUserLogin = $HelperObject->TestUserCreate(
    Groups => [ 'users', ],
);

my $TestUserID = $UserObject->UserLookup(
    UserLogin => $TestUserLogin,
);

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $TestUserID,
    UserID       => 1,
);

$Self->True( $TicketID, 'Could create ticket' );

$TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'note-internal',
    SenderType     => 'agent',
    Subject        => 'Should not unlock',
    Body           => '.',
    ContentType    => 'text/plain; charset=UTF-8',
    HistoryComment => 'Just a test',
    HistoryType    => 'OwnerUpdate',
    UserID         => 1,
    NoAgentNotify  => 1,
    UnlockOnAway   => 1,
);
my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1
);

$Self->Is(
    $Ticket{Lock},
    'lock',
    'Ticket still locked (UnlockOnAway)',
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOffice',
    Value  => 1,
);

my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $TimeObject->SystemTime2Date(
    SystemTime => $TimeObject->SystemTime(),
);

$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeStartYear',
    Value  => $Year - 1,
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeEndYear',
    Value  => $Year + 1,
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeStartMonth',
    Value  => $Month,
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeEndMonth',
    Value  => $Month,
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeStartDay',
    Value  => $Day,
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeEndDay',
    Value  => $Day,
);

$TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'note-internal',
    SenderType     => 'agent',
    Subject        => 'Should now unlock',
    Body           => '.',
    ContentType    => 'text/plain; charset=UTF-8',
    HistoryComment => 'Just a test',
    HistoryType    => 'OwnerUpdate',
    UserID         => 1,
    NoAgentNotify  => 1,
    UnlockOnAway   => 1,
);
%Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1
);

$Self->Is(
    $Ticket{Lock},
    'unlock',
    'Ticket now unlocked (UnlockOnAway)',
);

# the ticket is no longer needed
$TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

1;
