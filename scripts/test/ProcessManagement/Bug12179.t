
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

use Kernel::System::VariableCheck qw(:all);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Create a new dynamic field name.
my $DynamicFieldName = 'UnitTestDF' . $Helper->GetRandomNumber();

# Define new process.
my %Process = (
    'Process::Activity' => {
        A1 => {
            Name           => 'Start Activity',
            ActivityDialog => {
                '1' => 'AD1',
            },
            ChangeTime => '2016-07-05 15:10:56',
            CreateTime => '2016-07-05 15:09:49',
        },
        A2 => {
            Name       => 'End Activity',
            ChangeTime => '2016-07-05 15:11:06',
            CreateTime => '2016-07-05 15:11:06',
        },
    },
    ActivityDialogs => {
        AD1 => {
            Name             => 'Start AD',
            DescriptionLong  => '',
            DescriptionShort => 'Start AD',
            FieldOrder       => [],
            Fields           => {},
            Interface        => ['AgentInterface'],
            Permission       => '',
            RequiredLock     => 0,
            SubmitAdviceText => '',
            SubmitButtonText => '',
            ChangeTime       => '2016-07-05 15:18:54',
            CreateTime       => '2016-07-05 15:10:45',
        },
    },
    'Process' => {
        P1 => {
            Name => 'Create Ticket Copy',
            Path => {
                A1 => {
                    T1 => {
                        ActivityEntityID => 'A2',
                        TransitionAction => ['TA1'],
                    },
                },
                A2 => {},
            },
            StartActivity       => 'A1',
            StartActivityDialog => 'AD1',
            State               => 'Active',
            StateEntityID       => 'S1',
            ChangeTime          => '2016-07-05 15:22:56',
            CreateTime          => '2016-07-05 15:09:36',
        },
    },
    'Process::TransitionAction' => {
        TA1 => {
            Name   => 'Create Copy',
            Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketCreate',
            Config => {
                SenderType           => 'agent',
                IsVisibleForCustomer => 1,
                Body                 => 'Ticket Copy',
                ContentType          => 'text/plain; charset=UTF8',
                CustomerID           => '',
                CustomerUser         => '',
                $DynamicFieldName    => "<OTRS_TICKET_$DynamicFieldName>",
                HistoryComment       => 'Created new ticket copy',
                HistoryType          => 'AddNote',
                LinkAs               => 'Child',
                Lock                 => 'unlock',
                OwnerID              => 1,
                Priority             => '3 normal',
                Queue                => '<OTRS_TICKET_Queue>',
                State                => 'closed successful',
                Subject              => '<OTRS_TICKET_Title>',
                Title                => '<OTRS_TICKET_Title>',
                Type                 => '<OTRS_TICKET_Type>',
            },
            ChangeTime => '2016-07-05 16:00:22',
            CreateTime => '2016-07-05 15:18:21',
        },
    },
    'Process::Transition' => {
        T1 => {
            Name      => 'Ticket Create',
            Condition => {
                '1' => {
                    Fields => {
                        "DynamicField_$DynamicFieldName" => {
                            Match => '1',
                            Type  => 'String',
                        },
                    },
                    Type => 'and',
                },
                ConditionLinking => 'and',
            },
            ChangeTime => '2016-07-05 15:29:04',
            CreateTime => '2016-07-05 15:13:43',
        },
    },
);
for my $ProcessPart ( sort keys %Process ) {
    my $Success = $ConfigObject->Set(
        Key   => $ProcessPart,
        Value => $Process{$ProcessPart},
    );
    $Self->True(
        $Success,
        "Config Set() for $ProcessPart",
    );
}

# Get dynamic field object.
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# Add new dynamic field.
my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
    InternalField => 0,
    Name          => $DynamicFieldName,
    Label         => 'a description',
    FieldOrder    => 99999,
    FieldType     => 'Text',
    ObjectType    => 'Ticket',
    Config        => {
        DefaultValue => '',
    },
    Reorder => 0,
    ValidID => 1,
    UserID  => 1,
);
$Self->IsNot(
    $DynamicFieldID,
    undef,
    "DynamicFieldAdd() for $DynamicFieldName with true",
);

my $RandomID = $Helper->GetRandomID();

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

