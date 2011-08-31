# --
# TicketDynamicField.t - DynamicFieldValue backend tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TicketDynamicField.t,v 1.3 2011-08-31 22:16:36 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
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

# get the config for the field
my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID,
);

# sanity check
$Self->IsNotDeeply(
    $DynamicFieldConfig,
    {},
    "DynamicFielGet() successful for Field ID $FieldID",
);

# tests definition
my @Tests = (
    {
        Name      => 'No Field Name',
        Value     => 'A Value',
        FieldName => undef,
        TicketID  => $TicketID,
        UserID    => 1,
        Success   => 0,
    },
    {
        Name      => 'No TicketID',
        Value     => 'A Value',
        FieldName => $DynamicFieldConfig->{Name},
        TicketID  => undef,
        UserID    => 1,
        Success   => 0,
    },
    {
        Name      => 'No UserID',
        Value     => 'A Value',
        FieldName => $DynamicFieldConfig->{Name},
        TicketID  => $TicketID,
        UserID    => undef,
        Success   => 0,
    },
    {
        Name      => 'No Value',
        Value     => undef,
        FieldName => $DynamicFieldConfig->{Name},
        TicketID  => $TicketID,
        UserID    => 1,
        Success   => 1,
    },
    {
        Name      => 'Simple Text Value',
        Value     => 'A Value',
        FieldName => $DynamicFieldConfig->{Name},
        TicketID  => $TicketID,
        UserID    => 1,
        Success   => 1,
    },
);

for my $Test (@Tests) {

    # set the dynamic field velue
    my $Success = $TicketObject->TicketDynamicFieldSet(
        FieldName => $Test->{FieldName},
        Value     => $Test->{Value},
        TicketID  => $Test->{TicketID},
        UserID    => $Test->{UserID},
    );

    # get the ticket
    my %Ticket = $TicketObject->TicketGet( TicketID => $TicketID, UserID => 1 );

    # sanity check
    $Self->True(
        \%Ticket,
        "TicketGet() - Test ($Test->{Name}) - with True",

    );
    $Self->IsNotDeeply(
        \%Ticket,
        {},
        "Ticket is not empty",
    );

    if ( !$Test->{Success} ) {

        # check for unsuccessful set
        $Self->False(
            $Success,
            "TicketDynamicFieldSet() - Test ($Test->{Name}) - with False",
        );

        # check for dynamic field value
        $Self->Is(
            $Ticket{ 'DynamicField_' . $Test->{FieldName} },
            undef,
            "TicketGet() - Test ($Test->{Name}) - matched field ID "
                . $DynamicFieldConfig->{ID},
        );
    }
    else {

        # check for successful set
        $Self->True(
            $Success,
            "TicketDynamicFieldSet() - Test ($Test->{Name}) - with True",
        );

        # check for dynamic field value
        $Self->Is(
            $Ticket{ 'DynamicField_' . $Test->{FieldName} },
            $Test->{Value},
            "TicketGet() - Test ($Test->{Name}) - matched field ID "
                . $DynamicFieldConfig->{ID},
        );
    }
}

# delete the dynamic field
my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
    ID     => $FieldID,
    UserID => 1,
);

# sanity check
$Self->True(
    $FieldDelete,
    "DynamicFieldDelete() successful for Field ID $FieldID",
);

