# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $UserObject         = $Kernel::OM->Get('Kernel::System::User');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# Get helper object.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();
my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

my $NotificationLanguage = 'en';
my $UserLanguage         = 'de';

my @DynamicFieldsToAdd = (
    {
        Name       => 'Replace1password' . $RandomID,
        Label      => 'a description',
        FieldOrder => 9998,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            Name        => 'Replace1password' . $RandomID,
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

my $TestCustomerLogin = $Helper->TestCustomerUserCreate(
    Language => $UserLanguage,
);

my %TestCustomerData = $CustomerUserObject->CustomerUserDataGet(
    User => $TestCustomerLogin,
);

# Add a random secret for the customer user.
$CustomerUserObject->SetPreferences(
    Key    => 'UserGoogleAuthenticatorSecretKey',
    Value  => $Helper->GetRandomID(),
    UserID => $TestCustomerLogin,
);

# Generate a token for the customer user.
$CustomerUserObject->TokenGenerate(
    UserID => $TestCustomerLogin,
);

my @TestUsers;
for ( 1 .. 4 ) {
    my $TestUserLogin = $Helper->TestUserCreate(
        Language => $UserLanguage,
    );
    my %TestUser = $UserObject->GetUserData(
        User => $TestUserLogin,
    );

    # Add a random secret for the user.
    $UserObject->SetPreferences(
        Key    => 'UserGoogleAuthenticatorSecretKey',
        Value  => $Helper->GetRandomID(),
        UserID => $TestUser{UserID},
    );

    # Generate a token for the user.
    $UserObject->TokenGenerate(
        UserID => $TestUser{UserID},
    );

    push @TestUsers, \%TestUser;
}

# Create time for time tags check.
my $SystemTime = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2017-07-05 11:00:00',
    },
)->ToEpoch();

# Set the fixed time.
$Helper->FixedTimeSet($SystemTime);

# Create test queue with escalation times.
my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name                => 'Queue' . $RandomID,
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
    Comment             => "Test Queue",
);
$Self->True(
    $QueueID,
    "QueueID $QueueID - created"
);

