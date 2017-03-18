# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use MIME::Base64;

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation::Session::SessionCreate;
use Kernel::GenericInterface::Operation::Ticket::TicketGet;

use Kernel::System::VariableCheck qw(:all);

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# disable SessionCheckRemoteIP setting
$ConfigObject->Set(
    Key   => 'SessionCheckRemoteIP',
    Value => 0,
);

# get helper object
# skip SSL certificate verification
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get a random number
my $RandomID = $Helper->GetRandomNumber();

# create a new user for current test
my $UserLogin = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $Password = $UserLogin;

my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $UserLogin,
);

# create a new user without permissions for current test
my $UserLogin2 = $Helper->TestUserCreate();
my $Password2  = $UserLogin2;

# create a customer where a ticket will use and will have permissions
my $CustomerUserLogin = $Helper->TestCustomerUserCreate();
my $CustomerPassword  = $CustomerUserLogin;

# create a customer that will not have permissions
my $CustomerUserLogin2 = $Helper->TestCustomerUserCreate();
my $CustomerPassword2  = $CustomerUserLogin2;

my %SkipFields = (
    Age                       => 1,
    AgeTimeUnix               => 1,
    UntilTime                 => 1,
    SolutionTime              => 1,
    SolutionTimeWorkingTime   => 1,
    EscalationTime            => 1,
    EscalationDestinationIn   => 1,
    EscalationTimeWorkingTime => 1,
    UpdateTime                => 1,
    UpdateTimeWorkingTime     => 1,
    Created                   => 1,
    Changed                   => 1,
    UnlockTimeout             => 1,
);

# create dynamic field properties
my @DynamicFieldProperties = (
    {
        Name       => "DFT1$RandomID",
        FieldOrder => 9991,
        FieldType  => 'Text',
        Config     => {
            DefaultValue => 'Default',
        },
    },
    {
        Name       => "DFT2$RandomID",
        FieldOrder => 9992,
        FieldType  => 'Dropdown',
        Config     => {
            DefaultValue   => 'Default',
            PossibleValues => {
                ticket1_field2 => 'ticket1_field2',
                ticket2_field2 => 'ticket2_field2',
            },
        },
    },
    {
        Name       => "DFT3$RandomID",
        FieldOrder => 9993,
        FieldType  => 'DateTime',        # mandatory, selects the DF backend to use for this field
        Config     => {
            DefaultValue => 'Default',
        },
    },
    {
        Name       => "DFT4$RandomID",
        FieldOrder => 9993,
        FieldType  => 'Checkbox',        # mandatory, selects the DF backend to use for this field
        Config     => {
            DefaultValue => 'Default',
        },
    },
    {
        Name       => "DFT5$RandomID",
        FieldOrder => 9995,
        FieldType  => 'Multiselect',     # mandatory, selects the DF backend to use for this field
        Config     => {
            DefaultValue   => [ 'ticket2_field5', 'ticket4_field5' ],
            PossibleValues => {
                ticket1_field5 => 'ticket1_field51',
                ticket2_field5 => 'ticket2_field52',
                ticket3_field5 => 'ticket2_field53',
                ticket4_field5 => 'ticket2_field54',
                ticket5_field5 => 'ticket2_field55',
            },
        },
    }
);

# create dynamic fields
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my @TestFieldConfig;

for my $DynamicFieldProperty (@DynamicFieldProperties) {
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        %{$DynamicFieldProperty},
        Label      => 'Description',
        ObjectType => 'Ticket',
        ValidID    => 1,
        UserID     => 1,
        Reorder    => 0,
    );

    push @TestFieldConfig, $DynamicFieldObject->DynamicFieldGet(
        ID => $FieldID,
    );
}

# create ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# create 3 tickets

#ticket id container
my @TicketIDs;

# create ticket 1
my $TicketID1 = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customerOne@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID1,
    "TicketCreate() successful for Ticket One ID $TicketID1",
);

# create backend object and delegates
my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
$Self->Is(
    ref $BackendObject,
    'Kernel::System::DynamicField::Backend',
    'Backend object was created successfully',
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[0],
    ObjectID           => $TicketID1,
    Value              => 'ticket1_field1',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[1],
    ObjectID           => $TicketID1,
    Value              => 'ticket1_field2',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[2],
    ObjectID           => $TicketID1,
    Value              => '2001-01-01 01:01:01',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[3],
    ObjectID           => $TicketID1,
    Value              => '0',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[4],
    ObjectID           => $TicketID1,
    Value              => [ 'ticket1_field51', 'ticket1_field52', 'ticket1_field53' ],
    UserID             => 1,
);

# get the Ticket entry
# without dynamic fields
my %TicketEntryOne = $TicketObject->TicketGet(
    TicketID      => $TicketID1,
    DynamicFields => 0,
    UserID        => $UserID,
);

$Self->True(
    IsHashRefWithData( \%TicketEntryOne ),
    "TicketGet() successful for Local TicketGet One ID $TicketID1",
);

for my $Key ( sort keys %TicketEntryOne ) {
    if ( !$TicketEntryOne{$Key} ) {
        $TicketEntryOne{$Key} = '';
    }
    if ( $SkipFields{$Key} ) {
        delete $TicketEntryOne{$Key};
    }
}

