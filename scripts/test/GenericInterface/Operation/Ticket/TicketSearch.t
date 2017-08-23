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
use Kernel::GenericInterface::Operation::Ticket::TicketSearch;
use Kernel::GenericInterface::Operation::Session::SessionCreate;

use Kernel::System::VariableCheck qw(:all);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Skip SSL certificate verification.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# search old test tickets
my @OldTicketIDs = $TicketObject->TicketSearch(
    CustomerUserLogin => '*@example.com',
    Result            => 'ARRAY',
    UserID            => 1,
);

# delete old test ticket to have a clean environment
for my $TicketID (@OldTicketIDs) {
    $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
}

# get a random number
my $RandomID = $Helper->GetRandomNumber();

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# get the start time for the test
my $StartTime = $Kernel::OM->Create('Kernel::System::DateTime');

# get user object
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

# create a new user for current test
my $UserID = $UserObject->UserAdd(
    UserFirstname => 'Test',
    UserLastname  => 'User',
    UserLogin     => 'TestUser' . $RandomID,
    UserPw        => 'some-pass',
    UserEmail     => 'test' . $RandomID . 'email@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $UserID,
    'User Add ()',
);

# create type object
my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

# create new type
my $TypeID = $TypeObject->TypeAdd(
    Name    => 'TestType' . $RandomID,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $TypeID,
    "TypeAdd() - create testing type",
);

my %TypeData = $TypeObject->TypeGet(
    ID => $TypeID,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%TypeData ),
    "QueueGet() - for testing type",
);

# get service object
my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

# create new service
my $ServiceID = $ServiceObject->ServiceAdd(
    Name    => 'TestService' . $RandomID,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $ServiceID,
    "ServiceAdd() - create testing service",
);

my %ServiceData = $ServiceObject->ServiceGet(
    ServiceID => $ServiceID,
    UserID    => 1,
);

# sanity check
$Self->True(
    IsHashRefWithData( \%ServiceData ),
    "ServiceGet() - for testing service",
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
        FieldOrder => 9994,
        FieldType  => 'Date',            # mandatory, selects the DF backend to use for this field
        Config     => {
            DefaultValue => 'Default',
        },
    },
    {
        Name       => "DFT5$RandomID",
        FieldOrder => 9995,
        FieldType  => 'Checkbox',        # mandatory, selects the DF backend to use for this field
        Config     => {
            DefaultValue => 'Default',
        },
    },
    {
        Name       => "DFT6$RandomID",
        FieldOrder => 9996,
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

# create 3 tickets

# ticket id container
my @TicketIDs;

# create ticket 1
my $TicketID1 = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title ' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465' . $RandomID,
    CustomerUser => 'customerOne@example.com',
    Service      => 'TestService' . $RandomID,
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID1,
    "TicketCreate() successful for Ticket One ID $TicketID1",
);

my $TicketNumber1 = $TicketObject->TicketNumberLookup(
    TicketID => $TicketID1,
);

# sanity check
$Self->True(
    $TicketNumber1,
    "TicketNumberLookup() successful for Ticket One ID $TicketID1",
);

# update escalation times directly in the DB
my $EscalationTime = $StartTime->ToEpoch() + 120;
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => '
        UPDATE ticket
        SET escalation_time = ?, escalation_response_time = ?, escalation_update_time = ?,
            escalation_solution_time = ?, change_time = current_timestamp, change_by = ?
        WHERE id = ?',
    Bind => [
        \$EscalationTime,
        \$EscalationTime,
        \$EscalationTime,
        \$EscalationTime,
        \'1',
        \$TicketID1,
    ],
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
    Value              => '2001-01-01 00:00:00',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[4],
    ObjectID           => $TicketID1,
    Value              => '0',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[5],
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
    if ( $Key eq 'Age' ) {
        delete $TicketEntryOne{$Key};
    }
}

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
    if ( $Key eq 'Age' ) {
        delete $TicketEntryOneDF{$Key};
    }
}

# add ticket id
push @TicketIDs, $TicketID1;

# create ticket 2
my $TicketID2 = $TicketObject->TicketCreate(
    Title        => 'Ticket Two Title ' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465' . $RandomID,
    CustomerUser => 'customerTwo' . $RandomID . '@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID2,
    "TicketCreate() successful for Ticket Two ID $TicketID2",
);

my $TicketNumber2 = $TicketObject->TicketNumberLookup(
    TicketID => $TicketID2,
);

