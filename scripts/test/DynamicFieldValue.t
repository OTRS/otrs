# --
# DynamicFieldValue.t - DynamicFieldValue backend tests
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

use Kernel::System::DynamicField;
use Kernel::System::DynamicFieldValue;
use Kernel::System::UnitTest::Helper;
use Kernel::System::Ticket;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $RandomID = int rand 1_000_000_000;

my $DynamicFieldObject      = Kernel::System::DynamicField->new( %{$Self} );
my $DynamicFieldValueObject = Kernel::System::DynamicFieldValue->new( %{$Self} );
my $TicketObject            = Kernel::System::Ticket->new( %{$Self} );

# create a ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID,
    "TicketCreate() successful for Ticket ID $TicketID",
);

# create a dynamic field
my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "dynamicfieldtest$RandomID",
    Label      => 'a description',
    FieldOrder => 9991,
    FieldType  => 'Text',     # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'a value',
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $FieldID,
    "DynamicFieldAdd() successful for Field ID $FieldID",
);

# create a dynamic field
my $FieldID2 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "dynamicfield2test$RandomID",
    Label      => 'a description',
    FieldOrder => 9991,
    FieldType  => 'Text',     # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'a value',
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $FieldID2,
    "DynamicFieldAdd() successful for Field ID $FieldID",
);

# create a dynamic field with tree view
my $FieldID3 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "dynamicfield3test$RandomID",
    Label      => 'a description',
    FieldOrder => 9991,
    FieldType  => 'Text',     # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    TreeView   => 1,
    Config     => {
        DefaultValue => 'a value',
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $FieldID3,
    "DynamicFieldAdd() successful for Field ID $FieldID",
);

