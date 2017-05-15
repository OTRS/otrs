# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Number::Base;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::ExclusiveLock',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::Ticket::Number::Base - Common functions for ticket number generators

=head1 PUBLIC INTERFACE

=cut

sub new {
    my ($Type) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 IsDateBased()

informs if the current number counter has a reset with every new day or not. All generators
need to implement this function.

    my $IsDatebased = $TicketNumberObject->IsDateBased();

=cut

=head2 TicketNumberCounterAdd()

Add a new unique ticket counter entry (uses exclusive locking to avoid duplicate counter entries).

    my $Counter = $TicketNumberObject->TicketNumberCounterAdd(
        Offset      => 123,
    );

Returns:

    my $Counter = 123;  # undef in case of an error

=cut

sub TicketNumberCounterAdd {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Offset} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Offset!",
        );
        return;
    }

    if ( !IsPositiveInteger( $Param{Offset} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Offset needs to be a positive integer!",
        );
        return;
    }

    my $LockHandle = $Kernel::OM->Get('Kernel::System::ExclusiveLock')->ExclusiveLockGet(
        LockKey => 'TicketNumberCounter',
    );

    return if !$LockHandle;

    my $CounterUID = $LockHandle->LockUIDGet();

    return if !$CounterUID;

    # Get the last inserted counter.
    my $SQL = 'SELECT COALESCE(MAX(counter),0) FROM ticket_number_counter';

    my @Bind;

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime'
    );
    my $CurrentTimeString = $DateTimeObject->ToString();

    # Only get the value from the current date if the number generator modules is date based.
    if ( $Self->IsDateBased() ) {

        my $DateTimeSettings = $DateTimeObject->Get();
        for my $Element (qw(Hour Minute Second)) {
            $DateTimeSettings->{$Element} = 0;
        }

        my $TodayDateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => $DateTimeSettings,
        );

        $SQL .= ' WHERE create_time >= ?';
        push @Bind, \$TodayDateTimeObject->ToString(),
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind
    );
    my $LastCounter;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $LastCounter = $Data[0];
    }

    my $NewCounter = $LastCounter + $Param{Offset};

    # Insert new ticket counter into the database based on the last one
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO ticket_number_counter
                (counter, counter_uid, create_time)
            VALUES
                (  ?, ?, ? )',
        Bind => [ \$NewCounter, \$CounterUID, \$CurrentTimeString ],
    );

    # Get the just inserted ticket counter.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT counter
            FROM ticket_number_counter
            WHERE counter_uid = ?',
        Bind => [ \$CounterUID ],
    );

    my $Counter;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $Counter = $Data[0];
    }

    return if $Counter ne $NewCounter;

    return $Counter;
}

=head2 TicketNumberCounterDelete()

Remove a ticket counter entry.

    my $Success = $TicketNumberObject->TicketNumberCounterDelete(
        CounterID => 123,
    );

Returns:

    my $Success = 1;  # false in case of an error

=cut

sub TicketNumberCounterDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{CounterID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need CounterID",
        );
        return;
    }

    # Delete counter from the list.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM ticket_number_counter WHERE id = ?',
        Bind => [ \$Param{CounterID} ],
    );

    return 1;
}

=head2 TicketNumberCounterIsEmpty()

Check if there are no records in ticket_number_counter DB table.

    my $IsEmpty = $TicketNumberObject->TicketNumberCounterIsEmpty();

Returns:

    my $IsEmpty = 1;  # 0 if it is not empty and undef in case of an error

=cut

sub TicketNumberCounterIsEmpty {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT COUNT(*) FROM ticket_number_counter',
    );

    my $Count;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $Count = $Data[0];
    }

    return $Count ? 0 : 1;
}

=head2 TicketNumberCounterCleanup()

Removes old counters from the system.

    my $Success = $TicketNumberObject->TicketNumberCounterCleanup();

Returns:

    my $Success = 1;  # or false in case of an error

=cut

sub TicketNumberCounterCleanup {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get all counters.
    return if !$DBObject->Prepare(
        SQL => 'SELECT id, create_time FROM ticket_number_counter ORDER BY id DESC'
    );

    my @CounterList;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @CounterList, {
            ID         => $Row[0],
            CreateTime => $Row[1],
        };
    }

    # Keep the latest 10 counters.
    my $RemainingCounters = 10;
    @CounterList = splice( @CounterList, $RemainingCounters );

    # Create a date time object with 10 minutes in the past for later comparisons.
    my $TargetDateTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
    );
    my $SubstractSuccess = $TargetDateTime->Subtract(
        Minutes => 10,
    );

    my $MaxCounterID;

    COUNTERID:
    for my $Counter (@CounterList) {

        my $CounterDateTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Counter->{CreateTime},
            },
        );

        # Keep also counters created in the latest 10 minutes.
        next COUNTERID if $CounterDateTime >= $TargetDateTime;

        $MaxCounterID = $Counter->{ID};
        last COUNTERID;
    }

    # Delete counter from the list.
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM ticket_number_counter WHERE id <= ?',
        Bind => [ \$MaxCounterID ],
    );

    return 1;
}

=head2 TicketCreateNumber()

Creates a unique ticket number.

    my $TicketNumber = $TicketNumberObject->TicketCreateNumber();

Returns:

    my $TicketNumber = 456;

=cut

sub TicketCreateNumber {
    my ( $Self, $Offset ) = @_;    # Offset is an internal offset value for the new counter entry.

    # Try to generate a new ticket number.
    my $TicketNumber = $Self->TicketNumberBuild($Offset);
    return if !$TicketNumber;

    my $TicketNumberAlreadyUsed = $Kernel::OM->Get('Kernel::System::Ticket')->TicketIDLookup(
        TicketNumber => $TicketNumber,
    );

    # Normal case: everything fine, ticket number can be used.
    return $TicketNumber if !$TicketNumberAlreadyUsed;

    # Ok, ticket number already used. Try to generate another one, until one is valid.
    if ( ++$Self->{LoopProtectionCounter} >= 16000 ) {

        # Loop protection.
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "CounterLoopProtection is now $Self->{LoopProtectionCounter}!"
                . " Stopped TicketCreateNumber()!",
        );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'notice',
        Message  => "TicketNumber ($TicketNumber) exists! Creating a new one.",
    );

    return $Self->TicketCreateNumber( $Self->{LoopProtectionCounter} );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