# sanity check
$Self->True(
    $TicketNumber2,
    "TicketNumberLookup() successful for Ticket One ID $TicketID2",
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
    Value              => '2011-11-11 00:00:00',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[4],
    ObjectID           => $TicketID2,
    Value              => '1',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $TestFieldConfig[5],
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
    if ( $Key eq 'Age' ) {
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
    if ( $Key eq 'Age' ) {
        delete $TicketEntryTwoDF{$Key};
    }
}

# add ticket id
push @TicketIDs, $TicketID2;

# create ticket 3
my $TicketID3 = $TicketObject->TicketCreate(
    Title        => 'Ticket Three Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '1 very low',
    State        => 'new',
    CustomerID   => '123465' . $RandomID,
    CustomerUser => 'customerThree@example.com',
    Type         => 'TestType' . $RandomID,
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
    if ( $Key eq 'Age' ) {
        delete $TicketEntryThree{$Key};
    }
}

# add ticket id
push @TicketIDs, $TicketID3;

# create ticket 4
my $TicketID4 = $TicketObject->TicketCreate(
    Title        => 'Ticket Four Title äöüßÄÖÜ€ис',
    Queue        => 'Junk',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '654321' . $RandomID,
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

$ArticleObject->ArticleSearchIndexBuild(
    TicketID  => $TicketID4,
    ArticleID => $ArticleID41,
    UserID    => 1,
);

# second article
my $ArticleID42 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID4,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'Anot Real Agent <email@example.com>',
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

$ArticleObject->ArticleSearchIndexBuild(
    TicketID  => $TicketID4,
    ArticleID => $ArticleID42,
    UserID    => 1,
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

# Get article contents (attachments).
my @ArticleBox = $ArticleContentGet->(
    Articles => \@Articles,
    TicketID => $TicketID4,
);

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
            $Attachment{Content}            = $Param{NoContent} ? '' : encode_base64( $Attachment{Content} );
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

# get the Ticket entry
my %TicketEntryFour = $TicketObject->TicketGet(
    TicketID      => $TicketID4,
    DynamicFields => 0,
    UserID        => $UserID,
);

$Self->True(
    IsHashRefWithData( \%TicketEntryFour ),
    "TicketGet() successful for Local TicketGet Four ID $TicketID4"
);

for my $Key ( sort keys %TicketEntryFour ) {
    if ( !$TicketEntryFour{$Key} ) {
        $TicketEntryFour{$Key} = '';
    }
    if ( $Key eq 'Age' ) {
        delete $TicketEntryFour{$Key};
    }
}

# add ticket id
push @TicketIDs, $TicketID4;

# set web service name
my $WebserviceName = '-Test-' . $RandomID;

# create web service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create web service object"
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
    'Added web service'
);

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# prepare web service config
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
            TicketSearch => {
                Type => 'Ticket::TicketSearch',
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
            TicketSearch => {
                Type => 'Test::TestSimple',
            },
            SessionCreate => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# update web service with real config
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => $UserID,
);
$Self->True(
    $WebserviceUpdate,
    "Updated web service $WebserviceID - $WebserviceName"
);

# Get SessionID
# create requester object
my $RequesterSessionObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
$Self->Is(
    'Kernel::GenericInterface::Requester',
    ref $RequesterSessionObject,
    'SessionID - Create requester object'
);

# create a new user for current test
my $UserLogin = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);
my $Password = $UserLogin;

# start requester with our web service
my $RequesterSessionResult = $RequesterSessionObject->Run(
    WebserviceID => $WebserviceID,
    Invoker      => 'SessionCreate',
    Data         => {
        UserLogin => $UserLogin,
        Password  => $Password,
    },
);

my $NewSessionID = $RequesterSessionResult->{Data}->{SessionID};

my $TestCounter = 1;

my @Tests = (
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketNumber => $TicketNumber1,
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID1],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID1,
            },
            Success => 1
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketNumber => [
                $TicketNumber1,
                $TicketNumber2,
            ],
            SortBy  => 'Ticket',    # force order, because the Age (default) can be the same
            OrderBy => 'Down',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            Title => 'Ticket Two Title ' . $RandomID,
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID2],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID2,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            Title => [
                'Ticket One Title ' . $RandomID,
                'Ticket Two Title ' . $RandomID,
            ],
            SortBy  => 'Ticket',    # force order, because the Age (default) can be the same
            OrderBy => 'Down',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            Title  => 'Ticket Two Title ' . $RandomID,
            Queues => 'Raw'
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID2],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID2,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            Title  => 'Ticket Two Title ' . $RandomID,
            Queues => 'Raw',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID2],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID2,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            Title => 'Ticket Two Title ' . $RandomID,
            Locks => 'unlock',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID2],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID2,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            Title  => 'Ticket Two Title ' . $RandomID,
            States => 'new',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID2],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID2,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            Title      => 'Ticket Two Title ' . $RandomID,
            Priorities => '3 normal',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID2],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID2,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            CustomerID => '123465' . $RandomID,
            SortBy     => 'Ticket',               # force order, because the Age (default) can be the same
            OrderBy    => 'Down',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID2, $TicketID1 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID2, $TicketID1 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            Queues     => ['Junk'],
            CustomerID => '654321' . $RandomID,
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID4],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID4,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            Types => [ 'TestType' . $RandomID ],
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID3],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID3,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            States => ['new'],
            Title  => 'Ticket Two Title ' . $RandomID,
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID2],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID2,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            States  => ['new'],
            Title   => '*' . $RandomID,
            SortBy  => 'Ticket',          # force order, because the Age (default) can be the same
            OrderBy => 'Down',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            Title      => '* äöüßÄÖÜ€ис',
            CustomerID => '654321' . $RandomID,
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID4],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID4,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            Priorities => ['1 very low'],
            CustomerID => '123465' . $RandomID,
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID3],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID3,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test (Hash) DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            DynamicField => {
                Name   => "DFT1$RandomID",
                Equals => 'ticket2_field1',
            },
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID2],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID2,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test (Hash) DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            DynamicField => {
                Name => "DFT1$RandomID",
                Like => '*_field1',
            },
            SortBy => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test (Array) DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            DynamicField => [
                {
                    Name   => "DFT1$RandomID",
                    Equals => 'ticket2_field1',
                },
            ],
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID2],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID2,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test (Array) DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            DynamicField => [
                {
                    Name => "DFT1$RandomID",
                    Like => '*_field1',
                },
            ],
            SortBy => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test (Old API) DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            "DynamicField_DFT1$RandomID" => {
                Equals => 'ticket2_field1',
            },
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID2],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID2,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test (Old API) DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            "DynamicField_DFT1$RandomID" => {
                Like => '*_field1',
            },
            SortBy => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID2, $TicketID1 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test DF Date " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            "DynamicField_DFT4$RandomID" => {
                GreaterThanEquals => '2010-01-01',
            },
            SortBy => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID2],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID2,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test LastChangeTimeNewerDate +  CreateTimeNewerDate " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketLastChangeTimeNewerDate => $StartTime->ToString(),
            TicketCreateTimeNewerDate     => $StartTime->ToString(),
            SortBy  => 'Ticket',    # force order, because the Age (default) can be the same
            OrderBy => 'Down',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID4, $TicketID3, $TicketID2, $TicketID1 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID4, $TicketID3, $TicketID2, $TicketID1 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test CreateTimeNewerDate " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketCreateTimeNewerDate => $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    Epoch => $StartTime->ToEpoch() + 10,
                },
                )->ToString(),
            SortBy  => 'Ticket',    # force order, because the Age (default) can be the same
            OrderBy => 'Down',
        },
        ExpectedReturnLocalData => {
            Data    => {},
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data    => {},
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test Limit " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketLastChangeTimeNewerDate => $StartTime->ToString(),
            TicketCreateTimeNewerDate     => $StartTime->ToString(),
            SortBy  => 'Ticket',    # force order, because the Age (default) can be the same
            OrderBy => 'Down',
            Limit   => 1,
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID4],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID4,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test EscalationTime " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketEscalationTimeNewerMinutes => 120,
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID1],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID1,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test EscalationResponseTime " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketEscalationResponseTimeNewerMinutes => 120,
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID1],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID1,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test EscalationUpdateTime " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketEscalationUpdateTimeNewerMinutes => 120,
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID1],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID1,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test EscalationSolutionTime " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketEscalationSolutionTimeNewerMinutes => 120,
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID1],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID1,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test ContentSearch Parameter" . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            MIMEBase_Body    => 'text body long',
            MIMEBase_Subject => 'text body long',
            ContentSearch    => 'OR',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [$TicketID4],
            },
            Success => 1,
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => $TicketID4,
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test Operator 'Empty' DFT1 - DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketID     => [ $TicketID1, $TicketID2, $TicketID3, $TicketID4 ],
            DynamicField => {
                Name  => "DFT1$RandomID",
                Empty => 1,
            },
            OrderBy => 'Up',
            SortBy  => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test Operator 'Empty' DFT2 - DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketID     => [ $TicketID1, $TicketID2, $TicketID3, $TicketID4 ],
            DynamicField => {
                Name  => "DFT2$RandomID",
                Empty => 1,
            },
            OrderBy => 'Up',
            SortBy  => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test Operator 'Empty' DFT3 - DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketID     => [ $TicketID1, $TicketID2, $TicketID3, $TicketID4 ],
            DynamicField => {
                Name  => "DFT3$RandomID",
                Empty => 1,
            },
            OrderBy => 'Up',
            SortBy  => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test Operator 'Empty' DFT4 - DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketID     => [ $TicketID1, $TicketID2, $TicketID3, $TicketID4 ],
            DynamicField => {
                Name  => "DFT4$RandomID",
                Empty => 1,
            },
            OrderBy => 'Up',
            SortBy  => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test Operator 'Empty' DFT ALL - DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketID     => [ $TicketID1, $TicketID2, $TicketID3, $TicketID4 ],
            DynamicField => [
                {
                    Name  => "DFT1$RandomID",
                    Empty => 1,
                },
                {
                    Name  => "DFT2$RandomID",
                    Empty => 1,
                },
                {
                    Name  => "DFT3$RandomID",
                    Empty => 1,
                },
                {
                    Name  => "DFT4$RandomID",
                    Empty => 1,
                },
            ],
            OrderBy => 'Up',
            SortBy  => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test (Old API) Operator 'Empty' DFT1 - DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketID                     => [ $TicketID1, $TicketID2, $TicketID3, $TicketID4 ],
            "DynamicField_DFT1$RandomID" => {
                Empty => 1,
            },
            OrderBy => 'Up',
            SortBy  => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test (Old API) Operator 'Empty' DFT2 - DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketID                     => [ $TicketID1, $TicketID2, $TicketID3, $TicketID4 ],
            "DynamicField_DFT2$RandomID" => {
                Empty => 1,
            },
            OrderBy => 'Up',
            SortBy  => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test (Old API) Operator 'Empty' DFT3 - DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketID                     => [ $TicketID1, $TicketID2, $TicketID3, $TicketID4 ],
            "DynamicField_DFT3$RandomID" => {
                Empty => 1,
            },
            OrderBy => 'Up',
            SortBy  => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test (Old API) Operator 'Empty' DFT4 - DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketID                     => [ $TicketID1, $TicketID2, $TicketID3, $TicketID4 ],
            "DynamicField_DFT4$RandomID" => {
                Empty => 1,
            },
            OrderBy => 'Up',
            SortBy  => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
    {
        Name           => "Test (Old API) Operator 'Empty' DFT ALL - DF " . $TestCounter++,
        SuccessRequest => 1,
        RequestData    => {
            TicketID                     => [ $TicketID1, $TicketID2, $TicketID3, $TicketID4 ],
            "DynamicField_DFT1$RandomID" => {
                Empty => 1,
            },
            "DynamicField_DFT2$RandomID" => {
                Empty => 1,
            },
            "DynamicField_DFT3$RandomID" => {
                Empty => 1,
            },
            "DynamicField_DFT4$RandomID" => {
                Empty => 1,
            },
            OrderBy => 'Up',
            SortBy  => 'TicketNumber',
        },
        ExpectedReturnLocalData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                TicketID => [ $TicketID3, $TicketID4 ],
            },
            Success => 1,
        },
        Operation => 'TicketSearch',
    },
);