my @Tests = (
    {
        Name               => 'No FieldID',
        DynamicFieldConfig => {},
        ObjectID           => $TicketID,
        UserID             => 1,
        Success            => 0,
    },
    {
        Name               => 'No ObjectID',
        DynamicFieldConfig => {
            ID         => -1,
            ObjectType => 'Ticket',
        },
        UserID  => 1,
        Success => 0,
    },
    {
        Name               => 'No UserID',
        DynamicFieldConfig => {
            ID => -1,
        },
        ObjectID => $TicketID,
        Success  => 0,
    },
    {
        Name               => 'Invalid Date',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueDateTime => '23-2003-12 - 45:90:80',
            }
        ],
        UserID  => 1,
        Success => 0,
    },
    {
        Name               => 'Invalid Date - No Time',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueDateTime => '1977-12-12',
            },
        ],
        UserID  => 1,
        Success => 0,
    },
    {
        Name               => 'Invalid Date - Just Time',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueDateTime => '12:00:00',
            },
        ],
        UserID  => 1,
        Success => 0,
    },
    {
        Name               => 'Invalid Integer - Letter',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueInt => 'a',
            },
        ],
        UserID  => 1,
        Success => 0,
    },
    {
        Name               => 'Invalid Integer - Numbers and Letters',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueInt => '123a',
            },
        ],
        UserID  => 1,
        Success => 0,
    },
    {
        Name               => 'Invalid Integer - Real Number',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueInt => '123.0',
            },
        ],
        UserID  => 1,
        Success => 0,
    },
    {
        Name               => 'Set Text Value',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueText => 'a text',
            },
        ],
        UserID  => 1,
        Success => 1,
    },
    {
        Name               => 'Set Text Value - empty',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueText => '',
            },
        ],
        UserID  => 1,
        Success => 1,
    },
    {
        Name               => 'Set Text Value - unicode',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueText => 'äöüßÄÖÜ€ис',
            },
        ],
        UserID  => 1,
        Success => 1,
    },
    {
        Name               => 'Set Date Value',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueDateTime => '1977-12-12 12:00:00',
            },
        ],
        UserID  => 1,
        Success => 1,
    },
    {
        Name               => 'Set Int Value',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueInt => 14524,
            },
        ],
        UserID  => 1,
        Success => 1,
    },
    {
        Name               => 'Set Int Value - Zero',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueInt => 0,
            },
        ],
        UserID  => 1,
        Success => 1,
    },
    {
        Name               => 'Set Int Value - Negative',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueInt => -10,
            },
        ],
        UserID  => 1,
        Success => 1,
    },
    {
        Name               => 'Set All Values',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueText     => 'a text',
                ValueDateTime => '1977-12-12 12:00:00',
                ValueInt      => 1,
            },
        ],
        UserID  => 1,
        Success => 1,
    },
    {
        Name               => 'Set All Values unicode',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => [
            {
                ValueText     => 'äöüßÄÖÜ€ис',
                ValueDateTime => '1977-12-12 12:00:00',
                ValueInt      => 1,
            },
        ],
        UserID  => 1,
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $DynamicFieldValueObject->ValueSet(
        FieldID    => $Test->{DynamicFieldConfig}->{ID},
        ObjectType => $Test->{DynamicFieldConfig}->{ObjectType},
        ObjectID   => $Test->{ObjectID},
        UserID     => $Test->{UserID},
        Value      => $Test->{Value},
    );
    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "ValueSet() - Test $Test->{Name} - with False",
        );

        # Try to get the value with ValueGet()
        my $Value = $DynamicFieldValueObject->ValueGet(
            FieldID    => $Test->{DynamicFieldConfig}->{ID},
            ObjectType => $Test->{DynamicFieldConfig}->{ObjectType},
            ObjectID   => $Test->{ObjectID},
        );

        $Self->False(
            $Value->[0]->{ID},
            "ValueGet() - Test $Test->{Name} - with False",
        );
    }
    else {
        $Self->True(
            $Success,
            "ValueSet() - Test $Test->{Name} - with True",
        );

        # get the value with ValueGet()
        my $Value = $DynamicFieldValueObject->ValueGet(
            FieldID    => $Test->{DynamicFieldConfig}->{ID},
            ObjectType => $Test->{DynamicFieldConfig}->{ObjectType},
            ObjectID   => $Test->{ObjectID},
        );

        # sanity check
        $Self->True(
            $Value->[0],
            "ValueGet() after ValueSet() - Test $Test->{Name} - with True",
        );

        for my $ValueKey ( sort keys %{ $Test->{Value}->[0] } ) {

            # workaround for oracle
            # oracle databases can't determine the difference between NULL and ''
            if ( !defined $Value->[0]->{$ValueKey} || $Value->[0]->{$ValueKey} eq '' ) {

                # test falseness
                $Self->False(
                    $Value->[0]->{$ValueKey},
                    "ValueGet() after ValueSet() - Test $Test->{Name} - "
                        . " (Special case for '')"
                );
            }
            else {

                # compare data
                $Self->Is(
                    $Value->[0]->{$ValueKey},
                    $Test->{Value}->[0]->{$ValueKey},
                    "ValueGet() after ValueSet() - Test $Test->{Name} - Key $ValueKey",
                );
            }
        }
    }
}