my $FormatDynamicFields = sub {
    my %Param = @_;

    my %TicketRaw = %{ $Param{Ticket} };
    my %Ticket;
    my @DynamicFields;

    ATTRIBUTE:
    for my $Attribute ( sort keys %TicketRaw ) {

        if ( $Attribute =~ m{\A DynamicField_(.*) \z}msx ) {
            push @DynamicFields, {
                Name  => $1,
                Value => $TicketRaw{$Attribute},
            };
            next ATTRIBUTE;
        }

        $Ticket{$Attribute} = $TicketRaw{$Attribute};
    }

    # add dynamic fields array into 'DynamicField' hash key if any
    if (@DynamicFields) {
        $Ticket{DynamicField} = \@DynamicFields;
    }

    return %Ticket;
};

# get the Ticket entry
# with dynamic fields
my %TicketEntryOneDF = $TicketObject->TicketGet(
    TicketID      => $TicketID1,
    DynamicFields => 1,
    UserID        => $UserID,
);

$Self->True(
    IsHashRefWithData( \%TicketEntryOneDF ),
    "TicketGet() successful with DF for Local TicketGet One ID $TicketID1",
);

for my $Key ( sort keys %TicketEntryOneDF ) {
    if ( !$TicketEntryOneDF{$Key} ) {
        $TicketEntryOneDF{$Key} = '';
    }
    if ( $SkipFields{$Key} ) {
        delete $TicketEntryOneDF{$Key};
    }
}

%TicketEntryOneDF = $FormatDynamicFields->(
    Ticket => \%TicketEntryOneDF,
);

# add ticket id
push @TicketIDs, $TicketID1;

# create ticket 2
my $TicketID2 = $TicketObject->TicketCreate(
    Title        => 'Ticket Two Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customerTwo@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID2,
    "TicketCreate() successful for Ticket Two ID $TicketID2",
);

# set dynamic field values
$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[0],
    ObjectID           => $TicketID2,
    Value              => 'ticket2_field1',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[1],
    ObjectID           => $TicketID2,
    Value              => 'ticket2_field2',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[2],
    ObjectID           => $TicketID2,
    Value              => '2011-11-11 11:11:11',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[3],
    ObjectID           => $TicketID2,
    Value              => '1',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[4],
    ObjectID           => $TicketID2,
    Value              => [
        'ticket1_field5',
        'ticket2_field5',
        'ticket4_field5',
    ],
    UserID => 1,
);

# get the Ticket entry
# without DF
my %TicketEntryTwo = $TicketObject->TicketGet(
    TicketID      => $TicketID2,
    DynamicFields => 0,
    UserID        => $UserID,
);

$Self->True(
    IsHashRefWithData( \%TicketEntryTwo ),
    "TicketGet() successful for Local TicketGet Two ID $TicketID2",
);

for my $Key ( sort keys %TicketEntryTwo ) {
    if ( !$TicketEntryTwo{$Key} ) {
        $TicketEntryTwo{$Key} = '';
    }
    if ( $SkipFields{$Key} ) {
        delete $TicketEntryTwo{$Key};
    }
}

# get the Ticket entry
# with DF
my %TicketEntryTwoDF = $TicketObject->TicketGet(
    TicketID      => $TicketID2,
    DynamicFields => 1,
    UserID        => $UserID,
);

$Self->True(
    IsHashRefWithData( \%TicketEntryTwoDF ),
    "TicketGet() successful for Local TicketGet Two ID $TicketID2",
);

for my $Key ( sort keys %TicketEntryTwoDF ) {
    if ( !$TicketEntryTwoDF{$Key} ) {
        $TicketEntryTwoDF{$Key} = '';
    }
    if ( $SkipFields{$Key} ) {
        delete $TicketEntryTwoDF{$Key};
    }
}

%TicketEntryTwoDF = $FormatDynamicFields->(
    Ticket => \%TicketEntryTwoDF,
);

# add ticket id
push @TicketIDs, $TicketID2;

# create ticket 3
my $TicketID3 = $TicketObject->TicketCreate(
    Title        => 'Ticket Three Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customerThree@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID3,
    "TicketCreate() successful for Ticket Three ID $TicketID3",
);

# get the Ticket entry
my %TicketEntryThree = $TicketObject->TicketGet(
    TicketID      => $TicketID3,
    DynamicFields => 0,
    UserID        => $UserID,
);

$Self->True(
    IsHashRefWithData( \%TicketEntryThree ),
    "TicketGet() successful for Local TicketGet Three ID $TicketID3",
);

for my $Key ( sort keys %TicketEntryThree ) {
    if ( !$TicketEntryThree{$Key} ) {
        $TicketEntryThree{$Key} = '';
    }
    if ( $SkipFields{$Key} ) {
        delete $TicketEntryThree{$Key};
    }
}

# add ticket id
push @TicketIDs, $TicketID3;

# create ticket 3
my $TicketID4 = $TicketObject->TicketCreate(
    Title        => 'Ticket Four Title äöüßÄÖÜ€ис',
    Queue        => 'Junk',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $CustomerUserLogin,
    CustomerUser => 'customerFour@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID4,
    "TicketCreate() successful for Ticket Four ID $TicketID4",
);

# first article
my $ArticleID41 = $TicketObject->ArticleCreate(
    TicketID       => $TicketID4,
    ArticleType    => 'phone',
    SenderType     => 'agent',
    From           => 'Agent Some Agent Some Agent <email@example.com>',
    To             => 'Customer A <customer-a@example.com>',
    Cc             => 'Customer B <customer-b@example.com>',
    ReplyTo        => 'Customer B <customer-b@example.com>',
    Subject        => 'first article',
    Body           => 'A text for the body, Title äöüßÄÖÜ€ис',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'first article',
    UserID         => 1,
    NoAgentNotify  => 1,
);