# now that the field was deleted also "New Value" should be deleted too"
{
    my $DeleteSuccess = $DynamicFieldValueObject->ValueDelete(
        FieldID    => $FieldID,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        UserID     => 1,
    );

    $Self->False(
        $DeleteSuccess,
        "ValueDelete() unsuccessful for New Value - for FieldID $FieldID",
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

my @OriginalFreeFields;

# backup existing freefields and recover after the tests
# get the fields list
my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
    ObjectType => 'Ticket',
);

# check for TicketFreeText, TicketFreeKey and TicketFreeTime
for my $DynamicFieldConfig ( @{$DynamicFieldList} ) {
    if (
        $DynamicFieldConfig->{Name} =~ m{
       \A
       (
            TicketFree
            (?:
                (?:Text|Key)
                (?:1[0-6]|[1-9])
                |
                (?:Time [1-6])
            )
        )
        \z
    }gmxi
        )
    {

        # add Field Config to
        push @OriginalFreeFields, $DynamicFieldConfig
    }
}

if (@OriginalFreeFields) {

    $Self->True(
        @OriginalFreeFields,
        "FreeFields found on the system and needs to be updated befor this test continue",
    );

    for my $DynamicFieldConfig (@OriginalFreeFields) {

        # rename field
        my $Success = $DynamicFieldObject->DynamicFieldUpdate(
            %{$DynamicFieldConfig},

            # override name
            Name    => 'TestTicketDynamicField' . $DynamicFieldConfig->{Name},
            Reorder => 0,
            UserID  => 1,
        );

        $Self->True(
            $Success,
            "Renamed field $DynamicFieldConfig->{Name} to "
                . "TestTicketDynamicField$DynamicFieldConfig->{Name}",
            )
    }
    $Self->True(
        @OriginalFreeFields,
        "End of original fields update",
    );
}

# backward compatibity tests
# create a ticket
$TicketID = $TicketObject->TicketCreate(
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

# create an article
my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'note-internal',
    SenderType     => 'agent',
    From           => 'Some Agent <email@example.com>',
    Subject        => 'some short description',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 0,
);

# sanity check
$Self->True(
    $ArticleID,
    "TicketCreate() successful for Ticket ID $TicketID",
);

my @FreeFieldIDs;

# define TicketFreeText fields
for my $Counter ( 1 .. 16 ) {

    for my $Part (qw(Key Text)) {

        # create a dynamic field
        my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
            Name       => 'TicketFree' . $Part . $Counter,
            Label      => 'TicketFree' . $Part . $Counter,
            FieldOrder => 9890 + $Counter,
            FieldType  => 'Text',
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
            "DynamicFieldAdd() TicketFreeText$Counter, successful for Field ID $FieldID",
        );

        push @FreeFieldIDs, $FieldID;
    }

    # set Dynamic Field value using legacy function
    my $Success = $TicketObject->TicketFreeTextSet(
        Counter  => $Counter,
        Key      => 'Planet' . $Counter,
        Value    => 'Sun' . $Counter,
        TicketID => $TicketID,
        UserID   => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "TicketFreeTextSet() TicketFreeText$Counter, successful for Free Field $Counter",
    );
}

# define TicketFreeTime fields
for my $Counter ( 1 .. 6 ) {

    # create a dynamic field
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => 'TicketFreeTime' . $Counter,
        Label      => 'TicketFreeTime' . $Counter,
        FieldOrder => 9900 + $Counter,
        FieldType  => 'DateTime',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue => '1977:12:12 12:00:00',
        },
        ValidID => 1,
        UserID  => 1,
    );

    # sanity check
    $Self->True(
        $FieldID,
        "DynamicFieldAdd() TicketFreeTime$Counter, successful for Field ID $FieldID",
    );

    push @FreeFieldIDs, $FieldID;

    # set Dynamic Field value using legacy function
    my $Success = $TicketObject->TicketFreeTimeSet(
        Counter                                => $Counter,
        'TicketFreeTime' . $Counter . 'Year'   => 2000 + $Counter,
        'TicketFreeTime' . $Counter . 'Month'  => 12,
        'TicketFreeTime' . $Counter . 'Day'    => 20,
        'TicketFreeTime' . $Counter . 'Hour'   => 03,
        'TicketFreeTime' . $Counter . 'Minute' => 36,
        TicketID                               => $TicketID,
        UserID                                 => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "TicketFreeTimeSet() TicketFreeTime$Counter, successful for Free Time Field $Counter",
    );
}

# get the ticket
my %Ticket = $TicketObject->TicketGet( TicketID => $TicketID, UserID => 1 );

