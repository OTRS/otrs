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

use MIME::Base64;

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation::Session::SessionCreate;
use Kernel::GenericInterface::Operation::Ticket::TicketGet;

use Kernel::System::VariableCheck qw(:all);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# disable SessionCheckRemoteIP setting
$ConfigObject->Set(
    Key   => 'SessionCheckRemoteIP',
    Value => 0,
);

# Skip SSL certificate verification.
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
$TicketEntryOne{TimeUnit} = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID1 );

$Self->True(
    IsHashRefWithData( \%TicketEntryOne ),
    "TicketGet() successful for Local TicketGet One ID $TicketID1",
);

for my $Key ( sort keys %TicketEntryOne ) {
    if ( !defined $TicketEntryOne{$Key} ) {
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
$TicketEntryOneDF{TimeUnit} = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID1 );

$Self->True(
    IsHashRefWithData( \%TicketEntryOneDF ),
    "TicketGet() successful with DF for Local TicketGet One ID $TicketID1",
);

for my $Key ( sort keys %TicketEntryOneDF ) {
    if ( !defined $TicketEntryOneDF{$Key} ) {
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
$TicketEntryTwo{TimeUnit} = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID2 );

$Self->True(
    IsHashRefWithData( \%TicketEntryTwo ),
    "TicketGet() successful for Local TicketGet Two ID $TicketID2",
);

for my $Key ( sort keys %TicketEntryTwo ) {
    if ( !defined $TicketEntryTwo{$Key} ) {
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
$TicketEntryTwoDF{TimeUnit} = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID2 );

$Self->True(
    IsHashRefWithData( \%TicketEntryTwoDF ),
    "TicketGet() successful for Local TicketGet Two ID $TicketID2",
);

for my $Key ( sort keys %TicketEntryTwoDF ) {
    if ( !defined $TicketEntryTwoDF{$Key} ) {
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
$TicketEntryThree{TimeUnit} = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID3 );

$Self->True(
    IsHashRefWithData( \%TicketEntryThree ),
    "TicketGet() successful for Local TicketGet Three ID $TicketID3",
);

for my $Key ( sort keys %TicketEntryThree ) {
    if ( !defined $TicketEntryThree{$Key} ) {
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

my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

# first article
my $ArticleID41 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID4,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => 'first article',
    Body                 => 'A text for the body, Title äöüßÄÖÜ€ис',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'first article',
    UserID               => 1,
    NoAgentNotify        => 1,
);
my $Success = $TicketObject->TicketAccountTime(
    TicketID  => $TicketID4,
    ArticleID => $ArticleID41,
    TimeUnit  => '4.5',
    UserID    => 1,
);

# second article
my $ArticleID42 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID4,
    SenderType           => 'customer',
    IsVisibleForCustomer => 1,
    From                 => 'A not Real Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => 'second article',
    Body                 => 'A text for the body, not too long',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'second article',
    UserID               => 1,
    NoAgentNotify        => 1,
);
$Success = $TicketObject->TicketAccountTime(
    TicketID  => $TicketID4,
    ArticleID => $ArticleID42,
    TimeUnit  => '2',
    UserID    => 1,
);

# third article
my $ArticleID43 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID4,
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
    From                 => 'A not Real Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => 'second article',
    Body                 => 'A text for the body, not too long',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'second article',
    UserID               => 1,
    NoAgentNotify        => 1,
);

# Helper method to retrieve article content for supplied list of articles.
#
#    $ArticleContentGet->(
#        TicketID             => 123,           # (required)
#        Articles             => \@Articles,    # (required)
#        DynamicFields        => 1,             # (optional) Include dynamic field values
#    );
#
my $ArticleContentGet = sub {
    my (%Param) = @_;

    if (
        !$Param{TicketID}
        && !IsArrayRefWithData( $Param{Articles} )
        )
    {
        return;
    }

    my @ArticleContents;
    for my $Article ( @{ $Param{Articles} } ) {
        my %ArticleContent = $ArticleBackendObject->ArticleGet(
            %Param,
            ArticleID => $Article->{ArticleID},
        );

        for my $Key ( sort keys %ArticleContent ) {
            if ( !defined $ArticleContent{$Key} ) {
                $ArticleContent{$Key} = '';
            }
            if ( $SkipFields{$Key} ) {
                delete $ArticleContent{$Key};
            }
        }

        $ArticleContent{TimeUnit} = $ArticleObject->ArticleAccountedTimeGet(
            ArticleID => $Article->{ArticleID},
        );

        push @ArticleContents, \%ArticleContent;
    }

    return @ArticleContents;
};

# Get article contents (no attachments).
my @Articles = $ArticleObject->ArticleList(
    TicketID => $TicketID4,
);
my @ArticleWithoutAttachments = $ArticleContentGet->(
    Articles => \@Articles,
    TicketID => $TicketID4,
);

# Add attachments to article.
for my $File (qw(xls txt doc png pdf)) {
    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File";

    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Type     => 'Local',
    );

    my $ArticleWriteAttachment = $ArticleBackendObject->ArticleWriteAttachment(
        Content     => ${$ContentRef},
        Filename    => "StdAttachment-Test1.$File",
        ContentType => $File,
        ArticleID   => $ArticleID42,
        UserID      => 1,
    );
}

# Add test article dynamic field.
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

# Add a second article dynamic field to force an array reference in remote result and make it easier to check.
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

# Get article contents (attachments).
my @ArticleBox = $ArticleContentGet->(
    Articles => \@Articles,
    TicketID => $TicketID4,
);

# Get article contents (attachments + dynamic fields).
my @ArticleBoxDF = $ArticleContentGet->(
    Articles      => \@Articles,
    TicketID      => $TicketID4,
    DynamicFields => 1,
);

# Get article contents (attachments + visible to customers).
@Articles = $ArticleObject->ArticleList(
    TicketID             => $TicketID4,
    IsVisibleForCustomer => 1,
    UserID               => 1,
);
my @ArticleBoxTypeCustomer = $ArticleContentGet->(
    Articles => \@Articles,
    TicketID => $TicketID4,
);

# Get article contents (attachments + created by agents).
@Articles = $ArticleObject->ArticleList(
    TicketID   => $TicketID4,
    SenderType => 'agent',
    UserID     => 1,
);
my @ArticleBoxSenderAgent = $ArticleContentGet->(
    Articles => \@Articles,
    TicketID => $TicketID4,
);

# Get article contents (attachments + created by customers).
@Articles = $ArticleObject->ArticleList(
    TicketID   => $TicketID4,
    SenderType => 'customer',
);
my @ArticleBoxSenderCustomer = $ArticleContentGet->(
    Articles => \@Articles,
    TicketID => $TicketID4,
);

# Get the list of dynamic fields for object ticket.
my $TicketDynamicFieldList = $DynamicFieldObject->DynamicFieldList(
    ObjectType => 'Ticket',
    ResultType => 'HASH',
);

# Get article contents (attachments + without content).
@Articles = $ArticleObject->ArticleList(
    TicketID => $TicketID4,
);
my @ArticleBoxAttachmentsWithoutContent = $ArticleContentGet->(
    Articles => \@Articles,
    TicketID => $TicketID4,
);

# Create a lookup list for easy ticket dynamic field search.
my %TicketDynamicFieldLookup = map { 'DynamicField_' . $_ => 1 } values %{$TicketDynamicFieldList};

# Helper method to retrieve article attachment content for supplied list of articles.
#
#    $ArticleAttachmentContentGet->(
#        Articles  => \@Articles,    # (required)
#        NoContent => 1,             # (optional) Omit actual attachment content, return only meta data
#        HTMLBody  => 1,             # (optional) Include HTML body attachment content
#    );
#
my $ArticleAttachmentContentGet = sub {
    my (%Param) = @_;

    if ( !IsArrayRefWithData( $Param{Articles} ) ) {
        return;
    }

    my @Articles = @{ $Param{Articles} };

    ARTICLE:
    for my $Article (@Articles) {

        for my $Key ( sort keys %{$Article} ) {
            if ( !defined $Article->{$Key} ) {
                $Article->{$Key} = '';
            }
            if ( $SkipFields{$Key} ) {
                delete $Article->{$Key};
            }
            if ( $TicketDynamicFieldLookup{$Key} ) {
                delete $Article->{$Key};
            }
        }

        # Get attachment index.
        my %AtmIndex = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID        => $Article->{ArticleID},
            ExcludePlainText => 1,
            ExcludeHTMLBody  => $Param{HTMLBody} ? 0 : 1,
        );

        next ARTICLE if !IsHashRefWithData( \%AtmIndex );

        my @Attachments;
        ATTACHMENT:
        for my $FileID ( sort keys %AtmIndex ) {
            next ATTACHMENT if !$FileID;
            my %Attachment = $ArticleBackendObject->ArticleAttachment(
                ArticleID => $Article->{ArticleID},
                FileID    => $FileID,
            );

            next ATTACHMENT if !IsHashRefWithData( \%Attachment );

            $Attachment{FileID} = $FileID;

            # convert content to base64
            $Attachment{Content}            = $Param{NoContent} ? '' : encode_base64( $Attachment{Content}, '' );
            $Attachment{ContentID}          = '';
            $Attachment{ContentAlternative} = '';
            push @Attachments, {%Attachment};
        }

        # set Attachments data
        $Article->{Attachment} = \@Attachments;
    }
};

# Insert attachment content.
$ArticleAttachmentContentGet->(
    Articles => \@ArticleBox,
);
$ArticleAttachmentContentGet->(
    Articles => \@ArticleBoxDF,
);
$ArticleAttachmentContentGet->(
    Articles => \@ArticleBoxTypeCustomer,
);
$ArticleAttachmentContentGet->(
    Articles => \@ArticleBoxSenderAgent,
);
$ArticleAttachmentContentGet->(
    Articles => \@ArticleBoxSenderCustomer,
);
$ArticleAttachmentContentGet->(
    Articles  => \@ArticleBoxAttachmentsWithoutContent,
    NoContent => 1,
);

# Get the list of dynamic fields for object ticket.
my $ArticleDynamicFieldList = $DynamicFieldObject->DynamicFieldList(
    ObjectType => 'Article',
    ResultType => 'HASH',
);

# Create a lookup list for easy article dynamic field search.
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
$TicketEntryFour{TimeUnit} = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID4 );

