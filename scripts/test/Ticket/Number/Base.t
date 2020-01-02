# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Use AutoIncrement backend to have access to the base class functions.
my $TicketNumberBaseObject = $Kernel::OM->Get('Kernel::System::Ticket::Number::AutoIncrement');

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $Cleanup = sub {

    # Delete current counters.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'DELETE FROM ticket_number_counter',
    );
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
};

# TicketNumberCounterAdd() tests
my @Tests = (
    {
        Name    => 'Missing Offset',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Wrong Offset',
        Config => {
            Offset => -5,
        },
        Success => 0,
    },
    {
        Name   => 'Correct Offset',
        Config => {
            Offset => 1,
        },
        ExpectedValue => 1,
        Success       => 1,
    },
    {
        Name   => 'Correct Offset (1)',
        Config => {
            Offset => 1,
        },
        ExpectedValue => 2,
        Success       => 1,
    },
    {
        Name   => 'Correct Offset (2)',
        Config => {
            Offset => 2,
        },
        ExpectedValue => 4,
        Success       => 1,
    },
    {
        Name   => 'Correct Offset (50)',
        Config => {
            Offset => 50,
        },
        ExpectedValue => 54,
        Success       => 1,
    },
);

$Cleanup->();

TEST:
for my $Test (@Tests) {
    my $Counter = $TicketNumberBaseObject->TicketNumberCounterAdd( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->Is(
            $Counter,
            undef,
            "$Test->{Name} TicketNumberCounterAdd() - Should be undef",
        );

        next TEST;
    }

    $Self->Is(
        $Counter,
        $Test->{ExpectedValue},
        "$Test->{Name} TicketNumberCounterAdd()",
    );
}

# TicketNumberCounterIsEmpty() tests
@Tests = (
    {
        Name           => 'Initial',
        AddCounter     => 0,
        DeleteCounter  => 0,
        CacheBefore    => undef,
        CacheAfter     => 1,
        Cleanup        => 0,
        ExpectedResult => 1,
    },
    {
        Name           => 'Simple Call (empty)',
        AddCounter     => 0,
        DeleteCounter  => 0,
        CacheBefore    => 1,
        CacheAfter     => 1,
        Cleanup        => 0,
        ExpectedResult => 1,
    },
    {
        Name           => 'Add Counter',
        AddCounter     => 1,
        DeleteCounter  => 0,
        CacheBefore    => undef,
        CacheAfter     => 0,
        Cleanup        => 0,
        ExpectedResult => 0,
    },
    {
        Name           => 'Simple Call (filled)',
        AddCounter     => 0,
        DeleteCounter  => 0,
        CacheBefore    => 0,
        CacheAfter     => 0,
        Cleanup        => 0,
        ExpectedResult => 0,
    },
    {
        Name           => 'DeleteCounter',
        AddCounter     => 0,
        DeleteCounter  => 1,
        CacheBefore    => undef,
        CacheAfter     => 1,
        Cleanup        => 0,
        ExpectedResult => 1,
    },
    {
        Name           => 'Simple Call (empty again)',
        AddCounter     => 0,
        DeleteCounter  => 0,
        CacheBefore    => 1,
        CacheAfter     => 1,
        Cleanup        => 0,
        ExpectedResult => 1,
    },
);

$Cleanup->();

my $TicketNumberCounterDeleteLast = sub {

    return if !$DBObject->Prepare(
        SQL => 'SELECT MAX(id) FROM ticket_number_counter',
    );

    my $CounterID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $CounterID = $Row[0];
    }

    return if !$CounterID;
    my $Success = $TicketNumberBaseObject->TicketNumberCounterDelete(
        CounterID => $CounterID,
    );

    return $Success;
};

TEST:
for my $Test (@Tests) {
    if ( $Test->{AddCounter} ) {
        my $Counter = $TicketNumberBaseObject->TicketNumberCounterAdd( Offset => 1 );
        $Self->IsNot(
            $Counter,
            undef,
            "$Test->{Name} TicketNumberCounterAdd() - Should not be undef",
        );

    }
    if ( $Test->{DeleteCounter} ) {
        my $Success = $TicketNumberCounterDeleteLast->();
        $Self->IsNot(
            $Success,
            undef,
            "$Test->{Name} TicketNumberCounterDelete() - Should not be undef",
        );
    }

    my $IsEmpty = $TicketNumberBaseObject->TicketNumberCounterIsEmpty();
    $Self->Is(
        $IsEmpty,
        $Test->{ExpectedResult},
        "$Test->{Name} TicketNumberCounterIsEmpty()",
    );

    if ( $Test->{Cleanup} ) {
        $Cleanup->();
    }
}