for my $Counter ( 1 .. 16 ) {

    # check each legacy FreeText field for Text and Key
    $Self->Is(
        $Ticket{ 'DynamicField_TicketFreeText' . $Counter },
        'Sun' . $Counter,
        "Dynamic Field TicketFreeText$Counter content match the expected value",
    );
    $Self->Is(
        $Ticket{ 'DynamicField_TicketFreeKey' . $Counter },
        'Planet' . $Counter,
        "Dynamic Field TicketFreeKey$Counter content match the expected value",
    );

}

# Old tests from Ticket.t
# Check the TicketFreeField functions
my %TicketFreeText = ();
for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $TicketObject->TicketFreeTextSet(
        Counter  => $_,
        Key      => 'Planet' . $_,
        Value    => 'Sun' . $_,
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet() ' . $_,
    );
}

%TicketFreeText = $TicketObject->TicketGet( TicketID => $TicketID );
for ( 1 .. 16 ) {
    $Self->Is(
        $TicketFreeText{ 'TicketFreeKey' . $_ },
        'Planet' . $_,
        "TicketGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $TicketFreeText{ 'TicketFreeText' . $_ },
        'Sun' . $_,
        "TicketGet() (TicketFreeText$_)",
    );
}

# TicketFreeTextSet check, if only a value is available but no key
for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $TicketObject->TicketFreeTextSet(
        Counter  => $_,
        Value    => 'Earth' . $_,
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet () without key ' . $_,
    );
}

%TicketFreeText = $TicketObject->TicketGet( TicketID => $TicketID );

for ( 1 .. 16 ) {
    $Self->Is(
        $TicketFreeText{ 'TicketFreeKey' . $_ },
        'Planet' . $_,
        "TicketGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $TicketFreeText{ 'TicketFreeText' . $_ },
        'Earth' . $_,
        "TicketGet() (TicketFreeText$_)",
    );
}

# TicketFreeTextSet check, if only a key is available but no value
for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $TicketObject->TicketFreeTextSet(
        Counter  => $_,
        Key      => 'Location' . $_,
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet () without value ' . $_,
    );
}

%TicketFreeText = $TicketObject->TicketGet( TicketID => $TicketID );

for ( 1 .. 16 ) {
    $Self->Is(
        $TicketFreeText{ 'TicketFreeKey' . $_ },
        'Location' . $_,
        "TicketGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $TicketFreeText{ 'TicketFreeText' . $_ },
        'Earth' . $_,
        "TicketGet() (TicketFreeText$_)",
    );
}

# TicketFreeTextSet check, if no key and value
for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $TicketObject->TicketFreeTextSet(
        Counter  => $_,
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet () without key and value ' . $_,
    );
}

%TicketFreeText = $TicketObject->TicketGet( TicketID => $TicketID );
for ( 1 .. 16 ) {
    $Self->Is(
        $TicketFreeText{ 'TicketFreeKey' . $_ },
        'Location' . $_,
        "TicketGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $TicketFreeText{ 'TicketFreeText' . $_ },
        'Earth' . $_,
        "TicketGet() (TicketFreeText$_)",
    );
}

# TicketFreeTextSet check, with empty keys and values
for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $TicketObject->TicketFreeTextSet(
        Counter  => $_,
        TicketID => $TicketID,
        Key      => '',
        Value    => '',
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet () with empty key and value ' . $_,
    );
}

%TicketFreeText = $TicketObject->TicketGet( TicketID => $TicketID );
for ( 1 .. 16 ) {
    $Self->Is(
        $TicketFreeText{ 'TicketFreeKey' . $_ },
        '',
        "TicketGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $TicketFreeText{ 'TicketFreeText' . $_ },
        '',
        "TicketGet() (TicketFreeText$_)",
    );
}

for ( 1 .. 16 ) {
    my $TicketFreeTextSet = $TicketObject->TicketFreeTextSet(
        Counter  => $_,
        Key      => 'Hans_' . $_,
        Value    => 'Max_' . $_,
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $TicketFreeTextSet,
        'TicketFreeTextSet() ' . $_,
    );
}