# second article
my $ArticleID42 = $TicketObject->ArticleCreate(
    TicketID    => $TicketID4,
    ArticleType => 'phone',
    SenderType  => 'customer',
    From        => 'A not Real Agent <email@example.com>',
    To          => 'Customer A <customer-a@example.com>',
    Cc          => 'Customer B <customer-b@example.com>',
    ReplyTo     => 'Customer B <customer-b@example.com>',
    Subject     => 'second article',
    Body        => 'A text for the body, not too long',
    ContentType => 'text/plain; charset=ISO-8859-15',

    #    Attachment     => \@Attachments,
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'second article',
    UserID         => 1,
    NoAgentNotify  => 1,
);

# third article
my $ArticleID43 = $TicketObject->ArticleCreate(
    TicketID    => $TicketID4,
    ArticleType => 'note-internal',
    SenderType  => 'customer',
    From        => 'A not Real Agent <email@example.com>',
    To          => 'Customer A <customer-a@example.com>',
    Cc          => 'Customer B <customer-b@example.com>',
    ReplyTo     => 'Customer B <customer-b@example.com>',
    Subject     => 'second article',
    Body        => 'A text for the body, not too long',
    ContentType => 'text/plain; charset=ISO-8859-15',

    #    Attachment     => \@Attachments,
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'second article',
    UserID         => 1,
    NoAgentNotify  => 1,
);

# save articles without attachments
my @ArticleWithoutAttachments = $TicketObject->ArticleGet(
    TicketID => $TicketID4,
    UserID   => 1,
);

for my $Article (@ArticleWithoutAttachments) {

    for my $Key ( sort keys %{$Article} ) {
        if ( !$Article->{$Key} ) {
            $Article->{$Key} = '';
        }
        if ( $SkipFields{$Key} ) {
            delete $Article->{$Key};
        }
    }
}

# file checks
for my $File (qw(xls txt doc png pdf)) {
    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File";

    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Type     => 'Local',
    );

    my $ArticleWriteAttachment = $TicketObject->ArticleWriteAttachment(
        Content     => ${$ContentRef},
        Filename    => "StdAttachment-Test1.$File",
        ContentType => $File,
        ArticleID   => $ArticleID42,
        UserID      => 1,
    );
}

my $ArticleFieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "ADFA$RandomID",
    FieldOrder => 9993,
    FieldType  => 'Text',
    Config     => {
        DefaultValue => 'Default',
    },
    Label      => 'Description',
    ObjectType => 'Article',
    ValidID    => 1,
    UserID     => 1,
    Reorder    => 0,
);

push @TestFieldConfig, $DynamicFieldObject->DynamicFieldGet(
    ID => $ArticleFieldID,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[-1],
    ObjectID           => $ArticleID42,
    Value              => 'some value',
    UserID             => 1,
);

# Add a second article dynamic field to force an array reference in remote result and make it easier to check
my $ArticleFieldID2 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "ADFA2$RandomID",
    FieldOrder => 9999,
    FieldType  => 'Text',
    Config     => {
        DefaultValue => 'Default',
    },
    Label      => 'Description',
    ObjectType => 'Article',
    ValidID    => 1,
    UserID     => 1,
    Reorder    => 0,
);

push @TestFieldConfig, $DynamicFieldObject->DynamicFieldGet(
    ID => $ArticleFieldID2,
);

# get articles and attachments
my @ArticleBox = $TicketObject->ArticleGet(
    TicketID => $TicketID4,
    UserID   => 1,
);

# get articles and attachments
my @ArticleBoxDF = $TicketObject->ArticleGet(
    TicketID      => $TicketID4,
    UserID        => 1,
    DynamicFields => 1,
);

my $CustomerArticleTypes = [ $TicketObject->ArticleTypeList( Type => 'Customer' ) ];
my @ArticleBoxTypeCustomer = $TicketObject->ArticleGet(
    TicketID    => $TicketID4,
    UserID      => 1,
    ArticleType => $CustomerArticleTypes,
);

my @ArticleBoxSenderAgent = $TicketObject->ArticleGet(
    TicketID          => $TicketID4,
    ArticleSenderType => ['agent'],
    UserID            => 1,
);

my @ArticleBoxSenderCustomer = $TicketObject->ArticleGet(
    TicketID          => $TicketID4,
    ArticleSenderType => ['customer'],
    UserID            => 1,
);

# Get the list of dynamic fields for object ticket.
my $TicketDynamicFieldList = $DynamicFieldObject->DynamicFieldList(
    ObjectType => 'Ticket',
    ResultType => 'HASH',
);

my @ArticleBoxAttachmentsWithoutContent = $TicketObject->ArticleGet(
    TicketID => $TicketID4,
    UserID   => 1,
);

# Crate a lookup list for easy search
my %TicketDynamicFieldLookup = map { 'DynamicField_' . $_ => 1 } values %{$TicketDynamicFieldList};

