# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# Get needed objects.
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

# Get helper object.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

my @DynamicFieldsToAdd = (
    {
        Name       => 'Replace1' . $RandomID,
        Label      => 'a description',
        FieldOrder => 9998,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            Name        => 'Replace1' . $RandomID,
            Description => 'Description for Dynamic Field.',
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => 1,
    },
    {
        Name       => 'Replace2' . $RandomID,
        Label      => 'a description',
        FieldOrder => 9999,
        FieldType  => 'Dropdown',
        ObjectType => 'Ticket',
        Config     => {
            Name           => 'Replace2' . $RandomID,
            Description    => 'Description for Dynamic Field.',
            PossibleValues => {
                1 => 'A',
                2 => 'B',
                }
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => 1,
    },
);

my %AddedDynamicFieldIds;
my %DynamicFieldConfigs;

for my $DynamicField (@DynamicFieldsToAdd) {

    my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        %{$DynamicField},
    );
    $Self->IsNot(
        $DynamicFieldID,
        undef,
        'DynamicFieldAdd()',
    );

    # Remember added DynamicFields.
    $AddedDynamicFieldIds{$DynamicFieldID} = $DynamicField->{Name};

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name => $DynamicField->{Name},
    );
    $Self->Is(
        ref $DynamicFieldConfig,
        'HASH',
        'DynamicFieldConfig must be a hash reference',
    );

    # Remember the DF config.
    $DynamicFieldConfigs{ $DynamicField->{FieldType} } = $DynamicFieldConfig;
}

# Create template generator after the dynamic field are created as it gathers all DF in the
# constructor.
my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

# Set the fixed time.
$Helper->FixedTimeSet(
    $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime( String => '2017-07-05 11:00:00' ),
);

# Create test queue with escalation times.
my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name                => 'Queue' . $RandomID,
    Comment             => "Test Queue",
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 80,
    UpdateTime          => 40,
    UpdateNotify        => 80,
    SolutionTime        => 50,
    SolutionNotify      => 80,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
);
$Self->True(
    $QueueID,
    "QueueID $QueueID - created"
);

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    QueueID      => $QueueID,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->IsNot(
    $TicketID,
    undef,
    'TicketCreate() TicketID',
);

my $Success = $BackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfigs{Text},
    ObjectID           => $TicketID,
    Value              => 'otrs',
    UserID             => 1,
);
$Self->True(
    $Success,
    'DynamicField ValueSet() for Dynamic Field Text - with true',
);

$Success = $BackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
    ObjectID           => $TicketID,
    Value              => 1,
    UserID             => 1,
);
$Self->True(
    $Success,
    'DynamicField ValueSet() Dynamic Field Dropdown - with true',
);

# Add 5 minutes for escalation times evaluation.
$Helper->FixedTimeAddSeconds(300);

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'note-internal',
    SenderType     => 'agent',
    From           => 'Some Agent <email@example.com>',
    To             => 'Some Customer <customer-a@example.com>',
    Subject        => 'some short description',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,                                          # if you don't want to send agent notifications
);
$Self->IsNot(
    $ArticleID,
    undef,
    'ArticleCreate() ArticleID',
);

