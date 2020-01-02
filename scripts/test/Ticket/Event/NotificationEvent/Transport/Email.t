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

use Kernel::System::MailQueue;

use vars (qw($Self));

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
    'Kernel::System::MailQueue' => {
        CheckEmailAddresses => 0,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2016-01-02 03:04:05'
    },
);

$Helper->FixedTimeSet($DateTimeObject);

my $MailQueueObj = $Kernel::OM->Get('Kernel::System::MailQueue');

my $SendEmails = sub {
    my %Param = @_;

    # Get last item in the queue.
    my $Items = $MailQueueObj->List();
    my @ToReturn;
    for my $Item (@$Items) {
        $MailQueueObj->Send( %{$Item} );
        push @ToReturn, $Item->{Message};
    }

    # Clean the mail queue.
    $MailQueueObj->Delete();

    return @ToReturn;
};

# Ensure mail queue is empty before tests start.
$MailQueueObj->Delete();

# Enable email addresses checking.
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

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

# create a new user for current test
my $UserLogin = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->TestUserCreate(
    Groups => ['users'],
);

my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $UserLogin,
);

my $UserID = $UserData{UserID};

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# create ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    QueueID      => 1,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => 'example.com',
    CustomerUser => $UserData{UserLogin},
    OwnerID      => $UserID,
    UserID       => $UserID,
);

# sanity check
$Self->True(
    $TicketID,
    "TicketCreate() successful for Ticket ID $TicketID",
);

my $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal')->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 1,
    SenderType           => 'customer',
    From                 => 'customerOne@example.com, customerTwo@example.com',
    To                   => 'Some Agent A <agent-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    Charset              => 'utf8',
    MimeType             => 'text/plain',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => $UserID,
);

# sanity check
$Self->True(
    $ArticleID,
    "ArticleCreate() successful for Article ID $ArticleID",
);

my $RandomID                  = $Helper->GetRandomNumber();
my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

my @FieldValue = ( 'aaatest@otrsexample.com', 'bbbtest@otrsexample.com', 'ccctest@otrsexample.com' );

my @DynamicFields = (
    {
        Name       => 'TestText' . $RandomID,
        Label      => 'TestText' . $RandomID,
        FieldOrder => 9990,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue => '',
            Link         => '',
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'TestDropdown' . $RandomID,
        Label      => 'TestDropdown' . $RandomID,
        FieldOrder => 9990,
        FieldType  => 'Dropdown',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue   => '',
            Link           => '',
            PossibleNone   => 0,
            PossibleValues => {
                $FieldValue[0] => 'a',
                $FieldValue[1] => 'b',
                $FieldValue[2] => 'c',
            },
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'TestMultiselect' . $RandomID,
        Label      => 'TestMultiselect' . $RandomID,
        FieldOrder => 9990,
        FieldType  => 'Multiselect',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue   => '',
            Link           => '',
            PossibleNone   => 0,
            PossibleValues => {
                $FieldValue[0] => 'a',
                $FieldValue[1] => 'b',
                $FieldValue[2] => 'c',
            },
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => $UserID,
    },
);

# Create test dynamic fields.
my @FieldName;
for my $DynamicField (@DynamicFields) {
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        %{$DynamicField},
    );

    $Self->True(
        $FieldID,
        "Dynamic field $DynamicField->{Name} - ID $FieldID - created",
    );

    my $FieldIDConfig = $DynamicFieldObject->DynamicFieldGet(
        ID => $FieldID,
    );

    my $FieldValueSet = $FieldValue[0];
    if ( $DynamicField->{FieldType} eq 'Multiselect' ) {
        $FieldValueSet = \@FieldValue;
    }

    # Set DF value to ticket - test OTRS tags in RecipientEmail.
    $Success = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $FieldIDConfig,
        ObjectID           => $TicketID,
        Value              => $FieldValueSet,
        UserID             => $UserID,
    );

    push @FieldName, $DynamicField->{Name};
}

