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

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# disable rich text editor
my $Success = $ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 0,
);

$Self->True(
    $Success,
    "Disable RichText with true",
);

# use Test email backend
$Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

$Self->True(
    $Success,
    "Set Email Test backend with true",
);

# disable email checks to create new user
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

$ConfigObject->Set(
    Key   => 'CheckMXRecord',
    Value => 0,
);

# set default language to English
$Success = $ConfigObject->Set(
    Key   => 'DefaultLanguage',
    Value => 'en',
);

$Self->True(
    $Success,
    "Set default language to English",
);

# set not self notify
$Success = $ConfigObject->Set(
    Key   => 'AgentSelfNotifyOnAction',
    Value => 0,
);

$Self->True(
    $Success,
    "Disable Agent Self Notify On Action",
);

my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');

$Success = $TestEmailObject->CleanUp();
$Self->True(
    $Success,
    'Initial cleanup',
);

$Self->IsDeeply(
    $TestEmailObject->EmailsGet(),
    [],
    'Test backend empty after initial cleanup',
);

# enable responsible
$ConfigObject->Set(
    Key   => 'Ticket::Responsible',
    Value => 1,
);

# enable watcher
$ConfigObject->Set(
    Key   => 'Ticket::Watcher',
    Value => 1,
);

# create a new user for current test
my $UserLogin = $Helper->TestUserCreate(
    Groups => ['users'],
);

# get user object
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

my %UserData = $UserObject->GetUserData(
    User => $UserLogin,
);

my $UserID = $UserData{UserID};

# create a new user without permissions
my $UserLogin2 = $Helper->TestUserCreate();

my %UserData2 = $UserObject->GetUserData(
    User => $UserLogin2,
);

# create a new user invalid
my $UserLogin3 = $Helper->TestUserCreate(
    Groups => ['users'],
);

my %UserData3 = $UserObject->GetUserData(
    User => $UserLogin3,
);

# create a new user with permissions via roles only
my $UserLogin4 = $Helper->TestUserCreate();

my %UserData4 = $UserObject->GetUserData(
    User => $UserLogin4,
);

my $SetInvalid = $UserObject->UserUpdate(
    %UserData3,
    ValidID      => 2,
    ChangeUserID => 1,
);

# create a new customer user for current test
my $CustomerUserLogin = $Helper->TestCustomerUserCreate();

# get a random id
my $RandomID = $Helper->GetRandomID();

# get group object
my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

# add group
my $GID = $GroupObject->GroupAdd(
    Name    => "example-group$RandomID",
    Comment => 'comment describing the group',
    ValidID => 1,
    UserID  => 1,
);

$Self->IsNot(
    $GID,
    undef,
    "GroupAdd() should not be undef",
);

$Success = $GroupObject->PermissionGroupUserAdd(
    GID        => $GID,
    UID        => $UserID,
    Permission => {
        ro        => 1,
        move_into => 1,
        create    => 1,
        owner     => 1,
        priority  => 1,
        rw        => 1,
    },
    UserID => 1,
);

$Self->True(
    $Success,
    "Added User ID $UserID to Group ID $GID",
);

# add role
my $RoleID = $GroupObject->RoleAdd(
    Name    => "example-role$RandomID",
    Comment => 'comment describing the role',
    ValidID => 1,
    UserID  => 1,
);

$Self->IsNot(
    $GID,
    undef,
    "RoleAdd() should not be undef",
);

# add role to group
$Success = $GroupObject->PermissionGroupRoleAdd(
    GID        => $GID,
    RID        => $RoleID,
    Permission => {
        ro        => 1,
        move_into => 1,
        create    => 1,
        owner     => 1,
        priority  => 1,
        rw        => 1,
    },
    UserID => 1,
);

$Self->True(
    $Success,
    "Added Role ID $RoleID to Group ID $GID",
);

$Success = $GroupObject->PermissionRoleUserAdd(
    RID    => $RoleID,
    UID    => $UserID,
    Active => 1,
    UserID => 1,
);