# Renew object because of transaction.
$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my @Tests = (
    {
        Name => 'Simple replace',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_From>',
        Result   => 'Test test@home.com',
    },
    {
        Name => 'Simple replace, case insensitive',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_FROM>',
        Result   => 'Test test@home.com',
    },
    {
        Name => 'remove unknown tags',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_INVALID_TAG>',
        Result   => 'Test -',
    },
    {
        Name => 'OTRS customer subject',    # <OTRS_CUSTOMER_SUBJECT>
        Data => {
            From    => 'test@home.com',
            Subject => 'otrs',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_SUBJECT>',
        Result   => 'Test otrs',
    },
    {
        Name => 'OTRS customer subject 3 letters',    # <OTRS_CUSTOMER_SUBJECT[20]>
        Data => {
            From    => 'test@home.com',
            Subject => 'otrs',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_SUBJECT[3]>',
        Result   => 'Test otr [...]',
    },
    {
        Name => 'OTRS customer subject 20 letters + garbarge',    # <OTRS_CUSTOMER_SUBJECT[20]>
        Data => {
            From    => 'test@home.com',
            Subject => 'RE: otrs',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_SUBJECT[20]>',
        Result   => 'Test otrs',
    },
    {
        Name => 'OTRS responsible firstname',                     # <OTRS_RESPONSIBLE_UserFirstname>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_RESPONSIBLE_UserFirstname>',
        Result   => 'Test Admin',
    },
    {
        Name => 'OTRS owner firstname',                           # <OTRS_OWNER_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_OWNER_UserFirstname>',
        Result   => 'Test Admin',
    },
    {
        Name => 'OTRS current firstname',                         # <OTRS_CURRENT_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CURRENT_UserFirstname>',
        Result   => 'Test Admin',
    },
    {
        Name => 'OTRS ticket ticketid',                           # <OTRS_TICKET_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_TicketID>',
        Result   => 'Test ' . $TicketID,
    },
    {
        Name => 'OTRS dynamic field (text)',                      # <OTRS_TICKET_DynamicField_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace1' . $RandomID . '>',
        Result   => 'Test otrs',
    },
    {
        Name => 'OTRS dynamic field value (text)',                # <OTRS_TICKET_DynamicField_*_Value>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace1' . $RandomID . '_Value>',
        Result   => 'Test otrs',
    },
    {
        Name => 'OTRS dynamic field (Dropdown)',                  # <OTRS_TICKET_DynamicField_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace2' . $RandomID . '>',
        Result   => 'Test 1',
    },
    {
        Name => 'OTRS dynamic field value (Dropdown)',            # <OTRS_TICKET_DynamicField_*_Value>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace2' . $RandomID . '_Value>',
        Result   => 'Test A',
    },
    {
        Name     => 'OTRS config value',                          # <OTRS_CONFIG_*>
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_CONFIG_DefaultTheme>',
        Result   => 'Test Standard',
    },
    {
        Name     => 'OTRS secret config values, must be masked (even unknown settings)',
        Data     => {},
        RichText => 0,
        Template =>
            'Test <OTRS_CONFIG_DatabasePw> <OTRS_CONFIG_Core::MirrorDB::Password> <OTRS_CONFIG_SomeOtherValue::Password> <OTRS_CONFIG_SomeOtherValue::Pw>',
        Result => 'Test xxx xxx xxx xxx',
    },
    {
        Name     => 'OTRS secret config value and normal config value',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_CONFIG_DatabasePw> and <OTRS_CONFIG_DefaultTheme>',
        Result   => 'Test xxx and Standard',
    },
    {
        Name     => 'OTRS secret config values with numbers',
        Data     => {},
        RichText => 0,
        Template =>
            'Test <OTRS_CONFIG_AuthModule::LDAP::SearchUserPw1> and <OTRS_CONFIG_AuthModule::LDAP::SearchUserPassword1>',
        Result => 'Test xxx and xxx',
    },
    {
        Name => 'mailto-Links RichText enabled',
        Data => {
            From => 'test@home.com',
        },
        RichText => 1,
        Template =>
            'mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20%3COTRS_CUSTOMER_From%3E&amp;body=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Subject und Body</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Subject</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?body=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Body</a><br />',
        Result =>
            'mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20test%40home.com&amp;body=From%3A%20test%40home.com">E-Mail mit Subject und Body</a><br /><br />mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20test%40home.com">E-Mail mit Subject</a><br /><br />mailto-Link <a href="mailto:skywalker@otrs.org?body=From%3A%20test%40home.com">E-Mail mit Body</a><br />',
    },
    {
        Name     => 'OTRS <OTRS_TICKET_EscalationResponseTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_EscalationResponseTime>',
        Result   => "Test 2017-07-05 11:30:00",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_EscalationUpdateTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_EscalationUpdateTime>',
        Result   => "Test 2017-07-05 11:45:00",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_EscalationSolutionTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_EscalationSolutionTime>',
        Result   => "Test 2017-07-05 11:50:00",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_EscalationTimeWorkingTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_EscalationTimeWorkingTime>',
        Result   => "Test 25 m",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_EscalationTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_EscalationTime>',
        Result   => "Test 25 m",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_FirstResponseTimeWorkingTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_FirstResponseTimeWorkingTime>',
        Result   => "Test 25 m",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_FirstResponseTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_FirstResponseTime>',
        Result   => "Test 25 m",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_UpdateTimeWorkingTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_UpdateTimeWorkingTime>',
        Result   => "Test 40 m",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_UpdateTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_UpdateTime>',
        Result   => "Test 40 m",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_SolutionTimeWorkingTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_SolutionTimeWorkingTime>',
        Result   => "Test 45 m",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_SolutionTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_SolutionTime>',
        Result   => "Test 45 m",
    },
);

for my $Test (@Tests) {
    my $Result = $TemplateGeneratorObject->_Replace(
        Text     => $Test->{Template},
        Data     => $Test->{Data},
        RichText => $Test->{RichText},
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - _Replace()",
    );
}

# Set state to 'pending reminder'.
$Success = $TicketObject->TicketStateSet(
    State    => 'pending reminder',
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketID $TicketID - set to pending reminder state successfully",
);

$Success = $TicketObject->TicketPendingTimeSet(
    String   => '2017-07-06 10:00:00',
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "Set pending time successfully",
);

# Check 'UntilTime' and 'RealTillTimeNotUsed' tags (see bug#8301).
@Tests = (
    {
        Name     => 'OTRS <OTRS_TICKET_UntilTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_UntilTime>',
        Result   => "Test 22 h 55 m",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_RealTillTimeNotUsed>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_RealTillTimeNotUsed>',
        Result   => "Test 2017-07-06 10:00:00",
    }
);

for my $Test (@Tests) {
    my $Result = $TemplateGeneratorObject->_Replace(
        Text     => $Test->{Template},
        Data     => $Test->{Data},
        RichText => $Test->{RichText},
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - _Replace()",
    );
}

# Cleanup is done by RestoreDatabase.

1;