$Self->True(
    IsHashRefWithData( \%TicketEntryFour ),
    "TicketGet() successful for Local TicketGet Four ID $TicketID4",
);

for my $Key ( sort keys %TicketEntryFour ) {
    if ( !defined $TicketEntryFour{$Key} ) {
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
$TicketEntryFourDF{TimeUnit} = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID4 );

for my $Key ( sort keys %TicketEntryFourDF ) {
    if ( !defined $TicketEntryFourDF{$Key} ) {
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
$TicketEntryFive{TimeUnit} = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID5 );

$Self->True(
    IsHashRefWithData( \%TicketEntryFive ),
    "TicketGet() successful for Local TicketGet One ID $TicketID5",
);

for my $Key ( sort keys %TicketEntryFive ) {
    if ( !defined $TicketEntryFive{$Key} ) {
        $TicketEntryFive{$Key} = '';
    }
    if ( $SkipFields{$Key} ) {
        delete $TicketEntryFive{$Key};
    }
}

# first article
my $ArticleID51 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID5,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => 'first article',
    Body                 => '
<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;"><ol>
    <li>test</li>
</ol></body></html>',
    ContentType    => 'text/html; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'first article',
    UserID         => 1,
    NoAgentNotify  => 1,
);
my $ArticleID52 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID5,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => 'first article',
    Body                 => 'Test',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'first article',
    UserID               => 1,
    NoAgentNotify        => 1,
);

