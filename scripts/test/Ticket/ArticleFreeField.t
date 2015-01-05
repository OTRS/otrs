# --
# ArticleFreeField.t - Article Free Field tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: ArticleFreeField.t,v 1.8 2012-03-20 16:27:57 mg Exp $
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

# check for TicketFreeText, TicketFreeKey, TicketFreeTime ArticleFreeText
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

# get the fields list
$DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
    ObjectType => 'Article',
    Valid      => 0,
);

# check for TicketFreeText, TicketFreeKey, TicketFreeTime ArticleFreeText
for my $DynamicFieldConfig ( @{$DynamicFieldList} ) {
    if (
        $DynamicFieldConfig->{Name} =~ m{
           \A
           (
                ArticleFree
                (?:
                    (?:Text|Key)
                    (?:[1-3])
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
    From           => 'Some Agent <agentl@localunittest.com>',
    To             => 'Some Customer <customer@localunittest.com>',
    Subject        => 'some short description',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,
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
        Key      => 'Hans_' . $Counter,
        Value    => 'Max_' . $Counter,
        TicketID => $TicketID,
        UserID   => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "TicketFreeTextSet() TicketFreeText$Counter, successful for Free Field $Counter",
    );
}

# define ArticleFreeText fields
for my $Counter ( 1 .. 3 ) {

    for my $Part (qw(Key Text)) {

        # create a dynamic field
        my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
            Name       => 'ArticleFree' . $Part . $Counter,
            Label      => 'ArticleFree' . $Part . $Counter,
            FieldOrder => 9990 + $Counter,
            FieldType  => 'Text',
            ObjectType => 'Article',
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
            "DynamicFieldAdd() ArticleFreeText$Counter, successful for Field ID $FieldID",
        );

        push @FreeFieldIDs, $FieldID;
    }

    # set Dynamic Field value using legacy function
    my $Success = $TicketObject->ArticleFreeTextSet(
        Counter   => $Counter,
        Key       => 'Planet' . $Counter,
        Value     => 'Sun' . $Counter,
        ArticleID => $ArticleID,
        TicketID  => $TicketID,
        UserID    => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "ArticeFreeTextSet() ArticleFreeText$Counter, successful for Free Field $Counter",
    );
}

my %Article = $TicketObject->ArticleGet(
    ArticleID     => $ArticleID,
    DynamicFields => 1,
);
for my $Counter ( 1 .. 3 ) {

    # check each legacy FreeText field for Text and Key
    $Self->Is(
        $Article{ 'DynamicField_ArticleFreeText' . $Counter },
        'Sun' . $Counter,
        "Dynamic Field ArticleFreeText$Counter content match the expected value",
    );
    $Self->Is(
        $Article{ 'DynamicField_ArticleFreeKey' . $Counter },
        'Planet' . $Counter,
        "Dynamic Field ArticleFreeKey$Counter content match the expected value",
    );
}

# Old tests from Ticket.t
# Check the ArticleFreeField functions
my %ArticleFreeText = ();
for ( 1 .. 3 ) {
    my $ArticleFreeTextSet = $TicketObject->ArticleFreeTextSet(
        Counter   => $_,
        Key       => 'Planet' . $_,
        Value     => 'Sun' . $_,
        ArticleID => $ArticleID,
        TicketID  => $TicketID,
        UserID    => 1,
    );
    $Self->True(
        $ArticleFreeTextSet,
        'ArticleFreeTextSet() 1 ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet(
    ArticleID     => $ArticleID,
    DynamicFields => 1,
);
for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeKey' . $_ },
        'Planet' . $_,
        "ArticleGet() 1 (ArticleFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeText' . $_ },
        'Sun' . $_,
        "ArticleGet() 1 (ArticleFreeText$_)",
    );
}

# ArticleFreeTextSet check, if only a value is available but no key
for ( 1 .. 3 ) {
    my $ArticleFreeTextSet = $TicketObject->ArticleFreeTextSet(
        Counter   => $_,
        Value     => 'Earth' . $_,
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        UserID    => 1,
    );
    $Self->True(
        $ArticleFreeTextSet,
        'ArticleFreeTextSet() 2 without key ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet(
    ArticleID     => $ArticleID,
    DynamicFields => 1,
);

for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeKey' . $_ },
        'Planet' . $_,
        "ArticleGet() 2 (ArticleFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeText' . $_ },
        'Earth' . $_,
        "ArticleGet() 2 (ArticleFreeText$_)",
    );
}