$Self->True(
    $Success,
    "Added User ID $UserID to Role ID $RoleID",
);

$Success = $GroupObject->PermissionRoleUserAdd(
    RID    => $RoleID,
    UID    => $UserData4{UserID},
    Active => 1,
    UserID => 1,
);

$Self->True(
    $Success,
    "Added User ID $UserData4{UserID} to Role ID $RoleID",
);

# get queue object
my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

# get queue data
my %Queue = $QueueObject->QueueGet(
    ID => 1,
);

# set queue to special group
$Success = $QueueObject->QueueUpdate(
    QueueID => 1,
    %Queue,
    GroupID => $GID,
    UserID  => 1,
);

$Self->True(
    $Success,
    "Set Queue ID 1 to Group ID $GID",
);

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# create ticket
my $TicketID = $TicketObject->TicketCreate(
    Title         => 'Ticket One Title',
    QueueID       => 1,
    Lock          => 'unlock',
    Priority      => '3 normal',
    State         => 'new',
    CustomerID    => 'example.com',
    CustomerUser  => $CustomerUserLogin,
    OwnerID       => $UserID,
    ResponsibleID => $UserID,
    UserID        => $UserID,
);

# sanity check
$Self->True(
    $TicketID,
    "TicketCreate() successful for Ticket ID $TicketID",
);

my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

# create first article
my $ArticleID1 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 1,
    SenderType           => 'agent',
    Subject              => 'Article 1',
    Body                 => 'This is the first article',
    Charset              => 'ISO-8859-15',
    MimeType             => 'text/plain',
    HistoryType          => 'EmailCustomer',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    From                 => "$CustomerUserLogin\@localunittest.com",
    To                   => 'test1@otrsexample.com',
    Cc                   => 'test2@otrsexample.com',
);

$Self->True(
    $ArticleID1,
    "Article is created - ID $ArticleID1",
);

# create last article
my $ArticleID2 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 1,
    SenderType           => 'customer',
    Subject              => 'Article 2',
    Body                 => 'This is the last article',
    Charset              => 'ISO-8859-15',
    MimeType             => 'text/plain',
    HistoryType          => 'EmailCustomer',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    From                 => "$CustomerUserLogin\@localunittest.com",
    To                   => 'test3@otrsexample.com',
    Cc                   => 'test4@otrsexample.com',
);

$Self->True(
    $ArticleID2,
    "Article is created - ID $ArticleID2",
);

my $CustomerTicketID = $TicketObject->TicketCreate(
    Title         => 'Ticket One Title',
    QueueID       => 1,
    Lock          => 'unlock',
    Priority      => '3 normal',
    State         => 'new',
    CustomerID    => 'example.com',
    CustomerUser  => $CustomerUserLogin,
    OwnerID       => $UserID,
    ResponsibleID => $UserID,
    UserID        => $UserID,
);

$Self->True(
    $CustomerTicketID,
    "TicketCreate() successful for Ticket ID $CustomerTicketID",
);

# create first customer article
my $CustomerArticleID1 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $CustomerTicketID,
    IsVisibleForCustomer => 1,
    SenderType           => 'customer',
    Subject              => 'Article 1',
    Body                 => 'This is the first article',
    Charset              => 'ISO-8859-15',
    MimeType             => 'text/plain',
    HistoryType          => 'EmailCustomer',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    From                 => "$CustomerUserLogin\@localunittest.com",
    To                   => 'test1@otrsexample.com',
    Cc                   => 'test2@otrsexample.com',
);

$Self->True(
    $CustomerArticleID1,
    "Article is created - ID $ArticleID1",
);

my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
my $DynamicFieldValueObject   = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

# Create test ticket dynamic field of type checkbox.
my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT1$RandomID",
    Label      => 'Description',
    FieldOrder => 9991,
    FieldType  => 'Checkbox',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 1,
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);
$Self->True(
    $FieldID,
    "DynamicFieldAdd - Added checkbox field ($FieldID)",
);

