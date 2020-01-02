# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::NumberBase;

use strict;
use warnings;

use Time::HiRes();

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

Kernel::System::Ticket::NumberBase - Common functions for ticket number generators

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

Add a new unique ticket counter entry. These counters are used by the different number generators
    to generate unique C<TicketNumber>s

    my $Counter = $TicketNumberObject->TicketNumberCounterAdd(
        Offset      => 123,
    );

Returns:

    my $Counter = 123;  # undef in case of an error

This method has logic to generate unique numbers even though concurrent processes might write to the
same table. The algorithm runs as follows:
    - Insert a new record into the C<ticket_number_counter> table with a C<counter> value of 0.
    - Then update all preceding records including and up to the current one that still have value 0 and compute the correct value for each, which depends on the previous record.

This works well also if concurrent processes write to the records at the same time, because they will compute the same (unique) values for the counters.

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

    my $CounterUID = $Self->_GetUID();

    return if !$CounterUID;

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime'
    );
    my $CurrentTimeString = $DateTimeObject->ToString();

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Insert new ticket counter into the database (with value 0)
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO ticket_number_counter
                (counter, counter_uid, create_time)
            VALUES
                (  0, ?, ? )',
        Bind => [ \$CounterUID, \$CurrentTimeString ],
    );

    # It's strange, but this sleep seems to be needed to make sure that other database sessions also see this record.
    #   Without it, there were race conditions because the fillup of unset values below didn't find records that other
    #   sessions already inserted.
    Time::HiRes::sleep(0.05);

    # Get the ID of the just inserted ticket counter.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id
            FROM ticket_number_counter
            WHERE counter_uid = ?',
        Bind  => [ \$CounterUID ],
        Limit => 1,
    );

    my $CounterID;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $CounterID = $Data[0];
    }

    # Calculate the counter values for all records that don't have a generated value yet.
    #   This is safe even if multiple processes access the records at the same time.

    my $DateConditionSQL = '';

    # Only get counters from the current date if the number generator module is date based.
    if ( $Self->IsDateBased() ) {

        my $DateTimeSettings = $DateTimeObject->Get();
        for my $Element (qw(Hour Minute Second)) {
            $DateTimeSettings->{$Element} = 0;
        }

        $DateTimeObject->Set( %{$DateTimeSettings} );
        $DateConditionSQL = " AND create_time >= '" . $DateTimeObject->ToString() . "'";
    }

    my $SQL = "
        SELECT id
        FROM ticket_number_counter
        WHERE counter = 0
            AND id <= ?
            $DateConditionSQL
        ORDER BY id ASC";

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => [ \$CounterID ]
    );

    my @UnsetCounterIDs;

    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @UnsetCounterIDs, $Row[0];
    }

    my $SetOffset;
    for my $UnsetCounterID (@UnsetCounterIDs) {

        # Get previous counter record value (tolerate gaps).
        my $PreviousCounter = 0;

        return if !$DBObject->Prepare(
            SQL => "
            SELECT counter
            FROM ticket_number_counter
            WHERE id < ?
                $DateConditionSQL
            ORDER BY id DESC",
            Bind  => [ \$UnsetCounterID ],
            Limit => 1,
        );

        while ( my @Data = $DBObject->FetchrowArray() ) {
            $PreviousCounter = $Data[0] || 0;
        }

        # Offset must only be set once (following are consecutive).
        my $NewCounter = $PreviousCounter + 1;
        if ( !$SetOffset ) {
            $NewCounter = $PreviousCounter + $Param{Offset};
            $SetOffset  = 1;
        }

        # Update the counter value, unless another process already did it.
        return if !$DBObject->Do(
            SQL => '
                UPDATE ticket_number_counter
                SET counter = ?
                WHERE id = ?
                    AND counter = 0',
            Bind => [ \$NewCounter, \$UnsetCounterID ],
        );
    }

    # Get the just inserted ticket counter with the now computed value.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT counter
            FROM ticket_number_counter
            WHERE counter_uid = ?',
        Bind  => [ \$CounterUID ],
        Limit => 1,
    );

    my $Counter;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $Counter = $Data[0];
    }

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

=head1 PRIVATE INTERFACE

=head2 _GetUID()

Generates a unique identifier.

    my $UID = $TicketNumberObject->_GetUID();

Returns:

    my $UID = 14906327941360ed8455f125d0450277;

=cut

sub _GetUID {
    my ( $Self, %Param ) = @_;

    my $NodeID = $Kernel::OM->Get('Kernel::Config')->Get('NodeID') || 1;
    my ( $Seconds, $Microseconds ) = Time::HiRes::gettimeofday();
    my $ProcessID = $$;

    my $CounterUID = $ProcessID . $Seconds . $Microseconds . $NodeID;

    my $RandomString = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length     => 32 - length $CounterUID,
        Dictionary => [ 0 .. 9, 'a' .. 'f' ],    # hexadecimal
    );

    $CounterUID .= $RandomString;

    return $CounterUID;
}
1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