my $TicketID = $TicketObject->TicketCreate(
    Title         => 'Some Ticket_Title',
    QueueID       => $QueueID,
    Lock          => 'unlock',
    Priority      => '3 normal',
    State         => 'open',
    CustomerNo    => '123465',
    CustomerUser  => $TestCustomerLogin,
    OwnerID       => $TestUsers[0]->{UserID},
    ResponsibleID => $TestUsers[1]->{UserID},
    UserID        => $TestUsers[2]->{UserID},
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

my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

# Add 5 minutes for escalation times evaluation.
$Helper->FixedTimeAddSeconds(300);

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,                                          # if you don't want to send agent notifications
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
        Template => 'Test <OTRS_RESPONSIBLE_UserFirstname> <OTRS_RESPONSIBLE_nonexisting>',
        Result   => "Test $TestUsers[1]->{UserFirstname} -",
    },
    {
        Name => 'OTRS_TICKET_RESPONSIBLE firstname',              # <OTRS_RESPONSIBLE_UserFirstname>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_RESPONSIBLE_UserFirstname> <OTRS_TICKET_RESPONSIBLE_nonexisting>',
        Result   => "Test $TestUsers[1]->{UserFirstname} -",
    },
    {
        Name => 'OTRS responsible password (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_RESPONSIBLE_UserPw> <OTRS_RESPONSIBLE_SomeOtherValue::Password>',
        Result   => "Test xxx -",
    },
    {
        Name => 'OTRS responsible secrets (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_RESPONSIBLE_UserGoogleAuthenticatorSecretKey> <OTRS_RESPONSIBLE_UserToken>',
        Result   => 'Test xxx xxx',
    },
    {
        Name => 'OTRS owner firstname',    # <OTRS_OWNER_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_OWNER_UserFirstname> <OTRS_OWNER_nonexisting>',
        Result   => "Test $TestUsers[0]->{UserFirstname} -",
    },
    {
        Name => 'OTRS_TICKET_OWNER firstname',    # <OTRS_OWNER_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_OWNER_UserFirstname> <OTRS_TICKET_OWNER_nonexisting>',
        Result   => "Test $TestUsers[0]->{UserFirstname} -",
    },
    {
        Name => 'OTRS owner password (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_OWNER_UserPw> <OTRS_OWNER_SomeOtherValue::Password>',
        Result   => "Test xxx -",
    },
    {
        Name => 'OTRS owner secrets (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_OWNER_UserGoogleAuthenticatorSecretKey> <OTRS_OWNER_UserToken>',
        Result   => 'Test xxx xxx',
    },
    {
        Name => 'OTRS current firstname',    # <OTRS_CURRENT_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_nonexisting>',
        Result   => "Test $TestUsers[2]->{UserFirstname} -",
    },
    {
        Name => 'OTRS current password (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CURRENT_UserPw> <OTRS_CURRENT_SomeOtherValue::Password>',
        Result   => 'Test xxx -',
    },
    {
        Name => 'OTRS current secrets (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CURRENT_UserGoogleAuthenticatorSecretKey> <OTRS_CURRENT_UserToken>',
        Result   => 'Test xxx xxx',
    },
    {
        Name => 'OTRS ticket ticketid',    # <OTRS_TICKET_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_TicketID>',
        Result   => 'Test ' . $TicketID,
    },
    {
        Name => 'OTRS dynamic field (text)',    # <OTRS_TICKET_DynamicField_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace1password' . $RandomID . '>',
        Result   => 'Test otrs',
    },
    {
        Name => 'OTRS dynamic field value (text)',    # <OTRS_TICKET_DynamicField_*_Value>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace1password' . $RandomID . '_Value>',
        Result   => 'Test otrs',
    },
    {
        Name => 'OTRS dynamic field (Dropdown)',      # <OTRS_TICKET_DynamicField_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace2' . $RandomID . '>',
        Result   => 'Test 1',
    },
    {
        Name => 'OTRS dynamic field value (Dropdown)',    # <OTRS_TICKET_DynamicField_*_Value>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace2' . $RandomID . '_Value>',
        Result   => 'Test A',
    },
    {
        Name     => 'OTRS config value',                  # <OTRS_CONFIG_*>
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
        Name => 'mailto-Links',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template =>
            'mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20%3COTRS_CUSTOMER_From%3E&amp;body=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Subject und Body</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Subject</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?body=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Body</a><br />',
        Result =>
            'mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20test%40home.com&amp;body=From%3A%20test%40home.com">E-Mail mit Subject und Body</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20test%40home.com">E-Mail mit Subject</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?body=From%3A%20test%40home.com">E-Mail mit Body</a><br />',
    },
    {
        Name => 'OTRS AGENT + CUSTOMER FROM',    # <OTRS_TICKET_DynamicField_*_Value>
        Data => {
            From => 'testcustomer@home.com',
        },
        DataAgent => {
            From => 'testagent@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_From> - <OTRS_CUSTOMER_From>',
        Result   => 'Test testagent@home.com - testcustomer@home.com',
    },
    {
        Name =>
            'OTRS AGENT + CUSTOMER BODY',   # this is an special case, it sets the Body as it is since is the Data param
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_BODY> - <OTRS_CUSTOMER_BODY>',
        Result   => "Test Line1\nLine2\nLine3 - Line1\nLine2\nLine3",
    },
    {
        Name =>
            'OTRS AGENT + CUSTOMER BODY With RichText enabled'
        ,    # this is an special case, it sets the Body as it is since is the Data param
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 1,
        Template => 'Test &lt;OTRS_AGENT_BODY&gt; - &lt;OTRS_CUSTOMER_BODY&gt;',
        Result   => "Test Line1<br/>
Line2<br/>
Line3 - Line1<br/>
Line2<br/>
Line3",
    },
    {
        Name => 'OTRS AGENT + CUSTOMER BODY[2]',
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_BODY[2]> - <OTRS_CUSTOMER_BODY[2]>',
        Result   => "Test > Line1\n> Line2 - > Line1\n> Line2",
    },
    {
        Name => 'OTRS AGENT + CUSTOMER BODY[7] with RichText enabled',
        Data => {
            Body => "Line1\nLine2\nLine3\nLine4\nLine5\nLine6\nLine7\nLine8\nLine9",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3\nLine4\nLine5\nLine6\nLine7\nLine8\nLine9",
        },
        RichText => 1,
        Template => 'Test &lt;OTRS_AGENT_BODY[7]&gt; - &lt;OTRS_CUSTOMER_BODY[7]&gt;',
        Result =>
            'Test <div  type="cite" style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">Line1<br/>
Line2<br/>
Line3<br/>
Line4<br/>
Line5<br/>
Line6<br/>
Line7</div> - <div  type="cite" style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">Line1<br/>
Line2<br/>
Line3<br/>
Line4<br/>
Line5<br/>
Line6<br/>
Line7</div>',
    },
    {
        Name => 'OTRS AGENT + CUSTOMER EMAIL',    # EMAIL without [ ] does not exists
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_EMAIL> - <OTRS_CUSTOMER_EMAIL>',
        Result   => "Test Line1\nLine2\nLine3 - Line1\nLine2\nLine3",
    },
    {
        Name => 'OTRS AGENT + CUSTOMER EMAIL[2]',
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_EMAIL[2]> - <OTRS_CUSTOMER_EMAIL[2]>',
        Result   => "Test > Line1\n> Line2 - > Line1\n> Line2",
    },
    {
        Name => 'OTRS COMMENT',
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTRS_COMMENT>',
        Result   => "Test > Line1\n> Line2\n> Line3",
    },

    {
        Name => 'OTRS COMMENT[2]',
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTRS_COMMENT[2]>',
        Result   => "Test > Line1\n> Line2",
    },
    {
        Name => 'OTRS AGENT + CUSTOMER SUBJECT[2]',
        Data => {
            Subject => '0123456789'
        },
        DataAgent => {
            Subject => '987654321'
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_SUBJECT[2]> - <OTRS_CUSTOMER_SUBJECT[2]>',
        Result   => "Test 98 [...] - 01 [...]",
    },
    {
        Name     => 'OTRS CUSTOMER REALNAME',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_REALNAME>',
        Result   => "Test $TestCustomerLogin $TestCustomerLogin",
    },
    {
        Name     => 'OTRS CUSTOMER DATA UserFirstname',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_DATA_UserFirstname>',
        Result   => "Test $TestCustomerLogin",
    },
    {
        Name     => 'OTRS CUSTOMER DATA UserPassword (masked)',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_DATA_UserPassword>',
        Result   => 'Test xxx',
    },
    {
        Name     => 'OTRS CUSTOMER DATA secret (masked)',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_DATA_UserGoogleAuthenticatorSecretKey> <OTRS_CUSTOMER_DATA_UserToken>',
        Result   => 'Test xxx xxx',
    },
    {
        Name     => 'OTRS <OTRS_NOTIFICATION_RECIPIENT_UserFullname>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_NOTIFICATION_RECIPIENT_UserFullname> <OTRS_NOTIFICATION_RECIPIENT_nonexisting>',
        Result   => "Test $TestUsers[3]->{UserFullname} -",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_EscalationResponseTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_EscalationResponseTime>',
        Result   => "Test 07/05/2017 11:30",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_EscalationUpdateTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_EscalationUpdateTime>',
        Result   => "Test 07/05/2017 11:45",
    },
    {
        Name     => 'OTRS <OTRS_TICKET_EscalationSolutionTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_TICKET_EscalationSolutionTime>',
        Result   => "Test 07/05/2017 11:50",
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

my %Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);

for my $Test (@Tests) {
    my $Result = $TemplateGeneratorObject->_Replace(
        Text        => $Test->{Template},
        Data        => $Test->{Data},
        DataAgent   => $Test->{DataAgent},
        RichText    => $Test->{RichText},
        TicketData  => \%Ticket,
        UserID      => $TestUsers[2]->{UserID},
        RecipientID => $TestUsers[3]->{UserID},
        Language    => $NotificationLanguage,
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
    UserID   => $TestUsers[2]->{UserID},
);
$Self->True(
    $Success,
    "TicketID $TicketID - set state to pending reminder successfully",
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
        Result   => "Test 07/06/2017 10:00",
    }
);

%Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);

for my $Test (@Tests) {
    my $Result = $TemplateGeneratorObject->_Replace(
        Text        => $Test->{Template},
        Data        => $Test->{Data},
        DataAgent   => $Test->{DataAgent},
        RichText    => $Test->{RichText},
        TicketData  => \%Ticket,
        UserID      => $TestUsers[2]->{UserID},
        RecipientID => $TestUsers[3]->{UserID},
        Language    => $NotificationLanguage,
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - _Replace()",
    );
}

# Test for bug#14948 Appointment description tag replace with line brakes.
my %Calendar = $Kernel::OM->Get('Kernel::System::Calendar')->CalendarCreate(
    CalendarName => "My Calendar $RandomID",
    Color        => '#3A87AD',
    GroupID      => 1,
    UserID       => $UserID,
    ValidID      => 1,
);
$Self->True(
    $Calendar{CalendarID},
    "CalendarID $Calendar{CalendarID} is created.",
);

my $AppointmentID = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentCreate(
    CalendarID  => $Calendar{CalendarID},
    Title       => "Test Appointment $RandomID",
    Description => "Test
description
$RandomID",
    Location  => 'Germany',
    StartTime => '2016-09-01 00:00:00',
    EndTime   => '2016-09-01 01:00:00',
    UserID    => $UserID,
);
$Self->True(
    $AppointmentID,
    "AppointmentID $AppointmentID is created.",
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Frontend::RichText',
    Value => 1,
);

my $Result = $Kernel::OM->Get('Kernel::System::CalendarTemplateGenerator')->_Replace(
    Text          => 'Description &lt;OTRS_APPOINTMENT_DESCRIPTION&gt;',
    RichText      => 1,
    AppointmentID => $AppointmentID,
    CalendarID    => $Calendar{CalendarID},
    UserID        => $UserID,
);
$Self->Is(
    $Result,
    "Description Test<br/>
description<br/>
$RandomID",
    "Appointment description tag correctly replaced.",
);

# Cleanup is done by RestoreDatabase.

1;
