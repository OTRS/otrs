# --
# TicketFreeField.t - Ticket Free Field tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: TicketFreeField.t,v 1.7 2012-03-20 16:27:57 mg Exp $
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

my @OriginalFreeFields;

# check if configuration already has freefields as dynamic fields
# get the fields list
my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
    ObjectType => 'Ticket',
    Valid      => 0,
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
    }smxi
        )
    {

        # set field reference
        push @OriginalFreeFields, $DynamicFieldConfig;
    }
}

# rename original fields
for my $OriginalFreeFieldConfig (@OriginalFreeFields) {
    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        %{$OriginalFreeFieldConfig},
        Name    => 'TicketFreeFieldTest' . $RandomID . $OriginalFreeFieldConfig->{Name},
        Reorder => 0,
        UserID  => 1,
    );

    # sanity checks
    $Self->True(
        $Success,
        "Renamed field $OriginalFreeFieldConfig->{Name} to "
            . "TicketFreeFieldTest" . $RandomID . $OriginalFreeFieldConfig->{Name} . " using "
            . "DynamicFieldUpdate()",
    );

    my $UpdatedDynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name => 'TicketFreeFieldTest' . $RandomID . $OriginalFreeFieldConfig->{Name},
    );

    $Self->Is(
        $OriginalFreeFieldConfig->{ID},
        $UpdatedDynamicFieldConfig->{ID},
        "The ID of the Original and the Renamed field match"
    );
}

# backward compatibity tests
# create a ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => "Ticket$RandomID",
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
    "ArticleCreate() successful for Article ID $ArticleID",
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
            Reorder => 0,
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
}

for my $Counter ( 1 .. 6 ) {

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
my %Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    UserID        => 1,
    DynamicFields => 1,
);

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

%TicketFreeText = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);
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
        'TicketFreeTextSet() without key ' . $_,
    );
}

%TicketFreeText = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);

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

%TicketFreeText = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);

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

%TicketFreeText = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);
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
        'TicketFreeTextSet() with empty key and value ' . $_,
    );
}

%TicketFreeText = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);
for ( 1 .. 16 ) {

    #workaround oracle
    if ( $TicketObject->{ConfigObject}->Get('DatabaseDSN') =~ m{DBI:Oracle}gi ) {
        if ( !defined $TicketFreeText{ 'TicketFreeKey' . $_ } ) {
            $TicketFreeText{ 'TicketFreeKey' . $_ } = '';
        }
        if ( !defined $TicketFreeText{ 'TicketFreeText' . $_ } ) {
            $TicketFreeText{ 'TicketFreeText' . $_ } = '';
        }
    }

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

my @SearchTests = (
    {
        Name  => 'TicketFreeKey',
        Field => 'TicketFreeKey',
        Value => 'Hans_',
    },
    {
        Name  => 'TicketFreeText',
        Field => 'TicketFreeText',
        Value => 'Max_',
    },
);

for my $Test (@SearchTests) {

    for my $Counter ( 1 .. 16 ) {

        my %TicketIDsSearch = $TicketObject->TicketSearch(
            Result                   => 'HASH',
            Limit                    => 100,
            Title                    => "Ticket$RandomID",
            "$Test->{Field}$Counter" => {
                Equals => "$Test->{Value}$Counter",
            },
            UserID     => 1,
            Permission => 'rw',
        );

        $Self->IsDeeply(
            \%TicketIDsSearch,
            { $TicketID => $Ticket{TicketNumber} },
            "Search for one field ($Test->{Field}$Counter)",
        );
    }
}

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

%TicketFreeTime = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);
for ( 1 .. 5 ) {
    $Self->Is(
        $TicketFreeTime{ 'TicketFreeTime' . $_ },
        "2008-02-25 22:0$_:00",
        "TicketGet() (TicketFreeTime$_)",
    );
}

my @ArticleFreeTime = $TicketObject->ArticleGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);
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

%TicketFreeTime = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);
for ( 1 .. 5 ) {
    $Self->Is(
        $TicketFreeTime{ 'TicketFreeTime' . $_ },
        undef,
        "TicketGet() (TicketFreeTime$_)",
    );
}

my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
    SystemTime => $Self->{TimeObject}->SystemTime(),
);

my %TicketStatus = $TicketObject->HistoryTicketStatusGet(
    StopYear   => $Year,
    StopMonth  => $Month,
    StopDay    => $Day,
    StartYear  => $Year - 2,
    StartMonth => $Month,
    StartDay   => $Day,
);
if ( $TicketStatus{$TicketID} ) {
    my %TicketHistory = %{ $TicketStatus{$TicketID} };

    for ( 1 .. 16 ) {
        $Self->Is(
            $TicketHistory{ 'TicketFreeKey' . $_ },
            'Hans_' . $_,
            "HistoryTicketStatusGet() (TicketFreeKey$_)",
        );
        $Self->Is(
            $TicketHistory{ 'TicketFreeText' . $_ },
            'Max_' . $_,
            "HistoryTicketStatusGet() (TicketFreeText$_)",
        );
    }
}
else {
    $Self->True(
        0,
        'HistoryTicketStatusGet()',
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

# delete the dynamic fields
for my $FieldID (@FreeFieldIDs) {

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet( ID => $FieldID );

    # delete the dynamic field
    my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
        ID      => $FieldID,
        UserID  => 1,
        Reorder => 0,
    );

    # sanity check
    $Self->True(
        $FieldDelete,
        "DynamicFieldDelete() successful for Field ID $FieldID - $DynamicFieldConfig->{Name}",
    );
}

# restore original fields
for my $OriginalFreeFieldConfig (@OriginalFreeFields) {
    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        %{$OriginalFreeFieldConfig},
        Reorder => 0,
        UserID  => 1,
    );

    # sanity checks
    $Self->True(
        $Success,
        "Restored field $OriginalFreeFieldConfig->{Name}"
    );

    my $UpdatedDynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name => $OriginalFreeFieldConfig->{Name},
    );

    $Self->Is(
        $OriginalFreeFieldConfig->{ID},
        $UpdatedDynamicFieldConfig->{ID},
        "The ID of the Original field (DynamicFieldGet by Name) match"
    );
}

1;
