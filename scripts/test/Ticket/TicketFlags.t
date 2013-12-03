# --
# TicketFlags.t - ticket module testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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
my $UserObject = Kernel::System::User->new(
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
);

# create a new ticket
my $TicketID = $TicketObject->TicketCreate(
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

my @Tests = (
    {
        Name   => "$TicketID flag 1",
        Key    => "$TicketID flag 1 key",
        Value  => "$TicketID flag 1 value",
        UserID => 1,
    },
    {
        Name   => "$TicketID flag 2",
        Key    => "$TicketID flag 2 key",
        Value  => "$TicketID flag 2 value",
        UserID => 1,
    },
);

for my $Test (@Tests) {
    my %Flag = $TicketObject->TicketFlagGet(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->False(
        $Flag{ $Test->{Key} },
        'TicketFlagGet()',
    );
    my $Set = $TicketObject->TicketFlagSet(
        TicketID => $TicketID,
        Key      => $Test->{Key},
        Value    => $Test->{Value},
        UserID   => 1,
    );
    $Self->True(
        $Set,
        'TicketFlagSet()',
    );
    %Flag = $TicketObject->TicketFlagGet(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->Is(
        $Flag{ $Test->{Key} },
        $Test->{Value},
        'TicketFlagGet()',
    );
    my $Delete = $TicketObject->TicketFlagDelete(
        TicketID => $TicketID,
        Key      => $Test->{Key},
        UserID   => 1,
    );
    $Self->True(
        $Delete,
        'TicketFlagDelete()',
    );
    %Flag = $TicketObject->TicketFlagGet(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->False(
        $Flag{ $Test->{Key} },
        'TicketFlagGet()',
    );

    # check delete for all users
    $Set = $TicketObject->TicketFlagSet(
        TicketID => $TicketID,
        Key      => $Test->{Key},
        Value    => $Test->{Value},
        UserID   => 1,
    );
    $Self->True(
        $Set,
        'TicketFlagSet()',
    );
    %Flag = $TicketObject->TicketFlagGet(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->Is(
        $Flag{ $Test->{Key} },
        $Test->{Value},
        'TicketFlagGet()',
    );
    $Delete = $TicketObject->TicketFlagDelete(
        TicketID => $TicketID,
        Key      => $Test->{Key},
        AllUsers => 1,
    );
    $Self->True(
        $Delete,
        'TicketFlagDelete() for AllUsers',
    );
    %Flag = $TicketObject->TicketFlagGet(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->False(
        $Flag{ $Test->{Key} },
        'TicketFlagGet()',
    );

    $Set = $TicketObject->TicketFlagSet(
        TicketID => $TicketID,
        Key      => $Test->{Key},
        Value    => $Test->{Value},
        UserID   => 1,
    );
    $Self->True(
        $Set,
        'TicketFlagSet()',
    );
}

my @SearchTests = (
    {
        Name        => 'One matching flag',
        TicketFlags => {
            "$TicketID flag 1 key" => "$TicketID flag 1 value",
        },
        Result => 1,
    },
    {
        Name        => 'Another matching flag',
        TicketFlags => {
            "$TicketID flag 2 key" => "$TicketID flag 2 value",
        },
        Result => 1,
    },
    {
        Name        => 'Two matching flags',
        TicketFlags => {
            "$TicketID flag 1 key" => "$TicketID flag 1 value",
            "$TicketID flag 2 key" => "$TicketID flag 2 value",
        },
        Result => 1,
    },
    {
        Name        => 'Two flags, one matching',
        TicketFlags => {
            "$TicketID flag 1 key" => "$TicketID flag 1 valueOFF",
            "$TicketID flag 2 key" => "$TicketID flag 2 value",
        },
        Result => 0,
    },
    {
        Name        => 'Two flags, another matching',
        TicketFlags => {
            "$TicketID flag 1 key" => "$TicketID flag 1 value",
            "$TicketID flag 2 key" => "$TicketID flag 2 valueOFF",
        },
        Result => 0,
    },
);

for my $SearchTest (@SearchTests) {

    my @Tickets = $TicketObject->TicketSearch(
        Result     => 'ARRAY',
        Limit      => 2,
        TicketFlag => $SearchTest->{TicketFlags},
        UserID     => 1,
        Permission => 'rw',
    );

    $Self->Is(
        scalar @Tickets,
        $SearchTest->{Result},
        "$SearchTest->{Name} - number of found tickets",
    );
}

# cleanup
my $Delete = $TicketObject->TicketDelete(
    UserID   => 1,
    TicketID => $TicketID,
);
$Self->True(
    $Delete,
    "TicketDelete()",
);

# create 2 new users
my @UserIDs;
for ( 1 .. 2 ) {
    my $UserLogin = $HelperObject->TestUserCreate();
    my $UserID = $UserObject->UserLookup( UserLogin => $UserLogin );
    push @UserIDs, $UserID;
}

# create some content
$TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);
my @TicketIDs = ($TicketID);

# create article
my @ArticleIDs;
for ( 1 .. 2 ) {
    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID    => $TicketID,
        ArticleType => 'note-internal',
        SenderType  => 'agent',
        From        => 'Some Agent <email@example.com>',
        To          => 'Some Customer <customer@example.com>',
        Subject     => 'Fax Agreement laalala',
        Body        => 'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify => 1,    # if you don't want to send agent notifications
    );
    push @ArticleIDs, $ArticleID;
}

# check initial ticket and article flags
for my $UserID (@UserIDs) {
    my %TicketFlag = $TicketObject->TicketFlagGet(
        TicketID => $TicketID,
        UserID   => $UserID,
    );
    $Self->False(
        $TicketFlag{Seen},
        "Initial FlagCheck (false) - TicketFlagGet() - TicketID($TicketID) - UserID($UserID)",
    );
    for my $ArticleID (@ArticleIDs) {
        my %ArticleFlag = $TicketObject->ArticleFlagGet(
            ArticleID => $ArticleID,
            UserID    => $UserID,
        );
        $Self->False(
            $ArticleFlag{Seen},
            "Initial FlagCheck (false) - ArticleFlagGet() - TicketID($TicketID) - ArticleID($ArticleID) - UserID($UserID)",
        );
    }
}

# update one article
for my $UserID (@UserIDs) {
    my $Success = $TicketObject->ArticleFlagSet(
        ArticleID => $ArticleIDs[0],
        Key       => 'Seen',
        Value     => 1,
        UserID    => $UserID,
    );
    $Self->True(
        $Success,
        "UpdateOne FlagCheck ArticleFlagSet() - ArticleID($ArticleIDs[0])",
    );
    my %TicketFlag = $TicketObject->TicketFlagGet(
        TicketID => $TicketID,
        UserID   => $UserID,
    );
    $Self->False(
        $TicketFlag{Seen},
        "UpdateOne FlagCheck (false) TicketFlagGet() - TicketID($TicketID) - ArticleID($ArticleIDs[0]) - UserID($UserID)",
    );
    my %ArticleFlag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[0],
        UserID    => $UserID,
    );
    $Self->True(
        $ArticleFlag{Seen},
        "UpdateOne FlagCheck (true) ArticleFlagGet() - TicketID($TicketID) - ArticleID($ArticleIDs[0]) - UserID($UserID)",
    );
    %ArticleFlag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[1],
        UserID    => $UserID,
    );
    $Self->False(
        $ArticleFlag{Seen},
        "UpdateOne FlagCheck (false) ArticleFlagGet() - TicketID($TicketID) - ArticleID($ArticleIDs[1]) - UserID($UserID)",
    );
}

# update second article
for my $UserID (@UserIDs) {
    my $Success = $TicketObject->ArticleFlagSet(
        ArticleID => $ArticleIDs[1],
        Key       => 'Seen',
        Value     => 1,
        UserID    => $UserID,
    );
    $Self->True(
        $Success,
        "UpdateTwo FlagCheck ArticleFlagSet() - ArticleID($ArticleIDs[1])",
    );
    my %TicketFlag = $TicketObject->TicketFlagGet(
        TicketID => $TicketID,
        UserID   => $UserID,
    );
    $Self->True(
        $TicketFlag{Seen},
        "UpdateTwo FlagCheck (true) TicketFlagGet() - TicketID($TicketID) - ArticleID($ArticleIDs[1]) - UserID($UserID)",
    );
    for my $ArticleID (@ArticleIDs) {
        my %ArticleFlag = $TicketObject->ArticleFlagGet(
            ArticleID => $ArticleID,
            UserID    => $UserID,
        );
        $Self->True(
            $ArticleFlag{Seen},
            "UpdateTwo FlagCheck (true) ArticleFlagGet() - TicketID($TicketID) - ArticleID($ArticleID) - UserID($UserID)",
        );
    }
}

# delete tickets
for my $TicketID (@TicketIDs) {
    $Self->True(
        $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        ),
        'TicketDelete()',
    );
}

# set created users to invalid
for my $UserID (@UserIDs) {

    # get current user data
    my %User = $UserObject->GetUserData(
        UserID => $UserID,
    );

    # invalidate user
    $UserObject->UserUpdate(
        UserID        => $UserID,
        UserFirstname => $User{UserFirstname},
        UserLastname  => $User{UserLastname},
        UserLogin     => $User{UserLogin},
        UserEmail     => $User{UserEmail},
        ValidID       => 2,
        ChangeUserID  => 1,
    );
}

1;