for my $File (qw(txt)) {
    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File";

    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Type     => 'Local',
    );

    my $ArticleWriteAttachment = $ArticleBackendObject->ArticleWriteAttachment(
        Content     => ${$ContentRef},
        Filename    => "StdAttachment-Test1.$File",
        ContentType => $File,
        ArticleID   => $ArticleID51,
        UserID      => 1,
    );
}

# Get article contents (attachments + HTML body).
@Articles = $ArticleObject->ArticleList(
    TicketID => $TicketID5,
);
my @ArticleWithHTMLBody = $ArticleContentGet->(
    Articles => \@Articles,
    TicketID => $TicketID5,
);

# Insert attachment content.
$ArticleAttachmentContentGet->(
    Articles => \@ArticleWithHTMLBody,
    HTMLBody => 1,
);

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
                Timeout   => 120,
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
        Name           => 'Test Ticket 4 With last two Articles - check ArticleLimit parameter, ArticleOrder: DESC',
        SuccessRequest => '1',
        RequestData    => {
            TicketID     => $TicketID4,
            AllArticles  => 1,
            ArticleLimit => 2,
            ArticleOrder => 'DESC',
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article => [ $ArticleWithoutAttachments[-1], $ArticleWithoutAttachments[-2] ],
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
                            Article => [ $ArticleWithoutAttachments[-1], $ArticleWithoutAttachments[-2] ],
                        )
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 With first two Articles - check ArticleLimit parameter, ArticleOrder: ASC',
        SuccessRequest => '1',
        RequestData    => {
            TicketID     => $TicketID4,
            AllArticles  => 1,
            ArticleLimit => 2,
            ArticleOrder => 'ASC',
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article => [ $ArticleWithoutAttachments[0], $ArticleWithoutAttachments[1] ],
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
                            Article => [ $ArticleWithoutAttachments[0], $ArticleWithoutAttachments[1] ],
                        )
                    },
                ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test Ticket 4 - check ArticleLimit parameter when greater then number of articles',
        SuccessRequest => '1',
        RequestData    => {
            TicketID     => $TicketID4,
            AllArticles  => 1,
            ArticleLimit => 10,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Ticket => {
                    %TicketEntryFour,
                    Article =>
                        [ $ArticleWithoutAttachments[0], $ArticleWithoutAttachments[1], $ArticleWithoutAttachments[2] ],
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
                            Article => [
                                $ArticleWithoutAttachments[0], $ArticleWithoutAttachments[1],
                                $ArticleWithoutAttachments[2]
                            ],
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
                    Article => \@ArticleBoxSenderAgent,
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
                    Article => \@ArticleBoxSenderAgent,
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
                    Article => $ArticleBoxSenderCustomer[0],
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
                    if ( !defined $Item->{$Key} ) {
                        $Item->{$Key} = '';
                    }
                    if ( $SkipFields{$Key} ) {
                        delete $Item->{$Key};
                    }
                    if ( $Key eq 'DynamicField' ) {
                        for my $DF ( @{ $Item->{$Key} } ) {
                            if ( !defined $DF->{Value} ) {
                                $DF->{Value} = '';
                            }
                        }
                    }
                }

                # Articles
                if ( defined $Item->{Article} ) {
                    for my $Article ( @{ $Item->{Article} } ) {
                        for my $Key ( sort keys %{$Article} ) {
                            if ( !defined $Article->{$Key} ) {
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
                                    if ( !defined $DF->{Value} ) {
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
                        if ( !defined $Item->{$Key} ) {
                            $Item->{$Key} = '';
                        }
                        if ( $SkipFields{$Key} ) {
                            delete $Item->{$Key};
                        }
                        if ( $Key eq 'DynamicField' ) {
                            for my $DF ( @{ $Item->{$Key} } ) {
                                if ( !defined $DF->{Value} ) {
                                    $DF->{Value} = '';
                                }
                            }
                        }
                    }
                }
            }
            elsif ( ref $RequesterResult->{Data}->{Ticket} eq 'HASH' ) {
                for my $Key ( sort keys %{ $RequesterResult->{Data}->{Ticket} } ) {
                    if ( !defined $RequesterResult->{Data}->{Ticket}->{$Key} ) {
                        $RequesterResult->{Data}->{Ticket}->{$Key} = '';
                    }
                    if ( $SkipFields{$Key} ) {
                        delete $RequesterResult->{Data}->{Ticket}->{$Key};
                    }
                    if ( $Key eq 'DynamicField' ) {
                        for my $DF ( @{ $RequesterResult->{Data}->{Ticket}->{$Key} } ) {
                            if ( !defined $DF->{Value} ) {
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
                                if ( !defined $Article->{$Key} ) {
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
                                        if ( !defined $DF->{Value} ) {
                                            $DF->{Value} = '';
                                        }
                                    }
                                }
                            }
                        }
                    }
                    elsif ( ref $RequesterResult->{Data}->{Ticket}->{Article} eq 'HASH' ) {
                        for my $Key ( sort keys %{ $RequesterResult->{Data}->{Ticket}->{Article} } ) {
                            if ( !defined $RequesterResult->{Data}->{Ticket}->{Article}->{$Key} ) {
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
                                    if ( !defined $DF->{Value} ) {
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