my @Tests = (
    {
        Name => 'Single RecipientAgent',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
    },
    {
        Name => 'RecipientAgent + RecipientEmail',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
            RecipientEmail  => ['zzztest@otrsexample.com'],
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['zzztest@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
    },
    {
        Name => 'Recipient Customer - JustToRealCustomer enabled',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => ['Customer'],
        },
        ExpectedResults    => [],
        JustToRealCustomer => 1,
    },
    {
        Name => 'Recipient Customer - JustToRealCustomer disabled',
        Data => {
            Events     => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            Recipients => ['Customer'],
        },
        ExpectedResults => [
            {
                ToArray => [ 'customerOne@example.com', 'customerTwo@example.com' ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
        JustToRealCustomer => 0,
    },
    {
        Name => 'Sending twice Single RecipientAgent without once per day',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
        },
        SendTwice       => 1,
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
    },
    {
        Name => 'Sending twice Single RecipientAgent with once per day',
        Data => {
            Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientAgents => [$UserID],
            OncePerDay      => [1],
        },
        SendTwice       => 1,
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
    },
    {
        Name => 'Multiple valid RecipientEmail',
        Data => {
            Events         => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail => ['zz1test@otrsexample.com, zz2test@otrsexample.com; zz3test@otrsexample.com'],
        },
        ExpectedResults => [
            {
                ToArray => ['zz1test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['zz2test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['zz3test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
    },
    {
        Name => 'Multiple valid RecipientEmail not separated by space with additional commas and semmi-colons',
        Data => {
            Events         => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail => ['zz1test@otrsexample.com,;,zz2test@otrsexample.com;;zz3test@otrsexample.com'],
        },
        ExpectedResults => [
            {
                ToArray => ['zz1test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['zz2test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['zz3test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
    },
    {
        Name => 'Multiple valid and invalid RecipientEmail',
        Data => {
            Events         => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail => ['zz1test@otrsexample.com, asdfqwe; zz2test@otrsexample.com; e212355qwe.com'],
        },
        ExpectedResults => [
            {
                ToArray => ['zz1test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['zz2test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
    },
    {
        Name => 'Multiple valid with OTRS-tags in RecipientEmail - Text type DynamicField',
        Data => {
            Events => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail =>
                ["zz1test\@otrsexample.com, <OTRS_TICKET_DynamicField_$FieldName[0]>, zz2test\@otrsexample.com;"],
        },
        ExpectedResults => [
            {
                ToArray => [ $FieldValue[0] ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['zz1test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['zz2test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
    },
    {
        Name => 'Multiple valid with OTRS-tags in RecipientEmail - Dropdown type DynamicField',
        Data => {
            Events => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail =>
                ["zz1test\@otrsexample.com, <OTRS_TICKET_DynamicField_$FieldName[1]>, zz2test\@otrsexample.com;"],
        },
        ExpectedResults => [
            {
                ToArray => [ $FieldValue[0] ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['zz1test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => ['zz2test@otrsexample.com'],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
    },
    {
        Name => 'Valid with OTRS-tag in RecipientEmail - Multiselect type DynamicField',
        Data => {
            Events => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
            RecipientEmail =>
                ["<OTRS_TICKET_DynamicField_$FieldName[2]>"],
        },
        ExpectedResults => [
            {
                ToArray => [ $FieldValue[0] ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => [ $FieldValue[1] ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
            {
                ToArray => [ $FieldValue[2] ],
                Body    => "JobName $TicketID Kernel::System::Email::Test $UserData{UserFirstname}=\n",
            },
        ],
    },
);

my $NotificationEventObject      = $Kernel::OM->Get('Kernel::System::NotificationEvent');
my $EventNotificationEventObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::NotificationEvent');

my $Count = 0;
for my $Test (@Tests) {

    # add transport setting
    $Test->{Data}->{Transports} = ['Email'];

    # set just to real customer
    my $JustToRealCustomer = $Test->{JustToRealCustomer} || 0;
    $Success = $ConfigObject->Set(
        Key   => 'CustomerNotifyJustToRealCustomer',
        Value => $JustToRealCustomer,
    );

    $Self->True(
        $Success,
        "Set notifications just to real customer: $JustToRealCustomer.",
    );

    my $NotificationID = $NotificationEventObject->NotificationAdd(
        Name    => "JobName$Count-$RandomID",
        Data    => $Test->{Data},
        Message => {
            en => {
                Subject     => 'JobName',
                Body        => 'JobName <OTRS_TICKET_TicketID> <OTRS_CONFIG_SendmailModule> <OTRS_OWNER_UserFirstname>',
                ContentType => 'text/plain',
            },
        },
        Comment => 'An optional comment',
        ValidID => 1,
        UserID  => 1,
    );

    # sanity check
    $Self->IsNot(
        $NotificationID,
        undef,
        "$Test->{Name} - NotificationAdd() should not be undef",
    );

    my $Result = $EventNotificationEventObject->Run(
        Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
        Data  => {
            TicketID => $TicketID,
        },
        Config => {},
        UserID => 1,
    );

    # Test OncePerDay setting.
    if ( $Test->{SendTwice} ) {

        # Ensure %H:%M:%S are all diferent from the first fixed time.
        my $TestDateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => '2016-01-02 08:09:10'
            },
        );

        $Helper->FixedTimeSet($TestDateTimeObject);
        my $Result = $EventNotificationEventObject->Run(
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID => $TicketID,
            },
            Config => {},
            UserID => 1,
        );

        # Set FixedTime back for the other tests
        $Helper->FixedTimeSet($DateTimeObject);
    }

    $SendEmails->();

    my $Emails = $TestEmailObject->EmailsGet();

    # remove not needed data
    for my $Email ( @{$Emails} ) {
        for my $Attribute (qw(From Header)) {
            delete $Email->{$Attribute};
        }

        # de-reference body
        $Email->{Body} = ${ $Email->{Body} };
    }

    my @EmailsSort = sort { $a->{ToArray}[0] cmp $b->{ToArray}[0] } @{$Emails};

    $Self->IsDeeply(
        \@EmailsSort,
        $Test->{ExpectedResults},
        "$Test->{Name} - Recipients",
    );

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

    $Count++;
}

# Cleanup is done by RestoreDatabase.

1;