# Add a wrong value test for each possible parameter on direct search

for my $Item (
    qw(
    TicketNumber Title MIMEBase_From MIMEBase_To MIMEBase_Cc MIMEBase_Subject
    MIMEBase_Body CustomerID CustomerUserLogin StateType Fulltext
    )
    )
{
    my $FailTest = {
        Name           => "Test $Item",
        SuccessRequest => 1,
        RequestData    => {
            $Item => 'NotAReal' . $Item,
        },
        ExpectedReturnLocalData => {
            Data    => {},
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data    => {},
            Success => 1
        },
        Operation => 'TicketSearch',
    };

    # push test
    push @Tests, $FailTest;
}

# Arrays as strings
for my $Item (
    qw(StateIDs StateTypeIDs QueueIDs PriorityIDs OwnerIDs
    CreatedQueueIDs CreatedUserIDs WatchUserIDs ResponsibleIDs
    TypeIDs ServiceIDs SLAIDs LockIDs Queues Types States
    Priorities Services SLAs Locks CreatedTypes CreatedUserIDs
    CreatedTypes CreatedTypeIDs CreatedPriorities
    CreatedPriorityIDs CreatedStates CreatedStateIDs
    CreatedQueues CreatedQueueIDs
    )
    )
{
    my $FailTest = {
        Name           => "Test $Item",
        SuccessRequest => 1,
        RequestData    => {
            $Item => 'NotAReal' . $Item,
        },
        ExpectedReturnLocalData => {
            Data    => {},
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data    => {},
            Success => 1
        },
        Operation => 'TicketSearch',
    };

    # push test
    push @Tests, $FailTest;
}