#TODO Reenable this test when TicketSearch using DynamicFields is ready
#my %TicketIDsSearch = $TicketObject->TicketSearch(
#    Result          => 'HASH',
#    Limit           => 100,
#    TicketFreeKey1  => 'Hans_1',
#    TicketFreeText1 => 'Max_1',
#    UserID          => 1,
#    Permission      => 'rw',
#);
#$Self->True(
#    $TicketIDsSearch{$TicketID},
#    'TicketSearch() (HASH:TicketFreeKey1 and TicketFreeText1 with _)',
#);

# TicketFreeTime tests
for my $Counter ( 1 .. 6 ) {

    # check each legacy FreeText field for Text and Key
    $Self->Is(
        $Ticket{ 'DynamicField_TicketFreeTime' . $Counter },
        '200' . $Counter . '-12-20 03:36:00',
        "Dynamic Field TicketFreeTime$Counter content match the expected value",
    );
}

# Old tests from Ticket.t
# Check the TicketFreeTime functions
my %TicketFreeTime = ();
for ( 1 .. 5 ) {
    my $TicketFreeTimeSet = $TicketObject->TicketFreeTimeSet(
        Counter          => $_,
        Prefix           => 'a',
        "a$_" . "Year"   => 2008,
        "a$_" . "Month"  => 2,
        "a$_" . "Day"    => 25,
        "a$_" . "Hour"   => 22,
        "a$_" . "Minute" => $_,
        TicketID         => $TicketID,
        UserID           => 1,
    );
    $Self->True(
        $TicketFreeTimeSet,
        'TicketFreeTimeSet() ' . $_,
    );
}

%TicketFreeTime = $TicketObject->TicketGet( TicketID => $TicketID );
for ( 1 .. 5 ) {
    $Self->Is(
        $TicketFreeTime{ 'TicketFreeTime' . $_ },
        "2008-02-25 22:0$_:00",
        "TicketGet() (TicketFreeTime$_)",
    );
}

my @ArticleFreeTime = $TicketObject->ArticleGet( TicketID => $TicketID );
for ( 1 .. 5 ) {
    $Self->Is(
        $ArticleFreeTime[0]->{ 'TicketFreeTime' . $_ },
        "2008-02-25 22:0$_:00",
        "ArticleGet() (TicketFreeTime$_)",
    );
}

# set undef
for ( 1 .. 5 ) {
    my $TicketFreeTimeSet = $TicketObject->TicketFreeTimeSet(
        Counter          => $_,
        Prefix           => 'a',
        "a$_" . "Year"   => '0000',
        "a$_" . "Month"  => 0,
        "a$_" . "Day"    => 0,
        "a$_" . "Hour"   => 0,
        "a$_" . "Minute" => 0,
        TicketID         => $TicketID,
        UserID           => 1,
    );
    $Self->True(
        $TicketFreeTimeSet,
        'TicketFreeTimeSet() ' . $_,
    );
}

%TicketFreeTime = $TicketObject->TicketGet( TicketID => $TicketID );
for ( 1 .. 5 ) {
    $Self->Is(
        $TicketFreeTime{ 'TicketFreeTime' . $_ },
        undef,
        "TicketGet() (TicketFreeTime$_)",
    );
}

# TODO Add History Tests from Ticket.t

# delete the dynamic fields
for my $FieldID (@FreeFieldIDs) {

    # delete the dynamic field
    my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $FieldID,
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $FieldDelete,
        "DynamicFieldDelete() successful for Field ID $FieldID",
    );
}

# check if there was FreeFields originaly on the configuration
if (@OriginalFreeFields) {

    $Self->True(
        @OriginalFreeFields,
        "FreeFields found on the system and needs to be restored",
    );

    # restore original configuration
    for my $DynamicFieldConfig (@OriginalFreeFields) {

        my $Success = $DynamicFieldObject->DynamicFieldUpdate(
            %{$DynamicFieldConfig},
            Reorder => 0,
            UserID  => 1,
        );

        $Self->True(
            $Success,
            "Restored field $DynamicFieldConfig->{Name}"
            )
    }
    $Self->True(
        @OriginalFreeFields,
        "End of original fields restore",
    );
}

# delete the ticket
$TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

# sanity check
$Self->True(
    $TicketDelete,
    "TicketDelete() successful for Ticket ID $TicketID",
);

1;