# start article loop
ARTICLE:
for my $Article (
    @ArticleBox, @ArticleBoxDF, @ArticleBoxTypeCustomer, @ArticleBoxSenderAgent,
    @ArticleBoxSenderCustomer
    )
{

    for my $Key ( sort keys %{$Article} ) {
        if ( !$Article->{$Key} ) {
            $Article->{$Key} = '';
        }
        if ( $SkipFields{$Key} ) {
            delete $Article->{$Key};
        }
        if ( $TicketDynamicFieldLookup{$Key} ) {
            delete $Article->{$Key};
        }
    }

    # get attachment index (without attachments)
    my %AtmIndex = $TicketObject->ArticleAttachmentIndex(
        ContentPath                => $Article->{ContentPath},
        ArticleID                  => $Article->{ArticleID},
        StripPlainBodyAsAttachment => 3,
        Article                    => $Article,
        UserID                     => 1,
    );

    next ARTICLE if !IsHashRefWithData( \%AtmIndex );

    my @Attachments;
    ATTACHMENT:
    for my $FileID ( sort keys %AtmIndex ) {
        next ATTACHMENT if !$FileID;
        my %Attachment = $TicketObject->ArticleAttachment(
            ArticleID => $Article->{ArticleID},
            FileID    => $FileID,
            UserID    => 1,
        );

        next ATTACHMENT if !IsHashRefWithData( \%Attachment );

        $Attachment{FileID} = $FileID;

        # convert content to base64
        $Attachment{Content}            = encode_base64( $Attachment{Content} );
        $Attachment{ContentID}          = '';
        $Attachment{ContentAlternative} = '';
        push @Attachments, {%Attachment};
    }

    # set Attachments data
    $Article->{Attachment} = \@Attachments;

}    # finish article loop

# start article loop
ARTICLE:
for my $Article (@ArticleBoxAttachmentsWithoutContent)
{

    for my $Key ( sort keys %{$Article} ) {
        if ( !$Article->{$Key} ) {
            $Article->{$Key} = '';
        }
        if ( $SkipFields{$Key} ) {
            delete $Article->{$Key};
        }
        if ( $TicketDynamicFieldLookup{$Key} ) {
            delete $Article->{$Key};
        }
    }

    # get attachment index (without attachments)
    my %AtmIndex = $TicketObject->ArticleAttachmentIndex(
        ContentPath                => $Article->{ContentPath},
        ArticleID                  => $Article->{ArticleID},
        StripPlainBodyAsAttachment => 3,
        Article                    => $Article,
        UserID                     => 1,
    );

    next ARTICLE if !IsHashRefWithData( \%AtmIndex );

    my @Attachments;
    ATTACHMENT:
    for my $FileID ( sort keys %AtmIndex ) {
        next ATTACHMENT if !$FileID;
        my %Attachment = $TicketObject->ArticleAttachment(
            ArticleID => $Article->{ArticleID},
            FileID    => $FileID,
            UserID    => 1,
        );

        next ATTACHMENT if !IsHashRefWithData( \%Attachment );

        $Attachment{FileID} = $FileID;

        # convert content to base64
        $Attachment{Content}            = '';
        $Attachment{ContentID}          = '';
        $Attachment{ContentAlternative} = '';
        push @Attachments, {%Attachment};
    }

    # set Attachments data
    $Article->{Attachment} = \@Attachments;

}    # finish article loop

# Get the list of dynamic fields for object ticket.
my $ArticleDynamicFieldList = $DynamicFieldObject->DynamicFieldList(
    ObjectType => 'Article',
    ResultType => 'HASH',
);

# Crate a lookup list for easy search
my @ArticleDynamicFields = sort values %{$ArticleDynamicFieldList};

ARTICLE:
for my $Article (@ArticleBoxDF) {

    my @DynamicFields;
    for my $DynamicFieldName (@ArticleDynamicFields) {

        push @DynamicFields, {
            Name  => $DynamicFieldName,
            Value => $Article->{"DynamicField_$DynamicFieldName"} || '',
        };

        delete $Article->{"DynamicField_$DynamicFieldName"};
    }

    if (@DynamicFields) {
        $Article->{DynamicField} = \@DynamicFields;
    }
}

# get the Ticket entry
my %TicketEntryFour = $TicketObject->TicketGet(
    TicketID      => $TicketID4,
    DynamicFields => 0,
    UserID        => $UserID,
);

$Self->True(
    IsHashRefWithData( \%TicketEntryFour ),
    "TicketGet() successful for Local TicketGet Four ID $TicketID4",
);

for my $Key ( sort keys %TicketEntryFour ) {
    if ( !$TicketEntryFour{$Key} ) {
        $TicketEntryFour{$Key} = '';
    }
    if ( $SkipFields{$Key} ) {
        delete $TicketEntryFour{$Key};
    }
}

my %TicketEntryFourDF = $TicketObject->TicketGet(
    TicketID      => $TicketID4,
    DynamicFields => 1,
    UserID        => $UserID,
);

for my $Key ( sort keys %TicketEntryFourDF ) {
    if ( !$TicketEntryFourDF{$Key} ) {
        $TicketEntryFourDF{$Key} = '';
    }
    if ( $SkipFields{$Key} ) {
        delete $TicketEntryFourDF{$Key};
    }
}

%TicketEntryFourDF = $FormatDynamicFields->(
    Ticket => \%TicketEntryFourDF,
);

# add ticket id
push @TicketIDs, $TicketID4;

# create ticket 5
my $TicketID5 = $TicketObject->TicketCreate(
    Title        => 'Ticket Five Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customerOne@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID5,
    "TicketCreate() successful for Ticket Five ID $TicketID5",
);

# add ticket id
push @TicketIDs, $TicketID5;

# get the Ticket entry
my %TicketEntryFive = $TicketObject->TicketGet(
    TicketID      => $TicketID5,
    DynamicFields => 0,
    UserID        => $UserID,
);