# specific tests for ValueGet()
@Tests = (
    {
        Name               => 'Wrong FieldID',
        DynamicFieldConfig => {
            ID         => -1,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        UserID   => 1,
    },
    {
        Name               => 'Wrong ObjectID',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => -1,
        UserID   => 1,
    },
);

for my $Test (@Tests) {

    # try to get the value with ValueGet()
    my $Value = $DynamicFieldValueObject->ValueGet(
        FieldID    => $Test->{DynamicFieldConfig}->{ID},
        ObjectType => $Test->{DynamicFieldConfig}->{ObjectType},
        ObjectID   => $Test->{ObjectID},
    );

    $Self->False(
        $Value->[0]->{ID},
        "ValueGet() - Test $Test->{Name} - with False",
    );
}

# delete the value with ValueDelete()
my $DeleteSuccess = $DynamicFieldValueObject->ValueDelete(
    FieldID    => $FieldID,
    ObjectType => 'Ticket',
    ObjectID   => $TicketID,
    UserID     => 1,
);

$Self->True(
    $DeleteSuccess,
    "ValueDelete() successful for Field ID $FieldID",
);

# set a "New Value"
{
    my $Success = $DynamicFieldValueObject->ValueSet(
        FieldID    => $FieldID,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        Value      => [
            {
                ValueText => 'New Value',
            },
        ],
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "ValueSet() - New Value - with True - for FieldID $FieldID",
    );

    # get the value with ValueGet()
    my $Value = $DynamicFieldValueObject->ValueGet(
        FieldID    => $FieldID,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID
    );

    # sanity check
    $Self->Is(
        $Value->[0]->{ValueText},
        'New Value',
        "ValueGet() - New Value for ValueText - for FieldID $FieldID",
    );

    # get the value with ValueGet()
    $Value = $DynamicFieldValueObject->ValueGet(
        FieldID    => $FieldID,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID
    );

    # sanity check
    $Self->Is(
        $Value->[0]->{ValueText},
        'New Value',
        "ValueGet() - New Value for ValueText cached - for FieldID $FieldID",
    );

    # check caching
    $Success = $DynamicFieldValueObject->ValueSet(
        FieldID    => $FieldID,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        Value      => [
            {
                ValueText => 'New Value2',
            },
        ],
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "ValueSet() - New Value2 - with True - for FieldID $FieldID",
    );

    $Success = $DynamicFieldValueObject->ValueSet(
        FieldID    => $FieldID2,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        Value      => [
            {
                ValueText => 'New Value2 field2',
            },
        ],
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "ValueSet() - New Value2 - with True - for FieldID $FieldID",
    );

    $Success = $DynamicFieldValueObject->ValueSet(
        FieldID    => $FieldID3,
        ObjectType => 'Ticket',
        TreeView   => 1,
        ObjectID   => $TicketID,
        Value      => [
            {
                ValueText => 'New Value2 field3',
            },
        ],
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "ValueSet() - New Value2 - with True - for FieldID $FieldID3",
    );

    # get the value with ValueGet()
    $Value = $DynamicFieldValueObject->ValueGet(
        FieldID    => $FieldID,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID
    );

    # sanity check
    $Self->Is(
        $Value->[0]->{ValueText},
        'New Value2',
        "ValueGet() - New Value2 for ValueText - for FieldID $FieldID",
    );

    # get the value with ValueGet()
    $Value = $DynamicFieldValueObject->ValueGet(
        FieldID    => $FieldID2,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID
    );

    # sanity check
    $Self->Is(
        $Value->[0]->{ValueText},
        'New Value2 field2',
        "ValueGet() - New Value2 for ValueText - for field2 FieldID $FieldID2",
    );

    # get the value with ValueGet()
    $Value = $DynamicFieldValueObject->ValueGet(
        FieldID    => $FieldID3,
        ObjectType => 'Ticket',
        TreeView   => 1,
        ObjectID   => $TicketID
    );

    # sanity check
    $Self->Is(
        $Value->[0]->{ValueText},
        'New Value2 field3',
        "ValueGet() - New Value2 for ValueText - for field3 FieldID $FieldID3",
    );

    $Success = $DynamicFieldValueObject->ValueDelete(
        FieldID    => $FieldID,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        UserID     => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "ValueDelete() - for FieldID $FieldID",
    );

    # get the value with ValueGet()
    $Value = $DynamicFieldValueObject->ValueGet(
        FieldID    => $FieldID,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID
    );

    # sanity check
    $Self->Is(
        scalar @{$Value},
        0,
        "ValueGet() - deleted value - for FieldID $FieldID",
    );

    $Success = $DynamicFieldValueObject->ValueDelete(
        FieldID    => $FieldID2,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        UserID     => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "ValueDelete() - for FieldID $FieldID",
    );

    # get the value with ValueGet()
    $Value = $DynamicFieldValueObject->ValueGet(
        FieldID    => $FieldID2,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID
    );

    # sanity check
    $Self->Is(
        scalar @{$Value},
        0,
        "ValueGet() - deleted value - for field2 FieldID $FieldID",
    );

    $Success = $DynamicFieldValueObject->ValueDelete(
        FieldID    => $FieldID3,
        ObjectType => 'Ticket',
        TreeView   => 1,
        ObjectID   => $TicketID,
        UserID     => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "ValueDelete() - for FieldID $FieldID3",
    );

    # get the value with ValueGet()
    $Value = $DynamicFieldValueObject->ValueGet(
        FieldID    => $FieldID3,
        ObjectType => 'Ticket',
        TreeView   => 1,
        ObjectID   => $TicketID
    );

    # sanity check
    $Self->Is(
        scalar @{$Value},
        0,
        "ValueGet() - deleted value - for field3 FieldID $FieldID",
    );
}

# delete the dynamic field values
my $FieldValueDelete = $DynamicFieldValueObject->AllValuesDelete(
    FieldID => $FieldID,
    UserID  => 1,
);

# sanity check
$Self->True(
    $FieldValueDelete,
    "AllValuesDelete() successful for Field ID $FieldID",
);

my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
    ID     => $FieldID,
    UserID => 1,
);

