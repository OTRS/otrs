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

# get needed objects
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# enable watcher feature
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'Ticket::Watcher',
    Value => 1,
);

my @TicketIDs;
my @TestUserIDs;
for ( 1 .. 2 ) {

    my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
        Groups => [ 'users', ],
    );

    push @TestUserIDs, $TestUserID;

    # create a new ticket
    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'My ticket for watching',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerUser => 'customer@example.com',
        CustomerID   => 'example.com',
        OwnerID      => 1,
        UserID       => 1,
    );

    $Self->True(
        $TicketID,
        "Ticket created for test - $TicketID",
    );
    push @TicketIDs, $TicketID;
}

my $Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketIDs[0],
    WatchUserID => $TestUserIDs[0],
    UserID      => 1,
);
$Self->True(
    $Subscribe || 0,
    'TicketWatchSubscribe()',
);
my $Unsubscribe = $TicketObject->TicketWatchUnsubscribe(
    TicketID    => $TicketIDs[0],
    WatchUserID => $TestUserIDs[0],
    UserID      => 1,
);
$Self->True(
    $Unsubscribe || 0,
    'TicketWatchUnsubscribe()',
);

# add new subscription (will be deleted by TicketDelete(), also check foreign keys)
$Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketIDs[0],
    WatchUserID => $TestUserIDs[0],
    UserID      => 1,
);
$Self->True(
    $Subscribe || 0,
    'TicketWatchSubscribe()',
);

# subscribe first ticket with second user
$Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketIDs[0],
    WatchUserID => $TestUserIDs[1],
    UserID      => 1,
);
$Self->True(
    $Subscribe || 0,
    'TicketWatchSubscribe()',
);

# subscribe second ticket with second user
$Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketIDs[1],
    WatchUserID => $TestUserIDs[1],
    UserID      => 1,
);
$Self->True(
    $Subscribe || 0,
    'TicketWatchSubscribe()',
);

my %Watch = $TicketObject->TicketWatchGet(
    TicketID => $TicketIDs[0],
);
$Self->True(
    $Watch{ $TestUserIDs[0] } || 0,
    'TicketWatchGet - first user',
);
$Self->True(
    $Watch{ $TestUserIDs[1] },
    'TicketWatchGet - second user',
);

%Watch = $TicketObject->TicketWatchGet(
    TicketID => $TicketIDs[1],
);
$Self->False(
    $Watch{ $TestUserIDs[0] } || 0,
    'TicketWatchGet - first user',
);
$Self->True(
    $Watch{ $TestUserIDs[1] },
    'TicketWatchGet - second user',
);

# merge tickets
my $Merged = $TicketObject->TicketMerge(
    MainTicketID  => $TicketIDs[0],
    MergeTicketID => $TicketIDs[1],
    UserID        => 1,
);

$Self->True(
    $Merged,
    'TicketMerge',
);

%Watch = $TicketObject->TicketWatchGet(
    TicketID => $TicketIDs[0],
);
$Self->True(
    $Watch{ $TestUserIDs[0] } || 0,
    'TicketWatchGet - first user',
);
$Self->True(
    $Watch{ $TestUserIDs[1] } || 0,
    'TicketWatchGet - second user',
);

%Watch = $TicketObject->TicketWatchGet(
    TicketID => $TicketIDs[1],
);
$Self->False(
    $Watch{ $TestUserIDs[0] } || 0,
    'TicketWatchGet - first user',
);
$Self->False(
    $Watch{ $TestUserIDs[1] } || 0,
    'TicketWatchGet - second user',
);

# cleanup is done by RestoreDatabase.

1;