# TicketNumberCounterDelete() tests (other success tests are already done in other pars of this file).
@Tests = (
    {
        Name    => 'Missing CounterID',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Wrong CounterID',
        Config => {
            CounterID => 1,    # in the best case this ID was already used before in this test
        },
        Success => 1,
    },
);

TEST:
for my $Test (@Tests) {
    my $Success = $TicketNumberBaseObject->TicketNumberCounterDelete( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "$Test->{Name} TicketNumberCounterDelete() - with false",
        );
        next TEST;
    }

    $Self->True(
        $Success,
        "$Test->{Name} TicketNumberCounterDelete() - with true",
    );
}

# TicketNumberCounterCleanup() tests.
$Cleanup->();

$Helper->FixedTimeSet();
@Tests = (
    {
        Name           => '100 - ..1 Sec',
        Iterations     => 100,
        Seconds        => 1,
        ExpectedResult => [ 1 .. 100 ],
    },
    {
        Name           => '100 - 660 Sec',
        Iterations     => 100,
        Seconds        => 660,
        ExpectedResult => [ 91 .. 100 ],
    },
    {
        Name           => '..5 - ..1 Sec',
        Seconds        => 1,
        Iterations     => 5,
        ExpectedResult => [ 1 .. 5 ],
    },
    {
        Name           => '..5 - 660 Sec',
        Iterations     => 5,
        Seconds        => 660,
        ExpectedResult => [ 1 .. 5 ],
    },
    {
        Name           => '.10 - ..1 Sec',
        Iterations     => 10,
        Seconds        => 1,
        ExpectedResult => [ 1 .. 10 ],
    },
    {
        Name           => '.10 - 660 Sec',
        Iterations     => 10,
        Seconds        => 660,
        ExpectedResult => [ 1 .. 10 ],
    },
    {
        Name           => '.11 - ..1 Sec',
        Seconds        => 1,
        Iterations     => 11,
        ExpectedResult => [ 1 .. 11 ],
    },
    {
        Name           => '.11 - 660 Sec',
        Seconds        => 660,
        Iterations     => 11,
        ExpectedResult => [ 2 .. 11 ],
    },
);

for my $Test (@Tests) {
    for ( 1 .. $Test->{Iterations} ) {
        my $Counter = $TicketNumberBaseObject->TicketNumberCounterAdd( Offset => 1 );
        $Helper->FixedTimeAddSeconds( $Test->{Seconds} );
    }

    my $Success = $TicketNumberBaseObject->TicketNumberCounterCleanup();
    $Self->True(
        $Success,
        "$Test->{Name} TicketNumberCounterCleanup() - with true",
    );

    return if !$DBObject->Prepare(
        SQL => 'SELECT counter FROM ticket_number_counter ORDER BY id',
    );

    my @Counters;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Counters, $Row[0];
    }

    $Self->IsDeeply(
        \@Counters,
        $Test->{ExpectedResult},
        "$Test->{Name} Counters after cleanup"
    );

    $Cleanup->();
}

$Helper->FixedTimeUnset();

# _GetLastTicketNumber() tests
@Tests = (
    {
        Name => '456',
        TN   => 456,
    },
    {
        Name => '789',
        TN   => 789,
    },
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

for my $Test (@Tests) {

    my $TicketID = $TicketObject->TicketCreate(
        TN           => $Test->{TN},
        Title        => 'Some Ticket Title',
        QueueID      => 1,
        Lock         => 'unlock',
        PriorityID   => 3,
        StateID      => 4,
        TypeID       => 1,
        CustomerID   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );

    my $TicketNumber = $TicketNumberBaseObject->_GetLastTicketNumber();

    $Self->Is(
        $TicketNumber,
        $Test->{TN},
        "$Test->{Name} _GetLastTicketNumber()"
    );
}

# Cleanup is done by RestoreDatabase.

1;