$Self->True(
    IsHashRefWithData( \%TicketEntryFive ),
    "TicketGet() successful for Local TicketGet One ID $TicketID5",
);

for my $Key ( sort keys %TicketEntryFive ) {
    if ( !$TicketEntryFive{$Key} ) {
        $TicketEntryFive{$Key} = '';
    }
    if ( $SkipFields{$Key} ) {
        delete $TicketEntryFive{$Key};
    }
}

# first article
my $ArticleID51 = $TicketObject->ArticleCreate(
    TicketID    => $TicketID5,
    ArticleType => 'phone',
    SenderType  => 'agent',
    From        => 'Agent Some Agent Some Agent <email@example.com>',
    To          => 'Customer A <customer-a@example.com>',
    Cc          => 'Customer B <customer-b@example.com>',
    ReplyTo     => 'Customer B <customer-b@example.com>',
    Subject     => 'first article',
    Body        => '
<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;"><ol>
    <li>test</li>
</ol></body></html>',
    ContentType    => 'text/html; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'first article',
    UserID         => 1,
    NoAgentNotify  => 1,
);
my $ArticleID52 = $TicketObject->ArticleCreate(
    TicketID       => $TicketID5,
    ArticleType    => 'phone',
    SenderType     => 'agent',
    From           => 'Agent Some Agent Some Agent <email@example.com>',
    To             => 'Customer A <customer-a@example.com>',
    Cc             => 'Customer B <customer-b@example.com>',
    ReplyTo        => 'Customer B <customer-b@example.com>',
    Subject        => 'first article',
    Body           => 'Test',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'first article',
    UserID         => 1,
    NoAgentNotify  => 1,
);

for my $File (qw(txt)) {
    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File";

    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Type     => 'Local',
    );

    my $ArticleWriteAttachment = $TicketObject->ArticleWriteAttachment(
        Content     => ${$ContentRef},
        Filename    => "StdAttachment-Test1.$File",
        ContentType => $File,
        ArticleID   => $ArticleID51,
        UserID      => 1,
    );
}

# save articles
my @ArticleWithHTMLBody = $TicketObject->ArticleGet(
    TicketID => $TicketID5,
    UserID   => 1,
);

for my $Article (@ArticleWithHTMLBody) {

    for my $Key ( sort keys %{$Article} ) {
        if ( !$Article->{$Key} ) {
            $Article->{$Key} = '';
        }
        if ( $SkipFields{$Key} ) {
            delete $Article->{$Key};
        }
    }
}

ARTICLE:
for my $Article (@ArticleWithHTMLBody) {

    for my $Key ( sort keys %{$Article} ) {
        if ( !$Article->{$Key} ) {
            $Article->{$Key} = '';
        }
        if ( $SkipFields{$Key} ) {
            delete $Article->{$Key};
        }
        if ( $TicketDynamicFieldLookup{$Key} ) {
            delete $Article->{$Key};
        }
    }

    # get attachment index (without attachments)
    my %AtmIndex = $TicketObject->ArticleAttachmentIndex(
        ContentPath                => $Article->{ContentPath},
        ArticleID                  => $Article->{ArticleID},
        StripPlainBodyAsAttachment => 2,
        Article                    => $Article,
        UserID                     => 1,
    );

    next ARTICLE if !IsHashRefWithData( \%AtmIndex );

    my @Attachments;
    ATTACHMENT:
    for my $FileID ( sort keys %AtmIndex ) {
        next ATTACHMENT if !$FileID;
        my %Attachment = $TicketObject->ArticleAttachment(
            ArticleID => $Article->{ArticleID},
            FileID    => $FileID,
            UserID    => 1,
        );

        next ATTACHMENT if !IsHashRefWithData( \%Attachment );

        $Attachment{FileID} = $FileID;

        # convert content to base64
        $Attachment{Content}            = encode_base64( $Attachment{Content} );
        $Attachment{ContentID}          = '';
        $Attachment{ContentAlternative} = '';
        push @Attachments, {%Attachment};
    }

    # set Attachments data
    $Article->{Attachment} = \@Attachments;

}    # finish article loop

# set web-service name
my $WebserviceName = '-Test-' . $RandomID;

# create web-service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create web service object",
);

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Name   => $WebserviceName,
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
        },
        Provider => {
            Transport => {
                Type => '',
            },
        },
    },
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $WebserviceID,
    "Added Web Service",
);

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# prepare web-service config
my $RemoteSystem =
    $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
    . '/nph-genericinterface.pl/WebserviceID/'
    . $WebserviceID;

my $WebserviceConfig = {

    #    Name => '',
    Description =>
        'Test for Ticket Connector using SOAP transport backend.',
    Debugger => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    Provider => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                MaxLength => 10000000,
                NameSpace => 'http://otrs.org/SoapTestInterface/',
                Endpoint  => $RemoteSystem,
            },
        },
        Operation => {
            TicketGet => {
                Type => 'Ticket::TicketGet',
            },
            SessionCreate => {
                Type => 'Session::SessionCreate',
            },
        },
    },
    Requester => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                NameSpace => 'http://otrs.org/SoapTestInterface/',
                Encoding  => 'UTF-8',
                Endpoint  => $RemoteSystem,
            },
        },
        Invoker => {
            TicketGet => {
                Type => 'Test::TestSimple',
            },
            SessionCreate => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# update web-service with real config
# the update is needed because we are using
# the WebserviceID for the Endpoint in config
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => $UserID,
);
$Self->True(
    $WebserviceUpdate,
    "Updated Web Service $WebserviceID - $WebserviceName",
);

