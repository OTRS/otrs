# --
# ArticleDynamicField.t - Article Dynamic Field tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ArticleDynamicField.t,v 1.2 2011-09-01 22:19:41 cr Exp $
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
$Self->IsNot(
    $TicketID,
    undef,
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
    "ArticleCreate() successful for Ticket ID $TicketID",
);

# create a dynamic field
my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "dynamicfieldtest$RandomID",
    Label      => 'a description',
    FieldOrder => 9991,
    FieldType  => 'Text',      # mandatory, selects the DF backend to use for this field
    ObjectType => 'Article',
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
        ArticleID => $ArticleID,
        TicketID  => $ArticleID,
        UserID    => 1,
        Success   => 0,
    },
    {
        Name      => 'No ArticleID',
        Value     => 'A Value',
        FieldName => $DynamicFieldConfig->{Name},
        ArticleID => undef,
        TicketID  => $ArticleID,
        UserID    => 1,
        Success   => 0,
    },
    {
        Name      => 'No UserID',
        Value     => 'A Value',
        FieldName => $DynamicFieldConfig->{Name},
        ArticleID => $ArticleID,
        TicketID  => $ArticleID,
        UserID    => undef,
        Success   => 0,
    },
    {
        Name      => 'No Value',
        Value     => undef,
        FieldName => $DynamicFieldConfig->{Name},
        ArticleID => $ArticleID,
        TicketID  => $ArticleID,
        UserID    => 1,
        Success   => 1,
    },
    {
        Name      => 'No TicketID',
        Value     => 'A Value',
        FieldName => $DynamicFieldConfig->{Name},
        ArticleID => $ArticleID,
        TicketID  => undef,
        UserID    => 1,
        Success   => 0,
    },
    {
        Name      => 'Simple Text Value',
        Value     => 'A Value',
        FieldName => $DynamicFieldConfig->{Name},
        ArticleID => $ArticleID,
        TicketID  => $ArticleID,
        UserID    => 1,
        Success   => 1,
    },
);

for my $Test (@Tests) {

    # set the dynamic field velue
    my $Success = $TicketObject->ArticleDynamicFieldSet(
        FieldName => $Test->{FieldName},
        Value     => $Test->{Value},
        TicketID  => $Test->{TicketID},
        ArticleID => $Test->{ArticleID},
        UserID    => $Test->{UserID},
    );

    # get the article
    my %ArticleIndex = $TicketObject->ArticleGet(
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    # sanity check
    $Self->True(
        \%ArticleIndex,
        "ArticleGet() - Test ($Test->{Name}) - With true",

    );
    $Self->IsNotDeeply(
        \%ArticleIndex,
        {},
        "Article is not empty",
    );

    if ( !$Test->{Success} ) {

        # check for unsuccessful set
        $Self->False(
            $Success,
            "ArticleDynamicFieldSet() - Test ($Test->{Name}) - with False",
        );

        # check for dynamic field value
        $Self->Is(
            $ArticleIndex{ 'DynamicField_' . $Test->{FieldName} },
            undef,
            "ArticleGet() - Test ($Test->{Name}) - matched field ID "
                . $DynamicFieldConfig->{ID},
        );
    }
    else {

        # check for successful set
        $Self->True(
            $Success,
            "ArticleDynamicFieldSet() - Test ($Test->{Name}) - with True",
        );

        # check for dynamic field value
        $Self->Is(
            $ArticleIndex{ 'DynamicField_' . $Test->{FieldName} },
            $Test->{Value},
            "ArticleGet() - Test ($Test->{Name}) - matched field ID "
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

my %OriginalFreeFields;

# check if configuration already has freefields as dynamic fields
# get the fields list
my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
    ObjectType => 'Ticket',
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
                (?:[1-3])
            )
        )
        \z
    }gmxi
        )
    {

        # set field reference
        $OriginalFreeFields{ $DynamicFieldConfig->{Name} } = 1;
    }
}

# get the fields list
$DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
    ObjectType => 'Article',
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
        }gmxi
        )
    {

        # set field reference
        $OriginalFreeFields{ $DynamicFieldConfig->{Name} } = 1;
    }
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
$ArticleID = $TicketObject->ArticleCreate(
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

    FIELD:
    for my $Part (qw(Key Text)) {
        next FIELD if $OriginalFreeFields{ 'TicketFree' . $Part . $Counter };

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

    ARTICLEFIELD:
    for my $Part (qw(Key Text)) {
        next ARTICLEFIELD if $OriginalFreeFields{ 'ArticleFree' . $Part . $Counter };

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

my %Article = $TicketObject->ArticleGet( ArticleID => $ArticleID );
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
        'ArticleFreeTextSet() ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet( ArticleID => $ArticleID );
for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeKey' . $_ },
        'Planet' . $_,
        "ArticleGet() (ArticleFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeText' . $_ },
        'Sun' . $_,
        "ArticleGet() (ArticleFreeText$_)",
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
        'ArticleFreeTextSet () without key ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet( ArticleID => $ArticleID );

for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeKey' . $_ },
        'Planet' . $_,
        "ArticleGet() (ArticleFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeText' . $_ },
        'Earth' . $_,
        "ArticleGet() (ArticleFreeText$_)",
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
        'ArticleFreeTextSet () without value ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet( ArticleID => $ArticleID );

for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeKey' . $_ },
        'Location' . $_,
        "ArticleGet() (ArticleFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeText' . $_ },
        'Earth' . $_,
        "ArticleGet() (ArticleFreeText$_)",
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
        'ArticleFreeTextSet () without key and value ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet( ArticleID => $ArticleID );
for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeKey' . $_ },
        'Location' . $_,
        "ArticleGet() (ArticleFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeText' . $_ },
        'Earth' . $_,
        "ArticleGet() (ArticleFreeText$_)",
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
        'ArticleFreeTextSet () with empty key and value ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet( ArticleID => $ArticleID );
for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeKey' . $_ },
        '',
        "ArticleGet() (ArticleFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'ArticleFreeText' . $_ },
        '',
        "ArticleGet() (ArticleFreeText$_)",
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
        'ArticleFreeTextSet() ' . $_,
    );
}

%ArticleFreeText = $TicketObject->ArticleGet( ArticleID => $ArticleID );
for ( 1 .. 16 ) {
    $Self->Is(
        $ArticleFreeText{ 'TicketFreeKey' . $_ },
        'Hans_' . $_,
        "ArticleGet() (TicketFreeKey$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'TicketFreeText' . $_ },
        'Max_' . $_,
        "ArticleGet() (TicketFreeText$_)",
    );
}
for ( 1 .. 3 ) {
    $Self->Is(
        $ArticleFreeText{ 'TicketFreeKey' . $_ },
        'Hans_' . $_,
        "ArticleGet() (TicketFreeText$_)",
    );
    $Self->Is(
        $ArticleFreeText{ 'TicketFreeText' . $_ },
        'Max_' . $_,
        "ArticleGet() (TicketFreeText$_)",
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