# ArticleFreeTextSet check, if only a key is available but no value
for ( 1 .. 3 ) {
    my $ArticleFreeTextSet = $TicketObject->ArticleFreeTextSet(
        Counter   => $_,
        Key       => 'Location' . $_,
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        UserID    => 1,
    );
    $Self->True(
        $ArticleFreeTextSet,
        'ArticleFreeTextSet () 3 without value ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet(
    ArticleID     => $ArticleID,
    DynamicFields => 1,
);

for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeKey' . $_ },
        'Location' . $_,
        "ArticleGet() 3 (ArticleFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeText' . $_ },
        'Earth' . $_,
        "ArticleGet() 3 (ArticleFreeText$_)",
    );
}

# ArticleFreeTextSet check, if no key and value
for ( 1 .. 3 ) {
    my $ArticleFreeTextSet = $TicketObject->ArticleFreeTextSet(
        Counter   => $_,
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        UserID    => 1,
    );
    $Self->True(
        $ArticleFreeTextSet,
        'ArticleFreeTextSet() 4 without key and value ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet(
    ArticleID     => $ArticleID,
    DynamicFields => 1,
);
for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeKey' . $_ },
        'Location' . $_,
        "ArticleGet() 4 (ArticleFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeText' . $_ },
        'Earth' . $_,
        "ArticleGet() 4 (ArticleFreeText$_)",
    );
}

# ArticleFreeTextSet check, with empty keys and values
for ( 1 .. 3 ) {
    my $ArticleFreeTextSet = $TicketObject->ArticleFreeTextSet(
        Counter   => $_,
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        Key       => '',
        Value     => '',
        UserID    => 1,
    );
    $Self->True(
        $ArticleFreeTextSet,
        'ArticleFreeTextSet() 5 with empty key and value ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet(
    ArticleID     => $ArticleID,
    DynamicFields => 1,
);
for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeKey' . $_ } || '',
        '',
        "ArticleGet() 5 (ArticleFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeText' . $_ } || '',
        '',
        "ArticleGet() 5 (ArticleFreeText$_)",
    );
}

for ( 1 .. 3 ) {
    my $ArticleTextSet = $TicketObject->ArticleFreeTextSet(
        Counter   => $_,
        Key       => 'Hans_' . $_,
        Value     => 'Max_' . $_,
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        UserID    => 1,
    );
    $Self->True(
        $ArticleTextSet,
        'ArticleFreeTextSet() 6 ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet(
    ArticleID     => $ArticleID,
    DynamicFields => 1,
);
for ( 1 .. 16 ) {
    $Self->Is(
        $ArticleFreeText{ 'TicketFreeKey' . $_ },
        'Hans_' . $_,
        "ArticleGet() 6 (TicketFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'TicketFreeText' . $_ },
        'Max_' . $_,
        "ArticleGet() 6 (TicketFreeText$_)",
    );
}
for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'TicketFreeKey' . $_ },
        'Hans_' . $_,
        "ArticleGet() 6 (TicketFreeText$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'TicketFreeText' . $_ },
        'Max_' . $_,
        "ArticleGet() 6 (TicketFreeText$_)",
    );
}

#TODO Reenable this test when TicketSearch using DynamicFields is ready
#my %ArticleIDsSearch = $TicketObject->TicketSearch(
#    Result          => 'HASH',
#    Limit           => 100,
#    ArticleFreeKey1  => 'Hans_1',
#    ArticleFreeText1 => 'Max_1',
#    UserID          => 1,
#    Permission      => 'rw',
#);
#$Self->True(
#    $ArticleIDsSearch{$TicketID},
#    'TicketSearch() (HASH:ArticleFreeKey1 and ArticleFreeText1 with _)',
#);

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