# Arrays
for my $Item (
    qw(StateIDs StateTypeIDs QueueIDs PriorityIDs OwnerIDs
    CreatedQueueIDs CreatedUserIDs WatchUserIDs ResponsibleIDs
    TypeIDs ServiceIDs SLAIDs LockIDs Queues Types States
    Priorities Services SLAs Locks CreatedTypes CreatedUserIDs
    CreatedTypes CreatedTypeIDs CreatedPriorities
    CreatedPriorityIDs CreatedStates CreatedStateIDs
    CreatedQueues CreatedQueueIDs
    )
    )
{
    my $FailTest = {
        Name           => "Test $Item",
        SuccessRequest => 1,
        RequestData    => {
            $Item => [
                'NotAReal' . $Item . 'One',
                'NotAReal' . $Item . 'Two',
                'NotAReal' . $Item . 'Three',
            ],
        },
        ExpectedReturnLocalData => {
            Data    => {},
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data    => {},
            Success => 1
        },
        Operation => 'TicketSearch',
    };

    # push test
    push @Tests, $FailTest;
}

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
    'DebuggerObject instantiate correctly'
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

    # start requester with our web service
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            UserLogin => $UserLogin,
            Password  => $Password,
            %{ $Test->{RequestData} },
        },
    );

    # check result
    $Self->Is(
        'HASH',
        ref $LocalResult,
        "$Test->{Name} - Local result structure is valid"
    );

    # create requester object
    my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
    $Self->Is(
        'Kernel::GenericInterface::Requester',
        ref $RequesterObject,
        "$Test->{Name} - Create requester object"
    );

    # start requester with our web service
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            SessionID => $NewSessionID,
            %{ $Test->{RequestData} },
            }
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

    # remove ErrorMessage parameter from direct call
    # result to be consistent with SOAP call result
    if ( $LocalResult->{ErrorMessage} ) {
        delete $LocalResult->{ErrorMessage};
    }

    $Self->IsDeeply(
        $RequesterResult,
        $Test->{ExpectedReturnRemoteData},
        "$Test->{Name} - Requester success status (needs configured and running webserver)"
    );

    if ( $Test->{ExpectedReturnLocalData} ) {
        $Self->IsDeeply(
            $LocalResult,
            $Test->{ExpectedReturnLocalData},
            "$Test->{Name} - Local result matched with expected local call result."
        );
    }
    else {
        $Self->IsDeeply(
            $LocalResult,
            $Test->{ExpectedReturnRemoteData},
            "$Test->{Name} - Local result matched with remote result."
        );
    }

}    #end loop

# cleanup

# cleanup web service
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => $UserID,
);
$Self->True(
    $WebserviceDelete,
    "Deleted web service $WebserviceID"
);

# delete the tickets
for my $TicketID (@TicketIDs) {
    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => $UserID,
    );

    # sanity check
    $Self->True(
        $TicketDelete,
        "TicketDelete() successful for Ticket ID $TicketID"
    );
}

# delete dynamic fields
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
        "DynamicFieldDelete() successful for Field ID $TestFieldConfigItemID"
    );
}

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# delete user
my $Success = $DBObject->Do(
    SQL => "DELETE FROM user_preferences WHERE user_id = $UserID",
);
$Self->True(
    $Success,
    "User preference referenced to User ID $UserID is deleted!"
);
$Success = $DBObject->Do(
    SQL => "DELETE FROM users WHERE id = $UserID",
);
$Self->True(
    $Success,
    "User with ID $UserID is deleted!"
);

# delete type
$Success = $DBObject->Do(
    SQL => "DELETE FROM ticket_type WHERE id = $TypeID",
);
$Self->True(
    $Success,
    "Type with ID $TypeID is deleted!"
);

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

1;