# sanity check
$Self->True(
    $FieldDelete,
    "DynamicFieldDelete() successful for Field ID $FieldID",
);

$FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
    ID     => $FieldID2,
    UserID => 1,
);

# sanity check
$Self->True(
    $FieldDelete,
    "DynamicFieldDelete() successful for field2 aField ID $FieldID",
);

$FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
    ID     => $FieldID3,
    UserID => 1,
);

# sanity check
$Self->True(
    $FieldDelete,
    "DynamicFieldDelete() successful for field3 aField ID $FieldID",
);

# now that the field was deleted also "New Value" should be deleted too"
{

    # get the value with ValueGet()
    my $Value = $DynamicFieldValueObject->ValueGet(
        FieldID    => $FieldID,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID
    );

    $Self->False(
        $Value->[0],
        "Value was deleted by FieldDeletion of $FieldID",
    );
}

# delete the ticket
my $TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

# sanity check
$Self->True(
    $TicketDelete,
    "TicketDelete() successful for Ticket ID $TicketID",
);

# HistoryValueGet() tests
# set info to create some tickets
my %TicketInfo = (
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# set the tickets to create
my $TicketsToCreate = 5;

my @CreatedTicketIds;

# create each ticket
for my $Counter ( 1 .. $TicketsToCreate ) {
    my $TicketID = $TicketObject->TicketCreate(%TicketInfo);

    # sanity check
    $Self->True(
        $TicketID,
        "TicketCreate() successful for Ticket ID $TicketID - for HistoryValueGet()",
    );

    # store the ticket IDs
    push @CreatedTicketIds, $TicketID;
}

# sanity checks for created tickets
$Self->Is(
    scalar @CreatedTicketIds,
    $TicketsToCreate,
    "Tickets created match the number of tickets to create - for HistoryValueGet()"
);

# create a dynamic field
$FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "dynamicfieldtest$RandomID",
    Label      => 'a description',
    FieldOrder => 9991,
    FieldType  => 'Text',     # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'a value',
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $FieldID,
    "DynamicFieldAdd() successful for Field ID $FieldID - for HistoryValueGet()",
);

my $Counter;

my %TextValues;
my %IntValues;
my %DateValues;

