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

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
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

my @ArticleIDs;

for my $Item ( 0 .. 1 ) {
    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID,
        ArticleType    => 'note-internal',
        SenderType     => 'agent',
        From           => 'Some Agent <email@example.com>',
        To             => 'Some Customer <customer-a@example.com>',
        Subject        => 'some short description',
        Body           => 'the message text',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify  => 1,                                          # if you don't want to send agent notifications
    );

    $Self->True(
        $ArticleID,
        'ArticleCreate()',
    );

    push @ArticleIDs, $ArticleID;
}

# article flag tests
my @Tests = (
    {
        Name   => 'seen flag',
        Key    => 'seen',
        Value  => 1,
        UserID => 1,
    },
    {
        Name   => 'not seen flag',
        Key    => 'not seen',
        Value  => 2,
        UserID => 1,
    },
);

# delete pre-existing article flags which are created on TicketCreate
$TicketObject->ArticleFlagDelete(
    ArticleID => $ArticleIDs[0],
    Key       => 'Seen',
    UserID    => 1,
);
$TicketObject->ArticleFlagDelete(
    ArticleID => $ArticleIDs[1],
    Key       => 'Seen',
    UserID    => 1,
);

for my $Test (@Tests) {

    # set for article 1
    my %Flag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[0],
        UserID    => 1,
    );
    $Self->False(
        $Flag{ $Test->{Key} },
        'ArticleFlagGet() article 1',
    );
    my $Set = $TicketObject->ArticleFlagSet(
        ArticleID => $ArticleIDs[0],
        Key       => $Test->{Key},
        Value     => $Test->{Value},
        UserID    => 1,
    );
    $Self->True(
        $Set,
        'ArticleFlagSet() article 1',
    );

    # set for article 2
    %Flag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[1],
        UserID    => 1,
    );
    $Self->False(
        $Flag{ $Test->{Key} },
        'ArticleFlagGet() article 2',
    );
    $Set = $TicketObject->ArticleFlagSet(
        ArticleID => $ArticleIDs[1],
        Key       => $Test->{Key},
        Value     => $Test->{Value},
        UserID    => 1,
    );
    $Self->True(
        $Set,
        'ArticleFlagSet() article 2',
    );
    %Flag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[1],
        UserID    => 1,
    );
    $Self->Is(
        $Flag{ $Test->{Key} },
        $Test->{Value},
        'ArticleFlagGet() article 2',
    );

    # get all flags of ticket
    %Flag = $TicketObject->ArticleFlagsOfTicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->IsDeeply(
        \%Flag,
        {
            $ArticleIDs[0] => {
                $Test->{Key} => $Test->{Value},
            },
            $ArticleIDs[1] => {
                $Test->{Key} => $Test->{Value},
            },
        },
        'ArticleFlagsOfTicketGet() both articles',
    );

    # delete for article 1
    my $Delete = $TicketObject->ArticleFlagDelete(
        ArticleID => $ArticleIDs[0],
        Key       => $Test->{Key},
        UserID    => 1,
    );
    $Self->True(
        $Delete,
        'ArticleFlagDelete() article 1',
    );
    %Flag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[0],
        UserID    => 1,
    );
    $Self->False(
        $Flag{ $Test->{Key} },
        'ArticleFlagGet() article 1',
    );

    %Flag = $TicketObject->ArticleFlagsOfTicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->IsDeeply(
        \%Flag,
        {
            $ArticleIDs[1] => {
                $Test->{Key} => $Test->{Value},
            },
        },
        'ArticleFlagsOfTicketGet() only one article',
    );

    # delete for article 2
    $Delete = $TicketObject->ArticleFlagDelete(
        ArticleID => $ArticleIDs[1],
        Key       => $Test->{Key},
        UserID    => 1,
    );
    $Self->True(
        $Delete,
        'ArticleFlagDelete() article 2',
    );

    %Flag = $TicketObject->ArticleFlagsOfTicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->IsDeeply(
        \%Flag,
        {},
        'ArticleFlagsOfTicketGet() empty articles',
    );

    # test ArticleFlagsDelete for AllUsers
    $Set = $TicketObject->ArticleFlagSet(
        ArticleID => $ArticleIDs[0],
        Key       => $Test->{Key},
        Value     => $Test->{Value},
        UserID    => 1,
    );
    $Self->True(
        $Set,
        'ArticleFlagSet() article 1',
    );
    %Flag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[0],
        UserID    => 1,
    );
    $Self->Is(
        $Flag{ $Test->{Key} },
        $Test->{Value},
        'ArticleFlagGet() article 1',
    );
    $Delete = $TicketObject->ArticleFlagDelete(
        ArticleID => $ArticleIDs[0],
        Key       => $Test->{Key},
        AllUsers  => 1,
    );
    $Self->True(
        $Delete,
        'ArticleFlagDelete() article 1 for AllUsers',
    );
    %Flag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[0],
        UserID    => 1,
    );
    $Self->Is(
        $Flag{ $Test->{Key} },
        scalar undef,
        'ArticleFlagGet() article 1 after delete for AllUsers',
    );
}

# test searching for article flags

my @SearchTestFlagsSet = qw( f1 f2 f3 );

for my $Flag (@SearchTestFlagsSet) {
    my $Set = $TicketObject->ArticleFlagSet(
        ArticleID => $ArticleIDs[0],
        Key       => $Flag,
        Value     => 42,
        UserID    => 1,
    );

    $Self->True(
        $Set,
        "Can set article flag $Flag",
    );
}

my @FlagSearchTests = (
    {
        Search => {
            ArticleFlag => {
                f1 => 42,
                f2 => 42,
            },
        },
        Expected => 1,
        Name     => "Can find ticket when searching for two article flags",
    },
    {
        Search => {
            ArticleFlag => {
                f1 => 42,
                f2 => 1,
            },
        },
        Expected => 0,
        Name     => "Wrong flag value leads to no match",
    },
);

for my $Test (@FlagSearchTests) {
    my $Found = $TicketObject->TicketSearch(
        TicketID => $TicketID,
        Result   => 'COUNT',
        UserID   => 1,
        %{ $Test->{Search} },
    );

    $Self->Is(
        $Found,
        $Test->{Expected},
        $Test->{Name},
    );
}

# cleanup is done by RestoreDatabase.

1;