my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID,
);

# Set ticket dynamic field checkbox value to unchecked.
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfig,
    ObjectID           => $TicketID,
    Value              => 0,
    UserID             => 1,
);
$Self->True(
    $Success,
    'ValueSet - Checkbox value set to unchecked',
);

# Create test ticket dynamic field of type text.
$FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT2$RandomID",
    Label      => 'Additional Email',
    FieldOrder => 9992,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => '',
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);
$Self->True(
    $FieldID,
    "DynamicFieldAdd - Added text field ($FieldID)",
);

$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID,
);

# Set ticket dynamic field value to additional email
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfig,
    ObjectID           => $TicketID,
    Value              => 'foo@bar.com',
    UserID             => 1,
);
$Self->True(
    $Success,
    'ValueSet - Text value set to foo@bar.com',
);

# Create test ticket dynamic field of type text.
$FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT3$RandomID",
    Label      => 'Additional Email #2',
    FieldOrder => 9993,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => '',
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);
$Self->True(
    $FieldID,
    "DynamicFieldAdd - Added text field ($FieldID)",
);

$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID,
);

# Set ticket dynamic field value to additional email
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfig,
    ObjectID           => $TicketID,
    Value              => 'bar@foo.com',
    UserID             => 1,
);
$Self->True(
    $Success,
    'ValueSet - Text value set to bar@foo.com',
);

my $SuccessWatcher = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketID,
    WatchUserID => $UserID,
    UserID      => $UserID,
);

# sanity check
$Self->True(
    $SuccessWatcher,
    "TicketWatchSubscribe() successful for Ticket ID $TicketID",
);