for my $TicketID (@CreatedTicketIds) {
    $Counter++;

    # set proper counter for date
    my $DateCounter = '00';
    if ( $Counter > 0 && $Counter < 10 ) {
        $DateCounter = '0' . $Counter;
    }
    elsif ( $Counter > 59 ) {
        $DateCounter = '59'
    }
    else {
        $DateCounter = $Counter;
    }

    # set the DF value
    my %Value = (
        ValueText     => 'Text' . $Counter,
        ValueDateTime => '2011-01-01 00:' . $DateCounter . ':00',
        ValueInt      => $Counter,
    );

    my $Success = $DynamicFieldValueObject->ValueSet(
        FieldID    => $FieldID,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        UserID     => 1,
        Value      => [ \%Value ],
    );

    $Self->True(
        $Success,
        "ValueSet() for TicketID $TicketID - for HistoryValueGet()",
    );

    # reset counter to store duplicates
    if ( $Counter == scalar @CreatedTicketIds - 2 ) {
        $Counter = 0;
    }

    $TextValues{ $Value{ValueText} }     = $Value{ValueText};
    $DateValues{ $Value{ValueDateTime} } = $Value{ValueDateTime};
    $IntValues{ $Value{ValueInt} }       = $Value{ValueInt};

}

my $HistoricalValues = $DynamicFieldValueObject->HistoricalValueGet(
    FieldID   => $FieldID,
    ValueType => 'Text',
);

$Self->IsDeeply(
    $HistoricalValues,
    \%TextValues,
    "HistoricalValueGet() for Text data"
);

$HistoricalValues = $DynamicFieldValueObject->HistoricalValueGet(
    FieldID   => $FieldID,
    ValueType => 'DateTime',
);

$Self->IsDeeply(
    $HistoricalValues,
    \%DateValues,
    "HistoricalValueGet() for Date or DateTime data"
);

$HistoricalValues = $DynamicFieldValueObject->HistoricalValueGet(
    FieldID   => $FieldID,
    ValueType => 'Integer',
);

$Self->IsDeeply(
    $HistoricalValues,
    \%IntValues,
    "HistoricalValueGet() for Integer data"
);

# HistoricalValues (from cache)
$HistoricalValues = $DynamicFieldValueObject->HistoricalValueGet(
    FieldID   => $FieldID,
    ValueType => 'Text',
);

$Self->IsDeeply(
    $HistoricalValues,
    \%TextValues,
    "HistoricalValueGet() for Text data - from Cache"
);

$HistoricalValues = $DynamicFieldValueObject->HistoricalValueGet(
    FieldID   => $FieldID,
    ValueType => 'DateTime',
);

$Self->IsDeeply(
    $HistoricalValues,
    \%DateValues,
    "HistoricalValueGet() for Date or DateTime data - from Cache"
);

$HistoricalValues = $DynamicFieldValueObject->HistoricalValueGet(
    FieldID   => $FieldID,
    ValueType => 'Integer',
);

$Self->IsDeeply(
    $HistoricalValues,
    \%IntValues,
    "HistoricalValueGet() for Integer data - from Cache"
);

# delete the dynamic field values
$FieldValueDelete = $DynamicFieldValueObject->AllValuesDelete(
    FieldID => $FieldID,
    UserID  => 1,
);

# sanity check
$Self->True(
    $FieldValueDelete,
    "AllValuesDelete() successful for Field ID $FieldID",
);

# delete the dynamic field
$FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
    ID     => $FieldID,
    UserID => 1,
);

# sanity check
$Self->True(
    $FieldDelete,
    "DynamicFieldDelete() successful for Field ID $FieldID - for HistoryValueGet()",
);

# now that the field was deleted also "New Value" should be deleted too"
for my $TicketID (@CreatedTicketIds) {

    # get the value with ValueGet()
    my $Value = $DynamicFieldValueObject->ValueGet(
        FieldID    => $FieldID,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID
    );

    $Self->False(
        $Value->[0],
        "Value for TicketID $TicketID was deleted by FieldDeletion of $FieldID"
            . " - for HistoryValueGet()",
    );
}

# delete created tickets
for my $TicketID (@CreatedTicketIds) {

    # delete the ticket
    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # sanity check
    $Self->True(
        $TicketDelete,
        "TicketDelete() successful for Ticket ID $TicketID - for HistoryValueGet()",
    );
}

1;