# Create tickets.
my %TicketTemplate = (
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerID   => "123465$RandomID",
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
my $TicketID1 = $TicketObject->TicketCreate(
    %TicketTemplate,
    Title => "Test1 $RandomID",
);
$Self->IsNot(
    $TicketID1,
    undef,
    'TicketCrete() for Ticket 1'
);
my $TicketID2 = $TicketObject->TicketCreate(
    %TicketTemplate,
    Title => "Test2 $RandomID",
);
$Self->IsNot(
    $TicketID1,
    undef,
    'TicketCrete() for Ticket 2'
);

# Create articles.
my %ArticleTemplate = (
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    Subject              => 'some short description',
    Body                 => 'Ticket Original',
    ContentType          => 'text/plain; charset=UTF8',
    HistoryComment       => 'Created new ticket',
    HistoryType          => 'AddNote',
    UserID               => 1,
);
my $ArticleID1 = $ArticleBackendObject->ArticleCreate(
    %ArticleTemplate,
    TicketID => $TicketID1,
);
$Self->IsNot(
    $ArticleID1,
    undef,
    'ArticleCrete() for Ticket 1'
);
my $ArticleID2 = $ArticleBackendObject->ArticleCreate(
    %ArticleTemplate,
    TicketID => $TicketID1,
);
$Self->IsNot(
    $ArticleID2,
    undef,
    'ArticleCrete() for Ticket 2'
);

# Get Dynamic Fields Configuration
my $ProcessIDDynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    Name => $ConfigObject->Get('Process::DynamicFieldProcessManagementProcessID'),
);
my $ActivityIDDynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    Name => $ConfigObject->Get('Process::DynamicFieldProcessManagementActivityID'),
);

# Get dynamic field backend object
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

# Enroll Tickets into process
for my $TicketID ( $TicketID1, $TicketID2 ) {
    my $Sucess = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $ProcessIDDynamicFieldConfig,
        ObjectID           => $TicketID,
        Value              => 'P1',
        UserID             => 1,
    );
    $Self->True(
        $Sucess,
        'Process Enrollment DynamicField ValueSet() for Process for TicketID $TicketID'
    );
    $Sucess = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $ActivityIDDynamicFieldConfig,
        ObjectID           => $TicketID,
        Value              => 'A1',
        UserID             => 1,
    );
    $Self->True(
        $Sucess,
        "Process Enrollment DynamicField ValueSet() for Activity for TicketID $TicketID"
    );
}

# Discard ticket object to perform all handlers
$Kernel::OM->ObjectsDiscard(
    Objects => [ 'Kernel::System::Ticket', ],
);

# Get ticket object.
$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Search for tickets (should be only one of each)
for my $Counter ( 1, 2 ) {
    my @TicketIDs = $TicketObject->TicketSearch(
        Title  => "%Test$Counter $RandomID%",
        Result => 'ARRAY',
        UserID => 1,
    );
    $Self->Is(
        scalar @TicketIDs,
        1,
        "TicketSearch() for 'Test$Counter $RandomID' (before trigger the transition)"
    );
}

# Get Dynamic Fields Configuration
my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    Name => $DynamicFieldName,
);

# Set Dynamic Field Trigger Value
for my $TicketID ( $TicketID1, $TicketID2 ) {
    my $Sucess = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $TicketID,
        Value              => '1',
        UserID             => 1,
    );
    $Self->True(
        $Sucess,
        "Transition Trigger DynamicField ValueSet() for TicketID $TicketID"
    );
}

# Discard ticket object to perform all handlers
$Kernel::OM->ObjectsDiscard(
    Objects => [ 'Kernel::System::Ticket', ],
);

# Get ticket object.
$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Search for tickets (should be two of each)
for my $Counter ( 1, 2 ) {
    my @TicketIDs = $TicketObject->TicketSearch(
        Title  => "%Test$Counter $RandomID%",
        Result => 'ARRAY',
        UserID => 1,
    );
    $Self->Is(
        scalar @TicketIDs,
        2,
        "TicketSearch() for 'Test$Counter $RandomID' (after trigger the transition)"
    );
}

# cleanup is done by RestoreDatabase.

1;
