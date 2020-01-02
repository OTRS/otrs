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

my $UserObject           = $Kernel::OM->Get('Kernel::System::User');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $DateTimeObject       = $Kernel::OM->Create('Kernel::System::DateTime');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'Ticket::UnlockOnAway',
    Value => 1,
);

my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
    Groups => [ 'users', ],
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

$ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
    Subject              => 'Should not unlock',
    Body                 => '.',
    ContentType          => 'text/plain; charset=UTF-8',
    HistoryComment       => 'Just a test',
    HistoryType          => 'OwnerUpdate',
    UserID               => 1,
    NoAgentNotify        => 1,
    UnlockOnAway         => 1,
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

my $DTValues = $DateTimeObject->Get();

# Special case for leap years. There is no Feb 29 in the next and previous years in this case.
if ( $DTValues->{Month} == 2 && $DTValues->{Day} == 29 ) {
    $DTValues->{Day}--;
}

$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeStartYear',
    Value  => $DTValues->{Year} - 1,
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeEndYear',
    Value  => $DTValues->{Year} + 1,
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeStartMonth',
    Value  => $DTValues->{Month},
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeEndMonth',
    Value  => $DTValues->{Month},
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeStartDay',
    Value  => $DTValues->{Day},
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeEndDay',
    Value  => $DTValues->{Day},
);

$ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
    Subject              => 'Should now unlock',
    Body                 => '.',
    ContentType          => 'text/plain; charset=UTF-8',
    HistoryComment       => 'Just a test',
    HistoryType          => 'OwnerUpdate',
    UserID               => 1,
    NoAgentNotify        => 1,
    UnlockOnAway         => 1,
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

# cleanup is done by RestoreDatabase.

1;