# Get SessionID
# create requester object
my $RequesterSessionObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
$Self->Is(
    'Kernel::GenericInterface::Requester',
    ref $RequesterSessionObject,
    "SessionID - Create requester object",
);

# start requester with our web-service
my $RequesterSessionResult = $RequesterSessionObject->Run(
    WebserviceID => $WebserviceID,
    Invoker      => 'SessionCreate',
    Data         => {
        UserLogin => $UserLogin,
        Password  => $Password,
    },
);

my $NewSessionID = $RequesterSessionResult->{Data}->{SessionID};

my @Tests = (
    {
        Name                    => 'Empty Request',
        SuccessRequest          => 1,
        RequestData             => {},
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode    => 'TicketGet.MissingParameter',
                    ErrorMessage => 'TicketGet: TicketID parameter is missing!'
                    }
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                Error => {
                    ErrorCode    => 'TicketGet.MissingParameter',
                    ErrorMessage => 'TicketGet: TicketID parameter is missing!'
                    }
            },
            Success => 1
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Wrong TicketID',
        SuccessRequest => 1,
        RequestData    => {
            TicketID => 'NotTicketID',
        },
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketGet.AccessDenied',
                    ErrorMessage =>
                        'TicketGet: User does not have access to the ticket!'
                    }
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketGet.AccessDenied',
                    ErrorMessage =>
                        'TicketGet: User does not have access to the ticket!'
                    }
            },
            Success => 1
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 1',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => \%TicketEntryOne,
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [ \%TicketEntryOne, ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 2',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID2,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => \%TicketEntryTwo,
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [ \%TicketEntryTwo, ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 3',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID3,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => \%TicketEntryThree,
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [ \%TicketEntryThree, ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID4,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => \%TicketEntryFour,
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [ \%TicketEntryFour, ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 1 With DF',
        SuccessRequest => '1',
        RequestData    => {
            TicketID      => $TicketID1,
            DynamicFields => 1,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => \%TicketEntryOneDF,
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [ \%TicketEntryOneDF, ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 2 With DF',
        SuccessRequest => '1',
        RequestData    => {
            TicketID      => $TicketID2,
            DynamicFields => 1,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => \%TicketEntryTwoDF,
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [ \%TicketEntryTwoDF, ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 1 + 2 With DF',
        SuccessRequest => '1',
        RequestData    => {
            TicketID      => "$TicketID1, $TicketID2",
            DynamicFields => 1,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => [ \%TicketEntryOneDF, \%TicketEntryTwoDF, ],
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [ \%TicketEntryOneDF, \%TicketEntryTwoDF, ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 With All Articles',
        SuccessRequest => '1',
        RequestData    => {
            TicketID    => $TicketID4,
            AllArticles => 1,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article => \@ArticleWithoutAttachments,
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [
                    {
                        (
                            %TicketEntryFour,
                            Article => \@ArticleWithoutAttachments,
                            )
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 With All Articles and Attachments',
        SuccessRequest => '1',
        RequestData    => {
            TicketID    => $TicketID4,
            AllArticles => 1,
            Attachments => 1,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article => \@ArticleBox,
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [
                    {
                        (
                            %TicketEntryFour,
                            Article => \@ArticleBox,
                            )
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 With All Articles and Attachments (without contents)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID              => $TicketID4,
            AllArticles           => 1,
            Attachments           => 1,
            GetAttachmentContents => 0,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article => \@ArticleBoxAttachmentsWithoutContent,
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [
                    {
                        (
                            %TicketEntryFour,
                            Article => \@ArticleBoxAttachmentsWithoutContent,
                            )
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 With All Articles and Attachments and DynamicFields',
        SuccessRequest => '1',
        RequestData    => {
            TicketID      => $TicketID4,
            AllArticles   => 1,
            Attachments   => 1,
            DynamicFields => 1,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFourDF,
                    Article => \@ArticleBoxDF,
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [
                    {
                        (
                            %TicketEntryFourDF,
                            Article => \@ArticleBoxDF,
                            )
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },

    {
        Name           => 'Test Ticket 4 With All Articles and Attachments (With sessionID)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID    => $TicketID4,
            AllArticles => 1,
            Attachments => 1,
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article => \@ArticleBox,
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [
                    {
                        (
                            %TicketEntryFour,
                            Article => \@ArticleBox,
                            )
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 With All Articles and Attachments (With sessionID without contents)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID              => $TicketID4,
            AllArticles           => 1,
            Attachments           => 1,
            GetAttachmentContents => 0,
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article => \@ArticleBoxAttachmentsWithoutContent,
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [
                    {
                        (
                            %TicketEntryFour,
                            Article => \@ArticleBoxAttachmentsWithoutContent,
                            )
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },

    {
        Name           => 'Test Ticket 4 With All Articles and Attachments (No Permission)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID    => $TicketID4,
            AllArticles => 1,
            Attachments => 1,
        },
        Auth => {
            UserLogin => $UserLogin2,
            Password  => $Password2,
        },
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketGet.AccessDenied',
                    ErrorMessage =>
                        'TicketGet: User does not have access to the ticket!'
                    }
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketGet.AccessDenied',
                    ErrorMessage =>
                        'TicketGet: User does not have access to the ticket!'
                    }
            },
            Success => 1
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 With All Articles and Attachments (Customer)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID    => $TicketID4,
            AllArticles => 1,
            Attachments => 1,
        },
        Auth => {
            CustomerUserLogin => $CustomerUserLogin,
            Password          => $CustomerPassword,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article => \@ArticleBoxTypeCustomer,
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [
                    {    ## no critic
                        (
                            %TicketEntryFour,
                            Article => \@ArticleBoxTypeCustomer,
                        ),
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 With All Articles and Attachments (Customer No Permission)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID    => $TicketID4,
            AllArticles => 1,
            Attachments => 1,
        },
        Auth => {
            CustomerUserLogin => $CustomerUserLogin2,
            Password          => $CustomerPassword2,
        },
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketGet.AccessDenied',
                    ErrorMessage =>
                        'TicketGet: User does not have access to the ticket!'
                    }
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketGet.AccessDenied',
                    ErrorMessage =>
                        'TicketGet: User does not have access to the ticket!'
                    }
            },
            Success => 1
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 only agent sender articles',
        SuccessRequest => '1',
        RequestData    => {
            TicketID          => $TicketID4,
            AllArticles       => 1,
            ArticleSenderType => ['agent'],
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article => $ArticleBoxSenderAgent[0],
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [
                    {    ## no critic
                        (
                            %TicketEntryFour,
                            Article => \@ArticleBoxSenderAgent,
                        ),
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 only agent sender articles (string)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID          => $TicketID4,
            AllArticles       => 1,
            ArticleSenderType => 'agent',
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article => $ArticleBoxSenderAgent[0],
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [
                    {    ## no critic
                        (
                            %TicketEntryFour,
                            Article => \@ArticleBoxSenderAgent,
                        ),
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 only customer sender articles',
        SuccessRequest => '1',
        RequestData    => {
            TicketID          => $TicketID4,
            AllArticles       => 1,
            ArticleSenderType => ['customer'],
            Attachments       => 1,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article => \@ArticleBoxSenderCustomer,
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [
                    {    ## no critic
                        (
                            %TicketEntryFour,
                            Article => \@ArticleBoxSenderCustomer,
                        ),
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },

    {
        Name           => 'Test Ticket 5 With HTML Body',
        SuccessRequest => '1',
        RequestData    => {
            TicketID             => $TicketID5,
            AllArticles          => 1,
            Attachments          => 1,
            HTMLBodyAsAttachment => 1,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFive,
                    Article => \@ArticleWithHTMLBody,
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Ticket => [
                    {
                        (
                            %TicketEntryFive,
                            Article => \@ArticleWithHTMLBody,
                            )
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },
);

# debugger object
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Provider',
);
$Self->Is(
    ref $DebuggerObject,
    'Kernel::GenericInterface::Debugger',
    'DebuggerObject instantiate correctly',
);

for my $Test (@Tests) {

    # create local object
    my $LocalObject = "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"->new(
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
    );

    $Self->Is(
        "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}",
        ref $LocalObject,
        "$Test->{Name} - Create local object",
    );

    my %Auth = (
        UserLogin => $UserLogin,
        Password  => $Password,
    );
    if ( IsHashRefWithData( $Test->{Auth} ) ) {
        %Auth = %{ $Test->{Auth} };
    }

    # start requester with our web-service
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    # check result
    $Self->Is(
        'HASH',
        ref $LocalResult,
        "$Test->{Name} - Local result structure is valid",
    );

    # create requester object
    my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
    $Self->Is(
        'Kernel::GenericInterface::Requester',
        ref $RequesterObject,
        "$Test->{Name} - Create requester object",
    );

    # start requester with our web-service
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    # check result
    $Self->Is(
        'HASH',
        ref $RequesterResult,
        "$Test->{Name} - Requester result structure is valid",
    );

    $Self->Is(
        $RequesterResult->{Success},
        $Test->{SuccessRequest},
        "$Test->{Name} - Requester successful result",
    );

    # workaround because results from direct call and
    # from SOAP call are a little bit different
    if ( $Test->{Operation} eq 'TicketGet' ) {

        if ( ref $LocalResult->{Data}->{Ticket} eq 'ARRAY' ) {
            for my $Item ( @{ $LocalResult->{Data}->{Ticket} } ) {
                for my $Key ( sort keys %{$Item} ) {
                    if ( !$Item->{$Key} ) {
                        $Item->{$Key} = '';
                    }
                    if ( $SkipFields{$Key} ) {
                        delete $Item->{$Key};
                    }
                    if ( $Key eq 'DynamicField' ) {
                        for my $DF ( @{ $Item->{$Key} } ) {
                            if ( !$DF->{Value} ) {
                                $DF->{Value} = '';
                            }
                        }
                    }
                }

                # Articles
                if ( defined $Item->{Article} ) {
                    for my $Article ( @{ $Item->{Article} } ) {
                        for my $Key ( sort keys %{$Article} ) {
                            if ( !$Article->{$Key} ) {
                                $Article->{$Key} = '';
                            }
                            if ( $SkipFields{$Key} ) {
                                delete $Article->{$Key};
                            }

                            if ( $Key eq 'Attachment' ) {
                                for my $Atm ( @{ $Article->{$Key} } ) {
                                    $Atm->{ContentID}          = '';
                                    $Atm->{ContentAlternative} = '';
                                }
                            }

                            if ( $Key eq 'DynamicField' ) {
                                for my $DF ( @{ $Article->{$Key} } ) {
                                    if ( !$DF->{Value} ) {
                                        $DF->{Value} = '';
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        if (
            defined $RequesterResult->{Data}
            && defined $RequesterResult->{Data}->{Ticket}
            )
        {
            if ( ref $RequesterResult->{Data}->{Ticket} eq 'ARRAY' ) {
                for my $Item ( @{ $RequesterResult->{Data}->{Ticket} } ) {
                    for my $Key ( sort keys %{$Item} ) {
                        if ( !$Item->{$Key} ) {
                            $Item->{$Key} = '';
                        }
                        if ( $SkipFields{$Key} ) {
                            delete $Item->{$Key};
                        }
                        if ( $Key eq 'DynamicField' ) {
                            for my $DF ( @{ $Item->{$Key} } ) {
                                if ( !$DF->{Value} ) {
                                    $DF->{Value} = '';
                                }
                            }
                        }
                    }
                }
            }
            elsif ( ref $RequesterResult->{Data}->{Ticket} eq 'HASH' ) {
                for my $Key ( sort keys %{ $RequesterResult->{Data}->{Ticket} } ) {
                    if ( !$RequesterResult->{Data}->{Ticket}->{$Key} ) {
                        $RequesterResult->{Data}->{Ticket}->{$Key} = '';
                    }
                    if ( $SkipFields{$Key} ) {
                        delete $RequesterResult->{Data}->{Ticket}->{$Key};
                    }
                    if ( $Key eq 'DynamicField' ) {
                        for my $DF ( @{ $RequesterResult->{Data}->{Ticket}->{$Key} } ) {
                            if ( !$DF->{Value} ) {
                                $DF->{Value} = '';
                            }
                        }
                    }
                }

                # Articles
                if ( defined $RequesterResult->{Data}->{Ticket}->{Article} ) {
                    if ( ref $RequesterResult->{Data}->{Ticket}->{Article} eq 'ARRAY' ) {
                        for my $Article ( @{ $RequesterResult->{Data}->{Ticket}->{Article} } ) {
                            for my $Key ( sort keys %{$Article} ) {
                                if ( !$Article->{$Key} ) {
                                    $Article->{$Key} = '';
                                }
                                if ( $SkipFields{$Key} ) {
                                    delete $Article->{$Key};
                                }
                                if ( $Key eq 'Attachment' ) {
                                    for my $Atm ( @{ $Article->{$Key} } ) {
                                        $Atm->{ContentID}          = '';
                                        $Atm->{ContentAlternative} = '';
                                    }
                                }
                                if ( $Key eq 'DynamicField' ) {
                                    for my $DF ( @{ $Article->{$Key} } ) {
                                        if ( !$DF->{Value} ) {
                                            $DF->{Value} = '';
                                        }
                                    }
                                }
                            }
                        }
                    }
                    elsif ( ref $RequesterResult->{Data}->{Ticket}->{Article} eq 'HASH' ) {
                        for my $Key ( sort keys %{ $RequesterResult->{Data}->{Ticket}->{Article} } ) {
                            if ( !$RequesterResult->{Data}->{Ticket}->{Article}->{$Key} ) {
                                $RequesterResult->{Data}->{Ticket}->{Article}->{$Key} = '';
                            }
                            if ( $SkipFields{$Key} ) {
                                delete $RequesterResult->{Data}->{Ticket}->{Article}->{$Key};
                            }
                            if ( $Key eq 'Attachment' ) {
                                for my $Atm ( @{ $RequesterResult->{Data}->{Ticket}->{Article}->{$Key} } ) {
                                    $Atm->{ContentID}          = '';
                                    $Atm->{ContentAlternative} = '';
                                }
                            }
                            if ( $Key eq 'DynamicField' ) {
                                for my $DF ( @{ $RequesterResult->{Data}->{Ticket}->{Article}->{$Key} } ) {
                                    if ( !$DF->{Value} ) {
                                        $DF->{Value} = '';
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    # remove ErrorMessage parameter from direct call
    # result to be consistent with SOAP call result
    if ( $LocalResult->{ErrorMessage} ) {
        delete $LocalResult->{ErrorMessage};
    }

    $Self->IsDeeply(
        $RequesterResult,
        $Test->{ExpectedReturnRemoteData},
        "$Test->{Name} - Requester success status (needs configured and running web server)",
    );

    if ( $Test->{ExpectedReturnLocalData} ) {
        $Self->IsDeeply(
            $LocalResult,
            $Test->{ExpectedReturnLocalData},
            "$Test->{Name} - Local result matched with expected local call result.",
        );
    }
    else {
        $Self->IsDeeply(
            $LocalResult,
            $Test->{ExpectedReturnRemoteData},
            "$Test->{Name} - Local result matched with remote result.",
        );
    }

}    #end loop

# cleanup

# delete web service
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => $UserID,
);
$Self->True(
    $WebserviceDelete,
    "Deleted Web Service $WebserviceID",
);

# delete tickets
for my $TicketID (@TicketIDs) {
    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => $UserID,
    );

    # sanity check
    $Self->True(
        $TicketDelete,
        "TicketDelete() successful for Ticket ID $TicketID",
    );
}

# delete the dynamic fields
for my $TestFieldConfigItem (@TestFieldConfig) {
    my $TestFieldConfigItemID = $TestFieldConfigItem->{ID};

    my $DFDelete = $DynamicFieldObject->DynamicFieldDelete(
        ID      => $TestFieldConfigItemID,
        UserID  => 1,
        Reorder => 0,
    );

    # sanity check
    $Self->True(
        $DFDelete,
        "DynamicFieldDelete() successful for Field ID $TestFieldConfigItemID",
    );
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

1;