my @Tests = (
    {
        Name => 'Missing Event',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        Config => {
            Data => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [],
        Success         => 0,
    },
    {
        Name => 'Missing Data',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        Config => {
            Event  => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [],
        Success         => 0,
    },
    {
        Name => 'Missing Config',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        Config => {
            Event => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Data  => {
                TicketID => $TicketID,
            },
            UserID => 1,
        },
        ExpectedResults => [],
        Success         => 0,
    },
    {
        Name => 'Missing UserID',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        Config => {
            Event => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
        },
        ExpectedResults => [],
        Success         => 0,
    },
    {
        Name => 'RecipientAgent PostMasteruserID',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults     => [],
        SetPostMasterUserID => $UserID,
        Success             => 1,
    },
    {
        Name => 'RecipientAgent Event Trigger',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => $UserData{UserID},
        },
        ExpectedResults => [],
        Success         => 1,
    },
    {
        Name => 'RecipientAgent OutOfOffice (in the past)',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        SetOutOfOffice          => 1,
        SetOutOfOfficeDiffStart => -3 * 60 * 60 * 24,
        SetOutOfOfficeDiffEnd   => -1 * 60 * 60 * 24,
        Success                 => 1,
    },
    {
        Name => 'RecipientAgent OutOfOffice (currently)',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults         => [],
        SetOutOfOffice          => 1,
        SetOutOfOfficeDiffStart => -1 * 60 * 60 * 24,
        SetOutOfOfficeDiffEnd   => 1 * 60 * 60 * 24,
        Success                 => 1,
    },
    {
        Name => 'RecipientAgent OutOfOffice (in the future)',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        SetOutOfOffice          => 1,
        SetOutOfOfficeDiffStart => 1 * 60 * 60 * 24,
        SetOutOfOfficeDiffEnd   => 3 * 60 * 60 * 24,
        Success                 => 1,
    },
    {
        Name => 'RecipientAgent Customizable / No preference',
        Data => {
            Events                => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents       => [$UserID],
            VisibleForAgent       => [1],
            Transports            => ['Email'],
            AgentEnabledByDefault => ['Email'],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientAgent Customizable / Enabled preference',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
            VisibleForAgent => [1],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        SetUserNotificationPreference => {
            Value => 1,
        },
        Success => 1,
    },
    {
        Name => 'RecipientAgent Customizable / Disabled preference',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
            VisibleForAgent => [1],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults               => [],
        SetUserNotificationPreference => {
            Value => 0,
        },
        Success => 1,
    },
    {
        Name => 'RecipientAgent OncePerDay',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
            OncePerDay      => [1],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults  => [],
        SetTicketHistory => 1,
        Success          => 1,
    },
    {
        Name => 'RecipientAgent Without Permissions',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [ $UserData2{UserID} ],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [],
        Success         => 1,
    },
    {
        Name => 'Recipients agent creator for agent ticket - sent',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => ['AgentCreateBy'],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'Recipients agent creator for customer ticket - not sent',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => ['AgentCreateBy'],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $CustomerTicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [],    # no notification, because ticket was not created by an agent
        Success         => 1,
    },
    {
        Name => 'Recipients Owner',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => ['AgentOwner'],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'Recipients Responsible',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => ['AgentResponsible'],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'Recipients Watcher',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => ['AgentWatcher'],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'Recipients Write Permissions',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => ['AgentWritePermissions'],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => [ $UserData4{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientAgent invalid',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [ $UserID, $UserData3{UserID} ],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'Single RecipientAgent',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientAgent + RecipientEmail',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
            RecipientEmail  => ['test@otrsexample.com'],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientAgent SkipRecipients',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID       => $TicketID,
                SkipRecipients => [$UserID],
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [],
        Success         => 1,
    },
    {
        Name => 'RecipientGroups',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientGroups => [$GID],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientRoles',
        Data => {
            Events         => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientRoles => [$RoleID],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => [ $UserData4{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientAgents + RecipientGroups + RecipientRoles',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
            RecipientGroups => [$GID],
            RecipientRoles  => [$RoleID],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => [ $UserData4{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientCustomer + IsVisibleForCustomer = 0',
        Data => {
            Events               => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients           => ['Customer'],
            IsVisibleForCustomer => [0],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
                ToArray => ["$CustomerUserLogin\@localunittest.com"],
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientCustomer + OncePerDay',
        Data => {
            Events               => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients           => ['Customer'],
            IsVisibleForCustomer => [0],
            OncePerDay           => [1],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [],
        Success         => 1,
    },
    {
        Name => 'RecipientEmail filter by unchecked dynamic field',
        Data => {
            Events         => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail => ['test@otrsexample.com'],

            # Filter by unchecked checbox dynamic field value. Note that the search value (-1) is
            #   different than the match value (0). See bug#12257 for more information.
            'Search_DynamicField_DFT1' . $RandomID => [-1],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => ['test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientEmail additional recipient by dynamic field',
        Data => {
            Events         => [ 'TicketDynamicFieldUpdate_DFT2' . $RandomID . 'Update' ],
            RecipientEmail => ["<OTRS_TICKET_DynamicField_DFT2${RandomID}>"],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT2' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => ['foo@bar.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientEmail additional recipient by dynamic field (first position)',
        Data => {
            Events         => [ 'TicketDynamicFieldUpdate_DFT2' . $RandomID . 'Update' ],
            RecipientEmail => ["<OTRS_TICKET_DynamicField_DFT2${RandomID}>, test\@otrsexample.com"],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT2' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => ['foo@bar.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientEmail additional recipient by dynamic field (last position)',
        Data => {
            Events         => [ 'TicketDynamicFieldUpdate_DFT2' . $RandomID . 'Update' ],
            RecipientEmail => ["test\@otrsexample.com, <OTRS_TICKET_DynamicField_DFT2${RandomID}>"],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT2' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => ['foo@bar.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'RecipientEmail additional recipient by dynamic field (two fields)',
        Data => {
            Events         => [ 'TicketDynamicFieldUpdate_DFT3' . $RandomID . 'Update' ],
            RecipientEmail => [
                "<OTRS_TICKET_DynamicField_DFT3${RandomID}>, <OTRS_TICKET_DynamicField_DFT2${RandomID}>"
            ],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT3' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray => ['bar@foo.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['foo@bar.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'AllRecipientsFirstArticle',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => ['AllRecipientsFirstArticle'],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray =>
                    [ "$CustomerUserLogin\@localunittest.com", 'test1@otrsexample.com', 'test2@otrsexample.com' ],
                Body => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'AllRecipientsLastArticle',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => ['AllRecipientsLastArticle'],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray =>
                    [ "$CustomerUserLogin\@localunittest.com", 'test3@otrsexample.com', 'test4@otrsexample.com' ],
                Body => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'AllRecipientsFirstArticle + Customer',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => [ 'AllRecipientsFirstArticle', 'Customer' ],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray =>
                    [ "$CustomerUserLogin\@localunittest.com", 'test1@otrsexample.com', 'test2@otrsexample.com' ],
                Body => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'AllRecipientsLastArticle + Customer',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => [ 'AllRecipientsLastArticle', 'Customer' ],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray =>
                    [ "$CustomerUserLogin\@localunittest.com", 'test3@otrsexample.com', 'test4@otrsexample.com' ],
                Body => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
    {
        Name => 'AllRecipientsFirstArticle + AllRecipientsLastArticle + Customer',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => [ 'AllRecipientsFirstArticle', 'AllRecipientsLastArticle', 'Customer' ],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => [
            {
                ToArray =>
                    [ "$CustomerUserLogin\@localunittest.com", 'test1@otrsexample.com', 'test2@otrsexample.com' ],
                Body => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => [ 'test3@otrsexample.com', 'test4@otrsexample.com' ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        Success => 1,
    },
);

my $SetPostMasterUserID = sub {
    my %Param = @_;

    my $Success = $ConfigObject->Set(
        Key   => 'PostmasterUserID',
        Value => $Param{UserID},
    );

    $Self->True(
        $Success,
        "PostmasterUserID set to $Param{UserID}",
    );
};

my $SetOutOfOffice = sub {
    my %Param = @_;

    if ( $Param{OutOfOffice} ) {

        # create datetime object
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        my $SetOutOfOfficeDiffStartObj = $DateTimeObject->Clone();
        $SetOutOfOfficeDiffStartObj->Add( Seconds => $Param{SetOutOfOfficeDiffStart} );
        my $SetOutOfOfficeDiffStartValues = $SetOutOfOfficeDiffStartObj->Get();

        my $SetOutOfOfficeDiffEndObj = $DateTimeObject->Clone();
        $SetOutOfOfficeDiffEndObj->Add( Seconds => $Param{SetOutOfOfficeDiffEnd} );
        my $SetOutOfOfficeDiffEndValues = $SetOutOfOfficeDiffEndObj->Get();

        my %Preferences = (
            OutOfOfficeStartYear  => $SetOutOfOfficeDiffStartValues->{Year},
            OutOfOfficeStartMonth => $SetOutOfOfficeDiffStartValues->{Month},
            OutOfOfficeStartDay   => $SetOutOfOfficeDiffStartValues->{Day},
            OutOfOfficeEndYear    => $SetOutOfOfficeDiffEndValues->{Year},
            OutOfOfficeEndMonth   => $SetOutOfOfficeDiffEndValues->{Month},
            OutOfOfficeEndDay     => $SetOutOfOfficeDiffEndValues->{Day},
        );

        # pref update db
        my $Success = $UserObject->SetPreferences(
            UserID => $Param{UserID},
            Key    => 'OutOfOffice',
            Value  => 1,
        );

        for my $Key (
            qw( OutOfOfficeStartYear OutOfOfficeStartMonth OutOfOfficeStartDay OutOfOfficeEndYear OutOfOfficeEndMonth OutOfOfficeEndDay)
            )
        {

            # pref update db
            my $PreferenceSet = $UserObject->SetPreferences(
                UserID => $Param{UserID},
                Key    => $Key,
                Value  => $Preferences{$Key},
            );

            if ( !$PreferenceSet ) {
                $Success = 0;
            }
        }

        $Self->True(
            $Success,
            "User set OutOfOffice",
        );
    }
    else {

        # pref update db
        my $Success = $UserObject->SetPreferences(
            UserID => $Param{UserID},
            Key    => 'OutOfOffice',
            Value  => 0,
        );

        $Self->True(
            $Success,
            "User set Not OutOfOffice",
        );
    }

    my %UserPreferences = $UserObject->GetPreferences(
        UserID => $Param{UserID},
    );

    return $UserPreferences{OutOfOffice};

};

my $SetTicketHistory = sub {
    my %Param = @_;

    my $Success = $TicketObject->HistoryAdd(
        TicketID     => $TicketID,
        HistoryType  => 'SendAgentNotification',
        Name         => "\%\%$Param{NotificationName}\%\%$Param{UserLogin}\%\%Email",
        CreateUserID => $Param{UserID},
    );

    $Self->True(
        $Success,
        "Ticket HistoryAdd() for User $Param{UserID}",
    );
};

my $SetUserNotificationPreference = sub {
    my %Param = @_;

    my $Value = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => {
            "Notification-$Param{NotificationID}-Email" => $Param{Value},
        },
    );

    my $Success = $UserObject->SetPreferences(
        Key    => 'NotificationTransport',
        Value  => $Value,
        UserID => $Param{UserID},
    );

    $Self->True(
        $Success,
        "Updated notification $Param{NotificationID} preference with value $Param{Value} for User $Param{UserID}",
    );
};

my $PostmasterUserID = $ConfigObject->Get('PostmasterUserID') || 1;

my $NotificationEventObject      = $Kernel::OM->Get('Kernel::System::NotificationEvent');
my $EventNotificationEventObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::NotificationEvent');

my $SendEmail = sub {
    my %Param = @_;

    my $MailQueueObj = $Kernel::OM->Get('Kernel::System::MailQueue');

    # Get last item in the queue.
    my $Items = $MailQueueObj->List();
    my @ToReturn;
    for my $Item (@$Items) {
        $MailQueueObj->Send( %{$Item} );
        push @ToReturn, $Item->{Message};
    }

    return @ToReturn;
};

my $DeleteQueue = sub {
    my %Param = @_;

    my $MailQueueObj = $Kernel::OM->Get('Kernel::System::MailQueue');

    $MailQueueObj->Delete();

};

my $Count = 0;
my $NotificationID;
TEST:
for my $Test (@Tests) {

    # add transport setting
    $Test->{Data}->{Transports} = ['Email'];

    $NotificationID = $NotificationEventObject->NotificationAdd(
        Name    => "JobName$Count-$RandomID",
        Comment => 'An optional comment',
        Data    => $Test->{Data},
        Message => {
            en => {
                Subject     => 'JobName',
                Body        => 'JobName <OTRS_TICKET_TicketID> <OTRS_CONFIG_SendmailModule> <OTRS_OWNER_UserFirstname>',
                ContentType => 'text/plain',
            },
            de => {
                Subject     => 'JobName',
                Body        => 'JobName <OTRS_TICKET_TicketID> <OTRS_CONFIG_SendmailModule> <OTRS_OWNER_UserFirstname>',
                ContentType => 'text/plain',
            },
        },
        ValidID => 1,
        UserID  => 1,
    );

    # sanity check
    $Self->IsNot(
        $NotificationID,
        undef,
        "$Test->{Name} - NotificationAdd() should not be undef",
    );

    if ( $Test->{SetPostMasterUserID} ) {
        $SetPostMasterUserID->(
            UserID => $Test->{SetPostMasterUserID},
        );
    }

    if ( $Test->{SetTicketHistory} ) {
        $SetTicketHistory->(
            UserID           => $UserID,
            UserLogin        => $UserLogin,
            NotificationName => "JobName$Count-$RandomID",
        );
    }

    if ( $Test->{SetUserNotificationPreference} ) {
        $SetUserNotificationPreference->(
            UserID         => $UserID,
            NotificationID => $NotificationID,
            %{ $Test->{SetUserNotificationPreference} },
        );
    }

    if ( $Test->{SetOutOfOffice} ) {
        my $SuccessOOO = $SetOutOfOffice->(
            SetOutOfOfficeDiffStart => $Test->{SetOutOfOfficeDiffStart},
            SetOutOfOfficeDiffEnd   => $Test->{SetOutOfOfficeDiffEnd},
            UserID                  => $UserID,
            OutOfOffice             => 1,
        );

        # set out of office should always be true
        next TEST if !$SuccessOOO;
    }

    my $Result = $EventNotificationEventObject->Run( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Result,
            "$Test->{Name} - NotificationEvent Run() with false",
        );

        # notification will be deleted in "continue" statement
        next TEST;
    }

    $Self->True(
        $Result,
        "$Test->{Name} - NotificationEvent Run() with true",
    );

    $SendEmail->();

    my $Emails = $TestEmailObject->EmailsGet();

    # remove not needed data
    for my $Email ( @{$Emails} ) {
        for my $Attribute (qw(From Header)) {
            delete $Email->{$Attribute};
        }

        # de-reference body
        $Email->{Body} = ${ $Email->{Body} };
    }

    my @EmailSorted           = sort { $a->{ToArray}->[0] cmp $b->{ToArray}->[0] } @{$Emails};
    my @ExpectedResultsSorted = sort { $a->{ToArray}->[0] cmp $b->{ToArray}->[0] } @{ $Test->{ExpectedResults} };

    $Self->IsDeeply(
        \@EmailSorted,
        \@ExpectedResultsSorted,
        "$Test->{Name} - Recipients",
    );

    # check if there is email-notification-int article type when sending notification
    # to customer see bug#11592
    if ( $Test->{Name} =~ /RecipientCustomer/i ) {
        my @ArticleBox = $ArticleObject->ArticleList(
            TicketID             => $TicketID,
            CommunicationChannel => 'Email',
            SenderType           => 'system',
            IsVisibleForCustomer => 0,
        );

        $Self->Is(
            scalar @ArticleBox,
            2,
            "$Test->{Name} - Article Type email-notification-int created for Customer recipient",
        );
    }
}
continue {
    # delete notification event
    my $NotificationDelete = $NotificationEventObject->NotificationDelete(
        ID     => $NotificationID,
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $NotificationDelete,
        "$Test->{Name} - NotificationDelete() successful for Notification ID $NotificationID",
    );

    $TestEmailObject->CleanUp();

    $DeleteQueue->();

    # reset PostMasteruserID to the original value
    if ( $Test->{SetPostMasterUserID} ) {
        $SetPostMasterUserID->(
            UserID => $PostmasterUserID,
        );
    }

    # reset OutOfOffice status
    if ( $Test->{SetOutOfOffice} ) {
        $SetOutOfOffice->(
            UserID      => $UserID,
            OutOfOffice => 0,
        );
    }

    $Count++;
    undef $NotificationID;
}

# cleanup is done by RestoreDatabase but we need to run cleanup
# code too to remove data if the FS backend is used

# delete the ticket
for my $ID ( $TicketID, $CustomerTicketID ) {

    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $ID,
        UserID   => $UserID,
    );

    $Self->True(
        $TicketDelete,
        "TicketDelete() successful for Ticket ID $ID",
    );
}

1;
