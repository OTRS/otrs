# --
# TicketWatcher.t - ticket module testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::Ticket;
use Kernel::System::User;
use Kernel::System::UnitTest::Helper;

# create local objects
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);
my $ConfigObject = Kernel::Config->new();
my $UserObject   = Kernel::System::User->new(
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# enable watcher feature
$ConfigObject->Set(
    Key   => 'Ticket::Watcher',
    Value => 1,
);

my $TestUserLogin1 = $HelperObject->TestUserCreate(
    Groups => [ 'users', ],
);

my $TestUserID1 = $UserObject->UserLookup(
    UserLogin => $TestUserLogin1,
);

my $TestUserLogin2 = $HelperObject->TestUserCreate(
    Groups => [ 'users', ],
);

my $TestUserID2 = $UserObject->UserLookup(
    UserLogin => $TestUserLogin2,
);

my @TicketIDs;
for ( 1 .. 2 ) {

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
    WatchUserID => $TestUserID1,
    UserID      => 1,
);
$Self->True(
    $Subscribe || 0,
    'TicketWatchSubscribe()',
);
my $Unsubscribe = $TicketObject->TicketWatchUnsubscribe(
    TicketID    => $TicketIDs[0],
    WatchUserID => $TestUserID1,
    UserID      => 1,
);
$Self->True(
    $Unsubscribe || 0,
    'TicketWatchUnsubscribe()',
);

# add new subscription (will be deleted by TicketDelete(), also check foreign keys)
$Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketIDs[0],
    WatchUserID => $TestUserID1,
    UserID      => 1,
);
$Self->True(
    $Subscribe || 0,
    'TicketWatchSubscribe()',
);

# subscribe first ticket with second user
$Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketIDs[0],
    WatchUserID => $TestUserID2,
    UserID      => 1,
);
$Self->True(
    $Subscribe || 0,
    'TicketWatchSubscribe()',
);

# subscribe second ticket with second user
$Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketIDs[1],
    WatchUserID => $TestUserID2,
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
    $Watch{$TestUserID1} || 0,
    'TicketWatchGet - first user',
);
$Self->True(
    $Watch{$TestUserID2},
    'TicketWatchGet - second user',
);

%Watch = $TicketObject->TicketWatchGet(
    TicketID => $TicketIDs[1],
);
$Self->False(
    $Watch{$TestUserID1} || 0,
    'TicketWatchGet - first user',
);
$Self->True(
    $Watch{$TestUserID2},
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
    $Watch{$TestUserID1} || 0,
    'TicketWatchGet - first user',
);
$Self->True(
    $Watch{$TestUserID2} || 0,
    'TicketWatchGet - second user',
);

%Watch = $TicketObject->TicketWatchGet(
    TicketID => $TicketIDs[1],
);
$Self->False(
    $Watch{$TestUserID1} || 0,
    'TicketWatchGet - first user',
);
$Self->False(
    $Watch{$TestUserID2} || 0,
    'TicketWatchGet - second user',
);

for my $TicketID (@TicketIDs) {
    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "Removed ticket $TicketID",
    );
}

1;
